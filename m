Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97E73A8FE6
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Apr 2026 13:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776086869; cv=none; b=V7XdffObTBvW/V26P61dxE2kxga4i7hzG7pFG3OsZwamtoXlyGQay40B9HEcjYb1noRK/b56hjARQilDrB+q3ta9z1pZaUPwuOOSpG0QYzHmFwIkoiu8imRAG7EJ7LmX8z56jMuQ7gE7feBLfMpRieQng5TrFiuz19JLM4PKT3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776086869; c=relaxed/simple;
	bh=hldHgMD5A0O9DKvInt91qdUqLWxjlhCYrW776ljAE48=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ILA4TBwW1LkyVKrafgvEu0sZ9xYPum6m31Y3JU5v6QunxgpyeNMLZ4zWL0YGHsiBK3LPQKgt8HcswGBWWb1C2njaFX0BALvK2Hf/i8K0AdYXgTe08NqeKHLRry/XMDoORSSXSYmxmN5J260kOz9mxC5kQuD/1Z4c6EYhdHBo9PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vbqgL98n; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rHDOD3oC; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vbqgL98n; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rHDOD3oC; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vbqgL98n";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rHDOD3oC";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vbqgL98n";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rHDOD3oC"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A457D5BDA7;
	Mon, 13 Apr 2026 13:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776086865; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VgYzPyFA6x5DxkGE81tTZvWFfyANnk7qrhW+RxfJSSk=;
	b=vbqgL98nH2aibKU0jk76DgEjklSqPmHkUt/hOljAnjrPNm9KQRJqqoXVJ2cIhrT5IDkYf4
	NLh724RZ/GC9LlSHIFRAboQom4udP5MoJkP6Y5w++eYraqLy53UXO3nGBBHpj5Q6NttkQa
	w3uh/fbZ6GpJpujuUR3imhAX9oOFtac=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776086865;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VgYzPyFA6x5DxkGE81tTZvWFfyANnk7qrhW+RxfJSSk=;
	b=rHDOD3oCzGWReh3D1mpmjJG7RqbN07Sd35Jnr4G1DPnmQVzNxRUnEx1zBoncUOFah8SjUz
	h+HZ9RiX1Q3PFlBA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776086865; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VgYzPyFA6x5DxkGE81tTZvWFfyANnk7qrhW+RxfJSSk=;
	b=vbqgL98nH2aibKU0jk76DgEjklSqPmHkUt/hOljAnjrPNm9KQRJqqoXVJ2cIhrT5IDkYf4
	NLh724RZ/GC9LlSHIFRAboQom4udP5MoJkP6Y5w++eYraqLy53UXO3nGBBHpj5Q6NttkQa
	w3uh/fbZ6GpJpujuUR3imhAX9oOFtac=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776086865;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VgYzPyFA6x5DxkGE81tTZvWFfyANnk7qrhW+RxfJSSk=;
	b=rHDOD3oCzGWReh3D1mpmjJG7RqbN07Sd35Jnr4G1DPnmQVzNxRUnEx1zBoncUOFah8SjUz
	h+HZ9RiX1Q3PFlBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 450DB4AEE5;
	Mon, 13 Apr 2026 13:27:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TMLeDVHv3GkFRAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 13 Apr 2026 13:27:45 +0000
Message-ID: <ae935de2-ff04-41ae-abd1-a091bd76381a@suse.de>
Date: Mon, 13 Apr 2026 15:27:44 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf-next] netfilter: nf_conncount: make number of hash
 slots configurable
To: Vladimir Vdovin <deliran@verdict.gg>, netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org, fw@strlen.de, coreteam@netfilter.org, phil@nwl.cc
References: <20260413123712.42993-1-deliran@verdict.gg>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260413123712.42993-1-deliran@verdict.gg>
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
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 4/13/26 2:37 PM, Vladimir Vdovin wrote:
> Some workloads with high conntrack rate
> generate high lock contention on insert_tree(), so
> constant 256 CONNCOUNT_SLOTS can be too small.
> 
> Signed-off-by: Vladimir Vdovin <deliran@verdict.gg>
> ---

Hi Vladimir,

do you have a good way to reproduce such situation? I have been looking 
for ways to improve conncount and its testing.

Thanks,
Fernando.

>   net/netfilter/Kconfig        | 12 ++++++++++++
>   net/netfilter/nf_conncount.c |  2 +-
>   2 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
> index 6cdc994fdc8a..38df2829d4d6 100644
> --- a/net/netfilter/Kconfig
> +++ b/net/netfilter/Kconfig
> @@ -111,6 +111,18 @@ if NF_CONNTRACK
>   config NETFILTER_CONNCOUNT
>   	tristate
>   
> +config NF_CONNCOUNT_SLOTS
> +	int "Number of hash slots for nf_conncount"
> +	depends on NF_CONNTRACK
> +	default 256
> +	range 1 4096
> +	help
> +	  Number of hash slots used by the nf_conncount module.
> +	  Each slot has its own spinlock and rb-tree, so increasing
> +	  this value reduces lock contention at the cost of additional
> +	  memory.
> +	  Default is 256. Allowed range: 1 - 4096.
> +
>   config NF_CONNTRACK_MARK
>   	bool  'Connection mark tracking support'
>   	depends on NETFILTER_ADVANCED
> diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
> index 00eed5b4d1b1..bdb9081a6c05 100644
> --- a/net/netfilter/nf_conncount.c
> +++ b/net/netfilter/nf_conncount.c
> @@ -32,7 +32,7 @@
>   #include <net/netfilter/nf_conntrack_tuple.h>
>   #include <net/netfilter/nf_conntrack_zones.h>
>   
> -#define CONNCOUNT_SLOTS		256U
> +#define CONNCOUNT_SLOTS		CONFIG_NF_CONNCOUNT_SLOTS
>   
>   #define CONNCOUNT_GC_MAX_NODES		8
>   #define CONNCOUNT_GC_MAX_COLLECT	64
> 
> base-commit: 028ef9c96e96197026887c0f092424679298aae8

