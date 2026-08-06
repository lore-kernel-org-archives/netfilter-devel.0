Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDD0448390
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Aug 2026 10:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786013077; cv=none; b=LAJtDfT0b9Eh15XXcJzLqPH3AH6Oy1hfmShTzNy5ENpYE01/oRKlur8MQsUirnM3OOxg/1yTkp9LmYh7vnmuPD5Z8p1Z0i/8MTr87aPQbU+e0HXis6EUvpubZiNqYXrWbkF4DMSa4Rfa9K9ZwRU66wn+qUQEDqPkptpAUrzpDko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786013077; c=relaxed/simple;
	bh=8Fj9D9uRK5QFzC/WBnS6gFQhLmIMMNvMNyoe/VKej/s=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=K3LYj6h3RKsjbee/SqD6QBhu267c3i+FsWkWEnjRIgPqyuqKPFyj2FlNQbqCcyfxWB7qlp2m6nW+Dz3I5ixLjsbg7yHs8rAoK708ZJ2JWTBOyMLi/r7ywBtFI2yeVbcYkcCcI6YRBCcc4gHKyBmiMNxXNzQhv69tcshOSyESh9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0zJ8v9rj; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4VRlQizv; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=q4bjS1EC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qfUhCam/; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0zJ8v9rj";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4VRlQizv";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="q4bjS1EC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qfUhCam/"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9DE793E10;
	Thu,  6 Aug 2026 10:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786013069; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2dlDLfU86K4zf2WgZa5c9RZoR9Glmk1lvThRU4HQBho=;
	b=0zJ8v9rjMQNfIE55+62TJyIf+c7fnl6is5iwtNQhWgskogaFaKG97/6PvuXhRxB7Iy8VFV
	c+papZr7KG80aDbzaXETqfw9he1uYesgI0sSzhR5Dy5F+V3OdgS8AJIgnuoCRuyk02LCrR
	uXmoapguOiulgoYLSH7Za1rkFmgwq9k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786013069;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2dlDLfU86K4zf2WgZa5c9RZoR9Glmk1lvThRU4HQBho=;
	b=4VRlQizv3hVxH9TKTr4tUWBBvnXs8fnVXqgRPVhIfkh/B9Bsz+OkHL8ev+M0Fr59yGvcuB
	QxTIy657/Qif7mBg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786013065; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2dlDLfU86K4zf2WgZa5c9RZoR9Glmk1lvThRU4HQBho=;
	b=q4bjS1ECZMKZA+cXe7BTEfcq6CaFkGBcep3Ln+lCouLBEPBY7lNlikfMTZK6RfBEPJTZFQ
	mFwEB1BLUJ6pn5/H5vgUNZDwecRE9SGCf29sqM/V2l5+JXDDl4LyfQeyO2PcAVtzACwvrg
	khgMh1K3Y6LYki2VhlB14oeV0HGftMo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786013065;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2dlDLfU86K4zf2WgZa5c9RZoR9Glmk1lvThRU4HQBho=;
	b=qfUhCam/AFEM/eWO/yssdleOuWh+iT9ASiZ3xc3yN0IEp1RfhbpfdHw2OrjAlvorBkwcUo
	W3ywYWR7akbuAjBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 764D6779B6;
	Thu,  6 Aug 2026 10:44:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id laQcGolldGofdgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 06 Aug 2026 10:44:25 +0000
Message-ID: <eb83b9c7-379f-48b1-946f-e8039207480f@suse.de>
Date: Thu, 6 Aug 2026 12:44:03 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf-next,v2] netfilter: add DEBUG_NET_WARN_ON_ONCE to
 skb_set_nfct()
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
References: <20260805213003.297276-1-pablo@netfilter.org>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260805213003.297276-1-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[netfilter.org:email,imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 8/5/26 11:30 PM, Pablo Neira Ayuso wrote:
> Trigger a warning if nf_ct_set() overlaps an existing ct object leading
> to refcount leak. Add this warning to skb_set_nfct() whose only user is
> nf_ct_set() instead.
> 
> Update existing nf_ct_set() callers to use nf_reset_ct() first to clean
> up stale pointer to conntrack object which migh trigger false positive
> warnings.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

Thanks!

> ---
> sashiko: ignore current overwrites of skb->_nfct in
> net/bridge/netfilter/nf_conntrack_bridge.c:nf_ct_bridge_pre(),
> that will be fixed in a separated patch.
> 
>   include/linux/skbuff.h            |  1 +
>   include/net/ip_vs.h               |  2 +-
>   net/netfilter/nf_conntrack_core.c |  2 +-
>   net/openvswitch/conntrack.c       | 12 +++---------
>   net/sched/act_ct.c                |  6 +++---
>   5 files changed, 9 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 22eda1d54a0e..95184183180f 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -5004,6 +5004,7 @@ static inline unsigned long skb_get_nfct(const struct sk_buff *skb)
>   static inline void skb_set_nfct(struct sk_buff *skb, unsigned long nfct)
>   {
>   #if IS_ENABLED(CONFIG_NF_CONNTRACK)
> +	DEBUG_NET_WARN_ON_ONCE(skb->_nfct & NFCT_PTRMASK);
>   	skb->slow_gro |= !!nfct;
>   	skb->_nfct = nfct;
>   #endif
> diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
> index 8feb69158816..9c6c5336de1c 100644
> --- a/include/net/ip_vs.h
> +++ b/include/net/ip_vs.h
> @@ -2130,7 +2130,7 @@ static inline void ip_vs_notrack(struct sk_buff *skb)
>   	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
>   
>   	if (ct) {
> -		nf_conntrack_put(&ct->ct_general);
> +		nf_reset_ct(skb);
>   		nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
>   	}
>   #endif
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 784bd1d7a9bf..d0d9e5ea84a0 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -1031,7 +1031,7 @@ static int __nf_ct_resolve_clash(struct sk_buff *skb,
>   		nf_conntrack_get(&ct->ct_general);
>   
>   		nf_ct_acct_merge(ct, ctinfo, loser_ct);
> -		nf_ct_put(loser_ct);
> +		nf_reset_ct(skb);
>   		nf_ct_set(skb, ct, ctinfo);
>   
>   		NF_CT_STAT_INC(net, clash_resolve);
> diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
> index 95697d4e16e6..4dd82c4e87d3 100644
> --- a/net/openvswitch/conntrack.c
> +++ b/net/openvswitch/conntrack.c
> @@ -603,7 +603,7 @@ static bool skb_nfct_cached(struct net *net,
>   		if (nf_ct_is_confirmed(ct))
>   			nf_ct_delete(ct, 0, 0);
>   
> -		nf_ct_put(ct);
> +		nf_reset_ct(skb);
>   		nf_ct_set(skb, NULL, 0);
>   		return false;
>   	}
> @@ -745,8 +745,7 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
>   
>   		/* Associate skb with specified zone. */
>   		if (tmpl) {
> -			ct = nf_ct_get(skb, &ctinfo);
> -			nf_ct_put(ct);
> +			nf_reset_ct(skb);
>   			nf_conntrack_get(&tmpl->ct_general);
>   			nf_ct_set(skb, tmpl, IP_CT_NEW);
>   		}
> @@ -1075,12 +1074,7 @@ int ovs_ct_execute(struct net *net, struct sk_buff *skb,
>   
>   int ovs_ct_clear(struct sk_buff *skb, struct sw_flow_key *key)
>   {
> -	enum ip_conntrack_info ctinfo;
> -	struct nf_conn *ct;
> -
> -	ct = nf_ct_get(skb, &ctinfo);
> -
> -	nf_ct_put(ct);
> +	nf_reset_ct(skb);
>   	nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
>   
>   	if (key)
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index 4ca7964e83c8..7f54fb4e4ec9 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -782,7 +782,7 @@ static bool tcf_ct_skb_nfct_cached(struct net *net, struct sk_buff *skb,
>   	return true;
>   
>   drop_ct:
> -	nf_ct_put(ct);
> +	nf_reset_ct(skb);
>   	nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
>   
>   	return false;
> @@ -996,7 +996,7 @@ TC_INDIRECT_SCOPE int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>   		qdisc_skb_cb(skb)->post_ct = false;
>   		ct = nf_ct_get(skb, &ctinfo);
>   		if (ct) {
> -			nf_ct_put(ct);
> +			nf_reset_ct(skb);
>   			nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
>   		}
>   
> @@ -1034,7 +1034,7 @@ TC_INDIRECT_SCOPE int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>   
>   		/* Associate skb with specified zone. */
>   		if (tmpl) {
> -			nf_conntrack_put(skb_nfct(skb));
> +			nf_reset_ct(skb);
>   			nf_conntrack_get(&tmpl->ct_general);
>   			nf_ct_set(skb, tmpl, IP_CT_NEW);
>   		}

