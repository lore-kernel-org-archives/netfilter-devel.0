From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_ct_sctp: validate vtag for new conntrack
 entries
Date: Thu, 17 Dec 2015 12:05:12 +0100
Message-ID: <20151217110512.GA1863@salvia>
References: <85c8c8c570bdbf6f20f56fdef96d8017fea3cc4c.1449579256.git.marcelo.leitner@gmail.com>
 <20151210120233.GA2084@salvia>
 <56697B14.3010909@gmail.com>
 <20151210134247.GA3942@salvia>
 <20151210140625.GC3886@mrl.redhat.com>
 <20151210170647.GA1547@salvia>
 <20151215190304.GA3724@mrl.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org,
	Vlad Yasevich <vyasevich@gmail.com>,
	Neil Horman <nhorman@tuxdriver.com>, mkubecek@suse.cz
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59911 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932323AbbLQLFZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Dec 2015 06:05:25 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 26FF81392A0
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2015 12:05:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1464BDA57C
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2015 12:05:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B453CDA8E5
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2015 12:05:15 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151215190304.GA3724@mrl.redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 15, 2015 at 05:03:04PM -0200, Marcelo Ricardo Leitner wrote:
> On Thu, Dec 10, 2015 at 06:06:57PM +0100, Pablo Neira Ayuso wrote:
> > I think in this case it doesn't make sense to have a pointer to the
> > master conntrack for a new sctp flow that got established via
> > expectation. That new sctp flow would be completely independent. I
> 
> Not really. It's just another path/transport for the same sctp
> association. From sctp point of view, these two conntrack entries share
> their end points, they refer to the same sockets.

Then, you will need add support for expected conntrack with no master.

> > > > > This was the main reason that I didn't use expectations.  Yet this
> > > > > req changed when I realized that we can't process ASCONF chunks without
> > > > > validating the AUTH chunk first, which we just can't just when in the middle
> > > > > of the communication.
> > > > 
> > > > OK, so that's why we cannot create expectations for specific
> > > > addresses, right?
> > > 
> > > Right. We would be trusting un-trusty data.
> > 
> > I see, but without IP source and destination address in the
> > expectation, how is this effective from a security point of view? My
> > concerns go in the direction of possible spoofing that result in holes
> > in the firewall for sctp traffic.
> 
> It may not be 100% secure without the IP addresses in it but it adds
> another 32bit that the attacker must be able to match in order to get
> through that door.
> 
> Currently, if the attacker knows the ports used, it's enough to get
> at least a heartbeat through.

You have to come back to us to evaluate how feasible is to push holes
in the firewall through this helper and what the attacker would get
from this attack.

Anyway, what I'm going to propose you below will allow the user to
narrow down what peers are allowed to create sctp multihoming
expectations.

> About the idea to put the vtag into the tuple itself, this is more like a heads
> up, sharing it early. I'm afraid that's going to be very complicated because we
> store all infos in u union in big endian.
> 
>                 union {
>                         /* Add other protocols here. */
>                         __be64 all;
> 			    ^^-- to fit the new be32 (was be16)
> 
>                         struct {
>                                 __be16 port;
>                         } tcp;
>                         struct {
>                                 __be16 port;
>                         } udp;
>                         struct {
>                                 u_int8_t type, code;
>                         } icmp;
>                         struct {
>                                 __be16 port;
>                         } dccp;
>                         struct {
>                                 __be16 port;
>                                 __be32 vtag;
>                         } sctp;  <-- expanded
> 
> but this change will cause the structs with __be16 to read the higher
> portion of that be64 instead if on a little-endian system.

We should avoid this change in the structure. I'd suggest you better
extended nf_ct_find_expectation so it handles the special case to
include the vtag in the search when this is SCTP traffic. There must
be a generic way to accomodate this. You may need a specific
expectation for SCTP (so the hashing includes the vtag from the
ct->state). So the impact to add SCTP multihoming support is minimal
given that we'll have very little clients of this code.

To be more concrete on the path I would follow, I think you have to a
sctp-multihoming helper just like we do for FTP, IRC, GRE, Netbios and
friends. The idea is that you register a new struct
nf_conntrack_helper into the infrastructure. The help function will
inspect for HEARTBEAT chunks, if found, it will create the
expectation.

Given that we'll be disabling automagic helper assignment soon (the
existing behaviour is problematic from the security point of view, see
Eric Leblond's documentation on this), the user can probably skip the
possible security problems that we're discussing above by narrowing
down the possible SCTP peers that are allowed to create multihoming
expectations when explicitly configuring the helper through iptables.
This should also allow you to skip the sysctl that you need.

Have a look at: https://home.regit.org/netfilter-en/secure-use-of-helpers/
