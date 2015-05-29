From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: REOUTE target extenstion
Date: Fri, 29 May 2015 14:50:33 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1505291428200.16471@nerf40.vanv.qr>
References: <CADgXnSPNQM2xq_pAs72ddDCX-8DCx=J6mr--J_jPdMUcQS-PZw@mail.gmail.com> <20150527113746.GA23992@breakpoint.cc> <CADgXnSPkPdWdWcNJHrcv_9=oomWsE4ZfzoJZ3CTur=zW5LY9cQ@mail.gmail.com> <20150527121130.GC23992@breakpoint.cc> <20150527124037.GA19766@salvia>
 <CADgXnSMdWdbtBJ_0RxfUm0sFcXApBbEtUUSFdM+OKm8qrO7-sQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
To: Eddi Linder <eddi@guardicore.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:49492 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755233AbbE2Muf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 May 2015 08:50:35 -0400
In-Reply-To: <CADgXnSMdWdbtBJ_0RxfUm0sFcXApBbEtUUSFdM+OKm8qrO7-sQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2015-05-29 14:02, Eddi Linder wrote:

>The matching will be L3 based, but the copy can be of all the packet,
>I'd like to simply change the dest device of it.
>I can match by source device, I don't see why it's not logical to
>target a device as an action.

(Given "sending to a device" comes up again from time to time, let me provide
this linkable reasoning.)

An analogy to sending to a device is commanding a ship to harbor exit #34.

And then? Is it supposed to moor, or sink itself?


A destination is required. _Any_ will do, in whatever way it is derived, but
one is needed. One could for example (re)use the Ethernet address, in case of
copying from and to Ethernet. Or let one be neighbor-discovered by specifying
the L3 address with TEE's --gw. Or other magic, depending on what the link
type's needs are, and what your packet already provides in terms of fields
(which may be fewer or more in case of tunnels and such).
A destination is required, a device is only a waypoint.
