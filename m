Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33309397B06
	for <netfilter-devel@vger.kernel.org>; Wed, 27 May 2026 21:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779916729; cv=none; b=Rm1NHhohr7wcCzYo6UuDUI1VJOQPQS4pXnA4MCvR/bQJrUbkr1zzS3zQNy6ViWZwtJeHV/WPTIE3NH70aU7XoRpjEzlrPMBCaVh9ukfDSqbLzBzESddzhSIEzwWCDFVKxmbhptjVT15Ca5ysNXE5OsNnBFJAxwk2mS5PBDCA8dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779916729; c=relaxed/simple;
	bh=BD6yebRIFku3/Rr5E0/S4ItPjrrqSoG7TA42eRVTCdc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ETzftrCTcx1GXJpxXOx5RReguKg5QyMNRCwaOeHpT3VpXp+Oz+PeU2jE0mJUGw6FyHt77Ot5EbFo4q0tBwfT08FrXa+tgdofGllYiNPy5m1iGbNl8RCZO/d4KffGrIPt81ROLcf6hfjnjtMri6koke3cGbMHC/iIzRais0OFAFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yDnC/DP0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=bI8JFUFf; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yDnC/DP0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=bI8JFUFf; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yDnC/DP0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="bI8JFUFf";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yDnC/DP0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="bI8JFUFf"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5EE1A67161;
	Wed, 27 May 2026 21:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779916726; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FksTk+/U3qHRWzlZirjHrqG+KmzsSOzl0id9MwVftUc=;
	b=yDnC/DP0H3S2nEypxc2PHl/RC9hdBpfBZgLgGgHlFgynIXs8Wjide+sF67x4GfA+hS4i5h
	FQ/6rl9wIbkVNS8+cD7JqVgF24ZL1hlyM0ZH+G5awSuigDn1G+HKDbd2BqSTmgWGjXtXiu
	Fef3NtCXBQ2NFOZhcOTWKafy76R3/dc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779916726;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FksTk+/U3qHRWzlZirjHrqG+KmzsSOzl0id9MwVftUc=;
	b=bI8JFUFfimxb0Wp+USBZZJEKkaEevw1Mbzp72XhKPMneeZbZNHqg7TUquia6oe8+asPgA7
	ft7roLMaV1KLHlDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="yDnC/DP0";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bI8JFUFf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779916726; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FksTk+/U3qHRWzlZirjHrqG+KmzsSOzl0id9MwVftUc=;
	b=yDnC/DP0H3S2nEypxc2PHl/RC9hdBpfBZgLgGgHlFgynIXs8Wjide+sF67x4GfA+hS4i5h
	FQ/6rl9wIbkVNS8+cD7JqVgF24ZL1hlyM0ZH+G5awSuigDn1G+HKDbd2BqSTmgWGjXtXiu
	Fef3NtCXBQ2NFOZhcOTWKafy76R3/dc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779916726;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FksTk+/U3qHRWzlZirjHrqG+KmzsSOzl0id9MwVftUc=;
	b=bI8JFUFfimxb0Wp+USBZZJEKkaEevw1Mbzp72XhKPMneeZbZNHqg7TUquia6oe8+asPgA7
	ft7roLMaV1KLHlDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7B1B55AA1D;
	Wed, 27 May 2026 21:18:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /wvbGrVfF2rkegAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 27 May 2026 21:18:45 +0000
Message-ID: <227b1ecb-89b2-4b1a-b330-345ed4aabbd6@suse.de>
Date: Wed, 27 May 2026 23:18:40 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] netfilter: nft_tunnel: fix use-after-free on object
 destroy
To: Tristan Madani <tristmd@gmail.com>,
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>, "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, Tristan Madani <tristan@talencesecurity.com>
References: <20260527135751.1031891-1-tristmd@gmail.com>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260527135751.1031891-1-tristmd@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 5EE1A67161
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.988];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_TO(0.00)[gmail.com,netfilter.org,strlen.de];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:dkim,suse.de:mid];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51

On 5/27/26 3:57 PM, Tristan Madani wrote:
> From: Tristan Madani <tristan@talencesecurity.com>
> 
> nft_tunnel_obj_destroy() calls metadata_dst_free() which directly
> kfree()s the metadata_dst, ignoring the dst_entry refcount. Packets
> that took a reference via dst_hold() in nft_tunnel_obj_eval() and
> are still queued (e.g. in a netem qdisc) are left with a dangling
> pointer. When these packets are eventually dequeued, dst_release()
> operates on freed memory.
> 
> Replace metadata_dst_free() with dst_release() so the metadata_dst
> is freed only after all references are dropped. The dst subsystem
> already handles metadata_dst cleanup in dst_destroy() when
> DST_METADATA is set.
> 
> Fixes: af308b94a2a4 ("netfilter: nf_tables: add tunnel support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tristan Madani <tristan@talencesecurity.com>

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

Thanks!
