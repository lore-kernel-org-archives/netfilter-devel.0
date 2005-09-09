From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_conntrack/ip_conntrack disrepencies
Date: Fri, 09 Sep 2005 17:08:53 +0200
Message-ID: <4321A585.5050205@trash.net>
References: <dfs7qs$o54$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <dfs7qs$o54$1@sea.gmane.org>
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

Amin Azez wrote:
> in nf_conntrack_tuple.h we have:
> static inline int nf_ct_tuple_src_equal(const struct nf_conntrack_tuple *t1,
>                                         const struct nf_conntrack_tuple *t2)
> {
>         return (t1->src.u3.all[0] == t2->src.u3.all[0] &&
>                 t1->src.u3.all[1] == t2->src.u3.all[1] &&
>                 t1->src.u3.all[2] == t2->src.u3.all[2] &&
>                 t1->src.u3.all[3] == t2->src.u3.all[3] &&
>                 t1->src.u.all == t2->src.u.all &&
>                 t1->src.l3num == t2->src.l3num &&
>                 t1->dst.protonum == t2->dst.protonum);
> }
> 
> In ip_conntrack_tuple.h we have:
> static inline int ip_ct_tuple_src_equal(const struct ip_conntrack_tuple *t1,
>                                         const struct ip_conntrack_tuple *t2)
> {
>         return t1->src.ip == t2->src.ip
>                 && t1->src.u.all == t2->src.u.all;
> }
> 
> 
> nf_conntrack compares the dst.protonum (makes sense) but the
> ip_conntrack doesn't. Is there the danger of ip_conntrack selecting
> wrong matching tuples sometimes? Perhaps only in the rare case where the
> hashes also match (unlikely) but I thought I would point this out.

The only place where it is used in ip_conntrack is ip_ct_tuple_equal,
which also compares the dst tuple. I guess its the same in nf_conntrack,
so it could probably changed.

> Does protonum really belong in the dst member? Correspondingly, for
> nf_conntrack, does l3num really belong in src?

Not really, but it saves room. The compiler pads src and dst to
a multiple of 32 bit, so there are two bytes room.

> The final thing that troubles me is that the dst member seems to have
> things unrelated, like "dir" and "protonum", why are these part of
> nf_conntrack_tuple.dst and not the top level nf_conntrack_tuple struct?

See above.
