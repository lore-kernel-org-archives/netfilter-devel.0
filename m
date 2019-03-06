Return-Path: <SRS0=WT5G=RJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 613EFC10F00
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Mar 2019 17:49:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AFCF2087C
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Mar 2019 17:49:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="OWV+Ri0g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbfCFRtI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Mar 2019 12:49:08 -0500
Received: from mx1.riseup.net ([198.252.153.129]:53450 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726531AbfCFRtH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Mar 2019 12:49:07 -0500
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id A816D1A0A24;
        Wed,  6 Mar 2019 09:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1551894546; bh=tBygWtug1u7HPDUsSo0mMaZSk2iw8Pm4nCeHrG8uRSs=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=OWV+Ri0gDOIBnavN0BE3dM5yNLGN0D8NLAkMSCuDw+WLZuObUVHIMC36I93lVWwzC
         I28VmjICXG2MQk3mP32wrS9c8/HePM1BzWx+Rw0m+fqA+WgQq84t4rJ4zJu67ZzbqO
         Zm1gG/TA/z5ew/GR24fp2h3JgseVB+8HFbDWyhoU=
X-Riseup-User-ID: FE635F4919E306CA4FB22D3DE7C55A719F00BE9272CA50A4D3FEB0D3D7947A3F
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id E634E1207E6;
        Wed,  6 Mar 2019 09:49:05 -0800 (PST)
Subject: Re: [PATCH nf-next] netfilter: nft_osf: Add version option support
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <20190306124435.708-1-ffmancera@riseup.net>
 <20190306161502.ur4zm3arcdcfc6bn@salvia>
 <805cae0b-3458-5bf0-9be0-2698b90d097f@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <858f9d52-a270-ddbb-ec45-53cdaf5cbd59@riseup.net>
Date:   Wed, 6 Mar 2019 18:49:12 +0100
MIME-Version: 1.0
In-Reply-To: <805cae0b-3458-5bf0-9be0-2698b90d097f@riseup.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I have some notes, comments below. Thanks!

On 3/6/19 5:55 PM, Fernando Fernandez Mancera wrote:
> Sorry about the wrong mailing list, it was a mistake. I am fine with
> your comments so I am going to send a v2. Thanks.
> 
> On 3/6/19 5:15 PM, Pablo Neira Ayuso wrote:
>> Ups, wrong mailing list. For patches use
>> netfilter-devel@vger.kernel.org, so patchwork catches these patches:
>>
>> http://patchwork.ozlabs.org/project/netfilter-devel/list/
>>
>> Anyway, no worries, comments below.
>>
>> On Wed, Mar 06, 2019 at 01:44:35PM +0100, Fernando Fernandez Mancera wrote:
>>> Add version option support to the nftables "osf" expression.
>>>
>>> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
>>> ---
>>>  include/linux/netfilter/nfnetlink_osf.h  | 11 ++++++---
>>>  include/uapi/linux/netfilter/nf_tables.h |  6 +++++
>>>  net/netfilter/nfnetlink_osf.c            | 14 +++++------
>>>  net/netfilter/nft_osf.c                  | 31 ++++++++++++++++++++----
>>>  4 files changed, 47 insertions(+), 15 deletions(-)
>>>
>>> diff --git a/include/linux/netfilter/nfnetlink_osf.h b/include/linux/netfilter/nfnetlink_osf.h
>>> index c6000046c966..788613f36935 100644
>>> --- a/include/linux/netfilter/nfnetlink_osf.h
>>> +++ b/include/linux/netfilter/nfnetlink_osf.h
>>> @@ -21,13 +21,18 @@ struct nf_osf_finger {
>>>  	struct nf_osf_user_finger	finger;
>>>  };
>>>  
[...]
>>>  
>>>  #endif /* _NFOSF_H */
>>> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
>>> index a66c8de006cc..39bbb79ef4c2 100644
>>> --- a/include/uapi/linux/netfilter/nf_tables.h
>>> +++ b/include/uapi/linux/netfilter/nf_tables.h
>>> @@ -1522,15 +1522,21 @@ enum nft_flowtable_hook_attributes {
>>>   *
>>>   * @NFTA_OSF_DREG: destination register (NLA_U32: nft_registers)
>>>   * @NFTA_OSF_TTL: Value of the TTL osf option (NLA_U8)
>>> + * @NFTA_OSF_FLAGS: flags (NLA_U8)
>>
>> Please, use NLA_U32 for this.
>>

Do you mean all osf "flags" attribute right? So I am going to do the
proper changes in nft, libnftnl and nf-next.


[...]
>>> @@ -47,6 +57,7 @@ static int nft_osf_init(const struct nft_ctx *ctx,
>>>  			const struct nlattr * const tb[])
>>>  {
>>>  	struct nft_osf *priv = nft_expr_priv(expr);
>>> +	u8 flags;
>>>  	int err;
>>>  	u8 ttl;
>>>  
>>> @@ -57,6 +68,13 @@ static int nft_osf_init(const struct nft_ctx *ctx,
>>>  		priv->ttl = ttl;
>>>  	}
>>>  
>>> +	if (tb[NFTA_OSF_FLAGS]) {
>>> +		flags = nla_get_u8(tb[NFTA_OSF_FLAGS]);
>>
>> If you turn this into a NLA_U32, then you have to use here.
>>
>>                 flags = ntohl(nla_get_be32(tb[NFTA_OSF_FLAGS]));
>>
>>> +		if (flags != NFT_OSF_F_VERSION && flags != 0)
>>
>> No need to restrict flags != 0, remove that part of the check.
>>

I think we need this restriction because if we do not set "version"
option the "flags" value is 0. If we remove that part of the check we
are forcing to use "version" option always.

>>> +			return -EINVAL;
>>> +		priv->flags = flags;
>>> +	}
>>> +
>>>  	priv->dreg = nft_parse_register(tb[NFTA_OSF_DREG]);
>>>  	err = nft_validate_register_store(ctx, priv->dreg, NULL,
>>>  					  NFT_DATA_VALUE, NFT_OSF_MAXGENRELEN);
>>> @@ -73,6 +91,9 @@ static int nft_osf_dump(struct sk_buff *skb, const struct nft_expr *expr)
>>>  	if (nla_put_u8(skb, NFTA_OSF_TTL, priv->ttl))
>>>  		goto nla_put_failure;
>>>  
>>> +	if (nla_put_u8(skb, NFTA_OSF_FLAGS, priv->flags))
>>
>> And
>>         if (nla_put_be32(skb, NFTA_OSF_FLAGS, ntohl(priv->flags))
>>
>> here.
>>
>> Other than that, patch looks good!
>>
>>> +		goto nla_put_failure;
>>> +
>>>  	if (nft_dump_register(skb, NFTA_OSF_DREG, priv->dreg))
>>>  		goto nla_put_failure;
>>>  
>>> -- 
>>> 2.20.1
>>>
