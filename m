Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452212E06EF
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Jun 2026 20:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781815126; cv=none; b=G0IthQaohGlopgGHhneot60hCHNZ75VyMraZpJcAEh14H6idt9B1JIllwyFCq5j2uw2+SX6h2a2KP12sAbzao7iPc7t4DrdSvltO6zF/avZW73zZsm+3d6NzwPOt8aRyqkdW9oVwW16iu0YDN2VADDpv7vQPJagfC6ndIxRqIPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781815126; c=relaxed/simple;
	bh=gtSmY9rpjP9yLDcjnTWQR3Iw22Py8f5xkdmMIVb85qo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z3VuT2q028q7v85G26vSH1OMpBqZEwEOP/Nh9l+6SKmsCtlRdfRK/kriJypdl2upvVhdlZd87itAlAB1Q6YaEAHbg+acv5dh/R0aE2Z7p5HOn8KH1Nj2NdxAchH46tCn7KIEQJ7KG0sfJE0O0g4IW0Dz1hNPpmmDHTVtRTLmCTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IFpt2Xpn; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=RMTEG2Uo; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IFpt2Xpn; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=RMTEG2Uo; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IFpt2Xpn";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="RMTEG2Uo";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IFpt2Xpn";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="RMTEG2Uo"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6EEBB75EB6;
	Thu, 18 Jun 2026 20:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781815123; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JP9DOMmfGeDghitmgOQMRuS1HheXkfH3gr8zauo1mFg=;
	b=IFpt2XpnNFZQwjSTjynlPS6+PL9iB9/ywT11DPk8elNAYVBN1MvjBHk9LBdl+uoH68bGHM
	PgpaWtLYnTiHy0KO9fvzwoi8CAIhp4pDT9LDnZQ9Qku4qBVhqVZSWcdNOKnT8vBb11Z1cf
	IGjforFSkWi++3mbLZvvGXDLCbpLZa8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781815123;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JP9DOMmfGeDghitmgOQMRuS1HheXkfH3gr8zauo1mFg=;
	b=RMTEG2Uo2Khfq34NF1MM7sMZDx4MBN3+vvon0IBNjwtz7JL32vKiqDKiZGM7NTzzeG5KBZ
	2EqBEBKAUaKfDZBQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IFpt2Xpn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=RMTEG2Uo
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781815123; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JP9DOMmfGeDghitmgOQMRuS1HheXkfH3gr8zauo1mFg=;
	b=IFpt2XpnNFZQwjSTjynlPS6+PL9iB9/ywT11DPk8elNAYVBN1MvjBHk9LBdl+uoH68bGHM
	PgpaWtLYnTiHy0KO9fvzwoi8CAIhp4pDT9LDnZQ9Qku4qBVhqVZSWcdNOKnT8vBb11Z1cf
	IGjforFSkWi++3mbLZvvGXDLCbpLZa8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781815123;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JP9DOMmfGeDghitmgOQMRuS1HheXkfH3gr8zauo1mFg=;
	b=RMTEG2Uo2Khfq34NF1MM7sMZDx4MBN3+vvon0IBNjwtz7JL32vKiqDKiZGM7NTzzeG5KBZ
	2EqBEBKAUaKfDZBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1CF56779A8;
	Thu, 18 Jun 2026 20:38:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id B4URBFNXNGp1AgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 18 Jun 2026 20:38:43 +0000
Message-ID: <a6c98190-0e54-4061-8d4f-bdb5dd5172de@suse.de>
Date: Thu, 18 Jun 2026 22:38:38 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/9 nf-next] netfilter: conntrack: use
 DEBUG_NET_WARN_ON_ONCE on packet paths
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, phil@nwl.cc,
 fw@strlen.de
References: <20260601193049.8131-1-fmancera@suse.de>
 <20260601193049.8131-5-fmancera@suse.de> <ajQmsQsCbwJb5P7W@chamomile>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <ajQmsQsCbwJb5P7W@chamomile>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 6EEBB75EB6
X-Spam-Score: -4.51

On 6/18/26 7:11 PM, Pablo Neira Ayuso wrote:
> Hi Fernando,
> 
> I'm a making a bit more in-depth review for this specific patch.
> 
> I think, in general about this series, it would be good to avoid,
> things like:
> 
>          DEBUG_NET_WARN_ON_ONCE(blah);
> 
>          func(blah->info, ...);
> 
> but it might not be trivial in all cases, sometimes it is simply
> better to remove in that case.
> 

Makes sense.

> The patch in this series for nf_tables (already upstream) always
> follow the idiom:
> 
>          if (cond) {
>                  DEBUG_NET_WARN_ON_ONCE(1);
>                  terminal statament (ie. return, break...)
>          }
> 
> I will try to provide you with hints on what to do in other patches in
> this series to speed up inclusion.
> 
> Now comments on this specific patch, see below.
> 

Thank you Pablo for the comments, they are quite useful. As this goes to 
nf-next now we don't have time pressure. I will amend this patch locally 
and will wait for the comments in other patches. No need to rush the 
review, we can take this the slow-path.

Thank you again!

> On Mon, Jun 01, 2026 at 09:30:44PM +0200, Fernando Fernandez Mancera wrote:
>> Replace WARN_ON and WARN_ON_ONCE with DEBUG_NET_WARN_ON_ONCE inside
>> conntrack confirmation, extension management, helper assignment, and
>> protocol parsing loops. This prevents unnecessary system panics when
>> panic_on_warn=1 is enabled in production systems.
>>
>> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
>> ---
>>   net/netfilter/nf_conntrack_core.c       | 2 +-
>>   net/netfilter/nf_conntrack_extend.c     | 3 ++-
>>   net/netfilter/nf_conntrack_helper.c     | 4 +++-
>>   net/netfilter/nf_conntrack_ovs.c        | 2 +-
>>   net/netfilter/nf_conntrack_proto_icmp.c | 3 ++-
>>   net/netfilter/nf_conntrack_seqadj.c     | 2 +-
>>   net/netfilter/nf_conntrack_sip.c        | 5 ++++-
>>   7 files changed, 14 insertions(+), 7 deletions(-)
>>
>> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
>> index 8ba5b22a1eef..51e2d8ebe756 100644
>> --- a/net/netfilter/nf_conntrack_core.c
>> +++ b/net/netfilter/nf_conntrack_core.c
>> @@ -1244,7 +1244,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
>>   	 * unconfirmed conntrack.
>>   	 */
>>   	if (unlikely(nf_ct_is_confirmed(ct))) {
>> -		WARN_ON_ONCE(1);
>> +		DEBUG_NET_WARN_ON_ONCE(1);
>>   		nf_conntrack_double_unlock(hash, reply_hash);
>>   		local_bh_enable();
>>   		return NF_DROP;
> 
> OK, explicit drop, fine. Keep it.
> 
>> diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
>> index dd62cc12e775..68169007aea2 100644
>> --- a/net/netfilter/nf_conntrack_extend.c
>> +++ b/net/netfilter/nf_conntrack_extend.c
>> @@ -95,7 +95,8 @@ void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
>>   	struct nf_ct_ext *new;
>>   
>>   	/* Conntrack must not be confirmed to avoid races on reallocation. */
>> -	WARN_ON(nf_ct_is_confirmed(ct));
>> +	if (unlikely(nf_ct_is_confirmed(ct)))
>> +		DEBUG_NET_WARN_ON_ONCE(1);
> 
> Keep it, but return NULL here. It provide good context, extensions can
> only be added with a unconfirmed conntrack.
> 
>>   	/* struct nf_ct_ext uses u8 to store offsets/size */
>>   	BUILD_BUG_ON(total_extension_size() > 255u);
>> diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
>> index 17e971bd4c74..0a0e41dd4c95 100644
>> --- a/net/netfilter/nf_conntrack_helper.c
>> +++ b/net/netfilter/nf_conntrack_helper.c
>> @@ -198,8 +198,10 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
>>   	if (test_bit(IPS_HELPER_BIT, &ct->status))
>>   		return 0;
>>   
>> -	if (WARN_ON_ONCE(!tmpl))
>> +	if (unlikely(!tmpl)) {
>> +		DEBUG_NET_WARN_ON_ONCE(1);
>>   		return 0;
>> +	}
> 
> Useless for netfilter:
> 
>          if (!exp && tmpl)
>                  __nf_ct_try_assign_helper(ct, tmpl, GFP_ATOMIC);
> 
> _BUT_ it can catch bugs in other existing users, eg. net/sched/act_ct.c
> 
>          if (!nf_ct_is_confirmed(ct) && commit && p->helper && !nfct_help(ct)) {
>                  err = __nf_ct_try_assign_helper(ct, p->tmpl, GFP_ATOMIC);
> 
> keep it.
> 
> it is also fine that there is a branch and return (to skip it).
> 
>>   	help = nfct_help(tmpl);
>>   	if (help != NULL) {
>> diff --git a/net/netfilter/nf_conntrack_ovs.c b/net/netfilter/nf_conntrack_ovs.c
>> index a6988eeb1579..26f12dd0c1a4 100644
>> --- a/net/netfilter/nf_conntrack_ovs.c
>> +++ b/net/netfilter/nf_conntrack_ovs.c
>> @@ -53,7 +53,7 @@ int nf_ct_helper(struct sk_buff *skb, struct nf_conn *ct,
>>   		break;
>>   	}
>>   	default:
>> -		WARN_ONCE(1, "helper invoked on non-IP family!");
>> +		DEBUG_NET_WARN_ONCE(1, "helper invoked on non-IP family!");
>>   		return NF_DROP;
> 
> OK, this is in a branch with an explicit action (drop packet) LGTm.
> 
>>   	}
>>   
>> diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
>> index 32148a3a8509..0f39cb147c4f 100644
>> --- a/net/netfilter/nf_conntrack_proto_icmp.c
>> +++ b/net/netfilter/nf_conntrack_proto_icmp.c
>> @@ -117,7 +117,8 @@ int nf_conntrack_inet_error(struct nf_conn *tmpl, struct sk_buff *skb,
>>   	enum ip_conntrack_dir dir;
>>   	struct nf_conn *ct;
>>   
>> -	WARN_ON(skb_nfct(skb));
>> +	if (unlikely(skb_nfct(skb)))
>> +		DEBUG_NET_WARN_ON_ONCE(1);
> 
> nf_conntrack_in
>   [ reset skb->nfct ]
>   nf_conntrack_handle_icmp
>    nf_conntrack_icmpv4_error
>     nf_conntrack_inet_error
> 
> There is nf_conntrack_inet_error() which performs the ct lookup.
> There is resolve_normal_ct() too, but these two are coming later.
> 
> [ ... snippet that resets skb->nfct ... ]
> unsigned int
> nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
> {
>          enum ip_conntrack_info ctinfo;
>          struct nf_conn *ct, *tmpl;
>          u_int8_t protonum;
>          int dataoff, ret;
>   
>          tmpl = nf_ct_get(skb, &ctinfo);
>          if (tmpl || ctinfo == IP_CT_UNTRACKED) {
>                  /* Previously seen (loopback or untracked)?  Ignore. */
>                  if ((tmpl && !nf_ct_is_template(tmpl)) ||
>                       ctinfo == IP_CT_UNTRACKED)
>                          return NF_ACCEPT;
>                  skb->_nfct = 0; <---------  this is reset here.
>          }
> [ end of snippet ]
> 
> I don't remember to have seen this WARN_ON, so remove it.
> 
>>   	zone = nf_ct_zone_tmpl(tmpl, skb, &tmp);
>>   
>>   	/* Are they talking about one of our connections? */
>> diff --git a/net/netfilter/nf_conntrack_seqadj.c b/net/netfilter/nf_conntrack_seqadj.c
>> index 7ab2b25b57bc..2bf49f0b9406 100644
>> --- a/net/netfilter/nf_conntrack_seqadj.c
>> +++ b/net/netfilter/nf_conntrack_seqadj.c
>> @@ -38,7 +38,7 @@ int nf_ct_seqadj_set(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
>>   		return 0;
>>   
>>   	if (unlikely(!seqadj)) {
>> -		WARN_ONCE(1, "Missing nfct_seqadj_ext_add() setup call\n");
>> +		DEBUG_NET_WARN_ONCE(1, "Missing nfct_seqadj_ext_add() setup call\n");
> 
> This WARN_ONCE is now gone in the nf.git/nf-next.git.
> 
>>   		return 0;
>>   	}
>>   
>> diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
>> index e69941f1a101..7e9237c810a0 100644
>> --- a/net/netfilter/nf_conntrack_sip.c
>> +++ b/net/netfilter/nf_conntrack_sip.c
>> @@ -599,7 +599,10 @@ int ct_sip_parse_header_uri(const struct nf_conn *ct, const char *dptr,
>>   
>>   	ret = ct_sip_walk_headers(ct, dptr, dataoff ? *dataoff : 0, datalen,
>>   				  type, in_header, matchoff, matchlen);
>> -	WARN_ON(ret < 0);
>> +	if (unlikely(ret < 0)) {
>> +		DEBUG_NET_WARN_ON_ONCE(1);
>> +		return -1;
>> +	}
> 
> ct_sip_walk_headers() can never return < 0. This WARN_ON can be
> removed.
> 
>>   	if (ret == 0)
>>   		return ret;
> 
> Thanks.
> 

