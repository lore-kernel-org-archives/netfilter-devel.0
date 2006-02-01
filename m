From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: expectation mask handling in nfctnetlink
Date: Wed, 01 Feb 2006 22:35:17 +0900 (JST)
Message-ID: <200602011335.k11DZH7W024485@toshiba.co.jp>
References: <200601200457.k0K4vvAI001787@toshiba.co.jp>
	<43E01851.4040306@netfilter.org> <43E095A2.1040908@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	yasuyuki.kozakai@toshiba.co.jp, pablo@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <43E095A2.1040908@trash.net> <43C78C3C.6080707@netfilter.org>
	<200601151307.k0FD7evx014168@toshiba.co.jp>
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


Hi,

From: Patrick McHardy <kaber@trash.net>
Date: Wed, 01 Feb 2006 12:04:02 +0100

> Pablo Neira Ayuso wrote:
> > a) just remove the unlikely() statement.
> > Drawback: Not so efficient, since that checking isn't always required.
> 
> I'm not sure I understand the problem. Is it about the unlikely in
> __nf_ct_proto_find?

Yes.

>                     That one is most likely not making any difference
> at all, since there is no code to reorder.

Pablo pointed out ...

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

I thought unlikely() was ok but current ctnetlink_exp_dump_expect() was
strange because it trys to find proto with 0xffff as address family and 0xff
as protocol number.

But I understood from Pablo's mail, that we have not decided what contents
should be included in netlink message for expectation mask yet, then I agreed
to remove unlikely() for now.

-- Yasuyuki Kozakai
