Return-Path: <SRS0=22nV=3F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60AECC33CB1
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 11:22:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AA522073A
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 11:22:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbgAPLWx convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jan 2020 06:22:53 -0500
Received: from correo.us.es ([193.147.175.20]:57504 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbgAPLWw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jan 2020 06:22:52 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6557D191902
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jan 2020 12:22:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 55C0CDA72A
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jan 2020 12:22:50 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4B7B0DA723; Thu, 16 Jan 2020 12:22:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 52EC8DA703;
        Thu, 16 Jan 2020 12:22:48 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 16 Jan 2020 12:22:48 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3624342EE396;
        Thu, 16 Jan 2020 12:22:48 +0100 (CET)
Date:   Thu, 16 Jan 2020 12:22:47 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next v4 00/10] netfilter: nft_bitwise: shift support
Message-ID: <20200116112247.pfhkhii6b44iiw3n@salvia>
References: <20200115213216.77493-1-jeremy@azazel.net>
 <20200116085133.GG999973@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200116085133.GG999973@azazel.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jan 16, 2020 at 08:51:33AM +0000, Jeremy Sowden wrote:
> On 2020-01-15, at 21:32:06 +0000, Jeremy Sowden wrote:
> > The connmark xtables extension supports bit-shifts.  Add support for
> > shifts to nft_bitwise in order to allow nftables to do likewise, e.g.:
> >
> >   nft add rule t c oif lo ct mark set meta mark << 8 | 0xab
> >   nft add rule t c iif lo meta mark & 0xff 0xab ct mark set meta mark >> 8
> >
> > Changes since v3:
> >
> >   * the length of shift values sent by nft may be less than sizeof(u32).
> 
> Actually, having thought about this some more, I believe I had it right
> in v3.  The difference between v3 and v4 is this:
> 
>   @@ -146,7 +146,7 @@ static int nft_bitwise_init_shift(struct nft_bitwise *priv,
>                               tb[NFTA_BITWISE_DATA]);
>           if (err < 0)
>                   return err;
>   -       if (d.type != NFT_DATA_VALUE || d.len != sizeof(u32) ||
>   +       if (d.type != NFT_DATA_VALUE || d.len > sizeof(u32) ||
>               priv->data.data[0] >= BITS_PER_TYPE(u32)) {

Why restrict this to 32-bits?

>                   nft_data_release(&priv->data, d.type);
>                   return -EINVAL;
> 
> However, I now think the problem is in userspace and nft should always
> send four bytes.  If it sends fewer, it makes it more complicated to get
> the endianness right.
> 
> Unless you think there are other changes needed that will required a v5,
> shall we just ignore v4 and stick with v3?
