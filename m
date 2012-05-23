From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Using RELATED for a level4 protocol (MPTCP)
Date: Wed, 23 May 2012 10:52:20 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1205231016140.31407@blackhole.kfki.hu>
References: <CACd4Q01Hg2TC=_5Kk+MhZUoP9swUJKGFEvQgSbbtcXi=_4BZTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="110391812-1534195209-1337763140=:31407"
Cc: netfilter-devel@vger.kernel.org
To: =?ISO-8859-15?Q?Nicolas_Ma=EEtre?= <nimai@skynet.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:47949 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805Ab2EWIwX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 May 2012 04:52:23 -0400
In-Reply-To: <CACd4Q01Hg2TC=_5Kk+MhZUoP9swUJKGFEvQgSbbtcXi=_4BZTQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110391812-1534195209-1337763140=:31407
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 22 May 2012, Nicolas Ma=C3=AEtre wrote:

> I'm a complete newbie in netfilter hacking and I'm trying to implement
> the support of MPTCP [0] (standing for MultiPath TCP) in netfilter in
> the context of a master's thesis.
>=20
> I'll just summarize some points of MPTCP here to get a chance to be
> understood with my request.
> MPTCP is an extension of TCP which enables it to use multiple paths as
> part of a single "MPTCP connection", answering to a multihoming and
> performance demand. It acts as a higher-level, using TCP connections
> as subflows and it has been designed to be backward-compatible with
> regular TCP.
> It exposes a similar interface to TCP to the application layer. A
> figure might help to get the whole thing:
>=20
>        +-------------------------------+
>        |           Application         |
>        +-------------------------------+
>        |             MPTCP             |
>        + - - - - - - - + - - - - - - - +
>        | Subflow (TCP) | Subflow (TCP) |
>        +-------------------------------+
>        |       IP      |      IP       |
>        +-------------------------------+
> (If you cannot read it properly, the 2 figures in this mail are taken
> from [0] where they are displayed correctly with a monospace font).
>=20
> It's currently being standardized by the IETF.
> Furthermore, a Linux implementation is already available and working fine=
 [1].
>=20
> Now, what I'd like some help with is for the handling of additional
> subflows.  Here is a figure to illustrate the setup of an additional
> subflow.
>=20
>               Host A                                  Host B
>      ------------------------                       ----------
>      Address A1    Address A2                       Address B1
>      ----------    ----------                       ----------
>          |             |                                |
>          |             | SYN + MP_CAPABLE               |
> Initial subflow negotiation
>          |--------------------------------------------->|
>          |<---------------------------------------------|
>          |          SYN/ACK + MP_CAPABLE(Key-B)         |
>          |             |                                |
>          |        ACK + MP_CAPABLE(Key-A, Key-B)        |
>          |--------------------------------------------->|
>          |             |                                |
>          |             |   SYN + MP_JOIN(Token-B, R-A)  |
> Additional subflow
>          |             |------------------------------->|
>          |             |<-------------------------------|
>          |             |  SYN/ACK + MP_JOIN(MAC-B, R-B) |
>          |             |                                |
>          |             |      ACK + MP_JOIN(MAC-A)      |
>          |             |------------------------------->|
>          |             |                                |
>=20
> As subflows are negotiated (and authenticated) with an option in a
> regular TCP handshake, I'd like to know if there is currently a simple
> way of accepting new subflow packets with netfilter.
> Specifically, I thought of handling the MP_JOIN with a kind of
> conntrack's RELATED state. Indeed, the first packet of the MP_JOIN
> step can be "expected" and verified to be originating from the same
> host than the initial subflow.

As far as I see, after the hosts advertised their addresses (which can=20
later be updated) any one of them may initiate a subflow to the possible=20
advertised addresses/ports of the other side.

There are two possibilities:

a. conntrack helper: Whenever an address advertisement is detected,
   a corresponding expectation is created. It's not very nice that
   the expectation may never be used and thus created unnecessarily.
b. mptcp target and match: The target keeps record of=20
   the ids/addresses/ports from the advertisements. New subflows
   can be allowed by the match, which searches for a match in the
   pool of the id/address/port entries.

The target/match looks nicer and thus one could have a little bit firmer=20
grasp on the protocol - it looks quite easy to force opening up any=20
address/port by the firewall if MPTCP is blindly accepted.
=20
> After inspection of the code, I doubt that this would be possible as
> the expectation setup takes the ip addresses and ports as parameters.
> I therefore assume that the whole expectation system is only usable
> for protocols on the application level?
> Could you confirm that it's not the good way to go?
> But then, do you see any tool in the framework that would be helpful
> to me? Or give me some advices/pointers to integrate this in an
> elegant way into netfilter ?
>=20
> In advance, thank you!
>=20
>=20
> [0] http://tools.ietf.org/html/draft-ietf-mptcp-multiaddressed-07
> [1] http://mptcp.info.ucl.ac.be/

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
--110391812-1534195209-1337763140=:31407--
