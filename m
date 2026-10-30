Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793373218;
	b=Z0ncCJEBG/+G+HbGr9bYrRKopBK39Jrfd7G8fFnoYSIkYEut/r5nzacSZRcWeoexSjy7
	 QdreDy6b60pqXgZih2gacVerEdGnwAi1igC0zlH5GzfGyZgQLAcLV9gm8BhoubKXUJlLJ
	 dTDCP62qn0DlIAREIFXt+8tGs0Fu3jI5I7XmC7FOmg1f4vlhuJqX4cB9M56pvEuGnRmYB
	 olBs6P7wAcY94bxy67z3Pn+pIIUzn0BM4NsONA50bwLIjHtjy2J3dbJ2NoA6U+w//c3wP
	 vp4LuRRUShlmnHDypeYyzN9wjNqaGoXXRbM+EycNm6a8QOOqJ511nsnUH0utE5Utp+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793373218;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=Isw6TcuTohVuxegsR292vKweDamfGld5wLvNDAtEWzk=;
	b=GfpGYMDiBK7VQgqmhUxMEebxo77VySTLdHulebFgj+A3YtUYUojUqsNh1/1elhK4dVlW
	 twjY3xnNSPHpAIqc8x7aNiYW0eLznrcNfmNS7cjxE/igkCEUVoGd/SCiAzhLsOhBBzKHv
	 9+izdT9JSQTINElyNw8nKOMQn7VaFPitDew2nqF959kmxQ7s8rB+dzRLuigGUKIHMlv89
	 4MLpi/Uvdc/Wx0lMTUFphIdCu9l3E/5gs5LuD1bwE5dPfRDuFoEtlgAOIHQCEgjip3lvn
	 lkLRdE0BVJ5r1IAnvCKS7ndcYqS9Oifnsh6PS29FjdJDZWbzSWDWbr0/Gu9do4XaDQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=IFSlRZiJ;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=hsQZfSVA;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=z9A0XMid;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=WJkyigdl;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0251E60A262D
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2026 15:13:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0251E60A262D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=IFSlRZiJ;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=hsQZfSVA;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=z9A0XMid;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=WJkyigdl
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D1B7C1FE7C;
	Fri, 30 Oct 2026 15:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793373216; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Isw6TcuTohVuxegsR292vKweDamfGld5wLvNDAtEWzk=;
	b=IFSlRZiJlll0rYyQHhyr7J2IBHBVMYugy5hRbopRBiUv0F3JB+uY1V/DG1LSsosne7PagO
	ZcPrZGJqjNzxcaeJXkZTnEI1QU97uVHUIfRpGdWpFfkLW4ky1OQU9+J5RcwijyqgjHOpga
	b5gx8Lnao88Et8VCAUZGOjl3an3fw/A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793373216;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Isw6TcuTohVuxegsR292vKweDamfGld5wLvNDAtEWzk=;
	b=hsQZfSVAvVLjQ0ZLOJImIhUU64Y+ZQJvCd22Fpb60bMkASn+0EMcI7Zlri/6MkgN9ocT1k
	iRnhLMM4KEGmxOAg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=z9A0XMid;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WJkyigdl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793373215; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Isw6TcuTohVuxegsR292vKweDamfGld5wLvNDAtEWzk=;
	b=z9A0XMidq3Zu57CFMng6QyBOBE9CgTrpfD1vPXdPRmKEMl6NuexLBRH117KmDR/rsb7y4u
	nEts7zcWaIeF4+DBxEh0qLfFBzfCaa7Z8KHz2gsB8KwFU7Dp3fdld8qIU1RHladMkWfV/z
	MqUkO3OCBsm9nGvEcxUlIqyTGWZcPvQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793373215;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Isw6TcuTohVuxegsR292vKweDamfGld5wLvNDAtEWzk=;
	b=WJkyigdlBFHckjFIHsHlhxt21RiBSyk4xhkEOST3Jf+y36x9h24A8DP6jv3BDT/GrHGv/n
	UFR9KLlrp7G7NqCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5F12E13432;
	Fri, 30 Oct 2026 15:13:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bA9bDB+05GoqSAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 30 Oct 2026 15:13:35 +0000
Message-ID: <01a502da-e5fa-4046-9d24-2dd84e8d5098@suse.de>
Date: Fri, 30 Oct 2026 16:12:19 +0100
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
Subject: Re: [PATCH nf] netfilter: nfnetlink_queue: keep socket ownership when
 expanding skb
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 pablo@netfilter.org, phil@nwl.cc, VEGA <vega@nebusec.ai>
References: <20261030135750.4452-1-fmancera@suse.de>
 <auSrTEnc8tibSGs2@strlen.de> <17f1cf11-ae17-46f6-a8a0-a23644411ab0@suse.de>
 <auSvco0w7wKkuyE9@strlen.de> <964c22e6-9be8-4896-8c7c-45d927789c97@suse.de>
 <auSysrRmBdIesdue@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <auSysrRmBdIesdue@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-13.50 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:dkim];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -13.50
X-Spam-Level: 
X-Rspamd-Queue-Id: D1B7C1FE7C

On 10/30/26 4:07 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> On 10/30/26 3:53 PM, Florian Westphal wrote:
>>> If you think its worth doing, then by all means, go for it!
>>
>> The ownership fix is trivial and already done so why not? Anyway, let's
>> see what does Pablo think and decide based on that. FWIW, I won't go for
>> the whole memory issue fix you mentioned before.
> 
> Its not trivial, unfortunately, this needs wmem adjustments depending
> on destructor type, else accouting is off and sk cannot be released
> anymore (or we release to early if truesize was reduced).

Ah that is right. I missed it. Thanks Florian, let me take a look if 
this does not take too much effort I might fix it. Otherwise let's drop 
it. Although we might hear about this in the future due to LLMs.

