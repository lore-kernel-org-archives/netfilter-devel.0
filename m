Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726F128D8DA
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 11:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761306909; cv=none; b=bYdHU3IhP/QdDbJ4FZSqZDEq4lkNheizKHafrqku66rMkN08S5xN/go/Rl1NxZCdLNIEs1YxZ+IlX5prF7IL6t87Q32SV10MBm2HbyQfQ+z2WaSXhf5/C+VUm7MRGBc567SLbYTkhuC4PdYIJw2+hzpYO8OjyVCxCk22UWMn1kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761306909; c=relaxed/simple;
	bh=dsEXtH4fFOcQwRxovgZAaPwkGtGQoFusI3Ju0bdPWDI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WfQkLhpXn0jcRXn0e0zwW9XJz1Y+NW83KLiLOlQTV6v7b2+g0LlE95w1c0l1tjsQXddiieLJI9irkJRX1XD3TgJ9JG3eFCxKTPnv3vGqNBHZDb6xD/lX6txPar2beZA+MUlxSqwCguu4xAM5jTBLIYUhiSB6Uz4Fmeo2heqp8wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xW4keDg7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Y8GElQh/; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hYCZARDc; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=SMAPzlT8; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xW4keDg7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Y8GElQh/";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hYCZARDc";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SMAPzlT8"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5EEEB211AA;
	Fri, 24 Oct 2025 11:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761306905; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RjE2ZpDRpdV7uJQ8p3vTrc0AWwJ3OeKvGo/0+4vOEqg=;
	b=xW4keDg7zEq4GsNHRgjnzEddljKvxgak6YKdJHQk0usLkGzmC85RomCIqHj6AwxfnxSbt2
	ffZldMBXLFPmIc5yipeQYzfxQOtK+c9g0FHNV8QsraeZ1Jdp+XNheM3onKjYMruY8df4/3
	3fby1u9EceGj4A16GqdBF5bn4E0zIJ8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761306905;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RjE2ZpDRpdV7uJQ8p3vTrc0AWwJ3OeKvGo/0+4vOEqg=;
	b=Y8GElQh/EXr7izxEroCNa9wfw21JO4dLSFGry9bDs/hSp/1+PjTgkEpCNZP+qPewqb4rFX
	a4EETAfkbV3ZSVDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761306904; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RjE2ZpDRpdV7uJQ8p3vTrc0AWwJ3OeKvGo/0+4vOEqg=;
	b=hYCZARDcYPjS8d0qKRzTlO4QxiAMOUlM12n6N70GCB1FY4yZ/5GyCu1aO/6BMBTa4O128y
	Ydd13grnhTqfrqFPxjL8q/3eVBFyhVwNx66GKkAsVDwwCK/KuVBLMu/EElks/noCc2VyV8
	25/KjCsb4ZB675Q4EtAsgU8HaU1Ipok=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761306904;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RjE2ZpDRpdV7uJQ8p3vTrc0AWwJ3OeKvGo/0+4vOEqg=;
	b=SMAPzlT8e7olcIa8/yjhhAnJISM9UxJuF5lQ0qa3uc5/10vZ5ZXoOEg7IUM4mA7ezd/5Ws
	m8kPlCK+jpA+yVCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 16FF1132C2;
	Fri, 24 Oct 2025 11:55:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IHhgAhhp+2i7JwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 24 Oct 2025 11:55:04 +0000
Message-ID: <9d15bc0f-e41d-400b-9e3b-84f6ba1688f7@suse.de>
Date: Fri, 24 Oct 2025 13:55:03 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf] netfilter: nft_connlimit: fix stale read of connection
 count
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 louis.t42@caramail.com
References: <20251023232037.3777-1-fmancera@suse.de>
 <aPtjnNZncIqh19Jl@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aPtjnNZncIqh19Jl@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[caramail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,netfilter.org,caramail.com];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 



On 10/24/25 1:31 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> nft_connlimit_eval() reads priv->list->count to check if the connection
>> limit has been exceeded. This value can be cached by the CPU while it
>> can be decremented by a different CPU when a connection is closed. This
>> causes a data race as the value cached might be outdated.
>>
>> When a new connection is established and evaluated by the connlimit
>> expression, priv->list->count is incremented by nf_conncount_add(),
>> triggering the CPU's cache coherency protocol and therefore refreshing
>> the cached value before updating it.
>>
>> Solve this situation by reading the value using READ_ONCE().
> 
> Hmm, I am not sure about this.
> 
> Patch looks correct (we read without holding a lock),
> but I don't see how compiler would emit different code here.
> 
> This patch makes no difference on my end, same code is emitted.
> 
> Can you show code before and after this patch on your side?

I did `make net/netfilter/nft_connlimit.s` for before and after, then I 
diffed both files with diff -u:

I see a difference on how count is being handled.

@@ -984,19 +984,19 @@
  # net/netfilter/nft_connlimit.c:46: 	if 
(nf_conncount_add(nft_net(pkt), priv->list, tuple_ptr, zone)) {
  	testl	%eax, %eax	# _30
  	jne	.L65	#,
-# net/netfilter/nft_connlimit.c:51: 	count = priv->list->count;
-	movq	8(%rbx), %rax	# MEM[(struct nft_connlimit *)expr_2(D) + 8B].list, 
MEM[(struct nft_connlimit *)expr_2(D) + 8B].list
+# net/netfilter/nft_connlimit.c:51: 	count = READ_ONCE(priv->list->count);
+	movq	8(%rbx), %rax	# MEM[(struct nft_connlimit *)expr_2(D) + 8B].list, _31
+	movl	88(%rax), %eax	# MEM[(const volatile unsigned int *)_31 + 88B], _32
  # net/netfilter/nft_connlimit.c:53: 	if ((count > priv->limit) ^ 
priv->invert) {
-	movl	88(%rax), %eax	# _31->count, tmp155
-	cmpl	%eax, 16(%rbx)	# tmp155, MEM[(struct nft_connlimit *)expr_2(D) + 
8B].limit
+	cmpl	%eax, 16(%rbx)	# _32, MEM[(struct nft_connlimit *)expr_2(D) + 
8B].limit
  	setb	%al	#, _34
  # net/netfilter/nft_connlimit.c:53: 	if ((count > priv->limit) ^ 
priv->invert) {
  	cmpb	20(%rbx), %al	# MEM[(struct nft_connlimit *)expr_2(D) + 
8B].invert, _34
  	jne	.L69	#,
  .L61:
