Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F864C43334
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Jun 2022 17:34:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiF2Ret (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Jun 2022 13:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiF2Res (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Jun 2022 13:34:48 -0400
Received: from vulcan.natalenko.name (vulcan.natalenko.name [IPv6:2001:19f0:6c00:8846:5400:ff:fe0c:dfa0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CFE8286EF
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jun 2022 10:34:46 -0700 (PDT)
Received: from spock.localnet (unknown [83.148.33.151])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 336D1F6D4E9;
        Wed, 29 Jun 2022 19:34:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1656524082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vuBj6MnhwDuHKKpLZJ0rkAZ9g8A6wuyBGg54Uf00eOg=;
        b=OyqCrzLw1T/3ER8fUdSCsloiZEu7YBYmFCvvG93L0UjWPr5CmFuZ0PTQ9w5DzdLgp/w4ZH
        CBXgR9BoWM9NnlxpiNHgZYCRw74RZg5CV/+sKfKf2wFE7ETgnBKeRaE3LCeCb6KF6ySgGr
        IpdefgEmMsR1AQq7N/xwRLDjP1Ty6tw=
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Loganaden Velvindron <logan@cyberstorm.mu>
Subject: Re: [PATCH] src: proto: support DF, LE, VA for DSCP
Date:   Wed, 29 Jun 2022 19:34:40 +0200
Message-ID: <1798579.1LcLnjXDeY@natalenko.name>
In-Reply-To: <YryKzGUPvFFyH9oM@salvia>
References: <20220620185807.968658-1-oleksandr@natalenko.name> <4976225.sBZ64R0qgq@natalenko.name> <YryKzGUPvFFyH9oM@salvia>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello.

On st=C5=99eda 29. =C4=8Dervna 2022 19:24:28 CEST Pablo Neira Ayuso wrote:
> On Tue, Jun 28, 2022 at 08:29:42PM +0200, Oleksandr Natalenko wrote:
> > On pond=C4=9Bl=C3=AD 27. =C4=8Dervna 2022 19:31:27 CEST Pablo Neira Ayu=
so wrote:
> > > On Mon, Jun 20, 2022 at 08:58:07PM +0200, Oleksandr Natalenko wrote:
> > > > Add a couple of aliases for well-known DSCP values.
> > > >=20
> > > > As per RFC 4594, add "df" as an alias of "cs0" with 0x00 value.
> > > >=20
> > > > As per RFC 5865, add "va" for VOICE-ADMIT with 0x2c value.
> > >=20
> > > Quickly browsing, I don't find "va" nor 0x2c in this RFC above? Could
> > > you refer to page?
> >=20
> > As per my understanding it's page 11 ("2.3.  Recommendations on impleme=
ntation of an Admitted Telephony Service Class") here:
> >=20
> >       Name         Space    Reference
> >       ---------    -------  ---------
> >       VOICE-ADMIT  101100   [RFC5865]
> >=20
> > Am I wrong?
>=20
> Ok, hence the 'va'.

Yes.

> > > > As per RFC 8622, add "le" for Lower-Effort with 0x01 value.
> > >=20
> > > This RFC refers to replacing CS1 by LE
> > >=20
> > >    o  This update to RFC 4594 removes the following entry from its
> > >       Figure 4:
> > >=20
> > >    |---------------+------+-------------------+---------+--------+---=
=2D|
> > >    | Low-Priority  | CS1  | Not applicable    | RFC3662 |  Rate  | Ye=
s|
> > >    |     Data      |      |                   |         |        |   =
 |
> > >     ------------------------------------------------------------------
> > >=20
> > >       and replaces it with the following entry:
> > >=20
> > >    |---------------+------+-------------------+----------+--------+--=
=2D-|
> > >    | Low-Priority  | LE   | Not applicable    | RFC 8622 |  Rate  | Y=
es|
> > >    |     Data      |      |                   |          |        |  =
  |
> > >     -----------------------------------------------------------------=
=2D-
> > >=20
> > >=20
> > > static const struct symbol_table dscp_type_tbl =3D {
> > >         .base           =3D BASE_HEXADECIMAL,
> > >         .symbols        =3D {
> > >                 [...]
> > >                 SYMBOL("cs1",   0x08),
> > >                 [...]
> > >                 SYMBOL("le",    0x01),
> >=20
> > I think we shouldn't remove existing symbol, should we? Please let
> > me know if I missed any suggested action item for myself here.
>=20
> Not removing. I mean, if I understood correctly, the RFC says LE =3D=3D c=
s1 ?

To my understanding, no. The RFC talks about obsoleting:

"This specification obsoletes RFC 3662 and updates the DSCP recommended in =
RFCs 4594 and 8325 to use the DSCP assigned in this specification."

> But the values are different.

Yes, as a consequence of obsoleting, not replacing.

> > > > tc-cake(8) in diffserv8 mode would benefit from having "le" alias s=
ince
> > > > it corresponds to "Tin 0".
> > >=20
> > > Aliasing is fine, let's just clarify this first.
> >=20
> > I mean, "le" would be an alias to "0x01", not to "cs1".
> >=20
> > BTW, the reason I included Loganaden Velvindron in Cc is that "le"
> > was already added in the past, but got quickly reverted as it broke
> > some tests. Shall "le" interfere with "less-equal", or what could be
> > the issue with it? If the name is not acceptable, "lephb" or similar
> > can be used instead.
>=20
> Oh right, this is an issue for the parser, the 'le' keyword is an
> alias of '<=3D'.

OK, then another name should be found.

> What does 'lephb' stands for BTW?

"LE PHB" originally, as described in the RFC, it's Lower-Effort Per-Hop Beh=
avior.

> Note that these aliases will be lost when listing back the ruleset
> from the kernel, so it is only working as an input.

Sure thing.

Thanks.

=2D-=20
Oleksandr Natalenko (post-factum)


