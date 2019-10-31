Return-Path: <SRS0=LKiS=YY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA21ECA9EC3
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Oct 2019 11:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F5EC2087F
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Oct 2019 11:12:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="g8C+jM0S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfJaLMY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Oct 2019 07:12:24 -0400
Received: from smtp-out.kfki.hu ([148.6.0.45]:48051 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726722AbfJaLMY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Oct 2019 07:12:24 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id EECE167400F7;
        Thu, 31 Oct 2019 12:12:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1572520339; x=1574334740; bh=gXZ10RprWl
        1eXILfFFuXKsDOVj1ddX/MWUFSegSMRdA=; b=g8C+jM0SGk0N/kFEkPMLGK/SUr
        eG7gGi2k/j3dCcN81vMQIW+1Kvo2Q9w03vBjNsJu6/zqnVxpXy5MM+YNStJ6PeZy
        4G08oSUw2F4ZzTmsMmwJ4DBcdy+R/9x5G2QpgvQxqBV9wzNDZY3Cdf4sumJTfE0a
        i9SbmV+ui0yJwtI6c=
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Thu, 31 Oct 2019 12:12:19 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp0.kfki.hu (Postfix) with ESMTP id 87C3567400EA;
        Thu, 31 Oct 2019 12:12:19 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 633572206A; Thu, 31 Oct 2019 12:12:19 +0100 (CET)
Date:   Thu, 31 Oct 2019 12:12:19 +0100 (CET)
From:   =?UTF-8?Q?Kadlecsik_J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>
To:     Oskar Berggren <oskar.berggren@gmail.com>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: ipset make modules_install always fail unless module already
 loaded?
In-Reply-To: <CAHOuc7MXK7nqU84y7KnoO_4DdJPL2ts33c0tDENyS3bgHhZgeg@mail.gmail.com>
Message-ID: <alpine.DEB.2.20.1910311210540.30748@blackhole.kfki.hu>
References: <CAHOuc7MXK7nqU84y7KnoO_4DdJPL2ts33c0tDENyS3bgHhZgeg@mail.gmail.com>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Oskar,

On Tue, 29 Oct 2019, Oskar Berggren wrote:

> In Makefile.am there is this block:
> 
> modules_install:
> if WITH_KMOD
>     ${MAKE} -C $(KBUILD_OUTPUT) M=$$PWD/kernel/net \
>             KDIR=$$PWD/kernel modules_install
>     @modinfo -b ${INSTALL_MOD_PATH} ip_set_hash_ip | ${GREP} /extra/
> >/dev/null || echo "$$DEPMOD_WARNING"
>     @lsmod | ${GREP} '^ip_set' >/dev/null && echo "$$MODULE_WARNING"
> else
>     @echo Skipping kernel modules due to --with-kmod=no
> endif
> 
> I'm rusty on shell script, but it seems to me that the line with lsmod 
> will print the warning and return exit code 0 if a matching module is 
> loaded but if such a module is NOT loaded, grep will give exit code 1 
> (intended) and it will not print the warning (intended) but then the 
> whole line will return exit code 1 cause make to stop with an error. If 
> being run from another script it can/will stop that script from 
> continuing.
> 
> In short - make modules_install will only run successfully if an ipset
> module is already loaded. At least I seem to get this problem.

Yes, that was not taken care of. I'm committing the patch

diff --git a/Makefile.am b/Makefile.am
index 8d718e1..eab32ee 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -73,7 +73,7 @@ if WITH_KMOD
        ${MAKE} -C $(KBUILD_OUTPUT) M=$$PWD/kernel/net \
                        KDIR=$$PWD/kernel modules_install
        @modinfo -b ${INSTALL_MOD_PATH} ip_set_hash_ip | ${GREP} /extra/ >/dev/null || echo "$$DEPMOD_WARNING"
-       @lsmod | ${GREP} '^ip_set' >/dev/null && echo "$$MODULE_WARNING"
+       @lsmod | ${GREP} '^ip_set' >/dev/null && echo "$$MODULE_WARNING"; true
 else
        @echo Skipping kernel modules due to --with-kmod=no
 endif

to fix the issue.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
