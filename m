Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04912C56201
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Nov 2020 00:44:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94733207BC
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Nov 2020 00:44:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbgKZAom (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Nov 2020 19:44:42 -0500
Received: from correo.us.es ([193.147.175.20]:38914 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgKZAom (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Nov 2020 19:44:42 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0D392EB467
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2020 01:44:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EE09DDA722
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2020 01:44:39 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E3907DA730; Thu, 26 Nov 2020 01:44:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8A0AADA722;
        Thu, 26 Nov 2020 01:44:37 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 26 Nov 2020 01:44:37 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6BAB541FF201;
        Thu, 26 Nov 2020 01:44:37 +0100 (CET)
Date:   Thu, 26 Nov 2020 01:44:37 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v2 1/2] netfilter: nftables_offload: set address type
 in control dissector
Message-ID: <20201126004437.GA24061@salvia>
References: <20201125230446.28691-1-pablo@netfilter.org>
 <20201125152147.6f643149@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201125152147.6f643149@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jakub,

On Wed, Nov 25, 2020 at 03:21:47PM -0800, Jakub Kicinski wrote:
> On Thu, 26 Nov 2020 00:04:45 +0100 Pablo Neira Ayuso wrote:
> > This patch adds nft_flow_rule_set_addr_type() to set the address type
> > from the nft_payload expression accordingly.
> > 
> > If the address type is not set in the control dissector then a rule that
> > matches either source or destination IP address does not work.
> > 
> > After this patch, nft hardware offload generates the flow dissector
> > configuration as tc-flower to match on an IP address.
> > 
> > This patch has been also tested functionally to make sure packets are
> > filtered out by the NIC.
> > 
> > This is also getting the code aligned with the existing netfilter flow
> > offload infrastructure which is also setting the control dissector.
> > 
> > Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware offload support")
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > v2: add a nice patch description and remove unnecessary EXPORT_SYMBOL()
> >     per Jakub Kicinski.
> > 
> >  include/net/netfilter/nf_tables_offload.h |  4 ++++
> >  net/netfilter/nf_tables_offload.c         | 17 +++++++++++++++++
> >  net/netfilter/nft_payload.c               |  4 ++++
> >  3 files changed, 25 insertions(+)
> > 
> > diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
> > index ea7d1d78b92d..bddd34c5bd79 100644
> > --- a/include/net/netfilter/nf_tables_offload.h
> > +++ b/include/net/netfilter/nf_tables_offload.h
> > @@ -37,6 +37,7 @@ void nft_offload_update_dependency(struct nft_offload_ctx *ctx,
> >  
> >  struct nft_flow_key {
> >  	struct flow_dissector_key_basic			basic;
> > +	struct flow_dissector_key_control		control;
> >  	union {
> >  		struct flow_dissector_key_ipv4_addrs	ipv4;
> >  		struct flow_dissector_key_ipv6_addrs	ipv6;
> > @@ -62,6 +63,9 @@ struct nft_flow_rule {
> >  
> >  #define NFT_OFFLOAD_F_ACTION	(1 << 0)
> >  
> > +void nft_flow_rule_set_addr_type(struct nft_flow_rule *flow,
> > +				 enum flow_dissector_key_id addr_type);
> > +
> >  struct nft_rule;
> >  struct nft_flow_rule *nft_flow_rule_create(struct net *net, const struct nft_rule *rule);
> >  void nft_flow_rule_destroy(struct nft_flow_rule *flow);
> > diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
> > index 9f625724a20f..9ae14270c543 100644
> > --- a/net/netfilter/nf_tables_offload.c
> > +++ b/net/netfilter/nf_tables_offload.c
> > @@ -28,6 +28,23 @@ static struct nft_flow_rule *nft_flow_rule_alloc(int num_actions)
> >  	return flow;
> >  }
> >  
> > +void nft_flow_rule_set_addr_type(struct nft_flow_rule *flow,
> > +				 enum flow_dissector_key_id addr_type)
> > +{
> > +	struct nft_flow_match *match = &flow->match;
> > +	struct nft_flow_key *mask = &match->mask;
> > +	struct nft_flow_key *key = &match->key;
> > +
> > +	if (match->dissector.used_keys & BIT(FLOW_DISSECTOR_KEY_CONTROL))
> > +		return;
> > +
> > +	key->control.addr_type = addr_type;
> > +	mask->control.addr_type = 0xffff;
> > +	match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_CONTROL);
> > +	match->dissector.offset[FLOW_DISSECTOR_KEY_CONTROL] =
> > +		offsetof(struct nft_flow_key, control);
> > +}
> > +
> >  struct nft_flow_rule *nft_flow_rule_create(struct net *net,
> >  					   const struct nft_rule *rule)
> >  {
> > diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
> > index dcd3c7b8a367..bbf811d030d5 100644
> > --- a/net/netfilter/nft_payload.c
> > +++ b/net/netfilter/nft_payload.c
> > @@ -244,6 +244,7 @@ static int nft_payload_offload_ip(struct nft_offload_ctx *ctx,
> >  
> >  		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4, src,
> >  				  sizeof(struct in_addr), reg);
> > +		nft_flow_rule_set_addr_type(flow, FLOW_DISSECTOR_KEY_IPV4_ADDRS);
> >  		break;
> >  	case offsetof(struct iphdr, daddr):
> >  		if (priv->len != sizeof(struct in_addr))
> > @@ -251,6 +252,7 @@ static int nft_payload_offload_ip(struct nft_offload_ctx *ctx,
> >  
> >  		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4, dst,
> >  				  sizeof(struct in_addr), reg);
> > +		nft_flow_rule_set_addr_type(flow, FLOW_DISSECTOR_KEY_IPV4_ADDRS);
> >  		break;
> >  	case offsetof(struct iphdr, protocol):
> >  		if (priv->len != sizeof(__u8))
> > @@ -280,6 +282,7 @@ static int nft_payload_offload_ip6(struct nft_offload_ctx *ctx,
> >  
> >  		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV6_ADDRS, ipv6, src,
> >  				  sizeof(struct in6_addr), reg);
> > +		nft_flow_rule_set_addr_type(flow, FLOW_DISSECTOR_KEY_IPV6_ADDRS);
> >  		break;
> >  	case offsetof(struct ipv6hdr, daddr):
> >  		if (priv->len != sizeof(struct in6_addr))
> > @@ -287,6 +290,7 @@ static int nft_payload_offload_ip6(struct nft_offload_ctx *ctx,
> >  
> >  		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV6_ADDRS, ipv6, dst,
> >  				  sizeof(struct in6_addr), reg);
> > +		nft_flow_rule_set_addr_type(flow, FLOW_DISSECTOR_KEY_IPV6_ADDRS);
> >  		break;
> >  	case offsetof(struct ipv6hdr, nexthdr):
> >  		if (priv->len != sizeof(__u8))
> 
> Still worries me this is done in a response to a match.
> 
> skb_flow_dissector_init() has a straight up BUG_ON() if the dissector
> did not set the CONTROL or BASIC. It says in the comment that both must
> be initialized. But nft does not call skb_flow_dissector_init()?
> 
> Are you 100% sure all cases will set CONTROL and BASIC now?

Enforcing skb_flow_dissector_init() for software make sense, but in
Netfilter this is used for hardware offload only.

All drivers in the tree check for:

        if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CONTROL))

before accessing struct flow_match_control.

I can set it on inconditionally, but the driver will get a value 0x0
and mask 0x0, which is the same as leaving it unset.
