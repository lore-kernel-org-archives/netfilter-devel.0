Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FDD27A444
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Oct 2025 23:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760657860; cv=none; b=N/Xti9/02NywTMOjFgfRlaLHStkjvFx0vHa/ymYua6fB2Q+/lfNyt79gSZoIwMhx/4RZ5zWy4PhhFmVW7WU4QwIFpirnlpfJ/ug0GBjF3uT1t+AS+h9sTU10QyVonCnAxcH11X7ZVcFvzvG45WADC+ClZUglAcoCZrhS1nbtXDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760657860; c=relaxed/simple;
	bh=u65fHiyMVdqShHb65ET2V0hMp3wymcJx9+uITLh33gw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=KmP+H0B6iyZJ/oU7JE5YWlTDAFMGdWgCllQ0C+RmcfiztKtcA24sQo+eS2UPYPS/rxYSqosgKRWKGkSuAdU4IJ+qKEjjuk6yFLPurAl2ze9pMOOQUTLpe1AjI/wR2gfRkZkBZJ46SDiyAL5W7PDG/3d1v3yZ0tLHpRL3XuXEpy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wr7HV0ZQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9jM6Rp/J; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wr7HV0ZQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9jM6Rp/J; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wr7HV0ZQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9jM6Rp/J";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wr7HV0ZQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9jM6Rp/J"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 87F501FB87;
	Thu, 16 Oct 2025 23:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760657856; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CboQXkUe11kIsw2tcRPyJppQLVLzSvR7AGppqVX4ZaA=;
	b=wr7HV0ZQ+F/x96qnOwmRN2Ox4RjtSI3uQnbfbsvH4UxQzpAdESfdglarJUc58ZqntGY/pr
	MdkxKlZT/ayn6H6zP+4SQLZ1bLrDae5k/k8QzaBySyr/RNME/xxyHxyFMgU5aK9LaET8/Q
	nwSzX3At8kaZKOKp7EspTc7fg7j3OX8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760657856;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CboQXkUe11kIsw2tcRPyJppQLVLzSvR7AGppqVX4ZaA=;
	b=9jM6Rp/JY8rgmR4FBe+8IC74gDCaktnlMzOACUZ3M9ZsFFMUfr4wnzWnLIeMWiWWAKalIm
	YdRualYhMqdtjjCQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wr7HV0ZQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="9jM6Rp/J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760657856; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CboQXkUe11kIsw2tcRPyJppQLVLzSvR7AGppqVX4ZaA=;
	b=wr7HV0ZQ+F/x96qnOwmRN2Ox4RjtSI3uQnbfbsvH4UxQzpAdESfdglarJUc58ZqntGY/pr
	MdkxKlZT/ayn6H6zP+4SQLZ1bLrDae5k/k8QzaBySyr/RNME/xxyHxyFMgU5aK9LaET8/Q
	nwSzX3At8kaZKOKp7EspTc7fg7j3OX8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760657856;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CboQXkUe11kIsw2tcRPyJppQLVLzSvR7AGppqVX4ZaA=;
	b=9jM6Rp/JY8rgmR4FBe+8IC74gDCaktnlMzOACUZ3M9ZsFFMUfr4wnzWnLIeMWiWWAKalIm
	YdRualYhMqdtjjCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 58CEF1340C;
	Thu, 16 Oct 2025 23:37:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yp7/EcCB8WiMCAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 16 Oct 2025 23:37:36 +0000
Message-ID: <56c973f0-87a1-4e60-bd40-3cebfafdfe90@suse.de>
Date: Fri, 17 Oct 2025 01:37:35 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nft 1/4] evaluate: tunnel: don't assume src is set
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20251016145955.7785-1-fw@strlen.de>
 <20251016145955.7785-2-fw@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20251016145955.7785-2-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 87F501FB87
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:email,suse.de:mid,suse.de:dkim];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 


On 10/16/25 4:59 PM, Florian Westphal wrote:
> Included bogon crashes, after fix:
> 
> empty_geneve_definition_crash:2:9-16: Error: Could not process rule: Invalid argument
> 
> Since this feature is undocumented (hint, hint) I don't know
> if there are cases where ip daddr can be elided.
> 

Ugh, sorry. That is my fault, I am going to document this properly.

> If not, a followup patch should reject empty dst upfront
> so users get a more verbose error message.
> 

dst cannot be empty so it should be rejected properly providing a good 
error message. Let me handle that on a follow up patch.

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>   src/evaluate.c                                           | 9 +++++----
>   .../testcases/bogons/nft-f/empty_geneve_definition_crash | 4 ++++
>   2 files changed, 9 insertions(+), 4 deletions(-)
>   create mode 100644 tests/shell/testcases/bogons/nft-f/empty_geneve_definition_crash
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 0c7d90f8f43b..ac482c83cce2 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -5865,11 +5865,12 @@ static int tunnel_evaluate(struct eval_ctx *ctx, struct obj *obj)
>   				 obj->tunnel.dst->dtype->size);
>   		if (expr_evaluate(ctx, &obj->tunnel.dst) < 0)
>   			return -1;
> -	}
>   
> -	if (obj->tunnel.src->dtype != obj->tunnel.dst->dtype)
> -		return __stmt_binary_error(ctx, &obj->location, NULL,
> -					  "specify either ip or ip6 for address");
> +		if (obj->tunnel.src &&
> +		    obj->tunnel.src->dtype != obj->tunnel.dst->dtype)
> +			return __stmt_binary_error(ctx, &obj->location, NULL,
> +						  "specify either ip or ip6 for address");
> +	}
>   
>   	return 0;
>   }
> diff --git a/tests/shell/testcases/bogons/nft-f/empty_geneve_definition_crash b/tests/shell/testcases/bogons/nft-f/empty_geneve_definition_crash
> new file mode 100644
> index 000000000000..d1bc76c56bd5
> --- /dev/null
> +++ b/tests/shell/testcases/bogons/nft-f/empty_geneve_definition_crash
> @@ -0,0 +1,4 @@
> +table netdev x {
> +	tunnel geneve-t {
> +	}
> +}

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

