From: Patrick Schaaf <bof@bof.de>
Subject: Re: PATCH: extra conntrack stats
Date: Mon, 28 Apr 2003 15:47:13 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030428134713.GA12364@oknodo.bof.de>
References: <200304192142.h3JLg1S03466@fokkensr.vertis.nl> <20030428091332.GB29390@dns2.italway.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: vecna@s0ftpj.org
Content-Disposition: inline
In-Reply-To: <20030428091332.GB29390@dns2.italway.it>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> in attach I've put a simple patch for make proc entry that report number of
> connection tracked, if anyone is interesting ... I've used them because
> cat /proc/net/ip_conntrack | wc -l is too low with a large number of 
> connection tracked.

I use 'grep conntrack /proc/slabinfo' for this task (first number column
is the number of conntracks currently allocated).

Regarding your patch, it introduces another new place for cache line
pingpong, happening with the same frequency as creation of new conntracks.
That's rather rare, so the new pingpong won't have as much impact as the
per-packet cases, but it's still there.

> in addiction, for large tracking of connection, I think that the problem
> is on the manage of linked list, I'm thinking to implement a system for 
> apply merge sort over sortder array of connection hashs, did you think
> that this should be a good idea ? 

That is not a good idea, it's not the way hashing is supposed to work.
There is no need for ordering anywhere, so no need to sort anything,
as a mergesort would do.

If you have overly long hash chains, use more hash buckets, and, if
neccessary, a better distributing hash function.

best regards
  Patrick
