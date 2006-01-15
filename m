From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] fix nf_conntrack_netlink expectation dumping/event
 notification
Date: Sun, 15 Jan 2006 22:07:39 +0900 (JST)
Message-ID: <200601151307.k0FD7evx014168@toshiba.co.jp>
References: <43C76D22.8050805@trash.net>
	<200601130938.k0D9c6ud007984@toshiba.co.jp>
	<43C78C3C.6080707@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@netfilter.org
In-Reply-To: <43C78C3C.6080707@netfilter.org>
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


Hi, Pablo,

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 13 Jan 2006 12:17:16 +0100

> Yasuyuki KOZAKAI wrote:
> > diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> > index 62bb509..9a147dd 100644
> > --- a/net/netfilter/nf_conntrack_core.c
> > +++ b/net/netfilter/nf_conntrack_core.c
> > @@ -188,7 +188,7 @@ extern struct nf_conntrack_protocol nf_c
> >  struct nf_conntrack_protocol *
> >  __nf_ct_proto_find(u_int16_t l3proto, u_int8_t protocol)
> >  {
> > -	if (unlikely(nf_ct_protos[l3proto] == NULL))
> > +	if (unlikely(l3proto > AF_MAX || nf_ct_protos[l3proto] == NULL))
> 
> Could the unlikely statement be bad at expectation dumping?

Indeed. But please let me think about this some more.
I feel strange to find l3proto with 0xffff as address family or to find proto
with 0xff as protocol number.

After all, ctnetlink_dump_tuples() gets nf_conntrack_l3proto_generic /
nf_conntrack_proto_generic and they doesn't fill any contents, right ?

If so, I think that it's better to make ctnetlink_exp_dump_expect() use
l3proto/proto for &exp->tuple to dump &exp->mask, and then
we would not need to remove above unlikely().

Regards,

-- Yasuyuki Kozaki
