Return-Path: <SRS0=u4e5=WH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47B07C433FF
	for <netfilter-devel@archiver.kernel.org>; Sun, 11 Aug 2019 09:48:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1236C208C2
	for <netfilter-devel@archiver.kernel.org>; Sun, 11 Aug 2019 09:48:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbfHKJsm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 11 Aug 2019 05:48:42 -0400
Received: from fajn.hanzlici.cz ([46.13.76.95]:50422 "EHLO mail.hanzlici.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725855AbfHKJsm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 11 Aug 2019 05:48:42 -0400
X-Greylist: delayed 499 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Aug 2019 05:48:41 EDT
Received: from franta.hanzlici.cz (franta.hanzlici.cz [192.168.1.22])
        (Authenticated sender: franta)
        by mail.hanzlici.cz (Postfix) with ESMTPSA id 5403E1904F9
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Aug 2019 11:40:21 +0200 (CEST)
Date:   Sun, 11 Aug 2019 11:40:20 +0200
From:   Franta =?UTF-8?B?SGFuemzDrWs=?= <franta@hanzlici.cz>
To:     netfilter-devel@vger.kernel.org
Subject: xtables addons build on 5.2.6 ends with error: 'struct shash_desc'
 has no member named 'flags'
Message-ID: <20190811113826.5e594d8f@franta.hanzlici.cz>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; i686-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I'm using xtables-addons-3.3 on Fedora 30 from freshrpms, which is builded
via akmods. On kernel 5.1.20-300.fc30 it build fine, but on 5.2.6-200.fc30
it ends with error:
...
2019/08/11 10:11:28 akmodsbuild: gcc -Wp,-MD,/tmp/akmodsbuild.weDM0uSv/BUILD/xtables-addons-kmod-3.3/_kmod_build_5.2.6-200.fc30.x86_64/extensions/.xt_SYSRQ.o.d  -nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/9/include -I./arch/x86/include -I./arch/x86/include/generated  -I./include -I./arch/x86/include/uapi -I./arch/x86/include/generated/uapi -I./include/uapi -I./include/generated/uapi -include ./include/linux/kconfig.h -include ./include/linux/compiler_types.h
 -D__KERNEL__ -Wall -Wundef -Werror=strict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -fshort-wchar -fno-PIE -Werror=implicit-function-declaration -Werror=implicit-int -Wno-format-security -Wno-address-of-packed-member -std=gnu89 -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx -m64
 -falign-jumps=1 -falign-loops=1 -mno-80387 -mno-fp-ret-in-387 -mpreferred-stack-boundary=3 -mskip-rax-setup -mtune=generic -mno-red-zone -mcmodel=kernel
 -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 -DCONFIG_AS_CFI_SECTIONS=1 -DCONFIG_AS_SSSE3=1 -DCONFIG_AS_AVX=1 -DCONFIG_AS_AVX2=1 -DCONFIG_AS_AVX512=1 -DCONFIG_AS_SHA1_NI=1 -DCONFIG_AS_SHA256_NI=1 -Wno-sign-compare -fno-asynchronous-unwind-tables -mindirect-branch=thunk-extern -mindirect-branch-register
 -fno-jump-tables -fno-delete-null-pointer-checks -Wno-frame-address -Wno-format-truncation -Wno-format-overflow -Wno-address-of-packed-member -O2 --param=allow-store-data-races=0 -Wframe-larger-than=2048 -fstack-protector-strong -Wno-unused-but-set-variable -Wno-unused-const-variable -fvar-tracking-assignments -g -pg -mrecord-mcount -mfentry -DCC_USING_FENTRY -Wdeclaration-after-statement -Wvla -Wno-pointer-sign -Wno-stringop-truncation -fno-strict-overflow -fno-merge-all-constants -fmerge-constants -fno-stack-check -fconserve-stack -Werror=date-time -Werror=incompatible-pointer-types
 -Werror=designated-init -fmacro-prefix-map=./= -Wno-packed-not-aligned  -DMODULE  -DKBUILD_BASENAME='"xt_SYSRQ"' -DKBUILD_MODNAME='"xt_SYSRQ"' -c -o /tmp/akmodsbuild.weDM0uSv/BUILD/xtables-addons-kmod-3.3/_kmod_build_5.2.6-200.fc30.x86_64/extensions/xt_SYSRQ.o /tmp/akmodsbuild.weDM0uSv/BUILD/xtables-addons-kmod-3.3/_kmod_build_5.2.6-200.fc30.x86_64/extensions/xt_SYSRQ.c

2019/08/11 10:11:28 akmodsbuild: gcc -Wp,-MD,/tmp/akmodsbuild.weDM0uSv/BUILD/xtables-addons-kmod-3.3/_kmod_build_5.2.6-200.fc30.x86_64/extensions/.xt_TARPIT.o.d  -nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/9/include -I./arch/x86/include -I./arch/x86/include/generated  -I./include -I./arch/x86/include/uapi -I./arch/x86/include/generated/uapi -I./include/uapi -I./include/generated/uapi -include ./include/linux/kconfig.h -include ./include/linux/compiler_types.h -D__KERNEL__ -Wall -Wundef -Werror=strict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -fshort-wchar -fno-PIE
 -Werror=implicit-function-declaration -Werror=implicit-int -Wno-format-security -Wno-address-of-packed-member -std=gnu89 -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx -m64 -falign-jumps=1 -falign-loops=1 -mno-80387 -mno-fp-ret-in-387 -mpreferred-stack-boundary=3 -mskip-rax-setup -mtune=generic -mno-red-zone
 -mcmodel=kernel -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 -DCONFIG_AS_CFI_SECTIONS=1 -DCONFIG_AS_SSSE3=1 -DCONFIG_AS_AVX=1 -DCONFIG_AS_AVX2=1
 -DCONFIG_AS_AVX512=1 -DCONFIG_AS_SHA1_NI=1 -DCONFIG_AS_SHA256_NI=1 -Wno-sign-compare -fno-asynchronous-unwind-tables -mindirect-branch=thunk-extern -mindirect-branch-register -fno-jump-tables -fno-delete-null-pointer-checks -Wno-frame-address -Wno-format-truncation -Wno-format-overflow -Wno-address-of-packed-member -O2 --param=allow-store-data-races=0 -Wframe-larger-than=2048 -fstack-protector-strong -Wno-unused-but-set-variable -Wno-unused-const-variable -fvar-tracking-assignments -g -pg -mrecord-mcount -mfentry -DCC_USING_FENTRY -Wdeclaration-after-statement -Wvla -Wno-pointer-sign -Wno-stringop-truncation
 -fno-strict-overflow -fno-merge-all-constants -fmerge-constants -fno-stack-check -fconserve-stack -Werror=date-time -Werror=incompatible-pointer-types -Werror=designated-init -fmacro-prefix-map=./= -Wno-packed-not-aligned  -DMODULE  -DKBUILD_BASENAME='"xt_TARPIT"' -DKBUILD_MODNAME='"xt_TARPIT"' -c -o /tmp/akmodsbuild.weDM0uSv/BUILD/xtables-addons-kmod-3.3/_kmod_build_5.2.6-200.fc30.x86_64/extensions/xt_TARPIT.o /tmp/akmodsbuild.weDM0uSv/BUILD/xtables-addons-kmod-3.3/_kmod_build_5.2.6-200.fc30.x86_64/extensions/xt_TARPIT.c

2019/08/11 10:11:28 akmodsbuild: /tmp/akmodsbuild.weDM0uSv/BUILD/xtables-addons-kmod-3.3/_kmod_build_5.2.6-200.fc30.x86_64/extensions/pknock/xt_pknock.c: In function 'xt_pknock_mt_init':
2019/08/11 10:11:28 akmodsbuild: /tmp/akmodsbuild.weDM0uSv/BUILD/xtables-addons-kmod-3.3/_kmod_build_5.2.6-200.fc30.x86_64/extensions/pknock/xt_pknock.c:1128:13: error: 'struct shash_desc' has no member named 'flags'
2019/08/11 10:11:28 akmodsbuild: 1128 |  crypto.desc.flags = 0;
2019/08/11 10:11:28 akmodsbuild: |             ^
2019/08/11 10:11:28 akmodsbuild: /tmp/akmodsbuild.weDM0uSv/BUILD/xtables-addons-kmod-3.3/_kmod_build_5.2.6-200.fc30.x86_64/extensions/xt_SYSRQ.c: In function 'sysrq_tg':
2019/08/11 10:11:28 akmodsbuild: /tmp/akmodsbuild.weDM0uSv/BUILD/xtables-addons-kmod-3.3/_kmod_build_5.2.6-200.fc30.x86_64/extensions/xt_SYSRQ.c:117:6: error: 'struct shash_desc' has no member named 'flags'
2019/08/11 10:11:28 akmodsbuild: 117 |  desc.flags = 0;
2019/08/11 10:11:28 akmodsbuild: |      ^
2019/08/11 10:11:28 akmodsbuild: make[2]: *** [scripts/Makefile.build:285: /tmp/akmodsbuild.weDM0uSv/BUILD/xtables-addons-kmod-3.3/_kmod_build_5.2.6-200.fc30.x86_64/extensions/pknock/xt_pknock.o] Error 1
2019/08/11 10:11:28 akmodsbuild: make[1]: *** [scripts/Makefile.build:285: /tmp/akmodsbuild.weDM0uSv/BUILD/xtables-addons-kmod-3.3/_kmod_build_5.2.6-200.fc30.x86_64/extensions/xt_SYSRQ.o] Error 1
2019/08/11 10:11:28 akmodsbuild: make[1]: *** Waiting for unfinished jobs....
2019/08/11 10:11:28 akmodsbuild: make[1]: *** [scripts/Makefile.build:489: /tmp/akmodsbuild.weDM0uSv/BUILD/xtables-addons-kmod-3.3/_kmod_build_5.2.6-200.fc30.x86_64/extensions/pknock] Error 2
2019/08/11 10:11:28 akmodsbuild: ./tools/objtool/objtool orc generate  --module --no-fp --retpoline --uaccess /tmp/akmodsbuild.weDM0uSv/BUILD/xtables-addons-kmod-3.3/_kmod_build_5.2.6-200.fc30.x86_64/extensions/compat_xtables.o
2019/08/11 10:11:28 akmodsbuild: ./tools/objtool/objtool orc generate  --module --no-fp --retpoline --uaccess /tmp/akmodsbuild.weDM0uSv/BUILD/xtables-addons-kmod-3.3/_kmod_build_5.2.6-200.fc30.x86_64/extensions/xt_LOGMARK.o
2019/08/11 10:11:28 akmodsbuild: ./tools/objtool/objtool orc generate  --module --no-fp --retpoline --uaccess /tmp/akmodsbuild.weDM0uSv/BUILD/xtables-addons-kmod-3.3/_kmod_build_5.2.6-200.fc30.x86_64/extensions/xt_IPMARK.o
2019/08/11 10:11:28 akmodsbuild: ./tools/objtool/objtool orc generate  --module --no-fp --retpoline --uaccess /tmp/akmodsbuild.weDM0uSv/BUILD/xtables-addons-kmod-3.3/_kmod_build_5.2.6-200.fc30.x86_64/extensions/xt_CHAOS.o
2019/08/11 10:11:28 akmodsbuild: ./tools/objtool/objtool orc generate  --module --no-fp --retpoline --uaccess /tmp/akmodsbuild.weDM0uSv/BUILD/xtables-addons-kmod-3.3/_kmod_build_5.2.6-200.fc30.x86_64/extensions/xt_DHCPMAC.o
2019/08/11 10:11:28 akmodsbuild: ./tools/objtool/objtool orc generate  --module --no-fp --retpoline --uaccess /tmp/akmodsbuild.weDM0uSv/BUILD/xtables-addons-kmod-3.3/_kmod_build_5.2.6-200.fc30.x86_64/extensions/xt_DELUDE.o
2019/08/11 10:11:28 akmodsbuild: ./tools/objtool/objtool orc generate  --module --no-fp --retpoline --uaccess /tmp/akmodsbuild.weDM0uSv/BUILD/xtables-addons-kmod-3.3/_kmod_build_5.2.6-200.fc30.x86_64/extensions/xt_ECHO.o
2019/08/11 10:11:28 akmodsbuild: ./tools/objtool/objtool orc generate  --module --no-fp --retpoline --uaccess /tmp/akmodsbuild.weDM0uSv/BUILD/xtables-addons-kmod-3.3/_kmod_build_5.2.6-200.fc30.x86_64/extensions/xt_TARPIT.o
2019/08/11 10:11:28 akmodsbuild: ./tools/objtool/objtool orc generate  --module --no-fp --retpoline --uaccess /tmp/akmodsbuild.weDM0uSv/BUILD/xtables-addons-kmod-3.3/_kmod_build_5.2.6-200.fc30.x86_64/extensions/xt_DNETMAP.o
2019/08/11 10:11:28 akmodsbuild: ./tools/objtool/objtool orc generate  --module --no-fp --retpoline --uaccess /tmp/akmodsbuild.weDM0uSv/BUILD/xtables-addons-kmod-3.3/_kmod_build_5.2.6-200.fc30.x86_64/extensions/ACCOUNT/xt_ACCOUNT.o
2019/08/11 10:11:28 akmodsbuild: make: *** [Makefile:1600: _module_/tmp/akmodsbuild.weDM0uSv/BUILD/xtables-addons-kmod-3.3/_kmod_build_5.2.6-200.fc30.x86_64/extensions] Error 2
2019/08/11 10:11:28 akmodsbuild: make: Leaving directory '/usr/src/kernels/5.2.6-200.fc30.x86_64'
2019/08/11 10:11:28 akmodsbuild: error: Bad exit status from /var/tmp/rpm-tmp.oP2hls (%build)
...

I report it as issue against Fedora 30 kernel-5.2.6, but it was rejected
with
"That error is from the add on itself. Fedora does not provide support for 3rd party modules."

Know anyone, where problem may be?
-- 
TIA, Franta Hanzlik
