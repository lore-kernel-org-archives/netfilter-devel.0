From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: RFC: nftables set selection
Date: Thu, 23 Jan 2014 11:14:29 +0100
Message-ID: <20140123101429.GA4391@localhost>
References: <20140121170742.GA8194@macbook.localnet>
 <20140122101259.GA4866@localhost>
 <20140122105136.GB8764@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53644 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851AbaAWKcb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jan 2014 05:32:31 -0500
Content-Disposition: inline
In-Reply-To: <20140122105136.GB8764@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 22, 2014 at 10:51:37AM +0000, Patrick McHardy wrote:
> On Wed, Jan 22, 2014 at 11:12:59AM +0100, Pablo Neira Ayuso wrote:
> 
> Well, assuming (for a constant set) userspace provides the information:
> 
> - key size 4 bytes
> - number of keys 64
> - key range 192.168.0.0-192.168.1.200
> - number of clusters (just for distance 256 included here) 2
> 
> So the kernel would ask each set for an appromixation of expected
> memory use and performance:
> 
> - rbtree:
>   mem = sizeof(struct nft_rbtree) + 64 * sizeof(struct nft_ebtree_elem)
>       = 3080b
>   lookup = O(log N)
> 
> - hash:
>   size = sizeof(struct nft_hash) + 4/3 * 64 * sizeof(struct hlist_head) +
>          64 * sizeof(struct nft_hash_elem)
>        = 2746b
>   lookup = O(1)
> 
> - amtrie:
>   size = sizeof(struct nft_amtrie) +
> 	 sizeof(struct nft_amtrie_node) +
>          num_clusters * (key_size - 2) * (sizeof(struct nft_amtrie_node) +
> 					  sizeof(struct nft_amtrie_node *) +
> 	 num_clusters * (sizeof(struct nft_amtrie_node)
> 	
>        = 280b
> 
>   lookup = O(1)

Thanks for the detailed example.

> Some explanation here: the calculation is a worst case calculation since
> it can't determine exactly how much memory will be used. Each node on
> each level can store up to 256 elements or 8 bits of the key.
>
> Intermediate nodes have one pointer for each child node, leaf nodes only
> contain the bitmap. Since we don't know whether the leaf nodes
> (clusters of size 256) can share intermediate nodes, we assume they can't.
>
> So there is the tree root, pointing to a root node, with paths to
> two levels of intermediate nodes, echo one pointing to a leaf node.
>
> - obmap:
>   not usable since range too large

What information the obmap uses to decide if the range fits?

> So based on both size and memory usage the array mapped trie would win.
> This doesn't factor in constant costs, which are also smaller for the
> array mapped trie than for hashes. For this I'll probably just use some
> constant factor.

I see, with the new amtrie we need the memory consumption
approximation, otherwise I guess we would need to simulate the
addition of that element to know the precise memory consumption that
resulted from inserting that element.

> > Another possibility that I've been considering is that nft makes the
> > set type selection and tuning from userspace. The idea is that the
> > kernel provides a listing via netlink of the existing set types,
> > including a description of the available set type parameters and
> > performance information (memory consumption per element, lookup time
> > performance metrics). Based on that information and the abstract set
> > description, userspace can decide what set type suits better for your
> > needs.
> 
> That's probably even harder than the other way around. As you can see
> in the amtrie example, but it applies to obmap even more, there is not
> always a constant cost per element. The obmap has completely constant
> costs, but is only usable for small ranges, the amtrie has memory costs
> which depend on the amount of clusters of size 256.
>
> I think its not too unreasonable to expect that most algorithms we would
> use require similar information. Compressed tries would probably slightly
> differ, but we'd be either using trees, tries or bitmaps I suppose.
>
> > One of the things that I like the most in nftables is that the
> > "intelligence" resides in userspace, so, once we have the generic
> > kernel infrastructure in place, you only need to update your userspace
> > tool to get new features. Moreover, if we improve the set selection
> > logic from userspace, users won't need to wait until distributors
> > upgrade their kernel to get a better set selection/tuning and I think
> > we'll end up having quite some debate on the set selection algorithm
> > as it will be the key to improve performance.
> > 
> > So, why don't we perform this set selection/tuning from userspace?
> 
> I believe statistical properties of data can be described easier than
> the properties of the algorithms, especially wrt. memory usage.

Wouldn't the approximated memory consumption and lookup be enough to
perform a good set selection from userspace?
