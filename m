From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: nftables set selection
Date: Wed, 22 Jan 2014 10:51:37 +0000
Message-ID: <20140122105136.GB8764@macbook.localnet>
References: <20140121170742.GA8194@macbook.localnet>
 <20140122101259.GA4866@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48281 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbaAVKvl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jan 2014 05:51:41 -0500
Content-Disposition: inline
In-Reply-To: <20140122101259.GA4866@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 22, 2014 at 11:12:59AM +0100, Pablo Neira Ayuso wrote:
> Hola Patrick,
> 
> On Tue, Jan 21, 2014 at 05:07:42PM +0000, Patrick McHardy wrote:
> > So, so far we could make a good decision based on the following information:
> > 
> > - number of keys
> > - key size
> > - key range
> > - number of clusters
> > 
> > The number of keys is of course a subset of the number of clusters for
> > distance 0. To not tie this to the implementation, we could simply
> > compute the clusters for each possible distance in powers of two up until
> > the maximum key length.
> > 
> > For non-constant keys, we can simplfy this to have the user specify f.i.
> > "dense" to indicate that it is expected that many keys will be in proximity.
> > The number of keys would be an expectation specified by the user. If we
> > have no information at all, we might simply choose rbtrees, which have
> > higher costs, but don't degrade as badly as f.i. a badly sized fixed hash.
> > 
> > So the questions are:
> > 
> > - how should we proceed?
> > - if we go for the set descriptions, what other criteria might be required?
> >   I'd expect most set implementations to require rather similar information
> >   to that listed above. What might be missing?
> 
> I also think we need that set description, otherwise empty set
> handling is going to get more complicated, since we'll have to
> re-evaluate the selected set everytime we add a new element. If we
> don't have that abstract description, we would also need to be
> inferred from the elements, that can be expensive for large sets.
> More specifically, regarding the set description information fields
> that you propose, could you elaborate an example of how the selection
> would happen based on the ones that you propose above?

Well, assuming (for a constant set) userspace provides the information:

- key size 4 bytes
- number of keys 64
- key range 192.168.0.0-192.168.1.200
- number of clusters (just for distance 256 included here) 2

So the kernel would ask each set for an appromixation of expected
memory use and performance:

- rbtree:
  mem = sizeof(struct nft_rbtree) + 64 * sizeof(struct nft_ebtree_elem)
      = 3080b
  lookup = O(log N)

- hash:
  size = sizeof(struct nft_hash) + 4/3 * 64 * sizeof(struct hlist_head) +
         64 * sizeof(struct nft_hash_elem)
       = 2746b
  lookup = O(1)

- amtrie:
  size = sizeof(struct nft_amtrie) +
	 sizeof(struct nft_amtrie_node) +
         num_clusters * (key_size - 2) * (sizeof(struct nft_amtrie_node) +
					  sizeof(struct nft_amtrie_node *) +
	 num_clusters * (sizeof(struct nft_amtrie_node)
	
       = 280b

  lookup = O(1)

Some explanation here: the calculation is a worst case calculation since
it can't determine exactly how much memory will be used. Each node on
each level can store up to 256 elements or 8 bits of the key.
Intermediate nodes have one pointer for each child node, leaf nodes only
contain the bitmap. Since we don't know whether the leaf nodes
(clusters of size 256) can share intermediate nodes, we assume they can't.

So there is the tree root, pointing to a root node, with paths to
two levels of intermediate nodes, echo one pointing to a leaf node.

- obmap:
  not usable since range too large

So based on both size and memory usage the array mapped trie would win.
This doesn't factor in constant costs, which are also smaller for the
array mapped trie than for hashes. For this I'll probably just use some
constant factor.

> Another possibility that I've been considering is that nft makes the
> set type selection and tuning from userspace. The idea is that the
> kernel provides a listing via netlink of the existing set types,
> including a description of the available set type parameters and
> performance information (memory consumption per element, lookup time
> performance metrics). Based on that information and the abstract set
> description, userspace can decide what set type suits better for your
> needs.

That's probably even harder than the other way around. As you can see
in the amtrie example, but it applies to obmap even more, there is not
always a constant cost per element. The obmap has completely constant
costs, but is only usable for small ranges, the amtrie has memory costs
which depend on the amount of clusters of size 256.

I think its not too unreasonable to expect that most algorithms we would
use require similar information. Compressed tries would probably slightly
differ, but we'd be either using trees, tries or bitmaps I suppose.

> One of the things that I like the most in nftables is that the
> "intelligence" resides in userspace, so, once we have the generic
> kernel infrastructure in place, you only need to update your userspace
> tool to get new features. Moreover, if we improve the set selection
> logic from userspace, users won't need to wait until distributors
> upgrade their kernel to get a better set selection/tuning and I think
> we'll end up having quite some debate on the set selection algorithm
> as it will be the key to improve performance.
> 
> So, why don't we perform this set selection/tuning from userspace?

I believe statistical properties of data can be described easier than
the properties of the algorithms, especially wrt. memory usage.
