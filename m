Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09D0351C20
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Aug 2026 08:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787040370; cv=none; b=jPIa4rLm+62/bJpNcJoi1AQrVS/s10gdi2y++qOLh/2EEhMI+lBJ2jiSlFM+3/kdXWMWrMOBwSlKcfcN5h7b3w5mArtVcuXP4+0M3zRykDFkBhilLFeGBy/LpNWBR9gPQBhEhX9484nVJswMx/1sDUt0GIR850nYvypkTtWHpTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787040370; c=relaxed/simple;
	bh=bVZIHhFWS32EcV93lYCbI9eosgiX35f77QXRMXWNckg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fHxqKMm9CnvUjS7KdoicNOTtb8nmu+8I3F77cvvmNJ1+hIzN8g/VIXna7y2y7qc8migWPQAgJeD0F8zfYpGskMqVD88Qe6r4TcASWSiWi4A1pWuauoPry6F44wrkPhJLlY3iATq0OKJLGNLmfWZvrifYnTCtrI/EiBhdVAmK82E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=G/hMfqCc; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=EoFGzKp/; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=iuspJgKJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ckGAqTmm; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="G/hMfqCc";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="EoFGzKp/";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="iuspJgKJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ckGAqTmm"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 163288443C;
	Tue, 18 Aug 2026 08:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787040362; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NyrBMjlVUDXXIO1ajmNPzcgG5Yb59QcNGT9DFoekflU=;
	b=G/hMfqCciJKMDO5VCMw0+MDRDH2jeXw9DcfcDYlG6s9pt1Hx/ZfLNhxtRJ/OFt8xTeGTym
	oa3TXnWgScO7cZjmrgABbldn9vuz2Sd8ruyjMwF506vLV2DjUyUQ9AntIssGghDLgGzUNn
	TDKGBprsDwewyFGM7KgAoKmTmKQLuX0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787040362;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NyrBMjlVUDXXIO1ajmNPzcgG5Yb59QcNGT9DFoekflU=;
	b=EoFGzKp/cbNytpO6qmeJ7580IGZIphVjb65O9zFh56OtCznLrtnZLEVHxXpV6kNdGhzoOt
	YQjxXOZWGAHMZNCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787040358; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NyrBMjlVUDXXIO1ajmNPzcgG5Yb59QcNGT9DFoekflU=;
	b=iuspJgKJlBcpc9r5sLspd3txzbO/OHJR5o+CVZfiEkhjH3IOwQOF6Y+gQvPSc0L66MyMqy
	EtjpBOt2IqpbUkA0IXVH620XZ0KWa27PSdES+QeIq4L0aKxPTCO6HuYCPH30KYerypjC9h
	EDs/gwE99GexbBXpcGuHhwA0evSuebs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787040358;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NyrBMjlVUDXXIO1ajmNPzcgG5Yb59QcNGT9DFoekflU=;
	b=ckGAqTmmNNvUlvQljjFifFxc5slCsSm1MAjwK1NIm3l6Io1q3APb1kXVb7xJq1CcYMEKZs
	AeXtQaa6lI0MQSBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3DD6922BA;
	Tue, 18 Aug 2026 08:05:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZWU/DGUShGrDfgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 18 Aug 2026 08:05:57 +0000
Message-ID: <9f86fb45-8784-461e-9398-a0a930bea87c@suse.de>
Date: Tue, 18 Aug 2026 10:05:27 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf 1/1] netfilter: xt_IDLETIMER: validate label before
 debug logging in checkentry
To: Ren Wei <weir@nebusec.ai>, netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 luciano.coelho@nokia.com, kaber@trash.net, quic_manojbm@quicinc.com,
 quic_subashab@quicinc.com, vega@nebusec.ai, rakukuip@gmail.com
References: <cover.1786933680.git.rakukuip@gmail.com>
 <b139065e9f62868ac5ed0900faf1dcd13c7e68f8.1786933680.git.rakukuip@gmail.com>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <b139065e9f62868ac5ed0900faf1dcd13c7e68f8.1786933680.git.rakukuip@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[netfilter.org,strlen.de,nwl.cc,davemloft.net,google.com,kernel.org,redhat.com,nokia.com,trash.net,quicinc.com,nebusec.ai,gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]

On 8/18/26 3:56 AM, Ren Wei wrote:
> From: Luxiao Xu <rakukuip@gmail.com>
> 
> Both idletimer_tg_checkentry() and idletimer_tg_checkentry_v1() invoke
> pr_debug() with "%s" on info->label before idletimer_tg_helper() verifies
> that the 28-byte label is properly NUL-terminated.
> 
> If a user-supplied label is not NUL-terminated, printk format string
> parsing reads past the end of the allocated target structure until it
> encounters a zero byte. In builds with DEBUG enabled or when dynamic debug
> is active for this callsite, this triggers a slab-out-of-bounds read
> (detected by KASAN) and can disclose adjacent kernel memory into the logs.
> 
> Fix this by moving the pr_debug() calls after idletimer_tg_helper() has
> successfully validated the label string.
> 
> Fixes: 0902b469bd25 ("netfilter: xtables: idletimer target implementation")
> Fixes: 68983a354a65 ("netfilter: xtables: Add snapshot of hardidletimer target")
> Cc: stable@vger.kernel.org
> Reported-by: Vega <vega@nebusec.ai>
> Assisted-by: Codex:gpt-5.4
> Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
> Signed-off-by: Ren Wei <weir@nebusec.ai>
> ---

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

Thanks!
