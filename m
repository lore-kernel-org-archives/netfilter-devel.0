From: Saatvik Agarwal <saatvik.agarwal@stanford.edu>
Subject: Re: TCP simultaneous open using iptables NAT?
Date: Thu, 28 May 2009 13:00:03 -0700
Message-ID: <4ddb24250905281300l5ca0a6fcse1f38d36f3d9abb8@mail.gmail.com>
References: <4ddb24250905271506qb50323etf3f7deb4e240ff72@mail.gmail.com>
	 <alpine.DEB.2.00.0905281014090.26723@blackhole.kfki.hu>
	 <4ddb24250905281258i68374aa6w858aaf088b96c1b9@mail.gmail.com>
Reply-To: saatvik.agarwal@stanford.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:47078 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbZE1UAC convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 May 2009 16:00:02 -0400
In-Reply-To: <4ddb24250905281258i68374aa6w858aaf088b96c1b9@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Appreciate the lucid reply. Replies inline.

On 5/28/09, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
>  On Wed, 27 May 2009, Saatvik Agarwal wrote:
>
>  > For my research project in school, I am trying to establish TCP
>  > connections when both hosts are behind full-cone NATs using TCP's
>  > simultaneous open functionality. Unfortunately, it seems that ipta=
bles
>   > does not support TCP simultaneous open. For my test environment, =
I
>  > simulate a full-cone NAT using iptables. My iptables rule is exact=
ly
>  > as follows:
>  >
>  > iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
>
>
> That rule cannot simulate full-cone NAT, because netfilter implements
>  port-restricted cone NAT.


Would both SNAT and DNAT together simulate a full-cone NAT?


>   > According to the BEHAVE requirements outlined in IETF RFC 5382, T=
CP
>  > simultaneous open must be supported by "well behaved NATs". So is
>  > there a mistake in my rules or does iptables not support simultane=
ous
>   > open?
>
>
> The connection tracking subsystem does not support TCP simultaneous o=
pen.
>
>  As far as I'm concerned, I do not care whatever RFC is created in tr=
ying
>  to push NAT over its limits - that is just a totally wrong track. NA=
T was
>   invented solely to slow down the depletion of the IPv4 address spac=
e in
>  the hope to give more time introducing and *deploying* IPv6 world-wi=
de.
>  And everyone was fully aware that NAT breaks one of the key concempt=
s of
>   IP, the end-to-end connectivity. These "NAT behavioral requirements=
" RFCs
>  are the results of that breakage (and written exclusively from the p=
oint
>  of view of the application designers).


Agreed. I was trying to develop a NAT traversal library solely for appl=
ication
developers. I guess I'll test with actual NATs/routers instead of iptab=
les.


>   It is no point trying to *put back* end-to-end connectivity on top =
of NAT
>  when the clear and straight solution is to go to IPv6.
>
>  The end-to-end connectivity is the very reason why I refuse the idea=
 to
>  implement NAT for IPv6 in netfilter. The damage what IPv4 NAT produc=
ed
>   hasn't taught us not to repeat the same mistake again, willingly?


I wholeheartedly agree that implementing NAT for IPv6 would be
absolutely bone-headed. :)

Thanks,
Saatvik


>   Best regads,
>  Jozsef
>  -
>  E-mail=A0=A0: kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
>  PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
>   Address : KFKI Research Institute for Particle and Nuclear Physics
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0H-1525 Budapest 114, POB. 49, Hungary
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
