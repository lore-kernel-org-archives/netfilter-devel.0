Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A726C0032E
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Oct 2023 20:59:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjJYU7z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Oct 2023 16:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjJYU7z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2023 16:59:55 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6481132
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Oct 2023 13:59:52 -0700 (PDT)
Received: from [78.30.35.151] (port=43372 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qvklS-00Flsm-6k; Wed, 25 Oct 2023 22:46:08 +0200
Date:   Wed, 25 Oct 2023 22:46:04 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH v3 1/3] netfilter: nf_tables: Audit log dump
 reset after the fact
Message-ID: <ZTl+jIRe0ODMtI5F@calendula>
References: <20231025200828.5482-1-phil@nwl.cc>
 <20231025200828.5482-2-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231025200828.5482-2-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 25, 2023 at 10:08:26PM +0200, Phil Sutter wrote:
> In theory, dumpreset may fail and invalidate the preceeding log message.
> Fix this and use the occasion to prepare for object reset locking, which
> benefits from a few unrelated changes:
> 
> * Add an early call to nfnetlink_unicast if not resetting which
>   effectively skips the audit logging but also unindents it.
> * Extract the table's name from the netlink attribute (which is verified
>   via earlier table lookup) to not rely upon validity of the looked up
>   table pointer.
> * Do not use local variable family, it will vanish.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  net/netfilter/nf_tables_api.c | 28 +++++++++++++---------------
>  1 file changed, 13 insertions(+), 15 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 3c1fd8283bf4..d0f7274b7ffe 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -7767,6 +7767,7 @@ static int nf_tables_dump_obj_done(struct netlink_callback *cb)
>  static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
>  			    const struct nlattr * const nla[])
>  {
> +	const struct nftables_pernet *nft_net = nft_pernet(info->net);
>  	struct netlink_ext_ack *extack = info->extack;
>  	u8 genmask = nft_genmask_cur(info->net);
>  	u8 family = info->nfmsg->nfgen_family;
> @@ -7776,6 +7777,7 @@ static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
>  	struct sk_buff *skb2;
>  	bool reset = false;
>  	u32 objtype;
> +	char *buf;
>  	int err;
>  
>  	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
> @@ -7814,27 +7816,23 @@ static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
>  	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
>  		reset = true;
>  
> -	if (reset) {
> -		const struct nftables_pernet *nft_net;
> -		char *buf;
> -
> -		nft_net = nft_pernet(net);
> -		buf = kasprintf(GFP_ATOMIC, "%s:%u", table->name, nft_net->base_seq);
> -
> -		audit_log_nfcfg(buf,
> -				family,
> -				1,
> -				AUDIT_NFT_OP_OBJ_RESET,
> -				GFP_ATOMIC);
> -		kfree(buf);
> -	}
> -
>  	err = nf_tables_fill_obj_info(skb2, net, NETLINK_CB(skb).portid,
>  				      info->nlh->nlmsg_seq, NFT_MSG_NEWOBJ, 0,
>  				      family, table, obj, reset);
>  	if (err < 0)
>  		goto err_fill_obj_info;
>  
> +	if (!reset)
> +		return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);

More simple with?

        if (reset) {
        	buf = kasprintf(GFP_ATOMIC, "%.*s:%u",
        			nla_len(nla[NFTA_OBJ_TABLE]),
        			(char *)nla_data(nla[NFTA_OBJ_TABLE]),
        			nft_net->base_seq);
                                audit_log_nfcfg(buf, info->nfmsg->nfgen_family,
                                1, AUDIT_NFT_OP_OBJ_RESET, GFP_ATOMIC);
                kfree(buf);
        }

 	return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);

single call to nfnetlink_unicast().

> +
> +	buf = kasprintf(GFP_ATOMIC, "%.*s:%u",
> +			nla_len(nla[NFTA_OBJ_TABLE]),
> +			(char *)nla_data(nla[NFTA_OBJ_TABLE]),
> +			nft_net->base_seq);
> +	audit_log_nfcfg(buf, info->nfmsg->nfgen_family, 1,
> +			AUDIT_NFT_OP_OBJ_RESET, GFP_ATOMIC);
> +	kfree(buf);
> +
>  	return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
>  
>  err_fill_obj_info:
> -- 
> 2.41.0
> 
