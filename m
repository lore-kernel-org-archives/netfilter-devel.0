From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC] libnfnetlink and iface conversion to string
Date: Tue, 09 Jan 2007 01:53:30 +0100
Message-ID: <45A2E78A.8090402@netfilter.org>
References: <1167257854.31765.21.camel@localhost>	
	<45940145.3020003@netfilter.org>
	<1167349247.15420.13.camel@localhost>	
	<20070107142607.GC13543@prithivi.gnumonks.org>
	<1168296086.12298.6.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>, Vincent Deffontaines <vincent@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1168296086.12298.6.camel@localhost>
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

Eric Leblond wrote:
> It is not correct to do a dump (and send a netlink message) for each
> ifindex resolution. Thus, libnfnetlink needs to listen to netlink
> interfaces message. A permanent "task" is thus needed to have the job
> done : It can be a dedicated thread or a carefully hidden select.
> 
> In fact, if we omit the thread approach which is somehow intrusive, I
> don't see a way to do this via a simple call to added functions.

You have to open a netlink socket for NETLINK_ROUTE, request a dump
(RTM_GETLINK) to keep a cache of current tuples interface/index
available, and subscribe to interface events (RTNLGRP_LINK) to keep the
cache up to date. You can put both the nfqueue and the rtnetlink sockets
in a poll. Something like:

/* create a table ifindex to interface */
struct nfnl_ifindex2name_table *nfnl_ifindex2name_open();
/* destroy table */
void nfnl_ifindex2name_close(struct nfnl_ifindex2name_table *);

/* returns a socket descriptor to listen to interface events */
int nfnl_ifindex2name_events_open();
/* process data available for the socket and update the table */
int nfnl_ifindex2name_process_event(int, struct nfnl_ifindex2name_table *);
/* close socket */
void nfnl_ifindex2name_events_close(int); /* close the socket */

Another alternative could be the use of libnl, although this introduces
a new library dependency for every libnetfilter_queue application.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
