Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235E8322749
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 09:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790068011; cv=none; b=LutIxdorIzL/4908W12BsxVTYZ+3rAaKY4cfrkn3WAylumx6Aa5f2qQV4NLU/NCWY97LpgZAopL0yWddRNL97O0mnw3rPEQO26Hamc6XkOY72cJcFjVZE8QuH0W/PMUP+bLI9p9ehapAM8CCM39Y+PbnzVVADd7tEapARgwJ0Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790068011; c=relaxed/simple;
	bh=/XKAimS1eTs1R1edZ5B3aUsTVn4W58SZU4bGJVY5plE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O0sOrGzyyRDqOL8HckHRdaSx3xymmZJzs3u+I2OYGZs9DUZSLgBVXKEM+WG+NDxZJsTsHx7JV83TD8aFDdFlKFJujNLdJlwJUWCHS9h/i7GX/rf55HjSRt6tCzsguLmNRQej/yC6LGRRG8c/dPwUhL45N6DOTXBu32cCwFchBF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=B+rdXlQa; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yUbeJA2/; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=2F1dyNyb; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3S/QV8UH; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="B+rdXlQa";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yUbeJA2/";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="2F1dyNyb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3S/QV8UH"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E875B21DBA;
	Tue, 22 Sep 2026 09:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790068004; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E7/kdSA733Ggdbg1tIchJb/5N1XFZXSLbQohBNBgIJs=;
	b=B+rdXlQauIORHy8PzIATda/49PtN6T16R9rEv9d9itBLB+av0Udpv4bFUHNPVX7fwVrawF
	JSdtlws4Gjqa19MU6gQ+9a/1/01j9DdMN+VXcsA5QgLnWm5LrmAGNtsVGuBa1bT5PJak1O
	ZitE4YLpP9NVwz479LFlUqfr5gO0jq0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790068004;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E7/kdSA733Ggdbg1tIchJb/5N1XFZXSLbQohBNBgIJs=;
	b=yUbeJA2/aVOKKHrXpCKi0Uww7OwAdLzBg+RjgbCBBDrtBusYb2i8huBafOd+DW+dXuvwbb
	3v7NHMl2KgO8yLDA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=2F1dyNyb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="3S/QV8UH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790067999; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E7/kdSA733Ggdbg1tIchJb/5N1XFZXSLbQohBNBgIJs=;
	b=2F1dyNybxojZg3/TtgADpbsQf8sTpPyLELlT5tNuKDeqI/dKDQo7vrwvwtbDATVVsutgMw
	RTD2dFjbAVIqU62xIQ6nNBnOjuwwLTIIkpEa6Lc8MAOwsEKpgB8jtGNDcmnEVUkYj1gTaW
	qs+RacDlh8LeftLql3gGOVUtA8czFJQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790067999;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E7/kdSA733Ggdbg1tIchJb/5N1XFZXSLbQohBNBgIJs=;
	b=3S/QV8UHTY7REpzLKELVunM40PUL0PS8xpEXDd/R8wgFKaUJ0m6SyvbN7K/iy2cU+KES3g
	GpbMHQ2sdWNpzjDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 67B1D132D3;
	Tue, 22 Sep 2026 09:06:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6NZbDh9FsmqoTQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 22 Sep 2026 09:06:39 +0000
Message-ID: <d074d3ea-b6b0-4aa5-98ad-6cc167e28801@suse.de>
Date: Tue, 22 Sep 2026 11:05:44 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf] netfilter: nft_reject: prevent unbounded recursion in
 output hooks
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 pablo@netfilter.org, phil@nwl.cc, eric@regit.org,
 Yu Junzhe <junzheyu1@gmail.com>
References: <20260921222925.3874-1-fmancera@suse.de>
 <arIdrbUtZyaH7QbQ@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <arIdrbUtZyaH7QbQ@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: E875B21DBA
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,netfilter.org,nwl.cc,regit.org,gmail.com];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:email,suse.de:mid];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51

On 9/22/26 8:18 AM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
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
>> packet egresses from a different hook, it cannot synchronously loop.
> 
> Won't nf_send_unreach() / unrach6 need the same guard?
> 
> If not, please explain why those are safe, its not clear to me.

Hi Florian,

If I am not wrong, those functions are safe. I initially thought it was 
needed too but after failing to reproduce the issue in that path I 
noticed that both icmp_send() and icmp6_send() are protected for 
recursions by disabling BH and using a xmit lock 
icmp_xmit_lock()/icmpv6_xmit_lock().

I will send a V2 mentioning this in the commit message so it is documented.

> 
> Patch looks good otherwise, thanks Fernando.
> 

Thanks Florian!
