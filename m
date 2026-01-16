Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC46533A6E2
	for <netfilter-devel@vger.kernel.org>; Fri, 16 Jan 2026 15:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768577514; cv=none; b=LryWte52xZSM7FD+lYN+lzGrDeQQWxQIZPLl/rg2DaT3m68ZQwGLrKJyRStkHRyISxarqbG1DWHquznWlA/lKrvZUGLiic6ndGEAo1wVeJb9cH6g/52GibRn48cLz+Ff4mQ3HKs5BxViZP27mKIykXk4pfiO+9PKXhPburqK9zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768577514; c=relaxed/simple;
	bh=IzrMQkq70Cxm4pigQ8xG5z7FDOeh7gHVZ5fxlq8kE7M=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=h5HLvD9z3rbW4RgHeFdCZOMk/kDqkD+gzYdrBTcZq0w+DUilY16qbbo5ANt7IbadebaKCeXcS17hdLe3AqkHk9tHmNqGC3q3AN2nCoHVufp7fR78VBr8Eu6/Nf3sQAWLbvtbnw4fqQNFH0Hd2ZWNYv9CFl9fpzNxTfdZKRDo2rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rpQK+nNE; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/2mW+ECV; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vBDAq9s+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=SpgqEQ7o; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rpQK+nNE";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/2mW+ECV";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vBDAq9s+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SpgqEQ7o"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 20CA05BE58;
	Fri, 16 Jan 2026 15:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768577509; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5T73AKt1C+JbOJ8TxKkwX0+5VLxcWbSt08S/m90VIf0=;
	b=rpQK+nNEkMDZLkb+cFN793HDMQZoSs0WIf0yQQUJVnLTY5+8WXUaIPKkhRSqjMbX4LiZOl
	/YIb9Q/4DR+i1/Yz/5K20uW4tSbfkmg5YtI72J2raPgcABn1qSK6OWwDk7Yb96Nowh25mP
	BlR8HpPIq0BfXMPio/l00RBB0TjEUp8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768577509;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5T73AKt1C+JbOJ8TxKkwX0+5VLxcWbSt08S/m90VIf0=;
	b=/2mW+ECVEWzCzt5iwq/LXrwLZMOkQWDe33nNsVsHxdE03AcwhuOzk2cquellxxelbaFqYu
	WsoWPI00TNzrU+DQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768577508; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5T73AKt1C+JbOJ8TxKkwX0+5VLxcWbSt08S/m90VIf0=;
	b=vBDAq9s+Ukroo9P+VJlxr901K0JFTkhlTZlR4emAWUwEVODiwSxX2Nbsqjlxor8nOmNG7I
	VJ/1UnEr6fBOiWB6XyKovfYUNL/dfHT+9fD0N3wwZ4VSHo+pS54eDXv8ZBz2A6hui5rgLu
	X1wV/2Z5XlzZIk6YygB3U0BircnQTNk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768577508;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5T73AKt1C+JbOJ8TxKkwX0+5VLxcWbSt08S/m90VIf0=;
	b=SpgqEQ7o9UGgMvsRZPXz8B0M+6d8EmiyoegEd5oe+InP2/IuAsO8bpku2rBly86rHXi2SD
	6bHq67z48rew4KBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C40683EA63;
	Fri, 16 Jan 2026 15:31:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id i3mGKeNZamk2LAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 16 Jan 2026 15:31:47 +0000
Message-ID: <74d8f91b-3e25-448b-90d5-981c3fcc89d6@suse.de>
Date: Fri, 16 Jan 2026 16:31:30 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf-next] netfilter: nft_compat: add more restrictions on
 netlink attributes
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20260116114219.20868-1-fw@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260116114219.20868-1-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.30
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Level: 
X-Spam-Flag: NO

On 1/16/26 12:42 PM, Florian Westphal wrote:
> As far as I can see nothing bad can happen when NFTA_TARGET/MATCH_NAME
> are too large because this calls x_tables helpers which check for the
> length, but it seems better to reject known bad values early via
> netlink policy.
> 
> Rest of the changes avoid silent u8/u16 truncations.
> 
> For _TYPE, its expected to be only 1 or 0. In x_tables world, this
> variable is set by kernel, for IPT_SO_GET_REVISION_TARGET its 1, for
> all others its set to 0.
> 
> As older versions of nf_tables permitted any value except 1 to mean 'match',
> keep this as-is but sanitize the value for consistency.
> 
> Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x_tables")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Looks good to me and tested it.

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

