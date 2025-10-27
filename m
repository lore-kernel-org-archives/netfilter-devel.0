Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FB6277035
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Oct 2025 13:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761573304; cv=none; b=NhvXhXSbe6HtO2yXXZcyQpUsShHPRQrMmvMsDtOm/ztFERpfXMgB4FIYW66tqcX5Npin+gtt35iOak/iNzQXceCRWfMFDC1v/P3j4UHjIGNlVdkECnpF3wnOyZ7z0IV7IZoNcwvCKMMJNPehaA4g5795xmaTyy9BGVAgBe2jxKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761573304; c=relaxed/simple;
	bh=3611W0djDgwqpDfgQLKkj9s8Ep28+K5Y6T3iFbsp7M4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rbPOOScXOQPRZtnPse1NCtiZQYkwfnnfu89SycYuVd0oVk34FrEfrsBlqUwYbOESfRxpvmYEQRvY0PFd6h8aOEHVYnB04vvMDk2XRWQsmGGPBBihE2BYIAy7zJukCAgBJfU9stqGSGZn5ujAR2gaUXgj/TNdcM1y5M9ye99Ju6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vl3v9jOb; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YYm5Yemv; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vl3v9jOb; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YYm5Yemv; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vl3v9jOb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YYm5Yemv";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vl3v9jOb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YYm5Yemv"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 271ED21B06;
	Mon, 27 Oct 2025 13:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761573301; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5pU8ZxOe95VTeaROF8GsNZS3GwzHwLG/ZLt3xP5DZUQ=;
	b=vl3v9jOba+1HU9yzeHgsc3nDiAn9YrvbUmTqNJ8FXhvuCdE1xAy4zhQWGMOQLgz/ePsUlT
	aMbd+0533L9F5IsofBHvaCRovM4IWlRXsbnQRKmaf7TyixKoUU4KJWSY5DzHi6vEV0siNn
	1CF+Ga7eFxij/DrCZaHNudL42KW2Lsk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761573301;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5pU8ZxOe95VTeaROF8GsNZS3GwzHwLG/ZLt3xP5DZUQ=;
	b=YYm5Yemvq7Gz1ZQDwCpbkB31Q38SdOkfISoIfC91OVq2MaRFyl47PPuzhC3MZzKpk6m64H
	q8WQD3Q1ghchriCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vl3v9jOb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YYm5Yemv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761573301; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5pU8ZxOe95VTeaROF8GsNZS3GwzHwLG/ZLt3xP5DZUQ=;
	b=vl3v9jOba+1HU9yzeHgsc3nDiAn9YrvbUmTqNJ8FXhvuCdE1xAy4zhQWGMOQLgz/ePsUlT
	aMbd+0533L9F5IsofBHvaCRovM4IWlRXsbnQRKmaf7TyixKoUU4KJWSY5DzHi6vEV0siNn
	1CF+Ga7eFxij/DrCZaHNudL42KW2Lsk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761573301;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5pU8ZxOe95VTeaROF8GsNZS3GwzHwLG/ZLt3xP5DZUQ=;
	b=YYm5Yemvq7Gz1ZQDwCpbkB31Q38SdOkfISoIfC91OVq2MaRFyl47PPuzhC3MZzKpk6m64H
	q8WQD3Q1ghchriCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D770A136CF;
	Mon, 27 Oct 2025 13:55:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sMekMbR5/2i0awAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 27 Oct 2025 13:55:00 +0000
Message-ID: <4731d1d2-d11d-4802-a7f5-69cc75a0af90@suse.de>
Date: Mon, 27 Oct 2025 14:54:49 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf] netfilter: nft_connlimit: fix duplicated tracking of a
 connection
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 louis.t42@caramail.com
References: <20251027125730.3864-1-fmancera@suse.de>
 <aP94A1HduHkJudgg@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aP94A1HduHkJudgg@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 271ED21B06
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_ENVRCPT(0.00)[caramail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[vger.kernel.org,netfilter.org,caramail.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MID_RHS_MATCH_FROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email]
X-Spam-Score: -4.51



On 10/27/25 2:47 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> Connlimit expression can be used for all kind of packets and not only
>> for packets with connection state new. See this ruleset as example:
>>
>> table ip filter {
>>          chain input {
>>                  type filter hook input priority filter; policy accept;
>>                  tcp dport 22 ct count over 4 counter
>>          }
>> }
> 
> Right.  Would you mind sending a patch for nftables documentation to
> recommend combining this with ct state new or similar?
> 

Sure, this also requires a documentation fix on the nftables wiki [1] 
but I believe I do not have an account. How could create one for me? :)

[1] https://wiki.nftables.org/wiki-nftables/index.php/Connlimits

Thanks,
Fernando.

