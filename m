Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8BC30FC05
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2025 08:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761725044; cv=none; b=LexfgCewKekXcOnsmGep6Ll1MHwVS9O+5EVw7BW6ev7v85I/ls2MPzPKoIE9V6AOlUyicaeL3SePN8QDHT2wq2a+ZcjzLzMrXBF1J7blFwv2GN26g/V2sZeIIJlmeWLjfMJC9EnN+GccHFruUSvjilQV5qXBiPbuS/4reuUU3FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761725044; c=relaxed/simple;
	bh=7Jz0fnj6u9HnufKLJmUGFa+qRzgpcdwVoXKrnUMtT6g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WSER+LpcZjXrpvZPUmdgJvtkND5qq9tbB9/CvBV1MtCKiyEVcS3AwLz6iiTuMFaBFCPJHd8tuMUHJrSJ2217qrkU8uBNqHjsNyVlErH/f4qV/+8aHOyM9hnGYrjfERjtsR9Z/pSsGVvPH4vRVhy8dDAcOQBkNzUPBun6qLTPAVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JvC8TI4h; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=gb9BLWbg; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JvC8TI4h; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=gb9BLWbg; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JvC8TI4h";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="gb9BLWbg";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JvC8TI4h";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="gb9BLWbg"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7057B20219;
	Wed, 29 Oct 2025 08:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761725040; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2Q0Mkae3tscHa4LqN1a7AkpWj28zo86EJN1k+kK/LHs=;
	b=JvC8TI4h+q4pPtFG3oA56PKGdkBkU7t7ADbgJaGJRYh65XR4/dcWJxn2ppvvj7IxIidRnx
	lSz/ALI78j/iv+DGg+YKNDFn6qI0z2+CHAsrzrI+kZmblncmCULVQ6oZifZTCJDO5WLNEF
	KZoBBCZr2qA4KslSAWnkM1rTOHhJfzw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761725040;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2Q0Mkae3tscHa4LqN1a7AkpWj28zo86EJN1k+kK/LHs=;
	b=gb9BLWbgZU40AKdEOx6pxAuTlHEsfLDj5HFkFERSEsOPAd3qIXzfxEM7x2621entL4vIob
	9SX7JUFIqPfQNOBA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=JvC8TI4h;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gb9BLWbg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761725040; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2Q0Mkae3tscHa4LqN1a7AkpWj28zo86EJN1k+kK/LHs=;
	b=JvC8TI4h+q4pPtFG3oA56PKGdkBkU7t7ADbgJaGJRYh65XR4/dcWJxn2ppvvj7IxIidRnx
	lSz/ALI78j/iv+DGg+YKNDFn6qI0z2+CHAsrzrI+kZmblncmCULVQ6oZifZTCJDO5WLNEF
	KZoBBCZr2qA4KslSAWnkM1rTOHhJfzw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761725040;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2Q0Mkae3tscHa4LqN1a7AkpWj28zo86EJN1k+kK/LHs=;
	b=gb9BLWbgZU40AKdEOx6pxAuTlHEsfLDj5HFkFERSEsOPAd3qIXzfxEM7x2621entL4vIob
	9SX7JUFIqPfQNOBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1B8BD1396A;
	Wed, 29 Oct 2025 08:04:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WunvA3DKAWmWLAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 29 Oct 2025 08:04:00 +0000
Message-ID: <cc12c37c-9eee-4f97-bb22-a16c6aed969d@suse.de>
Date: Wed, 29 Oct 2025 09:03:59 +0100
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
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, louis.t42@caramail.com
References: <20251027125730.3864-1-fmancera@suse.de>
 <aQD2R1fQSJtMmTJc@calendula> <aQD4J7pI-Fz1V3eC@strlen.de>
 <aQD5PUkG7M_sqUAv@calendula> <aQD810keSBweNG66@strlen.de>
 <fdaccdd2-fce5-4224-9636-bf3366de2761@suse.de> <aQEMbKZUBms2bfuI@strlen.de>
 <f012e7c0-4c29-42b0-90e6-9e82ef5bc6d8@suse.de> <aQEVF4mZ23ewPmUN@strlen.de>
 <9d1bb390-0f79-405e-8f28-6c7143a2e6b5@suse.de> <aQEthU7pgdNm9a18@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aQEthU7pgdNm9a18@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 7057B20219
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FREEMAIL_ENVRCPT(0.00)[caramail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[netfilter.org,vger.kernel.org,caramail.com];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.51



On 10/28/25 9:54 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> The use-case I have on mind (which is similar to what user described,
>> but he uses a counter which I guess is just for debugging):
>>
>> ip saddr 192.168.1.100 tcp dport 22 ct counter over 4 mark set 0x1
>>
>> later, the mark can be used for tc or policy-based routing - e.g
>> limiting bandwidth if the ip address has too many connections open.
>>
>> To me this seems a valid use case..
> 
> It is.  Please add a comment as to why the extra gc is needed.
> 
> Its not needed for the 'limit this address/network to only have
> x concurrent connections'.
> 
> But it is for 'softlimit-like' things as you explained above
> (which I failed to consider).  Thanks Fernando.
> 

Will send a v2, thank you Florian & Pablo!
