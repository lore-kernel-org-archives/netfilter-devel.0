Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A183B30CDBD
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Oct 2025 11:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759403056; cv=none; b=EO/Gr46B0XFg5OqIFfl3MHIu+YQfzqsHB5tp6jdpp2AkAtecVc+/omva0uPHpbjXWXFoF1WiBApa+ZMBrVoo5T1WLN5QiA3LZgbYtzd95WLHnr80OLaOvSYrT7aPK+4ILDNCAkaoAtNjqsPnfzNk3FB/a5SuN2KyQZOzGdf8zn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759403056; c=relaxed/simple;
	bh=Qaa1AymTCUhemI/cxPY3cNYfmqs01GfeyGDpkPqtgoo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lEWAjAZVY6nmG4yHmcwA8zcroG4R/vI0/tDJrff0hBQRYFuDEO09VLQlaPogNsRAWtEajptnQBzfJDEeIGvg/FIktgewGIBBq1nAnHe7c20r72WgozFORar0jY0HywuyD/Mxdzp05poIbxjTWIyq9nHQ7zv0UBqKCIIR6vUI0Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IVpv5383; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JBhYhGuk; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IVpv5383; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JBhYhGuk; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IVpv5383";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JBhYhGuk";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IVpv5383";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JBhYhGuk"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6487C337EA;
	Thu,  2 Oct 2025 11:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759403052; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1qDNyLiaYpZ7hGwz7pVLY0Z5gLc726hBV4XVNB6Jxqc=;
	b=IVpv5383qK1ImJkgpg0LGDlKxhQrOsdhjkYEIb3Bfze2LDZeVJaCZUkF4BXLoIQxu3+pXx
	yff0nDPmpothmAyMtxRmozvALOEondYxePBZu1PiKczlNhhzyKk1H0fYemsD24t9MLw39R
	+NT0Qth/hGOUjNGMhQcHwTLvtNCNc5Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759403052;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1qDNyLiaYpZ7hGwz7pVLY0Z5gLc726hBV4XVNB6Jxqc=;
	b=JBhYhGukuKalTt/E4EohJWpf88w65kHOho4gXAFJZj+uSZYJCOaOetZXk81lxv/f1nq+ZT
	l5vQqM1m015e+/AQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759403052; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1qDNyLiaYpZ7hGwz7pVLY0Z5gLc726hBV4XVNB6Jxqc=;
	b=IVpv5383qK1ImJkgpg0LGDlKxhQrOsdhjkYEIb3Bfze2LDZeVJaCZUkF4BXLoIQxu3+pXx
	yff0nDPmpothmAyMtxRmozvALOEondYxePBZu1PiKczlNhhzyKk1H0fYemsD24t9MLw39R
	+NT0Qth/hGOUjNGMhQcHwTLvtNCNc5Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759403052;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1qDNyLiaYpZ7hGwz7pVLY0Z5gLc726hBV4XVNB6Jxqc=;
	b=JBhYhGukuKalTt/E4EohJWpf88w65kHOho4gXAFJZj+uSZYJCOaOetZXk81lxv/f1nq+ZT
	l5vQqM1m015e+/AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1F36D13990;
	Thu,  2 Oct 2025 11:04:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uFh/BCxc3mi6DAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 02 Oct 2025 11:04:12 +0000
Message-ID: <0adc0cbc-bf68-4b6a-a91a-6ec06af46c2e@suse.de>
Date: Thu, 2 Oct 2025 13:03:59 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] netfilter: nfnetlink: always ACK batch end if requested
To: Nikolaos Gkarlis <nickgarlis@gmail.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de
References: <20251001211503.2120993-1-nickgarlis@gmail.com>
 <4814384f-5fe2-491d-9424-7a0aebbbda1d@suse.de>
 <CA+jwDRkBHxwz7xHUAdYi1OZ9mtEski4VJ=gtyByritjRAiStmQ@mail.gmail.com>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <CA+jwDRkBHxwz7xHUAdYi1OZ9mtEski4VJ=gtyByritjRAiStmQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.30



On 10/2/25 12:41 PM, Nikolaos Gkarlis wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> 
>> e.g for a batch formatted like (BATCH_BEGIN|NFT_MSG_NEWRULE + NLM_F_ACK)
>> - nfnetlink would send two ACKs while it should be only one. Granted it
>> won't configure anything but it would be still misleading.
>>
>> What about this?
>>
> 
> Thanks ! I was a bit unsure on whether the status should also be checked.
> This seems to work with my test.

Just a nit, the commit should also have a Fixes tag IMHO.

Fixes: bf2ac490d28c ("netfilter: nfnetlink: Handle ACK flags for batch 
messages")

Thanks!

