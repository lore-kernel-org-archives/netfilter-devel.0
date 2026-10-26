Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793024874;
	b=IuFEdw7rwySHAzKRtUu+jKsIy++/BDp4OnkCDUfk74LOCaUm0f3xfcaZaG7MsZL1LoQW
	 8rjz2pzMrks7JCSAEe6VZp7KXTpdT6gljT68w0FQ9sTYg4ld4JnK5fXYdUlmREl4w5Gmg
	 ibjhX9MlaOANzJK2BtNyLG3C5GIDxC3Ub9fzJDeM3yOp1ry7Ypakrt6fqi83Zjmdk9OO/
	 0w1U61q7DivQbpANfx9QHQc9zYbDlQibxgs4Wo821z5PsKYfM5cbjB/UaCLiTkHvDK7B/
	 NJYMV+Da/ljvpplu2OpDLGTZo2oUVC/pCcF3zOXH2ozQYSy0HQBuVBaeCta60fstXhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793024874;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spam-Flag:X-Spam-Level:
	 X-Spamd-Result:X-Spam-Score;
	bh=pFeiZWUlKA17A5iSBKX4rHu8B6bfw4tdUPbBkbANNOg=;
	b=gZN9ohrUOktRwzg0YaB7Ta2lbVCl8wsKuuJBPDlc/6bP5MvLT+S/+7ssPTL0NF/9+DH3
	 1CSwG16nVPRR7njkb/9N4tRbCEMmQo91ZIYkqf3qP3lX27UVQoE6QaZ2ouIrdo7Gt3izv
	 LAoN48ZzggmDSeHfE+QrwKdbbX3gL0KxgX1+BiAOhVqbihHAgqEO1/ksZ2FjWbI0SLu5+
	 eU4IUbE9+hVqsCxiCvbD7mLk1mC6/QnT3hIHDVvoQIVZwVSESty/RJvfpUA0nj8e8iaTS
	 mY3rYkG5Oa85vMXQFe0q2ylVvdkx+5zENzwsydUH20+mhbfC6mZSS7fKtLDtduecUhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=kt+hROst;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Pg+rUfTq;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=kt+hROst;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Pg+rUfTq;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA314606A330
	for <netfilter-devel@vger.kernel.org>; Mon, 26 Oct 2026 14:27:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA314606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=kt+hROst;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Pg+rUfTq;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=kt+hROst;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Pg+rUfTq
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 27DFD220F1;
	Mon, 26 Oct 2026 14:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793024865; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pFeiZWUlKA17A5iSBKX4rHu8B6bfw4tdUPbBkbANNOg=;
	b=kt+hROsteMp4x9NabCiCembg/pzy6uxvQxiktgywWNRvs00G1brlIA1cIjzGglFeHA3ucg
	tSJljyvuy/Esx2QpRG7BSr8VrUBRJWB6CI3BH68+JHVdzfOUSXYVgA8Cy8bKQKCtvamP9o
	raek+kJT6/VkyWTx668zrMZx0EmMv44=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793024865;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pFeiZWUlKA17A5iSBKX4rHu8B6bfw4tdUPbBkbANNOg=;
	b=Pg+rUfTqZewOk36tggGl5vyPTHJctzK/XBFO6/egU1UP+DZwF+MYliZSgHn/XyGS6UJSal
	rWYmFFFAlBjbwFDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793024865; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pFeiZWUlKA17A5iSBKX4rHu8B6bfw4tdUPbBkbANNOg=;
	b=kt+hROsteMp4x9NabCiCembg/pzy6uxvQxiktgywWNRvs00G1brlIA1cIjzGglFeHA3ucg
	tSJljyvuy/Esx2QpRG7BSr8VrUBRJWB6CI3BH68+JHVdzfOUSXYVgA8Cy8bKQKCtvamP9o
	raek+kJT6/VkyWTx668zrMZx0EmMv44=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793024865;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pFeiZWUlKA17A5iSBKX4rHu8B6bfw4tdUPbBkbANNOg=;
	b=Pg+rUfTqZewOk36tggGl5vyPTHJctzK/XBFO6/egU1UP+DZwF+MYliZSgHn/XyGS6UJSal
	rWYmFFFAlBjbwFDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 83EFA13319;
	Mon, 26 Oct 2026 14:27:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9FfaFGBj32oCNwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 26 Oct 2026 14:27:44 +0000
Message-ID: <2888b742-9d02-466a-bd16-33296a686d7c@suse.de>
Date: Mon, 26 Oct 2026 15:26:38 +0100
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
Subject: Re: [PATCH nf v2] netfilter: nf_conntrack_sip: fix OOB read in
 ct_sip_parse_transport()
To: Joas Antonio dos Santos <joasantonio108@gmail.com>,
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>, Duc Anh Luu <luuducanh05051995@gmail.com>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <179286139765.93379.986858959213810476@gmail.com>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <179286139765.93379.986858959213810476@gmail.com>
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
	FREEMAIL_TO(0.00)[gmail.com,netfilter.org,strlen.de];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[9];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[nwl.cc,gmail.com,vger.kernel.org,netfilter.org];
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -13.29

On 10/24/26 7:03 PM, Joas Antonio dos Santos wrote:
> ct_sip_parse_transport() compares the value of the "transport=" header
> parameter against "TCP"/"UDP" with strncasecmp(..., 3), but it never
> checks that the parsed value is at least 3 bytes long.
> 
> ct_sip_parse_param() returns matchlen = end - start, where end is the
> next ';' or, when there is no ';', the end of the payload buffer
> (limit = dptr + datalen).  If the "transport=" value is only 1 or 2
> bytes long and runs exactly to the end of the payload (e.g. a REGISTER
> request whose Contact header ends in ";transport=T" with no trailing
> CRLF), matchlen is less than 3 while strncasecmp() still reads up to 3
> bytes, reading 1-2 bytes past the end of the linearized skb data.
> 
> Add a matchlen check before the comparison, mirroring the
> sdp_media_type() pattern a few lines below, so short values cannot reach
> strncasecmp().
> 
> The bug was found by LLM-assisted manual review of the SIP helper's
> parsers and confirmed with a userspace ASan harness built from the
> verbatim parser functions, which reports a heap-buffer-overflow read of
> size 2 in strncasecmp() called from ct_sip_parse_transport().
> 
> Fixes: ea45f12a2766d ("[NETFILTER]: nf_conntrack_sip: parse SIP headers properly")
> Link: https://lore.kernel.org/netfilter-devel/20260815133104.50369-1-joasantonio108@gmail.com/
> Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
> Assisted-by: Claude:claude-opus-5-5

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

Thanks!
