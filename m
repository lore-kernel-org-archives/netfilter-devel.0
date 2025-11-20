Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF242641CA
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Nov 2025 11:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763638778; cv=none; b=La1tHWRsm3CjTbMyM0FiQLTZhhPKrYncy+DUehoz288eRtkfGFIP6sUfqOa/qhkL3jr04fhHM1TMimrxtDOSoIL1vT137+pwfCTwbMQEGdnwtNgzE1M7ZNSYsANO68K7/IawDdjNeRAnR/VEWXLpL54SYS3JZ0qYEZ29+HE/gW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763638778; c=relaxed/simple;
	bh=6WAegcnfhvd6HVtFSpZjEiJpdz/TFjkoNBPQOyUg8Mo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Kof7Knhd1TUMAnl/oDQr300eZUVV3N9hPt+OPp9O2F27jEUj/ejCX07LhgrJjIZa9DLUWuI6u6GAjVPeXQyEqSul6q+jWA6pvYianLasqGS7/HzE9iKsK1xnyOw+gbpQvru6Mqp658VPZvFXXvXSMzVA7LMd/DgInEZgiO5uU3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JfBhzxyX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NtvsrTVm; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yZpbq8Yp; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=72+oMd5a; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JfBhzxyX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NtvsrTVm";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yZpbq8Yp";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="72+oMd5a"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 847EA209DE;
	Thu, 20 Nov 2025 11:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763638775; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q90sMGLEA+4FTl7t5GKFvni8/rkQ4jsLv4K3BshPEdg=;
	b=JfBhzxyXsTLYdM3yqbh6zA3jM0yRlbsyE2TaIb77fG/G6J3fnTgGc6KcWlpCGhWKFaP//h
	tQCD6SwX4uyackGMjUg3XqbCNSuUqh5AJh/+3+emjpl4vxGGkjFQey79BnC2aU6ERhiCC4
	GJ//4SwjCqX2zeJeneLTZ3a1cKxwt/o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763638775;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q90sMGLEA+4FTl7t5GKFvni8/rkQ4jsLv4K3BshPEdg=;
	b=NtvsrTVm3uzowfEAu5nkQS6YO82Y9heglX5LrtwnoZaIEN9Jj+aS9wskXyYCNQ6sSGq3AF
	nb0mtAlb+lWMKsAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763638774; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q90sMGLEA+4FTl7t5GKFvni8/rkQ4jsLv4K3BshPEdg=;
	b=yZpbq8YptIlBE49yhK0qKVha6PRrXs93t+jUIMB2nrJ/CP8NmXIZdc+OvQUL0ql3KCwq4a
	0puz4rUjeSAC+hbAUWufO10SHWbm6XVo6mdBs/jccQksL+/lPBnlloiyVwRnnrB14CCLPu
	2D2Y7PhKzzRknLzD7gS1usPBILW7Bbs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763638774;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q90sMGLEA+4FTl7t5GKFvni8/rkQ4jsLv4K3BshPEdg=;
	b=72+oMd5a6LYjUWWv76pIzs+XurV/Nhpkcc8pBkzKsJnJpihmr2wTqyLKDXWjK92J/h1FzT
	xYGou/VPTQG+9wBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4DFA53EA61;
	Thu, 20 Nov 2025 11:39:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ur0LEPb9HmmAIQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 20 Nov 2025 11:39:34 +0000
Message-ID: <2772dd60-1b5b-4913-a042-24eb44220149@suse.de>
Date: Thu, 20 Nov 2025 12:39:26 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf-next 0/3] netfilter: nft_set_rbtree: use cloned tree
 for insertions and removal
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
 netfilter-devel@vger.kernel.org
References: <20251118111657.12003-1-fw@strlen.de>
 <9a4e63da-6d36-4365-8c08-547961c9bfa7@suse.de>
 <aR29ddgmrjWcayAV@orbyte.nwl.cc> <aR3osq6hSxh7JwVm@strlen.de>
 <aR5BT0-HnwPEkBR5@orbyte.nwl.cc>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aR5BT0-HnwPEkBR5@orbyte.nwl.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.19)[-0.966];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.29

On 11/19/25 11:14 PM, Phil Sutter wrote:
> On Wed, Nov 19, 2025 at 04:56:34PM +0100, Florian Westphal wrote:
>> Phil Sutter <phil@nwl.cc> wrote:
>>>> 200K elements ~ avg. time insertion before 510ms after 744ms
>>>> 500K elements ~ avg. time insertion before 5460ms after 7730ms
>>>
>>> I wonder if nft_rbtree_maybe_clone() could run a simpler copying
>>> algorithm than properly inserting every element from the old tree into
>>> the new one since the old tree is already correctly organized -
>>> basically leveraging the existing knowledge of every element's correct
>>> position.
>>
>> Yes, but I doubt its going to help much.
>>
>> And I don't see how this can be done without relying on implementation
>> details of rb_node struct.
>>
>>> Or is there a need to traverse the new tree with each element instead of
>>> copying the whole thing as-is?
>>
>> What do you mean?
> 
> So I gave it a try and to my big surprise nftables test suite does not
> cause a kernel crash and inserting elements into a large set seems to be
> faster (0.07s vs. 0.1s per 'nft add element' call).
> 
> Where's the rub? Fernando, care to give it a try?
> 

It improved very little on my side..

200K elements ~ avg. time insertion mainline 510ms patchset 744ms this 
patch 703ms
500K elements ~ avg. time insertion mainline 5460ms patchset 7730ms this 
patch 7654ms

Please, notice that for calculate this I create a big set and then 
perform 20 insert operations calculating the average time.

Thanks,
Fernando.
