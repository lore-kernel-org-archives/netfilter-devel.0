Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C65C1FDE14
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Oct 2025 23:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760658273; cv=none; b=MWGTumF2LdQN8kjsKNRia/Dx6vc6PlsaG9gGHJCc/FBMcGycG/zkxDWY375pV/Z/gpOq2BMrJPSD6xh0xk0GxJiczYz5ST2SLHUCxrlBk/sNkn6wtLwD5HRKEopHs6OECCNYDD70FiYgfd+vU9i5Dj1Ij3HAjd9Uy/4lO+v7LNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760658273; c=relaxed/simple;
	bh=jqz1chttL5qxB1h+yQwD4NLwnJTfsafq9zFbcQhDwr0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=oI4IAik9IkTsKLJfRRjzqgulmlH07y/vCKMtzLC8AQ83psdEJhBzTn+IGZ7Phr8L0PFRfrFdFtK3P9ABqPnOiaRf5oZmxog6qe5uSgWhv95f8lXGq/93cVmRXIi6M1knhPnQCnEJVBPJaGrMQ6d9phWVdObqjRufm7bDjOGnSYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=od2QZaj3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JNOXQr1l; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=od2QZaj3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JNOXQr1l; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="od2QZaj3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JNOXQr1l";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="od2QZaj3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JNOXQr1l"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 86B8321B1D;
	Thu, 16 Oct 2025 23:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760658269; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F6CylcvY0HeBW7/BejaWFmyQFJTQhQYzYwVVZ/mAzC8=;
	b=od2QZaj3T+SJnsQ61uuElZ8SL2FQNUX5xdOpG2ZgHMmA9N9zSvutOGUva6RpEVbHzwh8Ac
	PgyAe0yzZhs4bWptrqIPVPv/H8bFUzWDN2FAKKPXYjwsmRY3C7q+aCAvKqP9ZPxZtIZz7N
	i/IpTZyBwFp0Q2Q5qKYfWeaYFe+Mpxs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760658269;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F6CylcvY0HeBW7/BejaWFmyQFJTQhQYzYwVVZ/mAzC8=;
	b=JNOXQr1lMYf9wYhneQoFFrwkk1AizGAAn5iZtdyCFAgspXzjOi3uoswiVuFaLDe5/eUCT8
	M7okRZsPFQvH2SAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760658269; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F6CylcvY0HeBW7/BejaWFmyQFJTQhQYzYwVVZ/mAzC8=;
	b=od2QZaj3T+SJnsQ61uuElZ8SL2FQNUX5xdOpG2ZgHMmA9N9zSvutOGUva6RpEVbHzwh8Ac
	PgyAe0yzZhs4bWptrqIPVPv/H8bFUzWDN2FAKKPXYjwsmRY3C7q+aCAvKqP9ZPxZtIZz7N
	i/IpTZyBwFp0Q2Q5qKYfWeaYFe+Mpxs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760658269;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F6CylcvY0HeBW7/BejaWFmyQFJTQhQYzYwVVZ/mAzC8=;
	b=JNOXQr1lMYf9wYhneQoFFrwkk1AizGAAn5iZtdyCFAgspXzjOi3uoswiVuFaLDe5/eUCT8
	M7okRZsPFQvH2SAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5B5EF1340C;
	Thu, 16 Oct 2025 23:44:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AzIwE12D8Wi6DgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 16 Oct 2025 23:44:29 +0000
Message-ID: <e253bbfd-40a4-4ae4-ba97-96c86464a6ac@suse.de>
Date: Fri, 17 Oct 2025 01:44:24 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nft 4/4] evaluate: reject tunnel section if another one is
 already present
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20251016145955.7785-1-fw@strlen.de>
 <20251016145955.7785-5-fw@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20251016145955.7785-5-fw@strlen.de>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 



On 10/16/25 4:59 PM, Florian Westphal wrote:
> Included bogon causes a crash because the list head isn't initialised
> due to tunnel->type == VXLAN.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>   src/parser_bison.y                            | 38 ++++++++++++++++---
>   .../bogons/nft-f/tunnel_in_tunnel_crash       | 10 +++++
>   2 files changed, 42 insertions(+), 6 deletions(-)
>   create mode 100644 tests/shell/testcases/bogons/nft-f/tunnel_in_tunnel_crash

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
