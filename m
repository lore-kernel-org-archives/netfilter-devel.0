From: Dave Taht <dave.taht@gmail.com>
Subject: Fwd: [RFC] ecn match ported to ipv6
Date: Wed, 8 Jun 2011 09:49:22 -0600
Message-ID: <BANLkTi=KJ=bP5w0jtK4cwHW6h611tQqi3w@mail.gmail.com>
References: <1307545312.3057.49.camel@edumazet-laptop>
	<BANLkTi=ORBH0q_arGbFUdjk=WMjbBz1KZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37563 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab1FHPtZ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2011 11:49:25 -0400
Received: by iyb14 with SMTP id 14so518148iyb.19
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Jun 2011 08:49:24 -0700 (PDT)
In-Reply-To: <BANLkTi=ORBH0q_arGbFUdjk=WMjbBz1KZg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---------- Forwarded message ----------
=46rom: Dave Taht <dave.taht@gmail.com>
Date: Wed, Jun 8, 2011 at 9:47 AM
Subject: Re: [RFC] ecn match ported to ipv6
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>, Jan Engelhardt
<jengelh@medozas.de>, Netfilter Development Mailinglist
<netfilter-devel@vger.kernel.org>




On Wed, Jun 8, 2011 at 9:01 AM, Eric Dumazet <eric.dumazet@gmail.com> w=
rote:
>
> Dave Taht mentioned in bloat list that netfilter ecn match was ipv4
> only.
>
> Is there any plan to make the switch from net/ipv4/netfilter/ipt_ecn.=
c
> to net/netfilter/xt_ecn.c ?
>
> I can probably do it but not before ~ten days, so if someone is
> interested, this will please Dave ;)

The larger question I had was this

"iptables seems to think ecn can only be looked at in TCP streams, wher=
e (for
example), ecn bits can be copied to the outer header of a udp vpn
stream, and marked


when needed."

ECN is an ip level standard, not just a tcp one.

http://www.ietf.org/rfc/rfc3168.txt

Example of ECN on ipsec:

http://huchra.bufferbloat.net/~d/veryhappynetwork.png

Also ECN marking in various qdiscs like HTB as presently being
discussed on the bloat list

https://lists.bufferbloat.net/pipermail/bloat/2011-June/000555.html

and a truly crazy idea regarding combining DSCP with firewalling is her=
e:

https://lists.bufferbloat.net/pipermail/bloat/2011-June/000558.html

To give some context as to what we've been up to regarding
bufferbloat, I have a test lab setup with a bunch of wndr3700v2
routers at georgia tech, and have pushed=A0 every ecn and bufferbloat
related patch in linux head into the openwrt distro, and am playing
with all sorts of techniques now, with increasingly good results.

The 'uberwrt' project is in addition to the debloat-testing work
and has various subprojects... mostly targeting the wndr3700v2 and
nanostation M5 as these have a completely open source wireless and
wired stack.

http://www.bufferbloat.net/projects/uberwrt/wiki

--
Dave T=E4ht
SKYPE: davetaht
US Tel: 1-239-829-5608
http://www.bufferbloat.net



--
Dave T=E4ht
SKYPE: davetaht
US Tel: 1-239-829-5608
http://the-edge.blogspot.com
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
