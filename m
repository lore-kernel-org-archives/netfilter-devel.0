Return-Path: <SRS0=eApp=WC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3A23C433FF
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Aug 2019 13:40:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78B0D208C3
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Aug 2019 13:40:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="DeHr6Y5B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbfHFNkd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Aug 2019 09:40:33 -0400
Received: from mx1.riseup.net ([198.252.153.129]:42596 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbfHFNkc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Aug 2019 09:40:32 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 266741A0261;
        Tue,  6 Aug 2019 06:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1565098832; bh=Fpw4jEwGAoIFeBRJrWojj3e8FhDya2gpN2WjruAU+Qo=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=DeHr6Y5B7Q7jcrqfaX3POeLnzD+o6PLo3XFvoBUkjfc0rOAfZzo3i6ETggbkR6iyM
         rnQ2Hk/5fZtjdTkwR/kjQjuZLiPabwn+GshXiXTd+cD5yCsx+Od0i3P4vMgkBMHSEA
         NTytodcNlgJ8Cr+6fQC+Yr9jgo263xklkpQfGLl8=
X-Riseup-User-ID: F709CF4447E6A1478CA4660198B340FD97D4B0C074F303AC9E9F7FB24B72F5BC
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 7D282220151;
        Tue,  6 Aug 2019 06:40:31 -0700 (PDT)
Subject: Re: [PATCH RFC nf-next] Introducing stateful object update operation
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <20190806102945.728-1-ffmancera@riseup.net>
 <20190806110648.khukqwbmxgbk5yfr@salvia>
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <146bb849-c4cf-1c88-cacf-fa909a626cac@riseup.net>
Date:   Tue, 6 Aug 2019 15:40:45 +0200
MIME-Version: 1.0
In-Reply-To: <20190806110648.khukqwbmxgbk5yfr@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 8/6/19 1:06 PM, Pablo Neira Ayuso wrote:
> On Tue, Aug 06, 2019 at 12:29:45PM +0200, Fernando Fernandez Mancera wrote:
>> I have been thinking of a way to update a quota object. i.e raise or lower the
>> quota limit of an existing object. I think it would be ideal to implement the
>> operations of updating objects in the API in a generic way.
>>
>> Therefore, we could easily give update support to each object type by adding an
>> update operation in the "nft_object_ops" struct. This is a conceptual patch so
>> it does not work.
>>
>> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
>> ---
>>  include/net/netfilter/nf_tables.h        |  4 ++++
>>  include/uapi/linux/netfilter/nf_tables.h |  2 ++
>>  net/netfilter/nf_tables_api.c            | 22 ++++++++++++++++++++++
>>  3 files changed, 28 insertions(+)
>>
>> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
>> index 9b624566b82d..bd1e6c19d23f 100644
>> --- a/include/net/netfilter/nf_tables.h
>> +++ b/include/net/netfilter/nf_tables.h
>> @@ -1101,6 +1101,7 @@ struct nft_object_type {
>>   *	@eval: stateful object evaluation function
>>   *	@size: stateful object size
>>   *	@init: initialize object from netlink attributes
>> + *	@update: update object from netlink attributes
>>   *	@destroy: release existing stateful object
>>   *	@dump: netlink dump stateful object
>>   */
>> @@ -1112,6 +1113,9 @@ struct nft_object_ops {
>>  	int				(*init)(const struct nft_ctx *ctx,
>>  						const struct nlattr *const tb[],
>>  						struct nft_object *obj);
>> +	int				(*update)(const struct nft_ctx *ctx,
>> +						  const struct nlattr *const tb[],
>> +						  struct nft_object *obj);
>>  	void				(*destroy)(const struct nft_ctx *ctx,
>>  						   struct nft_object *obj);
>>  	int				(*dump)(struct sk_buff *skb,
>> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
>> index 82abaa183fc3..8b0a012e9177 100644
>> --- a/include/uapi/linux/netfilter/nf_tables.h
>> +++ b/include/uapi/linux/netfilter/nf_tables.h
>> @@ -92,6 +92,7 @@ enum nft_verdicts {
>>   * @NFT_MSG_NEWOBJ: create a stateful object (enum nft_obj_attributes)
>>   * @NFT_MSG_GETOBJ: get a stateful object (enum nft_obj_attributes)
>>   * @NFT_MSG_DELOBJ: delete a stateful object (enum nft_obj_attributes)
>> + * @NFT_MSG_UPDOBJ: update a stateful object (enum nft_obj_attributes)
>>   * @NFT_MSG_GETOBJ_RESET: get and reset a stateful object (enum nft_obj_attributes)
>>   * @NFT_MSG_NEWFLOWTABLE: add new flow table (enum nft_flowtable_attributes)
>>   * @NFT_MSG_GETFLOWTABLE: get flow table (enum nft_flowtable_attributes)
>> @@ -119,6 +120,7 @@ enum nf_tables_msg_types {
>>  	NFT_MSG_NEWOBJ,
>>  	NFT_MSG_GETOBJ,
>>  	NFT_MSG_DELOBJ,
>> +	NFT_MSG_UPDOBJ,
> 
> No need for this new message type, see below.
> 
>>  	NFT_MSG_GETOBJ_RESET,
>>  	NFT_MSG_NEWFLOWTABLE,
>>  	NFT_MSG_GETFLOWTABLE,
>> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
>> index 605a7cfe7ca7..c7267f418808 100644
>> --- a/net/netfilter/nf_tables_api.c
>> +++ b/net/netfilter/nf_tables_api.c
>> @@ -5420,6 +5420,16 @@ static void nft_obj_destroy(const struct nft_ctx *ctx, struct nft_object *obj)
>>  	kfree(obj);
>>  }
>>  
>> +static int nf_tables_updobj(struct net *net, struct sock *nlsk,
>> +			    struct sk_buff *skb, const struct nlmsghdr *nlh,
>> +			    const struct nlattr * const nla[],
>> +			    struct netlink_ext_ack *extack)
>> +{
>> +	/* Placeholder function, here we would need to check if the object
>> +	 * exists. Then init the context and update the object.*/
>> +	return 1;
> 
> Use the existing nf_tables_newobj(), if NLM_F_EXCL is not set on and
> the object exists, then this is an update.
> 

I agree on that. But I think that if we use the NFT_MSG_NEWOBJ there
will be some issues in the commit and the abort phase. That is why I
think "NFT_MSG_UPDOBJ" would be needed.

Thanks!
