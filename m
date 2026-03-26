Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22DE3CEB9D
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2026 12:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774526627; cv=none; b=ksTQO3tetpkLtNRrUVzsbxX2m1CJPXg5/N/t2E0tgixEAMIxmzk6z/nkNiM76o8iCJabuz2XTB2GhHewuLJ3H6oyqcIMorEom2ojvcrPkWJBlWCGugWLMZ3PqJyKJZd6z9s6nkxRNinvii9AaJVu+RhZaoAe45QpbJe02VDXgxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774526627; c=relaxed/simple;
	bh=lYncb5gap7/s7TUbwdoLclIJw9i1Jk+jPmtLrC6O1mA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rKwYQvYsJDCGLDB18qV14j72HMNr5/aE5rQnjk5RlrEkYpXTpJbb3zaYEIK0uRziIgzYwsAgqOs1DC/XTc214t6ufJIPdH75AZLGsglzPhTww4CRr5wqEN6G+A2tNy4A+co/mkTrDaBPMJTmFiqI4P+ZLj3rXKaHAiNsGhDum98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RmMX0orp; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=u1T2dEzi; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=UcvWAWIo; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=eD/a150Z; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RmMX0orp";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="u1T2dEzi";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="UcvWAWIo";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="eD/a150Z"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7D2E45BDC2;
	Thu, 26 Mar 2026 12:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774526623; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lIY3FeUqnm3QhmIXC0Dww/bdHTuvfA9CUN9w3TpPtKA=;
	b=RmMX0orpdvKWHwdkCgKUqPy2i7IDyJKpw/CGLGtXjmX4bpAa6dNxLhbctODQ77A4/C0x5h
	3prT0+yqxV8MG1pPYXOcLUc2jL70vhaZ0oU7ns9zsZfxHKRqRCTPwvpv+gtXgrEJ59drhH
	ybj6Us5uXgRZ4sYkjgdPnNpnf4xaUXQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774526623;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lIY3FeUqnm3QhmIXC0Dww/bdHTuvfA9CUN9w3TpPtKA=;
	b=u1T2dEziI9mhFNq8pfhdiW6eUVQbVxZZ/sdYpSePSW5oi3zYb6od/fNIRHX6XeUhqYBFZz
	Cg1Jjz/MrLK+EpAw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UcvWAWIo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="eD/a150Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774526622; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lIY3FeUqnm3QhmIXC0Dww/bdHTuvfA9CUN9w3TpPtKA=;
	b=UcvWAWIoYSo8w/qA5LJqTr8zVxT0BODMUZLaJodZPcOJLDoReEpap3HPpgXgMC2ddbVNmP
	wSuhPOdmLDu14CQPNZszfkgCSM0jXVUY/PQjT1EojbIMvfdqUt+TM6nwkqWsHkEfW96O8G
	mN/SBxaNadcddecFdRETRd74ScYFrGY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774526622;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lIY3FeUqnm3QhmIXC0Dww/bdHTuvfA9CUN9w3TpPtKA=;
	b=eD/a150Zj4sTVgnhx0AYsalsjatT/cBVcrVoGgL84qmanR01RwA7ZClY8aVJSYdjQCPy1x
	ndrwZQtOFpRnQQCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 471B34A0A3;
	Thu, 26 Mar 2026 12:03:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id p3FrDp4gxWkCDwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 26 Mar 2026 12:03:42 +0000
Message-ID: <d33c0d7f-e281-4371-964d-3ecfc647f5e1@suse.de>
Date: Thu, 26 Mar 2026 13:03:32 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf] netfilter: nf_tables: reject requests exceeding
 NF_FLOW_RULE_ACTION_MAX actions
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Cc: Hyunwoo Kim <imv4bel@gmail.com>
References: <20260325164130.29060-1-fw@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260325164130.29060-1-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	RCPT_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 7D2E45BDC2

On 3/25/26 5:41 PM, Florian Westphal wrote:
> nf_flow_offload_rule_alloc() allocates space for NF_FLOW_RULE_ACTION_MAX
> entries.  Make sure userspace passes more entries to us.
> 

nit: shouldn't this be "Make sure userspace does not pass more entries 
to us"?

Other than that, LGTM.

Thanks.

> Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>   Can also route via nf-next if thats deemed the better tree.
> 
>   include/net/netfilter/nf_flow_table.h | 2 ++
>   net/netfilter/nf_flow_table_offload.c | 2 --
>   net/netfilter/nf_tables_offload.c     | 5 +++--
>   3 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
> index b09c11c048d5..0b2fb1467b3f 100644
> --- a/include/net/netfilter/nf_flow_table.h
> +++ b/include/net/netfilter/nf_flow_table.h
> @@ -13,6 +13,8 @@
>   #include <linux/if_pppox.h>
>   #include <linux/ppp_defs.h>
>   
> +#define NF_FLOW_RULE_ACTION_MAX	16
> +
>   struct nf_flowtable;
>   struct nf_flow_rule;
>   struct flow_offload;
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index 9b677e116487..11463682bbfa 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -727,8 +727,6 @@ int nf_flow_rule_route_ipv6(struct net *net, struct flow_offload *flow,
>   }
>   EXPORT_SYMBOL_GPL(nf_flow_rule_route_ipv6);
>   
> -#define NF_FLOW_RULE_ACTION_MAX	16
> -
>   static struct nf_flow_rule *
>   nf_flow_offload_rule_alloc(struct net *net,
>   			   const struct flow_offload_work *offload,
> diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
> index 9101b1703b52..a2f7966bc201 100644
> --- a/net/netfilter/nf_tables_offload.c
> +++ b/net/netfilter/nf_tables_offload.c
> @@ -88,10 +88,11 @@ static void nft_flow_rule_transfer_vlan(struct nft_offload_ctx *ctx,
>   struct nft_flow_rule *nft_flow_rule_create(struct net *net,
>   					   const struct nft_rule *rule)
>   {
> +	unsigned int num_actions = 0;
>   	struct nft_offload_ctx *ctx;
>   	struct nft_flow_rule *flow;
> -	int num_actions = 0, err;
>   	struct nft_expr *expr;
> +	int err;
>   
>   	expr = nft_expr_first(rule);
>   	while (nft_expr_more(rule, expr)) {
> @@ -102,7 +103,7 @@ struct nft_flow_rule *nft_flow_rule_create(struct net *net,
>   		expr = nft_expr_next(expr);
>   	}
>   
> -	if (num_actions == 0)
> +	if (num_actions == 0 || num_actions > NF_FLOW_RULE_ACTION_MAX)
>   		return ERR_PTR(-EOPNOTSUPP);
>   
>   	flow = nft_flow_rule_alloc(num_actions);

