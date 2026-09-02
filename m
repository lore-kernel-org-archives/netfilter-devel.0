Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229DE4A5EC1;
	Wed,  2 Sep 2026 15:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788361842; cv=none; b=C++Aw8VG1S2Zdm3BZaNLJ85/TRfXwkX2wRQIkVG/ZRvHsCXxWlO5mopLw/Xvxdv+wTnKZxvcIGW7jc6tksZe48MEPI+AMITVNxQ7iJrd/T7sizYuHWW8DHlxqQmQAExcWgFd8j17AH9ZNZeupcBfPgjFV0if4J/DcJ5IeV6BCKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788361842; c=relaxed/simple;
	bh=Xvl4SAQAQi/bcbCYEMDQY86QSTRpx+sWCLl/x4a/K64=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JED/4R9L0DVVjqX6PEuII90xppP8hXMuKXrL5NBQ3rWqyFGPQZ2fLnzW7SpmAXj9S8GpsaFbFVw068G+392PRY9iGAhToxi3A3sZREpifktQuycEWuKYZ5iROoea47uUz5kF2+a0lIh6B7r74ktno+WUj/0eMOwEaLEy2/HCEHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=QKLG7dgJ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=KVgX4IuD; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=NlgUfui3; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=40xxeeO4; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="QKLG7dgJ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="KVgX4IuD";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="NlgUfui3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="40xxeeO4"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 690B421D8C;
	Wed,  2 Sep 2026 15:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788361826; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NXuTO/aRy+5tUbOd5WS437MFkwe/A7P2Rhax9UnUhlc=;
	b=QKLG7dgJtqP711pVhXLtW50gKUk81yoJYBe86IIOsuxEXxpnq5EjyufyxFymte1i3gG3nF
	D89nKpjbrUbeQ7Dqwti3ZkSJozHbwxUCtu1kQ+Eu5Vvak/T5Bwk1Vo5vVaYvMTWsk29dNq
	WKFQMIWTIjwuGHUJ81yMtCv3lvsyYuQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788361826;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NXuTO/aRy+5tUbOd5WS437MFkwe/A7P2Rhax9UnUhlc=;
	b=KVgX4IuDgdHvOOL53DxYAaDIZAZqfWxDwP4wEAn5EQHsM2okr4FgBU8FDNem+2CXTSftpV
	h5sVZxUKbbCtFPBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NlgUfui3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=40xxeeO4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788361822; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NXuTO/aRy+5tUbOd5WS437MFkwe/A7P2Rhax9UnUhlc=;
	b=NlgUfui3HDWWedCk5YjuazT/t0FPx2Ed8TqCHCMn++8cgfQzihY5XGhr4AdILAzYKEYsoL
	DEqvoKwLn8QU5StrwYUA57l8n2s/C9oBde/2rxLbVzVHqBdXJlURELpoPec8edeEyIs93n
	aNpZCqbLebXLcdYEnjU8iO643R4MsiQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788361822;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NXuTO/aRy+5tUbOd5WS437MFkwe/A7P2Rhax9UnUhlc=;
	b=40xxeeO4008mvTY3CDPotV/JlfVFgNGHcJbZrW1fqxT+e/AHUQ8e1dfT8/94LrmyWf0xTb
	Zp3mWb+3UIsFQIAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4928613515;
	Wed,  2 Sep 2026 15:10:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SirXEV48mGrdQAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 02 Sep 2026 15:10:22 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D6F5BA13B5; Wed, 02 Sep 2026 17:10:17 +0200 (CEST)
Date: Wed, 2 Sep 2026 17:10:17 +0200
From: Jan Kara <jack@suse.cz>
To: Yuan Tan <yuantan098@gmail.com>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, workflows@vger.kernel.org, frankw@nebusec.ai, jhs@mojatatu.com, 
	ksummit@lists.linux.dev, kuba@kernel.org, pabeni@redhat.com, kerneljasonxing@gmail.com, 
	roman.gushchin@linux.dev, jgg@nvidia.com, mchehab+huawei@kernel.org, 
	torvalds@linux-foundation.org, ben.copeland@linaro.org, gregkh@linuxfoundation.org
Subject: Re: [ANNOUNCE] A Syzbot-style Platform for Verifying and Fixing
 LLM-reported Bugs
Message-ID: <f73vtlhwpdgrt5klkk2cgxfuqsvwvvlhzti4nu7hgdevwbqhvt@g2udlammqolb>
References: <20260830115546.3942129-1-yuantan098@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260830115546.3942129-1-yuantan098@gmail.com>
X-Spam-Score: -2.51
X-Rspamd-Queue-Id: 690B421D8C
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmail.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[huawei];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,nebusec.ai,mojatatu.com,lists.linux.dev,kernel.org,redhat.com,gmail.com,linux.dev,nvidia.com,linux-foundation.org,linaro.org,linuxfoundation.org];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nebusec.ai:url,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email]
X-Spam-Flag: NO

Hi,

On Sun 30-08-26 04:55:45, Yuan Tan wrote:
> A month ago, I posted an RFC[1] to the mailing list proposing an automated
> platform that validates AI-reported bugs and prepares draft fixes, and
> later discussed the idea at the Netdev conference. After further
> development, it is finally ready.
> 
> While preparing to send this email, I noticed that Roman has since started
> a related discussion:
> [MAINTAINERS SUMMIT] The place of AI code review in the Linux Kernel process
> 
> It turns out this platform already addresses several of the needs raised
> there.
> 
> The platform is available at:
> https://bugtracker.nebusec.ai
> 
> It is currently hosted under my company's domain for convenience. I would
> prefer to move it to a neutral, community-oriented domain once the project
> name is settled.
> Access is currently restricted to maintainers whose email addresses are
> listed in the Linux kernel MAINTAINERS file.
> For now, only bug reports from the net subsystem have been fully imported
> and processed.

I was playing with this for a while and this looks useful. Some notes I have:

1) When you download the patch, it has 'From' field set to some value (I've
actually seen different values in different patches). Perhaps it would make
sense to automatically set From to the person downloading the patch (or
maybe value configured in user's profile)?

2) Based on current state of the kernel doc, the patches should contain
"Assisted-by: LLM" tag although I understand that might be controversial.

3) It would be nice if you could "assign" the report to yourself - i.e.,
you've decided to handle this and don't want co-maintainers to waste time
on it anymore.

Thanks for putting together the service.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
