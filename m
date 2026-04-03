Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126751DC198
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Apr 2026 23:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775260664; cv=none; b=qDM3hy8JeA9xOPDHUyhxJ5zLPgKHT+OYMxxVJW+TF0KNmelGPLx+6CZHpXgyXDwKeCPw2vw4ijwDUVqZDU9UmEHvcbSDiY4GgqkDh7zju8AKRdFYc/rE1kHHLJpDWv2gHzKJ842ru7PHhj1NTQ/RRm1uZv0vFrWOJJiAHdg+E/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775260664; c=relaxed/simple;
	bh=hQZRt6WSgad+U+Pssq0KM4l6zxY4hq+Y/zwvXhp1K4M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k9NbHZVNjfOU1WFYzxTubU+fJ3KvIlZeLIv0PAK4bc6WPVRd4YbMxDxEjzj/Qil4wZsRfTccLbn6njJIr2gOxFF15GuS86VsiCPUM+asie8P5WI5r+SdQcrqDBYhl8bAn64bYgL/KSkE1gVZu7CWjnA1R0YEx2b4I2+08CaxRaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DWm/WCfm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=LyBrtKT4; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IbilKQbk; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qKyYdxO6; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DWm/WCfm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="LyBrtKT4";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IbilKQbk";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qKyYdxO6"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 892965BD23;
	Fri,  3 Apr 2026 23:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775260660; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NnoRqdUzNz0azZfM3b8bxze0ANQ+k8KxBHbyif5QGc4=;
	b=DWm/WCfmU2Sl0a8JBoazZ32/EkmZLi1k7GUPtfr2jyK1baB6K6l4xzzm5MUW+ZHuAG3isA
	wr6VwyJpPTfwSHXJdSbCGGy1UsoUl898nYhGXI54SPJMAWHBHl429KnWjE9MspgkSjuQvm
	iWd0O8OTb4h0x5On48iP7rF1OaaAIRw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775260660;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NnoRqdUzNz0azZfM3b8bxze0ANQ+k8KxBHbyif5QGc4=;
	b=LyBrtKT4Vejik99h7ClA0vh6Livh2N5zDtUP4IrVKLzWbQ0Nghd4AyvKT73kP/sS+kwKcL
	v8UkavyTYSIVQ+Dw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IbilKQbk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qKyYdxO6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775260659; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NnoRqdUzNz0azZfM3b8bxze0ANQ+k8KxBHbyif5QGc4=;
	b=IbilKQbkSlGLC5Tv4w909FE7+Ih/LS9E3edJR7kPmHPCwyLAQirUXGXFUrQWydzWKKsLig
	PPxsOD/CJRcFf8hXLGIwDdNf8TGRznVJfZCrbvEMUR5y9DELKiOLKKmeH/jh8b0YfrrUJm
	0unzGmM93wbaeaAQThrkYIRDOh2+BdA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775260659;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NnoRqdUzNz0azZfM3b8bxze0ANQ+k8KxBHbyif5QGc4=;
	b=qKyYdxO6Ej7NYxrF06rEDNc0N5AF8k/Oo0HP+IkOPOnRPvvWADCytrxniUKWRcjXlV1UfM
	uMsHML5Oy0ZDPSBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 509B74A0A6;
	Fri,  3 Apr 2026 23:57:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Y3SdEPNT0GnObgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 03 Apr 2026 23:57:39 +0000
Message-ID: <b0c495e4-2137-443b-986e-ed0c10251d0c@suse.de>
Date: Sat, 4 Apr 2026 01:57:31 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: nfnetlink_queue crashes kernel
To: Florian Westphal <fw@strlen.de>, Scott Mitchell <scott.k.mitch1@gmail.com>
Cc: netfilter-devel@vger.kernel.org
References: <ac-w6e33txkgTRJj@strlen.de> <ac_EY9ciqt5yQ6wr@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <ac_EY9ciqt5yQ6wr@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[strlen.de,gmail.com];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,strlen.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 892965BD23

On 4/3/26 3:45 PM, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
>> A probably better fix is to make the rhashtable perqueue, which is
>> much more intrusive at this late stage.
> 
> Tentative patch to do this, still misses selftest extensions:
> 

I could help with selftests. I have written a couple already. Let me 
prepare some this week and I will send them as proposals on the list.

Thanks,
Fernando.
