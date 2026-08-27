Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F5E43E06A
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Aug 2026 10:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787826049; cv=none; b=NtUPhv9LKP3GoFW6frvOn6raYLavLF4dpyYOI4xuCcxDF/Wi7EuMrxqya2elWMFSVtiNQCqD7e4Tyg4dQKuCOqgbNsKhvYtzgOIgNljZf+ku59I35R8O2s0frp78U7MZkTVjim4Rh1bfgmoaHA7JOtoFwM9jjugtccdSDxxw4fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787826049; c=relaxed/simple;
	bh=nyUJBsZ5z5NSPRQIVxNAXptpwK6RirEMuB4AvldHixI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZXB7LIK16MChEQlk2XCGQarCta2VPZUeMEyRgmpO7xYxOWeoFBbgNAci9AUx1Rr5Cbazy1ltA5TFqvHOYyB3QmKR2iQ0pLwEkg8CY3HmPKOIp1I3JG1iByM9QuscCr7q5zdJg3u+Cc2+qxOR7/urlcLwa51AbCYpb4euyLT2Wuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=SZjrZCPG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BNdwemxA; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yajFplai; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/aq2DOUD; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="SZjrZCPG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BNdwemxA";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yajFplai";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/aq2DOUD"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 223F421250;
	Thu, 27 Aug 2026 10:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787826029; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8gFtsF595mks9IsXtlrFhPAU78B+HI8POInW2GH77kk=;
	b=SZjrZCPGGn63l/XbjTkudzBRgPY3IH4EnapzOulLc7IjZYkqjulF3kwgpWo0WgnrAAWJk3
	zzebh1E4gWC7CKFFqR3iPyyQl/+zLAHlY1zgx59xEhmJ6WiWxurzfim7iwyEzS3u3TGJuk
	+Kivdtbp3C4M6RCH5EqYUupSAcsEMjY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787826029;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8gFtsF595mks9IsXtlrFhPAU78B+HI8POInW2GH77kk=;
	b=BNdwemxA3bTlC4XAzJmQj+18bUvWTO6Orak3klaQRlHLpV0jDq8uT3LyjAbqeYveaSlZXs
	qSJr68C0fgtqDTDg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=yajFplai;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/aq2DOUD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787826025; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8gFtsF595mks9IsXtlrFhPAU78B+HI8POInW2GH77kk=;
	b=yajFplaiaL3nz2S2+NnGj9wI4qQBcj/qbUPtoLL2ujM99GSdpICH8jQ+rnc5PWk2lA8jGb
	yIkecodBSdPNhmukpbPv14J4fbzUrTZfZH6Sw4DNCjDvBOzfiW4MMEPBnZPzcwcLc0P/3P
	131nhUqAugMPcNMpikKGlM/51J3w2Rc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787826025;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8gFtsF595mks9IsXtlrFhPAU78B+HI8POInW2GH77kk=;
	b=/aq2DOUDu2kmpW8sDaaARmOBCE616JmWHFkeHcq8V+9P3bg+bAZGL1uQ9h17KyWKy4hHtP
	K5pYZqu/zfnbNIDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C103413354;
	Thu, 27 Aug 2026 10:20:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AhIuLGgPkGooLQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 27 Aug 2026 10:20:24 +0000
Message-ID: <9182712b-ec1a-49f8-88f9-642cb0cd5484@suse.de>
Date: Thu, 27 Aug 2026 12:19:46 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf v3] netfilter: nf_tables: fix device name and prefix
 match in hook lookup
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 pablo@netfilter.org, fw@strlen.de, Wei Fang <void0red@gmail.com>
References: <20260826133208.4550-1-fmancera@suse.de>
 <ao8SujdfOcqEJLUD@orbyte.nwl.cc>
 <ddea4e10-2aa9-4063-ab17-5c86d5ec7125@suse.de>
 <ao85SJiRW5JlieJs@orbyte.nwl.cc>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <ao85SJiRW5JlieJs@orbyte.nwl.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: 223F421250
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,netfilter.org,strlen.de,gmail.com];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO

On 8/26/26 9:06 PM, Phil Sutter wrote:
> On Wed, Aug 26, 2026 at 06:47:57PM +0200, Fernando Fernandez Mancera wrote:
>> On 8/26/26 6:22 PM, Phil Sutter wrote:
>>> On Wed, Aug 26, 2026 at 03:32:08PM +0200, Fernando Fernandez Mancera wrote:
>>>> Currently, a netdev chain or flowtable hooked to a device prefix can be
>>>> unintentionally deleted by a control-plane request targeting an exact
>>>> device name or even a shorter one due to the usage of min() to calculate
>>>> the length to match.
>>>>
>>>> Fix this by making sure an exact device match never matches a prefix and
>>>> that both the target and the candidate have the same length during
>>>> delete operation. The add and update paths retain the existing overlap
>>>> matching to prevent a single device from matching multiple hooks.
>>>>
>>>> Reported-by: Wei Fang <void0red@gmail.com>
>>>> Closes: https://lore.kernel.org/netfilter-devel/CANE+tVrDeNCHQVmsqkV2ozeBqyE3GtRDMhZgsg1bhw10yGNTRQ@mail.gmail.com/
>>>> Fixes: 6d07a289504a ("netfilter: nf_tables: Support wildcard netdev hook specs")
>>>> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
>>>> ---
>>>>    net/netfilter/nf_tables_api.c | 24 ++++++++++++++----------
>>>>    1 file changed, 14 insertions(+), 10 deletions(-)
>>>>
>>>> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
>>>> index c112ecc4fca3..9ef12feec1ac 100644
>>>> --- a/net/netfilter/nf_tables_api.c
>>>> +++ b/net/netfilter/nf_tables_api.c
>>>> @@ -1978,7 +1978,7 @@ static int nft_dump_stats(struct sk_buff *skb, struct nft_stats __percpu *stats)
>>>>    	return -ENOSPC;
>>>>    }
>>>>    
>>>> -static bool hook_is_prefix(struct nft_hook *hook)
>>>> +static bool hook_is_prefix(const struct nft_hook *hook)
>>>
>>> This is an unrelated change now.
>>>
>>
>> Oops, yes sorry.
>>
>>>>    {
>>>>    	return strlen(hook->ifname) >= hook->ifnamelen;
>>>>    }
>>>> @@ -2440,11 +2440,14 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
>>>>    }
>>>>    
>>>>    static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
>>>> -					   const struct nft_hook *this)
>>>> +					   const struct nft_hook *this,
>>>> +					   bool strict)
>>>>    {
>>>>    	struct nft_hook *hook;
>>>>    
>>>>    	list_for_each_entry(hook, hook_list, list) {
>>>> +		if (strict && hook->ifnamelen != this->ifnamelen)
>>>> +			continue;
>>>>    		if (!strncmp(hook->ifname, this->ifname,
>>>>    			     min(hook->ifnamelen, this->ifnamelen))) {
>>>>    			if (hook->flags & NFT_HOOK_REMOVE)
>>>> @@ -2486,7 +2489,7 @@ static int nf_tables_parse_netdev_hooks(struct net *net,
>>>>    			err = PTR_ERR(hook);
>>>>    			goto err_hook;
>>>>    		}
>>>> -		if (nft_hook_list_find(hook_list, hook)) {
>>>> +		if (nft_hook_list_find(hook_list, hook, false)) {
>>>>    			NL_SET_BAD_ATTR(extack, tmp);
>>>>    			nft_netdev_hook_free(hook);
>>>>    			err = -EEXIST;
>>>> @@ -2943,7 +2946,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
>>>>    					ops->hook	= basechain->ops.hook;
>>>>    				}
>>>>    
>>>> -				if (nft_hook_list_find(&basechain->hook_list, h)) {
>>>> +				if (nft_hook_list_find(&basechain->hook_list, h, false)) {
>>>
>>> I think this should be a strict match. It fixes a problem you didn't
>>> intend to fix (I feel like an LLM-reviewer now), when updating a chain
>>> with a partially matching wildcard:
>>>
>>> | add table netdev t
>>> | add chain netdev t c '{ type filter hook ingress priority 0; devices = { eth* }; }'
>>> | add chain netdev t c '{ type filter hook ingress priority 0; devices = { et* }; }'
>>>
>>> The last command should return EEXIST instead of being accepted and
>>> treated as a NOP.
>>
>> Hm. I am not so sure about it. Wouldn't that allow for overlapping
>> devices with prefixes?
> 
> You're right! I tested my concern with a flowtable, which behaves as I
> expected (so the strict lookup suggested below works as it should). With
> chains however, there is no duplicate hook check as for flowtables in
> nft_register_flowtable_net_hooks.
> 
> I think the policy was to allow multiple netdev chains on the same
> interface but not multiple flowtables. And IIRC, it wasn't clear whether
> this restriction is really needed (e.g. for hw offloading) or kept "just
> in case".
> 
> Either way, the duplicate hook check for flowtables just coincidentally
> happens to do what we need, namely reject non-strict matching hooks in
> the same flowtable/chain. This deserves a distinct lookup loop for both
> flowtables and chains IMO.
> 

I agree. I am sending a v4 of this patch removing the unrelated change 
and let's address the other problem in a follow-up to nf-next. We should 
likely unify this behavior between flowtables and chains.

> I'll look into that tomorrow and once I have something I'll also submit
> the test cases I wrote.
> 
>> Given this is not straightforward and we need to think a bit about it,
>> Pablo leave this out of the next PR to netdev. I am going to do a bit
>> more testing.
> 
> Sorry for putting obstacles in your way. :(

No need to apologize, you found interesting issues in the patch :)

Thanks,
Fernando.

> 
> Cheers, Phil
> 

