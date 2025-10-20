Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132647261A
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Oct 2025 14:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760969523; cv=none; b=XcjJ70G91YNpAtkRO28JrnS13jOHG0F64G79WaEq7oi8y2aGqr2ThVKInDsL5bCmMcUcMBC9+WlCSNJy4H7PzEoMp7VrIf+KxAHvO5KeZFcRnVKQgDrkYqhQFXtTkyAGomSwJL09ig7PRQBcnAeTBbHEBX1FI9oKIRi/XyaP2HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760969523; c=relaxed/simple;
	bh=L9cnSGv5WUb5BbO1y/PZtvQTi2adcf5iNrnmDaQI3MM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UUZUNvXZbNl8Oe0poxAsWhgrrCEHG96OTF6Um6D32BXzzNNbWAd8vhZnkmbc+sVYgpuiCjSFRVW5cIRaIMhIRYgS/1mp9AlPu+tYFNTdmqznFlw/T79N3q3A7W6uLnnCVk4EkzhHodtUvrjhFQoGlWVFAYSl2pXcvnFG8OimQGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kgixuswK; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=e2Y2x1Vb; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=O1g5YHf6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ClOZCua+; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kgixuswK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="e2Y2x1Vb";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="O1g5YHf6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ClOZCua+"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 02DD82117A;
	Mon, 20 Oct 2025 14:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760969516; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GRJ8EXDt9ozcGPHkqVQkA4OXN/Oi1zQlb2lTYjnTDkE=;
	b=kgixuswK/ka5HAuYorwX6vCJnMatBITkWmxH06R8k9IJ0ORFyhl7coVvZpp7Fv0qCgE5p8
	I9QhlDDS9UfNFGfceNoKsAEZiDisKGvV2lkx2R5qn8CjRhixJs608JyKVJAZ0PZFcpewtI
	lTkOaRPwW5uEp8+Rlc5hwmvoObe4NCk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760969516;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GRJ8EXDt9ozcGPHkqVQkA4OXN/Oi1zQlb2lTYjnTDkE=;
	b=e2Y2x1Vbukzbd99urJ1BOEo6SUz+VEJ/EL+/pPBM8EEpOekG00p7YClCvgb8uFdRml5Inx
	ueFxwslwgGLuDVBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760969512; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GRJ8EXDt9ozcGPHkqVQkA4OXN/Oi1zQlb2lTYjnTDkE=;
	b=O1g5YHf6c2zm5fp9uMo0d/cI6Q41EE4WNgx1sAxCLJmZwpUK9eW3EGFs9xuoD46eMg734z
	nB0+IuEcEKhpPlOpJCAfNIFRFzp0jiXLeyGeWmGDENNxXnLZW+rRy0sVaUuk236JllQ4Bo
	z0HokoRiJyvIy7opaQYKmHQXfdniy+g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760969512;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GRJ8EXDt9ozcGPHkqVQkA4OXN/Oi1zQlb2lTYjnTDkE=;
	b=ClOZCua+ekao1pEf3n3l1urmo/hpfyfHr3HfgcvUOhPcLkweuq4SfRLxbkX3pn9T/ZVVdz
	7C3SNJj87V2y1rAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CB0D013AAC;
	Mon, 20 Oct 2025 14:11:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LzGiLidD9miPEwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 20 Oct 2025 14:11:51 +0000
Message-ID: <a2686aa3-adc4-4684-9442-ab4ad9654c69@suse.de>
Date: Mon, 20 Oct 2025 16:11:43 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nft v2] support for afl++ (american fuzzy lop++) fuzzer
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
References: <20251017115145.20679-1-fw@strlen.de>
 <ddf0bfea-0239-42bd-ba1b-5e6f340f1af4@suse.de> <aPTzD7qoSIQ5AXB-@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aPTzD7qoSIQ5AXB-@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 



On 10/19/25 4:17 PM, Florian Westphal wrote:
>> In addition I noticed that when a kernel splat happens the ruleset that
>> triggered it isn't saved anywhere, it would be nice to save them so we have
>> a reproducer right away.
> 
> I had such code but removed it for this version.
> 
> I can send a followup patch to re-add it but I think that it is better
> for kernel fuzzing to extend knft acordingly, as nft is restricted by
> the input grammar wrt. the nonsense that it can create.
> 

That is fine for me, I still have pending to try knft which I might do 
this week if I have time. If we do not want to save which ruleset 
generated the kernel splat I would drop netlink-rw mode completely..

>> I have a server at home that I am not using.. I would love to automate a
>> script to run this in multiple VMs and generate reports :)
> 
> Yes, that would be good.  Note that I still primarily use it with
> netlink-ro mode to not exercise he kernel, its easy to make graph
> validation (or abort path) take very long to finish.
> 
> There is still a patch series in the queue to limit jumps in nftables
> and I did not yet have time in looking at the abort path, Its simply not
> an issue for normal cases (you assume the input is going to be
> committed...).  But for faster netlink-rw/knft fuzzing it would make
> sense to look into async abort (like we do for commit cleanup).
> 

Yes, it seems we found the same issue. I do not have a solution on the 
control plane although I was about to send this patch for data plane.

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 6557a4018c09..ddc4943d082c 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -251,10 +251,10 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
  {
         const struct nft_chain *chain = priv, *basechain = chain;
         const struct net *net = nft_net(pkt);
+       unsigned int stackptr = 0, jumps = 0;
         const struct nft_expr *expr, *last;
         const struct nft_rule_dp *rule;
         struct nft_regs regs;
-       unsigned int stackptr = 0;
         struct nft_jumpstack jumpstack[NFT_JUMP_STACK_SIZE];
         bool genbit = READ_ONCE(net->nft.gencursor);
         struct nft_rule_blob *blob;
@@ -314,6 +314,9 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)

         switch (regs.verdict.code) {
         case NFT_JUMP:
+               jumps++;
+               if (WARN_ON_ONCE(jumps > 256))
+                       return NF_DROP;
                 if (WARN_ON_ONCE(stackptr >= NFT_JUMP_STACK_SIZE))
                         return NF_DROP;
                 jumpstack[stackptr].rule = nft_rule_next(rule);

Currently with enough jumps chained together and traffic generated, CPU 
can get stuck on nft_do_chain() triggering a kernel splat. If there is a 
solution on data plane it would be much better than this of course.
