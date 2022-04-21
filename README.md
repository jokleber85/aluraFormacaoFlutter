Alura

Formação Flutter</br>

Flutter: Push Notifications com Firebase Cloud Messaging (10 horas)
## <br />

[Projeto Original API](https://github.com/alura-cursos/dev-meetups-api)
[Projeto Original APP](https://github.com/alura-cursos/flutter-notifications/tree/main)
[Projeto Original WEB](https://github.com/alura-cursos/flutter-notifications/tree/aula_4)


Iniciar API:
```
java -jar server.jar
localhost:8080
```

Permitir acesso http por flutter (padrão é https):
- android > app > src > debug > AndroidManifest.xml
``` 
    <application android:usesCleartextTraffic="true">

    </application>
```

Localização do nome do pacote do android:
- android > app > src > debug > AndroidManifest.xml
- br.com.alura.meetups (exemplo)

Adicionar chave notificação ao servidor:
- Firebase > Configurações de Projeto > Contas de Serviço > Gerar nova chave primaria
- Salvar em API > firebase
