From: Jon <jon_webb@binary-one.com>
Subject: Re: ip_route_me_harder question...
Date: Wed, 26 Nov 2003 12:19:34 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FC50AD6.7080105@binary-one.com>
References: <20031126121031.67a8265e.pcingola@uolsinectis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Cingolani <pcingola@uolsinectis.com>
In-Reply-To: <20031126121031.67a8265e.pcingola@uolsinectis.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a good question. I've noticed that sometimes it's needed and 
sometimes it isn't. We implemented a routing protocol where all the 
packets were bumped up to userspace and after fiddling with the routing 
system for a long time, we ended up using some code from iproute2 to 
change the table before reinjecting the packet (unmodified). This 
alleviated our route_me_harder() issues. But another protocol we were 
looking at during our implementation used route_me_harder() and it 
seemed to work fine. Very confusing.

Regards,
Jon Webb
Computer Communications Research Group
University of California at Santa Cruz

Pablo Cingolani wrote:

>Refered to a question posted by "Zeeshan Ali <zeelists@yahoo.com>" a couple of days ago, I've suggested him to
>use ip_route_me_harder after changing a packet's saddr/daddr (at NF_IP_PRE_ROUTING).
>I've noticed that it doesn't work because after the hook changes the packet, ip_rcv_finish() calls
> skb->dst->input(skb) which seems to setted to something like 'dst_discard' (instead of 'ip_forward()' which is
>what I was expecting).
>Can someone give me a hint on what is wrong / what should be done to (correctly) change the routes 
>so that the packet is forwarded? 
>Thank you
>   Pablo
>
>P.S.: Packet's saddr is changed to a local one.
>
>  
>
