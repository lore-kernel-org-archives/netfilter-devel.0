Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794856538;
	b=iBiUbzpZ5UE9cDbQus+zePwlp43Alj9BFDCaEUqQ158omlNRvk0HIPADG1NO+e+qemY+
	 5KF3CMDWjs4KDPBNflneIroo1yW2HWkasv/vfUiQZeEFEqkLZYAE7WQaeesLYHsBTyId7
	 iCKmDOkWnwOqgixrlt/JyMPRMrRT/ZxZAzsTQeGIn69asp6F8igLhz8gWCigNrP2bD4Rf
	 eRPHOlA9gWywKoIAJxyI8pI/OZWj2pxAl7Nsw9LQ6Sp+SJNX+bVHkfMRaeDgNlowB0TyF
	 CoUIkJCq2lH3kszpDKMnC8YjZ+obIx4PySgDckcMdQWKsA/fcnAIKU1RsGzHUrh3j8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794856538;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=dhAoJNe3fPzmWOk2VpDnB6M/c9lvh0UdAslgSx4rl4o=;
	b=mzn/4un8BtNYaR7A7fTlIDgo/FJImRxuQrZtoWBDsWuz7PHIh/GuQ7j778gHkpM3ZvKJ
	 cmPuiMM6gjRSId2iJWVhAfp4XvNBqp8+1N/Vljn35Cbm4lahYZ2yOw3Rhv72a7R2/5bCe
	 tfoVV3W7WggCdd/2DM9BgKMWihO/pSMEZiwsE6m+xKyQV42XAbcsrvJOBudE5Dx5pr6wV
	 I9HZjIetP05r+xbV0E9AZgl8olf1rwYJOagYqmmFLQOBGF0PSDFwXa8G7mtfXmtLCpUbE
	 QmY+eRVA1G6NRBmGSdqOQjQw0Av+M3rnArCBDkLeh9D3TjhdeszkaBgN6xoXikFaadg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006B5606A31C;
	Mon, 16 Nov 2026 19:15:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 006B5606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1769360D56; Mon, 16 Nov 2026 20:15:30 +0100 (CET)
Date: Mon, 16 Nov 2026 20:15:26 +0100
From: Florian Westphal <fw@strlen.de>
To: Hui Peng <benquike@gmail.com>
Cc: pablo@netfilter.org, phil@nwl.cc, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nfnetlink_log: fix config error handling, SIT
 headroom OOB read, and nlmsg rollback
Message-ID: <avtWTqpzelp_PNmv@strlen.de>
References: <20260919215241.3471723-1-benquike@gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260919215241.3471723-1-benquike@gmail.com>

Hui Peng <benquike@gmail.com> wrote:
> Fix three issues in net/netfilter/nfnetlink_log.c:
> 
> 1. In __build_packet_message(), subtracting ETH_HLEN from skb_mac_header()
>    for ARPHRD_SIT tunnels can read before skb->head or past
>    skb_tail_pointer(skb), and nla_put_failure returns -1 without calling
>    nlmsg_cancel(inst->skb, nlh). Remove the unsafe ETH_HLEN subtraction,

That made no sense to me.  The entire ARPHRD_SIT check is dead code
nowadays and it will be removed in -next.

But how is it 'unsafe'?  If it moves to before skb->head, no read will
occur.

>    verify hwhdrp + hard_header_len <= skb_tail_pointer(skb), and cancel
>    the partial nlmsg on error.

I don't think its expected to ever fail.  There is a space-remaining
check *before* __build_packet_message() is called.

> 2. In nfulnl_log_packet(), only increment inst->qlen after
>    __build_packet_message() succeeds.

See above.

> 3. In nfulnl_recv_config(), propagate errors from nfulnl_set_mode() and
>    nfulnl_set_nlbufsiz() and destroy the newly created instance if
>    NFULNL_CFG_CMD_BIND was processed in the same message.

Not sure about this.  Could cause existing (working!) userspace
to fail.

> Fixes: 0c36b48b36dc ("netfilter: nfnetlink_log: fix mac address for 6in4 tunnels")

Not really.  Most of these 'fixes' are day-0 bugs.

I suggest we wait for the ARPHRD_SIT removal series to land in nf-next.

Then at least some of the changes here could land as cleanups.
