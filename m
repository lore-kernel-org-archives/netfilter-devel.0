Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A996230215A
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Nov 2025 21:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764279099; cv=none; b=jPU8nlCTGu9TCQXQzOVrhnxQzdsPWjluPGbHjdZrnwt52vuZJKjuu7uUbw/ADd0ougSzWfrSdrXG9EooF6D+PLsO353M5HUigyZmTuMVhSKSWvnDRKtlNFnrwHIMuVCrC+lnoFoSjT9GoLxFxicKjylhdoZp9vQeHTbv1ETpruQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764279099; c=relaxed/simple;
	bh=vN3i6Y1uhx44EkkxFrp5f3FcOoSt9xg0G5DDMgadqmE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GAGlbcA8uGBamXfRlAscvK9S5c2crlrpF2M9Jpfl9pjR7uIZo2+flozprNkiVNSOVhsxVyd+isA0O8g0l8s0hv5xqpEn9YrMV38xmNcPerwhCzc3CLFeATVC0AkvMUObhV6yKbK8UjGIvqjj3whEcy/akKBmU8AfgTZ7AUMQEww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sfbEHfkR; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7/pT6wPu; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bQNwZZpR; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9IT+3HwO; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sfbEHfkR";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7/pT6wPu";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bQNwZZpR";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9IT+3HwO"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 598E2336A2;
	Thu, 27 Nov 2025 21:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764279094; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=25mrNhu6Zie5BIwYCnaBernoFAVMbRKzxn4sg6lEYnE=;
	b=sfbEHfkRz4ELQ6+W0dpBHjL2F+ZqRdV5GFc4SJiyiiTArMUzMY9HO7YXVBGMaAtqMGmaxx
	kKDa0J77I4V5ptfaliDiIrSaqTBumQUcBzEcRs3xS17UDVWb6q3gWPi/XGuNL8lggvulAE
	O6fGp5ehmQS7EvyNHdVtc4iL1QSDzKY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764279094;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=25mrNhu6Zie5BIwYCnaBernoFAVMbRKzxn4sg6lEYnE=;
	b=7/pT6wPuARXtkDkL1w6atgXA5EdQk4xhZxdxp6FIkeYlfd/a703yeh1/QcN7SRbYhb7xX6
	PMO3XxFULnjFESBA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bQNwZZpR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9IT+3HwO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764279093; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=25mrNhu6Zie5BIwYCnaBernoFAVMbRKzxn4sg6lEYnE=;
	b=bQNwZZpR7VAxIwbp26dFZcx8gRb+VAemkP9dD5273bwtzGMcix/CH85pabXwBlqP95XP+I
	9IlEBKZbwbD6tueElzdUF9eZEtmXQw/bwREZuBn40Ss/nSGYEMsdlD19PzrEZuJl2Z26ez
	Z8kaYMZBaBZKZtyPUH/d/3e3Hzia9Dc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764279093;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=25mrNhu6Zie5BIwYCnaBernoFAVMbRKzxn4sg6lEYnE=;
	b=9IT+3HwOttEmn76qRt7A7Elf3WdC6ZoE3W2a4YWrwGZInDXkzxJvDAEyGXcpK3IgdUTK12
	Y2aOCBsxldK4PRAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C77823EA63;
	Thu, 27 Nov 2025 21:31:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fyKPLTTDKGkTJAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 27 Nov 2025 21:31:32 +0000
Message-ID: <fb6e4953-a706-49e5-9026-3cc190414984@suse.de>
Date: Thu, 27 Nov 2025 22:31:27 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next,v2 00/16] Netfilter updates for net-next
To: Paolo Abeni <pabeni@redhat.com>, Pablo Neira Ayuso <pablo@netfilter.org>,
 netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
 edumazet@google.com, fw@strlen.de, horms@kernel.org
References: <20251126205611.1284486-1-pablo@netfilter.org>
 <4362bcbe-4e82-4198-955f-e64b3ff2d9c9@redhat.com>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <4362bcbe-4e82-4198-955f-e64b3ff2d9c9@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,linux.dev:url,suse.de:mid,suse.de:dkim,nft_flowtables.sh:url];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 598E2336A2

On 11/27/25 4:08 PM, Paolo Abeni wrote:
> On 11/26/25 9:55 PM, Pablo Neira Ayuso wrote:
>> v2: - Move ifidx to avoid adding a hole, per Eric Dumazet.
>>      - Update pppoe xmit inline patch description, per Qingfang Deng.
>>
>> -o-
>>
>> Hi,
>>
>> The following batch contains Netfilter updates for net-next:
>>   
>> 1) Move the flowtable path discovery code to its own file, the
>>     nft_flow_offload.c mixes the nf_tables evaluation with the path
>>     discovery logic, just split this in two for clarity.
>>   
>> 2) Consolidate flowtable xmit path by using dev_queue_xmit() and the
>>     real device behind the layer 2 vlan/pppoe device. This allows to
>>     inline encapsulation. After this update, hw_ifidx can be removed
>>     since both ifidx and hw_ifidx now point to the same device.
>>   
>> 3) Support for IPIP encapsulation in the flowtable, extend selftest
>>     to cover for this new layer 3 offload, from Lorenzo Bianconi.
>>   
>> 4) Push down the skb into the conncount API to fix duplicates in the
>>     conncount list for packets with non-confirmed conntrack entries,
>>     this is due to an optimization introduced in d265929930e2
>>     ("netfilter: nf_conncount: reduce unnecessary GC").
>>     From Fernando Fernandez Mancera.
>>   
>> 5) In conncount, disable BH when performing garbage collection
>>     to consolidate existing behaviour in the conncount API, also
>>     from Fernando.
>>   
>> 6) A matching packet with a confirmed conntrack invokes GC if
>>     conncount reaches the limit in an attempt to release slots.
>>     This allows the existing extensions to be used for real conntrack
>>     counting, not just limiting new connections, from Fernando.
>>   
>> 7) Support for updating ct count objects in nf_tables, from Fernando.
>>   
>> 8) Extend nft_flowtables.sh selftest to send IPv6 TCP traffic,
>>     from Lorenzo Bianconi.
>>   
>> 9) Fixes for UAPI kernel-doc documentation, from Randy Dunlap.
>>
>> Please, pull these changes from:
>>
>>    git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-25-11-26
>>
>> Thanks.
> 
> The AI review tool found a few possible issue on this PR:
> 
> https://netdev-ai.bots.linux.dev/ai-review.html?id=fd5a6706-c2f8-4cf2-a220-0c01492fdb90
> 
> I'm still digging the report, but I think that at least first item
> reported (possibly wrong ifidx used in nf_flow_offload_ipv6_hook() by
> patch "netfilter: flowtable: consolidate xmit path") makes sense.
> 

Hi Paolo,

I took a look to the reports related to my patches.

Patch 10 - yes, that report is correct. I can follow up with a fix on nf 
tree if that is fine.

Patch 12 - I think that should be fine, nf_conncount_tree_skb() which 
calls count_tree() should called with RCU read lock. This patch didn't 
modify that behavior.

Patch 13 - as we are holding the commit mutex I thought that it wasn't 
needed. Anyway, if that is needed, there are other places where we have 
similar issues that would require a fix too. I can follow up on nf tree.

> I *think* that at least for that specific point it would be better to
> follow-up on net (as opposed to a v3 and possibly miss the cycle), but
> could you please have a look at that report, too?
> 
> Thanks,
> 
> Paolo
> 
> 

