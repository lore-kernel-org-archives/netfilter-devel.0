Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE17435837E
	for <netfilter-devel@vger.kernel.org>; Fri, 22 May 2026 09:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779443528; cv=none; b=XHWY72+zNCz4EEL0KOqsXw77Y/0OVG6bgr9/l5K9sTey5OBsLHDH+9lXUOf5KdsO+VvlyXYJCPjjp4oPRx5mXxTb7hNLpPQisoJsX/t5BYQ1izr3Ky0p6msFVe+typoYZWArGpy9pP2a4GHp4qk3Td8FtSTfE5IYp4ZxNkeMWQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779443528; c=relaxed/simple;
	bh=ewmcPvNAWoJZdcEKBhmQ+LCOXRWGT9iDGK4PXN5HQMQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=QxtfLKTF9p9oNuXzZOFnc88FCU9Up1VZT2eE9dHN7qtlViaa5N2kJ7GrDYf5jBxr5gBjQEI+YbUpIhhYZxSODfsqsgrcPUPRqejoDnuS1Jg1ocJcdpWAQIEgRKgCWandHYmVIN6LHh1bj6AxZceUA25axY+Oo/Hx9PQZ5QT5oxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=iLl9LJ4p; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vTjXohUT; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=iLl9LJ4p; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vTjXohUT; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="iLl9LJ4p";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vTjXohUT";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="iLl9LJ4p";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vTjXohUT"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0BB3667B5F;
	Fri, 22 May 2026 09:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779443525; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k9Nsr5l3boRDOy2IqOMaX4U7QnIHpNCi1uU7kVxrgPQ=;
	b=iLl9LJ4peWAS7SOYHPjJltYr8ZvQLr8HAOlEpdzhg8MSplZY1LZzZaw/973A0OWBqTii/I
	TK9wSx0slfzrTg46UOXPRuqVW/ZwxZ+fuICHuxNyhAeIF5SL3ILVh+MqtAfV+jkjXHnVbv
	lqVB4uUfimeBWtJeJGpbVxihngvzwBw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779443525;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k9Nsr5l3boRDOy2IqOMaX4U7QnIHpNCi1uU7kVxrgPQ=;
	b=vTjXohUTXtmzma5Ylbbbbn7J2u3Ga9tcsfw7tTm4fZoo/kmrolhDR+xiBix4t201hCoj1r
	6MNmX+4Hg0sdyaBw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779443525; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k9Nsr5l3boRDOy2IqOMaX4U7QnIHpNCi1uU7kVxrgPQ=;
	b=iLl9LJ4peWAS7SOYHPjJltYr8ZvQLr8HAOlEpdzhg8MSplZY1LZzZaw/973A0OWBqTii/I
	TK9wSx0slfzrTg46UOXPRuqVW/ZwxZ+fuICHuxNyhAeIF5SL3ILVh+MqtAfV+jkjXHnVbv
	lqVB4uUfimeBWtJeJGpbVxihngvzwBw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779443525;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k9Nsr5l3boRDOy2IqOMaX4U7QnIHpNCi1uU7kVxrgPQ=;
	b=vTjXohUTXtmzma5Ylbbbbn7J2u3Ga9tcsfw7tTm4fZoo/kmrolhDR+xiBix4t201hCoj1r
	6MNmX+4Hg0sdyaBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2A7DD593AD;
	Fri, 22 May 2026 09:52:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TGsQFUInEGr6XQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 22 May 2026 09:52:02 +0000
Message-ID: <89ebf61b-b7c1-4309-a1ce-44c6de88072c@suse.de>
Date: Fri, 22 May 2026 11:51:58 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] netfilter: synproxy: refresh tcphdr after
 skb_ensure_writable
To: Chris Mason <clm@meta.com>, netfilter-devel@vger.kernel.org,
 Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>
References: <20260519194841.63794-1-clm@meta.com>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260519194841.63794-1-clm@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	internal_greylist_whitelist(0.00)[10.150.64.97];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO

On 5/19/26 9:36 PM, Chris Mason wrote:
> synproxy_tstamp_adjust() rewrites the TCP timestamp option in place
> and then patches the TCP checksum via inet_proto_csum_replace4() on
> the caller-supplied tcphdr pointer.  Both ipv4_synproxy_hook() and
> ipv6_synproxy_hook() obtain that pointer with skb_header_pointer()
> before calling in, so it may either alias skb->head directly or
> point at the caller's on-stack _tcph buffer.
> 
> Between obtaining the pointer and using it, the function calls
> skb_ensure_writable(skb, optend), which on a cloned or non-linear
> skb invokes pskb_expand_head() and frees the old skb->head.  After
> that point the cached th is stale:
> 
>      caller (ipv[46]_synproxy_hook)
>        th = skb_header_pointer(skb, ..., &_tcph)
>        synproxy_tstamp_adjust(skb, protoff, th, ...)
>          skb_ensure_writable(skb, optend)
>            pskb_expand_head()        /* kfree(old skb->head) */
>          ...
>          inet_proto_csum_replace4(&th->check, ...)
>                                      /* writes into freed head, or
>                                         into the caller's stack copy
>                                         leaving the on-wire checksum
>                                         stale */
> 
> The option bytes are written through skb->data and are fine; only
> the checksum update goes through th and so lands in the wrong
> place.  The result is either a write into freed slab memory or a
> packet leaving with a checksum that does not match its payload.
> 
> Fix by re-deriving th from skb->data + protoff immediately after
> skb_ensure_writable() succeeds, so the subsequent checksum update
> targets the linear, writable header.
> 
> Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
> Assisted-by: kres (claude-opus-4-7)
> Signed-off-by: Chris Mason <clm@meta.com>

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

Thanks, Sashiko flagged other issues that I am now addressing..
