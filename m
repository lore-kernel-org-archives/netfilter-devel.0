From: "Jean-Michel Hemstedt" <jean-michel.hemstedt@alcatel.be>
Subject: Re: performance issues (nat / conntrack)
Date: Tue, 25 Jun 2002 14:42:36 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <01ff01c21c45$c90eb2a0$0489cb8a@etbx180>
References: <Pine.LNX.4.33.0206251119260.4927-100000@blackhole.kfki.hu>
Reply-To: "Jean-Michel Hemstedt" <jean-michel.hemstedt@alcatel.be>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: "Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> > I'm doing some tcp benches on a netfilter enabled box and noticed
> > huge and surprising perf decrease when loading iptable_nat module.
> >
> > - ip_conntrack is of course also loading the system, but with huge memory
> > and a large bucket size, the problem can be solved. The big issue with
> > ip_conntrack are the state timeouts: it simply kill the system and drops
> > all the traffic with the default ones, because the ip_conntrack table
> > becomes quickly full, and it seems that there is no way to recover from
> > that  situation... Keeping unused entries (time_close) even 1 minute in
> > the cache is really not suitable for configurations handling (relatively)
> > large number of connections/s.
>
> Please note: the role of the conntrack subsystem is to keep track of the
> connections. As good as possible. If the conntrack table becomes full,
> there are two possibilities:
>
> - conntrack table size is underestimated for the real traffic flowing
>   trough. Get more RAM and increase the table size.
> - conntrack is under a (DoS) attack. Then protect conntrack by appropriate
>   rules using the recent/limit/psd etc modules.

And what if, under load conditions, your table becomes full because 90% of
its entries, which are unused, are not aged because of timeouts?
We don't even need to have a full table to get into troubles. If at one
point, the vast majority of the conntrack entries are unused, but still
in hash, then you get more and more collisions, which decreases the
hash efficiency.

There's another side effect: when the system get's loaded (because of
hash exhaustion or hash collisions), it can't process all packets arriving
which means that conntrack will not see some FIN or RST packets allowing
it to recover... This is a kind of 'vicious circle', or point of failure.

In my opinion, a first step should be to reconsider timeout values but
also timer mechanisms.

>
> I'm against in changing the *default* timeout values, except when it is
> based on real-life, well established cases.

What sounds the most significant: 'TCP timeouts' or 'application timeouts'?
Should (i.e) HTTP, FTP and Telnet have the same lifetime in hash?

>
> > o The cumulative effect should be reconsidered.
> > o Are there ways/plans to tune the timeouts dynamically? and what are
> >   the valid/invalid ranges of timeouts?
>
> There is already a patch in p-o-m which makes possible to *tune* the
> timeouts dynamically via /proc. Actually, the only reason why that part of
> the patch was written was to make possible to dynamically *increase* the
> timeout value of the close_wait state.

I didn't know that. thanks for the info.
But unfortunately it doesn't meet my 'timeout per protocol' needs.

>
> > - The annoying point is iptable_nat: normally the number of entries in
> > the nat table is much lower than the number of entries in the conntrack
> > table. So even if the hash function itself could be less efficient than
> > the ip_conntrack one (because it takes less arguments: src+dst+proto),
> > the load of nat, should be much lower than the load of conntrack.
>
> If there is no explicit NAT rule for a connection, then automatic NULL
> mapping happens. (Also, because NAT keeps two additional hashes, the total
> amount of memory required for the data is 3*ip_conntrack_htable_size.)

indeed, this dimensioning is quite conservative, and it assumes that
conntrack is distributed on src+dst+proto, not on ports. But we can
live with that, since it's only a memory overhead (except if we start
considering memory pages swapping).

>
> The book-keeping overhead is at least doubled compared to the
> conntrack-only case - this explains pretty well the results you got.

what do you mean by 'book-keeping' ?
Does NAT do a lookup even if there are no rules?

>
> > - Another (old) question: why are conntrack or nat active when there are
> > no rules configured (using them or not)? If not fixed it should be at
> > least documented... Somebody doing "iptables -t nat -L" takes the risk
>
> conntrack and nat are subsystems. If somebody loads them in, then they
> start to work.
>

work on what, since NAT has nothing to translate?

> But why would anyone type in "iptables -t nat -L" when in reality he/she
> does not use nat and the nat table itself??

(why do we live if it's for dying in the end?)

>
> > here is my test bed:
> >
> > tested target:
> >  -kernel 2.4.18 + non_local_bind + small conntrack timeouts...
> >  -PIII~500MHz, RAM=256MB
> >  -2*100Mb/s NIC
> >
> > The target acts as a forwarding gateway between a load generator client
> > running httperf, and an apache proxy serving cached pages. 100Mb/s NICs
> > and requests/response sizes insure that BW and packet collisions is not
> > an issue.
> >
> > Since in my test, each connection is ephemeral (<10ms), i recompiled the
> > kernel with very short conntrack timeouts (i.e: 1 sec for close_wait,
> > and about 60 sec for established!) This was also the only way to restrict
> > the conntrack hash table size (given my RAM) and avoid exagerated hash
> > collisions. Another limitation comes from my load generator creating traffic
> > from one source to one destination ipa, with only source port variation
> > (but given my configured hash table size and the hash function itself
> > it shouldn't have been an issue).
>
> I think because only the source port varies, this is an important issue in
> your setup. You actually tested the hash functions and could bomb some
> hash entries. The overall effect was a DoS against conntrack.

ok, here we go:

98  static inline u_int32_t
99  hash_conntrack(const struct ip_conntrack_tuple *tuple)
100  {
101  #if 0
102          dump_tuple(tuple);
103  #endif
104          /* ntohl because more differences in low bits. */
105          /* To ensure that halves of the same connection don't hash
106             clash, we add the source per-proto again. */
107          return (ntohl(tuple->src.ip + tuple->dst.ip
108                       + tuple->src.u.all + tuple->dst.u.all
109                       + tuple->dst.protonum)
110                  + ntohs(tuple->src.u.all))
111                  % ip_conntrack_htable_size;
112  }

src.u.all & dst.u.all refer (unless there's a bug) to src.tcp.port
and dst.tcp.port respectively. So, if only src.port varies linearly
(let's say between 32000 and 64000), and if ip_conntrack_htable_size
= 32768 (kernel: ip_conntrack (32768 buckets, 262144 max)), then
we should have maximum 2 collisions per bucket (unless there's a type
overfow somewhere).

This was my test setup, but since I haven't verified the conntrack hash
distribution, I didn't want to argue on that. To measure that, we should
maintain hash counters such as max collisions, average collisions per
key, hit/miss depth average, number of hit/miss per second, etc...
I've planned to do that along with profiling, but unfortunately not in
the 2 coming weeks.

--

last points I wanted to clarify:

> From: "Patrick Schaaf" <bof@bof.de>
> On Sun, Jun 23, 2002 at 09:46:29PM -0700, Don Cohen wrote:
> >  > From: "Jean-Michel Hemstedt" <jean-michel.hemstedt@alcatel.be>
> >  > >  > Since in my test, each connection is ephemeral (<10ms) ...
> >
> > One question here is whether the traffic generator is acting like
> > a real set of users or like an attacker.  A real user would not keep
> > trying to make connections at the same rate if the previous attempts
> > were not being served.  I suspect you're acting more like an attacker.
>
> He definitely is. The test he described is completely artificial, and does
> not represent any normal real world workload.
>
> Nevertheless, it does point out a valid optimization chance. We discussed
> that months ago, and it's still there.

No, I don't think so.
1) the hash is not in cause (see above)
   (btw, as discussed in 'connection tracking scaling' [19 March 2002]
    i don't see ways to really optimize it unless you go for
    multidimesional hashes described in theoretical papers, or if
    you make traffic assumptions which is most likely impossible
    in such a generic framework...) However, I don't understand
    why we are adding twice the src.port in the hash function?
2) My test was artificial, but not unrealistic: one endpoint sustaining
   1000 conn/s wathever the responsiveness of the target, or 10000 users
   trying to connect through the gw in a time lapse of 10 seconds is
   similar.
   Now, if some of you are telling me that I'm not allowed, or that I'm nuts
   to place my box in front of 10000 users, that's another debate.
   I'm not talking about dimensioning, I'm talking about relative performances,
   and strange weaknesses.

kr,
-jmhe-
