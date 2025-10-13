Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D85C2FB978
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Oct 2025 09:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760346286; cv=none; b=GCo6IkyHitkRAQO7jWtOdWBamwNHyG31YuOByZvP0KjNrSWQ1BMOnCy4F32c0ouY94zrGHJP8qJzd8VRA6seyGUZslVPVXVy7ahaag/VJrzTN7G/Z6js7+Nvct2ls4FlPC6kbONeV89MUlz09PD92FfCH6prcvYhTV5q1DqMxeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760346286; c=relaxed/simple;
	bh=ArPk5F3tZzTcn61dZ5qKcWyvw29Uekx/BGuqxUSXgOI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AZhug82i7bu6BDh9+SgyxVhOUKfDpI+zOnmUz1rjuagH4UJgzL3tFuxeYN+qStJiZihCCEtYzZjAhhnVmfFVuwiUJE8CbP9w5ad7nqsiloaffMcyapVmEngMIogVVyC7m+YyjfHxr0reMXGD4ZhJOWZ5rFI3mg3877dwIw/Q7K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=R9AFFpqU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=q/SR35do; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=R9AFFpqU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=q/SR35do; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="R9AFFpqU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="q/SR35do";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="R9AFFpqU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="q/SR35do"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 561DF21A02;
	Mon, 13 Oct 2025 09:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760346282; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SR2Zcf0y9WV/9eKPSi3cBezQInqXzzkRmi/DSiyRj1c=;
	b=R9AFFpqUGvoe/spUd9+Blhu0JFO5vj3CCbTMz+hnpBeytYaMejmp1j4wTKmoA9jtbDWhiT
	C8BY0q8isZiuGIP81+Mf1kREH2SqriL2F9t3kyWCaC5BG8NZf43FM7Dh7FO14K7CqIlvEw
	XsOwuKHJtf3Yzc2vY8Bk3zHFetA4AdQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760346282;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SR2Zcf0y9WV/9eKPSi3cBezQInqXzzkRmi/DSiyRj1c=;
	b=q/SR35dod+Ug4KKLeW3JFE31Fv0jRt+SDlU+/QfW5wn6hDo9KdMqcaYUqH9UEqqFabpx0k
	CmnDV3v3R4+VYBBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760346282; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SR2Zcf0y9WV/9eKPSi3cBezQInqXzzkRmi/DSiyRj1c=;
	b=R9AFFpqUGvoe/spUd9+Blhu0JFO5vj3CCbTMz+hnpBeytYaMejmp1j4wTKmoA9jtbDWhiT
	C8BY0q8isZiuGIP81+Mf1kREH2SqriL2F9t3kyWCaC5BG8NZf43FM7Dh7FO14K7CqIlvEw
	XsOwuKHJtf3Yzc2vY8Bk3zHFetA4AdQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760346282;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SR2Zcf0y9WV/9eKPSi3cBezQInqXzzkRmi/DSiyRj1c=;
	b=q/SR35dod+Ug4KKLeW3JFE31Fv0jRt+SDlU+/QfW5wn6hDo9KdMqcaYUqH9UEqqFabpx0k
	CmnDV3v3R4+VYBBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1E1761374A;
	Mon, 13 Oct 2025 09:04:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Nw5UBKrA7Gg/UwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 13 Oct 2025 09:04:42 +0000
Message-ID: <dae7551c-c18e-46ea-b490-1b7310a40195@suse.de>
Date: Mon, 13 Oct 2025 11:04:28 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: iptables: zero dereference parsing bitwise operations
To: "Remy D. Farley" <one-d-wide@protonmail.com>,
 Florian Westphal <fw@strlen.de>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
References: <s5LZtLzqFmQhlD4mtmgcKbrgkfQ-X7k7vvg7s7XnXHekGJSKOMyOdmoiONo7MzuLVqYTFPntt74igf8Q0ERSPy5R9f8L1EfwrhOZbs_nhO8=@protonmail.com>
 <aOpigXfhOrj02Qa5@strlen.de>
 <e2mf5Q5IBD50dFQcvIXCNkQCKwghz-hLmCunP33gaZy33srxWrQKdcL1J3GKA8a0H05T6p4kZGFpR910g7JBZusbg_AmEZKPD1UvW_mEheQ=@protonmail.com>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <e2mf5Q5IBD50dFQcvIXCNkQCKwghz-hLmCunP33gaZy33srxWrQKdcL1J3GKA8a0H05T6p4kZGFpR910g7JBZusbg_AmEZKPD1UvW_mEheQ=@protonmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.980];
	MIME_GOOD(-0.10)[text/plain];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_TO(0.00)[protonmail.com,strlen.de];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[protonmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[protonmail.com:email];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.30



On 10/11/25 10:15 PM, Remy D. Farley wrote:
> On Saturday, October 11th, 2025 at 13:58, Florian Westphal <fw@strlen.de> wrote:
> 
>> Remy D. Farley one-d-wide@protonmail.com wrote:
>>
>>> While messing around with manually encoding nftables expressions, I noticed
>>> that iptables binary v1.8.11 segfaults with -L and -D <chain> options, if
>>> there's a rule containing a bitwise operation of a type other than
>>> mask-and-xor. As I understand, iptables and nft tools only generate rules with
>>> mask-xor, though the kernel seems to happily accept other types as well.
>>
>>
>> No, nftables supports this, but iptables does not.
> 
> 
> Hmm, when I run `nft list ruleset` it terminates successfully, but it does
> report some errors at the end if the rule from the example is present.
> 
>> netlink: Error: Invalid source register 0
>> netlink: Error: Bitwise expression has no right-hand expression
>> netlink: Error: Relational expression has no left hand side
> 
> But I'm not completely sure whether it's not me incorrectly encoding the rule.
> 

Hi Remy, could you share the full output of:

'nft --debug=netlink list ruleset'

This will allow me to understand what is the generated bytecode and an 
easy way to reproduce this with libnftnl. I am happy to investigate/fix 
this on the nft/libnftnl/kernel side :)

> For some context, that's how it renders the rule:
> 
>>     chain example-chain {
>>         accept
>>     }
> 
> 
>> iptables should not segfault, however. Care to make a patch?
> 
> 
> Sure. I think it's fine for now to just check for the operation type and
> error with something like "unsupported bitwise operation", like seems to be the
> case with nft tool, since this issue appears to be extremely uncommon, if it
> hasn't been spotted before.
> 

