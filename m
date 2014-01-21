From: Patrick McHardy <kaber@trash.net>
Subject: RFC: nftables set selection
Date: Tue, 21 Jan 2014 17:07:42 +0000
Message-ID: <20140121170742.GA8194@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41181 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbaAURHq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jan 2014 12:07:46 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hola,

as promised I've started looking into implementing a better mechanism for
automatic set selection by the kernel.

We have multiple different set implementations in the kernel, which provide
different memory and performance characteristics. Userspace should not
know or hard code these characteristics since they may change and
implementations may get added or removed from the kernel.

So the kernel needs a way to select the ideally best suited implementation
according to characteristics of the data contained in the set and user
preference, like lookup performance, memory usage, updates times.

Wrt. to this problem, we have two fundamentally different situations,
constant sets where the entire content is known at the time the set is
created and non-constant sets, about which in the worst case we know
very little at the time the set is created.

>From what I can tell, there are two possibilities how to do this:

- Dave brought up the idea of simply trying each possible implementation
  and comparing the results. The advantage of this is that we have definite
  information for both constant and non-constant sets, the downsides are
  that the update costs may significantly increase. Its not possible in
  all cases to give an estimate of memory usage just based on the number
  of elements, but the entire set actually has to be built. This is f.i.
  the case for upcoming array mapped trie, where memory usage is dependant
  on the number of clusters in the set,

  Possible refinements of this idea are to only try every N changes or
  when we notice we have to change something anyway, f.i. because of
  too long hash chains.

- My initial idea was to have an abstract description of the data's
  characteristics and have the set implementations return an estimate
  based on this description. This poses two problems: for non-constant
  sets we may not have any data to analyze, so the best we could do is
  either have the user manually specify the expected characteristics,
  or try to deduce them from the ruleset. For both constant and non-
  constant sets we need a notation to describe the data.

Assuming we'd go with the abstract descriptions, the hard part is
getting the information we include right so future implementations
will hopefully have the information they need.

We currently only have two very non-optimized (for our purposes) set
implementations, nft_rbtree and nft_hash. In both cases the number of
elements it pretty much all they need.

I also have two upcoming new set implementations:

- array mapped trie, which is basically a trie with 8 bits per level.
  In this case memory usage doesn't depend on the total amount of keys,
  but on the amount of clusters requiring new leaf nodes.

- offset bitmap: a fixed size bitmap, where the beginning of the range
  is subtracted from the key before the lookup. The costs are constant,
  but depend on the range of the keys.

So, so far we could make a good decision based on the following information:

- number of keys
- key size
- key range
- number of clusters

The number of keys is of course a subset of the number of clusters for
distance 0. To not tie this to the implementation, we could simply
compute the clusters for each possible distance in powers of two up until
the maximum key length.

For non-constant keys, we can simplfy this to have the user specify f.i.
"dense" to indicate that it is expected that many keys will be in proximity.
The number of keys would be an expectation specified by the user. If we
have no information at all, we might simply choose rbtrees, which have
higher costs, but don't degrade as badly as f.i. a badly sized fixed hash.

So the questions are:

- how should we proceed?
- if we go for the set descriptions, what other criteria might be required?
  I'd expect most set implementations to require rather similar information
  to that listed above. What might be missing?

Comments welcome.
