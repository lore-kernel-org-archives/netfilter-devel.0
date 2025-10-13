Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7367F25F78F
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Oct 2025 19:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760383187; cv=none; b=uNUMA/dN7DrQjhs1HWN/OAgcplPFCNF9iLGOEhLE06t+bOli48t2ynWxvqnbx1sMhlxuEAQ3L0Mwzn/vXXnrYQOUNQmLlIg975QNrf/4h+Vrmy/3aj89P08BJjlNPMwEzZjCfN02XR4npIuVPKkKU2RMjM1dSf8y+2SjGDBzKX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760383187; c=relaxed/simple;
	bh=yMr3OubLVB8+MaN+h6EsHa1j67prdJlZqqSYD5jVeJM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YIriLx5/db+AFO/9BuL6nCY+1GHFeXR+pI7BoPRqy1jnqvzSi3oMdDpMpyJOEDa5ngu0R78o9/EQlIKHImbSIcbkZNPmrAxCkxSixM0/79J9VzjRYYM/aw4ggCHPpye/p9WiGk6KE6h2DmaYQddvJq1QLr1Q5IsByIZxcAiTGak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ocyMfkoJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=L3ouhsjg; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ocyMfkoJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=L3ouhsjg; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ocyMfkoJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="L3ouhsjg";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ocyMfkoJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="L3ouhsjg"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7407C1F44F;
	Mon, 13 Oct 2025 19:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760383183; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p5/7yz0yfYw2dCoQPjIkY2oxToRfgQJNHeeCRXsVUQQ=;
	b=ocyMfkoJnaKoX/LC4W5FGk+GHDuYZTL0/zpaObw/6xzoQdsMbsWsVFJYIRSpMiaXaKYNBN
	QWcne4QLS/WX7pImACWOCSP8x6f5U6GLUnafdVYsd76t4dZIb78o4/cIOZve7LxAKZg5XS
	B5ZBCUEyvb0q5dg03bbVa0To7ksH+vU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760383183;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p5/7yz0yfYw2dCoQPjIkY2oxToRfgQJNHeeCRXsVUQQ=;
	b=L3ouhsjgJqKCe5P/KdErQG/JlQLkMLHd6NO1JWzykyb1YNBskePg42Hm8qWREZGev2Exkp
	/aBamOYcNnB1uuBw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ocyMfkoJ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=L3ouhsjg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760383183; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p5/7yz0yfYw2dCoQPjIkY2oxToRfgQJNHeeCRXsVUQQ=;
	b=ocyMfkoJnaKoX/LC4W5FGk+GHDuYZTL0/zpaObw/6xzoQdsMbsWsVFJYIRSpMiaXaKYNBN
	QWcne4QLS/WX7pImACWOCSP8x6f5U6GLUnafdVYsd76t4dZIb78o4/cIOZve7LxAKZg5XS
	B5ZBCUEyvb0q5dg03bbVa0To7ksH+vU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760383183;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p5/7yz0yfYw2dCoQPjIkY2oxToRfgQJNHeeCRXsVUQQ=;
	b=L3ouhsjgJqKCe5P/KdErQG/JlQLkMLHd6NO1JWzykyb1YNBskePg42Hm8qWREZGev2Exkp
	/aBamOYcNnB1uuBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3D60A1374A;
	Mon, 13 Oct 2025 19:19:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id U3rkC89Q7Wh+NAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 13 Oct 2025 19:19:43 +0000
Message-ID: <7600f08e-bedf-4f92-99b8-751f4a096243@suse.de>
Date: Mon, 13 Oct 2025 21:19:34 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [nftables PATCH] doc: fix tcpdump example
To: georg@syscid.com, netfilter-devel@vger.kernel.org
Cc: Georg Pfuetzenreuter <mail@georg-pfuetzenreuter.net>
References: <20251013171730.1447005-2-georg@syscid.com>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20251013171730.1447005-2-georg@syscid.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7407C1F44F
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.98%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,suse.de:dkim]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 



On 10/13/25 7:17 PM, georg@syscid.com wrote:
> From: Georg Pfuetzenreuter <mail@georg-pfuetzenreuter.net>
> 
> The expression needs to be enclosed in a single string and combined with
> a logical AND to have the desired effect.
> 
> Fixes: 1188a69604c3 ("src: introduce SYNPROXY matching")
> Signed-off-by: Georg Pfuetzenreuter <mail@georg-pfuetzenreuter.net>
> ---
>   doc/statements.txt | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)

Thank you Georg!

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
