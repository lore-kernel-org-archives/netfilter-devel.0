Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC17334690
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Oct 2025 23:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760658386; cv=none; b=cAYjFqcc8w/5d3Vr92OfEDVhCv7SgPIFMP7fFG5Qy6QsWYZPFsOE8N2LXMuzNsE/c/DK0QTrtXAlTThLMdN2QQXPdjPPsgft6zN4824c1RBWVhE0U0omh8/5cpv8bdXg2mEqgLEQApXRQ/72v8QqVMKftNp7pFmQ0yDtu76JbYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760658386; c=relaxed/simple;
	bh=392vCtvI7VFkbsSl+3W5Evu3sYXfdVkAhTUnZA6iWvE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=N5u/5LuYJZ6lGQNmMxaOWMozLEvad2qsu7R9TmAI6qgv2fzB4YP970mRRbyNuCzn4oFxCWm3N7a9x2WQnruvt56/HeRve+7rh8CGu1bujWXFT/mYm1qdm29Sy7squ1t0ShaN8lO/oieEccKb6vHh2fu6+PA258EqUEiKBIkR+eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nnYd6FY4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=v/DOqItY; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nnYd6FY4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=v/DOqItY; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nnYd6FY4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="v/DOqItY";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nnYd6FY4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="v/DOqItY"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 077B421B2E;
	Thu, 16 Oct 2025 23:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760658383; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=laU0HkjMWt8LpMUTBtuqKs8ECbrIZ/s/Cqfrt6iM3LI=;
	b=nnYd6FY49BwqS/pMALA0Cj9mryqqVE+15sEZhHchEVStcUah5MNGoBTUpLZ7LOEVPhD3cQ
	Wnf5cADQGK/fEL9BzUuJvFyR/cSatWcWaIGk6u49o4UfNiXCOACP8IGl+3zA6Q7pAqBV46
	CAWmWhWD9oLTLRomulRXlVN0c3CzDr8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760658383;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=laU0HkjMWt8LpMUTBtuqKs8ECbrIZ/s/Cqfrt6iM3LI=;
	b=v/DOqItYsYoFKYJk2b5wfaNMAVYn34osRD6DgOIFY2f/bgI3utkmLgJt5OxdjOoMZNvitv
	+YgFcZndYkcOo0Bg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760658383; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=laU0HkjMWt8LpMUTBtuqKs8ECbrIZ/s/Cqfrt6iM3LI=;
	b=nnYd6FY49BwqS/pMALA0Cj9mryqqVE+15sEZhHchEVStcUah5MNGoBTUpLZ7LOEVPhD3cQ
	Wnf5cADQGK/fEL9BzUuJvFyR/cSatWcWaIGk6u49o4UfNiXCOACP8IGl+3zA6Q7pAqBV46
	CAWmWhWD9oLTLRomulRXlVN0c3CzDr8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760658383;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=laU0HkjMWt8LpMUTBtuqKs8ECbrIZ/s/Cqfrt6iM3LI=;
	b=v/DOqItYsYoFKYJk2b5wfaNMAVYn34osRD6DgOIFY2f/bgI3utkmLgJt5OxdjOoMZNvitv
	+YgFcZndYkcOo0Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D122D1340C;
	Thu, 16 Oct 2025 23:46:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ETxuL86D8Wi5EAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 16 Oct 2025 23:46:22 +0000
Message-ID: <1d7b09a6-c2b1-4fb8-be84-af0c4f1fd1a6@suse.de>
Date: Fri, 17 Oct 2025 01:46:22 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nft 0/4] nft tunnel mode parser/eval fixes
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20251016145955.7785-1-fw@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20251016145955.7785-1-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 



On 10/16/25 4:59 PM, Florian Westphal wrote:
> This series addresses a few bugs found with afl fuzzer, see individual
> patches for details.
> 

Sorry for making you waste time here. I will follow up with the 
improvements mentioned on the other emails.

In addition, I want to set up afl fuzzer too :)

Thank you!

> Florian Westphal (4):
>    evaluate: tunnel: don't assume src is set
>    src: tunnel src/dst must be a symbolic expression
>    src: parser_bison: prevent multiple ip daddr/saddr definitions
>    evaluate: reject tunnel section if another one is already present
> 
>   src/evaluate.c                                | 29 +++++++--
>   src/parser_bison.y                            | 63 ++++++++++++++++---
>   .../nft-f/empty_geneve_definition_crash       |  4 ++
>   .../bogons/nft-f/tunnel_in_tunnel_crash       | 10 +++
>   .../bogons/nft-f/tunnel_with_anon_set_assert  |  9 +++
>   .../bogons/nft-f/tunnel_with_garbage_dst      |  5 ++
>   6 files changed, 104 insertions(+), 16 deletions(-)
>   create mode 100644 tests/shell/testcases/bogons/nft-f/empty_geneve_definition_crash
>   create mode 100644 tests/shell/testcases/bogons/nft-f/tunnel_in_tunnel_crash
>   create mode 100644 tests/shell/testcases/bogons/nft-f/tunnel_with_anon_set_assert
>   create mode 100644 tests/shell/testcases/bogons/nft-f/tunnel_with_garbage_dst
> 

