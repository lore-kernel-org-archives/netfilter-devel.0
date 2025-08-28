Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0F431064E
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Aug 2025 13:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756386381; cv=none; b=Ptjtf25GOTfnLQWBG6pxBxhaxXCWdzqLlloZc0+Hs8uMGHn+xbXWilbz2uSq+hF/8Q991Pk166lJic9rav/Y4Dh86NTYkYdJgQfP0KIMvovylOQYvx6CWjqfkB4MBQ5ZgpLHJjHYZsgxtLkMerlEO+AhNCVuV73T0n4D21akYec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756386381; c=relaxed/simple;
	bh=+x8GV3MlVYZU6dctIgXwpgxqo5BzRwhTz6X5RCezpc0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NFNVS1Kk9GAJWG6vBp3DlFPDIwgkFKmjKII18HqB3XsUr1kqW/rWBckG1U78EFMFFpDAFSpw+sD0MezLFV4aKZ4IFYA2Gj5R42BbYy29tCgWEZuu8BwNc5kOX/nm07PG5EGgkr+GkJwChuz7RZASEOklF9wlTFEIIIFfxzVal2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tgbjfp3+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yXsOXDcd; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tgbjfp3+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yXsOXDcd; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tgbjfp3+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yXsOXDcd";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tgbjfp3+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yXsOXDcd"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B12F522497;
	Thu, 28 Aug 2025 13:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756386377; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QxkUDnfSOk1Jrmqv8fwDbAZ3bnELpkBkShId2I/iRXs=;
	b=tgbjfp3+/3rLzzDTW/ofqzVj4mu7kD+7lPfk5dFf8DFbtPSlXEgrd4IXN8MiCqKmp+O6+k
	k7UiYVhxpyyGCxbFnKB6CU3qPi0InmKeWf5+dJbwclzA3j/JfhM6KB31hoMtq3KBfVp2l3
	rgJizfT/AYOb0RrMquGXQN06sfQCN/c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756386377;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QxkUDnfSOk1Jrmqv8fwDbAZ3bnELpkBkShId2I/iRXs=;
	b=yXsOXDcd4oZ59nUtagBi0GWyu+TG43u7C8iCk/S5dzw6B9XcBtLbcEmAjmOd7BK+pKh9cX
	OV3FHYhyokHXyOBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tgbjfp3+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yXsOXDcd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756386377; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QxkUDnfSOk1Jrmqv8fwDbAZ3bnELpkBkShId2I/iRXs=;
	b=tgbjfp3+/3rLzzDTW/ofqzVj4mu7kD+7lPfk5dFf8DFbtPSlXEgrd4IXN8MiCqKmp+O6+k
	k7UiYVhxpyyGCxbFnKB6CU3qPi0InmKeWf5+dJbwclzA3j/JfhM6KB31hoMtq3KBfVp2l3
	rgJizfT/AYOb0RrMquGXQN06sfQCN/c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756386377;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QxkUDnfSOk1Jrmqv8fwDbAZ3bnELpkBkShId2I/iRXs=;
	b=yXsOXDcd4oZ59nUtagBi0GWyu+TG43u7C8iCk/S5dzw6B9XcBtLbcEmAjmOd7BK+pKh9cX
	OV3FHYhyokHXyOBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7CE9413326;
	Thu, 28 Aug 2025 13:06:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HATRG0lUsGhPBwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 28 Aug 2025 13:06:17 +0000
Message-ID: <5c24f67e-744f-4114-8fcd-85b3e88809a4@suse.de>
Date: Thu, 28 Aug 2025 15:06:10 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf-next] netfilter: nft_payload: extend offset to 65535
 bytes
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
References: <20250828124831.4093-1-fmancera@suse.de>
 <aLBSYUfiL_HR_BJK@calendula>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aLBSYUfiL_HR_BJK@calendula>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:dkim,suse.de:email];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: B12F522497
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51

On 8/28/25 2:58 PM, Pablo Neira Ayuso wrote:
> On Thu, Aug 28, 2025 at 02:48:31PM +0200, Fernando Fernandez Mancera wrote:
>> In some situations 255 bytes offset is not enough to match or manipulate
>> the desired packet field. Increase the offset limit to 65535 or U16_MAX.
>>
>> In addition, the nla policy maximum value is not set anymore as it is
>> limited to s16. Instead, the maximum value is checked during the payload
>> expression initialization function.
>>
>> Tested with the nft command line tool.
>>
>> table ip filter {
>> 	chain output {
>> 		@nh,2040,8 set 0xff
>> 		@nh,524280,8 set 0xff
>> 		@nh,524280,8 0xff
>> 		@nh,2040,8 0xff
>> 	}
>> }
>>
>> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
>> ---
>>   include/net/netfilter/nf_tables_core.h |  2 +-
>>   net/netfilter/nft_payload.c            | 18 +++++++++++-------
>>   2 files changed, 12 insertions(+), 8 deletions(-)
>>
>> diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
>> index 6c2f483d9828..7644cfe9267d 100644
>> --- a/include/net/netfilter/nf_tables_core.h
>> +++ b/include/net/netfilter/nf_tables_core.h
>> @@ -73,7 +73,7 @@ struct nft_ct {
>>   
>>   struct nft_payload {
>>   	enum nft_payload_bases	base:8;
>> -	u8			offset;
>> +	u16			offset;
>>   	u8			len;
>>   	u8			dreg;
>>   };
>> diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
>> index 7dfc5343dae4..728a4c78775c 100644
>> --- a/net/netfilter/nft_payload.c
>> +++ b/net/netfilter/nft_payload.c
>> @@ -40,7 +40,7 @@ static bool nft_payload_rebuild_vlan_hdr(const struct sk_buff *skb, int mac_off,
>>   
>>   /* add vlan header into the user buffer for if tag was removed by offloads */
>>   static bool
>> -nft_payload_copy_vlan(u32 *d, const struct sk_buff *skb, u8 offset, u8 len)
>> +nft_payload_copy_vlan(u32 *d, const struct sk_buff *skb, u16 offset, u8 len)
>>   {
>>   	int mac_off = skb_mac_header(skb) - skb->data;
>>   	u8 *vlanh, *dst_u8 = (u8 *) d;
>> @@ -212,7 +212,7 @@ static const struct nla_policy nft_payload_policy[NFTA_PAYLOAD_MAX + 1] = {
>>   	[NFTA_PAYLOAD_SREG]		= { .type = NLA_U32 },
>>   	[NFTA_PAYLOAD_DREG]		= { .type = NLA_U32 },
>>   	[NFTA_PAYLOAD_BASE]		= { .type = NLA_U32 },
>> -	[NFTA_PAYLOAD_OFFSET]		= NLA_POLICY_MAX(NLA_BE32, 255),
>> +	[NFTA_PAYLOAD_OFFSET]		= { .type = NLA_BE32 },
> 
> Should this be
> 
>                                          NLA_POLICY_MAX(NLA_BE32, 65535),
> 
> ?
> 

Hi Pablo,

I don't think so. NLA_POLICY_MAX sets the nla_policy field "max" which 
is a 16 bit signed int (s16). Therefore, when doing 
NLA_POLICY_MAX(NLA_BE32, 65535) it triggers a warning as the max value 
set is actually "-1" in a s16.

This is why I decided to drop it. Let me know if I am missing something 
here..

> IIRC, NLA_POLICY_MAX(NLA_BE32, X) deprecates nft_parse_u32_check.
> 
>>   	[NFTA_PAYLOAD_LEN]		= NLA_POLICY_MAX(NLA_BE32, 255),
>>   	[NFTA_PAYLOAD_CSUM_TYPE]	= { .type = NLA_U32 },
>>   	[NFTA_PAYLOAD_CSUM_OFFSET]	= NLA_POLICY_MAX(NLA_BE32, 255),
>> @@ -797,7 +797,7 @@ static int nft_payload_csum_inet(struct sk_buff *skb, const u32 *src,
>>   
>>   struct nft_payload_set {
>>   	enum nft_payload_bases	base:8;
>> -	u8			offset;
>> +	u16			offset;
>>   	u8			len;
>>   	u8			sreg;
>>   	u8			csum_type;
>> @@ -812,7 +812,7 @@ struct nft_payload_vlan_hdr {
>>   };
>>   
>>   static bool
>> -nft_payload_set_vlan(const u32 *src, struct sk_buff *skb, u8 offset, u8 len,
>> +nft_payload_set_vlan(const u32 *src, struct sk_buff *skb, u16 offset, u8 len,
>>   		     int *vlan_hlen)
>>   {
>>   	struct nft_payload_vlan_hdr *vlanh;
>> @@ -940,14 +940,18 @@ static int nft_payload_set_init(const struct nft_ctx *ctx,
>>   				const struct nft_expr *expr,
>>   				const struct nlattr * const tb[])
>>   {
>> +	u32 csum_offset, offset, csum_type = NFT_PAYLOAD_CSUM_NONE;
>>   	struct nft_payload_set *priv = nft_expr_priv(expr);
>> -	u32 csum_offset, csum_type = NFT_PAYLOAD_CSUM_NONE;
>>   	int err;
>>   
>>   	priv->base        = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_BASE]));
>> -	priv->offset      = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_OFFSET]));
>>   	priv->len         = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_LEN]));
>>   
>> +	err = nft_parse_u32_check(tb[NFTA_PAYLOAD_OFFSET], U16_MAX, &offset);
>> +	if (err < 0)
>> +		return err;
>> +	priv->offset = offset;
> 
> Then, this nft_parse_u32_check() can go away.
> 
> IIRC, nft_parse_u32_check() was added before  NLA_POLICY_MAX(NLA_BE32, X)
> existed.
> 
> Can anyone please validate this claims?
> 
>> +
>>   	if (tb[NFTA_PAYLOAD_CSUM_TYPE])
>>   		csum_type = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_CSUM_TYPE]));
>>   	if (tb[NFTA_PAYLOAD_CSUM_OFFSET]) {
>> @@ -1069,7 +1073,7 @@ nft_payload_select_ops(const struct nft_ctx *ctx,
>>   	if (tb[NFTA_PAYLOAD_DREG] == NULL)
>>   		return ERR_PTR(-EINVAL);
>>   
>> -	err = nft_parse_u32_check(tb[NFTA_PAYLOAD_OFFSET], U8_MAX, &offset);
>> +	err = nft_parse_u32_check(tb[NFTA_PAYLOAD_OFFSET], U16_MAX, &offset);
>>   	if (err < 0)
>>   		return ERR_PTR(err);
>>   
>> -- 
>> 2.51.0
>>

