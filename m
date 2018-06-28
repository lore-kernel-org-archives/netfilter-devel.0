From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2 net-next 0/2] net: preserve sock reference when
 scrubbing the skb.
Date: Thu, 28 Jun 2018 22:21:56 +0900 (KST)
Message-ID: <20180628.222156.1257330145207562337.davem@davemloft.net>
References: <20180627133426.3858-1-fbl@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com, pabeni@redhat.com,
        fw@strlen.de, netfilter-devel@vger.kernel.org
To: fbl@redhat.com
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180627133426.3858-1-fbl@redhat.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Flavio Leitner <fbl@redhat.com>
Date: Wed, 27 Jun 2018 10:34:24 -0300

> The sock reference is lost when scrubbing the packet and that breaks
> TSQ (TCP Small Queues) and XPS (Transmit Packet Steering) causing
> performance impacts of about 50% in a single TCP stream when crossing
> network namespaces.
> 
> XPS breaks because the queue mapping stored in the socket is not
> available, so another random queue might be selected when the stack
> needs to transmit something like a TCP ACK, or TCP Retransmissions.
> That causes packet re-ordering and/or performance issues.
> 
> TSQ breaks because it orphans the packet while it is still in the
> host, so packets are queued contributing to the buffer bloat problem.
> 
> Preserving the sock reference fixes both issues. The socket is
> orphaned anyways in the receiving path before any relevant action,
> but the transmit side needs some extra checking included in the
> first patch.
> 
> The first patch will update netfilter to check if the socket
> netns is local before use it.
> 
> The second patch removes the skb_orphan() from the skb_scrub_packet()
> and improve the documentation.
> 
> ChangeLog:
> - split into two (Eric)
> - addressed Paolo's offline feedback to swap the checks in xt_socket.c
>   to preserve original behavior.
> - improved ip-sysctl.txt (reported by Cong)

Series applied, thanks Flavio.
