Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FF12C76196
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Apr 2023 19:54:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjDATyU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Apr 2023 15:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjDATyU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Apr 2023 15:54:20 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D90E41A963
        for <netfilter-devel@vger.kernel.org>; Sat,  1 Apr 2023 12:54:18 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id B12B9320095B;
        Sat,  1 Apr 2023 15:54:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sat, 01 Apr 2023 15:54:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1680378855; x=1680465255; bh=+J
        5pKaXmV/2XU2WhwiyCUW8b3FFE2hIa9Xhvd9OuBd4=; b=GluYLXQOevdf1YZCni
        al7ZmL+9UKXW1n5PMDEcoL3BTHvWy8Hl2d5jXRygIWb89qDEUjr7ARwpb/YCsveQ
        fLKpt3x9xLuIodOcishc9butnmop+t3IltN9+naau/qYTNKgY6W1p/grQobzrzfk
        qpS7vfXMvdntZES65Aqkra8j6D/6Xe0O9nVq/GOdQKh2WpW4oBM2cGrBaieEHRU8
        gy5/F3BrChFb4S+Tq7Q3ZNXNEWw+Ex1C8NY6HGwz6SiPcNlevKYHv5u7c0qQjXQO
        8fV/HkZ0CnIpZ6IXCWEIc2Y0j/StL/Civa76Fm+LlnIfv4SpFMUnohIhUPDLrFT0
        +HKw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1680378855; x=1680465255; bh=+J5pKaXmV/2XU
        2WhwiyCUW8b3FFE2hIa9Xhvd9OuBd4=; b=FkLXZf95SOnd486k2RB0xKElKCZig
        5iicmPePvCqSfpGUaWbaCLsgVbeI8akgajE9CXulkGLYcp/IDi7nvPogBmri4ORM
        9QlYBmDxF58usEsab4XJYqkDbBwBxj2o7EosoiHhGleXpVFXIB/2XGW2lADJbwZq
        GGGvzwSbyV3bKHxuZEV3pjRZrHAnsKr3XZzaV62MIgzRkg30cAatc1VJ/taRSzQ+
        QgqUo1AmXxtPcfq/sgguQR471BJ+ePf67ov+TPGZeW/X7E4j354XcPIprUj/iFZs
        9DP7y9YzsG4xVx1EiXDdIe9Nb9ea+qlkYYkdowhYB/zY24hat0gZc91dA==
X-ME-Sender: <xms:54soZHwhUsszubLY9CMn5kDEk3NCkAo8a9UB6JtQPC2cEU-88fdnvA>
    <xme:54soZPTFUwrdG_ovy7pV-Sac9vLRjFxakwYRJloLilIKE0bKK7Pt4qARc-gcCLm0J
    voCmL5QVOhE-eOhsg>
X-ME-Received: <xmr:54soZBXZ1LWEu_F5nPahw7aKBGdVOzKfpQEZWUQ797Lyuq2vRDZNv_rpAxwvW6u_9qxgg6a7-Cp6wE3eEUnzrQmCnRmDqrG4fQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeifedgudegfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehgtderredttddvnecuhfhrohhmpeetlhih
    shhsrgcutfhoshhsuceohhhisegrlhihshhsrgdrihhsqeenucggtffrrghtthgvrhhnpe
    dvgeeifeffkeejhfdvhfdtffelteehjeelueehhfdvudeiueeugeeujefgtdetvdenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehhihesrghlhi
    hsshgrrdhish
X-ME-Proxy: <xmx:54soZBi46EBYmLLWHcyy5w6wN5v939TPCnQDGhowgnriPwFSj8jI1A>
    <xmx:54soZJC233pbDlZWzouvujmFhk4PwR5tDvoGtVYfmpQQD_9aDNnBeA>
    <xmx:54soZKK37PyYTpGf5c6ZBReuItnRT0yN1Lk-50RpxhAF9U4uXuENiA>
    <xmx:54soZMojmjZoGLAI4ZXsWUHHrBlwD3UTr5-NAAV1r_PwbrcziPjvJQ>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 1 Apr 2023 15:54:14 -0400 (EDT)
Received: by x220.qyliss.net (Postfix, from userid 1000)
        id 8A57E2615; Sat,  1 Apr 2023 19:54:12 +0000 (UTC)
Date:   Sat, 1 Apr 2023 19:54:12 +0000
From:   Alyssa Ross <hi@alyssa.is>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables] build: use pkg-config for libpcap
Message-ID: <20230401195412.gjradx2lisntbk7z@x220>
References: <20230331223601.315215-1-hi@alyssa.is>
 <20230401114304.GB730228@celephais.dreamlands>
 <20230401123018.GC730228@celephais.dreamlands>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="f25ib5zpfuthakkt"
Content-Disposition: inline
In-Reply-To: <20230401123018.GC730228@celephais.dreamlands>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--f25ib5zpfuthakkt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 01, 2023 at 01:30:18PM +0100, Jeremy Sowden wrote:
> > > diff --git a/configure.ac b/configure.ac
> > > index bc2ed47b..e0bb26aa 100644
> > > --- a/configure.ac
> > > +++ b/configure.ac
> > > @@ -114,7 +114,8 @@ AM_CONDITIONAL([ENABLE_NFTABLES], [test "$enable_nftables" = "yes"])
> > >  AM_CONDITIONAL([ENABLE_CONNLABEL], [test "$enable_connlabel" = "yes"])
> > >
> > >  if test "x$enable_bpfc" = "xyes" || test "x$enable_nfsynproxy" = "xyes"; then
> > > -	AC_CHECK_LIB(pcap, pcap_compile,, AC_MSG_ERROR(missing libpcap library required by bpf compiler or nfsynproxy tool))
> > > +	PKG_CHECK_MODULES([libpcap], [libpcap], [], [
> > > +		AC_MSG_ERROR(missing libpcap library required by bpf compiler or nfsynproxy tool)])
> > >  fi
>
> When autoconf first encounters `PKG_CHECK_MODULES`, if `$PKG_CONFIG` is
> not already defined it will execute `PKG_PROG_PKG_CONFIG` to find it.
> However, because you are calling `PKG_CHECK_MODULES` in a conditional,
> if `$enable_bpfc` and `$enable_nfsynproxy` are not `yes`, the expansion
> of `PKG_PROG_PKG_CONFIG` will not be executed and so the following
> pkg-config checks will fail:
>
>   checking for libnfnetlink >= 1.0... no
>   checking for libmnl >= 1.0... no
>   *** Error: No suitable libmnl found. ***
>       Please install the 'libmnl' package
>       Or consider --disable-nftables to skip
>       iptables-compat over nftables support.
>
> Something like this will fix it:
>
>   @@ -14,6 +14,7 @@ AC_PROG_CC
>    AM_PROG_CC_C_O
>    m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
>    LT_INIT([disable-static])
>   +PKG_PROG_PKG_CONFIG
>
>    AC_ARG_WITH([kernel],
>           AS_HELP_STRING([--with-kernel=PATH],
>
> > >  PKG_CHECK_MODULES([libnfnetlink], [libnfnetlink >= 1.0],

Another option would be to just move the libpcap change after this
unconditional one, avoiding the manual initialization.  Do you have a
preference?

--f25ib5zpfuthakkt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEH9wgcxqlHM/ARR3h+dvtSFmyccAFAmQoi+IACgkQ+dvtSFmy
ccDzUw/7BGZIoyS4per+5rwMECjs5e08YwuEbP2mTf9Eqf7HlgQ+1VAP6kSdFqNB
bN13Vf4mTy/ev/tAUnLJNPxBkSzRnO4XwP4EO20emN+/0R1COhpu3KGIqAFeZOZ1
oYneqR5X7M9557gJv4IlD1rGzUf9BhQXZHmBYATwoYS6iktmx1zxjcT9e0xoO22S
uppQXkOzzYMb3rFKX+42pa3R7FU7L3xoEJHGhhzgBXuz3qfgjkNtvrkfqgEqEesT
8jNUj/NTaGC1mafblttwyZukXX5M5rDoKDdx2dbaYKoSgHlLd8YamA6/QJlIzphG
H9CG2HN4cv7nbAlSkI4zit8aPpcnQWU5BODk7W2l4V6V2Xp3ECkIYORi7/B+3aCc
HKxfvwhq2ZTqKZQwr4TMvDKmH7PO5ZVfqPT29Eiz9f9wwC+w5iek9MwURKSzYbNf
bn0u24UyWs6jiHXW0js+xqNtB3uWAf0KL2uRdsF1ACDhWblbUHAB18CPHlFoIWEB
hkBASsmT8ir/gV3v8BwkFLytYq5mELnGRKWx3HxlQzc496APY37EhXdq7NsozbzN
QmVjRy/fw+ZpIwGR2kLPaMkgLsdRrws5pWw+H/qKKhiYRTf+TlBWHBFH/FuyiAyt
lvGJKGC+bHwDL+u5LAgRVtHIh+U9P6U0t4YQ2oiU/PGxNmoJwto=
=B1Tf
-----END PGP SIGNATURE-----

--f25ib5zpfuthakkt--
