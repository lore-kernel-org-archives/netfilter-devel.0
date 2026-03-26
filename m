Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18DC329E6C
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2026 22:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774562560; cv=none; b=GyLU9wmJ1l/6TW8/pIVskM3+AHtkFnNT6fybYeXG7+0gp6YvFgCZD4wkaOvm1CImIkcMjRR/F6VPofk4KQoja67eGvfNMWKNC+SUyMSAey9uk3qtwN+l26ABSZfdsASa4vGGoElH36NWa/ow882WqzxgYvZL+fqAfAXhctJbKto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774562560; c=relaxed/simple;
	bh=yA3KV27hznXmt8SIG0JBgHPyl99jjyvp3hRmGsSYopM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LSYAv3oslJpe5nsu2TviWUASqsPf0uqPCDGAjm0KRZnc0DQOPiDMX/FeB58wDli02tNSsWebP2ZjmGoi01/jr7auBHWIGemkjigjzdbzD15w0SMWDEdUDEeevjvXhAMcZcczsQa0CvCft8q9qr4+Iwlj3lby10Ba8c1MRiJavts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=c5y11S/B; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=S1bEcfT/; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PyyAcqa6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2xVNpAuC; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="c5y11S/B";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="S1bEcfT/";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PyyAcqa6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2xVNpAuC"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C894E4D2E7;
	Thu, 26 Mar 2026 22:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774562557; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TcO3xVujOq/ED/TkVQkIWHRozJKaWXMQger2uChObhk=;
	b=c5y11S/BrkYxjzlknLYtp7krpun4yB9MIHwhHDQwjEFYqrQURfG4e89FretniSTqB94fWP
	1hvOa8PWSpexsxcSxHMwD96iwBrzlSt/c3wEZycAO7u0u7Z5ul1bCFqnqXXMm2XXcarPeo
	rDUNxv+IphNjPwgdw8bbYUBQarvQi40=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774562557;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TcO3xVujOq/ED/TkVQkIWHRozJKaWXMQger2uChObhk=;
	b=S1bEcfT/fTSzk/EnIX8+yWYkZkhVSZUUfx4TF0Bq3rgZxn66mFmvn4Wab56ytIJi2KB8YV
	PMySfsVXNljG/LCA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774562556; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TcO3xVujOq/ED/TkVQkIWHRozJKaWXMQger2uChObhk=;
	b=PyyAcqa6sAdXPaVBx/l+D4VFJI3EGl8UzC8iZNcyc+hmYTG0oCZnuqdryWm15BY0K7iChi
	tRYhi1tXL6lA0CGg/nUvIzhRsgjpSXZWLlXinBRmACMk6Ta7LffpLO/wsoxeCveBTpyXoZ
	gDRJtHgmS6tOjltvgRNdU6EsndF62SU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774562556;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TcO3xVujOq/ED/TkVQkIWHRozJKaWXMQger2uChObhk=;
	b=2xVNpAuCyxOO4ALxgqD2fhLVKd825bf11yZSxEiyKgvnm4GRF0XzMGgneVgllKQGlHQXIW
	Hn9NbLbSw/6CC0Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8AD844A0A3;
	Thu, 26 Mar 2026 22:02:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tjuKHvysxWladgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 26 Mar 2026 22:02:36 +0000
Message-ID: <f164d975-7134-4638-a8fc-b3348a599797@suse.de>
Date: Thu, 26 Mar 2026 23:02:27 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf] netfilter: flowtable: strictly check for maximum
 number of actions
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
References: <20260326200935.729750-1-pablo@netfilter.org>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260326200935.729750-1-pablo@netfilter.org>
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
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,netfilter.org:email,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 3/26/26 9:09 PM, Pablo Neira Ayuso wrote:
> The maximum number of flowtable hardware offload actions in IPv6 is:
> 
> * ethernet mangling (4 payload actions, 2 for each ethernet address)
> * SNAT (4 payload actions)
> * DNAT (4 payload actions)
> * Double VLAN (4 vlan actions, 2 for popping vlan, and 2 for pushing)
>    for QinQ.
> * Redirect (1 action)
> 
> Which makes 17, while the maximum is 16. But act_ct supports for tunnels
> actions too. Note that payload action operates at 32-bit word level, so
> mangling an IPv6 address take 4 payload actions.
> 
> Update flow_action_entry_next() calls to check for the maximum number of
> supported actions.
> 
> While at it, rise the maximum number of actions per flow from 16 to 24
> so this works fine with IPv6 setups.
> 
> Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
> Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> This is the large version of this fix, it should be possible to make a
> much smaller workaround patch. This codebase did not change much since
> 2019, backports should be not too complicated.
> 

Hi Pablo,

I assume this the larger version of 
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260325164130.29060-1-fw@strlen.de/ 
right?

>   net/netfilter/nf_flow_table_offload.c | 190 +++++++++++++++++---------
>   1 file changed, 125 insertions(+), 65 deletions(-)
> 
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index 9b677e116487..eea77e0d1416 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -14,6 +14,8 @@
>   #include <net/netfilter/nf_conntrack_core.h>
>   #include <net/netfilter/nf_conntrack_tuple.h>
>   
> +#define NF_FLOW_RULE_ACTION_MAX	24
> +
>   static struct workqueue_struct *nf_flow_offload_add_wq;
>   static struct workqueue_struct *nf_flow_offload_del_wq;
>   static struct workqueue_struct *nf_flow_offload_stats_wq;
> @@ -218,6 +220,9 @@ flow_action_entry_next(struct nf_flow_rule *flow_rule)
>   {
>   	int i = flow_rule->rule->action.num_entries++;
>   
> +	if (unlikely(i >= NF_FLOW_RULE_ACTION_MAX))
> +		return NULL;
> +
>   	return &flow_rule->rule->action.entries[i];
>  }

I think this might cause a read out-of-bounds on the destroy path when 
the rule allocation fails due to too many actions.

When the if statement is hit variable i is 24 (NF_FLOW_RULE_ACTION_MAX) 
but flow_rule->rule->action.num_entries is 25 as it was post-incremented.

static void __nf_flow_offload_destroy(struct nf_flow_rule *flow_rule)
{
	struct flow_action_entry *entry;
	int i;

	for (i = 0; i < flow_rule->rule->action.num_entries; i++) {
		entry = &flow_rule->rule->action.entries[i];
		if (entry->id != FLOW_ACTION_REDIRECT)
			continue;

		dev_put(entry->dev);
	}
	kfree(flow_rule->rule);
	kfree(flow_rule);
}

As you can see, variable i would reach value 24 while entries was 
allocated for NF_FLOW_RULE_ACTION_MAX - so from 0 to 23.

One more comment below.

>   
> @@ -234,6 +239,9 @@ static int flow_offload_eth_src(struct net *net,
>   	u32 mask, val;
>   	u16 val16;
>   
> +	if (!entry0 || !entry1)
> +		return -E2BIG;
> +
>   	this_tuple = &flow->tuplehash[dir].tuple;
>   
>   	switch (this_tuple->xmit_type) {
> @@ -284,6 +292,9 @@ static int flow_offload_eth_dst(struct net *net,
>   	u8 nud_state;
>   	u16 val16;
>   
> +	if (!entry0 || !entry1)
> +		return -E2BIG;
> +
>   	this_tuple = &flow->tuplehash[dir].tuple;
>   
>   	switch (this_tuple->xmit_type) {
> @@ -325,16 +336,19 @@ static int flow_offload_eth_dst(struct net *net,
>   	return 0;
>   }
>   
[...]
>   
>   	flow_offload_mangle(entry, flow_offload_l4proto(flow), offset,
>   			    &port, &mask);
> +	return 0;
>   }
>   
> -static void flow_offload_ipv4_checksum(struct net *net,
> -				       const struct flow_offload *flow,
> -				       struct nf_flow_rule *flow_rule)
> +static int flow_offload_ipv4_checksum(struct net *net,
> +				      const struct flow_offload *flow,
> +				      struct nf_flow_rule *flow_rule)
>   {
>   	u8 protonum = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.l4proto;
>   	struct flow_action_entry *entry = flow_action_entry_next(flow_rule);
>   
> +	if (!entry)
> +		return E2BIG;
> +

Typo here, it should be -E2BIG.

Thanks,
Fernando.

