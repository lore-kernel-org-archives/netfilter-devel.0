From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: RE: [PATCH] xt_gateway match
Date: Tue, 5 Jun 2007 12:16:12 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0706051213450.20829@yvahk01.tjqt.qr>
References: <200706041133.l54BXqv07802@server1.secure-linux-server.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
To: Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200706041133.l54BXqv07802@server1.secure-linux-server.com>
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

On Jun 4 2007 11:14, Amin Azez wrote:
>
>Thanks for looking at this, Jan. I'm away from a testing box right now, 
>but I think you got a test wrong. The gateway test is meant to exclude 
>cases where the neighbour table matches AND the daddr matches, because 
>that means the packet wasn't routed to that target AS a gateway.
>
>For nexthop we don't want to match daddr regardless, only if it is also 
>matching the neighbor table.
>
>Gateway: match neighbourtable and not match daddr
>Nexthop: match neighbour table.

Ok I am a bit narrow on this, anyway, I checked again and it looks like, 
yes, there was something wrong. I fixed it to:

	if (memcmp(&info->gateway, &neigh->primary_key, tbl->key_len) != 0)
		return false;
	if (!(info->flags & XT_GATEWAY_ROUTE))
		return true;
	iph = ip_hdr(skb);
	if (iph->daddr != info->gateway)
		return true;
	return false;

which should be matching

memcmp(&info->gateway, &skb->dst->neighbour->primary_key,
	skb->dst->neighbour->tbl->key_len) == 0 &&
((info->flags & IPT_GATEWAY_ROUTE) == 0 || iph->daddr != info->gateway)

Will resend with that.


	Jan
-- 
