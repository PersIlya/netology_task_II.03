## <p style="text-align: center;">ОТЧЕТ</p> <p style="text-align: center;">по домашним заданиям к занятию «Управляющие конструкции в коде Terraform»</p>
## <p style="text-align: right;">Выполнил: студент ___________.</p>


## Чек-лист готовности к домашнему заданию

1. Зарегистрирован аккаунт в Yandex Cloud. Использован промокод на грант.
2. Установлен инструмент Yandex CLI.
3. Доступен исходный код для выполнения задания в директории 03/src.
4. Любые ВМ, использованные при выполнении задания, должны быть прерываемыми, для экономии средств.


![localImage](./Yes.png)

## Задание 1

1. Изучить проект.
2. Заполнить файл personal.auto.tfvars.
3. Инициализировать проект, выполните код. Он выполнится, даже если доступа к preview нет.    

Примечание. Если у вас не активирован preview-доступ к функционалу «Группы безопасности» в Yandex Cloud, запросите доступ у поддержки облачного провайдера. Обычно его выдают в течение 24-х часов.       
Приложите скриншот входящих правил «Группы безопасности» в ЛК Yandex Cloud или скриншот отказа в предоставлении доступа к preview-версии.

### <div style="text-align: center;">Решение</div>
>по пунктам 1-3
![localImage](./screen_II.01.1-3.png)            
![localImage](./Yes.png)

## Задание 2

1. Создайте файл count-vm.tf. Опишите в нём создание двух одинаковых ВМ web-1 и web-2 (не web-0 и web-1) с минимальными параметрами, используя мета-аргумент count loop. Назначьте ВМ созданную в первом задании группу безопасности.(как это сделать узнайте в документации провайдера yandex/compute_instance )
2. Создайте файл for_each-vm.tf. Опишите в нём создание двух ВМ для баз данных с именами "main" и "replica" разных по cpu/ram/disk_volume , используя мета-аргумент for_each loop. Используйте для обеих ВМ одну общую переменную типа:
``` terraform
variable "each_vm" {
  type = list(object({  vm_name=string, cpu=number, ram=number, disk_volume=number }))
}
```
3. При желании внесите в переменную все возможные параметры. 
4. ВМ из пункта 2.1 должны создаваться после создания ВМ из пункта 2.2. 
5. Используйте функцию file в local-переменной для считывания ключа ~/.ssh/id_rsa.pub и его последующего использования в блоке metadata, взятому из ДЗ 2. 
6. Инициализируйте проект, выполните код.


### <div style="text-align: center;">Решение</div>
![localImage](./screen_II.02.1.png)  
![localImage](./Yes.png)


## Задание 3

1. Создать 3 одинаковых виртуальных диска размером 1 Гб с помощью ресурса yandex_compute_disk и мета-аргумента count в файле disk_vm.tf .
2. Создать в том же файле одиночную (использовать count или for_each запрещено из-за задания №4) ВМ c именем "storage" . Используйте блок dynamic secondary_disk{..} и мета-аргумент for_each для подключения созданных вами дополнительных дисков.

### <div style="text-align: center;">Решение</div>
![localImage](./screen_II.03.1-2.png)  
![localImage](./Yes.png)

## Задание 4

1. В файле ansible.tf создать inventory-файл для ansible. Использовать функцию tepmplatefile и файл-шаблон для создания ansible inventory-файла из лекции. Готовый код возьмите из демонстрации к лекции demonstration2. Передайте в него в качестве переменных группы виртуальных машин из задания 2.1, 2.2 и 3.2, т. е. 5 ВМ.
2. Инвентарь должен содержать 3 группы и быть динамическим, т. е. обработать как группу из 2-х ВМ, так и 999 ВМ.
3. Добавить в инвентарь переменную fqdn. 

``` terraform
[webservers]
web-1 ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>
web-2 ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>

[databases]
main ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>
replica ansible_host<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>

[storage]
storage ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>

```

Пример fqdn: web1.ru-central1.internal(в случае указания переменной hostname(не путать с переменной name)); fhm8k1oojmm5lie8i22a.auto.internal(в случае отсутвия перменной hostname - автоматическая генерация имени, зона изменяется на auto). нужную вам переменную найдите в документации провайдера или terraform console. 4. Выполните код. Приложите скриншот получившегося файла.

Для общего зачёта создайте в вашем GitHub-репозитории новую ветку terraform-03. Закоммитьте в эту ветку свой финальный код проекта, пришлите ссылку на коммит.
Удалите все созданные ресурсы.

### <div style="text-align: center;">Решение</div>
![localImage](./screen_II.04.1-3.png)  
![localImage](./Yes.png)

# Ссылки на файлы:
>[ansible.tf](./ansible.tf);    
>[count-vm.tf](./count-vm.tf);    
>[disk_vm.tf](./disk_vm.tf);    
>[for_each-vm.tf](./for_each-vm.tf);    
>[hosts.cfg](./hosts.cfg);    
>[hosts.tftpl](./hosts.tftpl);      
>[locals.tf](./locals.tf);     
>[main.tf](./main.tf);     
>[outputs.tf](./outputs.tf);      
>[providers.tf](./providers.tf);      
>[security.tf](./security.tf);      
>[variables.tf](./variables.tf).     


## Задание 5*

1. Написать output, который отобразит ВМ из ваших ресурсов count и for_each в виде списка словарей :
``` terraform
[
 {
  "name" = 'имя ВМ1'
  "id"   = 'идентификатор ВМ1'
  "fqdn" = 'Внутренний FQDN ВМ1'
 },
 {
  "name" = 'имя ВМ2'
  "id"   = 'идентификатор ВМ2'
  "fqdn" = 'Внутренний FQDN ВМ2'
 },
 ....
...итд любое количество ВМ в ресурсе(те требуется итерация по ресурсам, а не хардкод) !!!!!!!!!!!!!!!!!!!!!
]
```
Приложить скриншот вывода команды terrafrom output.

![localImage](./NotMain.png)

## Задание 6*

1. Используя null_resource и local-exec, применить ansible-playbook к ВМ из ansible inventory-файла. Готовый код возьмите из демонстрации к лекции demonstration2.
2. Модифицировать файл-шаблон hosts.tftpl. Необходимо отредактировать переменную `ansible_host="<внешний IP-address или внутренний IP-address если у ВМ отсутвует внешний адрес>.`
Для проверки работы уберите у ВМ внешние адреса(nat=false). Этот вариант используется при работе через bastion-сервер. Для зачёта предоставьте код вместе с основной частью задания.

### Правила приёма работы
В своём git-репозитории создайте новую ветку terraform-03, закоммитьте в эту ветку свой финальный код проекта. Ответы на задания и необходимые скриншоты оформите в md-файле в ветке terraform-03.

В качестве результата прикрепите ссылку на ветку terraform-03 в вашем репозитории.

Важно. Удалите все созданные ресурсы.

![localImage](./NotMain.png)

## Задание 7*
Ваш код возвращает вам следущий набор данных:
``` terraform
> local.vpc
{
  "network_id" = "enp7i560tb28nageq0cc"
  "subnet_ids" = [
    "e9b0le401619ngf4h68n",
    "e2lbar6u8b2ftd7f5hia",
    "b0ca48coorjjq93u36pl",
    "fl8ner8rjsio6rcpcf0h",
  ]
  "subnet_zones" = [
    "ru-central1-a",
    "ru-central1-b",
    "ru-central1-c",
    "ru-central1-d",
  ]
}
```
Предложите выражение в terraform console, которое удалит из данной переменной 3 элемент из: subnet_ids и subnet_zones.(значения могут быть любыми) Образец конечного результата:
``` terraform
> <некое выражение>
{
  "network_id" = "enp7i560tb28nageq0cc"
  "subnet_ids" = [
    "e9b0le401619ngf4h68n",
    "e2lbar6u8b2ftd7f5hia",
    "fl8ner8rjsio6rcpcf0h",
  ]
  "subnet_zones" = [
    "ru-central1-a",
    "ru-central1-b",
    "ru-central1-d",
  ]
}
```
![localImage](./NotMain.png)

## Задание 8*
Идентифицировать и устранить намеренно допущенную в tpl-шаблоне ошибку. Обратите внимание, что terraform сам сообщит на какой строке и в какой позиции ошибка!

``` terraform
[webservers]
%{~ for i in webservers ~}
${i["name"]} ansible_host=${i["network_interface"][0]["nat_ip_address"] platform_id=${i["platform_id "]}}
%{~ endfor ~}
```

![localImage](./NotMain.png)
