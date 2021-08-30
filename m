Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F8D2C432BE
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Aug 2021 10:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 800D161101
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Aug 2021 10:46:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236372AbhH3Krp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Aug 2021 06:47:45 -0400
Received: from mail.netfilter.org ([217.70.188.207]:43308 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236361AbhH3Krp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Aug 2021 06:47:45 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 01452601F9;
        Mon, 30 Aug 2021 12:45:51 +0200 (CEST)
Date:   Mon, 30 Aug 2021 12:46:47 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_log 0/6] Implementation of some fields
 omitted by `ipulog_get_packet`.
Message-ID: <20210830104647.GA22575@salvia>
References: <20210828193824.1288478-1-jeremy@azazel.net>
 <20210830001621.GA15908@salvia>
 <YSyth32P0Q5+0MIt@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <YSyth32P0Q5+0MIt@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 30, 2021 at 11:05:59AM +0100, Jeremy Sowden wrote:
> From f41fb8baa5993e21dbe21ad9ad52c8af2fae4d98 Mon Sep 17 00:00:00 2001
> From: Jeremy Sowden <jeremy@azazel.net>
> Date: Sun, 29 Aug 2021 11:40:13 +0100
> Subject: [PATCH] build: add LIBVERSION variable for ipulog
>=20
> Replace hard-coded version-info in LDFLAGS.

Applied, thanks.

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEFEKqOX9jqZmzwkCc1GSBvS7ZkBkFAmEstxQACgkQ1GSBvS7Z
kBncQw//WrTijcG+2TGYciNXlgxf6wHU+/Od3phZCTwzEZwilLGIw7iD/EcEqRTQ
e4nYTVDUmRSqymMeOsJIcO64sH69Mk8axutia2d8ALTuw5NceuQy5/n8nmsX4Zz5
HEF5ASBcoR0ke4b50z4+jZkJeUwZWwjJgGA5uKuUeE7AyCkDIgWKKkgd/9YoBYaj
oiFD08qbOwjfCZ84K8Uf9X0D8naHdz5A+9xNsyrwpTNk3rQXn02IRzYTzlqpTfPW
KsBwf1qAY9y4ybwepxsFWPBV63EooFQYt7ouLvacq9wqDf6d5TFyTOCDv4U+LEkz
L4zKqSJT/7QaVxzWoE0gCR+/ui9tif6K+aCKAOJ5fk2HVg/2p/xGfQKWU7hCZNit
teezuw2C+4EvFkKRMnqY3k3ZHLMytJaAWYJ3ccI1oNpl7tSh3uti+ZYvrbnHQmMc
m6Rg6F1RnMihn1giGp4VXCng7ITXF46waCLnGKB4CWJP+IoP+VEjcXadB6Wk9LU5
o62SIjYLfZAwZSaDT+RhiS5LYg1XRusHmOKvW9HKxe3JaWxBoumxql9Lkh3NYJiA
aNQNTrR6IeblD9PZOzJlWQ/tHamBMOqvEuUsddEZE8oM+YB60AWuzB+QoP5/AHEU
hwPleWhO4nPOTpzYOLbxBlPhEf/4Jx+ObvmkFwv8+9HPJGNKGPw=
=hsnN
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
