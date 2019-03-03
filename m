Return-Path: <SRS0=/MqZ=RG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED443C43381
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Mar 2019 18:32:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B09E020830
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Mar 2019 18:32:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="PNOm+qxv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726570AbfCCScj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 3 Mar 2019 13:32:39 -0500
Received: from smtp-out.kfki.hu ([148.6.0.48]:53907 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbfCCScj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Mar 2019 13:32:39 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 6F800CC00BB;
        Sun,  3 Mar 2019 19:32:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1551637955; x=1553452356; bh=z8LiHl1cdm
        Wit249eSYrPW/sg6qiKJc8vh6x5p7Woqw=; b=PNOm+qxvLdkcOC6ZDmE0LfbuqU
        Ml1OEZ2met62e+rrPA6/5JAQb7gIpABEIAQ1Z7pHgLHkZ6pnLTP4LyVNzjBs3H5m
        PM2uowiYbVwabIdorwvDpfWMOjDwO+R+NMXaENHttRgrMB4QA28+j/vfx/0vUaxk
        7ViXJ2lGFBfG7ihUg=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Sun,  3 Mar 2019 19:32:35 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 358E0CC007E;
        Sun,  3 Mar 2019 19:32:34 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 56E3021E44; Sun,  3 Mar 2019 19:32:34 +0100 (CET)
Date:   Sun, 3 Mar 2019 19:32:34 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To:     eliezer@ngtech.co.il
cc:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: RE: [ANNOUNCE] ipset 7.1 released
In-Reply-To: <01cd01d4cd69$20d81800$62884800$@ngtech.co.il>
Message-ID: <alpine.DEB.2.20.1902262020110.23657@blackhole.kfki.hu>
References: <alpine.DEB.2.20.1812111334220.25036@blackhole.kfki.hu> <01cd01d4cd69$20d81800$62884800$@ngtech.co.il>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Tue, 26 Feb 2019, eliezer@ngtech.co.il wrote:

> Can you refer me to an example to what it would be usefull fo 
> ansible,chef,puppet? Do you mean that it would be easier to configure 
> ipset with them?

Actually, sorting is not required to handle ipset from config management 
tools... I dunno why I thought so. I prefer ansible and Ansible Galaxy 
contains a role for managing ipset: 
https://github.com/mrlesmithjr/ansible-ipset

Best regards,
Jozsef

> From: netfilter-owner@vger.kernel.org <netfilter-owner@vger.kernel.org> On
> Behalf Of Jozsef Kadlecsik
> Sent: Tuesday, December 11, 2018 14:44
> To: netfilter@vger.kernel.org; netfilter-devel@vger.kernel.org
> Subject: [ANNOUNCE] ipset 7.1 released
> 
> Hi,
> 
> I'm happy to announce ipset 7.1. Besides the usual bugfixes there's a new 
> feature: sorting is implemented for the hash types of the sets, which is 
> useful for config management systems (ansible, chef, puppet, etc.).
> 
> Userspace changes:
>   - Add compatibility support for strscpy()
>   - Correct the manpage about the sort option
>   - Add missing functions to libipset.map
>   - configure.ac: Fix build regression on RHEL/CentOS/SL
>     (Serhey Popovych)
>   - Implement sorting for hash types in the ipset tool
>   - Fix to list/save into file specified by option
>     (reported by Isaac Good)
> Kernel part changes:
>   - netfilter/ipset: replace a strncpy() with strscpy() (Qian Cai)
>   - netfilter: ipset: fix ip_set_byindex function (Florent Fourcot)
>   - netfilter: ipset: do not call ipset_nest_end after nla_nest_cancel
>     (Pan Bian)
>   - Correct workaround in patch "Fix calling ip_set() macro at dumping"
> 
> You can download the source code of ipset from:
>         http://ipset.netfilter.org
>         ftp://ftp.netfilter.org/pub/ipset/
>         git://git.netfilter.org/ipset.git
> 
> Best regards,
> Jozsef
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
>           H-1525 Budapest 114, POB. 49, Hungary
> 
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
