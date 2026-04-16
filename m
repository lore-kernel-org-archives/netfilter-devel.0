Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33773CBE69
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Apr 2026 13:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776347908; cv=none; b=dI33nMa3AWc3ojmcbQ9tHzpsUXp7Au51uMjURSzJwHfLgruJtxYoYOtoiyX7XZ5b7x9UGn4RFdFVxrpMF0mdzkAu6nmGyWuSYdYk63gCC7Uxy6Ca2wbjNkssFsM+ZRyQre17BvBMOiy89HznSUhH+jOY+Bg0VeOHuockYBRBNeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776347908; c=relaxed/simple;
	bh=H0/r4HNR/fIOv35ZlspzM525oyhMabLKIRddE+YwfKM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=S8L1fZlxW/njJu6VnQvIvxMwfOAXUJDiGDST4zAKkMNFiwiUNEHn/ulT7Km70JgGx8F21aU28qn9NuVVmd0UYL16ksMFIvNy3EU84ju47FCXrvQAe7JlqgBJ6Zc6M6mQE9RL2arOsglMoC9ypnXZ0QCspkLluh4FWamNzu+LsJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sv3NM31V; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Stu6ZyuG; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=x8Q86ToK; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=mHXka8ca; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sv3NM31V";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Stu6ZyuG";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="x8Q86ToK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mHXka8ca"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 73DDF6A7EC;
	Thu, 16 Apr 2026 13:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776347903; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0NUZzz1LSyVwKvYzEiWoKoBGtCdTNBOJt0uExRYfg0o=;
	b=sv3NM31VCBx+VVKgTM4a/xuzuRAjsj+k55dxou2XXopBopyp9bBzeQFnh7FcEXWb4tZdtI
	wgjzPd7k0GEfY5KyjC8V3uelfa+aRQRIKRRYANcyDqEzyzuuFgyK71Jie2RSeDoG/jPiOK
	rKA9IXD20K4vyaOeamHIR+RpC4l2Yzw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776347903;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0NUZzz1LSyVwKvYzEiWoKoBGtCdTNBOJt0uExRYfg0o=;
	b=Stu6ZyuG2+D4DstbmdQ1Zgm87G8tir+H4eJNVL2zvnEDj7Uj2go9qYH0qgpZLXj5i7aQ2S
	ctYy5DX6PFMISTDQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=x8Q86ToK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=mHXka8ca
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776347902; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0NUZzz1LSyVwKvYzEiWoKoBGtCdTNBOJt0uExRYfg0o=;
	b=x8Q86ToKrx8VUojsLqAPgRgiwjdUROspBhXLeYmvOrTlVQW+HvA+DkYWaccJcdGtrb+zA5
	FoERbXMO5fZXZRI/SCOZQYLJ1qxZqH0D7AJciD+0YX6XszQH426DkmA6uBBxfTa50JL15Z
	b/KJoIvcI3e33L/v3A0+IQBHKDA3Re8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776347902;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0NUZzz1LSyVwKvYzEiWoKoBGtCdTNBOJt0uExRYfg0o=;
	b=mHXka8caGV8vi6SRW2YSaM0Af6owopyX3aPH6EMnsI9zDghdcu8qP6hrV91UutLJ9Gqksh
	osNGvgiJhce7XTDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4AA44593A3;
	Thu, 16 Apr 2026 13:58:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZByCD/7q4GnwdQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 16 Apr 2026 13:58:22 +0000
Message-ID: <aee16d13-2762-499f-8ec9-4b800d2e8706@suse.de>
Date: Thu, 16 Apr 2026 15:58:17 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf-next] netfilter: allow nfnetlink built-in only
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
References: <20260415111236.57925-1-pablo@netfilter.org>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260415111236.57925-1-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	URIBL_BLOCKED(0.00)[netfilter.org:email,suse.de:mid,suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 73DDF6A7EC

On 4/15/26 1:12 PM, Pablo Neira Ayuso wrote:
> Netfilter has its own netlink multiplexer, initially only a few
> subsystem were using it, most notably conntrack, queue and log,
> later in time nf_tables. These days it is the control plane of
> preference.
> 
> Just remove modular support for this, allow it built-in only.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Makes sense to me.

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
