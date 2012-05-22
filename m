From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Using RELATED for a level4 protocol (MPTCP)
Date: Wed, 23 May 2012 00:18:19 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1205222335460.18927@frira.zrqbmnf.qr>
References: <CACd4Q01Hg2TC=_5Kk+MhZUoP9swUJKGFEvQgSbbtcXi=_4BZTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: =?UTF-8?Q?Nicolas_Ma=C3=AEtre?= <nimai@skynet.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:36489 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754212Ab2EVWSU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 May 2012 18:18:20 -0400
In-Reply-To: <CACd4Q01Hg2TC=_5Kk+MhZUoP9swUJKGFEvQgSbbtcXi=_4BZTQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2012-05-22 22:51, Nicolas Ma=C3=AEtre wrote:
>
>MPTCP is an extension of TCP which enables it to use multiple paths as
>part of a single "MPTCP connection", answering to a multihoming and
>performance demand. It acts as a higher-level, using TCP connections
>as subflows and it has been designed to be backward-compatible with
>regular TCP. [...]
>It's currently being standardized by the IETF.
>[0] http://tools.ietf.org/html/draft-ietf-mptcp-multiaddressed-07

A mindshare about MPTCP itself, not any particular implementation:

Another standard, eh? xkcd #927 is calling. I would expect that MPTCP=20
will end up in limbo -- like most of the other RFC prose.

SHIM6 seems to already offer multihoming/loadsharing - and does so at=20
the IP level, so I really wonder why one would want to use MPTCP when=20
that's one up and seems to limit itself to TCP.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
