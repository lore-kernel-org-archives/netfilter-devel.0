From: Harald Welte <laforge@gnumonks.org>
Subject: Re: performance issues (nat / conntrack)
Date: Tue, 25 Jun 2002 18:11:23 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020625161123.GH7975@naboo.ols.wavesec.org>
References: <Pine.LNX.4.33.0206251238390.4927-100000@blackhole.kfki.hu> <021a01c21c4b$47b2f2b0$0489cb8a@etbx180> <20020625135113.GE7975@naboo.ols.wavesec.org> <028101c21c57$cf018130$0489cb8a@etbx180>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Jean-Michel Hemstedt <jean-michel.hemstedt@alcatel.be>
Content-Disposition: inline
In-Reply-To: <028101c21c57$cf018130$0489cb8a@etbx180>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jun 25, 2002 at 04:51:37PM +0200, Jean-Michel Hemstedt wrote:
> > both of this is already true. look at the module loadtime parameters of
> > ip_conntrack.o and iptable_nat.o
> 
> right for conntrack, but i can't find something similar for nat:

strange. I though we already had that.

> conntrack:
> ----------
> 
> but in ip_conntrack_init():
> 1093          ip_conntrack_max = 8 * ip_conntrack_htable_size;
> => when the module is loaded, it is loaded with this default value.
>    could be good to have it as loadable parameter in order to
>    save it and restore in modules.conf

wheres the problem with having a 'echo 12345 >
/proc/sys/net/ipv4/ip_conntrack_max' in the post-load script in
modules.conf?

> nat:
> ----
> (from ip_nat_init):
> - ip_nat_htable_size = ip_conntrack_htable_size; (not configurable)
>                      : allocated at init twice
>                        (for bysource and byisproto hashes)
> - max tuples??? haven't found any value neither any config data.
>                 (is it in patch-o-matic)?
>                 but the tuples are allocated on demand.
> 
> 
> PS: the fact that tuples are allocated on demand (392bytes/tuple) and not at
> init

a tuple does not have 329 bytes. this sounds more like the size of a 
struct ip_conntrack.

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
