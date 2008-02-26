From: "Juneja Kapil" <Kapil.Juneja@freescale.com>
Subject: RE: [PATCH] nf_conntrack_core: Updated nf_conntrack to destroy/refresh conn irrespective of del_timer status
Date: Tue, 26 Feb 2008 13:09:47 +0530
Message-ID: <2A6F278C5B66C4459AF4013E77A40CD30122F288@zin33exm20.fsl.freescale.net>
References: <1203916760-12951-1-git-send-email-Kapil.Juneja@freescale.com> <47C2B056.3010609@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Cc: <netfilter-devel@vger.kernel.org>,
	"Medve Emilian" <Emilian.Medve@freescale.com>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:58253 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbYBZHlA convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Feb 2008 02:41:00 -0500
Received: from az33smr01.freescale.net (az33smr01.freescale.net [10.64.34.199])
	by az33egw02.freescale.net (8.12.11/az33egw02) with ESMTP id m1Q7dwHl006703
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Feb 2008 00:40:06 -0700 (MST)
Received: from zin33exm20.fsl.freescale.net (zin33exm20.ap.freescale.net [10.232.192.5])
	by az33smr01.freescale.net (8.13.1/8.13.0) with ESMTP id m1Q7du2g026913
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Feb 2008 01:39:57 -0600 (CST)
Content-class: urn:content-classes:message
In-Reply-To: <47C2B056.3010609@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi, 
My responses are inlined..

> -----Original Message-----
> From: Patrick McHardy [mailto:kaber@trash.net] 
> Sent: Monday, February 25, 2008 5:41 PM
> To: Juneja Kapil
> Cc: netfilter-devel@vger.kernel.org; Medve Emilian
> Subject: Re: [PATCH] nf_conntrack_core: Updated nf_conntrack 
> to destroy/refresh conn irrespective of del_timer status
> 
> Kapil Juneja wrote:
> > Currently NF_CONNTRACK assumes that a running timer is 
> present before refreshing
> > the connection or destroying it. This may not be the case 
> when, for example,
> > another forwarding engine hooks up to it to listen to new 
> connections
> > but disables the NF_CONNTRACK timer in order to have more control.
> > In such a scenario, only control packets may be terminated 
> to NF_CONNTRACK for
> > it to decode and update the connection status. It will not 
> impact the present
> > scenario of kernel forwarding without the aid of any 
> forwarding engine. 
> 
> Do you have a pointer to the code you're talking about?

The forwarding engine concept is  same as the Grand Unified Flow Cache
idea mooted by Rusty Russel some time back:
http://lwn.net/Articles/194443/

Our architecture runs on three components - Linux NF_CONNTRACK, a
Control (Linux) Module(CM), and a Forwarding Engine or Flow Caching
system (FC):
1) The CM registers itself to the NF_CONNTRACK notifier chain. Whenever
an assured connection notifier event is received, it extracts all the
relevant tuple parameters (Src IP, Dst IP, Protocol, Src Port, Dst Port
etc.) and caches them to the FC. Due to reasons mentioned subsequently,
it also disables the timer for the said conntrack object. The object,
however, remains in the conntrack list as long as it is not destroyed.
3) The FC, sitting at the ethernet driver level, sends all the data
packets belonging to the cached connection directly to the outbound port
(as identified in step 2), bypassing the Linux stack altogether. All the
packets not belonging to either of the cached tuples are terminated to
the Linux stack. Also TCP control packets FIN/RST/SYN are terminated
irrespective of wether the connection is cached or not.
4) With assistance from the FC, the CM also runs aging on the cached
connections (hence the requirement of deleting the NF_CONNTRACK timer in
step 2)
5) Cached connections can be terminated (i.e, removed from cache) in two
ways:
	i) Aging out by the CM: In this scenario, the CM removes the
connection tuple from FC as well as NF_CONNTRACK by calling the
corresponding timer destroy function directly.
	ii) Destroy via TCP control packet: All the FIN-ACK, RST,
RST-ACK packets are send to conntrack irrespective of the fact that they
match a cached tuple. They are picked up by the TCP conntrack module
which restarts the accounting and refreshes the connection state. It is
at this point that the first chunk of this patch comes into picture. 
6) When the NF_CONNTRACK module is removed, it iterates through the list
to destroy the detected connections. Currently, it does not remove those
connections whose timers have gone off (which is the case with
connections cached to FC). This is fixed by the second chunk of the
patch.


> 
> > +		if (newtime - ct->timeout.expires >= HZ) {
> > +			/*
> > +			 * The timer could have already been deleted
> > +			 * while still alive (for example connection
> > +			 * offloaded to a forwarding module other than
> > +			 * the kernel stack).
> > +			 */
> > +			mod_timer(&ct->timeout, newtime);
> >  			event = IPCT_REFRESH;
> 
> This adds a race, we don't want to update the timer if it already
> went off this that means the connection is already destroyed.
> Same problem with the other chunk.
> 

A timer call would have invalidated the conntrack by a call to
'death_by_timeout' (or similar such routine), thereby rendering this
check redundant.  Theoretically, I think the check is irrelevant unless
a hypothetical timeout doesn't really invalidate the conntrack. Can you
describe the race scenario mentioned by you?

The other chunk for iterative cleaning of list during module removal
holds true on similar reasoning. 
