Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E941990D9
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 23:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761262352; cv=none; b=lC2YLnc2qABBSHBhYvBk3LaZ9Bwika8OrgFgaGFNR3E35kM+8V0Z34EzdRdEWiMEuHAqyM8mXIt7Pr+w5SWwYXOExs0A7WHPC1ge/Upo2SdDf+BWSf4v8jyfjNCdQhUOu3Cq5i0RR9seAdjrSX2SsGdgoDBpcuDH4oEhJDlkYM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761262352; c=relaxed/simple;
	bh=TuVIQbynqP1MUq0JNNU+6aVm+tbNJN2xnd2EHnUlQbw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fCasOIFDAIgoKJYl6v+JWrByihAbYpvigGev/0T7SYTAmw+MjBeiUMpe+X1qKTTcPBrkqpMCwlmDmDUB6MRzvREy+junJ1emtZyfWWM3P+MG9KPe8eLAoXPyb1NbThKbhMAp705DjynB8iEwpDF35MmDkqVA/Gm+3eTpf6nNTZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=O7sQ7TaS; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=pUOLbpcX; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Ex774RYG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9vCHbDRN; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="O7sQ7TaS";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="pUOLbpcX";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Ex774RYG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9vCHbDRN"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9F6D31F388;
	Thu, 23 Oct 2025 23:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761262344; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aOih+3gY8NIEXmrT3YjcSeTIwfNV5yFlD29Rbd57ZUQ=;
	b=O7sQ7TaStFmzcVEzjjyup4/BHdowg5g9JcBPQOPcwZbGlFW6n9CJG9GoXWYuGwhf0UCY2z
	VLUk1VybC4Qb5pssDSg4pSOd6R6ARJz2guV+xKtQyLeESwWEESa2ARwv8QHENPEKBsnIqi
	6CbQp7/s4aw0D/Tsz4I93qKY7hlc5xE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761262344;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aOih+3gY8NIEXmrT3YjcSeTIwfNV5yFlD29Rbd57ZUQ=;
	b=pUOLbpcXKUBYavbWUXXSjAZeUL5LnTjnQvmKrMX0XVtDSoyDuA+ieqHKXDoc7kLmPrPAzD
	TdaxYAxeJgTgPXCg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Ex774RYG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9vCHbDRN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761262340; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aOih+3gY8NIEXmrT3YjcSeTIwfNV5yFlD29Rbd57ZUQ=;
	b=Ex774RYGdU/EYsQ9bnIn034FT/18spPvgo4oAgmSTnXFHhStsh0uGtJFvAHLjP4sZAKBMj
	LYLeK14EKsH8WAy/Ae9o5RvBjhCTdIDOqu3Tu8vPNFMeLFNA+lKtU90FE4lc4K2kRmhOXA
	t/HrRN4Uvt1cUgj7WWuxPyp1682Lvek=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761262340;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aOih+3gY8NIEXmrT3YjcSeTIwfNV5yFlD29Rbd57ZUQ=;
	b=9vCHbDRNym/YtNA+4n/MOIulludWzLGVRhCi1S9KGaIXyOrsz5tgEPLlLexCFjHMtDDMNs
	NSzSyJI8VPGY0tDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CD30C13285;
	Thu, 23 Oct 2025 23:32:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rsc8JwO7+mjKXwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 23 Oct 2025 23:32:19 +0000
Message-ID: <6b0de8f3-d03a-4f12-b2f8-c87aeeef4847@suse.de>
Date: Fri, 24 Oct 2025 01:32:09 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf] netfilter: nft_connlimit: fix stale read of connection
 count
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org, louis.t42@caramail.com
References: <20251023232037.3777-1-fmancera@suse.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20251023232037.3777-1-fmancera@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9F6D31F388
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[caramail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[netfilter.org,caramail.com];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

On 10/24/25 1:20 AM, Fernando Fernandez Mancera wrote:
> nft_connlimit_eval() reads priv->list->count to check if the connection
> limit has been exceeded. This value can be cached by the CPU while it
> can be decremented by a different CPU when a connection is closed. This
> causes a data race as the value cached might be outdated.
> 
> When a new connection is established and evaluated by the connlimit
> expression, priv->list->count is incremented by nf_conncount_add(),
> triggering the CPU's cache coherency protocol and therefore refreshing
> the cached value before updating it.
> 
> Solve this situation by reading the value using READ_ONCE().
> 
> Fixes: df4a90250976 ("netfilter: nf_conncount: merge lookup and add functions")
> Closes: https://lore.kernel.org/netfilter/trinity-85c72a88-d762-46c3-be97-36f10e5d9796-1761173693813@3c-app-mailcom-bs12/
> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
> ---

While at this, I have found another problem with connlimit although with 
this fix, it is partially mitigated. Since d265929930e2 ("netfilter: 
nf_conncount: reduce unnecessary GC"), if __nf_conncount_add() is called 
more than once during the same jiffy, the function won't check if the 
connection is already tracked and will be added right away incrementing 
the count. This can cause a situation where the count is greater than it 
should and can cause nft_connlimit to match wrongly for a few jiffies.

I am open to suggestions on how to fix this.. as currently I don't have 
a different one other than reverting the commit..

Thanks,
Fernando.
