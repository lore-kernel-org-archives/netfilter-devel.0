Return-Path: <SRS0=D3nJ=YM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A214ACA9EAB
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Oct 2019 23:57:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F72F20872
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Oct 2019 23:57:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=oceanconsulting.com header.i=@oceanconsulting.com header.b="hTR4+Fba"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbfJSX5z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Oct 2019 19:57:55 -0400
Received: from smtp.oceanconsulting.com ([50.126.95.117]:38377 "EHLO
        atlantis.oceanconsulting.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726148AbfJSX5z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Oct 2019 19:57:55 -0400
X-Greylist: delayed 844 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Oct 2019 19:57:55 EDT
Received: from felix.pacific.oceanconsulting.com (static-50-126-95-120.frr01.wivl.or.frontiernet.net [50.126.95.120])
        (authenticated bits=0)
        by atlantis.oceanconsulting.com (8.15.2/8.15.2) with ESMTPSA id x9JNhosX000403
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO)
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Oct 2019 16:43:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=oceanconsulting.com;
        s=default; t=1571528630;
        bh=FqO65TPKmrHtpgUc9xyghbQxpBl4CmlzKBfHfSd/Yn8=;
        h=To:From:Subject:Message-ID:Date:MIME-Version:Content-Type:
         Content-Transfer-Encoding;
        b=hTR4+FbacquGZ6p/ezp9GwWfI8i64k5k4XwBxsaMY2fg8qpp3vBoYF5V7uO3QxS4l
         Abn3IGbW5SLqmiEXCR0pxKdwAFqdenCacctqBWHu8L2pe8hUFr6QOQzsxK/lSjz3U0
         QDBnmFfQfY9uQU/UuAvUUp5CwnwO/adcEn3QXYfEPJpM3mV3/dzI0VbKDbQCjHV8F7
         wfpM599Qi3bJgSOge4yY8OZybww1RG5WWkbzpra632ZzeaOk01ixL28ytP6I3fe/JG
         NWwlh+fOlqjqvvSOEQ0x2v2xvkAjUG9jmnX2NHl1xD1R43t2+zpSA8jpm5vmKFyuUY
         DyFaiR0/kAmxQ==
To:     netfilter-devel@vger.kernel.org
From:   Matt Olson <lkml@oceanconsulting.com>
Subject: xtables-addons akmods Builds Failing on Linux Kernel 5.3.6 - Log
 Sample - xt_DHCPMAC.c
Organization: Ocean Consulting, LLC
Message-ID: <52b77b21-1d56-cc2d-7d65-35705ff86a2b@oceanconsulting.com>
Date:   Sat, 19 Oct 2019 16:43:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

While troubleshooting why the xtables-addon module would not build, I 
ran across a specific build error that I thought may be useful for the 
maintainer.  The error appears to be

# akmods --kernels 5.3.6-200.fc30.x86_64

Log from 
/var/cache/akmods/xtables-addons/3.3-3-for-5.3.6-200.fc30.x86_64.failed.log:

2019/10/19 16:08:43 akmodsbuild: gcc 
-Wp,-MD,/tmp/akmodsbuild.A7wQddef/BUILD/xtables-addons-kmod-3.3/_kmod_build_5.3.6-200.fc30.x86_64/extensions/.xt_DHCPMAC.o.d 
-nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/9/include 
-I./arch/x86/include -I./arch/x86/include/generated  -I./include 
-I./arch/x86/include/uapi -I./arch/x86/include/generated/uapi 
-I./include/uapi -I./include/generated/uapi -include 
./include/linux/kconfig.h -include ./include/linux/compiler_types.h 
-D__KERNEL__ -Wall -Wundef -Werror=strict-prototypes -Wno-trigraphs 
-fno-strict-aliasing -fno-common -fshort-wchar -fno-PIE 
-Werror=implicit-function-declaration -Werror=implicit-int 
-Wno-format-security -Wno-address-of-packed-member -std=gnu89 -mno-sse 
-mno-mmx -mno-sse2 -mno-3dnow -mno-avx -m64 -falign-jumps=1 
-falign-loops=1 -mno-80387 -mno-fp-ret-in-387 
-mpreferred-stack-boundary=3 -mskip-rax-setup -mtune=generic 
-mno-red-zone -mcmodel=kernel -DCONFIG_AS_CFI=1 
-DCONFIG_AS_CFI_SIGNAL_FRAME=1 -DCONFIG_AS_CFI_SECTIONS=1 
-DCONFIG_AS_SSSE3=1 -DCONFIG_AS_AVX=1 -DCONFIG_AS_AVX2=1 
-DCONFIG_AS_AVX512=1 -DCONFIG_AS_SHA1_NI=1 -DCONFIG_AS_SHA256_NI=1 
-Wno-sign-compare -fno-asynchronous-unwind-tables 
-mindirect-branch=thunk-extern -mindirect-branch-register 
-fno-jump-tables -fno-delete-null-pointer-checks -Wno-frame-address 
-Wno-format-truncation -Wno-format-overflow 
-Wno-address-of-packed-member -O2 --param=allow-store-data-races=0 
-Wframe-larger-than=2048 -fstack-protector-strong 
-Wno-unused-but-set-variable -Wimplicit-fallthrough 
-Wno-unused-const-variable -fvar-tracking-assignments -g -pg 
-mrecord-mcount -mfentry -DCC_USING_FENTRY -Wdeclaration-after-statement 
-Wvla -Wno-pointer-sign -Wno-stringop-truncation -fno-strict-overflow 
-fno-merge-all-constants -fmerge-constants -fno-stack-check 
-fconserve-stack -Werror=date-time -Werror=incompatible-pointer-types 
-Werror=designated-init -fmacro-prefix-map=./= -fcf-protection=none 
-Wno-packed-not-aligned  -DMODULE -DKBUILD_BASENAME='"xt_DHCPMAC"' 
-DKBUILD_MODNAME='"xt_DHCPMAC"' -c -o 
/tmp/akmodsbuild.A7wQddef/BUILD/xtables-addons-kmod-3.3/_kmod_build_5.3.6-200.fc30.x86_64/extensions/xt_DHCPMAC.o 
/tmp/akmodsbuild.A7wQddef/BUILD/xtables-addons-kmod-3.3/_kmod_build_5.3.6-200.fc30.x86_64/extensions/xt_DHCPMAC.c
2019/10/19 16:08:43 akmodsbuild: 
/tmp/akmodsbuild.A7wQddef/BUILD/xtables-addons-kmod-3.3/_kmod_build_5.3.6-200.fc30.x86_64/extensions/xt_DHCPMAC.c: 
In function 'dhcpmac_tg':
2019/10/19 16:08:43 akmodsbuild: 
/tmp/akmodsbuild.A7wQddef/BUILD/xtables-addons-kmod-3.3/_kmod_build_5.3.6-200.fc30.x86_64/extensions/xt_DHCPMAC.c:99:7: 
error: implicit declaration of function 'skb_make_writable'; did you 
mean 'skb_try_make_writable'? [-Werror=implicit-function-declaration]
2019/10/19 16:08:43 akmodsbuild: 99 |  if (!skb_make_writable(skb, 0))
2019/10/19 16:08:43 akmodsbuild: |       ^~~~~~~~~~~~~~~~~
2019/10/19 16:08:43 akmodsbuild: |       skb_try_make_writable
2019/10/19 16:08:43 akmodsbuild: cc1: some warnings being treated as errors
2019/10/19 16:08:43 akmodsbuild: make[1]: *** 
[scripts/Makefile.build:281: 
/tmp/akmodsbuild.A7wQddef/BUILD/xtables-addons-kmod-3.3/_kmod_build_5.3.6-200.fc30.x86_64/extensions/xt_DHCPMAC.o] 
Error 1
2019/10/19 16:08:43 akmodsbuild: make[1]: *** Waiting for unfinished 
jobs....
2019/10/19 16:08:43 akmodsbuild: ./tools/objtool/objtool orc generate  
--module --no-fp --retpoline --uaccess 
/tmp/akmodsbuild.A7wQddef/BUILD/xtables-addons-kmod-3.3/_kmod_build_5.3.6-200.fc30.x86_64/extensions/xt_DELUDE.o
2019/10/19 16:08:43 akmodsbuild: make: *** [Makefile:1630: 
_module_/tmp/akmodsbuild.A7wQddef/BUILD/xtables-addons-kmod-3.3/_kmod_build_5.3.6-200.fc30.x86_64/extensions] 
Error 2
2019/10/19 16:08:43 akmodsbuild: make: Leaving directory 
'/usr/src/kernels/5.3.6-200.fc30.x86_64'
2019/10/19 16:08:43 akmodsbuild: error: Bad exit status from 
/var/tmp/rpm-tmp.VEFn5t (%build)
2019/10/19 16:08:43 akmodsbuild:
2019/10/19 16:08:43 akmodsbuild:
2019/10/19 16:08:43 akmodsbuild: RPM build errors:
2019/10/19 16:08:43 akmodsbuild: user mockbuild does not exist - using root
2019/10/19 16:08:43 akmodsbuild: group mock does not exist - using root
2019/10/19 16:08:43 akmodsbuild: user mockbuild does not exist - using root
2019/10/19 16:08:43 akmodsbuild: group mock does not exist - using root
2019/10/19 16:08:43 akmodsbuild: user mockbuild does not exist - using root
2019/10/19 16:08:43 akmodsbuild: group mock does not exist - using root
2019/10/19 16:08:43 akmodsbuild: Bad exit status from 
/var/tmp/rpm-tmp.VEFn5t (%build)
2019/10/19 16:08:43 akmodsbuild:
2019/10/19 16:08:43 akmods: Building rpms failed; see 
/var/cache/akmods/xtables-addons/3.3-3-for-5.3.6-200.fc30.x86_64.failed.log 
for details

This also fails on 5.3.5.

Matt

