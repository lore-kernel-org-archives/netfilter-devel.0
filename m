Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UPPERCASE_50_75 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD7BDC433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Mar 2021 16:31:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81A4D64DDD
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Mar 2021 16:31:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbhCRQbF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Mar 2021 12:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231833AbhCRQaj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Mar 2021 12:30:39 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F000C06174A;
        Thu, 18 Mar 2021 09:30:39 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1lMvXc-0001zd-0z; Thu, 18 Mar 2021 17:30:32 +0100
Date:   Thu, 18 Mar 2021 17:30:32 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>,
        Florian Westphal <fw@strlen.de>, twoerner@redhat.com,
        tgraf@infradead.org, dan.carpenter@oracle.com,
        Jones Desougi <jones.desougi+netfilter@gmail.com>
Subject: Re: [PATCH] audit: log nftables configuration change events once per
 table
Message-ID: <20210318163032.GS5298@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Richard Guy Briggs <rgb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>, Steve Grubb <sgrubb@redhat.com>,
        Florian Westphal <fw@strlen.de>, twoerner@redhat.com,
        tgraf@infradead.org, dan.carpenter@oracle.com,
        Jones Desougi <jones.desougi+netfilter@gmail.com>
References: <7e73ce4aa84b2e46e650b5727ee7a8244ec4a0ac.1616078123.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e73ce4aa84b2e46e650b5727ee7a8244ec4a0ac.1616078123.git.rgb@redhat.com>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Thu, Mar 18, 2021 at 11:39:52AM -0400, Richard Guy Briggs wrote:
> Reduce logging of nftables events to a level similar to iptables.
> Restore the table field to list the table, adding the generation.

This looks much better, a few remarks below:

[...]
> +static const u8 nft2audit_op[] = { // enum nf_tables_msg_types
> +	/* NFT_MSG_NEWTABLE	*/	AUDIT_NFT_OP_TABLE_REGISTER,
> +	/* NFT_MSG_GETTABLE	*/	AUDIT_NFT_OP_INVALID,
> +	/* NFT_MSG_DELTABLE	*/	AUDIT_NFT_OP_TABLE_UNREGISTER,
> +	/* NFT_MSG_NEWCHAIN	*/	AUDIT_NFT_OP_CHAIN_REGISTER,
> +	/* NFT_MSG_GETCHAIN	*/	AUDIT_NFT_OP_INVALID,
> +	/* NFT_MSG_DELCHAIN	*/	AUDIT_NFT_OP_CHAIN_UNREGISTER,
> +	/* NFT_MSG_NEWRULE	*/	AUDIT_NFT_OP_RULE_REGISTER,
> +	/* NFT_MSG_GETRULE	*/	AUDIT_NFT_OP_INVALID,
> +	/* NFT_MSG_DELRULE	*/	AUDIT_NFT_OP_RULE_UNREGISTER,
> +	/* NFT_MSG_NEWSET	*/	AUDIT_NFT_OP_SET_REGISTER,
> +	/* NFT_MSG_GETSET	*/	AUDIT_NFT_OP_INVALID,
> +	/* NFT_MSG_DELSET	*/	AUDIT_NFT_OP_SET_UNREGISTER,
> +	/* NFT_MSG_NEWSETELEM	*/	AUDIT_NFT_OP_SETELEM_REGISTER,
> +	/* NFT_MSG_GETSETELEM	*/	AUDIT_NFT_OP_INVALID,
> +	/* NFT_MSG_DELSETELEM	*/	AUDIT_NFT_OP_SETELEM_UNREGISTER,
> +	/* NFT_MSG_NEWGEN	*/	AUDIT_NFT_OP_GEN_REGISTER,
> +	/* NFT_MSG_GETGEN	*/	AUDIT_NFT_OP_INVALID,
> +	/* NFT_MSG_TRACE	*/	AUDIT_NFT_OP_INVALID,
> +	/* NFT_MSG_NEWOBJ	*/	AUDIT_NFT_OP_OBJ_REGISTER,
> +	/* NFT_MSG_GETOBJ	*/	AUDIT_NFT_OP_INVALID,
> +	/* NFT_MSG_DELOBJ	*/	AUDIT_NFT_OP_OBJ_UNREGISTER,
> +	/* NFT_MSG_GETOBJ_RESET	*/	AUDIT_NFT_OP_OBJ_RESET,
> +	/* NFT_MSG_NEWFLOWTABLE	*/	AUDIT_NFT_OP_FLOWTABLE_REGISTER,
> +	/* NFT_MSG_GETFLOWTABLE	*/	AUDIT_NFT_OP_INVALID,
> +	/* NFT_MSG_DELFLOWTABLE	*/	AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,
> +	/* NFT_MSG_MAX		*/	AUDIT_NFT_OP_INVALID,
> +};

NFT_MSG_MAX is itself not a valid message, it serves merely as an upper
bound for arrays, loops or sanity checks. You will never see it in
trans->msg_type.

Since enum nf_tables_msg_types contains consecutive values from 0 to
NFT_MSG_MAX, you could write the above more explicitly:

| static const u8 nft2audit_op[NFT_MSG_MAX] = {
| 	[NFT_MSG_NEWTABLE]	= AUDIT_NFT_OP_TABLE_REGISTER,
| 	[NFT_MSG_GETTABLE]	= AUDIT_NFT_OP_INVALID,
| 	[NFT_MSG_DELTABLE]	= AUDIT_NFT_OP_TABLE_UNREGISTER,
(And so forth.)

Not a must, but it clarifies the 1:1 mapping between index and said
enum. Sadly, AUDIT_NFT_OP_INVALID is non-zero. Otherwise one could skip
all uninteresting ones.

[...]
> @@ -6278,12 +6219,11 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
>  			    filter->type != NFT_OBJECT_UNSPEC &&
>  			    obj->ops->type->type != filter->type)
>  				goto cont;
> -
>  			if (reset) {
>  				char *buf = kasprintf(GFP_ATOMIC,
> -						      "%s:%llu;?:0",
> +						      "%s:%u",
>  						      table->name,
> -						      table->handle);
> +						      net->nft.base_seq);
>  
>  				audit_log_nfcfg(buf,
>  						family,

Why did you leave the object-related logs in place? They should reappear
at commit time just like chains and sets for instance, no?

Thanks, Phil
