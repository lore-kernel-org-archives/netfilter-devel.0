From: Ryan Hagelstrom <rhagelstrom@atcorp.com>
Subject: Setting sk_buff->dst
Date: Wed, 12 Feb 2003 13:31:26 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <01C2D29B.0B49B960.rhagelstrom@atcorp.com>
Reply-To: "rhagelstrom@atcorp.com" <rhagelstrom@atcorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "netfilter-devel@lists.netfilter.org"
	 <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

I'm trying to send out packets from the kernel level from my module. I have 
the packet built correctly and I have a net_device that I'd like to send 
the packet out on. From what I have been playing around with it appears 
that the dst field needs to be filled out correctly for the packet to be 
sent over the wire. I set the dst field currently with the following code 
but in setting that field it seems that it selects the device to send out 
on as well.

I'm curious if there is a method to specifiy the device to output on 
reguardless of what   ip_route_output_key() sets up or without calling that 
function at all? If not is there a way to manually modify the routing table 
within my module?

Thanks

Ryan Hagelstrom

	struct rtable *rt;
	struct rt_key key = { dst:iph->daddr,
			src:iph->saddr,
			oif:skb->sk ? skb->sk->bound_dev_if : 0,
			tos:RT_TOS(iph->tos)|RTO_CONN,
  };

  if (ip_route_output_key(&rt, &key) != 0)
  {
    return -EINVAL;
  }
  dst_release(skb->dst);

  skb->dst = &rt->u.dst
	
	dev = skb->dst->dev;
	dst = skb->dst;
	hh = dst->hh;
	ip = skb->nh.iph;
	skb->dev = dev;

	if (hh)
	{
		read_lock_bh(&hh->hh_lock);
		memcpy(skb->data - 16, hh->hh_data, 16);
		read_unlock_bh(&hh->hh_lock);
		skb_push(skb, hh->hh_len);
		return hh->hh_output(skb);
	}

	else if (dst->neighbour)
		return dst->neighbour->output(skb);
