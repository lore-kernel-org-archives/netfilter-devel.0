From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: New logging module
Date: Sat, 6 Sep 2003 03:13:08 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0309060259570.4937-100000@filer.marasystems.com>
References: <20030905140435.GI1597@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030905140435.GI1597@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 5 Sep 2003, Harald Welte wrote:

> 3) as part of ip_conntrack
> 
> this means that every struct ip_conntrack gets two byte counters (one
> for each direction).  when a connection is terminated, you send the
> accounting information about this connection to usrerspace (preferrably
> via netlink).   you can sum up traffic for certain ports / addresses in
> userspace.
> 
> pro: very easy implementation 
> pro: you can easily generate industry-standard netflow logfiles
> pro: at most one context switch per _connection_
> 
> 4) in userspace, receiving packets via ULOG 
> 
> this means that the first n (user-defined) bytes of every packet gets
> copied into a buffer, and this buffer is flushed to userspace when it
> fills up (usually every 1000-5000 packets) or a timer goes off.  all
> further processing is just like nacctd completely userspace based
> 
> From my point of view, either solutions 3 or 4 should be used (depending
> on the specific case).


3 looks very intersting and is something which we have been thinking we
need for a long time to implement meaningful accounting in a
iptables+conntrack+NAT based firewall.

What we have considered to log from conntrack is maybe a little more than
described above:

1. Start of session

2. Periodically while the conntrack session is active (preferably 
by a configurable interval)

3. End of session

with byte and packet counters in both directions.

'2' to be able to account "last 5 minutes of traffic" even if there is 
long-running sessions, but not too often. Once per accounting interval 
used is required, more often is overhead, less gives less accuracy than 
desired for the accounting.

Do you know if anyone else is attempting to do this?  If not we might give
it a stab shortly..

Regards
Henrik
