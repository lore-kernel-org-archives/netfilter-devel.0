From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: [RFC] [NETFILTER] nf_conntrack: more efficient helper lookup
Date: Mon, 13 Feb 2006 10:59:46 +0100
Message-ID: <1139824786.5141.17.camel@bzorp.balabit>
References: <20060212181648.GH4601@sunbeam.de.gnumonks.org>
	<43EFA7E6.7040909@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@eurodev.net>
In-Reply-To: <43EFA7E6.7040909@eurodev.net>
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

On Sun, 2006-02-12 at 22:25 +0100, Pablo Neira Ayuso wrote:

> Since the number of helpers is really small, I'm not sure about the
> benefits of this patch. The hash calculation adds a constant to the
> algorithm complexity that could result in a similar execution time for
> this and the current approach. A benchmark could throw some light on this.
> 
> What about just killing the tuple and mask fields and keep the current
> approach of the helper list?

Maybe a simple dynamically sized array of helper structures would be
more cache friendly instead of the linked list. IIRC hipac used arrays
instead of lists/hashtables for the very same reason.

A single helper would be no more than 8 bytes (l3proto, l4proto
dstproto, pointer to helper structure), maybe we can also skip the
dynamically allocated part. Statically allocated 256 bytes (a single
cacheline!) would be enough for 32 helpers which is plenty.

-- 
Bazsi
