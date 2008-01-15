From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3] Solving scalability issue: for chain list "name"
 searching.
Date: Tue, 15 Jan 2008 18:18:48 +0100
Message-ID: <478CEAF8.5020509@trash.net>
References: <1198244659.23885.8.camel@localhost.localdomain> <1198245030.23885.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@vger.kernel.org>,
	Harald Welte <laforge@netfilter.org>,
	Martin Josefsson <gandalf@netfilter.org>
To: jdb@comx.dk
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45105 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbYAORSx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 12:18:53 -0500
In-Reply-To: <1198245030.23885.17.camel@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jesper Dangaard Brouer wrote:
> Solving scalability issue: for chain list "name" searching.
> Functions: iptcc_find_label(), iptc_is_chain().
>
> Testing if a chain exist, requires a linearly walk of linked list with
> chain-names (doing a strcmp(3) in each step). Giving a worst-case
> runtime of O(n) where n is the number of chains.
>
> Why is this important to fix?! If only called once, this should not be
> a big concern, even-though the string compares are expensive.
>
> The performance issue arise with many chains for example; when using
> "iptables-restore", or when listing all "iptables -nL" rules, or when
> using CPAN IPTables::libiptc.
>
> Having 50k chains, the rule listing, with the command:
>  "./iptables -nL > /dev/null",
> Without patch it takes approximately 5 minutes,
> With the patch it takes 0.5 seconds.
>
> Listing without patch:
>  real    4m49.426s
>  user    4m37.993s
>  sys     0m0.280s
>
> Listing with patch:
>  real    0m0.558s
>  user    0m0.484s
>  sys     0m0.064s
>
> How is it solved?!
>
> The issue is solved introducing a new data structure, that allow us to
> do binary search of chain names. Thus, reducing the worst-case runtime
> to O(log n).
>
> Being more specific:
>
>  The new data structure is called "chain index", which is an array with
>  pointers into the chain list, with CHAIN_INDEX_BUCKET_LEN spacing.
>  This facilitates the ability to speedup chain list searching, by find
>  a more optimal starting points when searching the linked list.
>
>  The runtime complexity is actually also affected by this "bucket" size
>  concept. Thus, O(log(n/k) + k) where k is CHAIN_INDEX_BUCKET_LEN.
>
>  A nice property of the chain index, is that the "bucket" list
>  length is max CHAIN_INDEX_BUCKET_LEN (when just build, inserts will
>  change this). Oppose to hashing, where the "bucket" list length can
>  vary a lot.
>
> Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>

This looks fine and survives some basic testing, so I've applied it.
Thanks a lot Jesper.

