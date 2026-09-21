Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDC23C09E8
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Sep 2026 10:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789986791; cv=none; b=I8f297YWspAWhqswMy5RaoQoOUc9uXsKH0v9R+mSEIQiZQ1adNqOQc8dTnTZo0/49CINHBoUPCJV7qe7Ezo8ILgjpDeIwJ/oxJ6JPNyANOF9dfwM11nan6PbIoPdyeBcc7n7m/yfp50d7LzZSO1KgpHqutDrs7qn4OY9gZttYus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789986791; c=relaxed/simple;
	bh=2a0um1jI0q4DbgUWsC6RYQSdsNTtstgPBA343SpwgG8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rn8fbMzhl50zXN1wAJ9p7CV3XHFipDjW2GwbxxqEf75W0e8u2MXrjdJLj8Vvn4vMzmeatmIRhstpROOm+5nRlhhmujM1+RfkyzCD+w6Op1GJbHMmsIXIYPvqvEapn4sa9xZOokzZraP/qpSQGOCCS4S/zuf5f/2tgSp7KA6iBbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DckPWZVb; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ZOgPZvKW; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xVldDPoN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=bVuAyloW; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DckPWZVb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ZOgPZvKW";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xVldDPoN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="bVuAyloW"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2411321ABA;
	Mon, 21 Sep 2026 10:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789986783; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EMBPNS5tBT6RED7zRj4Dbpw0rJ79c1uwrkHz177/Nv4=;
	b=DckPWZVb7lO2/0+RCyTz7Z4SqLSurjT6m5ogC7TMppSkPRudqSnimED/oGiy9XP4/6naQZ
	qITTt3CaIkroUncgtaNfPnSkmVertYX+RtYJQPH50XzGOaIzKxLBuUxJLKcYUN2+J7S+v6
	X7SqSTQOW66LO47FGuwGXY+Axv1XRvg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789986783;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EMBPNS5tBT6RED7zRj4Dbpw0rJ79c1uwrkHz177/Nv4=;
	b=ZOgPZvKW0octw3eogkXng/wCAiCtp19SpE6bLwWmiSXi39cibWAbjmHl0nSB0nwUEr49E6
	VpkJxzSR2jDQ+qCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789986779; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EMBPNS5tBT6RED7zRj4Dbpw0rJ79c1uwrkHz177/Nv4=;
	b=xVldDPoNYMmAivGPX6+Ivtt+Nc1HNR2H0rBrCzoz3FEu80oIUV9bvLfjHxvh8lY8GHn7VR
	Lc0LaX154ss0b4P0GtuoVgQCjdVSPeUpJQJ6kpIGIABsY5TQg2glun4r5qhBSAhX7Cj/YC
	gEXLA66TxDV173Nw7fjkGSSqiSro+G0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789986779;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EMBPNS5tBT6RED7zRj4Dbpw0rJ79c1uwrkHz177/Nv4=;
	b=bVuAyloWcxTnU/WQtAq0TOrUzCUDmiI/tXAmANBuNXOhj+5pzrQHYzfzb1m5NGZqWx0nYv
	e336+xzJWuEgJRCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8A66F13793;
	Mon, 21 Sep 2026 10:32:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id T0h2FdoHsWrcPwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 21 Sep 2026 10:32:58 +0000
Message-ID: <37b05054-edaf-41d7-8bbb-50d9220b93e6@suse.de>
Date: Mon, 21 Sep 2026 12:32:10 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] netfilter: unbounded nftables reject recursion on inet
 OUTPUT
To: Florian Westphal <fw@strlen.de>, Yu Junzhe <junzheyu1@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org
References: <20260921061320.543-1-junzheyu1@gmail.com>
 <arD4z6mj71pMY0ho@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <arD4z6mj71pMY0ho@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spam-Score: -4.30
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[strlen.de,gmail.com];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,imap1.dmz-prg2.suse.org:helo]

On 9/21/26 11:28 AM, Florian Westphal wrote:
> Yu Junzhe <junzheyu1@gmail.com> wrote:
>> I am reporting unbounded hook recursion on inet OUTPUT: an nftables
>> output chain that does a TCP flags payload-set followed by
>> "reject with tcp reset" makes nf_send_reset() re-enter the same
>> NF_INET_LOCAL_OUT hook until the kernel stack is exhausted.
>>
>> Summary
>> =======
>>
>> nft_reject_inet_eval() calls nf_send_reset(), which builds a RST skb
>> and transmits it with ip_local_out(). That walks the same OUTPUT
>> hooks again.
> 
> Can you send us a patch for this?

Hi! Sorry, I have a patch for this already. So no need to do overlap 
work, will send it shortly.

Thanks for the report, I manage to trigger this easily.

> 
>> The only loop guard in nf_reject_ip_tcphdr_get() is the packet-content
>> check:
>>
>>    /* No RST for RST. */
>>    if (oth->rst)
>>            return NULL;
>>
>> If a payload-set runs first and rewrites the TCP flags byte to SYN,
>> that guard never sees RST, so another RST is generated. The cycle is:
>>
>>    nft_do_chain
>>      -> nft_reject_inet_eval
>>        -> nf_send_reset
>>          -> ip_local_out
>>            -> nf_hook_slow
>>              -> nft_do_chain
>>
>> nft_reject_inet_validate() allows NF_INET_LOCAL_OUT.
>>
>> This is a legal nftables configuration (payload set + reject with tcp
>> reset on an output base chain), including with CAP_NET_ADMIN in a
>> network namespace. I do not claim privilege escalation; the result we
>> see is local DoS (stack overflow, then panic).
>>
>> I am aware of the existing recursion bound on the netdev fwd/neigh
>> xmit path. nf_send_reset() via ip_local_out() does not use it.
> 
> Tell your coding assistant to move it to include/net/netfilter/nf_recursion.h,
> add that include to the existing users, then extend all reset functions
> (icmp and tcp reset) to use those helpers.
> 

