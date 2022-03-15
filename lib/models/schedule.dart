class Schedule{
  int ? id ;
  String? type;
  String? type_subject;
  String? title;
  String? date;
  String? detail;

  Schedule({
    this.id,
    this.type,
    this.type_subject,
    this.title,
    this.date,
    this.detail,
  });

  factory Schedule.fromJson(Map<String ,dynamic> json){
    return Schedule(
      id: json['id'],
      type: json['type'],
      type_subject: json['type_subject'],
      title: json['title'],
      date: json['date'],
      detail: json['detail'],

    );
  }
}