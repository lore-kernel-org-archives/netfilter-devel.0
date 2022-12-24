Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F155C4332F
	for <netfilter-devel@archiver.kernel.org>; Sat, 24 Dec 2022 17:24:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiLXRYP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 24 Dec 2022 12:24:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiLXRYO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 24 Dec 2022 12:24:14 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EEF9588
        for <netfilter-devel@vger.kernel.org>; Sat, 24 Dec 2022 09:24:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=oPHkvSqIS/3bFh8VQYpEtkFU+3GedN+HElAVL0Zf7N8=; b=MYPGknQHbl1A2Qg4k/wruo4ES4
        dkhxClQpt2kO98FJ+IMdwzfkxv7Oy4q7fR00SQM5EARYwF+MPPi7w/+W9jzWBTNX5j3hv2+qVufEx
        Y0Mu9jcVFBZxEQRQUBmRrwY+5bYQeMPceXuJ7PrRZWmu57Sz49UllMwhzFRx/cmRf23z/Up7WTf17
        eed9czF8gZ/8ptOKdE5AVJPkY9kS0k3B2lvMg5HysAX2Tz6s5hSF62LQXrTzG2TvmkMPxYmtwK+qI
        LUcyGOAldCY6EHITel4tk3B5HAt1TE5PIJ0K+6Nq1jOiFs8UfeiHi8I5DmAgD+xHkIKWX7AG/FFll
        y8/pj9hQ==;
Received: from [2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] (helo=celephais.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1p98Fl-006tTo-Vz; Sat, 24 Dec 2022 17:24:10 +0000
Date:   Sat, 24 Dec 2022 17:24:08 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libmnl] doc: fix some non-native English usages
Message-ID: <Y6c1uIjL/Eg+NfKW@celephais.dreamlands>
References: <20221223215621.2940577-1-jeremy@azazel.net>
 <Y6c0B55Iw3mqO2k/@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fvfYsJDTCHzQk8Fm"
Content-Disposition: inline
In-Reply-To: <Y6c0B55Iw3mqO2k/@salvia>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--fvfYsJDTCHzQk8Fm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2022-12-24, at 18:16:55 +0100, Pablo Neira Ayuso wrote:
> On Fri, Dec 23, 2022 at 09:56:21PM +0000, Jeremy Sowden wrote:
> > "allows to" -> "allows ${pronoun} to".  We use "you" if that appears in=
 context,
> > "one" otherwise.
>=20
> $ patch -p1 < libmnl-doc-fix-some-non-native-English-usages.patch
> patching file src/attr.c
> Hunk #1 FAILED at 115.
> Hunk #2 FAILED at 222.
> Hunk #3 succeeded at 262 (offset 18 lines).
> Hunk #4 succeeded at 289 (offset 18 lines).
> 2 out of 4 hunks FAILED -- saving rejects to file src/attr.c.rej
> patching file src/nlmsg.c
> Hunk #1 succeeded at 518 (offset 30 lines).
> patching file src/socket.c

Whoops.  Will rebase.

J.

--fvfYsJDTCHzQk8Fm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmOnNbgACgkQKYasCr3x
BA3LpA/+PvojITYFkmYXd/uSVjqu6+jkangvASQ53kBCR+zUFop78r+TTQLzW5hh
p6Mx0LgfChGCLE/HM9pvWeV5Vk1D/PIk8BD8fCHE2v2pvAD89Fb00trDol8Obmvw
NKw7w+5Qm8zD+PpkmKUl9eyYO5KA/hvnvkki4jmLY5bQ6EybpVskUF4eHaSdFlLP
+6KC48BjhvijVAv1dWigVsU173jnRTY4+fzBDjRYzqCyOXUuNnI7Muas6wKdeYdh
CnlQUmL18vIjGXChb6NNY3lsFxOBzhIL3ciXNoCWx/ozu0ftxB+R9lfDyWC9WLcD
MhAX6srusj8oR3h35bWjeiwjrdtJRVW+tNjhiRagEUTUee3NPKe+ERrKEAPoYPV2
d5na2jFVoklzPp4Cs/6FKAckMlbs71oJpBRKJCQzW9Lo9gUHZKpBvpvLqmGPWDaP
lD0hn9eZmHcW34/JaGqlUjiuvw6CemTdOhuUEtr5uBanVbJq012ed1UyROBx7EzB
3E0+8wchvemUGFYZ2UBr0G2rpKI/9HY42bdrZhBd7pWOWjBlul9z/kckkyV0CU19
upriRAKNHLuSFgDM7nh9QbSfr8cA8UV/OYs60b1J6PvSrwQNAV7OYZDA2iXPB40W
vLfY7IAvJLEqGkDSZmoGXfgq1PukdQeE2A/+z08nlfBKUfo3S38=
=SHTx
-----END PGP SIGNATURE-----

--fvfYsJDTCHzQk8Fm--
