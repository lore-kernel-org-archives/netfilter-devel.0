Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE7E012B171;
	Thu, 21 Mar 2024 21:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711055183; cv=none; b=ge0NUceymRIlwFARhqn7XD9PhAAjNlSjO8ESVmRZue0v/5qjxg5e7+Z7640n1+boCmh6jCarwbOuLOOG1wpSlcCTqfk7Evh+jiZGBUBLGHidZvp4nAlXL+HTX4ofcwwal9QkG0e+J8hUTtWPTTHUqQaYJW58TfQiDXmTXHTzZbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711055183; c=relaxed/simple;
	bh=hM2UzG3TY+IQ75WVNb8tSTq9gEs6yeTrLXZcM+B8/fg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yl6u8n3y6qk142hf+kdhIUbTzh97nY7WmpdydJmev7rgm9Vr5WGMbBFw8B73DmXSMynfKGZomEMO2d1IUUlyTy10BK286QKzA2V38lLwZlJs9lyQZVl3PtxZVQjT0tabiDdbVgZjpQovYCm7rhARL368ihxqfGMXryksvOAWwiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Thu, 21 Mar 2024 22:06:15 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jason Xing <kerneljasonxing@gmail.com>
Cc: edumazet@google.com, kadlec@netfilter.org, fw@strlen.de,
	kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH nf-next v2] netfilter: conntrack: avoid sending RST to
 reply out-of-window skb
Message-ID: <ZfyhR_24HmShs78t@calendula>
References: <20240311070550.7438-1-kerneljasonxing@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240311070550.7438-1-kerneljasonxing@gmail.com>

On Mon, Mar 11, 2024 at 03:05:50PM +0800, Jason Xing wrote:
> From: Jason Xing <kernelxing@tencent.com>
> 
> Supposing we set DNAT policy converting a_port to b_port on the
> server at the beginning, the socket is set up by using 4-tuple:
> 
> client_ip:client_port <--> server_ip:b_port
> 
> Then, some strange skbs from client or gateway, say, out-of-window
> skbs are eventually sent to the server_ip:a_port (not b_port)
> in TCP layer due to netfilter clearing skb->_nfct value in
> nf_conntrack_in() function. Why? Because the tcp_in_window()
> considers the incoming skb as an invalid skb by returning
> NFCT_TCP_INVALID.
> 
> At last, the TCP layer process the out-of-window
> skb (client_ip,client_port,server_ip,a_port) and try to look up
> such an socket in tcp_v4_rcv(), as we can see, it will fail for sure
> because the port is a_port not our expected b_port and then send
> back an RST to the client.
> 
> The detailed call graphs go like this:
> 1)
> nf_conntrack_in()
>   -> nf_conntrack_handle_packet()
>     -> nf_conntrack_tcp_packet()
>       -> tcp_in_window() // tests if the skb is out-of-window
>       -> return -NF_ACCEPT;
>   -> skb->_nfct = 0; // if the above line returns a negative value
> 2)
> tcp_v4_rcv()
>   -> __inet_lookup_skb() // fails, then jump to no_tcp_socket
>   -> tcp_v4_send_reset()
> 
> The moment the client receives the RST, it will drop. So the RST
> skb doesn't hurt the client (maybe hurt some gateway which cancels
> the session when filtering the RST without validating
> the sequence because of performance reason). Well, it doesn't
> matter. However, we can see many strange RST in flight.
> 
> The key reason why I wrote this patch is that I don't think
> the behaviour is expected because the RFC 793 defines this
> case:
> 
> "If the connection is in a synchronized state (ESTABLISHED,
>  FIN-WAIT-1, FIN-WAIT-2, CLOSE-WAIT, CLOSING, LAST-ACK, TIME-WAIT),
>  any unacceptable segment (out of window sequence number or
>  unacceptible acknowledgment number) must elicit only an empty
>  acknowledgment segment containing the current send-sequence number
>  and an acknowledgment..."
> 
> I think, even we have set DNAT policy, it would be better if the
> whole process/behaviour adheres to the original TCP behaviour as
> default.
> 
> Suggested-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Jason Xing <kernelxing@tencent.com>
> ---
> v2
> Link: https://lore.kernel.org/netdev/20240307090732.56708-1-kerneljasonxing@gmail.com/
> 1. add one more test about NAT and then drop the skb (Florian)
> ---
>  net/netfilter/nf_conntrack_proto_tcp.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> index ae493599a3ef..19ddac526ea0 100644
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -1256,10 +1256,21 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
>  	case NFCT_TCP_IGNORE:
>  		spin_unlock_bh(&ct->lock);
>  		return NF_ACCEPT;
> -	case NFCT_TCP_INVALID:
> +	case NFCT_TCP_INVALID: {
> +		int verdict = -NF_ACCEPT;
> +
> +		if (ct->status & IPS_NAT_MASK)
> +			/* If DNAT is enabled and netfilter receives
> +			 * out-of-window skbs, we should drop it directly,

Yes, if _be_liberal toggle is disabled this can happen.

> +			 * or else skb would miss NAT transformation and
> +			 * trigger corresponding RST sending to the flow
> +			 * in TCP layer, which is not supposed to happen.
> +			 */
> +			verdict = NF_DROP;

One comment for the SNAT case.

nf_conntrack_in() calls this function from the prerouting hook. For
the very first packet, IPS_NAT_MASK might not be yet fully set on
(masquerade/snat happens in postrouting), then still one packet can be
leaked without NAT mangling in the SNAT case.

Rulesets should really need to set default policy to drop in NAT
chains to address this.

And after this update, user has no chance anymore to bump counters at
the end of the policy, to debug issues.

We have relied on the rule that "conntrack should not drop packets"
since the very beginning, instead signal rulesets that something is
invalid, so user decides what to do.

I'm ambivalent about this, Jozsef?

>  		nf_tcp_handle_invalid(ct, dir, index, skb, state);
>  		spin_unlock_bh(&ct->lock);
> -		return -NF_ACCEPT;
> +		return verdict;
> +	}
>  	case NFCT_TCP_ACCEPT:
>  		break;
>  	}
> -- 
> 2.37.3
> 
