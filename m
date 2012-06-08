From: =?UTF-8?Q?Nicolas_Ma=C3=AEtre?= <nimai@skynet.be>
Subject: Re: Using RELATED for a level4 protocol (MPTCP)
Date: Fri, 8 Jun 2012 12:48:36 +0200
Message-ID: <CACd4Q00a_3r3tY6pgoKm1HAR5xSCmF9B-axD-r7Z9Jzb51b1QA@mail.gmail.com>
References: <CACd4Q01Hg2TC=_5Kk+MhZUoP9swUJKGFEvQgSbbtcXi=_4BZTQ@mail.gmail.com>
 <alpine.DEB.2.00.1205231016140.31407@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59745 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312Ab2FHKs5 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Jun 2012 06:48:57 -0400
Received: by eaak11 with SMTP id k11so1012190eaa.19
        for <netfilter-devel@vger.kernel.org>; Fri, 08 Jun 2012 03:48:56 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1205231016140.31407@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 23, 2012 at 10:52 AM, Jozsef Kadlecsik
<kadlec@blackhole.kfki.hu> wrote:
>
> As far as I see, after the hosts advertised their addresses (which ca=
n
> later be updated) any one of them may initiate a subflow to the possi=
ble
> advertised addresses/ports of the other side.

Actually, this is not really how it works in the general case.
The address advertisements are optional. A multihomed/multiaddressed
host A can implicitly establish subflows with its addresses A1 and A2,
and the other end host, B, can do it equally with its addresses B1 and
B2, as far as new TCP connections are accepted in both directions.
The advertisements exist for practical purposes and in the case of
middleboxes preventing one host from establishing new subflows --
which are actually new TCP connections. An end-host receiving the
ADD_ADDR advertisement will keep the new address in memory and try to
establish the new subflow to that address only if it decides to.
So, this is actually not something I care about right now.

Well, after reading your answer, I realize I might not have been so
clear about what I want (and actually, I'm not sure it was very clear
in my own head at that time). Sorry.
I am pretty sure I can't use the "expectation framework" as is since
it requires one to expect a new connection from a known address/port
combination. In the general case, these are unknown. The way SYN
packets of new subflows are validated for acceptation is by verifying
a token enclosed in it.
What I have thought of, however, is to mark that SYN packet as
"RELATED" (or NEW_SUBFLOW or anything) in a early stage at the packet
reception and then have a rule to accept those packets.

>
> There are two possibilities:
>
> a. conntrack helper: Whenever an address advertisement is detected,
> =C2=A0 a corresponding expectation is created. It's not very nice tha=
t
> =C2=A0 the expectation may never be used and thus created unnecessari=
ly.

As explained above, I can't use an "expectation" as is, anyway.
However, I'd like to know if there is an easy way for "marking" a
packet as RELATED (or NEW_SUBFLOW or whatever) without using that
expectation system. The goal would be to be able to configure iptables
like this:
$ iptables -m conntrack --ctstate NEW_SUBFLOW -j ACCEPT
By the way, if I understand well the conntrack match does the same and
more than the state match.
So if I had to implement this, I would have to modify the conntrack
match, right?

> b. mptcp target and match: The target keeps record of
> =C2=A0 the ids/addresses/ports from the advertisements. New subflows
> =C2=A0 can be allowed by the match, which searches for a match in the
> =C2=A0 pool of the id/address/port entries.
I'm not sure to understand well. In terms of iptables command line, it
would give something like:
$ iptables -m mptcp -j SUBFLOW_ACCEPT
?
It looks to me that it wouldn't be very clean to have a target
available only for a given match module. I'm not an advanced user of
iptables so someone has probably something to tell me about that.

A third possibility would be something like:
$ iptables -m mptcp_state --state NEW_SUBFLOW -j ACCEPT
which might (or not) allow avoiding messing with the connection trackin=
g match.

I think the first solution is cleaner and does not harm the security.
But I'm not sure what is the best in the absolute, if it were to be
accepted in the tree. What do you think?

Thank you.


--=20
Nicolas Ma=C3=AEtre
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
