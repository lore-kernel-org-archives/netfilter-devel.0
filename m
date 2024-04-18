Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C72F1D688;
	Thu, 18 Apr 2024 16:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713457869; cv=none; b=qnY5PSf/mFvGZQrWkZAVUXmmrmmsC2VtWX6jmk66XMUCI8vrLckTJOdL+YsUJwbj8W6H+NowRQxLfibIu4YWPfztxQe8hAbYq+QFJAHTN6UgaemhNRl10hCVE0A/tmeCZYXUdknw6x0bQa//NISzvKQ3L1bPjG67n42HwObfvrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713457869; c=relaxed/simple;
	bh=9fRcpRpDk1+gLwVxxLm/KpYdYw5q9EwPjtrfHLSZx24=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eKjChxXG9NbzlWOjVP1doW6DCFM39K/5qR/niQPgGQhcv/PqHtGyQ951tSyKfyIhJ2T/B/Rwkxs1w7mnBg1BjXl99bLKmXR0EpefzOfd4us16lJJx8NQQwae4v1qVNhouF2Ti0zzp03ztqApjBQgZH55xnX6HrQCUfi+uf6h7DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Thu, 18 Apr 2024 18:30:55 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Donald Hunter <donald.hunter@gmail.com>
Cc: netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	donald.hunter@redhat.com
Subject: Re: [PATCH net-next v4 4/4] netfilter: nfnetlink: Handle ACK flags
 for batch messages
Message-ID: <ZiFKvyvojcIqMQ3R@calendula>
References: <20240418104737.77914-1-donald.hunter@gmail.com>
 <20240418104737.77914-5-donald.hunter@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240418104737.77914-5-donald.hunter@gmail.com>

Hi Donald,

Apologies for a bit late jumping back on this, it took me a while.

On Thu, Apr 18, 2024 at 11:47:37AM +0100, Donald Hunter wrote:
> The NLM_F_ACK flag is ignored for nfnetlink batch begin and end
> messages. This is a problem for ynl which wants to receive an ack for
> every message it sends, not just the commands in between the begin/end
> messages.

Just a side note: Turning on NLM_F_ACK for every message fills up the
receiver buffer very quickly, leading to ENOBUFS. Netlink, in general,
supports batching (with non-atomic semantics), I did not look at ynl
in detail, if it does send() + recv() for each message for other
subsystem then fine, but if it uses batching to amortize the cost of
the syscall then this explicit ACK could be an issue with very large
batches.

Out of curiosity: Why does the tool need an explicit ack for each
command? As mentioned above, this consumes a lot netlink bandwidth.

> Add processing for ACKs for begin/end messages and provide responses
> when requested.
> 
> I have checked that iproute2, pyroute2 and systemd are unaffected by
> this change since none of them use NLM_F_ACK for batch begin/end.

nitpick: Quick grep shows me iproute2 does not use the nfnetlink
subsystem? If I am correct, maybe remove this.

Thanks!

One more comment below.

> Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
> ---
>  net/netfilter/nfnetlink.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
> index c9fbe0f707b5..4abf660c7baf 100644
> --- a/net/netfilter/nfnetlink.c
> +++ b/net/netfilter/nfnetlink.c
> @@ -427,6 +427,9 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
>  
>  	nfnl_unlock(subsys_id);
>  
> +	if (nlh->nlmsg_flags & NLM_F_ACK)
> +		nfnl_err_add(&err_list, nlh, 0, &extack);
> +
>  	while (skb->len >= nlmsg_total_size(0)) {
>  		int msglen, type;
>  
> @@ -573,6 +576,8 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
>  		} else if (err) {
>  			ss->abort(net, oskb, NFNL_ABORT_NONE);
>  			netlink_ack(oskb, nlmsg_hdr(oskb), err, NULL);
> +		} else if (nlh->nlmsg_flags & NLM_F_ACK) {
> +			nfnl_err_add(&err_list, nlh, 0, &extack);
>  		}
>  	} else {
>  		enum nfnl_abort_action abort_action;
> -- 
> 2.44.0
> 
