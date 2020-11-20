Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C167C63777
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Nov 2020 08:07:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE3D422227
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Nov 2020 08:07:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725809AbgKTIHc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Nov 2020 03:07:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbgKTIHc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 03:07:32 -0500
X-Greylist: delayed 40733 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 20 Nov 2020 00:07:32 PST
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06605C0613CF;
        Fri, 20 Nov 2020 00:07:32 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 7EE6567400C9;
        Fri, 20 Nov 2020 09:07:30 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Fri, 20 Nov 2020 09:07:28 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp0.kfki.hu (Postfix) with ESMTP id 4662A6740114;
        Fri, 20 Nov 2020 09:07:27 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 39EBD340D5C; Fri, 20 Nov 2020 09:07:27 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id 356C5340D5B;
        Fri, 20 Nov 2020 09:07:27 +0100 (CET)
Date:   Fri, 20 Nov 2020 09:07:27 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
X-X-Sender: kadlec@blackhole.kfki.hu
To:     Neutron Soutmun <neo.neutron@gmail.com>
cc:     Jan Engelhardt <jengelh@inai.de>, netfilter@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [ANNOUNCE] ipset 7.8 released
In-Reply-To: <CAMQP0skDvG-vOAGmcx2kn21KYS9UgMfxND7NTi_X75GOnx_izw@mail.gmail.com>
Message-ID: <alpine.DEB.2.23.453.2011200904550.19567@blackhole.kfki.hu>
References: <alpine.DEB.2.23.453.2011192141150.19567@blackhole.kfki.hu> <45rqn0n5-5385-o997-rn9q-os784nqrn9p@vanv.qr> <alpine.DEB.2.23.453.2011192237290.19567@blackhole.kfki.hu> <83oq5412-o0sq-5q31-s7o5-s0q28s12844@vanv.qr>
 <CAMQP0skDvG-vOAGmcx2kn21KYS9UgMfxND7NTi_X75GOnx_izw@mail.gmail.com>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Fri, 20 Nov 2020, Neutron Soutmun wrote:

> For the ipset 7.9, I found the released download url is 
> http://ipset.netfilter.org/ipset-7.9.tar.bz2, however, it's previous 
> releases are in http://ftp.netfilter.org/pub/ipset/
> 
> The Debian has the tool to detect the new release with package watch [1] 
> file. Could you please consider uploading the new release to the 
> fpt.netfiler.org/pub/ipset also.

It has been fixed. Please note, I switched from md5 to sha512 at 
generating the checksum file, so the filename is changed accordingly to 
<packagename>.sha512sum.txt.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
