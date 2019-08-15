Return-Path: <SRS0=UCCN=WL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D33D3C31E40
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Aug 2019 09:57:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B114F2171F
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Aug 2019 09:57:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730762AbfHOJ5D (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Aug 2019 05:57:03 -0400
Received: from correo.us.es ([193.147.175.20]:47604 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730533AbfHOJ5D (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Aug 2019 05:57:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 28722C41A5
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Aug 2019 11:57:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1880C5B3
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Aug 2019 11:57:00 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0E258DA72F; Thu, 15 Aug 2019 11:57:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0B7AA5B3;
        Thu, 15 Aug 2019 11:56:58 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 15 Aug 2019 11:56:58 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E01A54265A2F;
        Thu, 15 Aug 2019 11:56:57 +0200 (CEST)
Date:   Thu, 15 Aug 2019 11:56:58 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ander Juaristi <a@juaristi.eus>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] netfilter: Introduce new 64-bit helper functions
Message-ID: <20190815095658.rrgkaxgeqv3eccri@salvia>
References: <20190813183820.6659-1-a@juaristi.eus>
 <20190813185852.vzt4zjrditmptvmp@salvia>
 <052bfb99-22c1-749f-464d-ab63ad8d0e4c@juaristi.eus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <052bfb99-22c1-749f-464d-ab63ad8d0e4c@juaristi.eus>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 15, 2019 at 11:46:04AM +0200, Ander Juaristi wrote:
> 
> 
> On 13/8/19 20:58, Pablo Neira Ayuso wrote:
> > On Tue, Aug 13, 2019 at 08:38:19PM +0200, Ander Juaristi wrote:
> > [...]
> >> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> >> index 9b624566b82d..aa33ada8728a 100644
> >> --- a/include/net/netfilter/nf_tables.h
> >> +++ b/include/net/netfilter/nf_tables.h
> >> @@ -2,6 +2,7 @@
> >>  #ifndef _NET_NF_TABLES_H
> >>  #define _NET_NF_TABLES_H
> >>  
> >> +#include <asm/unaligned.h>
> >>  #include <linux/list.h>
> >>  #include <linux/netfilter.h>
> >>  #include <linux/netfilter/nfnetlink.h>
> >> @@ -119,6 +120,16 @@ static inline void nft_reg_store8(u32 *dreg, u8 val)
> >>  	*(u8 *)dreg = val;
> >>  }
> >>  
> >> +static inline void nft_reg_store64(u32 *dreg, u64 val)
> >> +{
> >> +	put_unaligned(val, (u64 *)dreg);
> >> +}
> >> +
> >> +static inline u64 nft_reg_load64(u32 *sreg)
> >> +{
> >> +	return get_unaligned((u64 *)sreg);
> >> +}
> > 
> > Please, add these function definition below _load16() and _store16().
> 
> You mean you'd like them ordered from smaller to larger?
> 
> nft_reg_store8
> nft_reg_load8
> nft_reg_store16
> nft_reg_load16
> nft_reg_store64
> nft_reg_load64

yes please.

> >> +
> >>  static inline u16 nft_reg_load16(u32 *sreg)
> >>  {
> >>  	return *(u16 *)sreg;
> >> diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
> >> index e06318428ea0..a25a222d94c8 100644
> >> --- a/net/netfilter/nft_byteorder.c
> >> +++ b/net/netfilter/nft_byteorder.c
> >> @@ -43,14 +43,14 @@ void nft_byteorder_eval(const struct nft_expr *expr,
> >>  		switch (priv->op) {
> >>  		case NFT_BYTEORDER_NTOH:
> > 
> > This is network-to-host byteorder.
> > 
> >>  			for (i = 0; i < priv->len / 8; i++) {
> >> -				src64 = get_unaligned((u64 *)&src[i]);
> >> -				put_unaligned_be64(src64, &dst[i]);
> >> +				src64 = nft_reg_load64(&src[i]);
> >> +				nft_reg_store64(&dst[i], cpu_to_be64(src64));
> > 
> > This looks inverted, this should be:
> > 
> > 				nft_reg_store64(&dst[i], be64_to_cpu(src64));
> > 
> > right?
> > 
> >>  			}
> >>  			break;
> >>  		case NFT_BYTEORDER_HTON:
> > 
> > Here, network-to-host byteorder:
> > 
> >>  			for (i = 0; i < priv->len / 8; i++) {
> >> -				src64 = get_unaligned_be64(&src[i]);
> >> -				put_unaligned(src64, (u64 *)&dst[i]);
> >> +				src64 = be64_to_cpu(nft_reg_load64(&src[i]));
> > 
> > and this:
> > 
> >                                 src64 = (__force __u64)
> >                                         cpu_to_be64(nft_reg_load64(&src[i]));
> > 
> 
> My bad. Yes, I've just fixed them.

Great.
