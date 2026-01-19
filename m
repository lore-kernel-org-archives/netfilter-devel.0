Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963F432E686
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Jan 2026 16:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768840692; cv=none; b=GoTCRpnKc7Xr9O0sTMAldVHsLTsyAOcqIJRhkAIb561vHLW6NpxwdASoDDR3W9XueZ+nPlA8Zsr2h1B0KG7t4ZXQSr8b4OlseYw3HsRppzYfg2SR7Phl3dQxBQPUlJqp9VmVN8qSHXxHa4nmPXf9nTCeQrWqPCdzhrTxB8wuy7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768840692; c=relaxed/simple;
	bh=TDcoRwN9dxWJdod2LoMDqSx6jl/DmwbUUVptkpk9NsA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vkv37i/2BHpBo6zNF0iyxIwTBL/RSDT7sYD2HeiWDlpK1TyLF04VanMcVksG/EHhwKL9R/+tuMTS5hWlWHu4MLqiLfR144EwNUID6CyhUuyyoCixPU/bU5f9iJhghueJaGY/c/VsiWO7UFZkPfdjoK+1SYnlvV3Y9OkXo6y9CdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PeR5B39t; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=xOIuJMrZ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PeR5B39t; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=xOIuJMrZ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PeR5B39t";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xOIuJMrZ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PeR5B39t";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xOIuJMrZ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9CE853376C;
	Mon, 19 Jan 2026 16:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768840688; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9/2y73LVrhElF7k5V2X+sq00JEwMAI/w9iDq3M3AMCg=;
	b=PeR5B39ttCsliplpozVAiN7xEhsm2BL9g10Loa/rfWQLsO4d1qiyxIdbYcLTvQBphL0bdh
	4jaPzcpjZ+/jtBOTXUV2x/6BmMuyni8khWFeEVVVum4xkuVrfSOpkrLpBUBKVMhc3Kb4L3
	4FtoRNZZOJepVgFDBnXP4xVUpa84+7A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768840688;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9/2y73LVrhElF7k5V2X+sq00JEwMAI/w9iDq3M3AMCg=;
	b=xOIuJMrZAFLN4tjOaCK1YqfTwOwgpaFdgZ0BDOum5zvFs2ZHM+UhhMnLetSisgklE9JrJ0
	F+9r7tAp3wK63DBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=PeR5B39t;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xOIuJMrZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768840688; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9/2y73LVrhElF7k5V2X+sq00JEwMAI/w9iDq3M3AMCg=;
	b=PeR5B39ttCsliplpozVAiN7xEhsm2BL9g10Loa/rfWQLsO4d1qiyxIdbYcLTvQBphL0bdh
	4jaPzcpjZ+/jtBOTXUV2x/6BmMuyni8khWFeEVVVum4xkuVrfSOpkrLpBUBKVMhc3Kb4L3
	4FtoRNZZOJepVgFDBnXP4xVUpa84+7A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768840688;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9/2y73LVrhElF7k5V2X+sq00JEwMAI/w9iDq3M3AMCg=;
	b=xOIuJMrZAFLN4tjOaCK1YqfTwOwgpaFdgZ0BDOum5zvFs2ZHM+UhhMnLetSisgklE9JrJ0
	F+9r7tAp3wK63DBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3E6243EA63;
	Mon, 19 Jan 2026 16:38:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id V+7gC/BdbmlxAgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 19 Jan 2026 16:38:08 +0000
Message-ID: <bfbceb1c-38a9-410f-81af-8eda0776690f@suse.de>
Date: Mon, 19 Jan 2026 17:37:41 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf-next] netfilter: nf_conncount: fix tracking of
 connections from localhost
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 pablo@netfilter.org, phil@nwl.cc,
 Michal Slabihoudek <michal.slabihoudek@gooddata.com>
References: <20260118111316.4643-1-fmancera@suse.de>
 <aWzQoFTl6Cf4Vt3T@strlen.de> <db94e3de-d949-449f-aabb-75de17ee6d21@suse.de>
 <aW0EZPoM60XTy6kJ@strlen.de> <7d24517c-1209-49cc-a9cc-26eaf1a0e49e@suse.de>
 <aW15H8M9tjLRHSED@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aW15H8M9tjLRHSED@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: 9CE853376C
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 



On 1/19/26 1:21 AM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> After a quick test, it works for local connections. Although it doesn't
>> work for reverse-connlimit on INPUT. Consider the following ruleset:
>>
>> iptables -I INPUT -p tcp --sport 80 --tcp-flags FIN,SYN,RST,ACK SYN -m
>> connlimit --connlimit-above 100 -j LOG --log-prefix "Exceeded limit
>> established connections to 443"
> 
> Mhh, what is that supposed to do?
> 
> 'sport 80' meaning that we're client and we're receiving back a syn/ack?
> The rule only matches syn packets.
> 
> I'm confused what this should accomplish.
> 

Sorry that is copy-paste typo.

  iptables -I INPUT -p tcp --sport 80 --tcp-flags FIN,SYN,RST,ACK SYN,ACK
  -m connlimit --connlimit-above 100 -j LOG --log-prefix "Exceed
  established connections to 80"

Anyway, I think this should not be supported. In order to accomplish the 
case where we are the client, it should use OUTPUT.

>> To clarify this is the diff:
>>
>> diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
>> index 5588cd0fcd9a..339aaf5e3393 100644
>> --- a/net/netfilter/nf_conncount.c
>> +++ b/net/netfilter/nf_conncount.c
>> @@ -182,7 +182,7 @@ static int __nf_conncount_add(struct net *net,
>>                   /* connections from localhost are confirmed almost
>> instantly,
>>                    * check if there has been a reply
>>                    */
>> -               if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
>> +               if (skb->skb_iif != 1) {
>>                           err = -EEXIST;
>>                           goto out_put;
>>                   }
>>
>> I will send a V2 and ask for testing from Michal if possible.
> 
> Thanks!  connlimit is very old and there is no formal spec as
> to what its supposed to do, so I supsect we should try to at least
> fix the reported regression.   I'm fine with both approaches
> (REPLY and iif test), but the iif one would be 'better' in the sense
> that its a clear workaround for the more shady corner case :-)
> 
> Would you mind updating the comment was well to explain that
> this is related to loopback traffic, with conncount sitting
> in prerouting and thus after conntrack confirmation?
> 

Sure thing, in addition I am using LOOPBACK_IFINDEX which is defined in 
include/net/flow.h and included by include/linux/netfilter.h and I 
consider it better than the magic number.

Thanks,
Fernando.

> Thanks!
> 

