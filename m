Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F48C42047;
	Thu,  7 Mar 2024 09:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709804006; cv=none; b=PznqXD0k8RUxWMQenmgz7PVK018TnJaja5XRR/FulNJR2pbVqnjE0f1Qyno5mLVYtu1RWae9hviCq8bvaJGYoBTdK4Pejc92GE5iz5bLbfK5JqnZFI4lAqD/NKvdJINErO/YA0AHsyvHpGwHbda+krFNysBRY1cLL2qE1GqTShQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709804006; c=relaxed/simple;
	bh=I1Omnfc692Sx83UTzgWLksTLou/ItHvR6ZJVyogwNMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eANAyJipgwMGtyWdeNSGPz0uGpIVhd66OAmoDSLjlK/zE3lNuaJ7XOkVyffHOdHD+8U9DVuBNPciEW6b1dpelcW7Az9hieevxDi0vkF+X0vq36lRXHpouiu3tC08oFdd02sBtE8cZ+dH0KLhc2hj9y4Wvb3HvO1IZNfH4+d+zqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1riA7i-0005hU-0g; Thu, 07 Mar 2024 10:33:10 +0100
Date: Thu, 7 Mar 2024 10:33:10 +0100
From: Florian Westphal <fw@strlen.de>
To: Jason Xing <kerneljasonxing@gmail.com>
Cc: edumazet@google.com, pablo@netfilter.org, kadlec@netfilter.org,
	fw@strlen.de, kuba@kernel.org, pabeni@redhat.com,
	davem@davemloft.net, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH net-next] netfilter: conntrack: avoid sending RST to
 reply out-of-window skb
Message-ID: <20240307093310.GI4420@breakpoint.cc>
References: <20240307090732.56708-1-kerneljasonxing@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240307090732.56708-1-kerneljasonxing@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Jason Xing <kerneljasonxing@gmail.com> wrote:
> client_ip:client_port <--> server_ip:b_port
> 
> Then, some strange skbs from client or gateway, say, out-of-window
> skbs are sent to the server_ip:a_port (not b_port) due to DNAT
> clearing skb->_nfct value in nf_conntrack_in() function. Why?
> Because the tcp_in_window() considers the incoming skb as an
> invalid skb by returning NFCT_TCP_INVALID.

So far everything is as intended.

> I think, even we have set DNAT policy, it would be better if the
> whole process/behaviour adheres to the original TCP behaviour.
> 
> Signed-off-by: Jason Xing <kernelxing@tencent.com>
> ---
>  net/netfilter/nf_conntrack_proto_tcp.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> index ae493599a3ef..3f3e620f3969 100644
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -1253,13 +1253,11 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
>  	res = tcp_in_window(ct, dir, index,
>  			    skb, dataoff, th, state);
>  	switch (res) {
> -	case NFCT_TCP_IGNORE:
> -		spin_unlock_bh(&ct->lock);
> -		return NF_ACCEPT;
>  	case NFCT_TCP_INVALID:
>  		nf_tcp_handle_invalid(ct, dir, index, skb, state);
> +	case NFCT_TCP_IGNORE:
>  		spin_unlock_bh(&ct->lock);
> -		return -NF_ACCEPT;
> +		return NF_ACCEPT;

This looks wrong.  -NF_ACCEPT means 'pass packet, but its not part
of the connection' (packet will match --ctstate INVALID check).

This change disables most of the tcp_in_window() test, this will
pretend everything is fine even though tcp_in_window says otherwise.

You could:
 - drop invalid tcp packets in input hook
 - set nf_conntrack_tcp_be_liberal=1

both will avoid this 'rst' issue.
