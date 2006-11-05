From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC] new API for libnetfilter_conntrack
Date: Sun, 05 Nov 2006 15:32:10 +0100
Message-ID: <454DF5EA.6030402@netfilter.org>
References: <45456285.4010609@netfilter.org> <454B13D7.4070006@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <454B13D7.4070006@trash.net>
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

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> Hi,
>>
>> Attached a patch, yet incomplete, that introduces the new API for
>> libnetfilter_conntrack. Basically the idea consists of providing
>> "conntrack" objects constructor/destructor functions and an interface to
>> get and set object attributes. The conntrack object structure is
>> encapsulated therefore we can add new attributes without breaking binary
>> backward compatibility. There is an example of the new API use in the
>> patch (see test.c file)
>>
>> See that conntrack object attributes are different from the netlink
>> attributes therefore they provide a high level interface that abstract
>> from netlink details. The idea is to let the programmer make the choice
>> to work with high level (objects) or low level (netlink) and provide the
>> gateways to switch from high to low level and vice-versa by means of
>> functions to build/parse netlink messages from/to conntrack objects.
>>
>> [...]
> 
> I like that approach. Its getting pretty close to the libnl API,
> have you considered integrating this in libnl?

I'm going to, I'm not too familiar with libnl (just spend some hours
yesterday and today) but I agree that the new API is getting close. At
first sight, my impression is that most of the code of my current patch
could be adapted to introduce ctnetlink support in libnl, and I don't
mind about doing so in the close future.

Perhaps we can introduce some kind of dependency between libnl and
libnetfilter_* (of course, providing an homogeneous API) but I'm unsure
that Thomas would like that.

I agree that people could choose between different libraries depending
on their preferences but at the moment I'm unsure that this would imply
dropping support for our libraries.

Back to libnl, I think that the cache thing provided by the library is
nice to implement quick applications without too much effort but I'm
unsure that this is the place to put this, I think that the data
structure used to store the entries of, say the neighbour cache, must be
up to the programmer (array, hash table, tree...), although nothing
prevents the programmer of not using the cache thing.

Anyway, I'm going to post the patches for libnfnetlink and
libnetfilter_conntrack soon, please let me make peace and apply them
since I do need them in mainline as well as many other people, we can go
back to this discussion later once I get more familiarized with libnl.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
