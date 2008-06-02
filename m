From: Patrick McHardy <kaber@trash.net>
Subject: Re: Fw: [PATCH net-2.6 1/2] [IPV4] [NETFILTER] Misc Cleanups.
Date: Mon, 02 Jun 2008 11:46:43 +0200
Message-ID: <4843C183.4060008@trash.net>
References: <20080601.234549.229050768.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, ramirose@gmail.com
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62720 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbYFBJqt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2008 05:46:49 -0400
In-Reply-To: <20080601.234549.229050768.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

David Miller wrote:
> Forwarding to netfilter-devel where this belongs...

Thanks.

> 	In this patch, these three fixes were made in net/ipv4/netfilter/ip_queue.c:
> 	
> 	1) No need to perform data_len = 0 in the switch command, since data_len
> 	   is initialized to 0 in the beginning of the method
> ,ipq_build_packet_message().
> 		
> 	2) We can reach nlmsg_failure only from one place; skb is sure to be NULL
> 	   when getting there; since skb is NULL, there is no need to check this fact
> 	   and call kfree_skb().
> 	
> 	3) Add #ifdef CONFIG_PROC_FS when removing the VFS entry,
>  		 proc_net_remove(&init_net, IPQ_PROC_FS_NAME);
> 	
> 
> Regards,
> Rami Rosen
> 
> 
> Signed-off-by: Rami Rosen <ramirose@gmail.com>

1) also affects ip6_queue and nfnetlink_queue
2) also affects ip6_queue
3) is unnecessary since proc_net_remove is a NOP without
    CONFIG_PROC_FS

Please update your patch to also change ip6_queue and
nfnetlink_queue where applicable. Thanks.


