From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [ANNOUNCE] IP sets
Date: Tue, 17 Feb 2004 14:51:52 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0402171449240.1089@tux.rsn.bth.se>
References: <20040214212340.GC7756@sunbeam.de.gnumonks.org>
 <Pine.LNX.4.33.0402171052590.10727-100000@blackhole.kfki.hu>
 <20040217125710.GA981@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040217125710.GA981@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 17 Feb 2004, Harald Welte wrote:

> I just added another use of vmalloc: dstlimit.  I have to fix that, too.
>
> It would be interesting though, to know how much of a performance
> penalty it implies.

According to Andi Kleen, some machines suffer from excessive TLB thrashing
if you use vmalloc to allocate for example large arrays like the conntrack
hashtable. I remember he said that the performance-problem got solved by
using __get_free_pages() instead, that will only create one TLB-mapping
for the entire thing iirc.

/Martin
