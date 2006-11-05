From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] new API for libnetfilter_conntrack
Date: Sun, 05 Nov 2006 17:45:32 +0100
Message-ID: <454E152C.3090607@trash.net>
References: <45456285.4010609@netfilter.org> <454B13D7.4070006@trash.net>
	<454DF5EA.6030402@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <454DF5EA.6030402@netfilter.org>
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

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
> 
>>I like that approach. Its getting pretty close to the libnl API,
>>have you considered integrating this in libnl?
> 
> 
> I'm going to, I'm not too familiar with libnl (just spend some hours
> yesterday and today) but I agree that the new API is getting close. At
> first sight, my impression is that most of the code of my current patch
> could be adapted to introduce ctnetlink support in libnl, and I don't
> mind about doing so in the close future.
> 
> Perhaps we can introduce some kind of dependency between libnl and
> libnetfilter_* (of course, providing an homogeneous API) but I'm unsure
> that Thomas would like that.

I don't think thats necessary, libnl includes all the infrastrucure
needed to handle nfnetlink.

> I agree that people could choose between different libraries depending
> on their preferences but at the moment I'm unsure that this would imply
> dropping support for our libraries.
> 
> Back to libnl, I think that the cache thing provided by the library is
> nice to implement quick applications without too much effort but I'm
> unsure that this is the place to put this, I think that the data
> structure used to store the entries of, say the neighbour cache, must be
> up to the programmer (array, hash table, tree...), although nothing
> prevents the programmer of not using the cache thing.

Agreed. I have a patch that replaces the linked list caches by hashes,
but it has some drawbacks since not all objects are suitable for
hashing without making expectations about their use. It shouldn't
be hard to use your own scheme, I think the only thing that
prevents it right now is that the structure is hidden from API
users.

> Anyway, I'm going to post the patches for libnfnetlink and
> libnetfilter_conntrack soon, please let me make peace and apply them
> since I do need them in mainline as well as many other people, we can go
> back to this discussion later once I get more familiarized with libnl.

Sure. Harald is renewing your keys, so you can simply apply it yourself.
