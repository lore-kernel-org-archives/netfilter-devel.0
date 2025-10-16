Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3661FDE14
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Oct 2025 23:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760658097; cv=none; b=PHqEBVWvg8jeSvWTN716UrOIK2QK1A2FNfPSLxOzl+Xt03sAch7vgT1gD7EXzIqG2euNS5wW3oGveS49ygtk6NXxBes3pHkHRtb2Us8xfKSmrd5DD+mdFCXlRTJVrzBBYWmoY2KMWbMaYOifH2iAAyegbguyHlnKmNtNgy6Lgoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760658097; c=relaxed/simple;
	bh=PvlWuLkdZvdMqfGRgeTM2fpUVgo3ivIirDCDHxuL9HA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=e8CyMwoCHpjmDePBBwRpIGDv+zyBDoKCanYPu6nx4WpOIWG1Oyb5c4wm2ta/RoPYKljTqxRiJJWmCi5c9NjvOS7XcJ4+Et8WGSdeFMbGqLrf44WepA+haQM98JDd4QbN1qM8L4KQjn9NSWDFTYZ0FmgpmVZWg9P8TBckYHjEOgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=oUKpxcXz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=mo/JnmUD; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=oUKpxcXz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=mo/JnmUD; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="oUKpxcXz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mo/JnmUD";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="oUKpxcXz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mo/JnmUD"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1438E21AF7;
	Thu, 16 Oct 2025 23:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760658094; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6pNvqzrQ3m9h6EpfX4KrEIPVfBwJAgGhTOYw2KtHJFc=;
	b=oUKpxcXz2B5MkK2RoMsuSEaQuePIaI4yL9LLKlNRmj+q2cwkHElpIm4zqJvJWhIxV4h+LO
	mX554sclVSaFX4jmLA+DwGTA1TcO4r3y1Ne5TGlYtyuoxS56svODNSoopweXxDmxz3/9BG
	tjlUmiRxqKXa6TrRJzFANiV9x1UdruE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760658094;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6pNvqzrQ3m9h6EpfX4KrEIPVfBwJAgGhTOYw2KtHJFc=;
	b=mo/JnmUDeUxabf/+BIsK5sBzinNtg2G6b6w3r+5Bz9NO0ZmHn2WZgYym67LH6Tw1X/c9tF
	7g5wzvQGn1j7B/Dg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oUKpxcXz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="mo/JnmUD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760658094; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6pNvqzrQ3m9h6EpfX4KrEIPVfBwJAgGhTOYw2KtHJFc=;
	b=oUKpxcXz2B5MkK2RoMsuSEaQuePIaI4yL9LLKlNRmj+q2cwkHElpIm4zqJvJWhIxV4h+LO
	mX554sclVSaFX4jmLA+DwGTA1TcO4r3y1Ne5TGlYtyuoxS56svODNSoopweXxDmxz3/9BG
	tjlUmiRxqKXa6TrRJzFANiV9x1UdruE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760658094;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6pNvqzrQ3m9h6EpfX4KrEIPVfBwJAgGhTOYw2KtHJFc=;
	b=mo/JnmUDeUxabf/+BIsK5sBzinNtg2G6b6w3r+5Bz9NO0ZmHn2WZgYym67LH6Tw1X/c9tF
	7g5wzvQGn1j7B/Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DB9221340C;
	Thu, 16 Oct 2025 23:41:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NJcWMq2C8WgUDAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 16 Oct 2025 23:41:33 +0000
Message-ID: <0723dbcd-bd3d-49ce-84bd-787f4fc73cfd@suse.de>
Date: Fri, 17 Oct 2025 01:41:29 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nft 3/4] src: parser_bison: prevent multiple ip
 daddr/saddr definitions
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20251016145955.7785-1-fw@strlen.de>
 <20251016145955.7785-4-fw@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20251016145955.7785-4-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 1438E21AF7
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid,suse.de:email];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.51



On 10/16/25 4:59 PM, Florian Westphal wrote:
> minor change to the bogon makes it assert because symbolic expression
> will have wrong refcount (2) at scope teardown.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>   src/parser_bison.y                              | 17 +++++++++++++++++
>   .../bogons/nft-f/tunnel_with_anon_set_assert    |  1 +
>   2 files changed, 18 insertions(+)
> 

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

