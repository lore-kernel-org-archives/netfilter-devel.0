From: Patrick Schaaf <bof@bof.de>
Subject: Re: ip_conntrack performance issues
Date: Sat, 18 Jan 2003 08:43:06 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030118074306.GC12401@oknodo.bof.de>
References: <200301180113.04460.alchemyx@uznam.net.pl> <1042857018.16805.19.camel@tux.rsn.bth.se> <20030118072556.GB12401@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Martin Josefsson <gandalf@wlug.westbo.se>,
  Micha? Margula <alchemyx@uznam.net.pl>,
  Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20030118072556.GB12401@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> The real problem with the interface, is not the runtime, but the
> inaccuracy. Does ctnetlink help with that?

Too early in the morning... The question should be "does ctnetlink
help to provide an accurate O(N) scan over all connections, neither
returning a connection twice during one scan, nor ommitting any
connection that was alive between the start of the scan, and the
current scan time point".

For the O(1) oident _lookup_ case, all this is irrelevant, and an
interface like /proc/net/ip_conntrack is inefficient IN PRINCIPLE.
It is clear that the query functionality of ctnetlink solves this.

best regards
  Patrick
