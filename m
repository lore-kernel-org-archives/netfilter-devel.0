Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D724ECAAD4
	for <netfilter-devel@archiver.kernel.org>; Sat,  3 Sep 2022 11:09:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbiICLJb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 3 Sep 2022 07:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiICLJa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 3 Sep 2022 07:09:30 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758CB2195
        for <netfilter-devel@vger.kernel.org>; Sat,  3 Sep 2022 04:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=00t8uSwdJikqSQza2zERscFImJFoC8oJQ3oPsh4fjdI=; b=INGCJ97mnE5Ff0KMIUdOBRaVPi
        LLQfOypNtsZIpvCAS+BojNHEJH2VOwQf2F+FNPHRPZxkDMmyjePPoS5nhoDv/sgzMR4KH+Z1dWrdw
        j1OqvqsCt+v9WGD0Aj7EhDppFfVknUbGjFB3RJdJS00kMZTY4HW8wzipr5hQpqreg8uPHNRmEUyfi
        JwIcU+1o6No9wVTlHmk2P1T5U0WvHJFuwkD25LMYclhwlCaGi5eI3aIetO0mU3W2aU//aYLIwI0Eg
        9ppHMU/LcFxPq0vYnq54iXLrKubSEJ18/YEfCYVBn17DVy2a8FXsPPlrdd8HzQp2RjI/ypOge4Bao
        q6FNXamA==;
Received: from [2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oUR1h-00Ej7K-2S; Sat, 03 Sep 2022 12:09:25 +0100
Date:   Sat, 3 Sep 2022 12:09:23 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Nick <vincent@systemli.org>
Cc:     Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Subject: Re: CPE-ID?
Message-ID: <YxM14+bAYAq0SesY@azazel.net>
References: <db95b6b2-ff01-c4ba-e3ea-8dd5f0fd8cf9@systemli.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jiAP5NIWA4GpAZPf"
Content-Disposition: inline
In-Reply-To: <db95b6b2-ff01-c4ba-e3ea-8dd5f0fd8cf9@systemli.org>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--jiAP5NIWA4GpAZPf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2022-09-03, at 12:10:34 +0200, Nick wrote:
> I can not find any cpe-id for nftables? Typically, I query this database:
> https://nvd.nist.gov/vuln/search

There don't appear to be any.  At any rate, if you use this search page:

  https://nvd.nist.gov/products/cpe/search

to look up "netfilter", you will find ID's for different versions of
other Netfilter libraries and tools, but nftables itself is not listed.

J.

--jiAP5NIWA4GpAZPf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmMTNdcACgkQKYasCr3x
BA3avQ//eIvtXjGkmB4QqNDHvbs1pilGAl/4Ogq8T8e6omneWx9UNliFbK8+yrm3
+uYxyqZkuwQeuEJe7A+/tq0qyKrUFV2czPiSiuQDvMSEk47a3C5+DyOm++5vSRls
+jp+/5ZZTs0NozuUk0WkXpH0yQf/tYPPY290hPLemOujTcnOsjxJuxQwBNMPiTWn
XB9qEx5Cc42LOYCZaNImabPWibZYlaZEQRAvAMu7ICxwKcy2fyQlobHew1UTxFli
5dLm/ANEfDkeuFSTDZdb98gfEW32sxVdA8KeBJuOPvM/sglR70TTspbdTiIzSXgZ
La3EeReG+zEwuy9dKfS/tYBdcjnMBmVoCmdvzkxEadx0SjNtwcasoWsBL85HEIbf
gv+me9WjEIxq4uQ2gxqSLLFpT5D+j39sM9dVb/RrJj31INxJAdI/Smf2Gg5H52CB
b1QaX0awz9zRB9VJaB7ARylOzSTS8fQFLoYbPSypqp8EvJcRoVbZNmpJ/7srZJph
cAR6B9+V31+TASIGOetvmDsltfsTthdYCIjbqbVeUNLU3XbgxF0gXG5r0dYD/FAI
O0NPPQalqNWwfGStPUXFSA0gwkJWes/CpQemdjn1IU9ooArKo+NdflKRfaqdFH50
W4UCalJZbNLpy8Qqto3FrawmBo1atnSelWTD65O0e1VUiAJnfgo=
=Zrxk
-----END PGP SIGNATURE-----

--jiAP5NIWA4GpAZPf--
