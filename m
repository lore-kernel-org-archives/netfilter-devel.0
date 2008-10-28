From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: NAT in an already established TCP connection
Date: Tue, 28 Oct 2008 12:18:20 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810281206230.2281@fbirervta.pbzchgretzou.qr>
References: <4906F699.6010006@gmail.com> <362dff85992463f0566f965662f8b75b@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
	netfilter@lists.samba.org
To: Diego Casado Mansilla <diego.casadomansilla@gmail.com>,
	Julien Vehent <julien@linuxwall.info>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43962 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbYJ1QSW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Oct 2008 12:18:22 -0400
In-Reply-To: <362dff85992463f0566f965662f8b75b@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-10-28 08:53, Julien Vehent wrote:
>On Tue, 28 Oct 2008 12:25:13 +0100, Diego Casado Mansilla wrote:

>> But this days I'm trying to do NAT in connections that are already 
>> established. The problem is (as far as I know) the packets which pass 
>> throught the nat table are only the SYN packets (once), thus, the 
>> packets that are used to perform a NEW connection.

This is so wrong. Any connection that *Netfilter* (not specifically
the networking stack) does not yet know about is NEW. That might
even be in the middle of a TCP stream -- you can do it: conntrack -F
will clear all connections and thus they will begin with NEW. Not
that this is something you randomly do on a router which only allows
ESTABLISHED or NEW-combined-with-SYN -matched packets.

>> After that the connection is created, the maintenance and the resolution 
>> of the SNAT and DNAT are kept till the connection finish.
>> What I'm wondering is: how can I change the ports or IPs of an already 
>> established connection if my packets just go throught the nat table at 
>> the connection time?

Well they don't go through, hence this is moot. The TCP stack of
the final destination will also be confused. Different port --
different connection. Basic rules of networking.

>If you use UDP, this doesn't apply since there's no connection tracking in
>the UDP protocol. Netfilter, however, does some connection tracking on UDP
>packets, so make some test to see if it's doable.

Same here. A (src, sourceport, dst, dstport) tuple uniquely identifies a
connection. If you change something in this tuple, it is, by definition,
a new one.

