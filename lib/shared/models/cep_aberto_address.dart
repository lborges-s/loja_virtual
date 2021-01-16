class CepAbertoAddress {
  Cidade cidade;
  Estado estado;
  double altitude;
  double longitude;
  String bairro;
  String complemento;
  String cep;
  String logradouro;
  double latitude;

  CepAbertoAddress(
      {this.cidade,
      this.estado,
      this.altitude,
      this.longitude,
      this.bairro,
      this.complemento,
      this.cep,
      this.logradouro,
      this.latitude});

  CepAbertoAddress.fromMap(Map<String, dynamic> json) {
    cidade = json['cidade'] != null
        ? Cidade.fromMap(json['cidade'] as Map<String, dynamic>)
        : null;
    estado = json['estado'] != null
        ? Estado.fromMap(json['estado'] as Map<String, dynamic>)
        : null;
    altitude = json['altitude'] as double;
    latitude = double.tryParse(json['latitude'] as String);
    longitude = double.tryParse(json['longitude'] as String);
    bairro = json['bairro'] as String;
    complemento = json['complemento'] as String;
    cep = json['cep'] as String;
    logradouro = json['logradouro'] as String;
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{};
    if (cidade != null) {
      data['cidade'] = cidade.toMap();
    }
    if (estado != null) {
      data['estado'] = estado.toMap();
    }
    data['altitude'] = altitude;
    data['longitude'] = longitude;
    data['bairro'] = bairro;
    data['complemento'] = complemento;
    data['cep'] = cep;
    data['logradouro'] = logradouro;
    data['latitude'] = latitude;
    return data;
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

class Cidade {
  String ibge;
  String nome;
  int ddd;

  Cidade({this.ibge, this.nome, this.ddd});

  Cidade.fromMap(Map<String, dynamic> json) {
    ibge = json['ibge'] as String;
    nome = json['nome'] as String;
    ddd = json['ddd'] as int;
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{};
    data['ibge'] = ibge;
    data['nome'] = nome;
    data['ddd'] = ddd;
    return data;
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

class Estado {
  String sigla;

  Estado({this.sigla});

  Estado.fromMap(Map<String, dynamic> json) {
    sigla = json['sigla'] as String;
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{};
    data['sigla'] = sigla;
    return data;
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
