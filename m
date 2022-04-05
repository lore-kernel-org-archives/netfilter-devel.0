Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E7F2C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Apr 2022 02:39:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiDECk5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 22:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbiDECkq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 22:40:46 -0400
Received: from mout.web.de (mout.web.de [212.227.15.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A23716BF64
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 18:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1649123072;
        bh=TmhQDWOXBFawecdqBgxQJzv3rU60ywJQR4Evthdgcko=;
        h=X-UI-Sender-Class:Date:From:To:Subject:In-Reply-To:References;
        b=d37uXrXCirTvjviQZhniJEtIlYXQtlRyfK51ex2gU9SXhLeDZcjVbGOCut946wIeS
         s1EAyrqfJZwKqgR7Jo3uk9CrMz5v0HjdYzxxTEsdMj1ANdZYCtuWLQYPQ7QQQ0h2LW
         PTQpwo7/x7FaSJlgFVuK49Lse9Ze/k8Ou3jql/+0=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from gecko ([46.223.151.228]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MsrhU-1nqrw03Ptg-00tLNS for
 <netfilter-devel@vger.kernel.org>; Tue, 05 Apr 2022 03:31:36 +0200
Date:   Tue, 5 Apr 2022 01:31:28 +0000
From:   Lukas Straub <lukasstraub2@web.de>
To:     netfilter-devel@vger.kernel.org
Subject: Re: meta time broken
Message-ID: <20220405013128.0bb907e2@gecko>
In-Reply-To: <20220405011705.1257ac40@gecko>
References: <20220405011705.1257ac40@gecko>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/uKwIt7V61xjM0_D+MTaIQFJ";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Provags-ID: V03:K1:vdKNXeyWbK0/FSUerIXZ6IV16kecBUDqe//i6Fvhtj0nVyZkoGo
 siH6Um0fE1XZDn9SSB4mOFpFNx982MlO2E6ANZe9Kwp+xTDR803NwH0OBgCcGkJhdeb8lcI
 4V7kttHvTu4ETzs5JQLksUs3t3ZXGcGKflWn6wqq6Nk/9n+YnFQQYWtEEx5ION9c2JA3k3g
 E+Y1DUOXqVNbU1I6xwKyQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:sL8w/CM+vJw=:0khaXhn1nPCaUyJkjQmbe5
 LilBofij4hAWShPNCEX3ax3av6Pji+J2fkhrPVawskw0eQUWvR5lRTjlNDZ8CFe9X8ASHkb9V
 2XF0Do2RYYZkCnHG7flIUBwwrXh7wOo00Sfcc0txFYvgnQZruNue5cgRfxg/lUZ23/Qte1anV
 IIoKrWmLQLtusluSdfDPlO/adv79KHPwngHX8qc56IlQ4oIaCTWesxYFLRdmd2/Hq6H6IdIMy
 8iyQTYHmOrI3aBD+eiSsckTTpRJVyMRz87U5UhJChGkcaxLG2WFdexRu2jG7SvVoP9mCMTxs6
 eg7Y9d7DfGKdUeJQZx0AkoqTmumPAJM3LB/TdChIwb/qKOLliPXA935J5Ujx7gtb8QnMawgb7
 XLCpJeW5jP/XGjuzf/OSOXQcldnpj5qVXqJSyUnwjUqNec3ceCkW6ls4rVSVE4qoICfIO1e6l
 FYq2eIHym2IBe5axurcSCSzXr2JSiQyKswGaBNr+5QwnUy00i8ESWChtvLlDFuIOlKn8L1LaL
 Saixy67Uh6IUqeCq475KzfFCt9IGRFnDmFh7z+O3uzjfDDdvGB3gHJP4hzQgtsvyX/GIafRlA
 VEVaq5Hhr/9ez/HtpAf7lzAxJg7bEINapP+0nHabHxckcGepweONx9Ygiv2bBEOuj+h2w/vtj
 dwV8MnenrcORuPlzRvAvoPkcuaMfu0FgVJYTNFO38K36J/omnGnUObGzOikEmcD2n30FB7CUA
 5wPelx307hprkgbcq9rCE69qR9/CjNZaz1J8OSL/svFhPWR9dw+Xu3LBifKGw2BoVVDhKYKH2
 edOfdpyV7AGa4j6KMwetM0KZTmZY/hfqMjsxF7pc0lJ8F4Z3Dlr6EnUTwZZjbGkXx1/U6/PQZ
 VQbIJJsM7Jyc+Q9bQfGOUo3qSL8U0GZIYyFyVN3yYWtvhhUDqft3gHhNC761uuUZy4mhEeYbv
 HbSWeluoyl0v3thECoY+2v4gzp50p/oLpjRt7I5Gt+0taMBLkisUcc7duOd8ws+IXVLIjn8lI
 ZDubBBhY5F570ioPwdPRVEftoJYSpN2NmWZta0jzqs3rHR7HkT2/RDdMSZXMlshCtnN4vEDWJ
 usOvdUmY4e2gNs=
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--Sig_/uKwIt7V61xjM0_D+MTaIQFJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 5 Apr 2022 01:17:05 +0000
Lukas Straub <lukasstraub2@web.de> wrote:

> Hello Everyone,
> I want to set up a rule that matches as long as the current time (/time
> of packet reception) is smaller than a given unix timestamp. However
> the whole "meta time" expression seems to be broken. I can't get it to
> work with either a unix timestamp or iso time. What's weird is that
> after setting the rule and listing it again, it will always display a
> date around 1970 instead of whatever was entered.
>=20
> Reproducer:
> nft "add chain inet filter prg_policy; flush chain inet filter prg_policy=
; add rule inet filter prg_policy meta time < $(date --date=3D'now + 2 hour=
s' '+%s') accept"
> nft list chain inet filter prg_policy
>=20
> Reproducer 2:
> nft "add chain inet filter prg_policy; flush chain inet filter prg_policy=
; add rule inet filter prg_policy meta time \"2022-04-01 01:00\" - \"2022-0=
4-10 01:00\" accept"
> nft list chain inet filter prg_policy
>=20
> nftables v1.0.2 (Lester Gooch)
> Linux usbrouter 5.10.0-13-armmp #1 SMP Debian 5.10.106-1 (2022-03-17) arm=
v7l GNU/Linux
>=20
> Regards,
> Lukas Straub
>=20

Hmm, after staring at the code for a bit. I could imagine it's due to
time_t being 32 bit on my platform and nftables trying to stuff a unix
timstamp with nanosecond resolution in it...

Regards,
Lukas Straub

--=20


--Sig_/uKwIt7V61xjM0_D+MTaIQFJ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEg/qxWKDZuPtyYo+kNasLKJxdslgFAmJLm/AACgkQNasLKJxd
slinnA/+NJZi515SsaY1mvfTZ6zoqL5T/y8e2CBKQFglELI/OY7KUbfsbLe5OgT7
sOgh3MCHfHviooMfPH8fzUp7+Ry+HD0jWVZpK3lePHzQWqmHlwwjOFj5FSjgh9nP
xQOQ6t03or8NIrOHVBeJ964sscdBG1QmrCUAOKgXXoZ5TZ8/k12GwonvN38GRvjM
6w3B9xSQG1504tUzVtbZB1/VEunifKb4qU5nITcnpyn3VcCwlSR0LIvKFjIu7vjy
+2p0XENN6wGN0OQywvqn5keo4amTGlYyDQvTKmNdEiUZsIzxG6kKbZdw1SreZFhC
sTJ8MH+94rGT1gBxXyB80k9C9+DWS7i9vHBLFqKapbQ8UMc4Bb42QO9zrEWTojRL
G4kpvY05xTEJwW19Eq5lnQ3vTeSdby/svhXhWQqsDey4EYQ7dTy9kB2+MHB0a9rr
DF9NcZnIOVz81Su5r0e4d3GRihIwLSUwddYCXERtEA02QP5QNPqPhPwAeJzLuNph
l4krSPeKxrmP/848UzmaB3b15wnhApekEgKCq9dVNurS6W8J/pNILwflxz00x0vM
/W21zkmLG8jf7cKPOHNnubxoVb9KJGmjYdmCr/MD0mY2JnZP3eU8jJ/7WvM1kJD2
TH2gFtmCLU2HHhIdQm+1H27ZgPqzYiZN0+jUnF6a2q6aCN8Vumg=
=+I4m
-----END PGP SIGNATURE-----

--Sig_/uKwIt7V61xjM0_D+MTaIQFJ--
