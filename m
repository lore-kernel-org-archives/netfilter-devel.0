From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: How/where does the kernel map packets to an application ...
Date: Thu, 15 Jan 2004 08:10:16 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401150801330.11137-100000@filer.marasystems.com>
References: <200401150910.32898.andrej@paradise.net.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andrej Ricnik <andrej@paradise.net.nz>
In-Reply-To: <200401150910.32898.andrej@paradise.net.nz>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 15 Jan 2004, Andrej Ricnik wrote:

> My idea is to write an addition to netfilter that will check 
> the originating application of an IP request against a list
> of allowed files, and if I handle that well enough, integrate
> a roster of user/application to check whether a request is
> legal or not.

Doesn't this exists already.. checking. You should be able to use the
owner match for this purpose.

> At which point does the kernel determine which application
> a incoming packet is meant for?

Ah, incoming packets. Then the situation is a little harder. The owner 
match only works on outgoing packets.

> Imagine one user having mozilla and opera open, using both for browsing.
> Another user having a links session in a console.

For this, matching outgoing packets is sufficient. Allows you to control 
which applications are allowed to initiate sessions to the network.

For incoming packets you use conntrack to allow only packets belonging to 
sessions accepted above.

> How does the kernel determine which application is meant to receive a
> incoming packet on port 80?

By the socket the packet belongs to. Known to iptables on outgoing 
packets, but on incoming packets the socket is not yet known as this 
is determined by the TCP/UDP layers which are after iptables.

Regards
Henrik
