From: Patrick McHardy <kaber@trash.net>
Subject: Re: conntrack doesn't always work when a bridge is used
Date: Thu, 20 Dec 2007 12:07:19 +0100
Message-ID: <476A4CE7.4070607@trash.net>
References: <9a4a382a0712180648i7fc958edt6f0d9db83f574c77@mail.gmail.com>	 <9a4a382a0712190900v2ba747a0wd4ff243d0e65e9ef@mail.gmail.com>	 <47696AE9.6090201@trash.net>	 <9a4a382a0712200030w5502c312k33b330e03e0e8555@mail.gmail.com>	 <476A3E93.3010400@trash.net> <9a4a382a0712200306m1260e21ahf89cf528c172bd6d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-net@vger.kernel.org, netfilter-devel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: =?ISO-8859-15?Q?Damien_Th=E9bault?= <damien.thebault@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46314 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbXLTLH4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Dec 2007 06:07:56 -0500
In-Reply-To: <9a4a382a0712200306m1260e21ahf89cf528c172bd6d@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Damien Th=E9bault wrote:
> Yes, when I'm using ip addresses with the same length, the conntrack
> -E output is similar, and it's working.
> But if I change the router's "wan"-side ip address to be longer or
> shorter than the client's ip address, then it's non-working again.
>=20
> I don't think it's something in the configuration : the results are
> present on two different computers, one being a x86 little endian
> debian laptop where I did the bisect, the other being an arm xscale
> big endian board with a custom distro (nothing funny here, just
> kernel, drivers, busybox and  some utilities).
>=20
> Well, I'm sorry, I don't want to bother anyone, but those are really
> the results I'm seeing.


Don't worry. I was just wondering because I asked for the output
of the *non-working* case :) Please post that and I'll look into it.
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
