Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8702826B2AD
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Mar 2026 20:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774904277; cv=none; b=Dno5gwzZD0wJ2gWL621LuTQC6lvQrZ/ScT8rijFnBJZ7WQIsu0uGrXnMDicJXPCTRLqJP3XczP36PmpSWCgXycFYC2FUAPNhdAGQgVHtUf/U/DA/Xf3f6dg7Wlu5dJhs3RPxpI8aDKGEs21niHzZmQFjJcbKPv1xzGzqvVdCK38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774904277; c=relaxed/simple;
	bh=JaMrL7lC6+aLXX5tQHJJYAGtD37CXoJLYo9WGS+M1QI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nr7Z/0co4PuCRkliVq4w9a48v8bO7ZcF+hrAFZVWvDAqmn9drUpBVT/VLZjd4xeWlK+ovtDJ3WTYAHIfej3aGuIfd0TMQHMk5tPCgARpxpE7lB5ExAPRyU6MJAFuIVCa6/ySie/aGi4GvLQ2f4E0uAoM6WesioEgqn0TA5wsrZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xsv94jsK; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=TVTXZvPp; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DwMdDQug; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ieZPkYsj; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xsv94jsK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="TVTXZvPp";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DwMdDQug";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ieZPkYsj"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 957465BD67;
	Mon, 30 Mar 2026 20:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774904274; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uR/oix3JsfagVJTlxQfxETZ5nBQJRFuFMR7PhhHjCLo=;
	b=xsv94jsKszEDp5yoxFQ4p5FsxAH0JqKxAbpaA8mIAOQlc3OC8G2TWm7z0raJRZZj7DpcqD
	WoIzdBnSY6ltKjv2GHtFFfXXwxxUk+JyLpKm6PBeBayFi85iX9aPoxa66DrWEtBUI9GhcJ
	49FnDfXCrZzHTF5cII27/4d6ZKtJ6IU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774904274;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uR/oix3JsfagVJTlxQfxETZ5nBQJRFuFMR7PhhHjCLo=;
	b=TVTXZvPp8WDQqdEsrPscCVa0B1oquHLExO8Sa0nrutVTU9DwswO/8O4TLZTsFoElkr7aPF
	3kyEvoGINbBb1cDA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774904273; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uR/oix3JsfagVJTlxQfxETZ5nBQJRFuFMR7PhhHjCLo=;
	b=DwMdDQugKxwPq0c+IENg8Ok09ccR9V1nqYYrPphg518nEOI92FntttiWUBKmOyKDMp6jU/
	Mb7Vld0OhcZzNLNe7ZxRqW79Ey/3pvy3pbzLEf1O2urmM1gPfGTS6/iZtTCRQ447bqMisG
	4JndcL2OpkWRcWjOY2yfnD+cm8q/ic8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774904273;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uR/oix3JsfagVJTlxQfxETZ5nBQJRFuFMR7PhhHjCLo=;
	b=ieZPkYsjqqFvBrzxlSu19oCBsBdBFAJoqoXjc05uWFeonojqakCkAfAwJamYlmmG/XlMFj
	ENcxpDnCZo1eC3Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4C5A04A0A2;
	Mon, 30 Mar 2026 20:57:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id z/LvDtHjymkMZQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 30 Mar 2026 20:57:53 +0000
Message-ID: <7c0c962a-aca2-432e-855b-e4b2d3a8a80d@suse.de>
Date: Mon, 30 Mar 2026 22:57:52 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf,v4] netfilter: ctnetlink: ignore explicit helper on new
 expectations
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, ffmancera@suse.de
References: <20260330143627.892413-1-pablo@netfilter.org>
 <609becce-893f-43ea-ac1b-dbfd11a7e60d@suse.de> <acrSzf1HIUhy8DTf@chamomile>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <acrSzf1HIUhy8DTf@chamomile>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email,netfilter.org:email]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 3/30/26 9:45 PM, Pablo Neira Ayuso wrote:
> On Mon, Mar 30, 2026 at 05:46:16PM +0200, Fernando Fernandez Mancera wrote:
>> On 3/30/26 4:36 PM, Pablo Neira Ayuso wrote:
>>> Use the existing master conntrack helper, anything else is not really
>>> supported and it just makes validation more complicated, so just ignore
>>> what helper userspace suggests for this expectation.
>>>
>>> This was uncovered when validating CTA_EXPECT_CLASS via different helper
>>> provided by userspace than the existing master conntrack helper:
>>>
>>>     BUG: KASAN: slab-out-of-bounds in nf_ct_expect_related_report+0x2479/0x27c0
>>>     Read of size 4 at addr ffff8880043fe408 by task poc/102
>>>     Call Trace:
>>>      nf_ct_expect_related_report+0x2479/0x27c0
>>>      ctnetlink_create_expect+0x22b/0x3b0
>>>      ctnetlink_new_expect+0x4bd/0x5c0
>>>      nfnetlink_rcv_msg+0x67a/0x950
>>>      netlink_rcv_skb+0x120/0x350
>>>
>>> Allowing to read kernel memory bytes off the expectation boundary.
>>>
>>> CTA_EXPECT_HELP_NAME is still used to offer the helper name to userspace
>>> via netlink dump.
>>>
>>> Fixes: bd0779370588 ("netfilter: nfnetlink_queue: allow to attach expectations to conntracks")
>>> Reported-by: Qi Tang <tpluszz77@gmail.com>
>>> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>>> ---
>>> v4: actually... remove this entire refetch
>>>
>>> @@ -3576,8 +3569,6 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
>>>    #ifdef CONFIG_NF_CONNTRACK_ZONES
>>>           exp->zone = ct->zone;
>>>    #endif
>>> -       if (!helper)
>>> -               helper = rcu_dereference(help->helper);
>>>           rcu_assign_pointer(exp->helper, helper);
>>>           exp->tuple = *tuple;
>>>           exp->mask.src.u3 = mask->src.u3;
>>>
>>
>> Just a note, I spend some time trying to apply the patch due to this. Drop
>> it before running git am if you are experiencing the same problem.
>>
>>>
>>>    net/netfilter/nf_conntrack_netlink.c | 54 +++++-----------------------
>>>    1 file changed, 9 insertions(+), 45 deletions(-)
>>>
>>> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
>>> index 35f859b24103..ec6771a0926c 100644
>>> --- a/net/netfilter/nf_conntrack_netlink.c
>>> +++ b/net/netfilter/nf_conntrack_netlink.c
>>> @@ -2636,7 +2636,6 @@ static const struct nla_policy exp_nla_policy[CTA_EXPECT_MAX+1] = {
>>>    static struct nf_conntrack_expect *
>>>    ctnetlink_alloc_expect(const struct nlattr *const cda[], struct nf_conn *ct,
>>> -		       struct nf_conntrack_helper *helper,
>>>    		       struct nf_conntrack_tuple *tuple,
>>>    		       struct nf_conntrack_tuple *mask);
>>> @@ -2865,7 +2864,6 @@ ctnetlink_glue_attach_expect(const struct nlattr *attr, struct nf_conn *ct,
>>>    {
>>>    	struct nlattr *cda[CTA_EXPECT_MAX+1];
>>>    	struct nf_conntrack_tuple tuple, mask;
>>> -	struct nf_conntrack_helper *helper = NULL;
>>>    	struct nf_conntrack_expect *exp;
>>>    	int err;
>>> @@ -2879,17 +2877,8 @@ ctnetlink_glue_attach_expect(const struct nlattr *attr, struct nf_conn *ct,
>>>    	if (err < 0)
>>>    		return err;
>>> -	if (cda[CTA_EXPECT_HELP_NAME]) {
>>> -		const char *helpname = nla_data(cda[CTA_EXPECT_HELP_NAME]);
>>> -
>>> -		helper = __nf_conntrack_helper_find(helpname, nf_ct_l3num(ct),
>>> -						    nf_ct_protonum(ct));
>>> -		if (helper == NULL)
>>> -			return -EOPNOTSUPP;
>>> -	}
>>> -
>>
>> I wonder if we should return -EOPNOTSUPP here and be explicit about it.
> 
> You mean:
> 
>          if (cda[CTA_EXPECT_HELP_NAME])
>                  return -EOPNOTSUPP;
> 
> I cannot do it, there is at least one userspace conntrack helper that
> would break (ssdp).
> 

Ah, I was not aware of it sorry.

>> I know the rule is "do not break userspace" but as you mentioned on the
>> commit message, this was not really supported. Better just explicitly fail
>> so if by any chance someone expects this to work, they will notice.
> 
> What I could do is to check if the helper name specified by
> CTA_EXPECT_HELP_NAME is the same as the master conntrack helper. But
> then I have to keep this code only to validate that expectation is
> using. And this attribute has been an optional attribute this far,
> userspace could just skip it.
> 
> I could only find one conntrack helper in userspace that sets on this
> attribute (ssdp), and it is setting it to the same helper that the
> master conntrack is using.
> 
> I think it is not worth the effort, simply removing this code to fix
> this issue should be fine, this simplifies this control plane path.
> 

I think you are right. Thanks for explaining. Then, it looks good to me.

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

