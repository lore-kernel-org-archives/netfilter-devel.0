From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] NAT for unreplied connections
Date: Tue, 4 Jun 2002 15:01:06 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206041501.06434.hno@marasystems.com>
References: <3CFC7DCA.9030801@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Philip Craig <philipc@snapgear.com>,
	netfilter-devel@lists.samba.org
In-Reply-To: <3CFC7DCA.9030801@snapgear.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

The MASQUERADE target comes to mind here.. it is approaching the same problem 
from a different angle, and in my opinion a better one.. MASQUERADE kills all 
relevant conntrack entries when the interface changes, to deal cleanly with 
the situation of dynamic IP assignment where the IP may change while the 
netfilter kernel is running and actively tracking packets..

The main problem with your approach is retransmitted packets. As you tear down 
the conntrack entry on each retransmission until the connection has been 
reassured, the retransmitted packets may well have a different NAT tuple 
selected than the original one. If then the first packet reaches the origin 
server then you will be in trouble. This may well happen even without any 
rule change in NAT, simply as an effect of traffic pattern or a complex 
ruleset intentionally varying the NAT selection. Not very good. You need to 
have some other criteria to determine when it is safe to forget the NAT 
state.

Regards
Henrik

Philip Craig wrote:
> Hi,
>
> The nat table is only used for the first packet in each
> connection.  This poses a problem if the events such as the
> following occur:
>
> 1. TCP SYN packet sent, but no reply received.
>
> 2. iptables rules change or routing table changes such that
> the TCP SYN packet should be NATed differently.
>
> 3. TCP SYN packet resent, but is NATed using the conntrack
> created by the initial conntrack, and so it never reaches its
> destination, or the reply is never received.
>
> Currently, the only solution for this is to create a new
> connection, often requiring the application to be killed and
> restarted.  This can happen for UDP connections and pings
> too.
>
> I searched in the list archives and found one other person
> has noticed this problem too, but there were no replies:
>
> http://lists.samba.org/pipermail/netfilter-devel/2002-January/003166.html
>
> I've included a patch which changes the IP conntracking such
> that the conntrack is recreated if a packet is sent in the
> original direction before any replies are seen.
>
> This solves my current problems, but my testing is fairly
> minimal so far.  Can anyone see any problems with this patch,
> or have a better solution?
>
> One problem may be that since the new conntrack may not have
> the same source port as the original, UDP protocols that
> don't require replies immediately after the first packet may
> fail.
>
> Regards,
> Phil
>
>
> --- linux-2.4.x/net/ipv4/netfilter/ip_conntrack_core.c	2 Oct 2001 09:36:12
> -0000	1.1.1.2 +++ linux-2.4.x/net/ipv4/netfilter/ip_conntrack_core.c	4 Jun
> 2002 07:52:40 -0000	1.3 @@ -584,6 +584,16 @@
>
>   	/* look for tuple match */
>   	h = ip_conntrack_find_get(&tuple, NULL);
> +
> if (h && !(h->ctrack->status & IPS_SEEN_REPLY)
> +
> 		&& DIRECTION(h) == IP_CT_DIR_ORIGINAL) {
> +
> 	/* No reply yet, so recreate the conntrack in case the
> +
> 	   NAT rules have changed. */
> +
> 	if (del_timer(&h->ctrack->timeout)) {
> +
> 		death_by_timeout((unsigned long)h->ctrack);
> +
> 		ip_conntrack_put(h->ctrack);
> +
> 		h = NULL;
> +
> 	}
> +
> }
>   	if (!h) {
>   		h = init_conntrack(&tuple, proto, skb);
>   		if (!h)
