From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: ipq+AF8-set+AF8-verdict problem in bridge+-iptables
Date: Wed, 16 Jul 2003 19:49:53 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200307161949.54239.bdschuym@pandora.be>
References: <001e01c34b36$f8e94460$8101a8c0@dev>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-7"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Yong" <sdssly@sina.com>, "Harald Welte" <laforge@netfilter.org>
In-Reply-To: <001e01c34b36$f8e94460$8101a8c0@dev>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wednesday 16 July 2003 03:09, Yong wrote:
>  I want to use the iptable_queue in bridge+-iptables environment. I can get
> the packet in userspace using -j QUEUE command. However, If I change the
> packet size. for example, I change the ping icmp packet size to 400, the
> packet Ethernet header is changed. In my test, the MAC address is changed
> to 0xffffffffff. I can capture this packet using sniffer tool. Since the
> MAC address is changed, the other computer cannot receive the ICMP packet.

>  It seems that the bridge iptables patch changed something in the function
> ipq_set_verdict().

Please test the patch below.

cheers,
Bart

--- linux-2.6.0-test1/net/ipv4/netfilter/ip_queue.c.old	2003-07-16 19:35:07.000000000 +-0200
+-+-+- linux-2.6.0-test1/net/ipv4/netfilter/ip_queue.c	2003-07-16 19:39:05.000000000 +-0200
@@ -353,6 +-353,11 @@ ipq_mangle_ipv4(ipq_verdict_msg_t *v, st
 			}
 			if (e->skb->sk)
 				skb_set_owner_w(newskb, e->skb->sk);
+-#if defined(CONFIG_BRIDGE) || defined(CONFIG_BRIDGE_MODULE)
+-			/* bridged packets already have their Ethernet header */
+-			if (e->skb->nf_bridge)
+-				memcpy(newskb->data - 16, e->skb->data - 16, 16);
+-#endif
 			kfree_skb(e->skb);
 			e->skb = newskb;
 		}
