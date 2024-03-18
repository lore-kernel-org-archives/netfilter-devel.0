Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CF71EB4A;
	Mon, 18 Mar 2024 20:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710792974; cv=none; b=J/tk47B3cuW0NaAaGPnGzzXP8Ohm07xPdp2i2nav0ywnzT9uQJVbCr95kGc1n7neMXvdhogcUY4nJxiQhs/TYfe6KH3SenKfL9cdTYpvXBcLj8IhLv3+rujsjN0beoz9oLIubTQj/kf7WXtt+4Rp5suZ0/spnspcAb75e+/tQ1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710792974; c=relaxed/simple;
	bh=gg9yhJE2tKWPbbcf6g5GK2oT2v1wCetzwojpd2WVCkY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mZ85vI4LeMdKV8aNdoqqcsK4ffAoSJdeCZNNPPy6tyc1RRM/IiWAS00jO4nJTGURd3n4ebTnMyqpvWaKEspvpDmi09rJ1fekhh3zBisQIw2lFLk4kgfD0ZUAhaMS3VIE8sfD3KXLueUcdytBwpjREQ9N9luljjw7aN8IlzQ++DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fmxU1QKr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fmxU1QKr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8118C433F1;
	Mon, 18 Mar 2024 20:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710792973;
	bh=gg9yhJE2tKWPbbcf6g5GK2oT2v1wCetzwojpd2WVCkY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fmxU1QKrhCBFklyRsBhey4NREh5F75+rKNal5351ToUkUx+qkjqH8ZD1oCEbVA5hE
	 MWUnZ3DadB1/5gwTYj/+BouD0ADixy0wikoxpcDS7k+7rIAGm2Z4hNU61GpMwbptaa
	 6UnXEyfPPvCrB1NOQiI2z44WN1YIUj1mvesJBaMMwCSfme2i9fHm+tgCpEabITSdZf
	 iLI83IktSzZrorvnrmdOGY2qY7z2ABFq3LKtZnriLKp+0utUvkbX2oZ4E6NMpy2sye
	 xj63iKbCywpGgNmiJZa50Ne4c4UQl1QrcQwoguoeN6zVaclpX1kAVKzccMJGu7b32r
	 g0ECxwgugO8Gw==
Date: Mon, 18 Mar 2024 20:16:08 +0000
From: Simon Horman <horms@kernel.org>
To: Jason Xing <kerneljasonxing@gmail.com>
Cc: edumazet@google.com, pablo@netfilter.org, kadlec@netfilter.org,
	fw@strlen.de, kuba@kernel.org, pabeni@redhat.com,
	davem@davemloft.net, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH nf-next v2] netfilter: conntrack: avoid sending RST to
 reply out-of-window skb
Message-ID: <20240318201608.GC185808@kernel.org>
References: <20240311070550.7438-1-kerneljasonxing@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Not for those following along, it appears that RFC 793 does misspell
unacceptable as above. Perhaps spelling was different in 1981 :)

>  acknowledgment segment containing the current send-sequence number
>  and an acknowledgment..."
> 
> I think, even we have set DNAT policy, it would be better if the
> whole process/behaviour adheres to the original TCP behaviour as
> default.
> 
> Suggested-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Jason Xing <kernelxing@tencent.com>

...
