From: Andi Kleen <ak@suse.de>
Subject: Re: use of vmalloc within netfilter (was Re: [ANNOUNCE] IP sets)
Date: Wed, 18 Feb 2004 08:12:50 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040218081250.20edb2b5.ak@suse.de>
References: <20040214212340.GC7756@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.33.0402171052590.10727-100000@blackhole.kfki.hu>
	<20040217125710.GA981@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.58.0402171449240.1089@tux.rsn.bth.se>
	<20040217141840.GJ981@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: gandalf@wlug.westbo.se, kadlec@blackhole.kfki.hu,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040217141840.GJ981@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 17 Feb 2004 15:18:40 +0100
Harald Welte <laforge@netfilter.org> wrote:

> Cc'ing Andi, to give us some clue ;)
> 
> On Tue, Feb 17, 2004 at 02:51:52PM +0100, Martin Josefsson wrote:
> > On Tue, 17 Feb 2004, Harald Welte wrote:
> > 
> > > I just added another use of vmalloc: dstlimit.  I have to fix that, too.
> > >
> > > It would be interesting though, to know how much of a performance
> > > penalty it implies.
> > 
> > According to Andi Kleen, some machines suffer from excessive TLB thrashing
> > if you use vmalloc to allocate for example large arrays like the conntrack
> > hashtable. I remember he said that the performance-problem got solved by
> > using __get_free_pages() instead, that will only create one TLB-mapping
> > for the entire thing iirc.
> 
> The question is:  Is the penalty only for allocationg of the memory
> (then it would be no problem, since it's a one-time allocation when we
> load the module).  If there also is a penalty during runtime (i.e.
> accessing/updating the vmalloc'ed memory), we really should change our
> code.

The penalty is at runtime. Excessive is a bit overstated though,
it will be likely slower but not that much slower.

Best is if you measure yourself. Run a hash table intensive workload
with oprofile and check if you're getting lots of TLB misses.

However before attacking the vmalloc you could consider improving the hash
function and making the hash table smaller too (most hash tables in Linux
seem to be too big)

-Andi
