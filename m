Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03C55CCA47F
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Jul 2022 11:13:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbiGKLNz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Jul 2022 07:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiGKLN3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Jul 2022 07:13:29 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ADDB7DEF6
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2022 03:27:58 -0700 (PDT)
Date:   Mon, 11 Jul 2022 12:27:55 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Loganaden Velvindron <logan@cyberstorm.mu>
Subject: Re: [PATCH] src: proto: support DF, LE, VA for DSCP
Message-ID: <Ysv7K00InP8vhSJb@salvia>
References: <20220620185807.968658-1-oleksandr@natalenko.name>
 <4976225.sBZ64R0qgq@natalenko.name>
 <YryKzGUPvFFyH9oM@salvia>
 <1798579.1LcLnjXDeY@natalenko.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1798579.1LcLnjXDeY@natalenko.name>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 29, 2022 at 07:34:40PM +0200, Oleksandr Natalenko wrote:
> Hello.
> 
> On středa 29. června 2022 19:24:28 CEST Pablo Neira Ayuso wrote:
> > On Tue, Jun 28, 2022 at 08:29:42PM +0200, Oleksandr Natalenko wrote:
> > > On pondělí 27. června 2022 19:31:27 CEST Pablo Neira Ayuso wrote:
> > > > On Mon, Jun 20, 2022 at 08:58:07PM +0200, Oleksandr Natalenko wrote:
> > > > > Add a couple of aliases for well-known DSCP values.
> > > > > 
> > > > > As per RFC 4594, add "df" as an alias of "cs0" with 0x00 value.
> > > > > 
> > > > > As per RFC 5865, add "va" for VOICE-ADMIT with 0x2c value.
> > > > 
> > > > Quickly browsing, I don't find "va" nor 0x2c in this RFC above? Could
> > > > you refer to page?
> > > 
> > > As per my understanding it's page 11 ("2.3.  Recommendations on implementation of an Admitted Telephony Service Class") here:
> > > 
> > >       Name         Space    Reference
> > >       ---------    -------  ---------
> > >       VOICE-ADMIT  101100   [RFC5865]
> > > 
> > > Am I wrong?
> > 
> > Ok, hence the 'va'.
> 
> Yes.

OK.

> > > > > As per RFC 8622, add "le" for Lower-Effort with 0x01 value.
> > > > 
> > > > This RFC refers to replacing CS1 by LE
> > > > 
> > > >    o  This update to RFC 4594 removes the following entry from its
> > > >       Figure 4:
> > > > 
> > > >    |---------------+------+-------------------+---------+--------+----|
> > > >    | Low-Priority  | CS1  | Not applicable    | RFC3662 |  Rate  | Yes|
> > > >    |     Data      |      |                   |         |        |    |
> > > >     ------------------------------------------------------------------
> > > > 
> > > >       and replaces it with the following entry:
> > > > 
> > > >    |---------------+------+-------------------+----------+--------+----|
> > > >    | Low-Priority  | LE   | Not applicable    | RFC 8622 |  Rate  | Yes|
> > > >    |     Data      |      |                   |          |        |    |
> > > >     -------------------------------------------------------------------
> > > > 
> > > > 
> > > > static const struct symbol_table dscp_type_tbl = {
> > > >         .base           = BASE_HEXADECIMAL,
> > > >         .symbols        = {
> > > >                 [...]
> > > >                 SYMBOL("cs1",   0x08),
> > > >                 [...]
> > > >                 SYMBOL("le",    0x01),
> > > 
> > > I think we shouldn't remove existing symbol, should we? Please let
> > > me know if I missed any suggested action item for myself here.
> > 
> > Not removing. I mean, if I understood correctly, the RFC says LE == cs1 ?
> 
> To my understanding, no. The RFC talks about obsoleting:
> 
> "This specification obsoletes RFC 3662 and updates the DSCP recommended in RFCs 4594 and 8325 to use the DSCP assigned in this specification."
> 
> > But the values are different.
> 
> Yes, as a consequence of obsoleting, not replacing.

OK.

> > > > > tc-cake(8) in diffserv8 mode would benefit from having "le" alias since
> > > > > it corresponds to "Tin 0".
> > > > 
> > > > Aliasing is fine, let's just clarify this first.
> > > 
> > > I mean, "le" would be an alias to "0x01", not to "cs1".
> > > 
> > > BTW, the reason I included Loganaden Velvindron in Cc is that "le"
> > > was already added in the past, but got quickly reverted as it broke
> > > some tests. Shall "le" interfere with "less-equal", or what could be
> > > the issue with it? If the name is not acceptable, "lephb" or similar
> > > can be used instead.
> > 
> > Oh right, this is an issue for the parser, the 'le' keyword is an
> > alias of '<='.
> 
> OK, then another name should be found.
>
> > What does 'lephb' stands for BTW?
> 
> "LE PHB" originally, as described in the RFC, it's Lower-Effort Per-Hop Behavior.

Fine with me.
