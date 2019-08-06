Return-Path: <SRS0=eApp=WC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CE33C433FF
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Aug 2019 10:44:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B93920818
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Aug 2019 10:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732571AbfHFKoM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Aug 2019 06:44:12 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:47850 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731922AbfHFKoL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Aug 2019 06:44:11 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1huwwr-0001Ts-65; Tue, 06 Aug 2019 12:44:09 +0200
Date:   Tue, 6 Aug 2019 12:44:09 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH RFC nf-next] Introducing stateful object update operation
Message-ID: <20190806104409.yt2cgmgohxyhokji@breakpoint.cc>
References: <20190806102945.728-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806102945.728-1-ffmancera@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fernando Fernandez Mancera <ffmancera@riseup.net> wrote:
> I have been thinking of a way to update a quota object. i.e raise or lower the
> quota limit of an existing object. I think it would be ideal to implement the
> operations of updating objects in the API in a generic way.
> 
> Therefore, we could easily give update support to each object type by adding an
> update operation in the "nft_object_ops" struct. This is a conceptual patch so
> it does not work.
> 
> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
> ---
>  include/net/netfilter/nf_tables.h        |  4 ++++
>  include/uapi/linux/netfilter/nf_tables.h |  2 ++
>  net/netfilter/nf_tables_api.c            | 22 ++++++++++++++++++++++
>  3 files changed, 28 insertions(+)
> 
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index 9b624566b82d..bd1e6c19d23f 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -1101,6 +1101,7 @@ struct nft_object_type {
>   *	@eval: stateful object evaluation function
>   *	@size: stateful object size
>   *	@init: initialize object from netlink attributes
> + *	@update: update object from netlink attributes
>   *	@destroy: release existing stateful object
>   *	@dump: netlink dump stateful object
>   */
> @@ -1112,6 +1113,9 @@ struct nft_object_ops {
>  	int				(*init)(const struct nft_ctx *ctx,
>  						const struct nlattr *const tb[],
>  						struct nft_object *obj);
> +	int				(*update)(const struct nft_ctx *ctx,
> +						  const struct nlattr *const tb[],
> +						  struct nft_object *obj);
>  	void				(*destroy)(const struct nft_ctx *ctx,
>  						   struct nft_object *obj);
>  	int				(*dump)(struct sk_buff *skb,
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index 82abaa183fc3..8b0a012e9177 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -92,6 +92,7 @@ enum nft_verdicts {
>   * @NFT_MSG_NEWOBJ: create a stateful object (enum nft_obj_attributes)
>   * @NFT_MSG_GETOBJ: get a stateful object (enum nft_obj_attributes)
>   * @NFT_MSG_DELOBJ: delete a stateful object (enum nft_obj_attributes)
> + * @NFT_MSG_UPDOBJ: update a stateful object (enum nft_obj_attributes)
>   * @NFT_MSG_GETOBJ_RESET: get and reset a stateful object (enum nft_obj_attributes)
>   * @NFT_MSG_NEWFLOWTABLE: add new flow table (enum nft_flowtable_attributes)
>   * @NFT_MSG_GETFLOWTABLE: get flow table (enum nft_flowtable_attributes)
> @@ -119,6 +120,7 @@ enum nf_tables_msg_types {
>  	NFT_MSG_NEWOBJ,
>  	NFT_MSG_GETOBJ,
>  	NFT_MSG_DELOBJ,
> +	NFT_MSG_UPDOBJ,

This breaks ABI, new enums need to be added at the end.

But I wonder if we can't just re-use NEWOBJ and teach it to update
the object if it exists already.

Userspace can already pass EXCL flag to bail out for the 'exists' case.

I agree that such feature (object update) is a good idea.
