From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [ANNOUNCE] IP sets
Date: Tue, 17 Feb 2004 14:50:16 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402171419580.30790-100000@filer.marasystems.com>
References: <20040217125710.GA981@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
   <netfilter-devel@lists.netfilter.org>
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

> It would be interesting though, to know how much of a performance
> penalty it implies.

There is mainly a penalty at allocation and initial population time for
setting up the page maps and flushing the TLB. This is quite significant 
compared to kmalloc, but still negliable if used correctly.

Once the memory area is set up and populated causing it to be mapped the
performance is mostly the same as kmalloc:ed memory.

The other issue is that the vmalloc memory area is quite limited in size
on many architectures, sitting between the user-process and the physical
memory ranges, and is also subject to fragmentation if there is frequent 
vmalloc/vfree calls.

vmalloc is designed for a few static largeish memory allocations where you
do not need pysically ajdacent memory and want to avoid failing due to
kernel memory fragmentation, not for frequent or very large allocations.

Regards
Henrik
