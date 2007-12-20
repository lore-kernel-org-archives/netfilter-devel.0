From: Patrick McHardy <kaber@trash.net>
Subject: Re: conntrack doesn't always work when a bridge is used
Date: Thu, 20 Dec 2007 11:06:11 +0100
Message-ID: <476A3E93.3010400@trash.net>
References: <9a4a382a0712180648i7fc958edt6f0d9db83f574c77@mail.gmail.com>	 <9a4a382a0712190900v2ba747a0wd4ff243d0e65e9ef@mail.gmail.com>	 <47696AE9.6090201@trash.net> <9a4a382a0712200030w5502c312k33b330e03e0e8555@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-net@vger.kernel.org, netfilter-devel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: =?ISO-8859-15?Q?Damien_Th=E9bault?= <damien.thebault@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44913 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757946AbXLTKGr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Dec 2007 05:06:47 -0500
In-Reply-To: <9a4a382a0712200030w5502c312k33b330e03e0e8555@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Damien Th=E9bault wrote:
> On Dec 19, 2007 8:03 PM, Patrick McHardy <kaber@trash.net> wrote:
>> Could you capture the conntrack events of the non-working
>> case with (run in parallel):
>>
>> conntrack -E
>> conntrack -E expect
>>
>=20
> Sure, here it is :

That actually looks like it works properly.

New control connection:

>     [NEW] tcp      6 120 SYN_SENT src=3D192.168.1.5 dst=3D192.168.2.2=
50
> sport=3D45090 dport=3D21 [UNREPLIED] src=3D192.168.2.50 dst=3D192.168=
=2E2.70
> sport=3D21 dport=3D45090
>  [UPDATE] tcp      6 60 SYN_RECV src=3D192.168.1.5 dst=3D192.168.2.25=
0
> sport=3D45090 dport=3D21 src=3D192.168.2.50 dst=3D192.168.2.70 sport=3D=
21
> dport=3D45090
>  [UPDATE] tcp      6 432000 ESTABLISHED src=3D192.168.1.5
> dst=3D192.168.2.250 sport=3D45090 dport=3D21 src=3D192.168.2.50
> dst=3D192.168.2.70 sport=3D21 dport=3D45090 [ASSURED]

New expectation for data connection:

 > conntrack -E expect :
 >
 > 300 proto=3D6 src=3D192.168.2.50 dst=3D192.168.2.70 sport=3D0 dport=3D=
33344

New data connection machting expectation, both source and
destination properly NATed:

>     [NEW] tcp      6 120 SYN_SENT src=3D192.168.2.50 dst=3D192.168.2.=
70
> sport=3D20 dport=3D33344 [UNREPLIED] src=3D192.168.1.5 dst=3D192.168.=
2.250
> sport=3D33344 dport=3D20
>  [UPDATE] tcp      6 60 SYN_RECV src=3D192.168.2.50 dst=3D192.168.2.7=
0
> sport=3D20 dport=3D33344 src=3D192.168.1.5 dst=3D192.168.2.250 sport=3D=
33344
> dport=3D20
>  [UPDATE] tcp      6 432000 ESTABLISHED src=3D192.168.2.50
> dst=3D192.168.2.70 sport=3D20 dport=3D33344 src=3D192.168.1.5
> dst=3D192.168.2.250 sport=3D33344 dport=3D20 [ASSURED]
>  [UPDATE] tcp      6 120 FIN_WAIT src=3D192.168.2.50 dst=3D192.168.2.=
70
> sport=3D20 dport=3D33344 src=3D192.168.1.5 dst=3D192.168.2.250 sport=3D=
33344
> dport=3D20 [ASSURED]
>  [UPDATE] tcp      6 60 CLOSE_WAIT src=3D192.168.2.50 dst=3D192.168.2=
=2E70
> sport=3D20 dport=3D33344 src=3D192.168.1.5 dst=3D192.168.2.250 sport=3D=
33344
> dport=3D20 [ASSURED]
>  [UPDATE] tcp      6 10 CLOSE src=3D192.168.2.50 dst=3D192.168.2.70
> sport=3D20 dport=3D33344 src=3D192.168.1.5 dst=3D192.168.2.250 sport=3D=
33344
> dport=3D20 [ASSURED]

Data connection closed

>  [UPDATE] tcp      6 120 FIN_WAIT src=3D192.168.1.5 dst=3D192.168.2.2=
50
> sport=3D45090 dport=3D21 src=3D192.168.2.50 dst=3D192.168.2.70 sport=3D=
21
> dport=3D45090 [ASSURED]
>  [UPDATE] tcp      6 60 CLOSE_WAIT src=3D192.168.1.5 dst=3D192.168.2.=
250
> sport=3D45090 dport=3D21 src=3D192.168.2.50 dst=3D192.168.2.70 sport=3D=
21
> dport=3D45090 [ASSURED]
>  [UPDATE] tcp      6 30 LAST_ACK src=3D192.168.1.5 dst=3D192.168.2.25=
0
> sport=3D45090 dport=3D21 src=3D192.168.2.50 dst=3D192.168.2.70 sport=3D=
21
> dport=3D45090 [ASSURED]
>  [UPDATE] tcp      6 120 TIME_WAIT src=3D192.168.1.5 dst=3D192.168.2.=
250
> sport=3D45090 dport=3D21 src=3D192.168.2.50 dst=3D192.168.2.70 sport=3D=
21
> dport=3D45090 [ASSURED]
>  [UPDATE] tcp      6 10 CLOSE src=3D192.168.1.5 dst=3D192.168.2.250
> sport=3D45090 dport=3D21 src=3D192.168.2.50 dst=3D192.168.2.70 sport=3D=
21
> dport=3D45090 [ASSURED]

Control connection closed

> [DESTROY] tcp      6 src=3D192.168.2.50 dst=3D192.168.2.70 sport=3D20
> dport=3D33344 packets=3D4 bytes=3D559 src=3D192.168.1.5 dst=3D192.168=
=2E2.250
> sport=3D33344 dport=3D20 packets=3D4 bytes=3D216

> [DESTROY] tcp      6 src=3D192.168.1.5 dst=3D192.168.2.250 sport=3D45=
090
> dport=3D21 packets=3D17 bytes=3D916 src=3D192.168.2.50 dst=3D192.168.=
2.70
> sport=3D21 dport=3D45090 packets=3D12 bytes=3D1162

Both connections destroyed
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
