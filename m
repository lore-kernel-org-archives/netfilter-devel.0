From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net] ipv4: set transport header earlier
Date: Tue, 16 Jul 2013 06:56:26 -0700
Message-ID: <1373982986.10804.106.camel@edumazet-glaptop>
References: <1373943799.10804.96.camel@edumazet-glaptop>
	 <51E549A0.206@cogentembedded.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>,
	netdev <netdev@vger.kernel.org>,
	Neal Cardwell <ncardwell@google.com>,
	netfilter-devel@vger.kernel.org, Tom Herbert <therbert@google.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <51E549A0.206@cogentembedded.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2013-07-16 at 17:24 +0400, Sergei Shtylyov wrote:
> > +	skb->transport_header = skb->network_header + iph->ihl*4;
> 
>     Spaces around * wouldn't hurt, to be consistent with the rest of the 
> statement and the Linux style in common.

I am well aware of this, I chose the convention used in this function
and file.

# grep ihl net/ipv4/ip_input.c
	opt->optlen = iph->ihl*4 - sizeof(struct iphdr);
	if (iph->ihl > 5 && ip_rcv_options(skb))
	if (iph->ihl < 5 || iph->version != 4)
	if (!pskb_may_pull(skb, iph->ihl*4))
	if (unlikely(ip_fast_csum((u8 *)iph, iph->ihl)))
	} else if (len < (iph->ihl*4))

Thanks
