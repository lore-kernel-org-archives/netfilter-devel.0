From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: =?iso-8859-1?Q?question?=
Date: Fri, 23 Jan 2004 13:21:51 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401231307440.12080-100000@filer.marasystems.com>
References: <HRU2W7$64C9358E9A23239906B5624603A3F140@tiscali.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: =?iso-8859-1?Q?netfilter-devel?= <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: =?iso-8859-1?Q?Jeanmich?= <jm.cornilleau@freesbee.fr>
In-Reply-To: <HRU2W7$64C9358E9A23239906B5624603A3F140@tiscali.fr>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 21 Jan 2004, Jeanmich wrote:

> I would like to protect myself against syn flooding.

What kind of SYN flooding of what?

> Obviously, i've looked on the web and i found 2 solutions :
> 
> -1- echo 1 in the file /proc/sys/net/ipv4/tcp_syncookies
> -2- iptables -A FORWARD -p tcp --syn -m limit --limit
> 1/second -J ACCEPT

The first makes Linux deal with SYN flooding on any services given by THIS 
Linux box. It does nothing on forwarded traffic.

THe second makes sure SYN "flooding" guantees a Denial of Service any new
sessions matching that rule in order to protect servers from becoming
overloaded by too many new sessions too fast, but without regard to the
actual load on the server.  This type of protection is highly overrated
and almost always causes more problems than it solves.  SYN flooding
SHOULD be addressed on the actual server using approach '1' or equivalent
(depending on the Server OS).

Neither protects from connection flooding if the server accepts long 
connections. And again connection flooding SHOULD be addressed on the 
server if possible as firewalling has much less knowledge of what is 
actually going on within the active sessions.

> When i've have a look in
> /usr/scr/linux/Documentation/networking/ip-sysctl.txt, i
> understand that it is a "facility" to use -1-, and that -1-
> is often hiding "misconfigured" servers.

This is not what the documentation says. What it says is that 
syncookies is not a substitute for a large SYN backlog unless there 
actually is a synflood in progress.

Both syncookies and SYN backlog is only relevant on connections to this
server. It is not related to forwarded traffic.

Regards
Henrik
