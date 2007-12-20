From: Patrick McHardy <kaber@trash.net>
Subject: Re: conntrack doesn't always work when a bridge is used
Date: Thu, 20 Dec 2007 12:25:36 +0100
Message-ID: <476A5130.6050800@trash.net>
References: <9a4a382a0712180648i7fc958edt6f0d9db83f574c77@mail.gmail.com>	 <9a4a382a0712190900v2ba747a0wd4ff243d0e65e9ef@mail.gmail.com>	 <47696AE9.6090201@trash.net>	 <9a4a382a0712200030w5502c312k33b330e03e0e8555@mail.gmail.com>	 <476A3E93.3010400@trash.net>	 <9a4a382a0712200306m1260e21ahf89cf528c172bd6d@mail.gmail.com>	 <476A4CE7.4070607@trash.net> <9a4a382a0712200320mec29cm3c4ac7df62ff6799@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-net@vger.kernel.org, netfilter-devel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: =?ISO-8859-15?Q?Damien_Th=E9bault?= <damien.thebault@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46779 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288AbXLTL0M (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Dec 2007 06:26:12 -0500
In-Reply-To: <9a4a382a0712200320mec29cm3c4ac7df62ff6799@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Damien Th=E9bault wrote:
> On Dec 20, 2007 12:07 PM, Patrick McHardy <kaber@trash.net> wrote:
>> Don't worry. I was just wondering because I asked for the output
>> of the *non-working* case :) Please post that and I'll look into it.
>>
>=20
> The fact is that this was the output of the non working case, they ar=
e similar.
> I'm attaching the four files I just made, with both the working and
> the non-working case.


Thanks. Could you also post a tcpdump and enable conntrack logging
by doing "echo 255 >/proc/sys/net/netfilter/nf_conntrack_log_invalid"
and post the output of that, if any (you also need to load ipt_LOG
in case you're not using some other logging backend).
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
