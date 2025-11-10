Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD1C1EF0B9
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Nov 2025 21:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762810826; cv=none; b=StbCjUVTTIw7qvndLr35etPMwp8sTdMXUzxvOB05gxubGg5NPjD2voIWMEzmFYpPg9DrfbIkrQNB/7pq1CtdiTQyEyhwsRK+ybV8PgraSkZiSiftOosrmALLNhi+ZCt8Lgw0imZYo67WmcUJ7eSV/J0/rcyQMHd0z1MjmiiVw6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762810826; c=relaxed/simple;
	bh=X6wwWSIgqc9lNnCB5dlABz+pmNTc9cAQFoKvJ2ZHDao=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kfVzOsEGAh/+leGmj6BeQIzHMSWP3hnCM3GEIELTpFOT88TPDeWE+Ijrc94ZURlPVPnYA/C+pmf03I28dPvyx061v74s+7ceO1FwYDXzfUknu5QnfX8Z5H30wUeX9dte5Nrldr91PI4IvSR9RsitdPYXL+LMkF+r+mzpFdbj4Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Ttstw0Dl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yZddeXKH; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Ttstw0Dl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yZddeXKH; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Ttstw0Dl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yZddeXKH";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Ttstw0Dl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yZddeXKH"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 48C721F399;
	Mon, 10 Nov 2025 21:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762810822; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mIcEiISYw2KlXkCPFmwNDHMBUY+R2N5yeThSaxxzTLY=;
	b=Ttstw0Dlfqxq+HEGusbG3Pzm+Xw5giS53YcgwuxEZctLp84ePR/o+DJPwbiu/CGYrMoPT0
	xds2DFNahCsRnxz5MSd0RSMdEIUcuSqykZMo2bsbt7tma+YXWSqe64+Iieo9iQBKNchdhj
	v0IlyIEdLCP3PdgUycPlS45gtAkWGiY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762810822;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mIcEiISYw2KlXkCPFmwNDHMBUY+R2N5yeThSaxxzTLY=;
	b=yZddeXKHKmUKgCO3T73s3PQvaXJlsItWiRCZPvTRnTbXdYmUIuJ4dZNnU3g/K1ZsVOWjLf
	4HEg90MuCdAShdDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762810822; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mIcEiISYw2KlXkCPFmwNDHMBUY+R2N5yeThSaxxzTLY=;
	b=Ttstw0Dlfqxq+HEGusbG3Pzm+Xw5giS53YcgwuxEZctLp84ePR/o+DJPwbiu/CGYrMoPT0
	xds2DFNahCsRnxz5MSd0RSMdEIUcuSqykZMo2bsbt7tma+YXWSqe64+Iieo9iQBKNchdhj
	v0IlyIEdLCP3PdgUycPlS45gtAkWGiY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762810822;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mIcEiISYw2KlXkCPFmwNDHMBUY+R2N5yeThSaxxzTLY=;
	b=yZddeXKHKmUKgCO3T73s3PQvaXJlsItWiRCZPvTRnTbXdYmUIuJ4dZNnU3g/K1ZsVOWjLf
	4HEg90MuCdAShdDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B3501145E5;
	Mon, 10 Nov 2025 21:40:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4uEAKMVbEmlSMQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 10 Nov 2025 21:40:21 +0000
Message-ID: <92ac5455-8f46-47ae-8c8e-ae1ddf9929a3@suse.de>
Date: Mon, 10 Nov 2025 22:40:14 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4 nf-next v2] netfilter: nf_conncount: only track
 connection if it is not confirmed
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 pablo@netfilter.org, phil@nwl.cc, aconole@redhat.com, echaudro@redhat.com,
 i.maximets@ovn.org
References: <20251110154249.3586-1-fmancera@suse.de>
 <20251110154249.3586-3-fmancera@suse.de> <aRJOo4bN1DEhYvE7@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aRJOo4bN1DEhYvE7@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 11/10/25 9:44 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
>> index 0189f8b6b0bd..8c21890e4536 100644
>> --- a/net/netfilter/xt_connlimit.c
>> +++ b/net/netfilter/xt_connlimit.c
>> @@ -29,24 +29,16 @@
>>   static bool
>>   connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
>>   {
>> -	struct net *net = xt_net(par);
>>   	const struct xt_connlimit_info *info = par->matchinfo;
>> -	struct nf_conntrack_tuple tuple;
>> -	const struct nf_conntrack_tuple *tuple_ptr = &tuple;
>> -	const struct nf_conntrack_zone *zone = &nf_ct_zone_dflt;
>> -	enum ip_conntrack_info ctinfo;
>> -	const struct nf_conn *ct;
>> +	struct net *net = xt_net(par);
>>   	unsigned int connections;
>> +	bool refcounted = false;
>> +	struct nf_conn *ct;
>>   	u32 key[5];
>>   
>> -	ct = nf_ct_get(skb, &ctinfo);
>> -	if (ct != NULL) {
>> -		tuple_ptr = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
>> -		zone = nf_ct_zone(ct);
>> -	} else if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb),
>> -				      xt_family(par), net, &tuple)) {
>> +	ct = nf_ct_get_or_find(net, skb, xt_family(par), &refcounted);
>> +	if (!ct)
>>   		goto hotdrop;
>> -	}
> 
> This can't work this way for -t raw use case, which we need
> to preserve.
> 
> Anyone who uses -t raw ... -m connlimit ...
> 
> will now have their packets dropped, so no connection
> can make forward progress (not even when using iptables --syn).
> 
> We need to get rid of the
>          if ((u32)jiffies == list->last_gc)
>                  goto add_new_node;
> 
> check in nf_conncount_add(), or, (to not add perf regress for ovs ...)
> apply it when a (confirmed) conntrack entry is present.
> 
> Given that limitation, I don't think this nf_ct_get_or_find() helper
> makes any sense, since you still need to pass the tupleptr down
> to count_tree().
> 

*sight* you are right, this approach still have the same problem with 
raw as we won't have a ct..

> I think passing in the sk_buff is better, so all of this
> conntrack/tuple/zone etc. stuff is hidden away in nf_conncount.c.
>

Yes, this is the only solution possible passing down the sk_buff and 
handle all of that there.
> I think you could start by *adding*
>> unsigned int nf_conncount_count_skb(struct net *net,
> 				    const struct sk_buff *skb,
> 				    struct nf_conncount_data *data,
> 				    const u32 *key);
> 
> As frontend function for nf_conncount_count().
> This new function could (re)use some of the code you made
> for nf_ct_get_or_find(), the zone usage there looks correct
> to me.
> 
> Then, in patch 2, convert -m connlimit.
> You could send that as an initial patch set already.
> 
> Then, in patch 3 (or later followup patch set), convert remaining user
> (ovs) and hide old api.
> 
> Then, in patch 4, start pushing down the sk_buff more in nf_conncount.c
> until its available for nf_conncount_add().
> 
> Then, add nf_conncount_add_skb and repeat this process.
> 
> Does that make sense?

Yes. Thank you for all these explanations Florian. This is being much 
complex than I expected initially..

Thanks,
Fernando.
