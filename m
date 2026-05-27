Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F417C357CFE
	for <netfilter-devel@vger.kernel.org>; Wed, 27 May 2026 10:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779879364; cv=none; b=JMojP6ohHOVVDI+MjW/DwwXyXqU4Nw+Pxui2LQZ+92x0bjIv3Dgxbp0INzOrgK5omUGMsBzuvcZ27xaKNK6rJZC5DLRsd5OxVzG9qLLBq3gwICS+Qqgv4ho19JekqdkIFaa/805IdwDjdaAefPe84D6bytXMwpYre9pA5F19Ltw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779879364; c=relaxed/simple;
	bh=YT5YbCsXLj8uN9w4ODQTQUJ/nd7I51TcvTEFO620NpM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=i2t95ry1gpkgSf7+O7HgvYCaQjK52gySgaO5CL0Fyn53rOi6+8HCaIwacWwxsuMjMNUQAG7bhBlmqh8deXlnV7H4mCcD7WIAFHYdEsvh0djTvpNfRTMAGdqnUthOVn1qAe7NzFI/StXFKlN1ay/9OS0ibSqtc8db00bWpnQc7/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=U7rxXDrq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=uZuo2cn7; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=U7rxXDrq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=uZuo2cn7; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="U7rxXDrq";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="uZuo2cn7";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="U7rxXDrq";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="uZuo2cn7"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2C43C6AEBB;
	Wed, 27 May 2026 10:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779879361; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z32WRtnxGuQQuiKMS0kEmgvbah7w9beAbQeqvu7U8i0=;
	b=U7rxXDrqRA+9xgCzNF6fw7wP+0oYkgU9jarGKNuOO98PAIGZU00YWKAeOBEVJWG1+1pXf/
	9ip1B4/HKtHknDpVYsgZ6G7rYMQIcmsm7/TU0Qf8/GTxTPihnDGiXSmchpnhuLVBkqc0cm
	xY8f941kloHy0m6er0Bl0t1Fb3yXdOI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779879361;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z32WRtnxGuQQuiKMS0kEmgvbah7w9beAbQeqvu7U8i0=;
	b=uZuo2cn7y0iNtdKaJhM7h3+Zo9tL+kEacXE7t5hTSBRjnvljGpV/IbPmNPWfs6sqAPvhpG
	7dKwc/zAkPFvsdBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=U7rxXDrq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=uZuo2cn7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779879361; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z32WRtnxGuQQuiKMS0kEmgvbah7w9beAbQeqvu7U8i0=;
	b=U7rxXDrqRA+9xgCzNF6fw7wP+0oYkgU9jarGKNuOO98PAIGZU00YWKAeOBEVJWG1+1pXf/
	9ip1B4/HKtHknDpVYsgZ6G7rYMQIcmsm7/TU0Qf8/GTxTPihnDGiXSmchpnhuLVBkqc0cm
	xY8f941kloHy0m6er0Bl0t1Fb3yXdOI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779879361;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z32WRtnxGuQQuiKMS0kEmgvbah7w9beAbQeqvu7U8i0=;
	b=uZuo2cn7y0iNtdKaJhM7h3+Zo9tL+kEacXE7t5hTSBRjnvljGpV/IbPmNPWfs6sqAPvhpG
	7dKwc/zAkPFvsdBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 02DE25A7C2;
	Wed, 27 May 2026 10:56:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id z4tfOcDNFmqfCQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 27 May 2026 10:56:00 +0000
Message-ID: <9250ac93-a4d6-4243-826d-e95a825bbd03@suse.de>
Date: Wed, 27 May 2026 12:55:51 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf] netfilter: conntrack_irc: fix possible out-of-bounds
 read
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20260527102022.9977-1-fw@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260527102022.9977-1-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 2C43C6AEBB
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:dkim,suse.de:mid,sashiko.dev:url];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51

On 5/27/26 12:20 PM, Florian Westphal wrote:
> When parsing fails after we've matched the command string we
> should bail out instead of trying to match a different command.
> 
> This helper should be deprecated, given prevalence of TLS I doubt it has
> any relevance in 2026.
> 
> Fixes: 869f37d8e48f ("[NETFILTER]: nf_conntrack/nf_nat: add IRC helper port")
> Closes: https://sashiko.dev/#/patchset/20260525182924.28456-1-fw%40strlen.de
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
