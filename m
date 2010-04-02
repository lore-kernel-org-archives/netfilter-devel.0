From: "Gareth Williams" <gwilliams@ubicom.com>
Subject: RE: br_netfilter post routing hook question...
Date: Fri, 2 Apr 2010 10:42:56 -0700
Message-ID: <CB2DD11991B27C4F99935E6229450D320566ACAE@STORK.scenix.com>
References: <CB2DD11991B27C4F99935E6229450D320566AC7B@STORK.scenix.com> <v2q861e3bca1004021026kc7bba6p1a4b615a46e48c29@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <netfilter-devel@vger.kernel.org>
To: "agashi shipora" <gashipo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from server70a.appriver.com ([69.20.116.35]:4258 "EHLO
	server70.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752363Ab0DBSnr convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Apr 2010 14:43:47 -0400
Content-class: urn:content-classes:message
In-Reply-To: <v2q861e3bca1004021026kc7bba6p1a4b615a46e48c29@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The product is a router and the bridge (br0) is connecting the lan to w=
lan.  The module only wants to examine packets on the bridge for qos pu=
rposes - to wlan and so I can, at the bridge layer, check for packets t=
o/from ath0 (the wireless port).  At PF_INET I would only see br0 so my=
 qos scope would be too wide.

TBH I wondered if I could have implemented a qdisc on ath0 and that mig=
ht have been more efficient to track packets to/from wlan.  Though I do=
n't know if qdisc can monitor rx packets - I know they can do tx as I h=
ave implemented them before.

The forward path would also expose me (at pf_inet) to wan<->bridge traf=
fic too - I am conscious of the exposure to traffic volume and slowing =
the system down - I have a performance target to hit and am struggling =
to do so at the moment.

But I am also new to all this so am still in learning mode.

Oh and the comment in the c code says ip_refrag() but it actually calls=
 ip_fragment() at the end of the post routing operation.  The bridge al=
ways returns STOLEN so maybe that is why it needs to be PRI_LAST???

Cheers for the advice.=20

Gareth



-----Original Message-----
=46rom: agashi shipora [mailto:gashipo@gmail.com]=20
Sent: 02 April 2010 18:26
To: Gareth Williams
Cc: netfilter-devel@vger.kernel.org
Subject: Re: br_netfilter post routing hook question...

Hi,

I don't know if br_nf_post_routing can be assigned a priority
NF_BR_PRI_LAST-1. I couldn't find ip_refrag definition in 2.6.30.

As br_netfilter.c invokes the NF_INET_POST_ROUTING hook.I was thinking
if registering your module at NF_INET_POST_ROUTING (PF_INET) after
ipt_post_routing_hook(mangle table), nf_nat_out(nat table) and before
ipv4_confirm (conntrack) would help.

Ofcourse this would mean your module would come into picture for
routed packets too.

Thanks
GP

On Fri, Apr 2, 2010 at 7:48 PM, Gareth Williams <gwilliams@ubicom.com> =
wrote:
> Hello chaps.
>
> I have a module which hooks into the bridge on the post routing hook
> (PF_BRIDGE).
>
> I also enable bridge netfilter to allow iptables rules to process
> packets - I set rules on the post_routing chain (mangle table) to set
> marks on packets.
>
> Unfortunately I cannot see these marks in my code because the priorit=
y
> on the bridge_netfilter post routing hook is PRI_LAST.
>
> Since it is PRI_LAST I have no room to put my hook lower than it - so=
 I
> will never see these marks.
>
> The comment in br_netfilter.c for this hook says it has to be PRI_LAS=
T
> because ip_refrag() can return STOLEN - but does it really have to be
> LAST??? =A0Can't it be say, last-1 so I have at least some room to mo=
ve my
> module to see those marks?
>
> I know I could enable ebtables and do it that way but I am happy usin=
g
> the conntrack facilities within the iptables framework to monitor
> connections over the bridge. =A0The product I am working on also has
> limited power and adding yet another set of tables and hooks would ju=
st
> cause more slowdown in the fast path - something I don't think we can
> stand right now.
>
> Am I missing something obvious?
>
> Cheers for any advice.
>
> Gareth
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
