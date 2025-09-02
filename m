Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386B7309DC6
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Sep 2025 17:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756832534; cv=none; b=uVOL9eBJdiogMQf51dPkN61VhPifTBygIsgt4YxMWK3NwHzqn7/LJa8Ags/RBsiFPPhpNKgvViM2FPI2fJFWuPa2EfU2nvuDZ2Hv5OHJqozLUdxFvF7hHQBxZTV9ht9X/mugHNsbEShDN76tMB3y+r1WbLMhysYfv48GkIIGOIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756832534; c=relaxed/simple;
	bh=TmWTul/buURVyahbIiNvumZhU1p60pNKI/i9K/HSPNE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EER0tCfndLXzMAz+plTb/UWCFKLKkawk0shINdLkaqyYMwjm+OJeA2g3/9LfuU8+LOwVE3CdhECUuww2R9Jnj/6zLPcQ3MNV7DHwvzPqMOnYmLXf91blyxAua2IOT2kSM5byo55+a4EJDT4r+2c/q0NZ+VNprr1e1g9yIiBQRcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FeB/zG4B; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2bhh3SYV; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FeB/zG4B; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2bhh3SYV; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FeB/zG4B";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2bhh3SYV";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FeB/zG4B";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2bhh3SYV"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 18C8A1F38A;
	Tue,  2 Sep 2025 17:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756832531; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oHXAX/Ymi71LaTy580nkoWvb0oCeYiBSz7RQEjHwmCU=;
	b=FeB/zG4BQUgsSpPJWgfDk62pI6i3ab7BKaEct9sP3D5Y/4juP+/qbPsqg9aYA5jXaD0fWh
	yHwR5UFFU5+NxIi4hqgK98RjcxqqposNBPQOeEDk+7ieLH1swI6N2gmnQkcAQWeTGsv7SA
	a6a6MZ726NzPMns5WzudVnuQLToIUFw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756832531;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oHXAX/Ymi71LaTy580nkoWvb0oCeYiBSz7RQEjHwmCU=;
	b=2bhh3SYV4UMtbNJfaOflktCiGZakSAWUSQ33z+QOCjE6XbsodY2SkYlX0uP8uS8hTR7OPM
	YOXCe6s/CjNEi0DA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="FeB/zG4B";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2bhh3SYV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756832531; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oHXAX/Ymi71LaTy580nkoWvb0oCeYiBSz7RQEjHwmCU=;
	b=FeB/zG4BQUgsSpPJWgfDk62pI6i3ab7BKaEct9sP3D5Y/4juP+/qbPsqg9aYA5jXaD0fWh
	yHwR5UFFU5+NxIi4hqgK98RjcxqqposNBPQOeEDk+7ieLH1swI6N2gmnQkcAQWeTGsv7SA
	a6a6MZ726NzPMns5WzudVnuQLToIUFw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756832531;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oHXAX/Ymi71LaTy580nkoWvb0oCeYiBSz7RQEjHwmCU=;
	b=2bhh3SYV4UMtbNJfaOflktCiGZakSAWUSQ33z+QOCjE6XbsodY2SkYlX0uP8uS8hTR7OPM
	YOXCe6s/CjNEi0DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CE52313888;
	Tue,  2 Sep 2025 17:02:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id t+CWLxIjt2gbTgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 02 Sep 2025 17:02:10 +0000
Message-ID: <3aa6619f-e085-4acb-ac47-2aeb545578df@suse.de>
Date: Tue, 2 Sep 2025 19:02:10 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf-next] netfilter: nft_meta_bridge: introduce
 NFT_META_BRI_IIFHWADDR support
To: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
References: <20250902112808.5139-1-fmancera@suse.de>
 <aLbeVpmjrPCPUiYH@strlen.de> <aLcBOhmSNhXrCLIh@calendula>
 <e2c78075-e3b7-4124-a530-54652910a2d5@suse.de> <aLcUJ5U0LWW_-Vo8@calendula>
 <aLccQ9MN20VExE-4@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aLccQ9MN20VExE-4@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 18C8A1F38A
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.51



On 9/2/25 6:33 PM, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>>>                       +----br0----+
>>>                       |           |
>>> veth0_a------------veth0      veth1--------veth1_b
>>> (192.168.10.10/24)                     (192.168.10.20/24)
>>>
>>> Using the MAC of the port, the packet is consumed by the bridge too and not
>>> forwarded. So, no need for it to be the MAC address of the bridge itself..
>>
>> Thanks for confirming.
>>
>> But this is going to be a bit strange from usability point of view?
>>
>> It is easier to explain to users that by setting the br0 mac address
>> (as we do now) packets are passed up to the local stack.
> 
> Fair point.
> So lets just go with this patch set, forget I said anything :-)
> 
> Fernando, if you have some cycles, would you make a packetpath shell test
> for this to exercise the datapath?
> 

Sure, I can do it. I will create a new test on selftests covering this. 
Should I send a v2 series including the new commit or just send an 
independent series with the selftest changes?

Thanks,
Fernando.

> Thanks!
> 

