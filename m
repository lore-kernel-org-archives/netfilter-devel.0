From: Anton VG <anton.vazir@gmail.com>
Subject: Re: rateest usage problem - slightly lost
Date: Sun, 31 May 2009 21:24:11 +0500
Message-ID: <c4b050a10905310924h20456bebj900c14226ad8dec5@mail.gmail.com>
References: <c4b050a10905310718h110e127cg6ee114cff0bc2f8c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel <netfilter-devel@vger.kernel.org>, kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:43297 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085AbZEaQYL convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 31 May 2009 12:24:11 -0400
Received: by ewy24 with SMTP id 24so7330268ewy.37
        for <netfilter-devel@vger.kernel.org>; Sun, 31 May 2009 09:24:12 -0700 (PDT)
In-Reply-To: <c4b050a10905310718h110e127cg6ee114cff0bc2f8c@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Seems finally I've got it working, and had to look at the sources of
the xt_rateest.c to understand what it wants :)

Possibly it's good to update man page with more examples of rateest
usage, so it would be clear, that we have to use the first and the
second (bps1 and bps2) parameters, and rateest give it's result as
difference of them, so the following

iptables -t mangle -A PREROUTING -s $SOURCE -m rateest --rateest1
$RATEESTIMATOR --rateest-bps1 0 --rateest-bps2 200kbit --rateest-lt -j
MARK --set-mark $TARGETMARK

will set mark only when estimated rate is below 200kbit

Regards,
Anton.

2009/5/31 Anton VG <anton.vazir@gmail.com>:
> Hi friends,
>
> Am a little lost with using of the rateest target.
>
> I'm trying to match if one of my interfaces have load over 2000kbit
> but it does not seem to work.
> While trying to understand the MAN page I'm a little lost - while man
> gives example on the comparing the delta, but even trying the simpler
> case it does not work for me.
>
> my example s simpler - i just want to know if one interface have load
> X to mark packets (to route them later to interface y) - and it does
> not seem to work at all.
>
> # iptables -t mangle -A POSTROUTING -o eth0.3810 -j RATEEST
> --rateest-name fiber --rateest-interval 250ms --rateest-ewma 0.5s
> # iptables -t mangle -A POSTROUTING -o eth0.3811 -j RATEEST
> --rateest-name satellite --rateest-interval 250ms --rateest-ewma 0.5s
> # iptables -t mangle -A PREROUTING -s 82.198.22.27/32 -m rateest
> --rateest1 fiber --rateest-bps1 2000kbit --rateest-gt -j MARK
> --set-mark 4
> # iptables -t mangle -A PREROUTING -s 82.198.22.27/32 -m rateest
> --rateest1 fiber --rateest-bps1 2000kbit --rateest-lt -j MARK
> --set-mark 7
>
> iptables -nL -v -t mangle gives
>
> Chain PREROUTING (policy ACCEPT 302M packets, 151G bytes)
> =A0pkts bytes target =A0 =A0 prot opt in =A0 =A0 out =A0 =A0 source =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 destination
> =A01426 =A0140K MARK =A0 =A0 =A0 all =A0-- =A0* =A0 =A0 =A0* =A0 =A0 =
=A0 82.198.22.27
> 0.0.0.0/0 =A0 =A0 =A0 =A0 =A0 rateest match fiber bps gt 0 MARK xset
> 0x4/0xffffffff
> =A0 =A00 =A0 =A0 0 MARK =A0 =A0 =A0 all =A0-- =A0* =A0 =A0 =A0* =A0 =A0=
 =A0 82.198.22.27
> 0.0.0.0/0 =A0 =A0 =A0 =A0 =A0 rateest match fiber bps lt 0 MARK xset
> 0x7/0xffffffff
>
>
> May anyone give me a piece of clue?
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
