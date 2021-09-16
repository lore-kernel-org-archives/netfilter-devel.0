Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45A7AC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Sep 2021 10:53:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 232E36121F
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Sep 2021 10:53:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235570AbhIPKyx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Sep 2021 06:54:53 -0400
Received: from mail.netfilter.org ([217.70.188.207]:58924 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236951AbhIPKyu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Sep 2021 06:54:50 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6A72B60081;
        Thu, 16 Sep 2021 12:52:15 +0200 (CEST)
Date:   Thu, 16 Sep 2021 12:53:26 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft,v2] doc: fix sinopsis of named counter, quota and ct
 {helper,timeout,expect}
Message-ID: <20210916105326.GA10574@salvia>
References: <20210916104009.10259-1-pablo@netfilter.org>
 <YUMg+7SnNKUYMp75@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
In-Reply-To: <YUMg+7SnNKUYMp75@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 16, 2021 at 11:48:27AM +0100, Jeremy Sowden wrote:
> On 2021-09-16, at 12:40:09 +0200, Pablo Neira Ayuso wrote:
> > Sinopsis is not complete. Add examples for counters and quotas.
>=20
> That should be "Synopsis".

Thanks for reviewing.

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEFEKqOX9jqZmzwkCc1GSBvS7ZkBkFAmFDIiYACgkQ1GSBvS7Z
kBmW1RAApVkdyiQITpk15LBxgSkcANDBTmSR7Yr87a4b8pYr54wDScY1paneT1HT
Vhgs5J2QjUANRqXBdcxqRhqNBqgzJUurRbT+8A6e+15jRdVy2kwxcqmg7+BA8dTH
rL5WxGYLI2ePQui94dyKnAb22Hr/w637Rfpw9JsU9gy92ndzuZuXEQ41DsTBN6Bm
WzsSl8O8mnUweBk/jWKcSsdSKI9VueXsEPQPgfOJiBqfDTugW5y+N371i/6RdI3C
DJZSKQsW9SPADLpSQiOOlgX5+d08pOve/8l4Iaa8tc60r8fenddjC0J92BP6Prn+
9FDOMncQEaw36yh/5DBxXaJFfQYXZjPOhMVxphAhMjxEegDrcX2R+E61BMWIcytZ
VHtsav2APPnorqJaIlC08ehdkaGOZlWea3MM+9HCxYDSmuvVPCOTGERSH5UcOOVZ
1LvIhd/SaHDZf8+m/li43sfttS2QTfh7njEv2QUnvC6Ipig6lPM/ZtPif2czv7BY
wcqLpb2xqhfDWUMuxcS/zaY/ZmVhNN9rS4dUQpnbZiZINgwmo206YaOV/uC9FGWn
8H+6fzlGhShXkzNGJZYXZ+o40k5DTGH9NbA1AP0H0jfhGoU/H4kYCDpRHlG4GCud
NBF1S8xgeQmvXVR3Ey9fQd/vmKzjIC+Zw/bQ0H96bVAKuXYV8y4=
=Pmdg
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
