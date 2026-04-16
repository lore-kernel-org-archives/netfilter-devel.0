Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0061221256C
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Apr 2026 12:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776343798; cv=none; b=Hj+xxMaZnJTIu3t7E2ULHCn1nS92WxD9iCQ+ai1H6kF2P7IM1bUoviwpI5uvtTlrWHK+wTfqT+D+BKWbFWBCYcia32XpC+Ih8jP8C3J8V9kEC/Zg+8AJX25gsQD8HLeEg67a+OOMD4zy+QKug3ohwQHmz8216+n+LSCraYuIM78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776343798; c=relaxed/simple;
	bh=a5/EXqMpsyNKARVOGE8LVXFdjOrH0z354sE/5WhVgi8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dg21LeiBid8vhCc8n01Fivk4GcAbuKP6l804z5eSu//bCmsCr3TirOClH/JeDqat7q+cU82bfw3WT100gWM8N96uvEl1eRQ0zBRhITnPhU/aJeXYwY6K1HuuOR4kT5TC0N46zK5AJPSX9fnY8LgLbY130/x4SRiXlGLgW9tLuiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=b414dE1P; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=QZ3CCXa8; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=b414dE1P; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=QZ3CCXa8; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="b414dE1P";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="QZ3CCXa8";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="b414dE1P";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="QZ3CCXa8"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1F52B6A7EC;
	Thu, 16 Apr 2026 12:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776343795; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dOlzxVPcvYutYtQY5iy+XsmQJuhqUgyyo2HCgwKbxuo=;
	b=b414dE1P8ZhPw+EQZ/L5BN3osxzulpHYCw214h53vsa7PfAND2hKp/1PgmwujHj1z0pEO2
	K+fI4wZBIoyYa70rZtzw32QOLNl8iF3oxJMc7/k9KVENfwi0UUf681Ix4ZYpurJ08jdP9C
	0zGaoWNwMvd9Rmr6o/QhN4/Wv3Mg4Q8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776343795;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dOlzxVPcvYutYtQY5iy+XsmQJuhqUgyyo2HCgwKbxuo=;
	b=QZ3CCXa8ORVS3YRF8de0TpzKLsspQ/RJ0PW1eTixfueTWhG06d/ss7ZoPQGtNEqjXM9blO
	QNGbK0UcVkuvsMCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=b414dE1P;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QZ3CCXa8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776343795; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dOlzxVPcvYutYtQY5iy+XsmQJuhqUgyyo2HCgwKbxuo=;
	b=b414dE1P8ZhPw+EQZ/L5BN3osxzulpHYCw214h53vsa7PfAND2hKp/1PgmwujHj1z0pEO2
	K+fI4wZBIoyYa70rZtzw32QOLNl8iF3oxJMc7/k9KVENfwi0UUf681Ix4ZYpurJ08jdP9C
	0zGaoWNwMvd9Rmr6o/QhN4/Wv3Mg4Q8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776343795;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dOlzxVPcvYutYtQY5iy+XsmQJuhqUgyyo2HCgwKbxuo=;
	b=QZ3CCXa8ORVS3YRF8de0TpzKLsspQ/RJ0PW1eTixfueTWhG06d/ss7ZoPQGtNEqjXM9blO
	QNGbK0UcVkuvsMCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9D376593A3;
	Thu, 16 Apr 2026 12:49:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7NuuI/La4GmpMgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 16 Apr 2026 12:49:54 +0000
Message-ID: <36ccd420-25f2-43e9-89bf-088fcad40f81@suse.de>
Date: Thu, 16 Apr 2026 14:49:50 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 00/14] Netfilter/IPVS fixes for net
To: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, horms@kernel.org
References: <20260416013101.221555-1-pablo@netfilter.org>
 <aeCPB1_WaFOX-Xos@chamomile> <aeC4A75gYD9qT5OR@chamomile>
 <aeC8hyj6IFW7UvUG@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aeC8hyj6IFW7UvUG@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[sashiko.dev:url,suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,netfilter.org:email];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Queue-Id: 1F52B6A7EC
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

On 4/16/26 12:40 PM, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> I cannot send a batch before 16h my local time, I need a bit more
>> time.
>>
>> Sorry.
> 
> No problem.  Alternative is to drop patches, this is what I did in the
> past.  Some LLM comment indicates problem, remove patch from v2
> and defer to next week.
> 
> But that was before LLM reviews flagged 50% of patches.
> I'll pick up on anything left behind for next weeks batch(es).
> 

Hi,

I would like to propose to add netfilter-devel mailing list to 
sashiko.dev and also to Netdev CI.. I think Jakub mentioned it was 
possible on a previous situation.

I think it isn't sustainable to review and address the AI/LLM comments 
when sending the pull request to for net/net-next.

If you agree I could help moving this forward.

Thanks,
Fernando.

