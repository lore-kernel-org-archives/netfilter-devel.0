From: Pablo Cingolani <pcingola@uolsinectis.com>
Subject: ip_route_me_harder question...
Date: Wed, 26 Nov 2003 12:10:31 -0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031126121031.67a8265e.pcingola@uolsinectis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Refered to a question posted by "Zeeshan Ali <zeelists@yahoo.com>" a couple of days ago, I've suggested him to
use ip_route_me_harder after changing a packet's saddr/daddr (at NF_IP_PRE_ROUTING).
I've noticed that it doesn't work because after the hook changes the packet, ip_rcv_finish() calls
 skb->dst->input(skb) which seems to setted to something like 'dst_discard' (instead of 'ip_forward()' which is
what I was expecting).
Can someone give me a hint on what is wrong / what should be done to (correctly) change the routes 
so that the packet is forwarded? 
Thank you
   Pablo

P.S.: Packet's saddr is changed to a local one.
