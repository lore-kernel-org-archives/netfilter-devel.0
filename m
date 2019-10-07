Return-Path: <SRS0=Ckc6=YA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE9EEC47404
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Oct 2019 20:08:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84AA820835
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Oct 2019 20:08:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="KeURC8C2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729167AbfJGUIf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Oct 2019 16:08:35 -0400
Received: from smtp-out.kfki.hu ([148.6.0.48]:45531 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728786AbfJGUIe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Oct 2019 16:08:34 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id EFC2CCC00F4;
        Mon,  7 Oct 2019 22:08:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1570478909; x=1572293310; bh=D2x1JMS/je
        ejuiFcz4vFCUP/V6CAlyGIwfqOsHsPBJE=; b=KeURC8C2I/WmfccWcQf3yBazfn
        JS1nmae1oQ3pfREqYweo33dIdRT+R2isZe75mg/gXyCLz+JsmprQ6/1xjOJTUhYK
        LwFSHYyyyTQRSYoJscn4OyGIlKEivhZDubYh1t02jHp2Ke1iSRRpxrvldFQB81zu
        4MdDcev/RyFRvla0g=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Mon,  7 Oct 2019 22:08:29 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 6B7A7CC00F3;
        Mon,  7 Oct 2019 22:08:29 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 031A1211B0; Mon,  7 Oct 2019 22:08:28 +0200 (CEST)
Date:   Mon, 7 Oct 2019 22:08:28 +0200 (CEST)
From:   =?UTF-8?Q?Kadlecsik_J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>
To:     Jeremy Sowden <jeremy@azazel.net>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next 0/7] ipset: remove static inline functions
In-Reply-To: <20191003195607.13180-1-jeremy@azazel.net>
Message-ID: <alpine.DEB.2.20.1910072206070.16051@blackhole.kfki.hu>
References: <20191003195607.13180-1-jeremy@azazel.net>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jeremy, Pablo,

On Thu, 3 Oct 2019, Jeremy Sowden wrote:

> In his feedback on an earlier patch series [0], Pablo suggested reducing
> the number of ipset static inline functions.
> 
> 0 - https://lore.kernel.org/netfilter-devel/20190808112355.w3ax3twuf6b7pwc7@salvia/
> 
> This series:
> 
>   * removes inline from static functions in .c files;
>   * moves some static functions out of headers and removes inline from
>     them if they are only called from one .c file,
>   * moves some static functions out of headers, removes inline from them
>     and makes them extern if they are too big.
> 
> The changes reduced the size of the ipset modules by c. 13kB, when
> compiled with GCC 9 on x86-64.

I have reviewed all of the patches and they are all right. Pablo, could 
you queue them for nf-next? I applied the patches in the ipset git tree.

Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
