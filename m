Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C43946C
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2026 21:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776719302; cv=none; b=bN5p8j35Y+cc+msEIm+xLwdbJo4QvxC3YSyLHKwgwGWAICO8BTJcOcrKGEiKN/G5Iw9f7PoFCXLaCXaEtcTHd+Wzqh/nxvzXQlDuV+ZeqXlZc/VX1Zn1Qt9dKWFSnYYKD3OTYbegef5St4WwzIrxtGfqCekFhQ770FWfHi/VvFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776719302; c=relaxed/simple;
	bh=eiig7UqC7KYu9Rke6U1ChITvIvOG/LCyJoCC3uipSys=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Osf0jZ3LJaAglbyRz9TnCxK8Cx/wvuNDRU7codt9GyZjzOJCrJv1ZIGvn3cS48iQPeUvv3+MT5/sOn61iC+RMRF1woL+svbMEsbunQaCiZ9YJgaXU+pOlA8XKOHWinJaZEdGEi86HU52hVLYR3ZH1PNgNgI/5MGpm2MGGFef9m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=oXlmcrPh; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vIwgJe1k; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=oXlmcrPh; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vIwgJe1k; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="oXlmcrPh";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vIwgJe1k";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="oXlmcrPh";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vIwgJe1k"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 726FE6A7D5;
	Mon, 20 Apr 2026 21:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776719299; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jilQR9GE8PoSmPRNaPz/68BpmSh+Xm9AVr4GLf+/mms=;
	b=oXlmcrPhwPIZZDVN4L6TDPVYorvQ8p+AEAQ/qXh0o3K0yBZ30a9HOTcU4dpMmzj4CBR6Kt
	Lq4ZcbUwq1FzwRtmkx+NjRK+6ncCbaoCk4P2NvXr4xPRijWJBB1SAFwHbTm2B4yKtT9pvA
	gmnor4clBqgySs9p0QNz+7+qDxHDjZM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776719299;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jilQR9GE8PoSmPRNaPz/68BpmSh+Xm9AVr4GLf+/mms=;
	b=vIwgJe1kKkMK5D82jCeLr2/136AQgXcyLB3hU6jMKF1Yu9mLumHQ7xhhjDwo0c4Xr6NbbI
	dTLlEbjpXy9wHZAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776719299; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jilQR9GE8PoSmPRNaPz/68BpmSh+Xm9AVr4GLf+/mms=;
	b=oXlmcrPhwPIZZDVN4L6TDPVYorvQ8p+AEAQ/qXh0o3K0yBZ30a9HOTcU4dpMmzj4CBR6Kt
	Lq4ZcbUwq1FzwRtmkx+NjRK+6ncCbaoCk4P2NvXr4xPRijWJBB1SAFwHbTm2B4yKtT9pvA
	gmnor4clBqgySs9p0QNz+7+qDxHDjZM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776719299;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jilQR9GE8PoSmPRNaPz/68BpmSh+Xm9AVr4GLf+/mms=;
	b=vIwgJe1kKkMK5D82jCeLr2/136AQgXcyLB3hU6jMKF1Yu9mLumHQ7xhhjDwo0c4Xr6NbbI
	dTLlEbjpXy9wHZAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1C023593AE;
	Mon, 20 Apr 2026 21:08:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SdUWBMOV5ml7ZQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 20 Apr 2026 21:08:19 +0000
Message-ID: <44c867f4-a9f7-4ca2-8c4e-ba13a5353815@suse.de>
Date: Mon, 20 Apr 2026 23:08:14 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2 nf v2] netfilter: xtables: fix L4 header parsing for
 non-first fragments
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 ecklm94@gmail.com, phil@nwl.cc, fw@strlen.de
References: <20260420104745.10338-1-fmancera@suse.de>
 <20260420104745.10338-2-fmancera@suse.de> <aeaQcrEMN-IYE7xI@chamomile>
 <aeaTcpPAk1HDjUoD@chamomile>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aeaTcpPAk1HDjUoD@chamomile>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,netfilter.org,gmail.com,nwl.cc,strlen.de];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

Hi Pablo,

On 4/20/26 10:58 PM, Pablo Neira Ayuso wrote:
> On Mon, Apr 20, 2026 at 10:45:41PM +0200, Pablo Neira Ayuso wrote:
>> Hi Fernando,
>>
>> On Mon, Apr 20, 2026 at 12:47:45PM +0200, Fernando Fernandez Mancera wrote:
>>> diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
>>> index 76e01f292aaf..d366e294f1aa 100644
>>> --- a/net/netfilter/xt_socket.c
>>> +++ b/net/netfilter/xt_socket.c
>>> @@ -55,8 +55,11 @@ socket_match(const struct sk_buff *skb, struct xt_action_param *par,
>>>   	if (sk && !net_eq(xt_net(par), sock_net(sk)))
>>>   		sk = NULL;
>>>   
>>> -	if (!sk)
>>> +	if (!sk) {
>>> +		if (par->fragoff)
>>> +			return false;
>>>   		sk = nf_sk_lookup_slow_v4(xt_net(par), skb, xt_in(par));
>>> +	}
>>>   
>>>   	if (sk) {
>>>   		bool wildcard;
>>> @@ -116,8 +119,11 @@ socket_mt6_v1_v2_v3(const struct sk_buff *skb, struct xt_action_param *par)
>>>   	if (sk && !net_eq(xt_net(par), sock_net(sk)))
>>>   		sk = NULL;
>>>   
>>> -	if (!sk)
>>> +	if (!sk) {
>>> +		if (par->fragoff)
>>> +			return false;
>>
>> Your patch will work as intented in iptables over nf_tables, because
>> it always sets on fragoff regardless user policy.
>>
>> But, if ipv6_find_hdr() finds no layer 4 protocol, then fragoff
>> remains zero, and pkt->flags does not set on NFT_PKTINFO_L4PROTO.
>> There, in nftables, par->fragoff but itself is not reliable because
>> maybe the layer 4 was not found.
> 
> This is where pkt->tprot comes into play. I think this series is fine
> with nf_tables, it is just ip6_tables legacy that lags behind.
> 

Hm, I didn't know this. Thanks for explaining. Then xt_socket is safe 
for IPv6 as the code does:

         tproto = ipv6_find_hdr(skb, &thoff, -1, NULL, NULL);
         if (tproto < 0) {
                 pr_debug("unable to find transport header in IPv6 
packet, dropping\n");
                 return NULL;
         }

at nf_socket_get_sock_v6()

Okay, let me re-send adjusting the IPv6 part..

>> Then, there is ip6_tables legacy which does not behave like ip_tables
>> for fragments.
>>
>> ip6t_do_table() only sets fragoff if IP6T_F_PROTO (-p in userspace) is
>> used, unlike nftables which always sets on fragoff.
>>
>> So par->fragoff is unreliable in ip6_tables legacy, and
>> ipv6_find_hdr() is called over and over again ip6_packet_match() loop
>> for each rule.
>>
>> One way would be to call ipv6_find_hdr() inconditionally from
>> ip6_tables legacy, but that belongs to a different patch and that
>> would be touch core ip6_tables legacy.
>>
>> Rewinding a bit, coming to back to the original issue: osf only
>> supports ipv4 :-)
>>

Right, but we need to fix this everywhere not only in osf.

Thanks,
Fernando.

>>>   		sk = nf_sk_lookup_slow_v6(xt_net(par), skb, xt_in(par));
>>> +	}
>>>   
>>>   	if (sk) {
>>>   		bool wildcard;
>>> diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
>>> index 0d32d4841cb3..69844cc8dbb8 100644
>>> --- a/net/netfilter/xt_tcpmss.c
>>> +++ b/net/netfilter/xt_tcpmss.c
>>> @@ -32,6 +32,9 @@ tcpmss_mt(const struct sk_buff *skb, struct xt_action_param *par)
>>>   	u8 _opt[15 * 4 - sizeof(_tcph)];
>>>   	unsigned int i, optlen;
>>>   
>>> +	if (par->fragoff)
>>> +		return false;
>>> +
>>>   	/* If we don't have the whole header, drop packet. */
>>>   	th = skb_header_pointer(skb, par->thoff, sizeof(_tcph), &_tcph);
>>>   	if (th == NULL)
>>> -- 
>>> 2.53.0
>>>
> 

