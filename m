From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 0/1] Conntrack event generation control, kernel part
Date: Tue, 12 May 2009 15:41:33 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0905121524020.28379@blackhole.kfki.hu>
References: <alpine.DEB.2.00.0905121348460.28379@blackhole.kfki.hu> <4A097752.4030303@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:51364 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbZELNld (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 May 2009 09:41:33 -0400
In-Reply-To: <4A097752.4030303@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Tue, 12 May 2009, Pablo Neira Ayuso wrote:

> First of all, this is clashing with seven big patches that I have here
> including one to kill the notifier call chain :), I'm waiting for
> Patrick to open nf-next-2.6 to send them all. I can send them now.

(I have promised patches ;-). Yes, I know they're clashing, I should have 
added the RFC tag to the subject. As soon as your patches are integrated 
I'll adapt my patches.
 
> > The patch adds support to control the in-kernel event generation.
> > In practice we face two problems: we should support a fine-grained
> > event generation in netfilter, in order to be able to catch and follow
> > the different state changes. At the same time, for example for conntrack
> > replication, a too fine-grained event generation can easily result in
> > a high, unnecessary system load. BFP and/or userspace event filtering
> > is not effective enough to avoid it: the resources are already burnt
> > on building up the netlink messages.
> 
> Yes, some fine-grain filtering to avoid the message building would be
> interesting, however, what you're proposing is not flexible enough for
> two different applications that are interested in different events. Time
> ago, I proposed a netlink unicast-based interface for ctnetlink similar
> to nfnetlink_queue and the NFQUEUE target. Still, it needed yet another
> table (at the end of postrouting) for something very specific.

But if application A is interested in event X and application B is 
interested in event Y, then why would it be any problem for the solution 
I'm proposing? Just proper rules are required, then the events X and Y 
will be generated and delivered to the clients. What do I miss here?
 
> > The patch solves the problem by adding the full power of iptables
> > to select which traffic should generate events and by adding new
> > options to the CONNMARK target to specify exactly which events should
> > be generated for the selected traffic.
> > 
> > The downsize is that extra 16 bit required in the nf_conn structure to
> > store the selected event flags.
> > 
> > The events were a little bit reorganized as well:
> > 
> > - IPCT_STATUS is split into IPCT_SEEN_REPLY and IPCT_ASSURED, to express
> >   exactly the state change in conntrack
> > - IPCT_PROTOINFO_VOLATILE renamed to IPCT_ICMP_PROTOINFO, mainly
> >   to get a shorter name ;-)
> 
> In one of my patches here, I have simplified this by removing the
> VOLATILE events which are not of any use.

I suppressed (as much as I was able to) my urge to purge events out ;-).
 
> > - IPCT_HELPINFO_VOLATILE, IPCT_NATINFO and IPCT_COUNTER_FILLING
> >   are dropped
> 
> Yes, those are in my patches as well.
> 
> > - IPEXP_REFRESH and IPEXP_TIMEOUT are added to cover the expectation
> >   events.
> 
> I like this. These are interesting since the ctnetlink expectation
> subsystem is incomplete, but they should go in a different patch to
> complete the expectation events.

Yes, true.
 
> > The single unresolved issue is backward incompatibility: should a module
> > parameter or a sysctl flag be added to the patch to specify the old
> > behaviour (i.e. generate events unconditionally)?
> 
> The main problem with this is that we may have different applications
> with different needs. This must be something configurable from
> user-space, not from the kernel.

Yes, but the kernel must supply all events the different applications 
want. So actually, it's simpler on the kernel side: it needs just to know 
the events wanted. And does not really matter, which application wants 
which event.

[...] 
> In my patches I have added a per-ct event cache like this (but using the
> conntrack extension infrastructure) to add reliable event reporting,
> which is something that we also need for logging and synchronization.
> 
> BTW, I don't like using connmark for this.

You mean the CONNMARK target? I deliberately avoided using the connection 
marks. Or "marking" the connections by the eventmask? But that is the most 
effective way to filter the events.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
