From: Diadon <diadon@isfera.ru>
Subject: Netfilter problem with new 2.4.22
Date: Thu, 18 Sep 2003 13:14:48 +0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F697788.8080103@isfera.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@lists.netfilter.org
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

More new info about this problem.

When I get ipt_REJECT.c from 2.4.21 and replace ipt_REJECT.c in 2.4.22, 
problem has disappeared. So when I compare two files ipt_REJECT.c from 
different versions of kernel:

3a4
 >  * Added support for ICMP type-3-code-13 (Maciej Soltysiak). [RFC 1812]
35a37,76
 > static inline struct rtable *route_reverse(struct sk_buff *skb, int 
local)
 > {
 >       struct iphdr *iph = skb->nh.iph;
 >       struct dst_entry *odst;
 >       struct rt_key key = {};
 >       struct rtable *rt;
 >
 >       if (local) {
 >               key.dst = iph->saddr;
 >               key.src = iph->daddr;
 >               key.tos = RT_TOS(iph->tos);
 >
 >               if (ip_route_output_key(&rt, &key) != 0)
 >                       return NULL;
 >       } else {
 >               /* non-local src, find valid iif to satisfy
 >                * rp-filter when calling ip_route_input. */
 >               key.dst = iph->daddr;
 >               if (ip_route_output_key(&rt, &key) != 0)
 >                       return NULL;
 >
 >               odst = skb->dst;
 >               if (ip_route_input(skb, iph->saddr, iph->daddr,
 >                                  RT_TOS(iph->tos), rt->u.dst.dev) != 0) {
 >                       dst_release(&rt->u.dst);
 >                       return NULL;
 >               }
 >               dst_release(&rt->u.dst);
 >               rt = (struct rtable *)skb->dst;
 >               skb->dst = odst;
 >       }
 >
 >       if (rt->u.dst.error) {
 >               dst_release(&rt->u.dst);
 >               rt = NULL;
 >       }
 >
 >       return rt;
 > }
 >
66,69c107
<       /* Routing: if not headed for us, route won't like source */
<       if (ip_route_output(&rt, oldskb->nh.iph->saddr,
<                           local ? oldskb->nh.iph->daddr : 0,
<                           RT_TOS(oldskb->nh.iph->tos), 0) != 0)
---
 >       if ((rt = route_reverse(oldskb, local)) == NULL)
332a371,373
 >       case IPT_ICMP_ADMIN_PROHIBITED:
 >               send_unreach(*pskb, ICMP_PKT_FILTERED);
 >               break;




As I think problem in new new route_reverse function which called from 
tcp_reset() procedure

So any new ideas?


 > Subject:
 > Netfilter problem with new 2.4.22
 > From:
 > Diadon <diadon@isfera.ru>
 > Date:
 > Tue, 16 Sep 2003 14:22:37 +0400
 > To:
 > linux-kernel@vger.kernel.org

 > After installing 2.4.22
 > this chain doesn't work
 > $IPPROG -A OUTPUT -p tcp --dport 113 -j REJECT --reject-with tcp-reset

 > On 2.4.21 all works fine
 > In tcpdump on 2.4.21:
 > 14:41:41.752557 somehost.auth > somehost1.32825: R 0:0(0) ack 
217583467 win 0 (DF)

 > In tcpdump on 2.4.22:
 > nothing.......


 > any ideas?
