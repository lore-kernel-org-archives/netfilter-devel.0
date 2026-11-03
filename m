Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793701084;
	b=w7jE+9VY2E0yHcUIJOE88rmirk/For8wIOPmcdPppV9hgopYfAqFNIQEBRwXi1YjIar9
	 tJGyQIMHgtCmHBkEeySPE+3wytV4G+kEs2oFHdoKxVp/VYTsFn/RpzutMDoe9XHiBiojS
	 dBSYdTuAB6XrFDGem/fQEySIO5eDjDI3VKERXWj0pD9M6Vl1gA6StVVO975CSnQZZ+0Wc
	 jsBB3eI+/KahsdZ2jNbTfslXeW7UWYfFfyXJiarAOQFUEQpBeJGAPdQr5xdYNU0fkzxdd
	 IXVypGwzlY9uqtQF1bAlLUzuVXkSscNUKniv/HLEohEdrJ9pVO+N1oven0NXqyZ8eHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793701084;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=yaS7yNbKpjTq/wdFXMRNNfI8QgdsYDKaRsynkutJv80=;
	b=4xMkIhNaa1ES56UIT+pFn9rOHAUGlyJ2hXziCTLzxaj4OREUL1xUq8pPwuMJhXT1Rghc
	 8El1RBFBghTHiiTRjStD2Ym4WbxZ5H6EI4qV+fJscNMGMteS5jDge2gn2PwDzO7vVViqr
	 lbaVE6A7O72Q3neLU+bsYIBx9bmBLOUW/zj9ivEyWsE1vglz1nyqXElChhCDu7Uk18cg+
	 uNg/g5iLJUn2KLn21eJbOcE9CTqCDyaUiHAYi+cAJp9ysnif5keaOP1184Ckr9fDUniKY
	 gjisbFfeyJ1ScRf4jNTDYeyrSbo9sWWMJNMkzqkmV5RcpA9dhqJuzfcLbmyOxBc6wkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=egqFE02S;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=asXO1zHk;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=egqFE02S;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=asXO1zHk;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9D06082BC5
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Nov 2026 10:18:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C9D06082BC5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=egqFE02S;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=asXO1zHk;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=egqFE02S;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=asXO1zHk
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9E55B22310;
	Tue,  3 Nov 2026 10:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793701081; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yaS7yNbKpjTq/wdFXMRNNfI8QgdsYDKaRsynkutJv80=;
	b=egqFE02SJK1yjk3WruMUPAjn9UJqm1TwtOjfODKKUhGvabSQO8lHv3A7M2gVaiT/PXnAc4
	bpSXAJFbY2yR1a5WPekBvQzw/hr1cb/S31B1PdkefYql01o3v44yE9iWZ0Gz7WSrhLRG4P
	XjrxaXe2DJR10rTdY4519RSL07vL1jU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793701081;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yaS7yNbKpjTq/wdFXMRNNfI8QgdsYDKaRsynkutJv80=;
	b=asXO1zHkGvRe0NvSZwePE2uCbQ04j2DpS4+T73G9/zb3zx/r2Rm59gT1Sh2W4/DFYlkN6y
	r/55jEIa2jfGmQCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=egqFE02S;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=asXO1zHk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793701081; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yaS7yNbKpjTq/wdFXMRNNfI8QgdsYDKaRsynkutJv80=;
	b=egqFE02SJK1yjk3WruMUPAjn9UJqm1TwtOjfODKKUhGvabSQO8lHv3A7M2gVaiT/PXnAc4
	bpSXAJFbY2yR1a5WPekBvQzw/hr1cb/S31B1PdkefYql01o3v44yE9iWZ0Gz7WSrhLRG4P
	XjrxaXe2DJR10rTdY4519RSL07vL1jU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793701081;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yaS7yNbKpjTq/wdFXMRNNfI8QgdsYDKaRsynkutJv80=;
	b=asXO1zHkGvRe0NvSZwePE2uCbQ04j2DpS4+T73G9/zb3zx/r2Rm59gT1Sh2W4/DFYlkN6y
	r/55jEIa2jfGmQCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 277B2134B8;
	Tue,  3 Nov 2026 10:18:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sW6/Odi06WoPegAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 03 Nov 2026 10:18:01 +0000
Message-ID: <4bd1fa01-983c-462f-8ccb-3e8e3d9482db@suse.de>
Date: Tue, 3 Nov 2026 11:16:37 +0100
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
Subject: Re: [PATCH nf v3] netfilter: nft_reject: prevent unbounded recursion
 in output hooks
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, fw@strlen.de,
 phil@nwl.cc, Yu Junzhe <junzheyu1@gmail.com>
References: <20260924201328.6323-1-fmancera@suse.de>
 <aufS5GcCmM590Q45@chamomile>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aufS5GcCmM590Q45@chamomile>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9E55B22310
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-13.50 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,netfilter.org,strlen.de,nwl.cc,gmail.com];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim]
X-Spam-Score: -13.50

On 11/2/26 1:01 AM, Pablo Neira Ayuso wrote:
> On Thu, Sep 24, 2026 at 10:13:28PM +0200, Fernando Fernandez Mancera wrote:
>> nftables payload-mangling rules can rewrite packet contents (such as TCP
>> flags) before they are evaluated by reject targets. This defeats the
>> content-based loop guards, allowing unbounded hook recursion that leads
>> to kernel stack exhaustion and panics.
>>
>> Fix this by extracting the per-CPU xmit recursion limit previously used
>> by the netdev duplication/forwarding paths into a shared header, and
>> apply it to the inet and inet6 reject transmit functions. It disables BH
>> while transmitting the skb to address a possible migration to different
>> CPU leading to imbalanced decrementation of the recursion counters.
>>
>> Note that the dev_queue_xmit() path used when CONFIG_BRIDGE_NETFILTER is
>> enabled does not require this recursion guard. In that scenario, the
>> generated reset packet is transmitted directly at Layer 2. Because the
>> packet egresses from a different hook, it cannot synchronously loop. In
>> addition nf_send_unreach() and nf_send_unreach6() are safe as the ICMP
>> transmit functions are protected against recursion by the
>> icmp_xmit_lock() and icmpv6_xmit_lock() guards.
> 
> Unrelated to this patch, but should ip_local_out() call in
> synproxy_send_tcp() be tracked by the recursion counter too?

Hi Pablo, you are right. I have reproduced the same on synproxy. I am 
sending a patch to nf tree.

Thanks for pointing it out Pablo!
