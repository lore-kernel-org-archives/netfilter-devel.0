Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837BD3F787F;
	Tue, 11 Aug 2026 16:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786466493; cv=none; b=L5gDs6qzFLWcP/4HC3amsfYuyBiZaQCL8A5j2lM8LzQzS5dIECA4Lz3g9CCFb9VayWVHT1tK1eGM5I6/PVB+oWZgKmahNhkYDPjbDuo/CcsxxLZR9K3qHK9L7zmHJUoCEytYQ5WqYZmOVjqyZ8MnQIKSxHBy8qhxaDervF5gi7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786466493; c=relaxed/simple;
	bh=ATr/ujTdsabhhEacZJ2NYArktC3CJSEQUb78gJcpe0E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DInBo5icvtf/kNmYUaeVLquc5SXRSTTKd8nsmcwrat8Nyorc+L6l8an659gc4RyhBjxaxSBLfWkp0jgZZENZRyyI81rHEHoQPKpZv51z5lSZe3zSOcfE4R5jSo1Boyp87NQSW21QYVfKHKgOal+VgK2Nk9ZBCgGhV/l+9mGoDjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=pblg7yKG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=m20nPUJ9; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=YRc9ObKI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=09I9e/cA; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="pblg7yKG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="m20nPUJ9";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="YRc9ObKI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="09I9e/cA"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F376E3E48;
	Tue, 11 Aug 2026 16:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786466454; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X/f2xV9/IfAEzJtWxzyVFu6EZLI17I2eiyzMHFuhpug=;
	b=pblg7yKGhhLz9BAVGAB65h6qYeD3Y+4S7pX7Q84CgS0ZkRFGi/A3yWsRiVR/AmCIqGTOa3
	9VAsRhEv2jlSSxUcuuWA8QIQBLhd+YbuNsT67xlsntN1pfhRh5pSvyo5s6efdJ2ZeQqlw8
	ySu8dYiiS6W5bxYaU1u6oeBWMoiDTP8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786466454;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X/f2xV9/IfAEzJtWxzyVFu6EZLI17I2eiyzMHFuhpug=;
	b=m20nPUJ9dhGMMQVKmIUv/n8QrPm04z82Z8lHPfYNb3jJIeIUR5nP+RvWSrzBgYlh30Ni5h
	7pq6A6WAoZK1PbAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YRc9ObKI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="09I9e/cA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786466449; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X/f2xV9/IfAEzJtWxzyVFu6EZLI17I2eiyzMHFuhpug=;
	b=YRc9ObKIds0C/oybpj2h6keVIb98HpTf3Nbx15bIl96dcTM7psyzDBVpOPTI/cyQ18sCpJ
	l+YWZ/cKf9HFRY/v24SeaDDr7edYVKmXossUQ2auyFh6UPK7YlEe/Lw9TGyz4zgq8vvd71
	YgJy9r0iOLWLyxztwpOuCkC2x6jXrG8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786466449;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X/f2xV9/IfAEzJtWxzyVFu6EZLI17I2eiyzMHFuhpug=;
	b=09I9e/cA+O02lG5F8/39T2khg7vGn3sOTCRXVdph2I+TIbGbdHTwQsYZhzckCiCZU4/1wJ
	laBLXQ9CrIofzNCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 97DA0779B2;
	Tue, 11 Aug 2026 16:40:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5dVHIpFQe2rPJQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 11 Aug 2026 16:40:49 +0000
Message-ID: <f6b53cdc-568b-41c7-b4be-84028543f507@suse.de>
Date: Tue, 11 Aug 2026 18:40:16 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [nf_tables] netdev chain: DELCHAIN with an exact device name
 matches a prefix hook and deletes the chain
To: Wei Fang <void0red@gmail.com>, pablo@netfilter.org
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
 k.chen@smail.nju.edu.cn
References: <CANE+tVrDeNCHQVmsqkV2ozeBqyE3GtRDMhZgsg1bhw10yGNTRQ@mail.gmail.com>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <CANE+tVrDeNCHQVmsqkV2ozeBqyE3GtRDMhZgsg1bhw10yGNTRQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_TO(0.00)[gmail.com,netfilter.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Queue-Id: F376E3E48
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

On 8/11/26 12:29 PM, Wei Fang wrote:
> Hi netfilter-devel,
> 
> The following nf_tables issue was found by metamorphic testing on
> linux-next 7.2.0-rc6-next-20260803 (x86_64) and reproduced on four
> independent VMs.  The reproducer is a single self-contained C program
> that uses only the raw netlink API (no nft CLI involved).
> 
> This report is about netdev-chain device matching: a chain hooked
> via the device prefix "vbug" can be deleted by a DELCHAIN request
> that names the exact device "vbug0", even though that device is not
> a member of the prefix hook.
> 
> Problem
> -------
> A chain hooked via the device prefix vbug (covering vbug0 and
> vbug1) can be deleted by specifying the exact name vbug0 in the
> DELCHAIN request - a device that is not a member of the prefix hook.
> Deleting by a non-member name must fail with -ENOENT; instead it
> succeeds and the whole chain is removed.
> 

I am investigating this and testing a possible patch. I also verified 
this cannot happen with nft.

Thanks,
Fernando.
