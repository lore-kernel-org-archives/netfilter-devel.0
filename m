From: Eddi Linder <eddi@guardicore.com>
Subject: Re: REOUTE target extenstion
Date: Sun, 31 May 2015 14:49:22 +0300
Message-ID: <CADgXnSMDQ7HSvY9F68yevJKv9fZf=8EQk-p9UFa0HSB2DNg4HA@mail.gmail.com>
References: <CADgXnSPNQM2xq_pAs72ddDCX-8DCx=J6mr--J_jPdMUcQS-PZw@mail.gmail.com>
	<20150527113746.GA23992@breakpoint.cc>
	<CADgXnSPkPdWdWcNJHrcv_9=oomWsE4ZfzoJZ3CTur=zW5LY9cQ@mail.gmail.com>
	<20150527121130.GC23992@breakpoint.cc>
	<20150527124037.GA19766@salvia>
	<CADgXnSMdWdbtBJ_0RxfUm0sFcXApBbEtUUSFdM+OKm8qrO7-sQ@mail.gmail.com>
	<alpine.LSU.2.20.1505291428200.16471@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:35663 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbbEaLtX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 31 May 2015 07:49:23 -0400
Received: by igbyr2 with SMTP id yr2so43353029igb.0
        for <netfilter-devel@vger.kernel.org>; Sun, 31 May 2015 04:49:22 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.20.1505291428200.16471@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I don't see how TEE will help me (in it's current state), I'd like to
redirect ingress packets to a device without an IP address (for IDS).
More specifically, I have a machine with a lot of interfaces
(Openstack hypervisor), each connected to a bridge.
I'd like to match the traffic on each interface using Iptables and to
mirror some of it into my own interface that is connected to an ovs.
There is no direct connection between the my interface and the others.
The reason I'd like to use Iptables is to do all the matches and the
redirects as fast as possible, instead of doing it in user space.

On Fri, May 29, 2015 at 3:50 PM, Jan Engelhardt <jengelh@inai.de> wrote:
>
> On Friday 2015-05-29 14:02, Eddi Linder wrote:
>
>>The matching will be L3 based, but the copy can be of all the packet,
>>I'd like to simply change the dest device of it.
>>I can match by source device, I don't see why it's not logical to
>>target a device as an action.
>
> (Given "sending to a device" comes up again from time to time, let me provide
> this linkable reasoning.)
>
> An analogy to sending to a device is commanding a ship to harbor exit #34.
>
> And then? Is it supposed to moor, or sink itself?
>
>
> A destination is required. _Any_ will do, in whatever way it is derived, but
> one is needed. One could for example (re)use the Ethernet address, in case of
> copying from and to Ethernet. Or let one be neighbor-discovered by specifying
> the L3 address with TEE's --gw. Or other magic, depending on what the link
> type's needs are, and what your packet already provides in terms of fields
> (which may be fewer or more in case of tunnels and such).
> A destination is required, a device is only a waypoint.
