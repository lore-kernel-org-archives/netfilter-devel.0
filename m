Return-Path: <SRS0=lxoE=WR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2BFDC3A59E
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 11:01:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CB5B22CF4
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 11:01:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="DTUU6BWT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbfHULBa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Aug 2019 07:01:30 -0400
Received: from mx1.riseup.net ([198.252.153.129]:52388 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726715AbfHULB3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Aug 2019 07:01:29 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 28D8B1A652C;
        Wed, 21 Aug 2019 04:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1566385289; bh=/RtQZMsXTbnLrb1EfHw2+J3CzbMjnWkzGuQOjlimtVM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=DTUU6BWT8XNM/NkGV+qxrspSzZzy3Lx3oXPWttQwYujzdz3gvOmdKwAOR3hH16WyT
         U3Bk+fJTKe9oq5aeaPwoT1h3bWWA9dcwHfl1XNf8d2VtTfwS+GNUZdilVqEakvYyxS
         JpVChrHtwHTmEzT6P4AXEE35/aJkxgYWUYVBD4Yk=
X-Riseup-User-ID: 7BECC84F222DC55E45DF7F3B3CDC581419C7B4A117D48E86E979153FA8F0AFB0
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 4138B1203F2;
        Wed, 21 Aug 2019 04:01:27 -0700 (PDT)
Subject: Re: [PATCH 1/2 nf-next] netfilter: nf_tables: Introduce stateful
 object update operation
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
References: <20190821094420.866-1-ffmancera@riseup.net>
 <20190821100905.GX2588@breakpoint.cc>
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <17f338ec-fe44-3ba7-3115-4b5f16d93ccf@riseup.net>
Date:   Wed, 21 Aug 2019 13:01:40 +0200
MIME-Version: 1.0
In-Reply-To: <20190821100905.GX2588@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 8/21/19 12:09 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <ffmancera@riseup.net> wrote:
>> This patch adds the infrastructure needed for the stateful object update
>> support.
>>
>> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
>> ---
>>  include/net/netfilter/nf_tables.h |  6 +++
>>  net/netfilter/nf_tables_api.c     | 71 ++++++++++++++++++++++++++++---
>>  2 files changed, 70 insertions(+), 7 deletions(-)
>>
>> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
>> index dc301e3d6739..dc4e32040ea9 100644
>> --- a/include/net/netfilter/nf_tables.h
>> +++ b/include/net/netfilter/nf_tables.h
>> @@ -1123,6 +1123,9 @@ struct nft_object_ops {
>>  	int				(*dump)(struct sk_buff *skb,
>>  						struct nft_object *obj,
>>  						bool reset);
>> +	int				(*update)(const struct nft_ctx *ctx,
>> +						  const struct nlattr *const tb[],
>> +						  struct nft_object *obj);
> 
> maybe adda 'bool commit' argument here.
> 

How is that argument going to be used? If 'commit' is false we should
just check that values are fine but not update them?

>> +	err = obj->ops->update(ctx, (const struct nlattr * const *)tb, obj);
> 
> Then, set it to 'false' here.
> You would have to keep 'tb' allocated and place it on the 'trans'
> object.
> 
Yes, I agree on updating the object in the commit phase. But I am not
sure about how I should place it on 'trans'. Any hints? Thanks :-)

I am also writing some userspace shell tests.

>> +	nft_trans_obj_update(trans) = true;
> 
> 	nft_trans_obj_update_tb(trans) = tb;
> 
>> -			nft_clear(net, nft_trans_obj(trans));
>> -			nf_tables_obj_notify(&trans->ctx, nft_trans_obj(trans),
>> -					     NFT_MSG_NEWOBJ);
>> -			nft_trans_destroy(trans);
>> +			if (nft_trans_obj_update(trans)) {
> 
> 				nft_trans_obj(trans)->ops->update(&trans->ctx,
> 					      nft_trans_obj_update_tb(trans),
> 					      nft_trans_obj(trans),
> 					      true);
> 
> 				kfree(nft_trans_obj_update_tb(trans));
> 
> 
> Because otherwise we will update objects while we're not yet sure that
> we can process/handle the entire batch.
> 
> I think we should, if possible, only update once we've made it to
> the commit phase.
> 
