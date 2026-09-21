Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3303847DD5F
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Sep 2026 09:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789982949; cv=none; b=VNR0VWKLKYIybpPRUNQr2AGNIsmscWMGJHbaujqsUpKknk2aNFian11Eiy2fV4+V30KpQFI49ipCXZPxLJ0TwD/9cpqkQQga9oVs5iH8p+umcMfLyS4uFYvwUpMLKOiLf+H6uZej1N9C3ihIoa3xGt6EjUNgRDGdp7Vv9j+14Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789982949; c=relaxed/simple;
	bh=S/8YPda2hNISCm02mDMcQhhIot6R6vdqeufzBoegoxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TJ9r5iZXcT3UlXCcZplcbcS3pABBlpTCdv2EsAymaGfmSM3douXl0tziD9UAS8S8HWcfBGuZ62ehMQnVxyXwjfkUcpdZw5oGJwV4WB3wJLNBrTGIHzsqI3Y7ULl/cnYu/Ujh00zCzQFX7Ki8yGYDX0f5Zt/QsmSqpcWpAMNXGl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id F2778602AB; Mon, 21 Sep 2026 11:28:58 +0200 (CEST)
Date: Mon, 21 Sep 2026 11:28:58 +0200
From: Florian Westphal <fw@strlen.de>
To: Yu Junzhe <junzheyu1@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [BUG] netfilter: unbounded nftables reject recursion on inet
 OUTPUT
Message-ID: <arD4z6mj71pMY0ho@strlen.de>
References: <20260921061320.543-1-junzheyu1@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921061320.543-1-junzheyu1@gmail.com>

Yu Junzhe <junzheyu1@gmail.com> wrote:
> I am reporting unbounded hook recursion on inet OUTPUT: an nftables
> output chain that does a TCP flags payload-set followed by
> "reject with tcp reset" makes nf_send_reset() re-enter the same
> NF_INET_LOCAL_OUT hook until the kernel stack is exhausted.
>
> Summary
> =======
> 
> nft_reject_inet_eval() calls nf_send_reset(), which builds a RST skb
> and transmits it with ip_local_out(). That walks the same OUTPUT
> hooks again.

Can you send us a patch for this?

> The only loop guard in nf_reject_ip_tcphdr_get() is the packet-content
> check:
> 
>   /* No RST for RST. */
>   if (oth->rst)
>           return NULL;
> 
> If a payload-set runs first and rewrites the TCP flags byte to SYN,
> that guard never sees RST, so another RST is generated. The cycle is:
> 
>   nft_do_chain
>     -> nft_reject_inet_eval
>       -> nf_send_reset
>         -> ip_local_out
>           -> nf_hook_slow
>             -> nft_do_chain
> 
> nft_reject_inet_validate() allows NF_INET_LOCAL_OUT.
> 
> This is a legal nftables configuration (payload set + reject with tcp
> reset on an output base chain), including with CAP_NET_ADMIN in a
> network namespace. I do not claim privilege escalation; the result we
> see is local DoS (stack overflow, then panic).
> 
> I am aware of the existing recursion bound on the netdev fwd/neigh
> xmit path. nf_send_reset() via ip_local_out() does not use it.

Tell your coding assistant to move it to include/net/netfilter/nf_recursion.h,
add that include to the existing users, then extend all reset functions
(icmp and tcp reset) to use those helpers.
