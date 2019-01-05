From: "David R. Bild" <david.bild@xaptum.com>
Subject: Re: [nf-next] netfilter: Add support for inner IPv6 packet match
Date: Sat, 5 Jan 2019 17:34:26 -0600
Message-ID: <CAAi9uDvrz3=BjJufp+8m_yWBdKvLoK7dEe-L=wnQ0Lbn7uqHHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Jan 25, 2018 at 08:13:00PM, Pabel wrote:
> On Thu, Jan 18, 2018 at 04:13:25PM +0100, Ahmed Abdelsalam wrote:
> [...]
> > diff --git a/include/uapi/linux/netfilter_ipv6/ip6t_inner6.h b/include/uapi/linux/netfilter_ipv6/ip6t_inner6.h
> > new file mode 100644
> > index 0000000..7017fa4
> > --- /dev/null
> > +++ b/include/uapi/linux/netfilter_ipv6/ip6t_inner6.h
> > @@ -0,0 +1,21 @@
> > +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> > +#ifndef _IP6T_INNER6_H
> > +#define _IP6T_INNER6_H
> > +
> > +#include <linux/types.h>
> > +#include <linux/netfilter.h>
> > +
> > +/* Values for "invflags" field in struct ip6t_inner6 */
> > +#define IP6T_INNER6_INV_SRC 0x01
> > +#define IP6T_INNER6_INV_DST 0x02
> > +#define IP6T_INNER6_INV_MASK 0x03
> > +
> > +struct ip6t_inner6 {
> > + /* Source and destination addr of inner IPv6 packet */
> > + struct in6_addr inner_src, inner_dst;
> > + /* Mask for src and dest addr of inner IPv6 packet */
> > + struct in6_addr inner_smsk, inner_dmsk;
> > + __u8 invflags;
> > +};

> Matching at inner headers is a very useful, no doubt. Problem is that
> this approach is rather limited since it only allows for matching
> source and destination address at the inner header. I suspect someone
> else will follow up later on to add more fields to this, and we will
> end up having a new version of ip6tables... inside ip6t_inner6 :-).

> nf_tables is a much more flexible framework, we can store the offset
> of this inner header in nft_pktinfo on demand, add new base to
> nft_payload and have access to all matching capabilities from any
> arbitrary offset. I really think this new feature belongs there.

Ahmed, have you had a chance to follow-up on the nftables approach
suggested here?

We're looking to move some of our backbone network to SRv6, but
require nftables support for inner packets.

I can potentially help with implementation, but don't want to
duplicate any more recent work of yours.

Pablo, what syntax were you envisioning for nft match expressions?
Something like:

   <outer packet match expressions> inner <inner packet match expressions>

Nested inner packets could be handled by allowing repeated "inner
<expr>" clauses:

<outer expr> inner <middle expr> inner <inner expr>

etc.

Curious for your thoughts, since this support could be useful with a
variety of tunnel protocols, not just IPv6 segment routing.

Thanks,
David
