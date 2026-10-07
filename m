Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4281738F950
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Oct 2026 12:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791377773; cv=none; b=N6iVtY2+ddF/SpCIkKJ/iQ8O9n3F6tth1gjpYo2pLa7K2SGb1eJv3QRQcnQZ9PDBC9rciBpX+nXt2LQi/usl4t0m+ABwPFsJLTCIFQrzeYPLKv0bzNLhzrNwJlnIJbTi18X2QaID99n4E+m7iXZ+azyMPgoQkqjIUyi6yQjY+Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791377773; c=relaxed/simple;
	bh=llvql1LklDvx1A9e8PIaZCG/Ln8E6u0o1UrXALr3mQE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LuSEFhcDvIWR5DR47G4fwRDcYYkXuMSYTLOGEBD9CcPSieLHpMGs3NdWBmp9PkZCVaFSxey1BNkIfb6wRJhgk69DjEMnxAstWWXD0+3zpp+yKP+0mOF+Ftw2GqK6qZ62iB0AvXLgt91hPpp7XE44QvowIoILe0e8/xJV6F4NhOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=P9KgezAx; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0V6VVqXG; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KuTCoQ5+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=uGtohwUM; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="P9KgezAx";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0V6VVqXG";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KuTCoQ5+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="uGtohwUM"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B9D8321BDE;
	Wed,  7 Oct 2026 12:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791377759; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ejVNQoFIeP/MDLKkcQCKmctUZr0AiZzjSNqTxg7ilps=;
	b=P9KgezAxo0IQpR8in8HQ83Y67bYPjSPvOWaBBeokW7a/ZoTl1hVXaE+F+deXKrOOwGWWus
	WCAf3av+Qxb6V8TUUgYts+OgoMLdCh4qH/JnJ7RicStMMWIrOWFMfGF8xkGggLMSTDZHe0
	9NnvM77VZytkz76mH9XFJ3SuhTivUeo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791377759;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ejVNQoFIeP/MDLKkcQCKmctUZr0AiZzjSNqTxg7ilps=;
	b=0V6VVqXG1cTwH7h+EdUdekC8A1w559R6JzdWENcJk7/ZCur/OatvuYrwv6Ac0cKhwMxTAp
	PQiuG0xDNWTVbbCQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KuTCoQ5+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=uGtohwUM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791377757; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ejVNQoFIeP/MDLKkcQCKmctUZr0AiZzjSNqTxg7ilps=;
	b=KuTCoQ5+6868XOBVo8lU923vxrkolaDpasHz+rOd/j+xCCBY2GBNcbaPEe7ZQAMTPG8soU
	ZKR1Yl9SMnyViUi21lEA+q0hqukIdWiNhe2twmL0Gl0Y4aIo3ss+YnRjSigG7abrPostTv
	UiFEvYs6thkR3k64gjVF9oYz4xpa/SE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791377757;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ejVNQoFIeP/MDLKkcQCKmctUZr0AiZzjSNqTxg7ilps=;
	b=uGtohwUM3b8JqHi1rB0EotBPX5PbAHOsZIjX2NG9SuFEG6acPrA5PubpueMA4XWwAGlRtI
	ErqDvHBCIutcepAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7207C13354;
	Wed,  7 Oct 2026 12:55:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MGmiEF1BxmoDZwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 07 Oct 2026 12:55:57 +0000
Message-ID: <634dbf1c-805d-4542-a90e-4e92dcc8ce50@suse.de>
Date: Wed, 7 Oct 2026 14:55:02 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf-next] selftests: netfilter: fix return value in zone
 subtest
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20261006230459.2139-1-fw@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20261006230459.2139-1-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.50 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.980];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[strlen.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:email,suse.de:dkim];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Score: -4.50
X-Spam-Level: 
X-Rspamd-Queue-Id: B9D8321BDE

On 10/7/26 1:04 AM, Florian Westphal wrote:
> zone subtest prints FAIL, but did not set 'ret=1', so kselftest
> framework reports success.
> 
> While at it, also fail when "nft -f" returns an error.
> 
> Noticed thanks to a (broken) local patch that should have caused this
> selftest (resp. the kselftest framework) to report a failure.
> 
> Fixes: 33b8aad21ac1 ("selftests: netfilter: add a vrf+conntrack testcase")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

Regarding the cleanup commit, we can leave that for the moment we have 
free cycles or for a newbie to take it. I think it would be nice to have 
but not relevant enough for a re-spin.

Thanks Florian!
