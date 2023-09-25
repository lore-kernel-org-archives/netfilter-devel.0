Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4829CE7A94
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Sep 2023 11:01:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjIYLCC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Sep 2023 07:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjIYLCB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Sep 2023 07:02:01 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1661FAB
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Sep 2023 04:01:55 -0700 (PDT)
Received: from [78.30.34.192] (port=40700 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qkjLb-00Fyih-5O; Mon, 25 Sep 2023 13:01:53 +0200
Date:   Mon, 25 Sep 2023 13:01:50 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nf PATCH 2/5] netfilter: nf_tables: Add locking for
 NFT_MSG_GETRULE_RESET requests
Message-ID: <ZRFonqx3/lTef9gA@calendula>
References: <20230923013807.11398-1-phil@nwl.cc>
 <20230923013807.11398-3-phil@nwl.cc>
 <ZRFlgxT2cSoo0QjX@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZRFlgxT2cSoo0QjX@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Sep 25, 2023 at 12:48:35PM +0200, Pablo Neira Ayuso wrote:
> On Sat, Sep 23, 2023 at 03:38:04AM +0200, Phil Sutter wrote:
> [...]
> > +static int nf_tables_getrule_reset(struct sk_buff *skb,
> > +				   const struct nfnl_info *info,
> > +				   const struct nlattr * const nla[])
> > +{
> > +	struct nftables_pernet *nft_net = nft_pernet(info->net);
> > +	u8 family = info->nfmsg->nfgen_family;
> > +	u32 portid = NETLINK_CB(skb).portid;
> > +	char *tablename, *buf;
> > +	struct sk_buff *skb2;
> > +
> > +	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
> > +		struct netlink_dump_control c = {
> > +			.start= nf_tables_dumpreset_rules_start,
> > +			.dump = nf_tables_dumpreset_rules,
> > +			.done = nf_tables_dump_rules_done,
> > +			.module = THIS_MODULE,
> > +			.data = (void *)nla,
> > +		};
> > +
> > +		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
> > +	}
> > +
> > +	if (!nla[NFTA_RULE_TABLE])
> > +		return -EINVAL;
> > +
> > +	tablename = nla_strdup(nla[NFTA_RULE_TABLE], GFP_ATOMIC);
> > +	if (!tablename)
> > +		return -ENOMEM;
> > +
> > +	spin_lock(&nft_net->reset_lock);
> > +	skb2 = nf_tables_getrule_single(portid, info, nla, true);
> > +	spin_unlock(&nft_net->reset_lock);
> > +	if (IS_ERR(skb2))
> 
> This leaks tablename?

Florian already reported this one, apologies.
