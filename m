Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58198C77B73
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 May 2023 15:01:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233365AbjEaPBO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 May 2023 11:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233575AbjEaPBN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 May 2023 11:01:13 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C35C0
        for <netfilter-devel@vger.kernel.org>; Wed, 31 May 2023 08:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TYAUZxdP9/WntNa5Zi6BpTH5LjH+Da18BbR5Eyll4MM=; b=T/YktXcyfdKYII7Yu4BJA/olqX
        7hyFwa1N4OARG/lsovXEsyLxOKt5/g2OyhGU3Z1cDEJzLHnti6gIrBSp5JXnfbSNwbiVnuA6gexD7
        /i7shJlq6GzKLfIoOR+2EEoNdGNWbNkiuKEQ9ntMRV2rOcwI9p69O9Bsi9VSOC+Sftjlu4r7zzxPh
        MpNKgJ0NgY8kzwIVqdzkpcNM32MX1DuHISxX84W3bp/8Go4Ehd7TO7fRgJjKV5MmBvXHNBaJqrzit
        mpc9PbvTzVIWt85+65LddvwU1f2GljdYUUyvFbtTKLjqchFKxdtlZlvM6BgGNk0sHmtiTEEih9orO
        0Qm3Llzg==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=azazel.net)
        by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1q4NJy-00Bfit-Ks; Wed, 31 May 2023 16:01:06 +0100
Date:   Wed, 31 May 2023 16:01:02 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     ValdikSS <iam@valdikss.org.ru>, netfilter-devel@vger.kernel.org
Subject: Re: xtables-addons: ipp2p does not block TCP traffic with nonlinear
 skb
Message-ID: <20230531150102.GA1355804@azazel.net>
References: <2b05bb89-08bf-b3b1-c2d7-9b391953f303@valdikss.org.ru>
 <7rr4q976-5qn6-382r-0pp-66rq492r9376@vanv.qr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="E2f57VnskL+TofF/"
Content-Disposition: inline
In-Reply-To: <7rr4q976-5qn6-382r-0pp-66rq492r9376@vanv.qr>
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--E2f57VnskL+TofF/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-05-31, at 11:41:07 +0200, Jan Engelhardt wrote:
> On Wednesday 2023-05-31 08:42, ValdikSS wrote:
> > However, it's not getting processed due to nonlinear skb:
> >
> >> static bool
> >> ipp2p_mt(const struct sk_buff *skb, struct xt_action_param *par)
> >>  /* make sure that skb is linear */
> >>  if (skb_is_nonlinear(skb)) {
> >>   if (info->debug)
> >>   	printk("IPP2P.match: nonlinear skb found\n");
> >>  	return 0;
> >>  }
>=20
> It should be possible to just take the code from xt_ECHO and call
>=20
> if (skb_linearize(skb) < 0)
> 	return false;
>=20
> However, none of the xtables matches in the Linux kernel do this
> linearization, at least not that I can see directly.

They use `skb_header_pointer` instead, I think, which handles the
linearization behind the scenes.  I'll send a patch.

> Or xt_string's call to skb_find_text is magic..

J.

--E2f57VnskL+TofF/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmR3YScACgkQKYasCr3x
BA0QCRAAg1mYUdPURt9uBpTMxm66oUFtfSfXVgnL2TVR5j8yHHkzmlyWONYVRIV9
RaYa2pryxxW5GzPKwf9EMO7Pl/Ahmh99TaHZtzLLv+/T7+XNREVzhw5xNAuMbjN+
LV0bjZhGiw2AeCqgOq4T/j1VzZXxcoA4xhibWIDrp9DkQLhhzeoyCJ7H/Loc0ibz
SBj0zEfK54NwkrRqEZD2z3vQhDqad0VAsCRLCWn5j/RKLxFda4fDC51Z4K8Oglcu
6R+QDF8jIsKVkUSXxaP75V5ZDr2fn1+EJLI6TH+8ttC0UhlPLudMgnkASg309/Lj
Zw+DdRYGkkzv/cyqIIUIGpfT1xnlcG3zZsJxzpoGNukRqYPLLuEIQRSqEZCQkYxk
sT015TS2zPeOEGH0noROzqMbQuE6imMlOJoP3VjmyPE5KNYtflpY+upHXX/unblK
bKhtISGGZM3uaGqvIfhzyZb6ZoVoAOlKH/HziopLfGSsJsXXCVy4eoF6svvymrEs
hO+rsCEwzX+Lwqb8u9dcEJRmoPKQJ+tR4U6sb98CaqW8WDhR8rwXlos/rfaBputp
38H30KDUy1KZlCvz8EUZxzBTFEiiZkL9znGghp+5xZWMRPJz70PK/oD5GLs0z8MA
977DQHf6501d7pYVugwpC8Mah8dhqk1rvS7X1bbNdgY2/WYR8dY=
=Y51x
-----END PGP SIGNATURE-----

--E2f57VnskL+TofF/--
