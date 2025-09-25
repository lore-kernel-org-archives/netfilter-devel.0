Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90742282F1
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Sep 2025 12:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758803784; cv=none; b=T5ST8FBt8/GRP37AWnAPwTkgAusoUj3WFpbiMI/uKeDyV8dM6lkV3AXK3LTTatMK9Mhf/8seKcJcAqwwvcX2g8Oeedxj6tW/tSWKuYyNTDGRnTKrmAnjiM/rxY57E52zD0AAB7kNtiMCe+sJS942+fv1n4KDfl80h+MZ8NsPtKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758803784; c=relaxed/simple;
	bh=b0UKCTgvMKf8QBiMJFrUQvWjNCQlFYecjCkeQCWkqoM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=PtzXMGqCnwcYGsIEtZ+1OCy35BaFJGrL1o99f2tyi/fy+GCR8hbwm5nINtjVc6qKV1j7hE/hLRwBoBrGQKAWiJCo0ahD3K1OLfoGFTn4/6xkFvLGTqOMXxa3VeNQDTrJN0xC9s3NA/fn85EU84RnIy7kMp8yChpnmRhTodRgMtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sib8i1hm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=v0mb2Eam; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sib8i1hm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=v0mb2Eam; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sib8i1hm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="v0mb2Eam";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sib8i1hm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="v0mb2Eam"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8819C6AFDF;
	Thu, 25 Sep 2025 12:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758803780; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RUkMOpfvxeJDazlACABnQQYaYYxfhEKw4bPs0o7UKpE=;
	b=sib8i1hm841uBPdtcxpAyzSM6Nu0LT5KmUTCvOsQKFU9O7V2EWnzk2iZCESZSL35rC2Ib6
	vVvKjFrfsblbMUe3P+xF2fdi5pQymwjRUcH6UZVwJgfpYrfi0Bb5RBJQEM+K2C7+5LjQ7S
	hXTXlOx0mthbPqyj0gULJsoSS1pYmwk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758803780;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RUkMOpfvxeJDazlACABnQQYaYYxfhEKw4bPs0o7UKpE=;
	b=v0mb2Eamlo4YfzrbeFj9k/slXfuQ2BPwhc2iZOtqsG8QQU70nd2Xg0D+lpfrF9+/+ov8Ft
	RW91GrbNZh+3hWBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758803780; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RUkMOpfvxeJDazlACABnQQYaYYxfhEKw4bPs0o7UKpE=;
	b=sib8i1hm841uBPdtcxpAyzSM6Nu0LT5KmUTCvOsQKFU9O7V2EWnzk2iZCESZSL35rC2Ib6
	vVvKjFrfsblbMUe3P+xF2fdi5pQymwjRUcH6UZVwJgfpYrfi0Bb5RBJQEM+K2C7+5LjQ7S
	hXTXlOx0mthbPqyj0gULJsoSS1pYmwk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758803780;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RUkMOpfvxeJDazlACABnQQYaYYxfhEKw4bPs0o7UKpE=;
	b=v0mb2Eamlo4YfzrbeFj9k/slXfuQ2BPwhc2iZOtqsG8QQU70nd2Xg0D+lpfrF9+/+ov8Ft
	RW91GrbNZh+3hWBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5C8E9132C9;
	Thu, 25 Sep 2025 12:36:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ptt/E0Q31WgMHAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 25 Sep 2025 12:36:20 +0000
Message-ID: <e19bafc0-61c9-47af-afb6-15f886cc4d37@suse.de>
Date: Thu, 25 Sep 2025 14:36:15 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: bug: nft -n still shows "resolved" values for iif and oif
To: Christoph Anton Mitterer <calestyo@scientia.org>,
 netfilter-devel@vger.kernel.org
References: <f2c46dc450b3223834cd837882877f892b234491.camel@scientia.org>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <f2c46dc450b3223834cd837882877f892b234491.camel@scientia.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.30



On 9/24/25 11:48 PM, Christoph Anton Mitterer wrote:
> Hey.
> 
> E.g.:
> # nft list ruleset
> table inet filter {
> 	chain input {
> 		type filter hook input priority filter; policy drop;
> 		ct state { established, related } accept
> 		iif "eth0" accept
> 	}
> }
> #  nft -n list ruleset
> table inet filter {
> 	chain input {
> 		type filter hook input priority 0; policy drop;
> 		ct state { 0x2, 0x4 } accept
> 		iif "eth0" accept
> 	}
> }
> 
> 
> IMO especially for iif/oif, which hardcode the iface ID rather than
> name, it would IMO be rather important to show the real value (that is
> the ID) and not the resolved one... so that users aren't tricked into
> some false sense (when they should actually use [io]ifname.
> 

Hi,

AFAICS, the current -n is just a combination of '--numeric-priority 
--numeric-protocol --numeric-time'. Although, the message displayed when 
using --help is misleading.

-n, --numeric                   Print fully numerical output.

I propose two changes:

1. Adjust the description when doing --help
2. Introduce a new "--numeric-interface" which prevents resolving iif or 
oif.

Another possible solution could be to use --numeric to do not resolve 
iif/oif but then it would mean we should not resolve ANYTHING as "Print 
fully numerical output." mentions.

What do you think? I can send a patch and test it.

Thanks,
Fernando.

> Maybe one could however always resolv it for lo, if that is truly
> always ID 1, as I've been told.
> 
> 
> Thanks,
> Chris.
> 
> 
> [0] https://lore.kernel.org/netfilter/aNPhP63SyX2ofE92@strlen.de/T/#m15841db7bf5bb588483fdd3576d70af7a71f5555
> 

