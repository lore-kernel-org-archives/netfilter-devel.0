From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [ANNOUNCE] IP sets
Date: Tue, 17 Feb 2004 14:56:47 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402171452020.30953-100000@filer.marasystems.com>
References: <Pine.LNX.4.58.0402171348210.1089@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <Pine.LNX.4.58.0402171348210.1089@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 17 Feb 2004, Martin Josefsson wrote:

> Maybe try __get_free_pages() and fall back to vmalloc() if it fails?
> 
> The downside of __get_free_pages() is that you get 2^n pages of memory
> which might result in a quite large allocation sometimes.

Sounds worse than using vmalloc() to me.

The main issue here is design requiring a large allocation, not which
memory allocation method is used.

Wrt the conntrack hashtable, has there been any thought about using a tree
instead of a hash for conntrack?

Regards
Henrkik
