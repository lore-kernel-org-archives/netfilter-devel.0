From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 10/10][CONNTRACK] introduce the pickup flag to take over
 connections
Date: Mon, 17 Jul 2006 10:17:07 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0607171007280.964@blackhole.kfki.hu>
References: <44ADC415.5030407@netfilter.org>
	<Pine.LNX.4.58.0607091718580.11722@blackhole.kfki.hu>
	<44B6AB69.7030700@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <44B6AB69.7030700@netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 13 Jul 2006, Pablo Neira Ayuso wrote:

> Jozsef Kadlecsik wrote:
> > Hi Pablo,
> >
> > On Fri, 7 Jul 2006, Pablo Neira Ayuso wrote:
> >
> >
> >>This patch introduces a new flag called IPS_PICKUP that forces the
> >>protocol handler to pick up the required information in order to ensure
> >>that the connection will reach a successful state. Currently, the only
> >>client is the TCP protocol helper.
> >>
> >>More arguments conntrackd or whatever failover solution need this.
> >>
> >>@Jozsef: You know better TCP sequence tracking in-deep details, can you
> >>see any problem with this?
> >
> > Nothing against it as I see. But I'd regard it as a preliminary step
> > toward creating conntrack entries by conntrackd/failover: the missing bits
> > are the flags (SACK and WSCALE) and the window scale factor. We assume
> > SACK is on (which thus don't hurt), but disabled window scaling can really
> > bite if it's actually on.
>
> Interesting, since the scale factor is only advertised in the SYN+ACK
> packet, we need a patch to introduce a new ctnetlink attribute that
> contains the scale factor. I think that should be enough.

Yes, that'd be sufficient (of course it can be advertised in both
directions). Window scaling is a must when someone wants to utilize a high
badwidth connection as much as possible in one TCP stream and conntrack
can go totally wrong if it uses wrong scale factors.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
