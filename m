Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984E9233939
	for <netfilter-devel@vger.kernel.org>; Sun, 24 May 2026 18:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779648503; cv=none; b=dk7WiBOEL7LG98z1vtK/Tf6Y5EVkH6Jbp2ivKI2o4VA1PtQBr5sQFHQSN21iuG5QGDk3NT08ttze9rklj+CVr/3y7mk+4Jt6UaisnXS//wmWH906W5mMFT8XrFVfkCg1ll0o92yCXkyRC/dfJvOLVKBYizTMDb0JmyOYvPTQgsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779648503; c=relaxed/simple;
	bh=843HfV77S4fFshr9H4dTjQ0qENWjewYdzcTjD++RdZ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t4Fw8dD9wOZ1bfvx4H7Gda3nJonKyKDgdS+YqSbQEAaTGk2iDaA2QAwaQy6zK5heE4MnIyjopVXx1+WL9aP1UegCOI0A8xQDKNLNqCWnsOfdsM+sRqKBN+vcJjX3SZ1Bxq9nxQJpUyop6+eD7E35KnDDAdZWDU36Nc97YVe9rpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Kyf1n0s8; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=HLgiCSJ2; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Kyf1n0s8; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=HLgiCSJ2; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Kyf1n0s8";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="HLgiCSJ2";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Kyf1n0s8";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="HLgiCSJ2"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DB2A366D9C;
	Sun, 24 May 2026 18:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779648499; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jipFbt7ethnjj9GS00ajOmxxkGnKGtsJcuZE1/JWqdc=;
	b=Kyf1n0s8qMZE51XCLMoZ3lsJSHbBM5po+vxNRloQqiKoQ8UcjL2HBLiUJ6TjtXkKelHu+d
	3twX5tI+NUvAL3jhF6+3Ambd5tLsDBYyycNRcuHF/fb/CRdsXhZ2TS9GrcY7+H+2m6vY5h
	JHF2/H3JkdtmAsKp5auZ7/SGlE9hYko=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779648499;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jipFbt7ethnjj9GS00ajOmxxkGnKGtsJcuZE1/JWqdc=;
	b=HLgiCSJ2eYs6vk0CwWyKL2xrD6dqsudZlrJLdKKFvQsb8hH9f/zcgaCUWB9Ow+aN/NaQqX
	tu41aLxW63E5syCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779648499; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jipFbt7ethnjj9GS00ajOmxxkGnKGtsJcuZE1/JWqdc=;
	b=Kyf1n0s8qMZE51XCLMoZ3lsJSHbBM5po+vxNRloQqiKoQ8UcjL2HBLiUJ6TjtXkKelHu+d
	3twX5tI+NUvAL3jhF6+3Ambd5tLsDBYyycNRcuHF/fb/CRdsXhZ2TS9GrcY7+H+2m6vY5h
	JHF2/H3JkdtmAsKp5auZ7/SGlE9hYko=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779648499;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jipFbt7ethnjj9GS00ajOmxxkGnKGtsJcuZE1/JWqdc=;
	b=HLgiCSJ2eYs6vk0CwWyKL2xrD6dqsudZlrJLdKKFvQsb8hH9f/zcgaCUWB9Ow+aN/NaQqX
	tu41aLxW63E5syCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 840015981C;
	Sun, 24 May 2026 18:48:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KDujHPNHE2ppUgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Sun, 24 May 2026 18:48:19 +0000
Message-ID: <3178bbf8-552a-45cf-819f-bf3ec2de41e0@suse.de>
Date: Sun, 24 May 2026 20:48:18 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3 nf-next] netfilter: synproxy: timestamp adjustment
 fixes
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 pablo@netfilter.org, phil@nwl.cc
References: <20260523194743.5888-2-fmancera@suse.de>
 <7dcb73cb-11ab-4c9d-89bd-7418bdc86fdb@suse.de> <ahMyVJYynOoa32U5@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <ahMyVJYynOoa32U5@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.995];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_TWO(0.00)[2];
	internal_greylist_whitelist(0.00)[10.150.64.97];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Flag: NO

On 5/24/26 7:16 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> What do you all think? nf or nf-next for the 4 commits? I tried to reproduce
>> an UAF but couldn't trigger it. Although, I was able to write to the stale
>> pointer using tc mirred..
> 
> nf.  But I'm not sold on this series: dropping patckets outside
> of rulesets should be a last resort.

Hm. That might be an appealing argument for the dup timestamp option, if 
we want to be more relaxed we can just adjust all timestamp options 
equally (we need to assume that this is a corner case of course).

But when failing skb_ensure_writable() or when encountering completely 
malformed options I believe we should drop the packet. Because either we 
didn't adjust the timestamp properly or the options are just malformed 
and in any of these cases the packet should reach the backend..

Thanks Florian!


