From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: nf_conntrack (l3 independent conntrack)
Date: Wed, 26 Nov 2003 20:25:18 +0900 (JST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200311261126.UAA26305@toshiba.co.jp>
References: <20031118165138.GO5075@sunbeam.de.gnumonks.org>
	<200311190246.LAA10515@toshiba.co.jp>
	<20031119132444.GW5075@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20031119132444.GW5075@sunbeam.de.gnumonks.org>
	<20031115105020.GI656@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi, Harald and all,

I'm seeking the best structure of nf_conntrack and tuple in L3 independent
conntrack, and I have some issues.

-----------------------------------------------------------------------------
1. I think one of benefits of L3 indepedent conntrack is that the various
L3 connection can be represented with only one structure -- tuple.

For example, we can represent IPv4-IPv6 translated packet with

    Original: ipv4_addr1, port1 -> ipv4_addr2, port2
    Reply   : ipv6_addr2, port2 -> ipv6_addr1, port1

Probably, we need to reallocate tuple somewhere to create this tuple.
Because when received initial packet in this connection, the core module
create:

    Original: ipv4_addr1, port1 -> ipv4_addr2, port2
    Reply   : ipv4_addr2, port2 -> ipv4_addr1, port1

so the size of tuple "Reply" need to be changes. But if we adopt the way in
white paper, this mean that we have to reallocate nf_conntrack.
Moreover, the size of nf_conntrack is different from ip_conntracck and
ip6_conntrack. So slab caches for all case of Original-Reply are needed.

Then I suggest that
	- nf_conntrack has only static part and tuple_hash, and
	  tuple_hash include the pointer to tuple
	- tuple is allocated from different slab caches.

We can save memory spaces and utilize slab cache in this way. The disadvantages
are that
	- The management of nf_coonntrack become more complex.
	- If L4 part in tuple should be handled as dynamic part, we can't
	  adopt this approach.

... or, shouldn't we assume such a above connection ?

-----------------------------------------------------------------------------
2. Do you think which is better ? Or do you have other idea ?

	a. define ip_conntrack_tuple and ip6_conntrack_tuple.
	b. define only nf_conntrack which has "size" and "data[0]" in L3 part.

If we choose a., we have to make L3 module operate tuple, so have to search L3
module every operations. 

And if we select b., we need to calculate to get the pointer to L3/L4 part
in tuple. Please remember that the offset of members in "dst" aren't static
because of "src" above "dst".

I like b. than a. . Because we can define L4 part in the header files for each
protocol.
-----------------------------------------------------------------------------

These issue affect basic structure and codes in L3 independent conntrack.
I want to carefully choose because I don't want to rewrite many time.

BTW, "flowi" in include/net/flow.h have union... I think this is one choise.

And BTW, the name "nf_conntrack" is already used in sk_buff.h . I use "nf_conn"
in my code for now...


----------------------------------------
Yasuyuki KOZAKAI

Communication Platform Laboratory,
Corporate Research & Development Center,
Toshiba Corporation

yasuyuki.kozakai@toshiba.co.jp
----------------------------------------
