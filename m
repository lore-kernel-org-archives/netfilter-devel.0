Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7023FAE15
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Jun 2026 15:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781795751; cv=none; b=cR5F25O07Q+7ZJPfBIX5bopZd7Z13b2KY4/SeYQYfP8DootSgEYaL9I9dnM7ZsTpwfSHLdimFERzjQojHp1KqBygwuID3inwocc3u7UOVPUCKqoU5oDGjU2UUSt5A7D/y4wr0Q4GU78IFI410sXkpZewZgG8J8+1+vvwSV8RqcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781795751; c=relaxed/simple;
	bh=fWv7yo49jjFo95VXqvlLxyabw+b7MO8mxZFbNmX9yU8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=miJKXaQxz4xytLCT1/nt6KqwhYZkQlkPa3rB0P6r4qE0l48AZMnH7zLi5zE0s5izvWkrA9UomK4aurhG3b/kKOFW4yAcfnr9/wAtM+YWgAIbK+uONiF4DfkGGhnji/De5Cw/15Ylj22lViOXNMpd/8mniVzXSbGOXywyLrG9CQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JvIQkuZk; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NVjcYF9I; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VASxojkV; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1C1/AZ9P; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JvIQkuZk";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NVjcYF9I";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VASxojkV";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1C1/AZ9P"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D5E1675EE0;
	Thu, 18 Jun 2026 15:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781795748; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0+xp2lAgiRGy4XawGGF2L4mQKPn98lOsmBuJmsYMdn4=;
	b=JvIQkuZkR2QQRI4HLdx1VRoF+JDtCWXzugq7ATKbv2nqrKSEDBfawHvfrTyDTVK08JeZBW
	uiZX4LdP2QIM3oSWmGOy4IMtJfu243SU7tOnARjgx3UyTjmAKmQofNhNDDXGXm0YQb80v9
	A8DXCJjJggZ772kF3nCIJue+wQjqM6U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781795748;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0+xp2lAgiRGy4XawGGF2L4mQKPn98lOsmBuJmsYMdn4=;
	b=NVjcYF9Ijhw4xJ4po/1T6Lab7yDa5WFv+RrNx8vxJJxIYXBTLT/Wf4AMNtuDlsIsRZ4MbM
	FKFlDMQnMvc4DyCA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VASxojkV;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="1C1/AZ9P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781795745; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0+xp2lAgiRGy4XawGGF2L4mQKPn98lOsmBuJmsYMdn4=;
	b=VASxojkVQrp0tLBRFLZqN9va/dHAKt9aKBXmMb6C8qbi8/Fy0rvjKlf6J5cOM4Ja9pL58Q
	t24WkMCGMOc88vFa4KVLBSuGqlG+jgq7zkOXosXXWmKuuif+20JV7RzE0mHpOA8zcie6gR
	q3Q75ZGYrfg7sGBhSk1ttvGQIPN88dU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781795745;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0+xp2lAgiRGy4XawGGF2L4mQKPn98lOsmBuJmsYMdn4=;
	b=1C1/AZ9PxKCFf2wq2cYLV/jCzTUQP9uZmFwv7ye7ct/G8cJW5/PyUICizApUy5pZH+Z4R1
	a/E8O/VhyVEOQNBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A4365779A8;
	Thu, 18 Jun 2026 15:15:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UoaLJKELNGpaSwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 18 Jun 2026 15:15:45 +0000
Message-ID: <eb7af2bc-fe6c-4c13-b21d-e5dba3f47bea@suse.de>
Date: Thu, 18 Jun 2026 17:15:38 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf] netfilter: nft_meta_bridge: add validate callback for
 get operations
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20260618061631.21919-1-fw@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260618061631.21919-1-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:email,suse.de:dkim,suse.de:mid]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: D5E1675EE0
X-Spam-Score: -4.51

On 6/18/26 8:16 AM, Florian Westphal wrote:
> Blamed commit added NFT_META_BRI_IIFHWADDR to the set validate callback,
> yet this is a get operation.
> 
> Add a get validate callback and move the NFT_META_BRI_IIFHWADDR key
> there.
> 
> AFAICS this is harmless, NFT_META_BRI_IIFHWADDR can deal with a NULL
> input device and the set handler ignores a NFT_META_BRI_IIFHWADDR
> operation, but it allows to read 4 bytes off bridge skb->cb[].
> 
> Fixes: cbd2257dc96e ("netfilter: nft_meta_bridge: introduce NFT_META_BRI_IIFHWADDR support")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Thank you Florian, LGTM.

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
