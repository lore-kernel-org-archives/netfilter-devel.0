From: Patrick McHardy <kaber@trash.net>
Subject: Re: SNMP conntrack module a la netbios_ns
Date: Fri, 04 Dec 2009 11:20:32 +0100
Message-ID: <4B18E270.8090408@trash.net>
References: <1259920389.2510.30.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Tim Waugh <twaugh@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51824 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402AbZLDKU2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Dec 2009 05:20:28 -0500
In-Reply-To: <1259920389.2510.30.camel@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[netfilter-devel is the correct list for development questions, CCed]

Tim Waugh wrote:
> I maintain the printing stack for Fedora and Red Hat Enterprise Linux,
> and I've become aware of a need for another conntrack module very
> similar to nf_conntrack_netbios_ns.
> 
> When CUPS searches for network printers it issues an SNMP broadcast
> query from a random source port and to the SNMP destination port, and
> waits for (unicast) replies from printers, following up each reply with
> a set of unicast SNMP queries.
> 
> The problem is that the iptables rules discard the replies to the
> initial broadcast query.
> 
> It looks like a conntrack module is what's needed to fix the problem,
> and the netbios_ns module very nearly solves it: the only changes I can
> see would be needed are the port number and the maximum number of
> expected replies.

Yes, I think Samir Bellabes mentioned this as well back when I added
that module.

> Is this something that warrants a more generic module so that code can
> be shared between them, or would it be better to just copy the code and
> make the changes?

The best solution would be to add generic broadcast tracking, the
use of expectations for this is a bit of abuse.

The second best choice I guess would be to move the help() function
to a shared module and generalize it so it can be used for both.
Basically I think it would come down to changing:

exp->tuple.dst.u.udp.port = htons(NMBD_PORT);

to:

struct nf_conn_help *help = nfct_help(ct);
...
exp->tuple.dst.u.udp.port = help->helper->tuple.src.u.udp.port;
