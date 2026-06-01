Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879C736494B
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Jun 2026 19:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780342531; cv=none; b=fhiaXsC/tVW1KURiMwy476w4dAFS3WFeq80vB6fA9UqtrjX94qQ8hyd0zGa01mqeyd0c21jZBVu7t8E82bsjKm5XC66Qf5GboBK2YZdeNFZrTucF5AXF7En45VXd8AuQaeWAx8Hw6o6yM6N2P97lNgUpK9HoI39Dnl6JGnwODbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780342531; c=relaxed/simple;
	bh=YHIXvXY4K+o/hyXFWCPzOYEp1p+hKbUKvuf5PXOtBXQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NDsQSYO4u940K6goVAd1oGdeF9fXZBglA9luNsKv01NJc7oPAcoV9ZhS0d5JLAiiVzwQNTea7zFDWsVNBvJdjwjzJnD7XWJTA2CixuO0FRZ3JcxltN0JUcUI/w9xiPfcO2Zr4cQowcvVhZ1Y/YM6WHXD37XWiDePorreMciRcuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FiQEzZVH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vBzQxQ2T; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FiQEzZVH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vBzQxQ2T; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FiQEzZVH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vBzQxQ2T";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FiQEzZVH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vBzQxQ2T"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E06876AB46;
	Mon,  1 Jun 2026 19:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780342528; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2vJuovr8c0mk3c3O9R4RpYGryN9PNFRIJ3NZEh+RnZ4=;
	b=FiQEzZVHNHYFVQxHesfswqp4Lg2xO9cZmwjVLCXNQozvBrZR8NcQTUzYQAvV4ryF21H7bJ
	uRtzmP+PI5wtGno11RY6fhCTxdJdsr4FG11flcV4yXJf6MBsTVDKWvYyGMv0iBDsovI28e
	m6wNq5YUVdUSiUxsow88pK1/LKxKP2g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780342528;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2vJuovr8c0mk3c3O9R4RpYGryN9PNFRIJ3NZEh+RnZ4=;
	b=vBzQxQ2T5UjBPhZxG1u5S0LgJZ5a6/aRldu6o8ydaHj1fGad4D9mJR/svEHdjgyMwXdTuy
	iB2Q8Nw7RWvDTdAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780342528; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2vJuovr8c0mk3c3O9R4RpYGryN9PNFRIJ3NZEh+RnZ4=;
	b=FiQEzZVHNHYFVQxHesfswqp4Lg2xO9cZmwjVLCXNQozvBrZR8NcQTUzYQAvV4ryF21H7bJ
	uRtzmP+PI5wtGno11RY6fhCTxdJdsr4FG11flcV4yXJf6MBsTVDKWvYyGMv0iBDsovI28e
	m6wNq5YUVdUSiUxsow88pK1/LKxKP2g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780342528;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2vJuovr8c0mk3c3O9R4RpYGryN9PNFRIJ3NZEh+RnZ4=;
	b=vBzQxQ2T5UjBPhZxG1u5S0LgJZ5a6/aRldu6o8ydaHj1fGad4D9mJR/svEHdjgyMwXdTuy
	iB2Q8Nw7RWvDTdAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 957E0779A7;
	Mon,  1 Jun 2026 19:35:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yxCrIQDfHWrkMgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 01 Jun 2026 19:35:28 +0000
Message-ID: <2a5609f2-a9f2-4d8e-b423-14e49c807ab0@suse.de>
Date: Mon, 1 Jun 2026 21:35:24 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/9 nf-next] netfilter: replace raw warnings with
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org, phil@nwl.cc, fw@strlen.de, pablo@netfilter.org
References: <20260601193049.8131-1-fmancera@suse.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260601193049.8131-1-fmancera@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	URIBL_BLOCKED(0.00)[suse.de:mid,imap1.dmz-prg2.suse.org:helo];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_NONE(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid]
X-Spam-Level: 

On 6/1/26 9:30 PM, Fernando Fernandez Mancera wrote:
> This patch series replaces raw WARN_ON and WARN_ON_ONCE macros with
> DEBUG_NET_WARN_ON_ONCE across various netfilter subsystems.
> 
> Currently, several internal invariant checks use standard warnings on
> packet processing paths or control-plane loops. If triggered, these can
> trigger full system panics when panic_on_warn=1 is enabled. In most of
> these cases, the condition is already handled gracefully by dropping the
> packet, applying a defensive fallback, or returning a proper error code
> to userspace via netlink.
> 
> By migrating to DEBUG_NET_WARN_ON_ONCE, we preserve full stack trace
> diagnostic capability for developers running kernels compiled with
> CONFIG_DEBUG_NET=y, while protecting production environments from system
> panics.
> 

And of course, the tile is not formatted properly for the cover letter. 
It should be:

"netfilter: replace raw warnings with network debug macros"

*sigh*

Thanks,
Fernando.

