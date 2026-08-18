Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B1B476046
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Aug 2026 12:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787057713; cv=none; b=JEhQtzQu88THngHl+Qju8abfIBRx2mGsNb9RF4qUVGMwxmV1ZsxGkFFahCcDshlwEdad1qOiAhEibMPUI/F/meQYFxvtHemKFUBE11yxPQ9a6V2sPVRHkIOgnR4uTNNMzZp0GuynAGpHjWxqPQO0R+wnuqShWwrp4QxvaW2kQMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787057713; c=relaxed/simple;
	bh=iPgr+ZWGWVQNxhOnG6yQbByhSoaIBv5jDE/QqnOYfWE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q5gbP8ASJwvxfE/22FfEcI9UTE9kRv61PxKjJsQiq/41cy3PrhzaE68J4YlR916fJsYd9B/7MeB8VFo7ZkzU4tmL/MIgHeJDJzndxi50pb7wNf2gvHLlKaM1bTMO/mMhgu+UAXz3hp65KiBdBjoszB6AQXd+mKwMpFyqHPC+6hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tsN47Mzm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=LoTxYZsC; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rAMHbERM; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YB/h4M2f; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tsN47Mzm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="LoTxYZsC";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rAMHbERM";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YB/h4M2f"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3152D84551;
	Tue, 18 Aug 2026 12:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787057703; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sse9yBtEbo/7NqJeutKaOvxEj1tFoKQpeGWqXKUduCw=;
	b=tsN47Mzm2NeBdeCCZrwJWD+gi8dghFfUs/oA8OeNuCLO32f+5pZx1aQYtaJmlCdEck/maz
	CN7G6MwjHjiH4okfhPOFwAXGkbEF4KbLP041jCSGwXxoXQ21BMbvmyX9mXjhRLF2uR9LTq
	VwduVKsqvjb/OMha4U/3l/4MAqxqD90=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787057703;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sse9yBtEbo/7NqJeutKaOvxEj1tFoKQpeGWqXKUduCw=;
	b=LoTxYZsCsjINB2zDxI7xMbyWWMw3LhVD45PRCuVv1VNxNcFIGPEf9WGofyvg6MUeFgcrC6
	Nu1s2t5JoW3pHvCQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rAMHbERM;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="YB/h4M2f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787057699; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sse9yBtEbo/7NqJeutKaOvxEj1tFoKQpeGWqXKUduCw=;
	b=rAMHbERMRT67GQObPdYq89rkLjWnJvsZ3ynXOPmy+pq2R0acZyk9knyfpC7vqoLezvZd4p
	rknzRc8S3KV8+JjMQHL38fSpQ5o1RcZHml5ESq+VpyhFNwoSY+52zPD/SbUHCJnQ9O5wqM
	gxnHI9I7sh6Mba6ACnZ3ZdGyELXZ9/s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787057699;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sse9yBtEbo/7NqJeutKaOvxEj1tFoKQpeGWqXKUduCw=;
	b=YB/h4M2fqnwn1tBw+aIfaLz1WH4RzlDl2PW65e6rvA/8eq2qErCVSkJrYTkh1y6i8Y+LiO
	PV46ota91QuC9xAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EED2E22BA;
	Tue, 18 Aug 2026 12:54:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MslnNyJWhGoaJQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 18 Aug 2026 12:54:58 +0000
Message-ID: <d080cfe3-4f1e-446e-8736-d47a5e8fb27c@suse.de>
Date: Tue, 18 Aug 2026 14:54:39 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf-next 4/4] netfilter: xt_cgroup: use
 pr_info_ratelimited()
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
References: <20260818122741.1329660-1-pablo@netfilter.org>
 <20260818122741.1329660-4-pablo@netfilter.org>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260818122741.1329660-4-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[netfilter.org:email,suse.de:email,suse.de:mid,suse.de:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 3152D84551
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

On 8/18/26 2:27 PM, Pablo Neira Ayuso wrote:
> This seems to be the last xtables extension not using the ratelimited
> version, update it.
> 
> Fixes: c38c4597e4bf ("netfilter: implement xt_cgroup cgroup2 path match")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
For the whole series:

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

Thanks Pablo and Florian. Right getting rid of them makes much more 
sense than fixing the wrong spots.
