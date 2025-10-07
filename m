Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C350248176
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Oct 2025 11:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759836836; cv=none; b=OFKQlbcxeq9a/LcEstBTLnpIYa9jZutYg2kDWNqTXixCrmwiKmT6q+vAzrC9nT26ttWEEt/Oikwslar2VmGtwMcd8EkgNs/9dtsgTqeDSMT5HyeD2vPqQm8qbpT1cTyYQ4pa4kzxNyGq1azBKrYBtofDAD/00cuIp3oM+4moDwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759836836; c=relaxed/simple;
	bh=g7FDfSj2u/tRV2oT2vvkd1QoX+NrmCH6WNlVZX8nGK0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=hg4Klbg763u7zawWhG9/9xDACltdF7kC8wQ0Z+4gYWW2AD3QwnP3YItB2ifElcY87XWAQklsx7YNTi2lUSpEWF86rGe7zCpLyGSKDoS/9SXuYA72YXjEVlzxBxxflsDz/+36Xz1iiB2Tckln/K9kTOnx35ubmCqpVdZK16diOaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Xvk2cAwI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=GaKBWR8S; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Xvk2cAwI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=GaKBWR8S; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Xvk2cAwI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="GaKBWR8S";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Xvk2cAwI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="GaKBWR8S"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 391601F84D;
	Tue,  7 Oct 2025 11:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759836832; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4/nyBJoWz93kWb+jMN6i3wBZjfPraBVJ5c0qsZKykxE=;
	b=Xvk2cAwIL8UWcxgW/Jn2WdJavLsjeV1OPkmfGgs1HB0rs462GPFqUAlvFxFXYyMSFsFAo1
	s8pLqryxbqwpa7BH0yqw6LWw9iqwia2Eq4HGoT8aR6YB6vVHaWPoLLUB9ZRO7/sTTwnnPh
	zr9G1iktaTjoI0pq3mXKWrgVhFki5XA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759836832;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4/nyBJoWz93kWb+jMN6i3wBZjfPraBVJ5c0qsZKykxE=;
	b=GaKBWR8SugB2r4vQO6AbkvNN/6TO5vy6/99dJOT2q8rdrSNIkfVCivZ7qS6rZAwb1Hjqls
	M1ypVQBsspjkQnBA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Xvk2cAwI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GaKBWR8S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759836832; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4/nyBJoWz93kWb+jMN6i3wBZjfPraBVJ5c0qsZKykxE=;
	b=Xvk2cAwIL8UWcxgW/Jn2WdJavLsjeV1OPkmfGgs1HB0rs462GPFqUAlvFxFXYyMSFsFAo1
	s8pLqryxbqwpa7BH0yqw6LWw9iqwia2Eq4HGoT8aR6YB6vVHaWPoLLUB9ZRO7/sTTwnnPh
	zr9G1iktaTjoI0pq3mXKWrgVhFki5XA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759836832;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4/nyBJoWz93kWb+jMN6i3wBZjfPraBVJ5c0qsZKykxE=;
	b=GaKBWR8SugB2r4vQO6AbkvNN/6TO5vy6/99dJOT2q8rdrSNIkfVCivZ7qS6rZAwb1Hjqls
	M1ypVQBsspjkQnBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 126A113693;
	Tue,  7 Oct 2025 11:33:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Fqh0AaD65GimeQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 07 Oct 2025 11:33:52 +0000
Message-ID: <a597abdd-77cd-4393-b18f-08249a9034c2@suse.de>
Date: Tue, 7 Oct 2025 13:33:41 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nft] tests: py: must use input, not output
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20251007104852.3892-1-fw@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20251007104852.3892-1-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[strlen.de:email,suse.de:mid,suse.de:dkim,suse.de:email];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: 391601F84D
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51



On 10/7/25 12:48 PM, Florian Westphal wrote:
> synproxy must never be used in output rules, doing so results in kernel
> crash due to infinite recursive calls back to nf_hook_slow() for the
> emitted reply packet.
> 
> Up until recently kernel lacked this validation, and now that the kernel
> rejects this the test fails.  Use input to make this pass again.
> 
> A new test to ensure we reject synproxy in ouput should be added
> in the near future.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---

Looks good to me, thanks Florian.

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
