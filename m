Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C9940DFA9
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2026 20:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777320042; cv=none; b=T4VTxmDTx3npuAsKxT3Rsmbrg/ayA0fW47m0MVZ3FiJzdZc2cKt/QhtUWle0htQRQKxcRlatlqjt0LGie8Im2SrUU2+3DvfmJ5uI8R1L71/MPSY4i2kOl3+E6y5Fc/eCdU2yoYIlxJMOOyGxwFlf/1UIATHLpQy8E1mOF2utV7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777320042; c=relaxed/simple;
	bh=C0OBtAx/FF4Flfmg2AD8MJGK9mVKZtM50SvFQPg70Kg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nxLlN1cuLYB3j+4E82TxfZXZYsloU4Ib4b2j4gm4q6ZFIvQYKQqrnGIh/uPaAAHdjScMAWUIUxxscUSLtwHjwB9WLn7mrV7GPZ3sAQot+Lq0WuYk4rIL+NzN7MPlviZLS3gFpKTOoZP9JRzIkEg45o4ImmN7SkwXqDRiBwlg7os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sGJNfHxz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=PUgqJNSd; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mDi0L5Uo; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=r/DIi7wZ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sGJNfHxz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="PUgqJNSd";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mDi0L5Uo";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="r/DIi7wZ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B39A66A826;
	Mon, 27 Apr 2026 20:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777320038; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VQzb5GxonsLziXI8kqQNlfhFLV2eHYtws8FQ98jDVz0=;
	b=sGJNfHxzfvfpPaPaNim/gWGE1tYmDuyN2GYIKRixlNjRCWdjUkDqlP8bvzZbNZwwrl4i7P
	3vXfv5bUspkCqJgUqFqaMew66q0nXAFKkFydsBs3k4cVcLZlAT+VtnzCJAPOFWCkx2NE72
	YU8fMIyEckj9ZsWsw6Slfp35pQ+AMlE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777320038;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VQzb5GxonsLziXI8kqQNlfhFLV2eHYtws8FQ98jDVz0=;
	b=PUgqJNSdETHtV66bhTdvQRtu6hU8tuGTTP5alos0i/juiFvtHPBPfA9g3pYeB66lHIhw+T
	vaiGtS+B5b2W6LAA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=mDi0L5Uo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="r/DIi7wZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777320035; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VQzb5GxonsLziXI8kqQNlfhFLV2eHYtws8FQ98jDVz0=;
	b=mDi0L5UoCMOBld/aJ3luiyfQZf46XC3mDKtV82sSdHG0W0+VEOpRR86fHB5e+Hk7qFwk2g
	LLLzCyd9M4WpBap2KTnP1q1XCsGOnQQDpbZ+e9zfG+UxGUw3+L09IKcTTpBRlDPrr4etGD
	T9E2U+eMZsFCOFHV/NH3QNKtW5Rz+BU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777320035;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VQzb5GxonsLziXI8kqQNlfhFLV2eHYtws8FQ98jDVz0=;
	b=r/DIi7wZoqOgz5bdoisO0lqfNw8etSIFPBziAf/ree8s9m3wVdupbrF9rcXK3JcJJWWIuh
	lDMN2b2OsRPDrQCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 613B4593B0;
	Mon, 27 Apr 2026 20:00:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /B+WFGPA72lmXwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 27 Apr 2026 20:00:35 +0000
Message-ID: <1fa9bf99-aa1f-4559-93bb-238a0d856582@suse.de>
Date: Mon, 27 Apr 2026 22:00:26 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3 nf v4] netfilter: xtables: fix L4 header parsing for
 non-first fragments
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, phil@nwl.cc
References: <20260427112720.5128-1-fmancera@suse.de>
 <20260427112720.5128-3-fmancera@suse.de> <ae-MRZ47QurmXY7z@chamomile>
 <ae-P4Sbl-0vpFrUY@strlen.de> <ae-bk_I_8CZyg5qA@chamomile>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <ae-bk_I_8CZyg5qA@chamomile>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	URIBL_BLOCKED(0.00)[suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,netfilter.org:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: B39A66A826

On 4/27/26 7:23 PM, Pablo Neira Ayuso wrote:
> On Mon, Apr 27, 2026 at 06:33:37PM +0200, Florian Westphal wrote:
>> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>>> -               if (!(pkt->flags & NFT_PKTINFO_L4PROTO))
>>> +               if (!(pkt->flags & NFT_PKTINFO_L4PROTO) || pkt->fragoff)
>>>                          return false;
>>
>> What is NFT_PKTINFO_L4PROTO supposed to mean?
> 
> "IP packet has been fully parsed"
> 

I thought it was something different. Actually, I saw check before and 
thought it was safe.

Let me adjust it on a v5 and thanks for pointing it out.

>> I thought it meant there is an l4 header but its set unconditionally
>> for ipv4.
> 
> Flag name is a misleading.
> 
> See my recent comment in this function:
> 
> static void nft_meta_pktinfo_may_update(struct nft_pktinfo *pkt)
> {
>          struct sk_buff *skb = pkt->skb;
>          struct vlan_ethhdr *veth;
>          __be16 ethertype;
>          int nhoff;
>                  
>          /* Is this an IP packet? Then, skip. */
>          if (pkt->flags)
>                  return;
> 
>> Only the ipv6 handling makes sense to me.
> 
> Maybe a helper function can be added, eg. nft_ip() then this flag can
> be renamed.

I will revisit the flag and its usage. Because there might be some more 
problematic uses. Anyway, the helper sounds like a good thing. Added to 
my nf-next TO-DO list.

Thanks,
Fernando.

