From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: the solution to synflood on netfilter
Date: Thu, 8 Jan 2004 15:29:49 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401081522400.16050-100000@filer.marasystems.com>
References: <3FFD5221.10503@netlab.hut.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Emmanuel Guiton <emmanuel@netlab.hut.fi>
In-Reply-To: <3FFD5221.10503@netlab.hut.fi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 8 Jan 2004, Emmanuel Guiton wrote:

> About the establishing "illegitimate connections" case, well it worth 
> doing when considering that the processing power/memory needed to take 
> care of the illegitimate connections has more capacity than the backlog 
> queue can accept half-open connections.

For TCP it is very hard to beat the SYN-cookies approach when it comes to
that specific issue. Moves the whole burden to the client while sacrifying
very little of TCP.

But this is only one of many issues to address, and for most if not all 
the firewall will have a harder time to maintain the required information 
than the server itself.

Note: The use of SYN-cookies is far more effective than netfilter
conntrack for SYN flood protection. The two can not even be compared in a
meaningful manner.

Note 2: Only the origin server can make correct use of SYN-cookies. 
Similar approaches done at the firewall level will have far more 
significant impact on TCP operations.

Regards
Henrik
