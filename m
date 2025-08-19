Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C312C181
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Aug 2025 15:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755619079; cv=none; b=IqUl19iFcIpADAY4ZFZ8qCXGY3hUlcl8dF3WMJJbk//m2ZwAyBlknIQRsLcAIEIv5DCysAIjzNVzxSiXMF6CitXKitRp2vYe29VJFFjI6cpLRx6Y1gE6zZteMfSbX9BDUE86Gs0UZtPx6iEkBWkm5Bfpk8G6NM/lETzTTlsHrZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755619079; c=relaxed/simple;
	bh=AbFxkZ80Q1aC8vTxvSAjWID3IciTsiIZ2Hes1rPJsvo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WZlrNMkXwCPH9LFtd8jSMI3alC5RFH2YBLAUuSC1fe2w5IOTZaBq81UnGeQCjqxu8b2f0oZkY57QcnGd3RVY95py3hpZBq1BYBXeOKNfNw+uema+SLKt1eibq0PMlnz4ma8TpGar4AX8O7j5YNxwieUg+8gEAn808fc5CSVoUEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tfVZnoSq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BIzXZaFm; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tfVZnoSq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BIzXZaFm; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tfVZnoSq";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BIzXZaFm";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tfVZnoSq";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BIzXZaFm"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 312A5211D3;
	Tue, 19 Aug 2025 15:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755619076; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B7HBaTgakamglFMjV9xzU67TDRzIGA8XbYDXB/tVqXc=;
	b=tfVZnoSqIyPMwHsxXl4Ov1kq9y0bU22jgH1ka8qrlxpliBMyKf6f78qAckSUAAHNr5uva9
	NxAlP03e2X6ifPlw3qy/B8gD7YhLs9jGmdaP4DT5z3iA429ZSbK1+T9mSX/4Zi1yAWTXMX
	9+p9jeYfJ4xPlLgF4JzrqtXQyOVcy7s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755619076;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B7HBaTgakamglFMjV9xzU67TDRzIGA8XbYDXB/tVqXc=;
	b=BIzXZaFmJae7OCVORi0Xg7dFn1lcVn/3nIhsSTCv7/7bglO7FRgv4b5u0QFy9vCXDE+I9V
	7nAqpdxVVzhgUdCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tfVZnoSq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=BIzXZaFm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755619076; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B7HBaTgakamglFMjV9xzU67TDRzIGA8XbYDXB/tVqXc=;
	b=tfVZnoSqIyPMwHsxXl4Ov1kq9y0bU22jgH1ka8qrlxpliBMyKf6f78qAckSUAAHNr5uva9
	NxAlP03e2X6ifPlw3qy/B8gD7YhLs9jGmdaP4DT5z3iA429ZSbK1+T9mSX/4Zi1yAWTXMX
	9+p9jeYfJ4xPlLgF4JzrqtXQyOVcy7s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755619076;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B7HBaTgakamglFMjV9xzU67TDRzIGA8XbYDXB/tVqXc=;
	b=BIzXZaFmJae7OCVORi0Xg7dFn1lcVn/3nIhsSTCv7/7bglO7FRgv4b5u0QFy9vCXDE+I9V
	7nAqpdxVVzhgUdCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E195313686;
	Tue, 19 Aug 2025 15:57:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WoAINAOfpGgNZAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 19 Aug 2025 15:57:55 +0000
Message-ID: <bdddcdd0-e8d8-4c8c-96e0-c18878e348ca@suse.de>
Date: Tue, 19 Aug 2025 17:57:55 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7 nft v2] src: add tunnel template support
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, fw@strlen.de
References: <20250814110450.5434-1-fmancera@suse.de>
 <aKRybNzVyFOC7oCB@calendula>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aKRybNzVyFOC7oCB@calendula>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 312A5211D3
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -4.51



On 8/19/25 2:47 PM, Pablo Neira Ayuso wrote:
> Hi,
> 
> I made a changes to this series and push it out to the 'tunnel' branch
> under the nftables tree.
> 
> I added IPv6 support to this 1/7 patch.
> 
> However:
> 
> [PATCH 6/7] tunnel: add tunnel object and statement json support
> 
> still needs to be adjusted to also support IPv6.
> 
> I can see JSON representation uses "src" and "dst" as keys.
> 
> It is better to have keys that uniquely identify the datatype, I would
> suggest:
> 
> "ip saddr"
> "ip6 saddr"
> 
> (similar to ct expression)
> 
> or
> 
> "src-ipv4"
> "src-ipv6"
> 

Hi Pablo,

I would prefer the latter options "src-ipv4" and "src-ipv6" mainly 
because adding spaces to keys in a JSON should be avoided.

I am sending a v3 with the requested changes, thank you!

> else, anything you consider better for this.
> 
> I think this is the only remaining issue in this series IMO.
> 
> If you follow up, patch based your work on the two branches that I
> have pushed out for libnftnl and nftables.
> 
> Thanks.

