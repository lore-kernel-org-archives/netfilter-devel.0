Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793026084;
	b=iiVQFeJnH568AV/CNpINRrOadMs8ZdgIRVf9Xi6GnCd+UqOOq3EQbsuQzfFAp0Z68sbo
	 /L0vgd4t7kS+4ivaEeRHNHC1XgTL0jtfva+wE7SqG4VihkPqM2XxQ9VUr9JEMr1CWbiRz
	 g/8+Bv58wJbO1k//7a+zjHpvVnkicCsitf65j9o5MO05K3r/d80HvW/fH06R01C0KeoE4
	 +Nbg9o5MYpLEMQ/O/dMwt/ncMf2nLkDddcXgeg0gr5AAEk1Vp13BV3yIpEBbXgCcUi09W
	 HGTCN1sVEuNC4iuXXfvTH/gb+b3N61YOBKVVNcdUMXwssyaesTbSddGataK+se30diw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793026084;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=c4fhNBhjWd5b4LsGj3Nu0Y1DHvUPKC82YqRdlrw/Dbc=;
	b=HIpZ/vH4yBmd+TzTeePGpDGwgSL5quTKNJQYmuzarXsdzk1znI8In0mCubm2LEiSHDhU
	 ilkwElnbG95YBfHn/W1RFFNPq79WJw2nqz4COyoAe6UG+O54sQmfYd5tsR/uFs+tzFgYo
	 0DWrQb2x/htKjnVZR8tX78IvfehXffvPxGTlZ4L/3bkyYz+vP8eA2qn46A6bro+RoY8Io
	 YLdz3hOMEbZWBHzaw4+4RdTL0GtQrPzZDSx97ZWTVmeoleD/ohWUq5b7CBfF1/y8sBRrI
	 Nznph8Lex4f/udPu4vMXvKtAlBnf/h6khwxyw4cfUGW9gzRTTUQ7m6kQ5VWYKW7Npmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=R+7ELHqG;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OB1mtzAE;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=FzvGw2Ab;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=kE0HtejF;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1400606A31A
	for <netfilter-devel@vger.kernel.org>; Mon, 26 Oct 2026 14:48:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1400606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=R+7ELHqG;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OB1mtzAE;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=FzvGw2Ab;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=kE0HtejF
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D5BCD21FCF;
	Mon, 26 Oct 2026 14:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793026082; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c4fhNBhjWd5b4LsGj3Nu0Y1DHvUPKC82YqRdlrw/Dbc=;
	b=R+7ELHqGbBatAkgTP7r9MApmMvQFTT0xU5FaI/4cFPw3RMl8GiCcF391tpK5ZcdtytoX6a
	7gLiEBjWNppE7LvJiZb92RtOy/I8oOXtRNRIlW5Kfi/a2QPcewFB+fv1F68EaFZyVAxiJf
	/+AXa3ryQJ0AcW0nEY9sVYt6BZiQs98=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793026082;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c4fhNBhjWd5b4LsGj3Nu0Y1DHvUPKC82YqRdlrw/Dbc=;
	b=OB1mtzAE/YCMecLu/KH7wrTa0BYgvFR0z2ez/UPgmuUZv+jeqJ1sBlJaLVflx6nSZrOQmS
	gkFNX53zsz7sBZBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FzvGw2Ab;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=kE0HtejF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793026081; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c4fhNBhjWd5b4LsGj3Nu0Y1DHvUPKC82YqRdlrw/Dbc=;
	b=FzvGw2AbqN9gZ3/6pNG+Ac0lXFV15gGdkecwlPkSJCWcdTSwmztlfaq0pgsV4rmCPe1qXg
	EXJ9jTFqsWALSPKShFpWDHAtzVT2a9Bpao2kcR0/AE6favq2MrvhDbwM76mDHRRrBTw0y0
	3stomxhdddISlRzspMYiBn0K0iyCwNg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793026081;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c4fhNBhjWd5b4LsGj3Nu0Y1DHvUPKC82YqRdlrw/Dbc=;
	b=kE0HtejF3H1LJE+JzRdQOYZ/Jq3CwT3vrOTMuABYO0VdQmOTAEDuJODx/3HLetGDa3i6mr
	TOAyf3H5Ppm78yBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8F5C313319;
	Mon, 26 Oct 2026 14:48:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UvcsGiFo32qhSwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 26 Oct 2026 14:48:01 +0000
Message-ID: <1729d120-ac5b-451d-935f-834864a1691d@suse.de>
Date: Mon, 26 Oct 2026 15:46:55 +0100
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
Subject: Re: [PATCH libnftnl 0/7] misc LLM fixes
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20261023135806.7259-1-fw@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20261023135806.7259-1-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D5BCD21FCF
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-13.50 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -13.50

On 10/23/26 3:57 PM, Florian Westphal wrote:
> The only thing these changes have in common is that they are all
> LLM findings.
> 
> 1) Prevent out-of-bounds read in str_array.h, this doesn't cause crash, the
> value that is read off the end of the array is not used.
> 
> 2) Fix NFTNL_CHAIN_TYPE data_len to return the string length, consistent with
> other attributes.
> 
> 3) Fix fd leak in nftnl_batch_is_supported when mnl_socket_bind() fails.
> Close the already-open socket on the error path.
> 
> 4) Free partially-allocated sub-objects in nftnl_expr_parse error path via
> nftnl_expr_free. Fixes memory leaks (e.g., dynset set_name) when parsing
> embedded expressions fails after allocation.
> 
> 5) Allow unsetting NFTNL_FLOWTABLE_SIZE.
> 
> 6) Fix pointer state inconsistency by freeing the old value only after
> strndup succeeds. Delegate nftnl_parse_str_attr to the fixed helper
> instead of open-coding the same bug.
> 
> 7) Add nftnl_mem_blob helper for user_data and switch all users to it,
> resolving inconsistent state on alloc failure.
> 
> Florian Westphal (7):
>    include: str_array.h: avoid oob read
>    src: chain: fix NFTNL_CHAIN_TYPE data_len
>    src: common: fix fd leak in nftnl_batch_is_supported
>    expr: nftnl_expr_parse: use nftnl_expr_free on error unwind
>    src: flowtable: allow to unset NFTNL_FLOWTABLE_SIZE
>    src: utils: keep old name if strndup fails
>    src: add and use nftnl_mem_blob for user_data
> 
>   include/obj.h       |  5 +----
>   include/rule.h      |  5 +----
>   include/set.h       |  5 +----
>   include/set_elem.h  |  6 ++----
>   include/str_array.h |  8 ++++----
>   include/utils.h     | 24 ++++++++++++++++++++++++
>   src/chain.c         | 25 ++++++++-----------------
>   src/common.c        |  5 ++++-
>   src/expr.c          |  2 +-
>   src/flowtable.c     |  1 +
>   src/object.c        | 18 ++++++------------
>   src/rule.c          | 41 +++++++++++++----------------------------
>   src/set.c           | 18 ++++++------------
>   src/set_elem.c      | 31 +++++++++++--------------------
>   src/table.c         | 23 +++++++----------------
>   src/utils.c         | 43 ++++++++++++++++++++++++++++++++-----------
>   16 files changed, 122 insertions(+), 138 deletions(-)

For the whole series:

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

Thanks!

