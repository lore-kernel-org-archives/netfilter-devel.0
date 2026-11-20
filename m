Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795173559;
	b=sNtW11oppDzVp4jDv+NQl9LUzx3TCqFn9Zq9y9tInG+0/nomdhVxAhD/QQf0PBYkSCP2
	 uwXT/afb2ng1oQxkZhlmebW0w2nYiIeWiwTPF76e3tJOtFe/46yr5anoyk3P6Bslf9E3M
	 kLT+sMCytnp5Kfo5h/uZKv/P3DXlMBs6wskgRvPHsjVBBE1YrTphf2xINfCGjpJEvyeEz
	 zo1pfv844qG78jl55yKwROpHe8ZDaU96uC6yXoLs12AX67tADbe+2MOGcdptipCSBIqP/
	 HuBft3pRsyg6A8ve8UYnDOEj0YoCyiR7L1pcWUBBWpDqqwDO+u6MmI2NmiAT1CKYSXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795173559;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:
	 X-Spam-Level:X-Spam-Flag;
	bh=I8GhJnpKnYfJgSMigvxn0tzrVe47bEBLTm791b8puxo=;
	b=kEB1of75jXvBzvV74ulnUbYetwValCi+qW+VsumA+ZG9ox40Abz2PZYg2hRZam/SVr9V
	 VmtgO33HSIVW+eTeoc7Q7lqOmmENHKZKX7dwOMfbgIt8PS9apHxVTqXm0+DZpJTYx2jYk
	 UHnoTewpqz89tMSrqAFSFjEVkdcwiHclHsls3ZISXZBwbE1dQ0dYEvdue9qODXsk8lAsR
	 VJE6c5SAuZRhNqhJACtKxcg8gf+OcwICyg5qSMmhjnRzKoA7wwhyRXHc+2oy58pk40BRV
	 BOesJbrw37GBDbBdWz7YioFusEYlEnY6tQDHPJcPw8ASibZO+DROCkppgEBZqKjIFGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=gnnpH+uJ;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=QxV7G8eT;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=gnnpH+uJ;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=QxV7G8eT;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF20606A333
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2026 11:19:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6DF20606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=gnnpH+uJ;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=QxV7G8eT;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=gnnpH+uJ;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=QxV7G8eT
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B073B224FF;
	Fri, 20 Nov 2026 11:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795173556; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I8GhJnpKnYfJgSMigvxn0tzrVe47bEBLTm791b8puxo=;
	b=gnnpH+uJOXVAICz1FuL7VxrEIlnbTy1B41fQVR0oyN6xxTM356FAPy0QBwBCjwqiG9ONvg
	tfRH8bkZX8ioq8ZZ36FwFxAfK5opqdkbt3OzmqDJNKw6fUvIk3zdCClqA6l4zo7d/+VGJ8
	ZgtDfe+CqwNRMJe+sGqQEw7FsaeXkXw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795173556;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I8GhJnpKnYfJgSMigvxn0tzrVe47bEBLTm791b8puxo=;
	b=QxV7G8eTm0ISY0HkcSGkjixv40fRPOIG8UAjCkz9iXFnxBWdRPcNmN+1ERt2uQSzUUQNId
	Y3t0StLBen30ECCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795173556; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I8GhJnpKnYfJgSMigvxn0tzrVe47bEBLTm791b8puxo=;
	b=gnnpH+uJOXVAICz1FuL7VxrEIlnbTy1B41fQVR0oyN6xxTM356FAPy0QBwBCjwqiG9ONvg
	tfRH8bkZX8ioq8ZZ36FwFxAfK5opqdkbt3OzmqDJNKw6fUvIk3zdCClqA6l4zo7d/+VGJ8
	ZgtDfe+CqwNRMJe+sGqQEw7FsaeXkXw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795173556;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I8GhJnpKnYfJgSMigvxn0tzrVe47bEBLTm791b8puxo=;
	b=QxV7G8eTm0ISY0HkcSGkjixv40fRPOIG8UAjCkz9iXFnxBWdRPcNmN+1ERt2uQSzUUQNId
	Y3t0StLBen30ECCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5E0C41342D;
	Fri, 20 Nov 2026 11:19:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3gKpC7QsAGsvaQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 20 Nov 2026 11:19:16 +0000
Message-ID: <1a37d867-cb36-4f9f-9b60-9f5dc3055d45@suse.de>
Date: Fri, 20 Nov 2026 12:19:15 +0100
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
Subject: Re: [PATCH nf,v5] netfilter: nf_reject_ipv6: fix locally generated
 packet to local address
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
References: <20261117221509.3108808-1-pablo@netfilter.org>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20261117221509.3108808-1-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-13.28 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-0.99)[-0.987];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email]
X-Spam-Score: -13.28
X-Spam-Level: 
X-Spam-Flag: NO

On 11/17/26 11:15 PM, Pablo Neira Ayuso wrote:
> Fix reject expression in inet/ingress for locally generated IPv6 packets
> that are sent to a local address on ethX arrives through lo, really
> perform the similar handling as ip6_rcv_core().
> 
> Reported by sashiko.
> 
> Fixes: 73a73d442f99 ("netfilter: nf_reject: initialize IPCB at inet ingress")
> Tested-by: Fernando Fernandez Mancera <fmancera@suse.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

Thanks Pablo!
