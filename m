From: Ilguiz Latypov <ilguiz@nit.ca>
Subject: Re: How to Send Raw IP datagrams?
Date: Sat, 29 Mar 2003 21:54:21 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0303292111080.23834-100000@localhost.localdomain>
References: <Pine.GSO.4.53.0303291701390.9064@teer20.acpub.duke.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: efd@duke.edu
In-Reply-To: <Pine.GSO.4.53.0303291701390.9064@teer20.acpub.duke.edu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


On Sat, 29 Mar 2003 efd@duke.edu wrote:

> Here is what I'm doing, but send() keeps returning -1 as an error occurs
> somewhere.

What do errno and/or strerror() say?

Isn't it necessary to bind() the socket to a network interface by
specifying the IP address of the interface?

It seems reasonable if the INADDR_ANY value in the bind() call would not
help to send raw IP packets.  I would assume that the kernel might not
want to look for the right network interface from which to send the raw IP
packet.

Many open source programs such as tcpdump, DHCP family etc. can serve as
an example of binding to a particular network interface.  I wrote some C
code to walk through network interfaces in the multicast BOOTP
server/client at

   http://mbootp.sf.net/

--
Ilguiz Latypov
Net Integration Technologies, Inc

tel. +1 (514) 281 9191 x 117
