Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792689376;
	b=MduTLrc5lwDsUf69jE4VE87yLFWOkSmA9yreMCBCKZ2m0m4llxplFIXd7BcOqVTIEa97
	 RZiHHWSKpGm9ETP841hT8OAaZp9vY8Kz30f0lIoA9n+SoXa+Zd8pheVtZAzHPDv/2eXAh
	 aBTZs+zWg9amMKvCI6/xxm+PfTYQbVuklT3HOKhZQ1fKN3wE5guIgkCTGLRVQLW9APTU+
	 H1wUMCBI36nHbnsViftlzf8vKSKqcaFUffYcL7OIg0sEoSJwyw5Da2JYMEKBFYO13ataU
	 QFPtq/mcGctBd7f5X8gA6O8EgjUPPX8VW9P3DWqeO8qNwgzHZqXfEnt25m5mNvSFUsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792689376;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=eYJlCngMqnDsOd7je4YuJlgK1ptTV5XGXutorFd8Srw=;
	b=RsIkw3/7vN4ltaDyg7E/WjntYEOnCbOawiY0KLkwAKXF4O1lb1AvChE7dNLdsXvAd4jF
	 IqJBI53lwpSIjZ+RddVRUyruRu17JNEPf5k7l4D9C/374DOQUdMP/NAhjv4Udhrmq9Y6x
	 3iNrYlsaW1Yrb86dy7Lb5LW09CdsNuevx+Kv09QOp72FMywhZ/2cCUAlHL5p0oC7CQNYC
	 XqEPqON3FAdwHFs44dqN1knZRxr+puqaBXQwz1ICNgANy3Fd3oT7bGrna6C0/kHkjA15s
	 R9cHmRRbHyvRaOO0tnUQAdFRTImz3PdX81CSdaRpJSLqmlj2OomVOtDzQER9m+Hy8zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=q9RlM5kY;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=lhHvuUWX;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=FD3TNZ98;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ZsqUtaNF;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09B9606A31E
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 17:16:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B09B9606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=q9RlM5kY;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=lhHvuUWX;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=FD3TNZ98;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ZsqUtaNF
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 549411FB3D;
	Thu, 22 Oct 2026 17:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792689373; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eYJlCngMqnDsOd7je4YuJlgK1ptTV5XGXutorFd8Srw=;
	b=q9RlM5kY8+DVI08XNz0zGj0YQPhWkpHQfak2re9AxllsmAP3GyAFBenOM5WkbsxFUCHwPZ
	vUzS+psa3wMPMCBD1ELzZpbgZU3VmjCckY6zQCo95tbUZNpTw4DPR/7pqyz4xa+xLC4kPy
	njgUbS8J+oFPRtuC5vrA+Xhv8i0rLRU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792689373;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eYJlCngMqnDsOd7je4YuJlgK1ptTV5XGXutorFd8Srw=;
	b=lhHvuUWXJyb/A64UPTXlbU2Zl/WPuUWEmIO4PFVQ3cYkwlNKJc5Q6gFq3TchkT6sQ/SSmH
	g8qRAYk2I1XN8LDg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FD3TNZ98;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZsqUtaNF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792689372; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eYJlCngMqnDsOd7je4YuJlgK1ptTV5XGXutorFd8Srw=;
	b=FD3TNZ982leEt89Z6uOkjLR66KqebJutek1B/QEXwLTrUKHQf13YPcqdFQOTgMRmVxvj/Z
	Dr3PISKEq7L69laHrCCt5393ALR68tFt1NcAi3Uw2SDn4oyot7KHwv+OOW00tLfftX6xyl
	Dm0YZOSWBiB0aFpt4Xa6WbQ0ias2Ctg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792689372;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eYJlCngMqnDsOd7je4YuJlgK1ptTV5XGXutorFd8Srw=;
	b=ZsqUtaNFRBSgoxBRN6HE6JIE7Zf+bWL55Bhtvq5tgga96odUPu70xzc4tzYQkqG05WDEy0
	IkeBL/WZsxs/JjBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0ADF4134E6;
	Thu, 22 Oct 2026 17:16:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id R/PGMttE2mp2WwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 22 Oct 2026 17:16:11 +0000
Message-ID: <396660ef-055b-4311-8e85-455f82636910@suse.de>
Date: Thu, 22 Oct 2026 19:16:01 +0200
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
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
References: <20261022155854.2004977-1-pablo@netfilter.org>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20261022155854.2004977-1-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
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
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,netfilter.org:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -13.50
X-Spam-Level: 
X-Rspamd-Queue-Id: 549411FB3D

On 10/22/26 5:58 PM, Pablo Neira Ayuso wrote:
> Fix reject expression in inet/ingress for locally generated IPv6 packets
> that are sent to a local address on ethX arrives through lo, really
> perform the similar handling as ip6_rcv_core().
> 
> Reported by sashiko.
> 
> Fixes: 73a73d442f99 ("netfilter: nf_reject: initialize IPCB at inet ingress")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v4: do not move route lookup before, this seems to interfer with the special loopback case.
> 
>   net/ipv6/netfilter/nf_reject_ipv6.c | 13 ++++++++++++-
>   1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
> index 5e08d8529cc8..8551e40faf04 100644
> --- a/net/ipv6/netfilter/nf_reject_ipv6.c
> +++ b/net/ipv6/netfilter/nf_reject_ipv6.c
> @@ -445,8 +445,19 @@ void nf_send_unreach6(struct net *net, struct sk_buff *skb_in,
>   		skb_in->dev = net->loopback_dev;
>   
>   	if (hooknum == NF_INET_INGRESS) {
> +		const struct inet6_dev *idev;
> +
>   		memset(IP6CB(skb_in), 0, sizeof(*IP6CB(skb_in)));
> -		IP6CB(skb_in)->iif = skb_in->skb_iif;
> +
> +		if (skb_valid_dst(skb_in)) {
> +			idev = ip6_dst_idev(skb_dst(skb_in));
> +			if (idev)
> +				IP6CB(skb_in)->iif = idev->dev->ifindex;
> +			else
> +				IP6CB(skb_in)->iif = skb_in->dev->ifindex;
> +		} else {
> +			IP6CB(skb_in)->iif = skb_in->dev->ifindex;
> +		}
>   	}


Hi Pablo, I did a bit of testing and patch LGTM.

Could we maybe simplify the code a bit by using a helper? Something like:

static int nf_reject6_ingress_iff(const struct sk_buff *skb)
{
	const struct inet6_dev *idev;

	if (skb_valid_dst(skb)) {
		idev = ip6_dst_idev(skb_dst(skb));
		if (idev)
			return idev->dev->ifindex;
	}

	return skb->dev->ifindex;
}

Then at nf_send_unreach6() we can do:

IP6CB(skb_in)->iif = nf_reject6_ingress_iif(skb_in);

If I am not wrong, compiler should just inline the helper and there 
should not be a performance hit. In addition, the code is cleaner from 
my point of view.

What do you think?

>   
>   	if (!skb_valid_dst(skb_in) && nf_reject6_fill_skb_dst(skb_in) < 0)

