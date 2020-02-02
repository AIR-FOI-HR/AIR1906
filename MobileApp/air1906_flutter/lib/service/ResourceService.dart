import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:air1906_flutter/models/MyContainer.dart';
import 'package:flutter/painting.dart';

import 'package:flutter/material.dart';

import '../models/ResourceInstance.dart';

import '../models/Category.dart';
import '../models/ResourceType.dart';

import '../models/Resource.dart';
import '../models/APIResponse.dart';
import 'package:http/http.dart' as http;
import '../models/User.dart';
import '../helpers/Auth.dart';
import 'package:image/image.dart' as Img;

class ResourceService {
  // Future<Uint8List> removeWhiteBackground(Uint8List bytes) async {
  //   Img.Image image = Img.decodeImage(bytes);
  //   Img.Image transparentImage = await colorTransparent(image, 255, 255, 255);
  //   var newPng = Img.encodePng(transparentImage);
  //   return newPng;
  // }
  // Future<Img.Image> colorTransparent(Img.Image src, int red, int green, int blue) async {
  // var pixels = src.getBytes();
  // print(pixels);
  // for (int i = 0, len = pixels.length; i < len; i += 4) {
  //   if(pixels[i] == red
  //       && pixels[i+1] == green
  //       && pixels[i+2] == blue
  //   ) {
  //     print("bojanje");
  //     pixels[i + 3] = 0;
  //   }
  // }

  // return src;
  // }

  // Future<APIResponse<Uint8List>> processImage(String url) async {
  //   var response = await http.get(url,headers: {'Content-Type': 'image/jpg'});
  //   var bytes = response.bodyBytes;
  //   var image = await removeWhiteBackground(bytes);
  //   return APIResponse<Uint8List>(image);
  // }
  Future<APIResponse<List<MyContainer>>> getResourceLocations(
      String resourceId) async {
    List<MyContainer> listContainers = [];

    var url = "https://air-api.azurewebsites.net/Pozicija/$resourceId";
    var response = await http.get(url);
    var containerApi = jsonDecode(response.body);
    for (var item in containerApi) {
      listContainers.add(MyContainer(item["polica"]));
      listContainers.add(MyContainer(item["ormar"]));
    }
    return APIResponse<List<MyContainer>>(listContainers.reversed.toList());
  }

  Future<APIResponse<List<Resource>>> getAllResourceFromDatabase() async {
    List<Resource> listResource = [];
    var url = "https://air-api.azurewebsites.net/SviResursi";
    var response = await http.get(url);
    var resourceApi = jsonDecode(response.body);
    for (var item in resourceApi) {
      listResource.add(Resource(
        item["id_resurs"],
        item["nazivr"],
        int.parse(item["kolicina"]),
        item["slika"],
        Duration(days: int.parse(item["max_posudba"])),
        ResourceType(
          item["fk_tip_resursa"],
        ),
        int.parse(item["zauzeto"]),
        item["nazivtr"],
      ));
    }
    return APIResponse<List<Resource>>(listResource);
  }

  Future<APIResponse<List<Resource>>> getResourceListByCategory(
      Category category) async {
    List<Resource> listResource = [];
    var url = "https://air-api.azurewebsites.net/TraziPoVrsti/${category.id}";
    var response = await http.get(url);
    var resourceApi = jsonDecode(response.body);
    for (var item in resourceApi) {
      listResource.add(
        Resource(
          item["id_resurs"],
          item["nazivr"],
          int.parse(item["kolicina"]),
          item["slika"],
          Duration(days: int.parse(item["max_posudba"])),
          ResourceType(item["fk_tip_resursa"]),
        ),
      );
    }
    return APIResponse<List<Resource>>(listResource);
  }

  Future<APIResponse<bool>> borrowResource(String resourceId,
      [String kolicina]) async {
    var body = {
      "idkor": Auth.currentUser.id,
      "idins": resourceId,
    };
    if (kolicina != null) {
      body = {
        "idkor": Auth.currentUser.id,
        "idins": resourceId,
        "kolins": kolicina,
      };
    }
    var url = "https://air-api.azurewebsites.net/Posudi";
    try {
      var response = await http.post(url, body: body);
      if (response.statusCode == 200) {
        return APIResponse<bool>(true);
      }
      return APIResponse<bool>(false);
    } catch (e) {
      return APIResponse<bool>(false);
    }
  }

  Future<APIResponse<bool>> returnResource(String resourceId,
      [int kolicina]) async {
    var url = "https://air-api.azurewebsites.net/Vrati";

    print("user -- resid");
    print(Auth.currentUser.id);
    print(resourceId);
    try {
      var response = await http
          .post(url, body: {"idkor": Auth.currentUser.id, "idins": resourceId});
      print(response.statusCode);
      if (response.statusCode == 200) {
        return APIResponse<bool>(true);
      }
      return APIResponse<bool>(false);
    } catch (e) {
      return APIResponse<bool>(false);
    }
  }

  Future<APIResponse<ResourceInstance>> getInstanceById(String id) async {
    var url = "https://air-api.azurewebsites.net/InstancaId/$id";
    ResourceInstance instance;
    try {
      final response = await http.get(url);
      final result = jsonDecode(response.body)[0];
      print(result);
      instance = ResourceInstance(
          result["id_instanca"],
          int.parse(result["kolicina"]),
          Resource(
            result["fk_resurs"][0]["id_resurs"],
            result["fk_resurs"][0]["nazivr"],
            int.parse(result["fk_resurs"][0]["kolicina"]),
            result["fk_resurs"][0]["slika"],
            Duration(days: int.parse(result["fk_resurs"][0]["max_posudba"])),
            ResourceType(result["fk_resurs"][0]["fk_tip_resursa"]),
          ));
    } catch (e) {
      print(e);
    }
    // ResourceInstance test = ResourceInstance(
    //   "test",
    //   10,
    //   Resource(
    //     "testR",
    //     "nazivR",
    //     14,
    //     "http://xd.com",
    //     Duration(days: 5),
    //     ResourceType("2"),
    //   ),
    // );
    print(instance);
    return APIResponse<ResourceInstance>(instance);
  }

  Future<APIResponse<List<ResourceInstance>>> getResourceListByUser(
      User user) async {
    List<ResourceInstance> listResource = [];
    print("pozivam resurse");
    var url = "https://air-api.azurewebsites.net/MojePosudbe2/${user.id}";
    var response = await http.get(url);
    var resourceApi = jsonDecode(response.body);
    print(response.body);
    //print(resourceApi[0][0]);
    for (var item in resourceApi) {
      listResource.add(ResourceInstance(
        item["fk_instanca"][0]["id_instanca"],
        int.parse(item["kolicina"]),
        Resource(
            item["resurs"][0]["id_resurs"],
            item["resurs"][0]["nazivr"],
            int.parse(item["resurs"][0]["kolicina"]),
            item["resurs"][0]["slika"],
            Duration(days: int.parse(item["resurs"][0]["max_posudba"])),
            ResourceType(item["resurs"][0]["fk_tip_resursa"])),
        DateTime.parse(item["datum"]),
      ));
    }
    return APIResponse<List<ResourceInstance>>(listResource);
  }

  Future<APIResponse<bool>> insertCommentByUser(
      User user, String comment, ResourceInstance instance) async {
    var response = await http.get(
      "https://air-api.azurewebsites.net/DodajLog/${Auth.currentUser.id}/${instance.id}/6/$comment",
    );
    print(instance.id);
    print(response.statusCode);
    if (response.body.isNotEmpty) return APIResponse<bool>(true);
    return APIResponse<bool>(true);
  }

  Future<APIResponse<bool>> updateInstanceNFCStatus(String idInstance) async {
    var response = await http
        .get("https://air-api.azurewebsites.net/NfcSpreman/$idInstance");
    print(response.body);
    if (response.body == "0") {
      return APIResponse<bool>(false);
    }
    return APIResponse<bool>(true);
  }

  Future<APIResponse<List<ResourceInstance>>> getInstancesWithoutTags() async {
    List<ResourceInstance> listResource = [];
    print("pozivam resurse");

    var url = "https://air-api.azurewebsites.net/NfcPriprava";
    var response = await http.get(url);
    var resourceApi = jsonDecode(response.body);
    //print(response.body);
    //print(resourceApi[0][0]);
    for (var item in resourceApi) {
      listResource.add(
        ResourceInstance(
          item["id_instanca"],
          int.parse(item["kolicina"]),
          Resource(
            item["fk_resurs"][0]["id_resurs"],
            item["fk_resurs"][0]["nazivr"],
            int.parse(
              item["fk_resurs"][0]["kolicina"],
            ),
            item["fk_resurs"][0]["slika"],
            Duration(
              days: int.parse(
                item["fk_resurs"][0]["max_posudba"],
              ),
            ),
            ResourceType(
              item["fk_resurs"][0]["fk_tip_resursa"],
            ),
          ),
        ),
      );
    }
    return APIResponse<List<ResourceInstance>>(listResource);
  }
}
