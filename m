From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 3/3] netfilter: bridge: copy back VLAN header for
 bridge packet queued to userspace
Date: Sat, 23 Jan 2016 21:39:19 +0100
Message-ID: <20160123203919.GC17729@breakpoint.cc>
References: <1452847734-3766-1-git-send-email-stephane.ml.bryant@gmail.com>
 <1452847734-3766-4-git-send-email-stephane.ml.bryant@gmail.com>
 <20160115110218.GA2361@salvia>
 <20160115140412.GD7462@breakpoint.cc>
 <56A34851.8080800@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: =?iso-8859-15?Q?st=E9phane?= bryant <stephane.ml.bryant@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:57146 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754133AbcAWUjW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Jan 2016 15:39:22 -0500
Content-Disposition: inline
In-Reply-To: <56A34851.8080800@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

st=E9phane bryant <stephane.ml.bryant@gmail.com> wrote:
> On 01/15/2016 03:04 PM, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >> For the specific case of nfnetlink_queue, I would expose the vlan
> >> information through a new netlink attribute NFQA_VLAN (similar to =
what
> >> we do for NFQA_HWADDR for the layer 3).
> >=20
> > If we do this I think it does make sense to consider putting
> > the entire L2 mac header under its own attr too.
> >=20
> > This is especially good if we'd later add support for NETDEV
> > family.  Since drivers already pull the L2 header userspace
> > would not need to handle arbirary L2 protocols.
> >=20
> >>> +				payload +=3D VLAN_HLEN;
> >>> +				payload_len -=3D VLAN_HLEN;
> >>> +			} else {
> >>> +				entry->skb->vlan_tci &=3D ~VLAN_TAG_PRESENT;
> >>> +				entry->skb->protocol =3D veth->h_vlan_proto;
> >>> +			}
> >>> +		}
> >>
> >> I'm awar it's more work, but it would be good to reduce ifdef poll=
ution
> >> by placing all this bridge netfilter code wrapped into functions u=
nder
> >> one single ifdef in this file to improve maintainability.
> >=20
> > Right, but for anything family specifiy it would be even better to =
push
> > it into nf afinfo. In case thats too much work or too cumbersome (e=
=2Eg.
> > because you'd need 12 function arguments ...) then the ifdef-wrappe=
d
> > helper is fine of course.
>=20
> As the nf_afinfo saveroute/reroute hooks are called on the original
> packet skb, at a location where netlink attributes are not in existen=
ce,
> it only seems possible to use these hooks to hide the L2 code if we
> pull-in/pull out the L2 header into/from the original skb, and forego
> the new attributes -- which is fine by me as it is precisely what i w=
as
> doing in the original patches (albeit in a different location).

Yes.  Problem with push/pull is that it will be impossible to do packet
rewriting of the l2 header since we'd have to pull a different amount.

> If we use new netlink attributes (NFQA_VLAN, NFQA_L2HDR) we will have=
 to
> wrap them in a #ifder helper, it seems.

ifdef helper is fine.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
