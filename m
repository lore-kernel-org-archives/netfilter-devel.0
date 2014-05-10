From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: ip_route_output_key returns wrong gateway info with specific ip rules
Date: Sat, 10 May 2014 03:18:22 -0700
Message-ID: <CAHo-OoyP69f=4yvct+gy6rPsS3Dps_Ph=tn1SnRkH0yVS2+2OA@mail.gmail.com>
References: <20140509134110.GI10939@kvmbude>
	<CAHo-Ooww_a0jXJGQru9E5mGTW4LUqNi6559AWy79wdHErB0Y8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Andreas Herz <andi@geekosphere.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qa0-f51.google.com ([209.85.216.51]:39835 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbaEJKSW convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 10 May 2014 06:18:22 -0400
Received: by mail-qa0-f51.google.com with SMTP id w8so5046936qac.38
        for <netfilter-devel@vger.kernel.org>; Sat, 10 May 2014 03:18:22 -0700 (PDT)
In-Reply-To: <CAHo-Ooww_a0jXJGQru9E5mGTW4LUqNi6559AWy79wdHErB0Y8w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

To further clarify on the above.
[I'm drastically simplifying as I copy-paste this, hopefully not
introducing mistakes]

Originally I had simply a very standard setup:

-A POSTROUTING -s 192.168.1.0/24 -o wan -p tcp -j SNAT --to-source
A.B.C.201:32768-49151

A.B.C.200/30 dev wan  proto kernel  scope link  src A.B.C.201
192.168.100.0/24 dev wan  proto kernel  scope link  src 192.168.100.3
192.168.1.0/24 dev lan  proto kernel  scope link  src 192.168.1.1
default via A.B.C.202 dev wan

192.168.1.0/24 is lan subnet, .1 being the linux router, .2+ clients
192.168.100.0/24 is wan subnet, .3 is the linux router, .2 is first
cablemodem (and .4 is an experimental second cablemodem, while .1 is
reserved because it seems to be out of box default for tons of
cablemodem hw)
A.B.C.201 is router public ip, A.B.C.202 is the first cablemodem/gw

Now with the above setup everything goes via the first cablemodem.

I wanted to move all http/https traffic to the second cablemodem for
experimental purposes.
In order to do this the packets leaving the router should have src ip
192.168.100.3 and head for 192.168.100.4

=46irst attempt was to simply use:
-A POSTROUTING -s 192.168.1.0/24 -o wan -p tcp -m multiport --dports
80,443 -j SNAT --to-source 192.168.100.3:32768-49151
-A POSTROUTING -s 192.168.1.0/24 -o wan -p tcp -j SNAT --to-source
A.B.C.201:32768-49151

ip rule add pref 100 from 192.168.100.3/24 lookup 100
ip route add default via 192.168.100.4 dev wan src 192.168.100.3 table =
100

But it turns out that while you get the right src ip, the SYN packets
are still getting sent out with the first (and not second) cablemodems
destination mac.
And only after receiving a SYN-ACK does the ACK end up getting sent to
the second cablemodem (which of course breaks).

My interpretation is that ROUTE lookup happens before SNAT for the SYN
packet, so we don't know the SRCIP will change, and we do a route
lookup with srcip=3Dclient ip,
find the normal route (default via A.B.C.202 dev wan src A.B.C.201)
and thus the dst mac of A.B.C.202 (ie. first cablemodem is used).

On further packets in this stream we apparently know we will nat, and
what we will nat to early enough that we get the proper route.


The following:

-A PREROUTING -i lan -p tcp --syn -m multiport --dports 80,443 -j MARK
--set-mark 1
-A POSTROUTING -s 192.168.1.0/24 -o wan -p tcp -m multiport --dports
80,443 -j SNAT --to-source 192.168.100.3:32768-49151
-A POSTROUTING -s 192.168.1.0/24 -o wan -p tcp -j SNAT --to-source
A.B.C.201:32768-49151

ip rule add pref 100 from 192.168.100.3/24 lookup 100
ip rule add pref 100 fwmark 1 lookup 100
ip route add default via 192.168.100.4 dev wan src 192.168.100.3 table =
100

appears to work.  We mark the annoying packets with a fwmark 1 before
routing happens, use that to force select the right routing table,
and non-SYN packets work like they did previously.

On Sat, May 10, 2014 at 2:56 AM, Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
> (guesswork, read it with a grain of salt)
>
> In my experience stuff like this usually ends up being caused by the
> order in which src ip selection (for locally generated packets withou=
t
> an explicit bind(ip) call, but thus also src ip selection for auto
> nat), route lookup and nat happen.
> Easiest fix has been to use iptables mangle prerouting to mark
> packets, thus also forcing a reroute, and then using fwmark ip rules
> instead of (or maybe in addition to) from ip rules.
>
> In your particular case I'm guessing the route lookup is happening
> post-source-nat src ip substitution (or even with a 0 during nat sec
> ip selection).  While theoretically SNAT happens in POSTROUTING, and
> thus after routing, I think this is only truly the case for the first
> packet of a flow.
>
> To be fair my info may be long obsolete, since I most recently (1-2
> weeks ago) ran into something like this on some 2.4 kernel (wrt54gl
> openwrt 8.09.2) while trying to use a different src ip for SNAT to
> port 80/443 then for all other ports.
> In my case iptables mangle prerouting (ip rule fwmark lookup) was use=
d
> to mark SYNs from local client ip to dest port 80/443, and then src i=
p
> routing (ip rule from X) worked for everything else (ie. the rest of
> the tcp connection).
> Although that was with dst port based SNAT rules and not MASQUERADE.
>
> - Maciej
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
