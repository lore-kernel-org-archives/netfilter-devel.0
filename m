Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C4A6C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Apr 2022 11:32:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241701AbiDEL0Z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Apr 2022 07:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357374AbiDELQV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Apr 2022 07:16:21 -0400
Received: from mout.web.de (mout.web.de [212.227.15.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4820E2DAAC
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Apr 2022 03:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1649155285;
        bh=rh6p9jx50Q1CqGRbyBscbEbQz0IxvFcBMbcbXN6ewnc=;
        h=X-UI-Sender-Class:Date:From:To:Subject:In-Reply-To:References;
        b=re7ZM4zUlTLgBW+IAlK1X3dSiho4GO4zlTfScAhR6j6H/HSKwe84RQKbyht/v+J1A
         M67p5WB4PUPcD3vZoeOZKcljp6RsaxEXNmt79RpkuIaaUIj7h5Z8gvow3aKdG4616I
         cRuA6+mGR0rh7qLc+WnhUbPz62HL31PEP7QmzG9g=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from gecko ([46.223.151.228]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1Mpl0r-1oLCWW17F7-00pkVv for
 <netfilter-devel@vger.kernel.org>; Tue, 05 Apr 2022 12:41:25 +0200
Date:   Tue, 5 Apr 2022 10:41:14 +0000
From:   Lukas Straub <lukasstraub2@web.de>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] meta time: use uint64_t instead of time_t
Message-ID: <20220405101026.867817071@web.de>
In-Reply-To: <20220405101016.855221490@web.de>
References: <20220405101016.855221490@web.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/dwye=9sy1v_mbwkf0axE5=w";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Provags-ID: V03:K1:nL1FPWDtlwht679GC8WeimfDPFcoQfnosVkxtUupyJrUuoj0zku
 qEsaGLMqRqkG6U0p3UpRx/ByiuOFqlsgGVgSRIJN9gQB7s9mF/8L9NSMlE1DbtWeRtRraiv
 RpPjpOSZY9yWPQ/OLwH8TjyL8Zkm9zVXs02MMxCwdd2WTJ2I1akAtdQx0TlhPdqvzvkx3//
 QzHslJFTceoLWrxNU6Mqw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:oQLNEMeKhVI=:/DSu8/6+Fr0xugjISqz288
 /OWkzb2T17XnKV+KFU0ng94yE2iQqNa1CikkP1ZOena3io8oFBdSC3StTdQvilFZXGn/IBgml
 ptD9qhAFsR8ptT4fmhKStuQ+Az++2b7nqvMu53zBhnmLlCnEGqHiaa6OqISUNmLQJfygt+z1E
 U6taWDjGP2d7UL2WVF2is/4T1scKueB5Ov2l3x+nWfkOtT6LQVblxWPdGsHdza5NFjC62EDCa
 jGBACP6FV9cW/uWGiVHnNQIqW5e0Sxl3tz2omm2htTWkQGQ7uenW5EXIfOARjpmTDCXo8kzJk
 QoFVtXX7H9ia1pL74+R4/OEKMhnIdOwe1AEFc4AxvBt3ImLCKa9UWQVTD4wFMDK+VaJIX6L3K
 2MHFWJnny25l+lDtoMJLXytJMWSbgqXzsADQqXEm01/IMod7oXLbGHi9g1tRzkpmGNLpGWlKR
 43esWGi4SCH8i/NfSpmWCXz0bbnLGWjlmAAWOytV5Eu7Bd3FN17UZAdldBuRu/380Z3QcWI1F
 VQUthPYNXSWtUQK0Rhx9rI0rePE39hCGjGNCdqJeU1ZCdNeqayioYzwFj72ppkJVuDq3KbXxL
 BpXLaX6sK8oMQ6R++EPPUd2Puzukk4lVZ0qg7+G+Uvb7lctceAu1ecODaGlxDyY1DLZkZM7HK
 ek7HTxTB/F8ynRDxPlXcpxTvs5LfJBOeypIadUkmCZW1VDBbEWV8UTajbSuacSMIh4NLpkBiU
 4yyhBUE4v26H6rOi1PtPgwu3eOgtx23z1+PUMvnsP0bfUJw9IeEeh5ij0fdXZHG7tE/F44WTE
 NXp9Qmr4IdX3LvFoRBIUN1klXk+7kBzC2fR8pQGH426Gw2rurhaJw+eiF/Pz+XXCMxOXQaS4/
 dzB0vz6zmNdrjxLKhN8awRoMk8dv89Q822eo5EHBjIvEaVlggAImiMq4DDCLxO+2osW6wUICt
 1YGcHEEjR99nb8nzc+0m99KNRXtoAND1zuCV+v7rHfGOdAwO7XbPiQnxF4okUq8qlYHOEPtde
 FbDos9WKDUGZpPOIjZFA7SvaLWNQq9UO9I6RIZsl9k4ZBGkq6V7xi6QokD97lEB4Bk3hPBycE
 tQ3tLGrZPCMELU=
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--Sig_/dwye=9sy1v_mbwkf0axE5=w
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

time_t may be 32 bit on some platforms and thus can't fit a timestamp
with nanoseconds resolution. This causes overflows and ultimatively
breaks meta time expressions on such platforms.

Fix this by using uint64_t instead.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=3D1567
Fixes: f8f32deda31df597614d9f1f64ffb0c0320f4d54=20
("meta: Introduce new conditions 'time', 'day' and 'hour'")
Signed-off-by: Lukas Straub <lukasstraub2@web.de>

Index: b/src/meta.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- a/src/meta.c
+++ b/src/meta.c
@@ -444,7 +444,7 @@ static struct error_record *date_type_pa
 					    struct expr **res)
 {
 	const char *endptr =3D sym->identifier;
-	time_t tstamp;
+	uint64_t tstamp;
=20
 	if ((tstamp =3D parse_iso_date(sym->identifier)) !=3D -1)
 		goto success;


--Sig_/dwye=9sy1v_mbwkf0axE5=w
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEg/qxWKDZuPtyYo+kNasLKJxdslgFAmJMHMoACgkQNasLKJxd
sliSWg/+NyYbTM7BAgIuJ6+HGTVzAFYM8sqYRyOe+Yk/ASHFr41PPYhRrr6K9Qq/
WajanPP8tp7+1PFOyc/HfcvHoEa9nVt7eUcIyRxbdfoNgNDJs40mgImPfvTBLVna
aOXl5iExW+N/toMI2fDBpjwob2NiqukOGKizSqLTj5BkwRJwopJN3m1ai6MWl5aQ
woMiYiUItoKqcY46DTmaFhlIud8Up5gjcumLaPidU34++I2Tk31hASPIeHQpfVTS
bHwGgPOsu7x6SD0xrFosq/543D9u/5qNChYWPLPUmQBBzRIC+VgD/NDS1j7FT9CZ
eWzQX60kb9yso0Uxa4L9Vv7axSmvGWQ1luW96oCJknl5B9OIZnXteV43Bx9CLygj
IRQ1tOE1Lqy5mwj0usqohY1xzdJnshobJ12E7WVcdREHWeOXnXN7MFAkk5O6NK/Z
REHs9l1aFx2b6kuRCpux43y9wNJUapjClwHna7AanVc2FtZSWweFtHnsMVy/0WNv
DIJ8oPhRZp2ZMKyQlTgzlxtPq0Ny5O4e9xQPRZ0LnnMhp/teATpQXYNndjHAfbjn
APPdlsStrOoebUzL+fIBEAsBkaeujyBv037w0y457ADrPP2uFSehwOiQu/XCjIvO
udDV9QnOIflNhwVpaL0FXw3opAYr7xsz1vDVwktp9QmqbkAKihM=
=SqjR
-----END PGP SIGNATURE-----

--Sig_/dwye=9sy1v_mbwkf0axE5=w--
