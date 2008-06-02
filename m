From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH net-2.6] [NETFILTER] Misc Cleanups.
Date: Mon, 02 Jun 2008 13:18:50 +0200
Message-ID: <4843D71A.5090107@trash.net>
References: <20080601.234549.229050768.davem@davemloft.net>	 <4843C183.4060008@trash.net> <eb3ff54b0806020411p16531d2chb05061a6d209b406@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Rami Rosen <ramirose@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759461AbYFBLTR@vger.kernel.org>
In-Reply-To: <eb3ff54b0806020411p16531d2chb05061a6d209b406@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Rami Rosen wrote:
> Hi,
>   - Thanks for your comments; I was not aware that this issues occur
> in other places too; attached here is another patch, fixing where
> applicable in ip6_queue and nfnetlink_queue.
> 
>   1) in net/ipv6/netfilter/ip6_queue.c
>     - No need to perform data_len = 0 in the switch command, since data_len
> 	   is initialized to 0 in the beginning of the
> ipq_build_packet_message() method
>     - We can reach nlmsg_failure only from one place; skb is sure to be NULL
> 	     when getting there; since skb is NULL, there is no need to check this fact
> 	     and call kfree_skb().
> 
> 2) in net/netfilter/nfnetlink_queue.c:
>     - No need to perform data_len = 0 in the switch command, since data_len
> 	   is initialized to 0 in the beginning of the
> nfqnl_build_packet_message() method
> 
> (Note: here, as opposed to previous patch, nlmsg_failure must check
> skb and free it if it is not NULL, so the call to kfree_skb() is
> needed , so it is not removed)


I've queued this patch and the previous one (without the procfs
bits) as one combined patch for 2.6.27, thanks.
