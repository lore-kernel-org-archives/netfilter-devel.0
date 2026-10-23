Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792742722;
	b=dQ2DH+DHoQbi6AX2MD5xcSmwcb4G/0EsxUic8D+QeJKIxSTzb+mrxwudzeVjOS9mmA0/
	 RbD3UZFnmSifwX9+OmvgubJ/EpLtw5J4tL6WbQUA1L/LCIGrRxgOEvLKsENiPZDugOj+V
	 MGqWneXePSgDQNOBIW/AihYW0XPWAuQpIr1RHMZi6U7ryxI0Y5ppSCaTFPrxQmVlYQjtb
	 w3vSobUH6I4La+rHymJamMUFyGznEyB+OlYreAKx6pPBQ+kycP3qCcyNB4kd9gJJdSzdE
	 J1Nbjs21gw8gexPb1QgjsYQ4mRwTi3bvo+HNB+KnfibBVag4ro4OwChCGUhqSA+cl6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792742722;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=uJe3OQAvGTorhYfKOqlMJuT2mL12mzVhTxsyHo7z7HQ=;
	b=lGNscGv+4ka8suZJEsD5JMqbuByefgP3eoP2rB3qqB8hFBC+3v1ETqoEolz0E68gNtTQ
	 JiENtGWDj7t4nHk6MF5dWXtsOa7i28MlCSlC8EVsNPmvR+5PT1iBFI6lEQNKfQ84hVNkk
	 7HsoMO4RXERWM+YnPIYOO8GPX67f+hon1sPZj7sSCFT/ZJFJiN1QJDYU4JJnoUpU+7u4s
	 00uBQ0ZHUS5dOV9WkDAm5ob1Bvd9tPMSnG+1qmvLP3V7j4Xo1D3IVD13bDh2ZeOU7BNgE
	 RGDlyDMdyXzDd6ngz5sMd88d96+BHWjJzjFkrPZWgokXqLlvKqJ0rwDNatTMqUP4gRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=VleN0kF+;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Vj4jJJU0;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=xrkW1Gvl;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=qDVIIIS+;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12BB606A31A
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Oct 2026 08:05:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A12BB606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=VleN0kF+;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Vj4jJJU0;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=xrkW1Gvl;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=qDVIIIS+
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AE1262208C;
	Fri, 23 Oct 2026 08:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792742719; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uJe3OQAvGTorhYfKOqlMJuT2mL12mzVhTxsyHo7z7HQ=;
	b=VleN0kF+EcLPWgFdHAJ2cah90suSIkkOikgeXYiSTrIhMPICw/n2h1VdUNYXwN4y5JM7TM
	+n/5WRshE/LSgDhlrYeVmAuJdc0VjU8bQG3Datii53NKKl6FFQLvIk2GxdOPzXTn6DAj/F
	MA6HbedJFR9BHQeeycPyKHUkjogNrrM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792742719;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uJe3OQAvGTorhYfKOqlMJuT2mL12mzVhTxsyHo7z7HQ=;
	b=Vj4jJJU0y4VtWDJfC4jnoDhfWepH+iRlmYHG1SwpaxDn06Z2tJ0uPo6SKCT3Cyx4Q6dQaN
	EJgHCyu0UJgFdhAw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xrkW1Gvl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qDVIIIS+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792742718; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uJe3OQAvGTorhYfKOqlMJuT2mL12mzVhTxsyHo7z7HQ=;
	b=xrkW1GvlIpH6YFjPzRIqYuId68WE5+JwgmXSjUsx9oQIt5HZRU2gUvEatBvSvjvwCMgwz+
	zXNrxfP7kRfA01k0BikeUDL7fQDP8T/AhMHW90AX6b4d+BIAvhjZRTGaqIVW/+u9goUidz
	wlK6PNg9OyerllzLnPS424UPElbL2iM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792742718;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uJe3OQAvGTorhYfKOqlMJuT2mL12mzVhTxsyHo7z7HQ=;
	b=qDVIIIS+UxPbbqbUQ5n0VVJ4b2hOV2cHg6neE1W7j0NwfyP+Putsu2S7GlAFTn2xcdmeTg
	721fF31EXopW6LBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5FA89133F6;
	Fri, 23 Oct 2026 08:05:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CHGpCz4V22qMbAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 23 Oct 2026 08:05:18 +0000
Message-ID: <5e8c0c60-230b-4a07-bafe-7c8216357ae8@suse.de>
Date: Fri, 23 Oct 2026 10:04:07 +0200
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf,v4] netfilter: nf_reject_ipv6: fix locally generated
 packet to local address
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
References: <20261022155854.2004977-1-pablo@netfilter.org>
 <396660ef-055b-4311-8e85-455f82636910@suse.de> <atqKCsIbAn35HIse@chamomile>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <atqKCsIbAn35HIse@chamomile>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AE1262208C
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-13.50 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -13.50

On 10/23/26 12:11 AM, Pablo Neira Ayuso wrote:
> On Thu, Oct 22, 2026 at 07:16:01PM +0200, Fernando Fernandez Mancera wrote:
>> On 10/22/26 5:58 PM, Pablo Neira Ayuso wrote:
>>> Fix reject expression in inet/ingress for locally generated IPv6 packets
>>> that are sent to a local address on ethX arrives through lo, really
>>> perform the similar handling as ip6_rcv_core().
>>>
>>> Reported by sashiko.
>>>
>>> Fixes: 73a73d442f99 ("netfilter: nf_reject: initialize IPCB at inet ingress")
>>> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>>> ---
>>> v4: do not move route lookup before, this seems to interfer with the special loopback case.
>>>
>>>    net/ipv6/netfilter/nf_reject_ipv6.c | 13 ++++++++++++-
>>>    1 file changed, 12 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
>>> index 5e08d8529cc8..8551e40faf04 100644
>>> --- a/net/ipv6/netfilter/nf_reject_ipv6.c
>>> +++ b/net/ipv6/netfilter/nf_reject_ipv6.c
>>> @@ -445,8 +445,19 @@ void nf_send_unreach6(struct net *net, struct sk_buff *skb_in,
>>>    		skb_in->dev = net->loopback_dev;
>>>    	if (hooknum == NF_INET_INGRESS) {
>>> +		const struct inet6_dev *idev;
>>> +
>>>    		memset(IP6CB(skb_in), 0, sizeof(*IP6CB(skb_in)));
>>> -		IP6CB(skb_in)->iif = skb_in->skb_iif;
>>> +
>>> +		if (skb_valid_dst(skb_in)) {
>>> +			idev = ip6_dst_idev(skb_dst(skb_in));
>>> +			if (idev)
>>> +				IP6CB(skb_in)->iif = idev->dev->ifindex;
>>> +			else
>>> +				IP6CB(skb_in)->iif = skb_in->dev->ifindex;
>>> +		} else {
>>> +			IP6CB(skb_in)->iif = skb_in->dev->ifindex;
>>> +		}
>>>    	}
>>
>>
>> Hi Pablo, I did a bit of testing and patch LGTM.
> 
> May I have your Tested-by: tag?

Sure thing!

Tested-by: Fernando Fernandez Mancera <fmancera@suse.de>

> 
>> Could we maybe simplify the code a bit by using a helper? Something like:
>>
>> static int nf_reject6_ingress_iff(const struct sk_buff *skb)
>> {
>> 	const struct inet6_dev *idev;
>>
>> 	if (skb_valid_dst(skb)) {
>> 		idev = ip6_dst_idev(skb_dst(skb));
>> 		if (idev)
>> 			return idev->dev->ifindex;
>> 	}
>>
>> 	return skb->dev->ifindex;
>> }
>>
>> Then at nf_send_unreach6() we can do:
>>
>> IP6CB(skb_in)->iif = nf_reject6_ingress_iif(skb_in);
>>
>> If I am not wrong, compiler should just inline the helper and there should
>> not be a performance hit. In addition, the code is cleaner from my point of
>> view.
>>
>> What do you think?
> 
> That sounds fine, I will post a v5.

