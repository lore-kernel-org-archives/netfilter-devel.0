Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CF62FE041
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 11:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761304493; cv=none; b=Q2Bdug2ebmI+DleU2tAtJSDvdIojtAF+DjIdnip6h6gJGFfLhcVj0KH6/NswT4jMwiXQaOipA8F9b7S/PmgWekz4GaLS0BwDQRDaRqgJ6sKfhf703DYxo1u7ZF4b4TXEAtXKC/PSvNmgQsOWakXbHWsSZLINV2twFHiN9/l5/rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761304493; c=relaxed/simple;
	bh=J9Nj/rAceZrKnveQzDw6wqqMcJgrsRhkj5N7EH+Xo8Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bBp+JTtWymtdwP7QHxmZzK8FpVx+5wBV9PFOt22qkiLG2JZ8fHX4f0fs50/gmVccIiNl6xY3iH5C6fPU6hwVDsisWD0Bn/LFOWKFqq3G+XX5SGFXmxxMvVhaZ/JaDP9L1C2+sGF8Ben26zy+AE3ZfmzAYrcL88H2KO5S9wOuUSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Z29fY09t; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=r7s3iVs2; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Z29fY09t; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=r7s3iVs2; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Z29fY09t";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="r7s3iVs2";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Z29fY09t";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="r7s3iVs2"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 06C3D1F388;
	Fri, 24 Oct 2025 11:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761304489; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BHTEGfRwlwJ3WKLHonwkyCWQvqGyGVZ/v5+/zS5SmYQ=;
	b=Z29fY09txGTxgWx3rv6yB7cWFoMbQvaZLfXSR1J1xx+PgAUhubwHke90bFzK56SqceL5OK
	JJaDtVBu2p2VxoTuW1UWhDLtwa+8+W4c+SEI4J0oOw9oW1FwdHIzAPBJUwzGiw6AyU0P+z
	ZJgiLLxogYq2udGbARz0uE8tXblxNcc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761304489;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BHTEGfRwlwJ3WKLHonwkyCWQvqGyGVZ/v5+/zS5SmYQ=;
	b=r7s3iVs2b03JHwEJ5KGv/yL2pzsFBSAIVBW9W7UTgMQ1cvBpGqu24BXO+PAIoOcBnkTZwx
	YaiN6YgaCGPQpRAg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Z29fY09t;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=r7s3iVs2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761304489; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BHTEGfRwlwJ3WKLHonwkyCWQvqGyGVZ/v5+/zS5SmYQ=;
	b=Z29fY09txGTxgWx3rv6yB7cWFoMbQvaZLfXSR1J1xx+PgAUhubwHke90bFzK56SqceL5OK
	JJaDtVBu2p2VxoTuW1UWhDLtwa+8+W4c+SEI4J0oOw9oW1FwdHIzAPBJUwzGiw6AyU0P+z
	ZJgiLLxogYq2udGbARz0uE8tXblxNcc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761304489;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BHTEGfRwlwJ3WKLHonwkyCWQvqGyGVZ/v5+/zS5SmYQ=;
	b=r7s3iVs2b03JHwEJ5KGv/yL2pzsFBSAIVBW9W7UTgMQ1cvBpGqu24BXO+PAIoOcBnkTZwx
	YaiN6YgaCGPQpRAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AECA8132C2;
	Fri, 24 Oct 2025 11:14:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VhXsJqhf+2jPfQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 24 Oct 2025 11:14:48 +0000
Message-ID: <33d6f2aa-2c10-4727-b78d-0fefc64b2d35@suse.de>
Date: Fri, 24 Oct 2025 13:14:40 +0200
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
 <6b0de8f3-d03a-4f12-b2f8-c87aeeef4847@suse.de> <aPtctiRlb9Pg9sNQ@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aPtctiRlb9Pg9sNQ@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 06C3D1F388
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[caramail.com];
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,netfilter.org,caramail.com];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 



On 10/24/25 1:02 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> On 10/24/25 1:20 AM, Fernando Fernandez Mancera wrote:
>>> nft_connlimit_eval() reads priv->list->count to check if the connection
>>> limit has been exceeded. This value can be cached by the CPU while it
>>> can be decremented by a different CPU when a connection is closed. This
>>> causes a data race as the value cached might be outdated.
>>>
>>> When a new connection is established and evaluated by the connlimit
>>> expression, priv->list->count is incremented by nf_conncount_add(),
>>> triggering the CPU's cache coherency protocol and therefore refreshing
>>> the cached value before updating it.
>>>
>>> Solve this situation by reading the value using READ_ONCE().
>>>
>>> Fixes: df4a90250976 ("netfilter: nf_conncount: merge lookup and add functions")
>>> Closes: https://lore.kernel.org/netfilter/trinity-85c72a88-d762-46c3-be97-36f10e5d9796-1761173693813@3c-app-mailcom-bs12/
>>> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
>>> ---
>>
>> While at this, I have found another problem with connlimit although with
>> this fix, it is partially mitigated. Since d265929930e2 ("netfilter:
>> nf_conncount: reduce unnecessary GC"), if __nf_conncount_add() is called
>> more than once during the same jiffy, the function won't check if the
>> connection is already tracked and will be added right away incrementing
>> the count. This can cause a situation where the count is greater than it
>> should and can cause nft_connlimit to match wrongly for a few jiffies.
>>
>> I am open to suggestions on how to fix this.. as currently I don't have
>> a different one other than reverting the commit..
> 
> People are not supposed to use it in this way.
> 
> This is very expensive, there is a reason why iptables-extensions
> examples all use iptables --syn.
> 

If this is only supposed to be checked for SYN packets, that is, a new 
connection is started.. a simple fix could be to check whether this is a 
SYN packet or not, break if it isn't. Similar to what is done on 
synproxy eval function. What do you think?

> This needs a documentation fix.
> 
> Or, we could revert df4a90250976 and then only _add for ctinfo NEW.


