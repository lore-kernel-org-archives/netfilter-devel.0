From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: nf_conntrack (l3 independent conntrack)
Date: Tue, 18 Nov 2003 12:04:49 +0900 (JST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200311180305.MAA20518@toshiba.co.jp>
References: <20031113010159.GD835@mea-ext.zmailer.org>
	<200311131303.WAA28664@toshiba.co.jp>
	<20031115105020.GI656@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: yasuyuki.kozakai@toshiba.co.jp, netfilter-devel@lists.netfilter.org,
        usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20031115105020.GI656@obroa-skai.de.gnumonks.org>
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

From: Harald Welte <laforge@netfilter.org>
Subject: nf_conntrack (l3 independent conntrack)
Date: Sat, 15 Nov 2003 11:50:20 +0100

> Hi again Yasuyuki.  Sorry for not getting back to you earlier.  I'm just
> busy with way too much work and don't really know where to start and
> when I'll be ever finished with all that stuff.
> 
> Please be assured that I didn't forget about the issue, but I just
> didn't find the time to finish the design paper on l3 independent
> conntrack.
>
> However, I'll attach the current (icomplete) start of my paper to this
> email and also put it in CVS.  

I read. It's very usefull to implement nf_conntrack. Thank you.

>      * Size of Addresses. ip_conntrack keeps two address tuples
>        per connection (every tuple is
>        2*(sizeof(l3_addr)+sizeof(l4_addr)), thus adding up to 32
>        bytes. In IPv6 the size of a tuple would grow up to at
>        least 80 bytes due to the large address size. If a union
>        for struct nf_conntrack_tuple was used, every IPv4
>        conntrack entry would waste 48 bytes of memory, which is
>        not acceptable considering the effect on wasting
>        cachelines. Thus, a mechanism must be implemented to have
>        differently sizes nf_conntrack structures, allocated from
>        different slab caches, allocated from different slab
>        caches. The dynamic part could be added to the end of a
>        structure, so all l3 independent structure members can be
>        transparently accessed by the core.

OK, I understand this problem, but I don't perfectly understand the detail of
your solution. 
Is "The dynamic part" equal to tuple ? or does this part include the private
structures for L3, protocol, and helper ?

> net/ipv4/netfilter/nf_conntrack_ipv4.c
> - init()
>         - register with nf_conntrack core. tell it the size of the l4

I think it is not l4 but l3. Is this right ?

BTW, 

> Maybe this is a start and somebody else will pick it up and express his
> idea about how the implementation / organization of data structures can
> look like.

Actually, I already started implementing L3 independent conntrack....

At present, I have implemented ipv4, ipv6, tcp, udp, icmp[v6], generic,
standard, and core except for the following items.

	- separating "struct tuple" of IPv4 and IPv6
	- hash function of tuple
	- handling fragmented IPv6 packet
	- DUMP_TUPLE()
	- SO_ORIGINAL_DST

And I'm debugging now. I can see that it tracks the connections of ssh(TCP),
iperf(UDP), and ping[6](ICMP[v6]), and output /proc/net/netfilter/nf_conntrack .

I'll send the patches as snapshot when I finish debugging.
Or should I send them after I finish implementing above items ?

Regeards,

----------------------------------------
Yasuyuki KOZAKAI

Communication Platform Laboratory,
Corporate Research & Development Center,
Toshiba Corporation

yasuyuki.kozakai@toshiba.co.jp
----------------------------------------
