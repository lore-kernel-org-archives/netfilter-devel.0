Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793352289;
	b=YHvuEw/qc7qb1BrcSaOfklYmrUmd9ogxubKfZ4u6sMYF1UxkIGo3L/kHa+FxQoqPhUbs
	 CJ+T3GYph9DT8NjQVaMMFAH7nDkB39knzcLKAtAPk21zBDxj6hOk/pq5wJ8eMyomKeo8x
	 rt0cLxnAMT3kKKvXeRFZufxq4JlH6N+rnTrFVhO43H3335bG6wfmDJ4hRNNTFUHL+CXhv
	 RhmUjKjwUlFhOOCOobMC1bQhlrTo0l+WRtXJJ16BvzvBKXE0b6QUxdiYChRqWsZq2/bxJ
	 yCMdQ5VVleS0DWcz93JtnIE/4b+AJHYkOMeiDv2uaB40NsINrY9VOux2+NhfWXHPjbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793352289;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=C0z1va5Akm+5RadyFgkvlghZRPvTOoivc3esiRH//nA=;
	b=sqAy22oVEXmKingmaJjlBBP3wt243SuQFHD42qMBGKY7qksh5hVEUks0Zew1RbTAaY1l
	 r81YCLwtI31Obprmahr2Sso6STpzgMKsUcJ6o/40fCRbZIVddsTg7Pl/gIqtLufOWSCSo
	 4d+RoufkqxUvTEuxUFgi8ZMwd6IkiU4A/CVEkrHMxI0qY/+Xww4wMmLLq6Wmt58dEyLKG
	 LZL771F95RVCkm5AQZWHlcD7V06K8XW4oDjq59XuV1dihrTRhtA6pkVsLBxGCqfuSeIvv
	 xppz68mYPLLrA+PVdR5rvpmHus3xGzDsW47D84ctucWO4zujnHPUTGvdr1aJAwrq7gA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b="KYfM/Rgj";
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=U7vUBjfN;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b="KYfM/Rgj";
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=U7vUBjfN;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05321606A339
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2026 09:24:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 05321606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=KYfM/Rgj;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=U7vUBjfN;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=KYfM/Rgj;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=U7vUBjfN
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 136BE220DE;
	Fri, 30 Oct 2026 09:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793352287; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C0z1va5Akm+5RadyFgkvlghZRPvTOoivc3esiRH//nA=;
	b=KYfM/Rgj5KHMiG3iVVYh7eBeR4+2XYVnk/9KzLXykSSC7X+4khxZ6CtkMLsQRFzs7A3aPR
	dGkqeIFvUKoSKd38DAM5gHCYIjXRnOzetz5nj/NSXBbPw4MQf+gZo+dyMZOMX27AZkn55H
	VMEpBiNLwrM5OdTb8M3HoWmERJnZFvA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793352287;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C0z1va5Akm+5RadyFgkvlghZRPvTOoivc3esiRH//nA=;
	b=U7vUBjfNUYECPhNNDdCKx6PBbcp6xYUg0UuC775EGscGLDCefCK7fYOztz9V3Pb6L/o1IA
	Oiy8gvIr/r5L4nDQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="KYfM/Rgj";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=U7vUBjfN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793352287; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C0z1va5Akm+5RadyFgkvlghZRPvTOoivc3esiRH//nA=;
	b=KYfM/Rgj5KHMiG3iVVYh7eBeR4+2XYVnk/9KzLXykSSC7X+4khxZ6CtkMLsQRFzs7A3aPR
	dGkqeIFvUKoSKd38DAM5gHCYIjXRnOzetz5nj/NSXBbPw4MQf+gZo+dyMZOMX27AZkn55H
	VMEpBiNLwrM5OdTb8M3HoWmERJnZFvA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793352287;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C0z1va5Akm+5RadyFgkvlghZRPvTOoivc3esiRH//nA=;
	b=U7vUBjfNUYECPhNNDdCKx6PBbcp6xYUg0UuC775EGscGLDCefCK7fYOztz9V3Pb6L/o1IA
	Oiy8gvIr/r5L4nDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C3162132C9;
	Fri, 30 Oct 2026 09:24:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ylfoJF5i5Gq7WQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 30 Oct 2026 09:24:46 +0000
Message-ID: <b6dd522c-dee9-4b64-9ac3-b11e03b21135@suse.de>
Date: Fri, 30 Oct 2026 10:23:31 +0100
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf] netfilter: nat: zero newrange before filling it in
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20261029165445.3745-1-fw@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20261029165445.3745-1-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-13.50 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -13.50
X-Spam-Level: 
X-Rspamd-Queue-Id: 136BE220DE

On 10/29/26 5:54 PM, Florian Westphal wrote:
> nf_nat_masquerade_ipv4(), nf_nat_masquerade_ipv6(), netmap_tg4() and
> netmap_tg6() each build a stack-local struct nf_nat_range2 from the
> caller-supplied range, inheriting range->flags unmodified. Two of them
> only memset() the min_addr/max_addr members, the other two don't
> memset() anything at all, so newrange.base_proto is left as stack
> garbage.
> 
> If the inherited flags include NF_NAT_RANGE_PROTO_OFFSET,
> nf_nat_l4proto_unique_tuple() reads range->base_proto.all to compute
> the NAT port offset. Neither the NETMAP nor the MASQUERADE targets
> mask the flags field in their checkentry callback, so this
> uninitialized stack value can end up feeding the NAT port selection.
> 
> The per-member memset()s are not enough: they have to enumerate every
> field that must be cleared, and base_proto was missed when
> NF_NAT_RANGE_PROTO_OFFSET/base_proto was added to the struct. memset()
> the whole struct instead, so every member is covered regardless of
> which ones get explicitly assigned afterwards.
> 
> There are other places that miss this, but those hardcode .flags so
> nat core won't read from the uninitialized fields.
> 
> C99 initializers would be preferrable, but this is a more intrusive
> change.  Lets followup in nf-next and convert others as well.
> 
> This is an LLM finding.
> 
> Fixes: 2eb0f624b709 ("netfilter: add NAT support for shifted portmap ranges")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

I agree that using C99 struct initializers would be preferrable but 
let's look into that later.

Thanks Florian!

