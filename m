From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: nf_conntrack (l3 independent conntrack)
Date: Tue, 02 Dec 2003 09:34:40 +0900 (JST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200312020035.JAA26549@toshiba.co.jp>
References: <20031119132444.GW5075@sunbeam.de.gnumonks.org>
	<200311261126.UAA26305@toshiba.co.jp>
	<20031129175622.GN3181@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20031129175622.GN3181@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi, Harald,

Thank you for replying.

[ short ]

I agree that we should not care too much about the corner cases, and
translation of IPv4 (or IPv6) packets is the corner case, IN NOW.

And, I still seem to misunderstand your idea about tuple.

I tried to write structure of tuple like that in last week.
	- all connection can be represented with nf_conntrack_tuple.
	- l4 part and l3 protocol number in tuple can be accessed with l3
	  independently.
	- operations of tuple are easy as possible.
	- only one hash for conntrack is allocated in kernel.

I don't know these are what you want, or not.

And, I thought about some types of structure, but all of them have some complexity to operate tuple.
I needed typecasting, manual calculation of pointer.

After all, I think that using "union" is simply and better even though wasting
memory space.


[ detail ]

> cases. In a realistic setup, we would mainly have two sizes:
> 1) nf_conntrack + 2*tuple_ipv4
> 2) nf_conntrack + 2*tuple_ipv6
> 
> In case of an ipv4-ipv6 connection, I would just use tuple number two
> and represent the ipv4 end as ipv6-mapped-ipv4 address.

# ??? I assume 128 bit representation of IPv4 address in "2)".

I suspect this does not work well. We have to search nf_conntrack from hash
2 times every IPv4 packets -- by using tuple_ipv4 and tuple_ipv6.
And I think we should not use tuple_ipv6 to represent ipv4 connection.
I don't want to be confused that a tuple_ipv6 represents ipv4 or ipv6.

But I'll stop talking about this any more. This is the corner cases as you say,
in now.

> > Then I suggest that
> > 	- nf_conntrack has only static part and tuple_hash, and
> > 	  tuple_hash include the pointer to tuple
> > 	- tuple is allocated from different slab caches.
> > 
> > We can save memory spaces and utilize slab cache in this way. The
> > disadvantages are that
> > 	- The management of nf_coonntrack become more complex.
> > 	- If L4 part in tuple should be handled as dynamic part, we can't
> > 	  adopt this approach.
> 
> one problem is also that we would have to allocate three items for every
> new connections, which is bad.  I think we should have two slab caches,
> one with v4 tuples, one with v6 tuples.  Depending on the type of
> connection, we chose either.

You're right about that problem.

> > 2. Do you think which is better ? Or do you have other idea ?
> > 
> > 	a. define ip_conntrack_tuple and ip6_conntrack_tuple.
> > 	b. define only nf_conntrack which has "size" and "data[0]" in L3 part.
> > 
> > If we choose a., we have to make L3 module operate tuple, so have to search L3
> > module every operations. 

Oh, sorry, I mistook in b. I wanted to ask about tuple.

	b. define only nf_conntrack_tuple which has "size" and "data[0]"
	   in L3 part.

i.e.

struct nf_conntrack_tuple_elem {
	u_int16_t pnum; /* l3 protocol number (in src) or 
			   l4 protocol number (in dst) */
	u_int16_t size;
	union {
		struct {
			u_int16_t port;
		} tcp;
		...
	} u;
	u_int8_t data[0]; /* l3 part */
};

struct nf_conntrack_tuple {
	u_int32_t size;		/* size of src(dst) part */
	u_int8_t data[0];	/* followed by src and dst part */
};

I think that the l3 & l4 protocol number and l4 part in tuple should be
independent of l3 part. Then l4 modules can be implemented without thought of
l3 protocol, and l3 module can be found from l3 protocol number in tuple.
So I wanted to choice "b." if we compress tuple size. Of cause,
typecasting and manual pointer calculations is needed.

And, if I'm allowed to change structure of tuple more, we can define tuple
as following.

struct nf_conntrack_tuple {
	u_int16_t l3num;
	u_int16_t protonum;

	/* l4 part */
	union {
		struct {
			u_int16_t port;
		} tcp[2];
		...
	} l4;

	/* l3 part */
	union {
		struct nf_conntrack_tuple_ipv4 ipv4[0];
		struct nf_conntrack_tuple_ipv6 ipv6[0];
	} l3;
};

In this case, typecasting and manual pointer calculations is not needed. But It's more difficult to rewrite IPv4 NAT modules.

> I think we should have something like
> 
> struct nf_conntrack {
> 	struct list_head;
> 	int foo;
> 	int bar;
> 
> 	union {
> 		struct nf_conntrack_ipv4 ipv4[0];
> 		struct nf_conntrack_ipv6 ipv6[0];
> 	} l3;
> };
> 
> this way we can dereference all fields without any typacasting or manual
> pointer calculations..

I agree. but, please don't forget that size of nf_conntrack_tuple is dynamic,
so we have to define

struct nf_conntrack_ipv4 {
	int foo;
	int bar;

	u_int8_t tuple[0];
}

and, we need tuple_hash in nf_conntrack. I assume that
	- nf_conntrack include tuple_hash
	- tuple_hash include the pointer to tuple in nf_conntrack_ipv{4,6}

Then tuple and tuple_hash can be accessed with l3 independently.

You know this way is complex. and it is clear that
	- the way to use "union" in l3 part in tuple is the most simple.

and I want to use it very much. But.. ok, I'll try rewrite my code with
nf_conntrack_tuple and nf_conntrack I said.
	- I'll not define tuple for ipv4 and ipv6 separately. I'll define
	  just nf_conntrack_tuple.
	- nf_conntrack include tuple_hash
	- tuple_hash include the pointer to tuple in nf_conntrack_ipv{4,6}

----------------------------------------
Yasuyuki KOZAKAI

Communication Platform Laboratory,
Corporate Research & Development Center,
Toshiba Corporation

yasuyuki.kozakai@toshiba.co.jp
----------------------------------------
