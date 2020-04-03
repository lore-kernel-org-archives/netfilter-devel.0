Return-Path: <SRS0=NeGz=5T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 331AFC43331
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Apr 2020 23:56:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC4D22072B
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Apr 2020 23:56:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jv29mVBZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbgDCX4N (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Apr 2020 19:56:13 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52097 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbgDCX4N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Apr 2020 19:56:13 -0400
Received: by mail-wm1-f66.google.com with SMTP id z7so8831234wmk.1
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Apr 2020 16:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:autocrypt:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=/kE+tAnPFuyADRagz1CLpAc3HTvkE9a7UkkNj7CsqWE=;
        b=Jv29mVBZFksfnrOg5aGuYIkBagi59WiuwSItv6V2bloPyM4Y4DWBknm+eZGpv2LHw9
         ibgUyqgPeSqVh2c2GfZgljjuB8R+ivsnyIFNV7FhR6GkYKqvw8a8SMXtVXmRDRaqu80L
         1P5r4y0q/Yz6m2LVYAcFfbYJanxaGlAiZHg+gyNeHsegAoyL85XSMWaeqPoLeZq1/b4V
         blJeeQGIa9S2LVN0snhhCtfYYBNlQtx97kIsSVZm22pNga3UsDplPOOVDkpwZr4GOiah
         yhwDdXzdmxAdp4vbw7rP5o4l4p/xsbxPJh95/Wc8EL4vTaM7ZGzgIXs22McWzfrsUBV6
         FkBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:autocrypt:subject:message-id:date
         :user-agent:mime-version:content-transfer-encoding:content-language;
        bh=/kE+tAnPFuyADRagz1CLpAc3HTvkE9a7UkkNj7CsqWE=;
        b=MMri9I+lU/x2xmrAvQuWNv+16ipOTyOXXX6DEBPmJs4oio5beyWeCi7AUYgC388tDu
         wfndA2bNLyoXCNfiTrUBtvOy5JglE6C3JWcNjXnu0tvJ9JMPQU5ktd9B6HrBSKjYpA9B
         DiBM0LpT5EzUNkNSRrBtT+zndnHWgfdDyNBmyQsQCOQVrJ/Ld1sV0fSl7BnwmX9ePlpw
         twG3kgbQwi4Qw2nhbYsVb2qf66Ncjkic2e4fLEItpbisrgspoPGkf/yGRBuq6hIIqqXu
         wvtMMnzGZ3ubNSwek2L1OArzHeZsnZgeRIY+WiYY0pJuGLpT9wwAyLRmSKVFyeSmaBou
         ZOWw==
X-Gm-Message-State: AGi0PuawOU62Ojoie6frnZRNnOOTe1/VybmjwbHAO6+n6W3ONYxjfO5E
        taTmXE5xb41ryL68sHD17aPHOzC9hJeikQ==
X-Google-Smtp-Source: APiQypJGXStpp6s42HieJjxzCXNt4Lh98Tt0vG92HpZ2bTFCldOTiKO5lXPckXgWX51irNP1ta/oUg==
X-Received: by 2002:a1c:3586:: with SMTP id c128mr10913160wma.82.1585958170221;
        Fri, 03 Apr 2020 16:56:10 -0700 (PDT)
Received: from [192.168.1.125] ([91.142.18.183])
        by smtp.gmail.com with ESMTPSA id m11sm13599913wmf.9.2020.04.03.16.56.09
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Apr 2020 16:56:09 -0700 (PDT)
To:     netfilter-devel@vger.kernel.org
From:   Benjamin Doppler <benjamin.doppler@gmail.com>
Autocrypt: addr=benjamin.doppler@gmail.com; keydata=
 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
Subject: segfault while trying to load module br_netfilter
Message-ID: <1bf42879-4816-a1f7-aa4d-442e8f50fd91@gmail.com>
Date:   Sat, 4 Apr 2020 01:56:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: de-AT
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello!
I have cross-compiled a kernel (5.6.2) for ARM with the module
br_netfilter included. When I load the module using modprobe
br_netfilter on my ARM machine I get a segfault resulting in text on the
screen and in dmesg.

Output of gdb shows this:
(gdb) file br_netfilter.ko
(gdb) list *brnf_init_net+0x90
0x388 is in brnf_init_net (net/bridge/br_netfilter_hooks.c:1110).

Line 1110 of net/bridge/br_netfilter_hooks.c is:
br_netfilter_sysctl_default(brnet);

Kernel information
Kernel version (from /proc/version):
Host machine:
Linux version 5.4.0-rc5-custom (temrix@msi-pc) (gcc version 8.3.0
(Debian 8.3.0-6)) #2 SMP Tue Oct 29 22:45:09 CET 2019

ARM machine:
Linux version 5.6.2 (temrix@msi-pc) (gcc version 9.2.1 20191025 (GNU
Toolchain for the A-profile Architecture 9.2-2019.12 (arm-9.10))) #1 SMP
Fri Apr 3 21:05:22 CEST 2020

Cross-compile toolchain: gcc-arm-9.2-2019.12-x86_64-arm-none-linux-gnueab=
ihf

Kernel .config file:
see attachments

Most recent kernel version I tried which did not have the bug:
5.4.0-rc5_armhf

Output of dmesg:
=C2=A0=C2=A0=C2=A0=C2=A0 resolved (see Documentation/admin-guide/bug-hunt=
ing.rst)
[=C2=A0 538.272076] bridge: filtering via arp/ip/ip6tables is no longer
available by default. Update your scripts to load br_netfilter if you
need this.
[=C2=A0 538.289383] 8<--- cut here ---
[=C2=A0 538.292447] Unable to handle kernel NULL pointer dereference at
virtual address 00000008
[=C2=A0 538.300638] pgd =3D c483f76c
[=C2=A0 538.303357] [00000008] *pgd=3D00000000
[=C2=A0 538.307021] Internal error: Oops: 805 [#1] SMP ARM
[=C2=A0 538.311804] Modules linked in: br_netfilter(+) bridge stp llc
iptable_filter overlay uas usb_storage ip_tables x_tables
[=C2=A0 538.322595] CPU: 0 PID: 6089 Comm: modprobe Not tainted 5.6.2 #1
[=C2=A0 538.328590] Hardware name: Allwinner A83t board
[=C2=A0 538.333138] PC is at brnf_init_net+0x90/0xe4 [br_netfilter]
[=C2=A0 538.338715] LR is at ops_init+0x38/0xf0
[=C2=A0 538.342544] pc : [<bf07e388>]=C2=A0=C2=A0=C2=A0 lr : [<c06264f8>]=
=C2=A0=C2=A0=C2=A0 psr: 60010013
[=C2=A0 538.348801] sp : ea105d58=C2=A0 ip : ec056500=C2=A0 fp : 00000000=

[=C2=A0 538.354018] r10: bf082140=C2=A0 r9 : ec056ac0=C2=A0 r8 : c0b6b100=

[=C2=A0 538.359236] r7 : c0b6b100=C2=A0 r6 : 00000000=C2=A0 r5 : bf082000=
=C2=A0 r4 : 00000000
[=C2=A0 538.365753] r3 : 00000001=C2=A0 r2 : bf082000=C2=A0 r1 : bf081114=
=C2=A0 r0 : c0b6b100
[=C2=A0 538.372272] Flags: nZCv=C2=A0 IRQs on=C2=A0 FIQs on=C2=A0 Mode SV=
C_32=C2=A0 ISA ARM=C2=A0
Segment none
[=C2=A0 538.379399] Control: 10c5387d=C2=A0 Table: 6a26806a=C2=A0 DAC: 00=
000051
[=C2=A0 538.385139] Process modprobe (pid: 6089, stack limit =3D 0x9f8e54=
38)
[=C2=A0 538.391311] Stack: (0xea105d58 to 0xea106000)
[=C2=A0 538.395664]
5d40:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ec0564c0
bf08210c
[=C2=A0 538.403830] 5d60: c0b6b100 0000000a ee984000 c06264f8 bf08210c
c0b6b100 0000000a ea105d94
[=C2=A0 538.411998] 5d80: c0b6b058 ec056ac0 bf082140 c06268a0 00000000
ea105d94 ea105d94 c0b04e48
[=C2=A0 538.420165] 5da0: c0b6b040 bf08210c ffffe000 00000000 bf082188
c06269c4 c0b75e40 bf085000
[=C2=A0 538.428333] 5dc0: ffffe000 bf08500c c0b75e40 c01026d0 ee815c00
ec08db00 edc042c0 ef42b3d4
[=C2=A0 538.436500] 5de0: ee803e00 ec08db80 ef42b3d4 8040003e ec08db80
c0210a10 bf082188 c0b04e48
[=C2=A0 538.444667] 5e00: 00000001 ef42b3d4 ee803e00 ec08db00 c01a1354
bf082188 bf082140 c0b04e48
[=C2=A0 538.452835] 5e20: 00000002 bf082140 ec056880 00000002 00000002
c019f1e4 ec056a80 00000002
[=C2=A0 538.461002] 5e40: ea105f40 ec056a80 00000002 c01a135c bf08214c
00007fff bf082140 c019e400
[=C2=A0 538.469169] 5e60: bf082318 00000000 c0803038 c090733c bf08214c
bf087150 bf082254 c0907294
[=C2=A0 538.477337] 5e80: c09072ec ea105f38 004c7498 c023ec68 00000000
00000000 00000000 ffffe000
[=C2=A0 538.485503] 5ea0: 00000000 00000000 00000000 00000000 00000000
00000000 6e72656b 00006c65
[=C2=A0 538.493670] 5ec0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[=C2=A0 538.501836] 5ee0: 00000000 00000000 00000000 00000000 00000000
c0b04e48 7fffffff 00000000
[=C2=A0 538.510004] 5f00: 00000006 004b17e0 0000017b c0101204 ea104000
0000017b 004c7498 c01a199c
[=C2=A0 538.518173] 5f20: 7fffffff 00000000 00000003 000000c0 004c7498
f0bf4000 00004cbc 00000000
[=C2=A0 538.526341] 5f40: f0bf65bf f0bf6780 f0bf4000 00004cbc f0bf858c
f0bf83c0 f0bf7584 00005000
[=C2=A0 538.534507] 5f60: 00005220 000020dc 00005403 00000000 00000000
00000000 000020cc 0000002b
[=C2=A0 538.542674] 5f80: 0000002c 00000021 00000000 00000017 0000001d
c0b04e48 004b310c 00000000
[=C2=A0 538.550842] 5fa0: b0b55500 c0101000 004b310c 00000000 00000006
004b17e0 00000000 004b3318
[=C2=A0 538.559010] 5fc0: 004b310c 00000000 b0b55500 0000017b 004c74e8
00000000 00000000 004c7498
[=C2=A0 538.567176] 5fe0: be916398 be916388 004a9e41 b6ceed92 40010030
00000006 00000000 00000000
[=C2=A0 538.575373] [<bf07e388>] (brnf_init_net [br_netfilter]) from
[<c06264f8>] (ops_init+0x38/0xf0)
[=C2=A0 538.583982] [<c06264f8>] (ops_init) from [<c06268a0>]
(register_pernet_operations+0xf4/0x1f4)
[=C2=A0 538.592499] [<c06268a0>] (register_pernet_operations) from
[<c06269c4>] (register_pernet_subsys+0x24/0x38)
[=C2=A0 538.602145] [<c06269c4>] (register_pernet_subsys) from [<bf08500c=
>]
(br_netfilter_init+0xc/0x1000 [br_netfilter])
[=C2=A0 538.612403] [<bf08500c>] (br_netfilter_init [br_netfilter]) from
[<c01026d0>] (do_one_initcall+0x58/0x1c4)
[=C2=A0 538.622051] [<c01026d0>] (do_one_initcall) from [<c019f1e4>]
(do_init_module+0x5c/0x244)
[=C2=A0 538.630138] [<c019f1e4>] (do_init_module) from [<c01a135c>]
(load_module+0x1f0c/0x22ec)
[=C2=A0 538.638134] [<c01a135c>] (load_module) from [<c01a199c>]
(sys_finit_module+0xd0/0xe8)
[=C2=A0 538.645956] [<c01a199c>] (sys_finit_module) from [<c0101000>]
(ret_fast_syscall+0x0/0x54)
[=C2=A0 538.654120] Exception stack(0xea105fa8 to 0xea105ff0)
[=C2=A0 538.659166] 5fa0:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 004b310c 000=
00000 00000006
004b17e0 00000000 004b3318
[=C2=A0 538.667334] 5fc0: 004b310c 00000000 b0b55500 0000017b 004c74e8
00000000 00000000 004c7498
[=C2=A0 538.675499] 5fe0: be916398 be916388 004a9e41 b6ceed92
[=C2=A0 538.680547] Code: e58520b8 e3011114 e1a02005 e34b1f08 (e5843008)
[=C2=A0 538.686793] ---[ end trace c644a87d777f3f88 ]---

A small shell script or example program which triggers the problem
modprobe br_netfilter

Environment
output of the ver_linux script:
Host machine:
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux msi-pc 5.4.0-rc5-custom #2 SMP Tue Oct 29 22:45:09 CET 2019 x86_64
GNU/Linux

GNU Make=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 =C2=A0=C2=A0=C2=A0 4.2.1
Binutils=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 =C2=A0=C2=A0=C2=A0 2.31.1
Util-linux=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=
=A0=C2=A0 2.33.1
Mount=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 2.33.1
Bison=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 3.3.2
Flex=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 2.6.4
Linux C Library=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 2.28
Dynamic linker (ldd)=C2=A0=C2=A0=C2=A0 2.28
Procps=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 =C2=A0=C2=A0=C2=A0 3.3.15
Kbd=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 2.0.4
Console-tools=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 2.0.=
4
Sh-utils=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 =C2=A0=C2=A0=C2=A0 8.30
Udev=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 241
Modules Loaded=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 acpi_pad =
aesni_intel ahci autofs4 binfmt_misc
button coretemp crc16 crc32c_generic crc32c_intel crc32_pclmul
crct10dif_pclmul cryptd crypto_simd drm drm_kms_helper efi_pstore
efivarfs efivars evdev ext4 fan fat fuse ghash_clmulni_intel glue_helper
gspca_main gspca_sonixj hid hid_generic i2c_i801 intel_cstate
intel_powerclamp intel_rapl_common intel_rapl_msr intel_rapl_perf
intel_uncore ipmi_devintf ipmi_msghandler ip_tables irqbypass
iTCO_vendor_support iTCO_wdt jbd2 kvm kvm_intel ledtrig_audio libahci
libata libphy lp mbcache mc mei mei_me mxm_wmi nls_ascii nls_cp437
nvidia nvidia_drm nvidia_modeset nvme nvme_core overlay parport
parport_pc pcspkr ppdev r8169 realtek scsi_mod sd_mod sg snd
snd_hda_codec snd_hda_codec_generic snd_hda_codec_hdmi
snd_hda_codec_realtek snd_hda_core snd_hda_intel snd_hwdep
snd_intel_nhlt snd_pcm snd_rawmidi snd_seq_device snd_timer
snd_usb_audio snd_usbmidi_lib soundcore thermal uas usbcore usbhid
usb_storage vfat video videobuf2_common videobuf2_memops videobuf2_v4l2
videobuf2_vmalloc videodev wmi x86_pkg_temp_thermal xhci_hcd xhci_pci
x_tables

ARM machine:
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux cubietruck-plus 5.6.2 #1 SMP Fri Apr 3 21:05:22 CEST 2020 armv7l
GNU/Linux

GNU Make=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 =C2=A0=C2=A0=C2=A0 4.2.1
Binutils=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 =C2=A0=C2=A0=C2=A0 2.31.1
Util-linux=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=
=A0=C2=A0 2.33.1
Mount=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 2.33.1
Linux C Library=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 2.28
Dynamic linker (ldd)=C2=A0=C2=A0=C2=A0 2.28
Procps=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 =C2=A0=C2=A0=C2=A0 3.3.15
Sh-utils=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 =C2=A0=C2=A0=C2=A0 8.30
Udev=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 241
Modules Loaded=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 iptable_f=
ilter ip_tables overlay uas usb_storage
x_tables

Processor information (from /proc/cpuinfo):
ARM machine:
model name=C2=A0=C2=A0=C2=A0 : ARMv7 Processor rev 5 (v7l)
BogoMIPS=C2=A0=C2=A0=C2=A0 : 57.14
Features=C2=A0=C2=A0=C2=A0 : half thumb fastmult vfp edsp neon vfpv3 tls =
vfpv4 idiva
idivt vfpd32 lpae evtstrm
CPU implementer=C2=A0=C2=A0=C2=A0 : 0x41
CPU architecture: 7
CPU variant=C2=A0=C2=A0=C2=A0 : 0x0
CPU part=C2=A0=C2=A0=C2=A0 : 0xc07
CPU revision=C2=A0=C2=A0=C2=A0 : 5

Hardware=C2=A0=C2=A0=C2=A0 : Allwinner A83t board
Revision=C2=A0=C2=A0=C2=A0 : 0000
Serial=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 : 32c00001b3cbac18

Module information (from /proc/modules):
ARM machine:
br_netfilter 36864 1 - Loading 0x00000000
bridge 143360 1 br_netfilter, Live 0x00000000
stp 16384 1 bridge, Live 0x00000000
llc 16384 2 bridge,stp, Live 0x00000000
iptable_filter 16384 1 - Live 0x00000000
overlay 90112 0 - Live 0x00000000
uas 20480 0 - Live 0x00000000
usb_storage 53248 2 uas, Live 0x00000000
ip_tables 24576 1 iptable_filter, Live 0x00000000
x_tables 24576 2 iptable_filter,ip_tables, Live 0x00000000

Loaded driver and hardware information (/proc/iomem)
ARM machine:
00000000-00000000 : 1000000.clock
00000000-00000000 : sunxi-mc-smp
00000000-00000000 : 1c02000.dma-controller
00000000-00000000 : 1c0f000.mmc
00000000-00000000 : 1c10000.mmc
00000000-00000000 : 1c11000.mmc
00000000-00000000 : 1c14000.eeprom
00000000-00000000 : usb@1c19000
=C2=A0 00000000-00000000 : musb-hdrc.1.auto
00000000-00000000 : 1c19400.phy
00000000-00000000 : 1c1a000.usb
00000000-00000000 : 1c19400.phy
00000000-00000000 : 1c1b000.usb
00000000-00000000 : 1c19400.phy
00000000-00000000 : 1c20000.clock
00000000-00000000 : 1c20800.pinctrl
00000000-00000000 : 1c20ca0.watchdog
00000000-00000000 : serial
00000000-00000000 : serial
00000000-00000000 : 1c30000.ethernet
00000000-00000000 : interrupt-controller@1f00c00
00000000-00000000 : clock@1f01400
00000000-00000000 : sunxi-mc-smp
00000000-00000000 : 1f02c00.pinctrl
00000000-00000000 : 1f03400.rsb
00000000-00000000 : 1f04000.thermal-sensor
00000000-00000000 : System RAM
=C2=A0 00000000-00000000 : Kernel code
=C2=A0 00000000-00000000 : Kernel data

