Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59A0AC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jan 2022 22:48:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245137AbiAEWsg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Jan 2022 17:48:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbiAEWse (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Jan 2022 17:48:34 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A666FC061245
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Jan 2022 14:48:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SkKfptq0Fn+YRKQKstcOWFrhmaSBmKeNJahpYNvnrKo=; b=PnSbRF1fsaLLylb+HbrakDYmHW
        p1Mw4aeHok8RT3+eVhWGf7lgGAlCjvZAd7O9J9mcDqT5LQacGruWoOZaG2a6ZqpJ1mJ00EqWX80KP
        lBob30Q0EdYBVIbWFuMSAIbdJ2EOfeBxDpgg0bSNf7EiTwcpXTeaP6+ZC4FGUOkbMiLEjxaUxHViU
        Qcg0uJNlafzjNhnBe4gRFrDPAkHrAcIWmZSwM+ktFf+wA6QY381ZK4i1ZBzCF0K8GIv9fNT/mvS5+
        gL1REAsWLkPDu6oH6B9F2Sc5Ot982IWim/dsYYnsdPfAh57LO0AI3dcE+Hh7RGvS8h4H/mRJuCpAn
        0bbA6VHg==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1n5F55-00G2BI-Ga; Wed, 05 Jan 2022 22:48:31 +0000
Date:   Wed, 5 Jan 2022 22:48:30 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [ulogd2 PATCH v4 00/32] Fixes for compiler warnings
Message-ID: <YdYgPpxjhPP7IsiO@azazel.net>
References: <20211130105600.3103609-1-jeremy@azazel.net>
 <Ya6MyhseW80+w0FY@salvia>
 <YdM8BYK5U+CMU+ow@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="sVSoj9dy0QJ18I0X"
Content-Disposition: inline
In-Reply-To: <YdM8BYK5U+CMU+ow@salvia>
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--sVSoj9dy0QJ18I0X
Content-Type: multipart/mixed; boundary="88ZKhcwZiQhjHfu4"
Content-Disposition: inline


--88ZKhcwZiQhjHfu4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2022-01-03, at 19:10:13 +0100, Pablo Neira Ayuso wrote:
> On Mon, Dec 06, 2021 at 11:21:01PM +0100, Pablo Neira Ayuso wrote:
> > On Tue, Nov 30, 2021 at 10:55:28AM +0000, Jeremy Sowden wrote:
> > > This patch-set fixes all the warnings reported by gcc 11.
> > >
> > > Most of the warnings concern fall-throughs in switches, possibly
> > > problematic uses of functions like `strncpy` and `strncat` and
> > > possible truncation of output by `sprintf` and its siblings.
> > >
> > > Some of the patches fix bugs revealed by warnings, some tweak code
> > > to avoid warnings, others fix or improve things I noticed while
> > > looking at the warnings.
> > >
> > > Changes since v3:
> > >
> > >   * When publishing v3 I accidentally sent out two different
> > >     versions of the patch-set under one cover-letter.  There are
> > >     no code-changes in v4: it just omits the earlier superseded
> > >     patches.
> >
> > Applied from 1 to 19 (all inclusive)
>
> Applied remaining patches with comments.
>
> - Patch #20, #24 maybe consider conversion to snprintf at some point,
>   not your fault, this code is using sprintf in many spots. I think
>   the only problematic scenario which might trigger problems is the
>   configuration path using too long object names.

Yeah, there definitely were other places where I started to make
changes, but held off to stop the patch-set becoming even bigger than it
already was and focus on fixing the warnings.

> - Patch #21, #22 and #25, maybe consolidate this database field from
>   _ to . in a common function.

I've got the beginnings of a patch-set to do some tidying of the DB API.

There's an unused local variable left in the SQLITE3 plug-in.  I've
attached a patch to remove it.

> - Patch #27, tm_gmtoff mod 86400 is really required? tm_gmtoff can be
>   either -12/+12 * 60 * 60, simple assignment to integer should calm
>   down the compiler?

The compiler wasn't smart enough to know that the range of tm_gmtoff is
=C2=B143200, so it couldn't work out that the hours would fit in `%+03d`
without the mod.

> - Patch #80, I guess you picked 80 just to provide a sufficiently
>   large buffer to calm down compiler.

Correct.

> - Patch #31: I have replaced this patch with a check from .start and
>   .signal paths to validate the unix socket path. The signal path of
>   ulogd2 is problematic since configuration file errors should
>   likely stop the daemon. I'll post it after this email.

Looks good.

> - Patch #32: this IPFIX plugin was tested with wireshark according to
>   4f639231c83b ("IPFIX: Add IPFIX output plugin"), I wonder if this
>   attribute((packed)) is breaking anything, or maybe this was all
>   tested on 32-bit?

I'll take a look.

> Anyway, after this update it's probably better to look at using
> pkg-config in the build system.

J.

--88ZKhcwZiQhjHfu4
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline;
	filename="0001-output-SQLITE3-remove-unused-variable.patch"
Content-Transfer-Encoding: quoted-printable

=46rom e45879a7ea5529c26f369c297295332143ee8420 Mon Sep 17 00:00:00 2001
=46rom: Jeremy Sowden <jeremy@azazel.net>
Date: Wed, 5 Jan 2022 22:37:21 +0000
Subject: [PATCH] output: SQLITE3: remove unused variable

There's local variable left over from a previous tidy-up.  Remove it.

Fixes: 67b0be90f16f ("output: SQLITE3: improve mapping of fields to DB colu=
mns")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/sqlite3/ulogd_output_SQLITE3.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/output/sqlite3/ulogd_output_SQLITE3.c b/output/sqlite3/ulogd_o=
utput_SQLITE3.c
index 51eab782cc9d..0a9ad67edcff 100644
--- a/output/sqlite3/ulogd_output_SQLITE3.c
+++ b/output/sqlite3/ulogd_output_SQLITE3.c
@@ -320,7 +320,6 @@ sqlite3_init_db(struct ulogd_pluginstance *pi)
 	}
=20
 	for (col =3D 0; col < num_cols; col++) {
-		char *underscore;
 		struct field *f;
=20
 		/* prepend it to the linked list */
--=20
2.34.1


--88ZKhcwZiQhjHfu4--

--sVSoj9dy0QJ18I0X
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmHWIDcACgkQKYasCr3x
BA1KGhAApCqRBGF6f7bthhYT9UHnmznVVqDKVhWrrbsUVAys9ngVMEhK1EasEVPz
kN6dZ33UPwGjFXlUDkWlOtPpj41iKF8ZPvrZXx4e8CANDHWXRLKpPSOIm8ETs/zV
2U9W/PPQGnp+YKoZNVUScqaootw2Q1e+p0h0A+fgYvNIyrwcx73/jGNz6qwwSrs7
Ud+09EbQIE1y++DUITaV0mEqt4fTTCtN8czDqSkXtDudy2MMxOQjYZZ+ahpSUKyo
fBFbEV+OVoesav2aguWnLkWh2hK9vR9geYYpjGk9rK8TFL04gA7ZlMLIQ8sI5Y3k
FeUZlV0oGH0fOU3i0Bisn6reByeNRMcXLtzxN0TdieN3cTOX4CIzDLWYwsaFa6FB
jGjVmaoVImO47EVVvFerjaDuRNzHzro8GQygQpqJqvfRZnN8gafvC+WTxNONntY4
yNbfxH75ltx+LntkqdkbDWq+CoEfgTw1cfg5Lyf/s4+TtOpy36cSF3FbgHmKcKfJ
vnC5BOyReZfb5EYWvy6NL1X00kB7qiWgGFbVXImUX3hflpvX5vXHfWj/0ipx6jVx
yMGlCH2ieI62tP7uVqmI5Ru9x7w98+USVAsAs4/4kwefvFB4HUc4mEG67d13Z24B
FGd2bHuvdAB6leoirI6vxjYML1Yr43gI2Ly6dhVBoM/byBZexO8=
=oCZI
-----END PGP SIGNATURE-----

--sVSoj9dy0QJ18I0X--
