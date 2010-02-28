From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: linux-next netfilter: xt_recent: Add an entry reaper
Date: Sun, 28 Feb 2010 21:20:36 +0100
Message-ID: <1267388436.9082.84.camel@edumazet-laptop>
References: <20100228033841.265CFF8BB0@sepang.rtg.net>
	 <1267331677.9082.46.camel@edumazet-laptop>  <4B8AB4BE.7080206@tpi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net, coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: timg@tpi.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:62702 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031964Ab0B1UUm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Feb 2010 15:20:42 -0500
In-Reply-To: <4B8AB4BE.7080206@tpi.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le dimanche 28 f=C3=A9vrier 2010 =C3=A0 11:23 -0700, Tim Gardner a =C3=A9=
crit :
>=20
> I realize there are manual methods for removing entries, but I argue
> that manual methods are insufficient in a dynamic environment.
>=20
> Let me explain one of my use cases. One of the companies that I work =
for
> is an ISP. Our primary bridge/firewall uses iptables as a first line =
of
> defense. One of the methods to detect attackers is by using a port sc=
an
> detection filter (PSD), which is a bit memory and CPU intensive. Once
> PSD identifies an attacker, then that source IP is added to a 'recent=
'
> filter instance with an X second timeout, and the PSD entry flushes
> after some timeout. 'recent' continues to block _all_ traffic from th=
at
> source IP until it stops sending packets for at least X seconds, at
> which time I would like 'recent' to release the entry.
>=20
> Here is a rule snippet that implements this behavior:
>=20
> IRAW=3D"iptables -t raw"
> $IRAW -N DROPIP
> $IRAW -A PREROUTING -m recent --name psd  --update --seconds 3600 -j =
DROP
> $IRAW -A PREROUTING -m psd --update --seconds 600 -J DROPIP
> $IRAW -A DROPIP -m recent --name psd --set -j DROP
>=20
> As long as '-m recent --name psd  --update --seconds 3600' drops entr=
ies
> older then 3600 seconds, then nothing external is required to recover
> those entries.
>=20
> As for your fast path comment, how about scaling the frequency with
> which the reaper is run using a module parameter ? See attached patch=
=2E
>=20
> rtg

OK but as pointed by Jan Engelhardt, same table can be used with
different matches and different delays, so your patch is not good. You
should add a parameter (--reap or some flag) to iptables rule to ask fo=
r
this reap, and not let it happen in general case.

iptables -A ... -m recent --name foo --seconds 60 -j DOTHAT
iptables -A ... -m recent --name foo --seconds 3600 --reap -j ELSE

Also, I am convinced your reap pointer is not good, because it can poin=
t
to an entry that is renewed once per second for example, and reaper wil=
l
be frozen.

You should use lru_list.next only, because this one is guaranted to
point to the oldest entry in table


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
