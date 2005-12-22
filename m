From: "David S. Miller" <davem@davemloft.net>
Subject: please fix TARPIT
Date: Wed, 21 Dec 2005 22:15:52 -0800 (PST)
Message-ID: <20051221.221552.70499588.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


Recently it was reported that the TARPIT target depends upon the
sysctl_ip_default_ttl symbol which is not exported any longer.

Any use is illegal, because the TTL is a property of a route and
should thus be obtained from the RTAX_HOPLIMIT metric.  The only
valid reference is in the ipv4 routing code where it sets the
default value of this route metric.

So, tarpit_tcp() should compute 'nrt' a little earlier and then grab
the RTAX_HOPLIMIT dst metric to store into nskb->nh.iph->ttl field.
(as a side note it should probably use pskb_may_pull() and skb_unshare()
 instead of the dangerously hand-crafted stuff it's using there, skb_copy()
 is overkill especially for non-local packets on a firewall/router, and
 yeah there seems to be nf_debug references in there too :-).

Wheee, there's also a copy of ip_finish_output2() in there as well.
It should probably use dst_output() so that paths over IPSEC and
things like that work.

If someone could take care of this (bonus points for grepping other
code in patch-o-matic for references to this sysctl_ip_default_ttl
symbol) I would really appreciate it.

Thanks.
