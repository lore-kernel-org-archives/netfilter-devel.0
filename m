Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2C83911C8
	for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2026 13:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778593891; cv=none; b=ij+i7tWnefr92ZF/731yCUSi2GjAUc/AGDU6ZqXWilF0OL8Omz4phdjRZn1XcPfG91O8ePDboF+rTjYZMa7vXq/dYMw6zKOybVNUHNxvSrdM7UPJOe82eq54VgFylptU4rhtl+9k9zYvERLhRURHxby2uswwUcypO1TnOjK+2yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778593891; c=relaxed/simple;
	bh=HDzA6rnRwYSzBBYMSmkrjSJSmFmgXGRLZ+4QFSbV4EM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=MCvnh3UdWjmVh2Gt71g2lyyY1Ydcr6rnLlpjPX4FgbfEYOb5YGE5j7pERjJ8Z3nMKQVy8j4HJlAHm2p77WD35j12kMPaVaJpnONDRXhkssDmTK6+jzjcimgPN4JhX++aPA6+JYLLK+SEnWL4R5ghM6LEI092YzBqQwqsMLKVTnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sI4BjihD; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=u0bJUCf1; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sI4BjihD; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=u0bJUCf1; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sI4BjihD";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="u0bJUCf1";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sI4BjihD";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="u0bJUCf1"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0C1226A901;
	Tue, 12 May 2026 13:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778593888; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/ON0cwqVBv262i8NOpfCMQotKKWtbSE9dJssgY/3ybU=;
	b=sI4BjihDmdOCo02qB8JFHNxrzHY+JfV+Ooyjl+VVNOYumr833QhSPVYpm0CizaZ/AQ7Tlx
	No7QTvfFk4JIE7VHY8H05hKo/TttqHj5MT+khBaHHXnwzwqJLlOOFnZu9E/zLf/GYBVjDI
	7Wt+uAJzD9YdZZDrofq1KA8qfXMYFYI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778593888;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/ON0cwqVBv262i8NOpfCMQotKKWtbSE9dJssgY/3ybU=;
	b=u0bJUCf1xkIDy2+OpNaQXvYFErhVI05l3fhB7D3tPRo/pexbTwZjNWWvZJPHQXlgPo0pGx
	CnE+cW/x5NZZBMDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778593888; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/ON0cwqVBv262i8NOpfCMQotKKWtbSE9dJssgY/3ybU=;
	b=sI4BjihDmdOCo02qB8JFHNxrzHY+JfV+Ooyjl+VVNOYumr833QhSPVYpm0CizaZ/AQ7Tlx
	No7QTvfFk4JIE7VHY8H05hKo/TttqHj5MT+khBaHHXnwzwqJLlOOFnZu9E/zLf/GYBVjDI
	7Wt+uAJzD9YdZZDrofq1KA8qfXMYFYI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778593888;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/ON0cwqVBv262i8NOpfCMQotKKWtbSE9dJssgY/3ybU=;
	b=u0bJUCf1xkIDy2+OpNaQXvYFErhVI05l3fhB7D3tPRo/pexbTwZjNWWvZJPHQXlgPo0pGx
	CnE+cW/x5NZZBMDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 85662593A9;
	Tue, 12 May 2026 13:51:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id h7C7HV8wA2qZawAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 12 May 2026 13:51:27 +0000
Message-ID: <7d6c2b21-276c-4b30-8eed-8e75e519c533@suse.de>
Date: Tue, 12 May 2026 15:51:18 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 nf-next] netfilter: nft_byteorder: remove
 multi-register support
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20260512133617.8191-1-fw@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260512133617.8191-1-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,strlen.de:email,suse.de:mid];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,strlen.de:email,suse.de:mid,suse.cz:email]
X-Spam-Level: 

On 5/12/26 3:36 PM, Florian Westphal wrote:
> 64bit byteorder conversion is broken when several registers need to be
> converted because the source register array advances in steps for 4 bytes
> instead of 8:
> 
>    for (i = ...
>        src64 = nft_reg_load64(&src[i]);
>                               ~~~~~ u32 *src
>        nft_reg_store64(&dst64[i],
> 
> Remove the multi-register support, it has other issues as well:
> 
> Pablo points out that commit
> caf3ef7468f7 ("netfilter: nf_tables: prevent OOB access in nft_byteorder_eval")
> alters semantics: before the loop operated on registers, i.e.
>   for ( ... )
>     dst32[i] = htons((u16)src32[i])
> 
>   .. but after the patch it will operate on bytes, which makes this
>   useless to convert e.g. concatenations, which store each compound
>   in its own register.
> 
> Multi-convert of u32 has one theoretical application:
> 
> ct mark . meta mark . tcp dport @intervalset
> 
> Because ct mark and meta mark are host byte order, use with
> intervals has to convert the byteorder for ct/meta mark value
> to network byte order (bigendian).
> 
> nftables emits this:
>   [ meta load mark => reg 1 ]
>   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
>   [ ct load mark => reg 9 ]
>   [ byteorder reg 9 = hton(reg 9, 4, 4) ]
>   ...
> 
> I.e. two separate calls.  Theoretically it could be changed to do:
>   [ meta load mark => reg 1 ]
>   [ ct load mark => reg 9 ]
>   [ byteorder reg 1 = htonl(reg 1, 4, 8) ]
>   ...
> 
> But then all it would take to change the set to
> meta mark . tcp dport . ct mark
> 
> ... and we'd be back to two "byteorder" calls. IOW, support to
> convert a range of registers is both dysfunctional and dubious.
> 
> Simplify this: remove the feature.
> 
> Pablo Neira Ayuso points out that nftables before 1.1.0 can generate
> incorrect byteorder conversions, see 9fe58952c45a,
> "evaluate: skip byteorder conversion for selector smaller than 2 bytes"
> in nftables.git).  Affected rulesets fail to load with this change and
> old userspace due to 'len != size' check.
> 
> Fixes: c301f0981fdd ("netfilter: nf_tables: fix pointer math issue in nft_byteorder_eval()")
> Cc: <stable+noautosel@kernel.org> # may break rule load with old nftables versions
> Reported-by: Michal Kubecek <mkubecek@suse.cz>
> Link: https://lore.kernel.org/netfilter-devel/20240206104336.ctigqpkunom2ufmn@lion.mk-sys.cz/
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>   v3: proposing this for inclusion again; sashiko also points out the
>   breakage in nft_byteorder as drive-by result.
> 

Yep, I read the report too. I was going to bring this up again.

+1 from my side, thanks Florian!
