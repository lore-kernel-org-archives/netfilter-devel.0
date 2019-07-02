Return-Path: <SRS0=Rfup=U7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10C24C06510
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Jul 2019 10:59:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5A6520659
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Jul 2019 10:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbfGBK7J (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Jul 2019 06:59:09 -0400
Received: from mail.us.es ([193.147.175.20]:50272 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbfGBK7J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Jul 2019 06:59:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0998215C103
        for <netfilter-devel@vger.kernel.org>; Tue,  2 Jul 2019 12:59:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E9BC6DA4CA
        for <netfilter-devel@vger.kernel.org>; Tue,  2 Jul 2019 12:59:05 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DF649DA7B6; Tue,  2 Jul 2019 12:59:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 14052202D2;
        Tue,  2 Jul 2019 12:59:03 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 02 Jul 2019 12:59:03 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id DF64C4265A2F;
        Tue,  2 Jul 2019 12:59:02 +0200 (CEST)
Date:   Tue, 2 Jul 2019 12:59:02 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Yonatan Goldschmidt <yon.goldschmidt@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nat: Update obsolete comment on
 get_unique_tuple()
Message-ID: <20190702105902.gcsd4mgtzy4k777p@salvia>
References: <20190627212307.GB4897@jong.localdomain>
 <20190628090748.e42ymhe3huvuduhj@salvia>
 <20190701204222.GA1068@jong.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701204222.GA1068@jong.localdomain>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 01, 2019 at 11:42:23PM +0300, Yonatan Goldschmidt wrote:
> On Fri, Jun 28, 2019 at 11:07:48AM +0200, Pablo Neira Ayuso wrote:
> > On Fri, Jun 28, 2019 at 12:23:08AM +0300, Yonatan Goldschmidt wrote:
> > > Commit c7232c9979cba ("netfilter: add protocol independent NAT core")
> > > added nf_nat_core.c based on ipv4/netfilter/nf_nat_core.c,
> > > with this comment copied.
> > > 
> > > Referred function doesn't exist anymore, and anyway since day one
> > > of this file it should have referred the generic __nf_conntrack_confirm(),
> > > added in 9fb9cbb1082d6.
> > > 
> > > Signed-off-by: Yonatan Goldschmidt <yon.goldschmidt@gmail.com>
> > > ---
> > >  net/netfilter/nf_nat_core.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> > > index 9ab410455992..3f6023ed4966 100644
> > > --- a/net/netfilter/nf_nat_core.c
> > > +++ b/net/netfilter/nf_nat_core.c
> > > @@ -519,7 +519,7 @@ static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
> > >   * and NF_INET_LOCAL_OUT, we change the destination to map into the
> > >   * range. It might not be possible to get a unique tuple, but we try.
> > >   * At worst (or if we race), we will end up with a final duplicate in
> > > - * __ip_conntrack_confirm and drop the packet. */
> > > + * __nf_conntrack_confirm and drop the packet. */
> > 
> > I dislike this oneliners to update comments, I tend to think it's too
> > much overhead a patch just to update something obvious to the reader.
> > 
> > However, I also understand you may want to fix this while passing by
> > here.
> > 
> > So my sugggestion is that you run:
> > 
> >         git grep ip_conntrack
> > 
> > in the tree, searching for comments and documentation that can be
> > updated, eg.
> > 
> > net/netfilter/nf_conntrack_proto_icmp.c:        /* See ip_conntrack_proto_tcp.c */
> > 
> > Please, only update comments / documentation in your patch.
> > 
> > The ip_conntrack_ prefix is legacy, that it was used by the time there
> > was only support for IPv4 in the connection tracking system.
> > 
> > Thanks.
> 
> Okay, I've updated all comments which I found relevant, and made them refer
> to current files/functions names.
> I have retained comments referring to historical actions (i.e, comments like
> "derived from ..." were not touched, even if the file it was derived from is
> no longer here).

Thanks, LGTM.

Would you re-submit this again? This is not showing in my patchwork:

https://patchwork.ozlabs.org/project/netfilter-devel/list/

Please, also include a new subject title and patch description
according to this change.

> Signed-off-by: Yonatan Goldschmidt <yon.goldschmidt@gmail.com>
> ---
>  include/linux/netfilter/nf_conntrack_h323_asn1.h | 2 +-
>  net/ipv4/netfilter/ipt_CLUSTERIP.c               | 4 ++--
>  net/netfilter/nf_conntrack_core.c                | 2 +-
>  net/netfilter/nf_conntrack_h323_asn1.c           | 4 ++--
>  net/netfilter/nf_conntrack_proto_gre.c           | 2 +-
>  net/netfilter/nf_conntrack_proto_icmp.c          | 2 +-
>  net/netfilter/nf_nat_core.c                      | 2 +-
>  7 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/netfilter/nf_conntrack_h323_asn1.h b/include/linux/netfilter/nf_conntrack_h323_asn1.h
> index 91d6275292a5..a3844e2cd531 100644
> --- a/include/linux/netfilter/nf_conntrack_h323_asn1.h
> +++ b/include/linux/netfilter/nf_conntrack_h323_asn1.h
> @@ -1,6 +1,6 @@
>  /* SPDX-License-Identifier: GPL-2.0-only */
>  /****************************************************************************
> - * ip_conntrack_h323_asn1.h - BER and PER decoding library for H.323
> + * nf_conntrack_h323_asn1.h - BER and PER decoding library for H.323
>   * 			      conntrack/NAT module.
>   *
>   * Copyright (c) 2006 by Jing Min Zhao <zhaojingmin@users.sourceforge.net>
> diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
> index 4d6bf7ac0792..6bdb1ab8af61 100644
> --- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
> +++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
> @@ -416,8 +416,8 @@ clusterip_tg(struct sk_buff *skb, const struct xt_action_param *par)
>  	     ctinfo == IP_CT_RELATED_REPLY))
>  		return XT_CONTINUE;
>  
> -	/* ip_conntrack_icmp guarantees us that we only have ICMP_ECHO,
> -	 * TIMESTAMP, INFO_REQUEST or ADDRESS type icmp packets from here
> +	/* nf_conntrack_proto_icmp guarantees us that we only have ICMP_ECHO,
> +	 * TIMESTAMP, INFO_REQUEST or ICMP_ADDRESS type icmp packets from here
>  	 * on, which all have an ID field [relevant for hashing]. */
>  
>  	hash = clusterip_hashfn(skb, cipinfo->config);
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index f4f9b8344a32..fd7d317951d4 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -1817,7 +1817,7 @@ EXPORT_SYMBOL_GPL(nf_ct_kill_acct);
>  #include <linux/mutex.h>
>  
>  /* Generic function for tcp/udp/sctp/dccp and alike. This needs to be
> - * in ip_conntrack_core, since we don't want the protocols to autoload
> + * in nf_conntrack_core, since we don't want the protocols to autoload
>   * or depend on ctnetlink */
>  int nf_ct_port_tuple_to_nlattr(struct sk_buff *skb,
>  			       const struct nf_conntrack_tuple *tuple)
> diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
> index 8f6ba8162f0b..e86b12bd19ed 100644
> --- a/net/netfilter/nf_conntrack_h323_asn1.c
> +++ b/net/netfilter/nf_conntrack_h323_asn1.c
> @@ -1,11 +1,11 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  /*
> - * ip_conntrack_helper_h323_asn1.c - BER and PER decoding library for H.323
> + * nf_conntrack_helper_h323_asn1.c - BER and PER decoding library for H.323
>   * 			      	     conntrack/NAT module.
>   *
>   * Copyright (c) 2006 by Jing Min Zhao <zhaojingmin@users.sourceforge.net>
>   *
> - * See ip_conntrack_helper_h323_asn1.h for details.
> + * See nf_conntrack_helper_h323_asn1.h for details.
>   */
>  
>  #ifdef __KERNEL__
> diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
> index c2eb365f1723..ceb492a418c1 100644
> --- a/net/netfilter/nf_conntrack_proto_gre.c
> +++ b/net/netfilter/nf_conntrack_proto_gre.c
> @@ -1,6 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  /*
> - * ip_conntrack_proto_gre.c - Version 3.0
> + * nf_conntrack_proto_gre.c - Version 3.0
>   *
>   * Connection tracking protocol helper module for GRE.
>   *
> diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
> index a824367ed518..5f37aff3b2a9 100644
> --- a/net/netfilter/nf_conntrack_proto_icmp.c
> +++ b/net/netfilter/nf_conntrack_proto_icmp.c
> @@ -215,7 +215,7 @@ int nf_conntrack_icmpv4_error(struct nf_conn *tmpl,
>  		return -NF_ACCEPT;
>  	}
>  
> -	/* See ip_conntrack_proto_tcp.c */
> +	/* See nf_conntrack_proto_tcp.c */
>  	if (state->net->ct.sysctl_checksum &&
>  	    state->hook == NF_INET_PRE_ROUTING &&
>  	    nf_ip_checksum(skb, state->hook, dataoff, 0)) {
> diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> index 9ab410455992..3f6023ed4966 100644
> --- a/net/netfilter/nf_nat_core.c
> +++ b/net/netfilter/nf_nat_core.c
> @@ -519,7 +519,7 @@ static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
>   * and NF_INET_LOCAL_OUT, we change the destination to map into the
>   * range. It might not be possible to get a unique tuple, but we try.
>   * At worst (or if we race), we will end up with a final duplicate in
> - * __ip_conntrack_confirm and drop the packet. */
> + * __nf_conntrack_confirm and drop the packet. */
>  static void
>  get_unique_tuple(struct nf_conntrack_tuple *tuple,
>  		 const struct nf_conntrack_tuple *orig_tuple,
