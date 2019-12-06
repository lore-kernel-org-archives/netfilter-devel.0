Return-Path: <SRS0=ut36=Z4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E50B6C43603
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Dec 2019 08:54:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5E132467A
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Dec 2019 08:54:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="KuZW/yXO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbfLFIy4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Dec 2019 03:54:56 -0500
Received: from kadath.azazel.net ([81.187.231.250]:46952 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfLFIy4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Dec 2019 03:54:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tgZlI5Lk2Jz70ch/c79iaSAYN7UEAX7zH6f6of3q0cs=; b=KuZW/yXOxHyNa+kIVIfJmsgwHW
        1O+J6ifWxTy4HbfpEiyYCjxOXj5pPrcGKXwV8tFaEz3qWCmTRCjb5liGcL1mGKQkyv5PKUSBYB0Hw
        M9QCN12BaVAya0xiZ4exaTeKsNh+qUmc75+FnKOspb0Vo1P3DcFLUVq7+zsjXMtBC32ckOmKuHOBH
        qu9KeBlGsIgSmERRyzIm68fsBkfUh0vHLsGL7+6y4uLCk6q61uIH2eankX78ZoJePZaP48Q7B/jy8
        KQ3GOtdqEcstbBUx489RMHlv2h2o/4GbDqKe9jfdfthJDOq/lDZUDI9aXXUwHk0gwFCzYKTxZz9c6
        jofT5DqQ==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1id9O1-0005xS-Lx; Fri, 06 Dec 2019 08:54:53 +0000
Date:   Fri, 6 Dec 2019 08:54:57 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH 0/1] netfilter: connmark: introduce set-dscpmark
Message-ID: <20191206085457.GH133447@azazel.net>
References: <20190324142314.92539-1-ldir@darbyshire-bryant.me.uk>
 <20191203160652.44396-1-ldir@darbyshire-bryant.me.uk>
 <20191205085657.GF133447@azazel.net>
 <DA14999D-D2D2-42C5-91BC-E3A8A7D0AA46@darbyshire-bryant.me.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="17/8oYur5Y32USnW"
Content-Disposition: inline
In-Reply-To: <DA14999D-D2D2-42C5-91BC-E3A8A7D0AA46@darbyshire-bryant.me.uk>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--17/8oYur5Y32USnW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-12-05, at 09:46:38 +0000, Kevin 'ldir' Darbyshire-Bryant wrote:
> On 5 Dec 2019, at 08:56, Jeremy Sowden <jeremy@azazel.net> wrote:
> > On 2019-12-03, at 16:06:52 +0000, Kevin Darbyshire-Bryant wrote:
> > > Greetings.  The following patch is similar to one I submitted as
> > > an RFC quite a while back (April).  Since then I've realised that
> > > the option should have been in the 'set mark' family as opposed to
> > > 'save mark' because 'set' is about setting the ct mark directly,
> > > whereas 'save' is about copying a packet's mark to the ct mark.
> > >
> > > Similarly I've been made aware of the revision infrastructure and
> > > now that I understand that a little more have made use of it for
> > > this change.  Hopefully this addresses one of Pablo's concerns.
> > >
> > > I've not been able to address the 'I'd like an nftables version'.
> > > Quite simply it is beyond my knowledge and ability.
> >
> > I'll do it [...].
>
> [...]
>
> I'm not totally convinced that what I've submitted for x_tables is the
> 'perfect' way of implementing the function so it's a plea for guidance
> as much as anything :-)

Understood. :) I'll port it to nft as a starting-point and then we can
see what feedback we get.

J.

--17/8oYur5Y32USnW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl3qF1IACgkQ0Z7UzfnX
9sOmghAAiWJM1w+nfrzVRMEyElmkr31CbFzkbydiQGSY8x489GM1WI0q88fefLzQ
TFDtCNNX5vlaGPxr7DEH8P5nQAMSp0UcaUz3Z8LPsjpaJdhAMFHsv3VzAHJdskF8
kpJnQMgL2uLHfmerq5K9fPFFDgTpGzH3tvodGId/bi+sxTAzk098gVNmuVN/YdqZ
PbZ+Z7AzUPNZiwnsAq671BZMqgUU40MnO5w37znomy3Prv9u+L59zzCUMDvsVUee
djLm5OnlOVK1s7d5YNFt4wqMQY4PzVe8lZtc2L6/MO32xmMMYq04ZoBDRl1ayN5C
F7RNC7yWyJrpOS/ZWW670+sCBF6Bmqe0aSGKb/lz2A+LBhRz3B2vhbJuViGMye2g
MQQr60Pwtxu88AguTHbpdY9reCYC9BqOpIaGKS8d4KsSW0J8uEDL2QwErtrBU5KF
CwCkrSPSj91W6rJgu39UzhmE2OEO+OJLTuk5I3ESBgmX+OUQ5KCdXZ0ZIOlfQdfX
JumNUknbQx9Kqvajs8CScFdzMlUdpkg+X/LW8s/GihZGM2Xooon9ELCHUjjjRo6S
HV05HcUtfYR5E6d8/hJmh6ivTwONvpuvh5M0xCxQgIYx54uxDjObiqa9mTolOwfy
LomVn4pD7MaWSHtMaPOMaI5DE2qxWczkUaBu3+zTAi2pYLyvqCg=
=xmec
-----END PGP SIGNATURE-----

--17/8oYur5Y32USnW--
