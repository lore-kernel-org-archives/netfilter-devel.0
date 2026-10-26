Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793023817;
	b=Nn7W0oYhszFZySS8YrQ740D0Rl78GL09ZZbIcf2HAm602thIvFWbqHvtiL2CCbyFdGaP
	 rNvNjorXKL/jsev8yWj9YEwtJ4sVK/F5Inw2l0kmRKfho7sIUUKsMK0GtmOI+rhGm8Nym
	 bqKCyoxaTGgbqYRXJ/BhaEZQbVtDZd/I9KmzdovQyfQFB8dG+5ByOUSgDDJEkQQOphX/7
	 aCkJnhCNtVQnYgkszDM6lXUcQA1SHtCVc3AKxFU5W1wa2KRH1jkuS5sUMswpjDloR6oPF
	 y7AKe0rYZuGrddOkJzCZESbAaPXbD4zYuFqEIH5od08YdnHmsOgDsZ1akrYj8sxN4RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793023817;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spam-Flag:X-Spam-Level:
	 X-Spamd-Result:X-Spam-Score;
	bh=WM4vAEGlhlHGhMEi1px3qUFAkL1THxHMrZ+7SD9VpUI=;
	b=FEOVwcl9rqXHBSZ4Qg9XL6n7nVir+XCdQc9pRFX3TCCgtxle3Xf/lYUlxoXBY0O4udOQ
	 5NE+pA0BKAW2munY3RSv90yC8gttQRXH6fXmtMyqVRkyyzh46XUafRXuugAs5ul3EVMMn
	 YPB06a2ZyPrDvRe0pfWMX3HqonLGB4Tm6/A1NprtvbE56CdBNtRBqVeenmbEMp0GrLlww
	 S3os18GHQMiKhjIoOV30bBLp6/lsHITksBaOfvr8/Kn713UMAKmK15O3/OhwjX69F/Orp
	 qB8M9r3ZHiHPpQy8fPrzMBbTck+hA/OHt/pEwVJ+M/QeSQLASGOtllVOgxm4NQirVqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=M8PpZdww;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=XK0VRyT1;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=M8PpZdww;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=XK0VRyT1;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A935606A31F
	for <netfilter-devel@vger.kernel.org>; Mon, 26 Oct 2026 14:10:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2A935606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=M8PpZdww;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=XK0VRyT1;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=M8PpZdww;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=XK0VRyT1
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 28E90222D1;
	Mon, 26 Oct 2026 14:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793023804; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WM4vAEGlhlHGhMEi1px3qUFAkL1THxHMrZ+7SD9VpUI=;
	b=M8PpZdwwPBi8GdZSTVAJs/1VKegcckiCwUXuUa8TdZBzmEDOY2Nc4gUKuHgS2a1WX9vRLy
	xWTEZZOrnWlVtn7BBnLHSuDlpxjjj351zPOVCdXSL/lSGgPX6rY4sXcrG2QCmrHlcGc/N1
	DOVoyqxiTB4PhLnGUN41V1R1n57ipb0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793023804;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WM4vAEGlhlHGhMEi1px3qUFAkL1THxHMrZ+7SD9VpUI=;
	b=XK0VRyT1SszO2SFQbm8U5dYoFPu4oufO9Kb3gMYZSAKAvnrDx8mrfFDd5pNQwVdvlL/VzO
	QplSGZqaxYJUZNBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793023804; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WM4vAEGlhlHGhMEi1px3qUFAkL1THxHMrZ+7SD9VpUI=;
	b=M8PpZdwwPBi8GdZSTVAJs/1VKegcckiCwUXuUa8TdZBzmEDOY2Nc4gUKuHgS2a1WX9vRLy
	xWTEZZOrnWlVtn7BBnLHSuDlpxjjj351zPOVCdXSL/lSGgPX6rY4sXcrG2QCmrHlcGc/N1
	DOVoyqxiTB4PhLnGUN41V1R1n57ipb0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793023804;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WM4vAEGlhlHGhMEi1px3qUFAkL1THxHMrZ+7SD9VpUI=;
	b=XK0VRyT1SszO2SFQbm8U5dYoFPu4oufO9Kb3gMYZSAKAvnrDx8mrfFDd5pNQwVdvlL/VzO
	QplSGZqaxYJUZNBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8DD1013319;
	Mon, 26 Oct 2026 14:10:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jYdOFztf32oaJAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 26 Oct 2026 14:10:03 +0000
Message-ID: <3141c47e-6fa1-4012-a756-db565f7d1c03@suse.de>
Date: Mon, 26 Oct 2026 15:08:46 +0100
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
Subject: Re: [PATCH] netfilter: nf_conntrack_sip: fix out-of-bounds read in
 ct_sip_parse_transport()
To: Duc Anh Luu <luuducanh05051995@gmail.com>, pablo@netfilter.org,
 fw@strlen.de
Cc: netfilter-devel@vger.kernel.org, phil@nwl.cc, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261022172248.554687-1-luuducanh05051995@gmail.com>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20261022172248.554687-1-luuducanh05051995@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-13.29 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,netfilter.org,strlen.de];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -13.29

On 10/22/26 7:22 PM, Duc Anh Luu wrote:
> ct_sip_parse_transport() compares the "transport=" parameter value against
> "TCP" and "UDP" with a fixed length of 3, without first checking that the
> parsed value is that long:
> 
> 	if (ct_sip_parse_param(ct, dptr, dataoff, datalen, "transport=",
> 			       &matchoff, &matchlen)) {
> 		if (!strncasecmp(dptr + matchoff, "TCP", strlen("TCP")))
> 		...
> 
> ct_sip_parse_param() sets the value end to the surrounding limit when no
> ';' delimiter follows, and that limit can be the end of the SIP message
> (dptr + datalen) when no ',' is present either. A Contact/Via parameter
> such as "transport=tc" placed at the very end of the payload therefore
> yields matchlen < 3 with matchoff + matchlen == datalen, and the
> strncasecmp() reads up to two bytes past the end of the message buffer.
> 
> The value of the over-read bytes can also flip the detected transport,
> so this is not purely a read: a crafted short value can make the helper
> classify the transport using out-of-bounds data.
> 
> Both call sites (process_register_request() and
> process_register_response()) are reached from attacker-supplied SIP
> traffic when the nf_conntrack_sip helper is active.
> 
> Bound each comparison by matchlen. A value shorter than three characters
> can never equal "TCP"/"UDP", so this only rejects already-malformed input
> and leaves valid transports (TCP, UDP, TLS, SCTP, ...) unchanged.
> 
> Reachability and behavioural equivalence were verified with a userspace
> ASan harness built from the verbatim parser functions: the over-read is
> confirmed as a read past dptr + datalen, and the fix removes it while
> producing identical results for all well-formed transport values.
> 
> Fixes: f5b321bd37fb ("netfilter: nf_conntrack_sip: add TCP support")
> Signed-off-by: Duc Anh Luu <luuducanh05051995@gmail.com>
Hi, this is a dup of:

https://lore.kernel.org/netfilter-devel/179286139765.93379.986858959213810476@gmail.com/

Since the v1 was sent earlier, let's stick to that patch.

