From: Patrick Schaaf <bof@bof.de>
Subject: Re: ip_conntrack performance issues
Date: Sat, 18 Jan 2003 08:25:56 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030118072556.GB12401@oknodo.bof.de>
References: <200301180113.04460.alchemyx@uznam.net.pl> <1042857018.16805.19.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Micha? Margula <alchemyx@uznam.net.pl>,
  Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1042857018.16805.19.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> /proc/net/ip_conntrack has an O(n^2) complexity and you have to search
> it in a linear fashion. It will never become a fast interface to the
> ip_conntrack hashtable.

In the hope to dispell a possible wrong impression: there's nothing
inherently O(N^2) about /proc/net/ip_conntrack, once you realize that
the walk has never been _accurate_ (duplicates may happen, and
connections may go unnoticed). Just use some place (the user's filp
private pointer, or something) to store not the output offset of
the last read(), but the "next unvisited hash bucket index".

The real problem with the interface, is not the runtime, but the
inaccuracy. Does ctnetlink help with that?

best regards
  Patrick
