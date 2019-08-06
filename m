Return-Path: <SRS0=eApp=WC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12017C433FF
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Aug 2019 11:07:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E717B20B1F
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Aug 2019 11:07:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731235AbfHFLHW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Aug 2019 07:07:22 -0400
Received: from correo.us.es ([193.147.175.20]:38700 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728845AbfHFLHV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Aug 2019 07:07:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 22C62C1DE1
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Aug 2019 13:07:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1396F512D2
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Aug 2019 13:07:19 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0937250F3F; Tue,  6 Aug 2019 13:07:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 02E8FDA704;
        Tue,  6 Aug 2019 13:07:16 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 06 Aug 2019 13:07:16 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (149.103.108.93.rev.vodafone.pt [93.108.103.149])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 718994265A32;
        Tue,  6 Aug 2019 13:07:15 +0200 (CEST)
Date:   Tue, 6 Aug 2019 13:06:48 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH RFC nf-next] Introducing stateful object update operation
Message-ID: <20190806110648.khukqwbmxgbk5yfr@salvia>
References: <20190806102945.728-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806102945.728-1-ffmancera@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 06, 2019 at 12:29:45PM +0200, Fernando Fernandez Mancera wrote:
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

No need for this new message type, see below.

>  	NFT_MSG_GETOBJ_RESET,
>  	NFT_MSG_NEWFLOWTABLE,
>  	NFT_MSG_GETFLOWTABLE,
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 605a7cfe7ca7..c7267f418808 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -5420,6 +5420,16 @@ static void nft_obj_destroy(const struct nft_ctx *ctx, struct nft_object *obj)
>  	kfree(obj);
>  }
>  
> +static int nf_tables_updobj(struct net *net, struct sock *nlsk,
> +			    struct sk_buff *skb, const struct nlmsghdr *nlh,
> +			    const struct nlattr * const nla[],
> +			    struct netlink_ext_ack *extack)
> +{
> +	/* Placeholder function, here we would need to check if the object
> +	 * exists. Then init the context and update the object.*/
> +	return 1;

Use the existing nf_tables_newobj(), if NLM_F_EXCL is not set on and
the object exists, then this is an update.
