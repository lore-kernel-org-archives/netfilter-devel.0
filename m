Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0F3FE7D0AB
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Sep 2023 21:57:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbjIUV5Y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Sep 2023 17:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232910AbjIUV5O (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Sep 2023 17:57:14 -0400
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 117797AF47;
        Thu, 21 Sep 2023 10:34:43 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id DD8CACC02C9;
        Thu, 21 Sep 2023 08:57:02 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Thu, 21 Sep 2023 08:57:00 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 98DB7CC011C;
        Thu, 21 Sep 2023 08:56:59 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 9B6733431A9; Thu, 21 Sep 2023 08:56:59 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id 98CD4343155;
        Thu, 21 Sep 2023 08:56:59 +0200 (CEST)
Date:   Thu, 21 Sep 2023 08:56:59 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Jan Engelhardt <jengelh@inai.de>, Sam James <sam@gentoo.org>
cc:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [ANNOUNCE] ipset 7.18 released
In-Reply-To: <382279q3-6on5-32rq-po59-6r18os6934n9@vanv.qr>
Message-ID: <62d31829-d130-2e80-e7c-d3da4f19e90@netfilter.org>
References: <55c2bf9d-ec58-8db-e457-8a36ebbbc4c0@blackhole.kfki.hu> <382279q3-6on5-32rq-po59-6r18os6934n9@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jan,

On Wed, 20 Sep 2023, Jan Engelhardt wrote:

> 
> On Tuesday 2023-09-19 20:26, Jozsef Kadlecsik wrote:
> >
> >I'm happy to announce ipset 7.18, which brings a few fixes, backports, 
> >tests suite fixes and json output support.
> 
> The installation of the pkgconfig file is now broken.
> 
> >  - lib/Makefile.am: fix pkgconfig dir (Sam James)
> 
> Aaaaagh.. that change completely broke installation and must be reverted.
> 
> [   44s] RPM build errors:
> [   44s]     Installed (but unpackaged) file(s) found:
> [   44s]    /usr/usr/lib64/pkgconfig/libipset.pc

Thanks for quickly noticing the issue - the new release is already out.

Even two persons can make mistakes.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
