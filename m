Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04996342CA1
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Jan 2026 14:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769092593; cv=none; b=omEIvrsynJTws4mBTTSILd6y8Qumo2byLYwvQ7fSABhbJnveZ0a23oxuOwSq79BSR5ulFVTkiCR517/U/p4qGyGTXAnhwH3KrE75lZ5IjSfTZFDIDkNBDmeiAnup2a7kZ9QTb02QpqKDc1yA4mnE117Vs411xmxECugQm8VvlE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769092593; c=relaxed/simple;
	bh=GxEoOBZzlawwuL8s0M2L8HPLzKdWCNFuUIH8asbmshM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gRs3RJd2a5rQJ0Ay+J8B46c33hVhFzL4kBPNlseRV2ysrut47gqfYfKOejmCYJF6XX2VM7GWsjXBXANi+N9lwLVKzivmGNVAtRQLuvJ9GtEp0+1jPbA0vy567HLsui3wAUapfu7EgPK+QHZhqLXC4IynIIuOAKkeMNeVRGtzQQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vLgmORBz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kG1lK8rw; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vLgmORBz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kG1lK8rw; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vLgmORBz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kG1lK8rw";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vLgmORBz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kG1lK8rw"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CAC3D5BCCA;
	Thu, 22 Jan 2026 14:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769092589; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G3mIcepQcGA71yqXDO+8F0WZeg6inefvX21mwTjIGhQ=;
	b=vLgmORBzThpCw+HVQF0GgARKWdkQljGg3Wex69bjiofcEZV0LBiTThFvzjvckqH2h2aG/Y
	eAv5vR5xHzNqlFyRwxpZSzyog+2N8NVm9QxiJc3a9Nc1Vg9TojJcp68iYtWgR84lur9BpV
	QXvU7vOgvOBpOHmkEgcZcWX8wCjGTPQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769092589;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G3mIcepQcGA71yqXDO+8F0WZeg6inefvX21mwTjIGhQ=;
	b=kG1lK8rwo7UCF/AIyO1yjm9+ijKSShf72iLPGofs9qMkeH0RneOLDNDkDv3bR+/PwPOAX4
	sbsVh0WeuaxDbpCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769092589; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G3mIcepQcGA71yqXDO+8F0WZeg6inefvX21mwTjIGhQ=;
	b=vLgmORBzThpCw+HVQF0GgARKWdkQljGg3Wex69bjiofcEZV0LBiTThFvzjvckqH2h2aG/Y
	eAv5vR5xHzNqlFyRwxpZSzyog+2N8NVm9QxiJc3a9Nc1Vg9TojJcp68iYtWgR84lur9BpV
	QXvU7vOgvOBpOHmkEgcZcWX8wCjGTPQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769092589;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G3mIcepQcGA71yqXDO+8F0WZeg6inefvX21mwTjIGhQ=;
	b=kG1lK8rwo7UCF/AIyO1yjm9+ijKSShf72iLPGofs9qMkeH0RneOLDNDkDv3bR+/PwPOAX4
	sbsVh0WeuaxDbpCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6BB9413533;
	Thu, 22 Jan 2026 14:36:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2BYgF+01cmkPLgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 22 Jan 2026 14:36:29 +0000
Message-ID: <54e7d5ac-8cae-4fd7-9440-21ae982b4a22@suse.de>
Date: Thu, 22 Jan 2026 15:36:15 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: FYI: Code coverage of nft test suites
To: Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
 Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org
References: <aXANvUVv8nX-wPeM@orbyte.nwl.cc>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aXANvUVv8nX-wPeM@orbyte.nwl.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,nwl.cc:url,suse.de:mid];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid]
X-Spam-Level: 
X-Spam-Flag: NO

On 1/21/26 12:20 AM, Phil Sutter wrote:
> Hi,
> 
> I recalled there was an effort to increase code coverage of the nft test
> suites so I ran 'make check' in a '--coverage'-enabled build. Here's
> the result for HEAD at commit dda050bd78245 ("doc: clarify JSON rule
> positioning with handle field"):
> 
> http://nwl.cc/~n0-1/nft_testsuites_coverage/index.html
> 
> I plan to pick at least a few low hanging fruits from there, but anyone
> interested is more than welcome to chime in!
> 

Thank you Phil! I would love to.

> Cheers, Phil
> 

