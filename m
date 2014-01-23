From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: nftables set selection
Date: Thu, 23 Jan 2014 11:16:13 +0000
Message-ID: <20140123111612.GB3732@macbook.localnet>
References: <20140121170742.GA8194@macbook.localnet>
 <20140122101259.GA4866@localhost>
 <20140122105136.GB8764@macbook.localnet>
 <20140123101429.GA4391@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59040 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbaAWLQR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jan 2014 06:16:17 -0500
Content-Disposition: inline
In-Reply-To: <20140123101429.GA4391@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 23, 2014 at 11:14:29AM +0100, Pablo Neira Ayuso wrote:
> On Wed, Jan 22, 2014 at 10:51:37AM +0000, Patrick McHardy wrote:
> > On Wed, Jan 22, 2014 at 11:12:59AM +0100, Pablo Neira Ayuso wrote:
> > 
> Thanks for the detailed example.
> 
> > Some explanation here: the calculation is a worst case calculation since
> > it can't determine exactly how much memory will be used. Each node on
> > each level can store up to 256 elements or 8 bits of the key.
> >
> > Intermediate nodes have one pointer for each child node, leaf nodes only
> > contain the bitmap. Since we don't know whether the leaf nodes
> > (clusters of size 256) can share intermediate nodes, we assume they can't.
> >
> > So there is the tree root, pointing to a root node, with paths to
> > two levels of intermediate nodes, echo one pointing to a leaf node.
> >
> > - obmap:
> >   not usable since range too large
> 
> What information the obmap uses to decide if the range fits?

Simply the size of the range vs. the size of the bitmap (currently
256 elements). The size of the key doesn't matter, if will subtract
the beginning of the range before the lookup (hance offset bitmap).

> > So based on both size and memory usage the array mapped trie would win.
> > This doesn't factor in constant costs, which are also smaller for the
> > array mapped trie than for hashes. For this I'll probably just use some
> > constant factor.
> 
> I see, with the new amtrie we need the memory consumption
> approximation, otherwise I guess we would need to simulate the
> addition of that element to know the precise memory consumption that
> resulted from inserting that element.

Well, actually its worse than that. If the element falls into an existing
range of 256 elements, it won't consume *any* memory. If not, it might
require up to three new nodes and two pointers. So its not dependant on
the amount of elements, but on their proximity.

> > > Another possibility that I've been considering is that nft makes the
> > > set type selection and tuning from userspace. The idea is that the
> > > kernel provides a listing via netlink of the existing set types,
> > > including a description of the available set type parameters and
> > > performance information (memory consumption per element, lookup time
> > > performance metrics). Based on that information and the abstract set
> > > description, userspace can decide what set type suits better for your
> > > needs.
> > 
> > That's probably even harder than the other way around. As you can see
> > in the amtrie example, but it applies to obmap even more, there is not
> > always a constant cost per element. The obmap has completely constant
> > costs, but is only usable for small ranges, the amtrie has memory costs
> > which depend on the amount of clusters of size 256.
> >
> > I think its not too unreasonable to expect that most algorithms we would
> > use require similar information. Compressed tries would probably slightly
> > differ, but we'd be either using trees, tries or bitmaps I suppose.
> >
> > > One of the things that I like the most in nftables is that the
> > > "intelligence" resides in userspace, so, once we have the generic
> > > kernel infrastructure in place, you only need to update your userspace
> > > tool to get new features. Moreover, if we improve the set selection
> > > logic from userspace, users won't need to wait until distributors
> > > upgrade their kernel to get a better set selection/tuning and I think
> > > we'll end up having quite some debate on the set selection algorithm
> > > as it will be the key to improve performance.
> > > 
> > > So, why don't we perform this set selection/tuning from userspace?
> > 
> > I believe statistical properties of data can be described easier than
> > the properties of the algorithms, especially wrt. memory usage.
> 
> Wouldn't the approximated memory consumption and lookup be enough to
> perform a good set selection from userspace?

Well, if we give the approximated data to userspace, we already need
the description. If userspace should approximate itself, we need a
notation to describe the memory and performance characteristics.

I'm having a hard time coming up with something fitting. How would you
describe the amtrie or obmap? Or even worse, a compressed trie?
