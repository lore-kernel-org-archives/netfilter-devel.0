From: Patrick McHardy <kaber@trash.net>
Subject: Re: Netfilter Connection Tracking Race Condition in Kernel 2.4.x
Date: Tue, 25 Jul 2006 03:07:24 +0200
Message-ID: <44C56ECC.3020107@trash.net>
References: <44C56653.10901@nominum.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Bob Halley <Bob.Halley@nominum.com>
In-Reply-To: <44C56653.10901@nominum.com>
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

Bob Halley wrote:
> This is bugzilla 495, resent to netfilter-devel by request.

Thanks.

> Background
> 
> Our application uses ip_queue in prerouting to divert DNS UDP packets
> to a userland daemon which inspects them and then issues a NF_ACCEPT
> or NF_DROP verdict back to the kernel.
> 
> We found that if several packets with the same conntrack tuple,
> i.e. the same src addr, src port, dst addr, and dst port, arrive very
> close together, then only the first one accepted by our software
> actually makes it back out to the wire; the others are silently
> dropped.
> 
> 
> Analysis
> 
> We instrumented the kernel to find out where the drop was occurring.
> The code doing the dropping was ip_refrag() in
> net/ipv4/netfilter/ip_conntrack_standalone.c, specifically:
> 
>       /* We've seen it coming out the other side: confirm */
>       if (ip_confirm(hooknum, pskb, in, out, okfn) != NF_ACCEPT)
>               return NF_DROP;
> 
> The dropping is caused by a race between the first packet of a given
> tuple making it to confirmed state, and the arrival of another packet
> with the same tuple.  If a second packet arrives before the first is
> confirmed, it is assigned a new connection tracking context instead of
> joining that of the first unconfirmed packet.  When the second packet
> is finally handled by ip_refrag(), the call to ip_confim() finds that
> there is already a confirmed entry in the table, and returns NF_DROP.
> From the comments in __ip_contrack_confirm(), we infer that this is to
> deal with duplicated datagrams and some REJECT case, but it's the
> wrong thing in this case because the subsequent packets are neither
> duplicates nor REJECTs.
> 
> We were using RHEL 3 kernel 2.4.21-40 initially.  We looked at later
> 2.4.x kernels and found some promising looking changes, namely the
> addition of an unconfirmed list, in more recent 2.4.x kernels.  We built
> a 2.4.32 kernel and tested it, but the problem remained.  We looked into
> the nature of the unconfirmed list and discovered that it was solving a
> different problem, but could be a useful starting point for a fix.
> 
> 
> Fix
> 
> We decided to eliminate the race by having subsequent packets with the
> same conntrack tuple join the conntrack context of the first packet
> instead of creating a new conntrack context for each of them.  Here's
> the patch:
> 
> --- linux-2.4.32/net/ipv4/netfilter/ip_conntrack_core.c.orig  
> 2005-04-03 18:42:20.000000000 -0700
> +++ linux-2.4.32/net/ipv4/netfilter/ip_conntrack_core.c    2006-07-24
> 13:23:25.000000000 -0700
> @@ -777,6 +777,14 @@
>    /* look for tuple match */
>    h = ip_conntrack_find_get(&tuple, NULL);
>    if (!h) {
> +        READ_LOCK(&ip_conntrack_lock);
> +        h = LIST_FIND(&unconfirmed, conntrack_tuple_cmp,
> +                  struct ip_conntrack_tuple_hash *, &tuple, NULL);
> +        if (h)
> +            atomic_inc(&h->ctrack->ct_general.use);
> +        READ_UNLOCK(&ip_conntrack_lock);
> +    }
> +    if (!h) {
>        h = init_conntrack(&tuple, proto, skb);
>        if (!h)
>            return NULL;
> 
> This patch reliably ends the race, and we no longer have mysteriously
> disappearing packets.  Not being netfilter experts, we're not certain
> that this patch has no other side effects, and would appreciate any
> advice or alternative fixes that people who know more than we do have
> to offer.

The patch itself still contains a race, when a conntrack is confirmed
between the hash lookup and the unconfirmed lookup, it will still
create a new conntrack entry. About the general concept:

Using the unconfirmed lists looks like the only way to do this
besides changing the conntrack of the packet after noticing a
clash, but this would get tricky as the packets could already
cause state transitions or need sequence number adjustments.
Walking the unconfirmed list (which should usually only be very
small, but can grow large with queueing) for every new connection
sounds like a too large performance impact, so at least we need to
use a hash instead. Unfortunately its hard to specify a reasonable
size since it purely depends on userspace. The two other choices I
see are:

- confirm entries manually (using a target) or automatically
  before queueing packets. Not a good choice IMO since dropped
  connections will stay in the hash table until timeing out.

- change conntrack to always put connections in the hash immediately
  and remove them again if the connection is dropped before beeing
  confirmed.

The last option looks like the best to me for 2.6 (but could be
tricky to implement, haven't looked at that code in a while).
For 2.4 I think all these possibilities are too intrusive, you
probably need to maintain this patch yourself.

Any better suggestions?
