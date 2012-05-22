From: =?UTF-8?Q?Nicolas_Ma=C3=AEtre?= <nimai@skynet.be>
Subject: Using RELATED for a level4 protocol (MPTCP)
Date: Tue, 22 May 2012 22:51:02 +0200
Message-ID: <CACd4Q01Hg2TC=_5Kk+MhZUoP9swUJKGFEvQgSbbtcXi=_4BZTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61662 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab2EVUvX convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 May 2012 16:51:23 -0400
Received: by wgbdr13 with SMTP id dr13so6455381wgb.1
        for <netfilter-devel@vger.kernel.org>; Tue, 22 May 2012 13:51:22 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi everyone,

I'm a complete newbie in netfilter hacking and I'm trying to implement
the support of MPTCP [0] (standing for MultiPath TCP) in netfilter in
the context of a master's thesis.

I'll just summarize some points of MPTCP here to get a chance to be
understood with my request.
MPTCP is an extension of TCP which enables it to use multiple paths as
part of a single "MPTCP connection", answering to a multihoming and
performance demand. It acts as a higher-level, using TCP connections
as subflows and it has been designed to be backward-compatible with
regular TCP.
It exposes a similar interface to TCP to the application layer. A
figure might help to get the whole thing:

       +-------------------------------+
       |           Application         |
       +-------------------------------+
       |             MPTCP             |
       + - - - - - - - + - - - - - - - +
       | Subflow (TCP) | Subflow (TCP) |
       +-------------------------------+
       |       IP      |      IP       |
       +-------------------------------+
(If you cannot read it properly, the 2 figures in this mail are taken
from [0] where they are displayed correctly with a monospace font).

It's currently being standardized by the IETF.
=46urthermore, a Linux implementation is already available and working =
fine [1].

Now, what I'd like some help with is for the handling of additional
subflows.  Here is a figure to illustrate the setup of an additional
subflow.

              Host A                                  Host B
     ------------------------                       ----------
     Address A1    Address A2                       Address B1
     ----------    ----------                       ----------
         |             |                                |
         |             | SYN + MP_CAPABLE               |
Initial subflow negotiation
         |--------------------------------------------->|
         |<---------------------------------------------|
         |          SYN/ACK + MP_CAPABLE(Key-B)         |
         |             |                                |
         |        ACK + MP_CAPABLE(Key-A, Key-B)        |
         |--------------------------------------------->|
         |             |                                |
         |             |   SYN + MP_JOIN(Token-B, R-A)  |
Additional subflow
         |             |------------------------------->|
         |             |<-------------------------------|
         |             |  SYN/ACK + MP_JOIN(MAC-B, R-B) |
         |             |                                |
         |             |      ACK + MP_JOIN(MAC-A)      |
         |             |------------------------------->|
         |             |                                |

As subflows are negotiated (and authenticated) with an option in a
regular TCP handshake, I'd like to know if there is currently a simple
way of accepting new subflow packets with netfilter.
Specifically, I thought of handling the MP_JOIN with a kind of
conntrack's RELATED state. Indeed, the first packet of the MP_JOIN
step can be "expected" and verified to be originating from the same
host than the initial subflow.

After inspection of the code, I doubt that this would be possible as
the expectation setup takes the ip addresses and ports as parameters.
I therefore assume that the whole expectation system is only usable
for protocols on the application level?
Could you confirm that it's not the good way to go?
But then, do you see any tool in the framework that would be helpful
to me? Or give me some advices/pointers to integrate this in an
elegant way into netfilter ?

In advance, thank you!


[0] http://tools.ietf.org/html/draft-ietf-mptcp-multiaddressed-07
[1] http://mptcp.info.ucl.ac.be/


--=20
Nicolas Ma=C3=AEtre
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
