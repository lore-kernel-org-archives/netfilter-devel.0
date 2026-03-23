Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C137B362147
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Mar 2026 10:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774262079; cv=none; b=MZr7d11HRhr/KFfpji0unw5I6nU0ZNbkD3PNHyJ4K5sDSGY/6I1OqrlA7bL8sOe1YxqriouYu/oYgA3fRG9u9q7UJKpwsF8BHaYD/d29/MYz1aMSV09bJR7Nw5jlEcSuulo97X4CSUs8t+in0nUjKC15tqYsWSFa3dUmVYBFloM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774262079; c=relaxed/simple;
	bh=+f9x5hLK3THl6/AZT21yeR8M5KU4iNXXerSTHV5AzCA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=kSrN8B8Ei3Bsl3CbKDxgIFsJDPKo8uPXqB8CFwdiKKNnLH39T/DqHj2KjpGgV3JXvnbESck6dYZ63DVT2qkzmChuAWKen5ZOmTI/5g+ne6uGgeyZN4VLCRUKg9Wgenou7+8pxSvTQfmwFNJD7gPgCpk09ojlnLw6cUceYWo5pqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=YFhFSiPo; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=QZgFCSKL; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=YFhFSiPo; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=QZgFCSKL; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="YFhFSiPo";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="QZgFCSKL";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="YFhFSiPo";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="QZgFCSKL"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0BD285BDB4;
	Mon, 23 Mar 2026 10:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774262077; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hIsNmltsRjGf4AjeUncJ7Vj71UuQzde3cou4Rr+TMEM=;
	b=YFhFSiPoH08F8iQm1kACnIyGdZwoCnAIHt47p+eV9vRZaEP6cmGqgW6OM76AX7TMSvEHS3
	L/4tl0xHd4bVPss7qI7jdPIY3u70sbm+5YdBNtRL7hFNWY2E9siQr+hyphr9A4AjhKPfyW
	beM7sSagBA+51hgSPLdAO09IjV1dncc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774262077;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hIsNmltsRjGf4AjeUncJ7Vj71UuQzde3cou4Rr+TMEM=;
	b=QZgFCSKL42YmDZ1jSf+ttyvqgbn6aPe/P7/b/kegTgGw1C1J+DG21mkMZ5IV7avGYkYZs0
	VG8XIeMMMA2KeGAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YFhFSiPo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QZgFCSKL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774262077; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hIsNmltsRjGf4AjeUncJ7Vj71UuQzde3cou4Rr+TMEM=;
	b=YFhFSiPoH08F8iQm1kACnIyGdZwoCnAIHt47p+eV9vRZaEP6cmGqgW6OM76AX7TMSvEHS3
	L/4tl0xHd4bVPss7qI7jdPIY3u70sbm+5YdBNtRL7hFNWY2E9siQr+hyphr9A4AjhKPfyW
	beM7sSagBA+51hgSPLdAO09IjV1dncc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774262077;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hIsNmltsRjGf4AjeUncJ7Vj71UuQzde3cou4Rr+TMEM=;
	b=QZgFCSKL42YmDZ1jSf+ttyvqgbn6aPe/P7/b/kegTgGw1C1J+DG21mkMZ5IV7avGYkYZs0
	VG8XIeMMMA2KeGAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D40BC4381E;
	Mon, 23 Mar 2026 10:34:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gamVMDwXwWkbJwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 23 Mar 2026 10:34:36 +0000
Message-ID: <a45d0b9d-e6d3-474b-846c-7be069111cf4@suse.de>
Date: Mon, 23 Mar 2026 11:34:29 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf-next] netfilter: osf: add deprecation notices
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20260323085629.43927-1-fw@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260323085629.43927-1-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_TWO(0.00)[2];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:dkim,suse.de:email,strlen.de:email];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 0BD285BDB4

On 3/23/26 9:56 AM, Florian Westphal wrote:
> The p0f fingerprints haven't been updated in years, it doesn't look like
> this feature is still in a useful/working state.
> 
> Add deprecation notices.  We can remove them again if people still use this
> feature.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

It makes sense, rest in peace "osf".

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
