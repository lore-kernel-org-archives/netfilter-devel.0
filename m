From: "Jean-Michel Hemstedt" <jean-michel.hemstedt@alcatel.be>
Subject: Re: performance issues (nat / conntrack)
Date: Tue, 25 Jun 2002 16:51:37 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <028101c21c57$cf018130$0489cb8a@etbx180>
References: <Pine.LNX.4.33.0206251238390.4927-100000@blackhole.kfki.hu> <021a01c21c4b$47b2f2b0$0489cb8a@etbx180> <20020625135113.GE7975@naboo.ols.wavesec.org>
Reply-To: "Jean-Michel Hemstedt" <jean-michel.hemstedt@alcatel.be>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 7bit
Cc: "Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu>,
	<netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: "Harald Welte" <laforge@gnumonks.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


> > But this raises one additional problem:
> > 1) the hash index size and the hash total size should be configurable
> > separately (get rid of that factor 8, and use a free list for the tuple
> > allocation).
> > 2) NAT hash sizes should also be configurable independently from conntrack.
> > Normally the nat hashes are smaller than conntrack hash, since conntrack
> > is based on ports, while nat is not.
>
> both of this is already true. look at the module loadtime parameters of
> ip_conntrack.o and iptable_nat.o

right for conntrack, but i can't find something similar for nat:

conntrack:
----------
- ip_conntrack_htable_size : load time param
                           : allocated at init
                           : 16? bytes per list head
- ip_conntrack_max: /proc setting only after the module is loaded
                  : tuples allocated on demand (kmem_chache_alloc)
                  : 392 bytes per tuple.

=> that's why i'm not swapping when my table is not full...

but in ip_conntrack_init():
1093          ip_conntrack_max = 8 * ip_conntrack_htable_size;
=> when the module is loaded, it is loaded with this default value.
   could be good to have it as loadable parameter in order to
   save it and restore in modules.conf

nat:
----
(from ip_nat_init):
- ip_nat_htable_size = ip_conntrack_htable_size; (not configurable)
                     : allocated at init twice
                       (for bysource and byisproto hashes)
- max tuples??? haven't found any value neither any config data.
                (is it in patch-o-matic)?
                but the tuples are allocated on demand.


PS: the fact that tuples are allocated on demand (392bytes/tuple) and not at
init
    explains also why I was not swapping. (just facts ;o))
