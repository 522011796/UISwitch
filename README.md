# UISwitch
可部分自定义UISwitch

<img width="279" alt="image" src="https://github.com/522011796/UISwitch/assets/36726234/091d1679-2ae8-4e35-b0e0-254d584ffe5d">

<img width="273" alt="image" src="https://github.com/522011796/UISwitch/assets/36726234/d9ecccd0-1a6d-4ffe-adc0-f10a0f44f0c1">

可调节参数
```
1、开/关背景色
2、按钮块开/关背景色
3、开关的高度和宽度
4、按钮块开/关图标(可以不显示)
```

使用
```
UIColorSwitch *nkColorSwitch = [[UIColorSwitch alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
[nkColorSwitch setOnTintColor:[UIColor greenColor]];
[nkColorSwitch setTintColor:[UIColor grayColor]];
[nkColorSwitch setThumbTintColor:[UIColor whiteColor]];
[nkColorSwitch setThumbOffTintColor:[UIColor blackColor]];
[nkColorSwitch setShape:kNKColorSwitchShapeRectangle];
[nkColorSwitch setThumbOffTintImage:@"close"];
[nkColorSwitch setThumbOnTintImage:@"network_state_icon"];
[nkColorSwitch setThumbImageHeight: 20];
[nkColorSwitch setThumbImageWidth: 20];
[nkColorSwitch setOn: NO];
nkColorSwitch.center = self.view.center;
[nkColorSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
```


