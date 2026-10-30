Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793351878;
	b=RMOcuEY8Kk5FPoE/y60UlsFZ+fUiJWGLf4DgQuASMOIdmzWotE0RC84pwHrk4qFwQzsc
	 6o12CePTY1JlBgAXJKiIRjn8B5Uxa307HAsKJHYEa0KmDqwjsK2O7rPPEc9OnesEvzCA2
	 4lhWypYmbOdLVMB5rR7woxjFYyMP5fxmGN8V09uQFCNRiL69uqcw7K9x9AjVLaEqnpwak
	 cCOPLFG4aQDbWXusuMVp31aRWC4rMIIDaHOrT6HdMKOVEoweIiFlgV1ntbQH9xR84PCsD
	 3zDSwVFaz9Op/JV21+8brNi9/hBU3ppIryEZ1cq2DekaFg3tFwQXOsJbN8jjEtjTA2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793351878;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=9jTtEVNt7UYfSKNwtbCMXjr7hW3XM8fUeKbTJzhjJ2w=;
	b=2xzv3Lsel8gRmKPv8HJu4MrKNuPI6n1cxApDIf4HBnMHfFHyT6+gJX82+cTbfJUuWQVN
	 TNQ/9JlftguScXvnhSD/YmkN6pTpWyoVv8KRHPtvBGUBATcGBe3+v6v3QZAQ+IjvjILp4
	 IHlFgx3qyrpa8/xb2tXg+qvMOhhjLlqw8MRuZxKrJU0SWi0Cxx9VA5K2o/4P8B19Kyc8t
	 BsS3NIVYLdQHHWsGdUrdlLyTD6l+25pTNm6Fi/gCytAgOP3PMgBro/RSuhHUTFTIW1JXa
	 pxN3ClCHdT0mNbcvilLFjLMhmimutLht8S8gbJZV2qVil8jUTj0MgRHC6ZAvKnbJjfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=GSS4Y391;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=LFkHozn6;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=GSS4Y391;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=LFkHozn6;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809C6606A32F
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2026 09:17:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 809C6606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=GSS4Y391;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=LFkHozn6;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=GSS4Y391;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=LFkHozn6
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7CDE622169;
	Fri, 30 Oct 2026 09:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793351875; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9jTtEVNt7UYfSKNwtbCMXjr7hW3XM8fUeKbTJzhjJ2w=;
	b=GSS4Y3916HP8gFO5Q9U1/QudH0UCfl+znAsterasoVHP5HJI8wzyugwtZgGuyG0PHjLPRI
	Hs332DyrdV1gVGhngQqk2pDs0Oi/9l82HNYYjM46wUHxw9dvMHSFQAy7aN7WsQ/IM58rME
	OcGBdB1NW3DOzbKemtYRqVhWancUHFg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793351875;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9jTtEVNt7UYfSKNwtbCMXjr7hW3XM8fUeKbTJzhjJ2w=;
	b=LFkHozn68lK9i4cUb+4bSqIini4j2PfrGNJ4sbIOoSwduu6ZEsmDFyTMIR0ZRt52fqizTy
	USmcuGfZcPfyTEBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=GSS4Y391;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=LFkHozn6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793351875; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9jTtEVNt7UYfSKNwtbCMXjr7hW3XM8fUeKbTJzhjJ2w=;
	b=GSS4Y3916HP8gFO5Q9U1/QudH0UCfl+znAsterasoVHP5HJI8wzyugwtZgGuyG0PHjLPRI
	Hs332DyrdV1gVGhngQqk2pDs0Oi/9l82HNYYjM46wUHxw9dvMHSFQAy7aN7WsQ/IM58rME
	OcGBdB1NW3DOzbKemtYRqVhWancUHFg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793351875;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9jTtEVNt7UYfSKNwtbCMXjr7hW3XM8fUeKbTJzhjJ2w=;
	b=LFkHozn68lK9i4cUb+4bSqIini4j2PfrGNJ4sbIOoSwduu6ZEsmDFyTMIR0ZRt52fqizTy
	USmcuGfZcPfyTEBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 33605132C9;
	Fri, 30 Oct 2026 09:17:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JDigAcNg5GpiUgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 30 Oct 2026 09:17:55 +0000
Message-ID: <f67d8718-c74f-42e6-8043-51cb52934d0a@suse.de>
Date: Fri, 30 Oct 2026 10:16:37 +0100
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
Subject: Re: [PATCH libftnl 00/12] more misc LLM fixes
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20261028145632.7089-1-fw@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20261028145632.7089-1-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7CDE622169
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
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:email]
X-Spam-Score: -13.50

On 10/28/26 3:56 PM, Florian Westphal wrote:
> Another round of LLM findings.  These commits are all unrelated,
> except that they are LLM findigs with no observed bug reports.
> 
> 1) Check mnl_nlmsg_batch_start() for a NULL return. Avoid potential NULL
> pointer dereference in src/common.
> 
> 2) Fix uninitialised attr arrays by zero-initialising tb[] arrays.
> 
> 3) Move several MNL_STRING attribute types to MNL_NUL_STRING so
> mnl_attr_validate enforces NUL termination. Harden future
> netlink-attribute parsing against non-kernel sources that may omit the
> terminator.
> 
> 4) Validate NFTA_EXPR_NAME parse success. Upgrade string validation to
> NUL_STRING, since the kernel always appends a trailing NUL.
> 
> 5) Forbid re-setting or clearing the object type field to prevent
> inconsistent state and segfaults. Check the correct subtype before freeing
> to guard against a latent union overlap crash.
> 
> 6) Drop trailing semicolon from the xfree macro. Callers already append their
> own ;, so the macro's is redundant.
> 
> 7) Remove the obsolete set_elem member from the ruleset union. Its last
> consumer (the removed json interface) no longer exists, and the shared
> nftnl_set_free path masked a latent type-confusion bug.
> 
> 8) Clear field_len array before copying to avoid reading stale values from a
> prior call. Fix a bug where shrinking the array on a second invocation
> leaks leftover field counts.
> 
> 9) Guard the s->expr_list traversal against the empty-list case to avoid
> returning a pointer into the middle of nftnl_set. Initialize data_len to 0.
> 
> 10) Fix use-after-free by calling list_del() before freeing expressions in
> set_elem. Prevents dangling next/prev pointers from corrupting a
> subsequent list_add on the same list.
> 
> 11) Clamp buf->end to the actually copied size in udata_buf_put. Prevent
> nftnl_udata_buf_space() from observing an end pointer past the buffer.
> 
> 12) Remove all remaining MNL_STRING users, switch to MNL_NUL_STRING and
> mnl_attr_put_strz. Enforce NUL-termination checking on all string
> attributes to prevent illegal strlen/strdup on unchecked data.
> 
> Florian Westphal (12):
>    src: common: mnl_nlmsg_batch_start may return NULL
>    src: fix uninitialised attr arrays
>    src: move several MNL_STRING types to MNL_NUL_STRING
>    src: expr: make sure NFTA_EXPR_NAME was parsed successfuly
>    src: object: don't permit to re-set or clear object type field
>    include: drop semicolon at end of xfree macro
>    src: ruleset: remove set_elem member from union
>    src: set: clear field_len array before copying
>    src: set: check for empty list explicitly
>    src: set_elem: list_del before freeing
>    src: udata: clamp buf->end to actally copied size
>    src: remove all remaining MNL_STRING users
> 
>   examples/nft-compat-get.c |  2 +-
>   include/utils.h           |  2 +-
>   src/chain.c               |  4 ++--
>   src/common.c              |  4 ++++
>   src/expr.c                |  5 ++++-
>   src/expr/data_reg.c       |  4 ++--
>   src/expr/dynset.c         |  2 +-
>   src/expr/flow_offload.c   |  2 +-
>   src/expr/log.c            |  2 +-
>   src/expr/lookup.c         |  2 +-
>   src/expr/objref.c         |  6 +++---
>   src/flowtable.c           |  2 +-
>   src/obj/ct_helper.c       |  4 ++--
>   src/obj/secmark.c         |  4 ++--
>   src/object.c              | 19 +++++++++++++++----
>   src/rule.c                |  2 +-
>   src/ruleset.c             |  3 +--
>   src/set.c                 | 13 +++++++------
>   src/set_elem.c            | 10 +++++++---
>   src/table.c               |  2 +-
>   src/trace.c               |  6 +++---
>   src/udata.c               |  5 ++++-
>   src/utils.c               |  5 +++--
>   23 files changed, 68 insertions(+), 42 deletions(-)
> 

For the whole series:

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

Thanks!
