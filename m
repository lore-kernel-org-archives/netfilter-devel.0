Return-Path: <SRS0=22nV=3F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B61C33CB1
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 12:09:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4969D207FF
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 12:09:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgAPMJa convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jan 2020 07:09:30 -0500
Received: from correo.us.es ([193.147.175.20]:60868 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726574AbgAPMJ3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jan 2020 07:09:29 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 129E3DA7F0
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jan 2020 13:09:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 04F83DA7A0
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jan 2020 13:09:28 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EE6BADA796; Thu, 16 Jan 2020 13:09:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E2986DA707;
        Thu, 16 Jan 2020 13:09:25 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 16 Jan 2020 13:09:25 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C179F42EE396;
        Thu, 16 Jan 2020 13:09:25 +0100 (CET)
Date:   Thu, 16 Jan 2020 13:09:25 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next v4 00/10] netfilter: nft_bitwise: shift support
Message-ID: <20200116120925.eztbab76355ltdpe@salvia>
References: <20200115213216.77493-1-jeremy@azazel.net>
 <20200116085133.GG999973@azazel.net>
 <20200116112247.pfhkhii6b44iiw3n@salvia>
 <20200116114152.GA18463@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200116114152.GA18463@azazel.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jan 16, 2020 at 11:41:53AM +0000, Jeremy Sowden wrote:
> On 2020-01-16, at 12:22:47 +0100, Pablo Neira Ayuso wrote:
> > On Thu, Jan 16, 2020 at 08:51:33AM +0000, Jeremy Sowden wrote:
> > > On 2020-01-15, at 21:32:06 +0000, Jeremy Sowden wrote:
> > > > The connmark xtables extension supports bit-shifts.  Add support
> > > > for shifts to nft_bitwise in order to allow nftables to do
> > > > likewise, e.g.:
> > > >
> > > >   nft add rule t c oif lo ct mark set meta mark << 8 | 0xab
> > > >   nft add rule t c iif lo meta mark & 0xff 0xab ct mark set meta mark >> 8
> > > >
> > > > Changes since v3:
> > > >
> > > >   * the length of shift values sent by nft may be less than
> > > >   sizeof(u32).
> > >
> > > Actually, having thought about this some more, I believe I had it
> > > right in v3.  The difference between v3 and v4 is this:
> > >
> > >   @@ -146,7 +146,7 @@ static int nft_bitwise_init_shift(struct nft_bitwise *priv,
> > >                               tb[NFTA_BITWISE_DATA]);
> > >           if (err < 0)
> > >                   return err;
> > >   -       if (d.type != NFT_DATA_VALUE || d.len != sizeof(u32) ||
> > >   +       if (d.type != NFT_DATA_VALUE || d.len > sizeof(u32) ||
> > >               priv->data.data[0] >= BITS_PER_TYPE(u32)) {
> >
> > Why restrict this to 32-bits?
> 
> Because of how I implemented the shifts.  Here's the current rshift:
> 
>   static void nft_bitwise_eval_rshift(u32 *dst, const u32 *src,
>                                       const struct nft_bitwise *priv)
>   {
>           u32 shift = priv->data.data[0];
>           unsigned int i;
>           u32 carry = 0;
> 
>           for (i = 0; i < DIV_ROUND_UP(priv->len, sizeof(u32)); i++) {
>                   dst[i] = carry | (src[i] >> shift);
>                   carry = src[i] << (BITS_PER_TYPE(u32) - shift);
>           }
>   }
> 
> In order to support larger shifts, it would need to look something
> like:

No need for larger shift indeed, no need for this.

I just wanted to make sure NFTA_BITWISE_DATA can be reused later on in
future new operation that might require larger data.

All good then, I'll review v3, OK?
