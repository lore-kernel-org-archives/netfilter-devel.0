Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1F31C245C
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Oct 2024 12:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728564559; cv=none; b=iSIzj90UtiAHCBoXk2SRj+q+2LSxqlp31u2bgcQyPPf9HC7GJXX/F/UKx/DkPm35Qk43BzazYkcrc5sb8CC4AsGXfTtaYg8NVBmQk0j46daVjW+O/xptHsOiLkCBrtB1aQTn/sAuwgRUHdG6C/qrXJahKmHt46khVGLySCYQusU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728564559; c=relaxed/simple;
	bh=X7orjDhh2p9jpJ5YdqN6bD876sQFeWJnHL0HbtXeqnI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gVbhW0tJpD+T32qxgIm2JIP2SsBDpsmte0P1pqGjc92suyKE9i8jtBYPOisjX98sHdnLufEOdmpbr0RNOEhUQWZVPFTMF8Gire2DAAixYd5sOtdoTMfoTYP18PK1vBvvOusp5jiueCsdzrQmvxDfJ7hh8UfT/pDHuGQ5K2HZVKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wRDyvnwv; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ZTcO04A4; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wRDyvnwv; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ZTcO04A4; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wRDyvnwv";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ZTcO04A4";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wRDyvnwv";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ZTcO04A4"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B331E1FEFD;
	Thu, 10 Oct 2024 12:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1728564555; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n4ntJASa3MhXoH92glEZ30iHBZf4cvlVmKvLiaH2WbM=;
	b=wRDyvnwvyjV0ftVJpwS00epmd486sw72k/2lr6TNBQG2DhQHMTt008y4oK68QYj/SLsB7V
	5HQbYTiJEa+OZkUZes23eTTnHlnPYOc4TmhFFuzqnGGtaedGwUPHqhkU7OdPrfBjfNdjQw
	ALlN1Enb2Z5t57cGH1nHXfVrcYaOWPo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1728564555;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n4ntJASa3MhXoH92glEZ30iHBZf4cvlVmKvLiaH2WbM=;
	b=ZTcO04A4InzY0op2vteD3pxSrSQyTDOkvI5dAKJAswAE8Zb52nixxffZfVFvK31IdE/Xw2
	04pyMBAJVtK6zmDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1728564555; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n4ntJASa3MhXoH92glEZ30iHBZf4cvlVmKvLiaH2WbM=;
	b=wRDyvnwvyjV0ftVJpwS00epmd486sw72k/2lr6TNBQG2DhQHMTt008y4oK68QYj/SLsB7V
	5HQbYTiJEa+OZkUZes23eTTnHlnPYOc4TmhFFuzqnGGtaedGwUPHqhkU7OdPrfBjfNdjQw
	ALlN1Enb2Z5t57cGH1nHXfVrcYaOWPo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1728564555;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n4ntJASa3MhXoH92glEZ30iHBZf4cvlVmKvLiaH2WbM=;
	b=ZTcO04A4InzY0op2vteD3pxSrSQyTDOkvI5dAKJAswAE8Zb52nixxffZfVFvK31IdE/Xw2
	04pyMBAJVtK6zmDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9CF801370C;
	Thu, 10 Oct 2024 12:49:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3ZLeJUvNB2eiRwAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 10 Oct 2024 12:49:15 +0000
Message-ID: <b83a3a26-8806-40e6-8aa3-84fe3fe4517a@suse.de>
Date: Thu, 10 Oct 2024 14:49:15 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] nf_conntrack_proto_udp: Set ASSURED for NAT_CLASH entries
 to avoid packets dropped
To: Florian Westphal <fw@strlen.de>, Yadan Fan <ydfan@suse.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, netfilter-devel@vger.kernel.org,
 Michal Kubecek <mkubecek@suse.de>, Hannes Reinecke <hare@kernel.org>
References: <fd991e87-a97b-49af-892f-685b93833bd8@suse.com>
 <20241010124708.GB30424@breakpoint.cc>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20241010124708.GB30424@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email]
X-Spam-Flag: NO
X-Spam-Level: 

On 10/10/24 14:47, Florian Westphal wrote:
> Yadan Fan <ydfan@suse.com> wrote:
>> c46172147ebb brought the logic that never setting ASSURED to drop NAT_CLASH replies
>> in case server is very busy and early_drop logic kicks in.
>>
>> However, this will drop all subsequent UDP packets that sent through multiple threads
>> of application, we already had a customer reported this issue that impacts their business,
>> so deleting this logic to avoid this issue at the moment.
>>
>> Fixes: c46172147ebb ("netfilter: conntrack: do not auto-delete clash entries on reply")
>>
>> Signed-off-by: Yadan Fan <ydfan@suse.com>
> 
> 
> Acked-by: Florian Westphal <fw@strlen.de>

You probably need mine:

Signed-off-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
