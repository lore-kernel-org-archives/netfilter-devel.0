Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDD32FF66A
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Oct 2025 15:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760454905; cv=none; b=K1joev/7c3QXRZcZXNxBY2RHqXQb3n0WGhZSXUru5v9UgNn5v43aJwG303Dlkl4rs7U4ZvdW4N1ldER9Dk+imj0ISLQQYMWPnoRZFiQOC6QcF/dAnC/m53ckM2bLnXTY5UwZejVLKtg4FWDD+5IOB+9Lxp1E4qx0vESkJRcHMtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760454905; c=relaxed/simple;
	bh=y/4ymzi6x1u8W3pC6uRrQzksMaya3Q2cZ9qcmENPa/k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PP6LwswvEDO07QQXR7W1USU79yOoZoAx28eW22RpCrPPfPr2Z0lC/gZA2PSwiIxjcp+w1Z/aVhzhISj4I5m066aeSRY3PTDO4iW4uWdw6+C9exrd6beAYI3KhE2D6ISfEu4+W0XKm5hXbESeRE8F+FWOEZX0YiCOx8CUNKGLYYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=g9qMrP6K; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=WSxAos+t; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=g9qMrP6K; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=WSxAos+t; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="g9qMrP6K";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="WSxAos+t";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="g9qMrP6K";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="WSxAos+t"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C824922076;
	Tue, 14 Oct 2025 15:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760454901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dqsWWsAOhiatUf8TvgfOSUi9HjDriPctdwoPYCLl4Dc=;
	b=g9qMrP6KciVnO+LCuBPO31devqor+3dULMaKRdcyBt3OeRnrOkkK6MdurPEb3Uh0quUR1D
	zJE9ndv7dtuevjdUSPfHQMNUFgg86CYti4uJksyadQaY4NEuXiDQlkGxRxDejML8mMJgoW
	w92fxkJVrRMisb5K537nToMTHZQ5xdA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760454901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dqsWWsAOhiatUf8TvgfOSUi9HjDriPctdwoPYCLl4Dc=;
	b=WSxAos+t1kH/CorUhc29R7dkC7ZMIDQTO+z7DkbcyD5Qq5RLv18j+PUf4fcrkBINGzR92q
	WHFD0qVBV66q2dBg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=g9qMrP6K;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WSxAos+t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760454901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dqsWWsAOhiatUf8TvgfOSUi9HjDriPctdwoPYCLl4Dc=;
	b=g9qMrP6KciVnO+LCuBPO31devqor+3dULMaKRdcyBt3OeRnrOkkK6MdurPEb3Uh0quUR1D
	zJE9ndv7dtuevjdUSPfHQMNUFgg86CYti4uJksyadQaY4NEuXiDQlkGxRxDejML8mMJgoW
	w92fxkJVrRMisb5K537nToMTHZQ5xdA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760454901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dqsWWsAOhiatUf8TvgfOSUi9HjDriPctdwoPYCLl4Dc=;
	b=WSxAos+t1kH/CorUhc29R7dkC7ZMIDQTO+z7DkbcyD5Qq5RLv18j+PUf4fcrkBINGzR92q
	WHFD0qVBV66q2dBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 958A9139B0;
	Tue, 14 Oct 2025 15:15:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tWrNIfVo7mjhKgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 14 Oct 2025 15:15:01 +0000
Message-ID: <e914fab4-e65d-43d3-a99d-816e8dffd72b@suse.de>
Date: Tue, 14 Oct 2025 17:14:57 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: iptables: zero dereference parsing bitwise operations
To: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Florian Westphal <fw@strlen.de>,
 "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
References: <s5LZtLzqFmQhlD4mtmgcKbrgkfQ-X7k7vvg7s7XnXHekGJSKOMyOdmoiONo7MzuLVqYTFPntt74igf8Q0ERSPy5R9f8L1EfwrhOZbs_nhO8=@protonmail.com>
 <aOpigXfhOrj02Qa5@strlen.de>
 <e2mf5Q5IBD50dFQcvIXCNkQCKwghz-hLmCunP33gaZy33srxWrQKdcL1J3GKA8a0H05T6p4kZGFpR910g7JBZusbg_AmEZKPD1UvW_mEheQ=@protonmail.com>
 <dae7551c-c18e-46ea-b490-1b7310a40195@suse.de>
 <c0jUt9xXxfO6o8KmFHUCZKJYW1bArw2X3KSLyVn39yv9-LiFW46XF0vnsPVV-QXkempUYu7kwzNsmG9rHM-65QjnqZ-mdz94Es2EPKbjbHI=@protonmail.com>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <c0jUt9xXxfO6o8KmFHUCZKJYW1bArw2X3KSLyVn39yv9-LiFW46XF0vnsPVV-QXkempUYu7kwzNsmG9rHM-65QjnqZ-mdz94Es2EPKbjbHI=@protonmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C824922076
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
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
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[protonmail.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[protonmail.com];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,suse.de:dkim];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 



On 10/13/25 1:43 PM, Remy D. Farley wrote:
> On Monday, October 13th, 2025 at 09:04, Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> 
>> Hi Remy, could you share the full output of:
>>
>> 'nft --debug=netlink list ruleset'
>>
>> This will allow me to understand what is the generated bytecode and an
>> easy way to reproduce this with libnftnl. I am happy to investigate/fix
>> this on the nft/libnftnl/kernel side :)
> 
> 
> Hi Fernando,
> 
> Not sure if it worth investigating, but here you go.
> 
> 

I have reproduced this and confirmed that the right source register is 
being set (NFT_REG_1) and that libnftnl is reporting it correctly. The 
problem is on nft command line tool side.. I do not think it is worth 
going deeper as it is probably related to nftables not being able to 
delinearize this rule as it is not supported by nft itself.
