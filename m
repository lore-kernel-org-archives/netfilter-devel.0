From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: performance issues (nat / conntrack)
Date: Tue, 25 Jun 2002 12:35:50 +0200 (CEST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Pine.LNX.4.33.0206251119260.4927-100000@blackhole.kfki.hu>
References: <027b01c21893$72bbe1d0$0289cb8a@etbx180>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Jean-Michel Hemstedt <jean-michel.hemstedt@alcatel.be>
In-Reply-To: <027b01c21893$72bbe1d0$0289cb8a@etbx180>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 20 Jun 2002, Jean-Michel Hemstedt wrote:

> I'm doing some tcp benches on a netfilter enabled box and noticed
> huge and surprising perf decrease when loading iptable_nat module.
>
> - ip_conntrack is of course also loading the system, but with huge memory
> and a large bucket size, the problem can be solved. The big issue with
> ip_conntrack are the state timeouts: it simply kill the system and drops
> all the traffic with the default ones, because the ip_conntrack table
> becomes quickly full, and it seems that there is no way to recover from
> that  situation... Keeping unused entries (time_close) even 1 minute in
> the cache is really not suitable for configurations handling (relatively)
> large number of connections/s.

Please note: the role of the conntrack subsystem is to keep track of the
connections. As good as possible. If the conntrack table becomes full,
there are two possibilities:

- conntrack table size is underestimated for the real traffic flowing
  trough. Get more RAM and increase the table size.
- conntrack is under a (DoS) attack. Then protect conntrack by appropriate
  rules using the recent/limit/psd etc modules.

I'm against in changing the *default* timeout values, except when it is
based on real-life, well established cases.

> o The cumulative effect should be reconsidered.
> o Are there ways/plans to tune the timeouts dynamically? and what are
>   the valid/invalid ranges of timeouts?

There is already a patch in p-o-m which makes possible to *tune* the
timeouts dynamically via /proc. Actually, the only reason why that part of
the patch was written was to make possible to dynamically *increase* the
timeout value of the close_wait state.

> - The annoying point is iptable_nat: normally the number of entries in
> the nat table is much lower than the number of entries in the conntrack
> table. So even if the hash function itself could be less efficient than
> the ip_conntrack one (because it takes less arguments: src+dst+proto),
> the load of nat, should be much lower than the load of conntrack.

If there is no explicit NAT rule for a connection, then automatic NULL
mapping happens. (Also, because NAT keeps two additional hashes, the total
amount of memory required for the data is 3*ip_conntrack_htable_size.)

The book-keeping overhead is at least doubled compared to the
conntrack-only case - this explains pretty well the results you got.

> - Another (old) question: why are conntrack or nat active when there are
> no rules configured (using them or not)? If not fixed it should be at
> least documented... Somebody doing "iptables -t nat -L" takes the risk

conntrack and nat are subsystems. If somebody loads them in, then they
start to work.

But why would anyone type in "iptables -t nat -L" when in reality he/she
does not use nat and the nat table itself??

> here is my test bed:
>
> tested target:
>  -kernel 2.4.18 + non_local_bind + small conntrack timeouts...
>  -PIII~500MHz, RAM=256MB
>  -2*100Mb/s NIC
>
> The target acts as a forwarding gateway between a load generator client
> running httperf, and an apache proxy serving cached pages. 100Mb/s NICs
> and requests/response sizes insure that BW and packet collisions is not
> an issue.
>
> Since in my test, each connection is ephemeral (<10ms), i recompiled the
> kernel with very short conntrack timeouts (i.e: 1 sec for close_wait,
> and about 60 sec for established!) This was also the only way to restrict
> the conntrack hash table size (given my RAM) and avoid exagerated hash
> collisions. Another limitation comes from my load generator creating traffic
> from one source to one destination ipa, with only source port variation
> (but given my configured hash table size and the hash function itself
> it shouldn't have been an issue).

I think because only the source port varies, this is an important issue in
your setup. You actually tested the hash functions and could bomb some
hash entries. The overall effect was a DoS against conntrack.

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
WWW-Home: http://www.kfki.hu/~kadlec
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
