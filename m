Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26AC14B977
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Oct 2025 15:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760973840; cv=none; b=MzM2rTS4CuwSsffvxovzezl3k3WNj4hN3h2ZiSy1Wgcnrz2phFuHvzhDjxTcFZh15IYkYBgg/6Z6SRFWGN8jnNVe/FAEhaedjz6QsZhikp1EQtelQkkQzAb72/zsJOxITSuV2LXlsyEm+0dpYAPEB26y6ep5NnYjiXOV34QztAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760973840; c=relaxed/simple;
	bh=sZTiFPSl4V8p1tENMWu9iitimwsaq8sJakHqqsqSiPc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=deb8NJ9TaXtZRJF3Nwkx9MWp4J5bWeDjXcBZ61FQOArO/QA2Bhs61WPoYiJdhFein2+W+g8zjTc0Oaa6viEQm6M1uYiYzA/lfCfVP1sJgGur+FICGJ/6/e8I1SJGlnJfVlt37bAOMlVbcemTehoe12fncj9HqkijTu80sCyTCpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=cNuxrAUb; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NW7xWoM7; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1Zk+I93d; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=fQmtaqFq; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="cNuxrAUb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NW7xWoM7";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1Zk+I93d";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="fQmtaqFq"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 98C53211B3;
	Mon, 20 Oct 2025 15:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760973832; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rKyVwW/40783UbemXbIka2ZAUaFHtiB2dmtXnDiqd68=;
	b=cNuxrAUbt8p+N92bsJ0+W7djpsZ5oc1PfoHS/4hjZ7yiFKkw4XDbe97RWZYBwwZLvJ6Dss
	KMspxJD9jlAKoOCDkMYLATPhTUE+A6CovUh93e9+d2ia9QgrBBUpueyjRUhtVMBl9Jkqh3
	HEJ+kzsun7s/BeL+G+yYYAoS0o4B6T4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760973832;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rKyVwW/40783UbemXbIka2ZAUaFHtiB2dmtXnDiqd68=;
	b=NW7xWoM7Vo5Db6B1p3NYJW70eCyrjRKcHnK7fMCoBPZ2U4WVeUC4hUnxJtjwoi0a0k/yPB
	w8u4oZzAOcE4tHBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1Zk+I93d;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=fQmtaqFq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760973828; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rKyVwW/40783UbemXbIka2ZAUaFHtiB2dmtXnDiqd68=;
	b=1Zk+I93dvLyX82e6xB7w1+DHfISrf2ggbHUk+zbOaEKik2wkUQ/B6FvckczkxJOBHxAKXk
	ay7qVvtbKoo/+iHOIeknd19Fk4Bt0/K9LH9N5jxLohZLZ/PRyBINzxPGsb6NDecRPpyq02
	VV5wJ0LJvgLBsOLkP+TzLt1JRLAVf5E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760973828;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rKyVwW/40783UbemXbIka2ZAUaFHtiB2dmtXnDiqd68=;
	b=fQmtaqFqYJ6jpstILlGRaQUBkauDDhlGQvk0oYOQ2uk39eqOXxQkTKbMigiNc8nDZ4HFaJ
	SIPfr0CNVns2dzAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6DEC513AAD;
	Mon, 20 Oct 2025 15:23:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aDYMGARU9mj8VwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 20 Oct 2025 15:23:48 +0000
Message-ID: <a641ebd1-c2de-478d-bbba-68eaed580fd9@suse.de>
Date: Mon, 20 Oct 2025 17:23:47 +0200
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
 <a2686aa3-adc4-4684-9442-ab4ad9654c69@suse.de> <aPZGOudKuDa5HMmS@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aPZGOudKuDa5HMmS@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 98C53211B3
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.51



On 10/20/25 4:24 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> On 10/19/25 4:17 PM, Florian Westphal wrote:
>>>> In addition I noticed that when a kernel splat happens the ruleset that
>>>> triggered it isn't saved anywhere, it would be nice to save them so we have
>>>> a reproducer right away.
>>>
>>> I had such code but removed it for this version.
>>>
>>> I can send a followup patch to re-add it but I think that it is better
>>> for kernel fuzzing to extend knft acordingly, as nft is restricted by
>>> the input grammar wrt. the nonsense that it can create.
>>>
>>
>> That is fine for me, I still have pending to try knft which I might do
>> this week if I have time. If we do not want to save which ruleset
>> generated the kernel splat I would drop netlink-rw mode completely..
> 
> Hmmm.... I'm not sure on this.  It would be a bit of a silly limitation.
> Its not like -rw adds a huge chunk of code.
> 
> The store code wasn't too bad, back then I added some scripting for
> allow to e.g. call nft flush ruleset periodically and that was more code
> than strictly needed for pure nft (-ro mode) fuzzing.
> 
>> Yes, it seems we found the same issue. I do not have a solution on the
>> control plane although I was about to send this patch for data plane.
>>
>> diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
>> index 6557a4018c09..ddc4943d082c 100644
>> --- a/net/netfilter/nf_tables_core.c
>> +++ b/net/netfilter/nf_tables_core.c
>> @@ -251,10 +251,10 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
>>    {
>>           const struct nft_chain *chain = priv, *basechain = chain;
>>           const struct net *net = nft_net(pkt);
>> +       unsigned int stackptr = 0, jumps = 0;
>>           const struct nft_expr *expr, *last;
>>           const struct nft_rule_dp *rule;
>>           struct nft_regs regs;
>> -       unsigned int stackptr = 0;
>>           struct nft_jumpstack jumpstack[NFT_JUMP_STACK_SIZE];
>>           bool genbit = READ_ONCE(net->nft.gencursor);
>>           struct nft_rule_blob *blob;
>> @@ -314,6 +314,9 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
>>
>>           switch (regs.verdict.code) {
>>           case NFT_JUMP:
>> +               jumps++;
>> +               if (WARN_ON_ONCE(jumps > 256))
>> +                       return NF_DROP;
>>                   if (WARN_ON_ONCE(stackptr >= NFT_JUMP_STACK_SIZE))
>>                           return NF_DROP;
>>                   jumpstack[stackptr].rule = nft_rule_next(rule);
>>
>> Currently with enough jumps chained together and traffic generated, CPU
>> can get stuck on nft_do_chain() triggering a kernel splat. If there is a
>> solution on data plane it would be much better than this of course.
> 
> There is this patch:
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20250728040315.1014454-1-brady.1345@gmail.com/
> 
> I planned to push it upstream in this merge window.
> 

This looks quite good. I tested it and seems to solve the problem, great!
