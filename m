From: Christoph Paasch <christoph.paasch@gmail.com>
Subject: Re: [PATCH] netfilter: don't track ICMPv6 negotiation message.
Date: Mon, 9 Feb 2009 18:39:28 +0100
Message-ID: <200902091839.29175.christoph.paasch@gmail.com>
References: <200901271007.n0RA78k6023294@toshiba.co.jp> <200902061130.29873.christoph.paasch@student.uclouvain.be> <498F17EA.1030907@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, yasuyuki.kozakai@toshiba.co.jp,
	kaber@trash.net
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:61568 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbZBIRjg convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:39:36 -0500
Received: by yx-out-2324.google.com with SMTP id 8so38793yxm.1
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Feb 2009 09:39:35 -0800 (PST)
In-Reply-To: <498F17EA.1030907@inl.fr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

thanks for your reply.
On Sun February 8 2009, Eric Leblond wrote:
> Hi,
>
> Christoph Paasch a =E9crit :
> > Why do you set skb->nfctinfo =3D IP_CT_NEW?
> > Because in xt_state.c, at state_mt(...) :
> > 	if it is in front of an untracked packet (using nf_ct_is_untracked=
(skb))
> > it automatically sets the statebit to UNTRACKED and so the IP_CT_NE=
W
> > isn't used.
>
> Not much to say on that point. I wanted to be homogeneous with what i=
s
> done in xt_NOTRACK.c.
OK.

But then I'm asking me, why does the UNTRACKED state isn't documented i=
n the=20
iptables manpage, even if this one exists for the iptables state module=
? As=20
those ICMPv6 messages will be recognized as UNTRACKED by xt_state.c, an=
d so=20
the firewall administrator needs to allow those kind of packets.

But well, this is more an issue of the iptables manpage, ...

>
> > Why do you return NF_ACCEPT and not -NF_ACCEPT?
> > By returning a positiv value, the packet will continue it's way thr=
ough
> > the connection tracker.
>
> If I understand well, icmpv6_error will be called in nf_conntrack_cor=
e.c
> as l4proto->error :
>
> 	if (l4proto->error !=3D NULL) {
> 		ret =3D l4proto->error(net, skb, dataoff, &ctinfo, pf, hooknum);
> 		if (ret <=3D 0) {
> 			NF_CT_STAT_INC_ATOMIC(net, error);
> 			NF_CT_STAT_INC_ATOMIC(net, invalid);
> 			return -ret;
> 		}
> 	}
>
> It will thus increment error counters if return is -NF_ACCEPT. As the
> packets we deal with are not error I don't think it is correct to ret=
urn
> -NF_ACCEPT.
>
> But I agree with the fact, that returning NF_ACCEPT leads to some
> useless work inside the kernel.

The packet will then go up to the call to icmpv6_new (as the connection=
=20
tracker will still look for a connection matching the tuple):

	if (type < 0 || type >=3D sizeof(valid_new) || !valid_new[type]) {
		/* Can't create a new ICMPv6 `conn' with this. */
		pr_debug("icmpv6: can't create new conn with type %u\n",
			 type + 128);
		nf_ct_dump_tuple_ipv6(&ct->tuplehash[0].tuple);
		return false;
	}

And then the invalid counter will get incremented in nf_conntrack_in(..=
=2E):

	ct =3D resolve_normal_ct(net, skb, dataoff, pf, protonum,
			       l3proto, l4proto, &set_reply, &ctinfo);
	if (!ct) {
		/* Not valid part of a connection */
		NF_CT_STAT_INC_ATOMIC(net, invalid);
		return NF_ACCEPT;
	}

So, maybe the handling of the ICMPv6 negotiation messages should get mo=
ved to=20
icmpv6_new, with a more descriptive pr_debug message than the one who i=
s=20
present.

--
Christoph Paasch

www.rollerbulls.be
--
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
