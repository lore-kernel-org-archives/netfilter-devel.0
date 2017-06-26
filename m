From: Loic <hackurx@opensec.fr>
Subject: Re: [netfilter-core] Heap overflow in xt_geoip.c
Date: Mon, 26 Jun 2017 20:49:39 +0200
Message-ID: <77bf7ff91165dafb9955bbcb63544898@opensec.fr>
References: <CAFwXZv_CZanNT=MTcA7G_5YtgJ07+2Xf-poXy2dNfv+V=j4iLw@mail.gmail.com>
 <59482edb.6385df0a.e863a.a6ca.GMRIR@mx.google.com>
 <6358d530697ad564236584c07d2f3cb2@opensec.fr> <20170621161642.GB6117@salvia>
 <nycvar.YFH.7.76.1706252143110.6159@n3.vanv.qr>
 <f2aa016334df64f2e88dc7b0cb802762@opensec.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.opensec.fr ([82.236.169.210]:56548 "EHLO mail.opensec.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751335AbdFZStk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Jun 2017 14:49:40 -0400
In-Reply-To: <f2aa016334df64f2e88dc7b0cb802762@opensec.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le 2017-06-26 20:41, Loic a écrit :
> Le 2017-06-25 21:45, Jan Engelhardt a écrit :
>> On Wednesday 2017-06-21 18:16, Pablo Neira Ayuso wrote:
>> 
>>> Hi Loic,
>>> 
>>> On Tue, Jun 20, 2017 at 08:31:26PM +0200, Loic wrote:
>>>> Hi,
>>>> 
>>>> I think there is a problem in the geoip code because I detect this:
>>>> 
>>>> grep -ar "cicus.162_313 max" 
>>>> /usr/src/xtables-addons-2.12/extensions/
>>>> /usr/src/xtables-addons-2.12/extensions/xt_geoip.o:cicus.162_313 
>>>> max,
>>>> count: 7, decl: vmalloc; num: 1; context: fndecl;
>>>> /usr/src/xtables-addons-2.12/extensions/xt_geoip.o:/usr/src/xtables-addons-2.12/extensions/xt_geoip.ccicus.162_313
>>>> max, count: 5, decl: size_overflow MARK_NO copy_user_generic 3; num:
>>>> 0; context: attr;
>>>> /usr/src/xtables-addons-2.12/extensions/xt_geoip.ko:cicus.162_313 
>>>> max,
>>>> count: 7, decl: vmalloc; num: 1; context: fndecl;
>>>> /usr/src/xtables-addons-2.12/extensions/xt_geoip.ko:/usr/src/xtables-addons-2.12/extensions/xt_geoip.ccicus.162_313
>>>> max, count: 5, decl: size_overflow MARK_NO copy_user_generic 3; num:
>>>> 0; context: attr;
>>>> 
>>>> You maybe can draw inspiration for resolve this by 
>>>> "vmalloc_usercopy" in
>>>> PAX_USERCOPY from PaX/Grsecurity.
>>> 
>>> This is out of tree code, Cc'ing Jan, who maintains this.
>> 
>> What is cicus and what are these messages supposed to tell me?
> 
> This comes from the size_overflow plugin :
> https://github.com/ephox-gcc-plugins/size_overflow
> 
> After I'm not an expert I just detected this:
> grep -ai size_overflow "xt_geoip.ko"
> /usr/src/xtables-addons-2.12/extensions/xt_geoip.ccicus.162_313 max,
> count: 5, decl: # size_overflow MARK_NO copy_user_generic 3; num: 0;
> context: attr;

There is even another similar errors:
/usr/src/xtables-addons-2.12# grep -air "# size_overflow" *
extensions/ACCOUNT/xt_ACCOUNT.o:cicus.321_1094 max, count: 9, decl: # 
size_overflow MARK_NO copy_user_generic 3; num: 0; context: attr;
extensions/ACCOUNT/xt_ACCOUNT.o:cicus.326_1106 max, count: 13, decl: # 
size_overflow MARK_NO copy_user_generic 3; num: 0; context: attr;
extensions/ACCOUNT/xt_ACCOUNT.ko:cicus.321_1094 max, count: 9, decl: # 
size_overflow MARK_NO copy_user_generic 3; num: 0; context: attr;
extensions/ACCOUNT/xt_ACCOUNT.ko:cicus.326_1106 max, count: 13, decl: # 
size_overflow MARK_NO copy_user_generic 3; num: 0; context: attr;
extensions/xt_SYSRQ.o:cicus.199_241 min, count: 10, decl: # 
size_overflow MARK_NO __kmalloc 1; num: 0; context: attr;
extensions/xt_geoip.o:/usr/src/xtables-addons-2.12/extensions/xt_geoip.ccicus.162_313 
max, count: 5, decl: # size_overflow MARK_NO copy_user_generic 3; num: 
0; context: attr;
extensions/xt_SYSRQ.ko:cicus.199_241 min, count: 10, decl: # 
size_overflow MARK_NO __kmalloc 1; num: 0; context: attr;
extensions/xt_geoip.ko:/usr/src/xtables-addons-2.12/extensions/xt_geoip.ccicus.162_313 
max, count: 5, decl: # size_overflow MARK_NO copy_user_generic 3; num: 
0; context: attr;

And for your information (sorry if it is not readable):
extensions/.xt_geoip.mod.o.cmd:cmd_/usr/src/xtables-addons-2.12/extensions/xt_geoip.mod.o 
:= gcc -Wp,-MD,/usr/src/xtables-addons-2.12/extensions/.xt_geoip.mod.o.d 
  -nostdinc -isystem /usr/lib/gcc/x86_64-linux-gnu/4.8/include 
-I./arch/x86/include -I./arch/x86/include/generated/uapi 
-I./arch/x86/include/generated  -I./include -I./arch/x86/include/uapi 
-I./include/uapi -I./include/generated/uapi -include 
./include/linux/kconfig.h -D__KERNEL__ -Wall -Wundef -Wstrict-prototypes 
-Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security -std=gnu89 
-fno-PIE -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx -m64 
-falign-jumps=1 -falign-loops=1 -mno-80387 -mno-fp-ret-in-387 
-mpreferred-stack-boundary=3 -O3 -march=x86-64 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-ffreestanding -DCONFIG_X86_X32_ABI -DCONFIG_AS_CFI=1 
-DCONFIG_AS_CFI_SIGNAL_FRAME=1 -DCONFIG_AS_CFI_SECTIONS=1 
-DCONFIG_AS_FXSAVEQ=1 -DCONFIG_AS_SSSE3=1 -DCONFIG_AS_CRC32=1 
-DCONFIG_AS_AVX=1 -DCONFIG_AS_AVX2=1 -DCONFIG_AS_SHA1_NI=1 
-DCONFIG_AS_SHA256_NI=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -fno-delete-null-pointer-checks -O2 
-Wno-maybe-uninitialized --param=allow-store-data-races=0 
-Wframe-larger-than=2048 -fstack-protector -Wno-unused-but-set-variable 
-fomit-frame-pointer -fno-var-tracking-assignments 
-Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow 
-fconserve-stack -Werror=implicit-int -Werror=strict-prototypes 
-DCC_HAVE_ASM_GOTO  
-fplugin=./scripts/gcc-plugins/latent_entropy_plugin.so 
-fplugin=./scripts/gcc-plugins/constify_plugin.so 
-fplugin=./scripts/gcc-plugins/stackleak_plugin.so 
-fplugin=./scripts/gcc-plugins/kernexec_plugin.so 
-fplugin=./scripts/gcc-plugins/colorize_plugin.so 
-fplugin=./scripts/gcc-plugins/size_overflow_plugin/size_overflow_plugin.so 
-fplugin=./scripts/gcc-plugins/randomize_layout_plugin.so 
-fplugin=./scripts/gcc-plugins/structleak_plugin.so 
-fplugin=./scripts/gcc-plugins/initify_plugin.so 
-fplugin=./scripts/gcc-plugins/rap_plugin/rap_plugin.so 
-DLATENT_ENTROPY_PLUGIN -DCONSTIFY_PLUGIN -DSTACKLEAK_PLUGIN 
-fplugin-arg-stackleak_plugin-track-lowest-sp=100 -DKERNEXEC_PLUGIN 
-fplugin-arg-kernexec_plugin-method=bts -DSIZE_OVERFLOW_PLUGIN 
-fplugin-arg-size_overflow_plugin-check-fns 
-fplugin-arg-size_overflow_plugin-check-fields 
-fplugin-arg-size_overflow_plugin-check-fptrs 
-fplugin-arg-size_overflow_plugin-check-vars -DRANDSTRUCT_PLUGIN 
-DSTRUCTLEAK_PLUGIN -DINITIFY_PLUGIN 
-fplugin-arg-initify_plugin-search_init_exit_functions 
-fplugin-arg-initify_plugin-verbose 
-fplugin-arg-initify_plugin-print_missing_attr -DRAP_PLUGIN 
-fplugin-arg-rap_plugin-typecheck=call,ret 
-fplugin-arg-rap_plugin-hash=abs-finish 
-fplugin-arg-rap_plugin-hash=abs-ops 
-fplugin-arg-rap_plugin-hash=abs-attr -DX86_RAP_CALL_VECTOR=0x82 
-DX86_RAP_RET_VECTOR=0x83 '-fplugin-arg-rap_plugin-callabort=int $$0x82' 
'-fplugin-arg-rap_plugin-retabort=int $$0x83'   
-DKBUILD_BASENAME='"xt_geoip.mod"'  -DKBUILD_MODNAME='"xt_geoip"' 
-DMODULE  -c -o /usr/src/xtables-addons-2.12/extensions/xt_geoip.mod.o 
/usr/src/xtables-addons-2.12/extensions/xt_geoip.mod.c


-- 
Best regards,

Loic
