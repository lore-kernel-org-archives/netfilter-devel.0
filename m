Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB049C43334
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jun 2022 18:29:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbiF1S3u (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Jun 2022 14:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbiF1S3t (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Jun 2022 14:29:49 -0400
Received: from vulcan.natalenko.name (vulcan.natalenko.name [IPv6:2001:19f0:6c00:8846:5400:ff:fe0c:dfa0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 704F121809
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jun 2022 11:29:47 -0700 (PDT)
Received: from spock.localnet (unknown [83.148.33.151])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 35D74F6A8B0;
        Tue, 28 Jun 2022 20:29:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1656440984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bqaiqzH74abHB69zm6IY6OsuXJbFYqyN5sw+VsG9/Tk=;
        b=PUVSvUuAvBo/xDltEN0UHIOC6ur7Egm9fqB2fjdk/yxkF84t8dwyqhpCGDbPa5vWYySQ0u
        de5ERITK8aY6vztbOJL4RIE3tL+2aD+NRkBGTMBvoJWz293QfyCNw2UOg1AWFCYdR319ac
        g9XTqr18Z3eI2GP8n50Phg3156g8J/U=
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Loganaden Velvindron <logan@cyberstorm.mu>
Subject: Re: [PATCH] src: proto: support DF, LE, VA for DSCP
Date:   Tue, 28 Jun 2022 20:29:42 +0200
Message-ID: <4976225.sBZ64R0qgq@natalenko.name>
In-Reply-To: <Yrnpb7DcTz7qW1hh@salvia>
References: <20220620185807.968658-1-oleksandr@natalenko.name> <Yrnpb7DcTz7qW1hh@salvia>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello.

Thank you for your response. Please find my comments inline.

On pond=C4=9Bl=C3=AD 27. =C4=8Dervna 2022 19:31:27 CEST Pablo Neira Ayuso w=
rote:
> On Mon, Jun 20, 2022 at 08:58:07PM +0200, Oleksandr Natalenko wrote:
> > Add a couple of aliases for well-known DSCP values.
> >=20
> > As per RFC 4594, add "df" as an alias of "cs0" with 0x00 value.
> >=20
> > As per RFC 5865, add "va" for VOICE-ADMIT with 0x2c value.
>=20
> Quickly browsing, I don't find "va" nor 0x2c in this RFC above? Could
> you refer to page?

As per my understanding it's page 11 ("2.3.  Recommendations on implementat=
ion of an Admitted Telephony Service Class") here:

      Name         Space    Reference
      ---------    -------  ---------
      VOICE-ADMIT  101100   [RFC5865]

Am I wrong?

> > As per RFC 8622, add "le" for Lower-Effort with 0x01 value.
>=20
> This RFC refers to replacing CS1 by LE
>=20
>    o  This update to RFC 4594 removes the following entry from its
>       Figure 4:
>=20
>    |---------------+------+-------------------+---------+--------+----|
>    | Low-Priority  | CS1  | Not applicable    | RFC3662 |  Rate  | Yes|
>    |     Data      |      |                   |         |        |    |
>     ------------------------------------------------------------------
>=20
>       and replaces it with the following entry:
>=20
>    |---------------+------+-------------------+----------+--------+----|
>    | Low-Priority  | LE   | Not applicable    | RFC 8622 |  Rate  | Yes|
>    |     Data      |      |                   |          |        |    |
>     -------------------------------------------------------------------
>=20
>=20
> static const struct symbol_table dscp_type_tbl =3D {
>         .base           =3D BASE_HEXADECIMAL,
>         .symbols        =3D {
>                 [...]
>                 SYMBOL("cs1",   0x08),
>                 [...]
>                 SYMBOL("le",    0x01),

I think we shouldn't remove existing symbol, should we? Please let me know =
if I missed any suggested action item for myself here.

> > tc-cake(8) in diffserv8 mode would benefit from having "le" alias since
> > it corresponds to "Tin 0".
>=20
> Aliasing is fine, let's just clarify this first.

I mean, "le" would be an alias to "0x01", not to "cs1".

BTW, the reason I included Loganaden Velvindron in Cc is that "le" was alre=
ady added in the past, but got quickly reverted as it broke some tests. Sha=
ll "le" interfere with "less-equal", or what could be the issue with it? If=
 the name is not acceptable, "lephb" or similar can be used instead.

Thanks.

Thanks.

=2D-=20
Oleksandr Natalenko (post-factum)


