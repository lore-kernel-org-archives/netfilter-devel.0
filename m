From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: performance issues (nat / conntrack)
Date: Tue, 25 Jun 2002 16:17:54 +0200 (CEST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Pine.LNX.4.33.0206251548230.539-100000@blackhole.kfki.hu>
References: <01ff01c21c45$c90eb2a0$0489cb8a@etbx180>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Jean-Michel Hemstedt <jean-michel.hemstedt@alcatel.be>
In-Reply-To: <01ff01c21c45$c90eb2a0$0489cb8a@etbx180>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 25 Jun 2002, Jean-Michel Hemstedt wrote:

> > connections. As good as possible. If the conntrack table becomes full,
> > there are two possibilities:
> >
> > - conntrack table size is underestimated for the real traffic flowing
> >   trough. Get more RAM and increase the table size.
> > - conntrack is under a (DoS) attack. Then protect conntrack by appropriate
> >   rules using the recent/limit/psd etc modules.
>
> And what if, under load conditions, your table becomes full because 90% of
> its entries, which are unused, are not aged because of timeouts?

The only case when that might happen is a DoS. You did not consider the
second point above.

> We don't even need to have a full table to get into troubles. If at one
> point, the vast majority of the conntrack entries are unused, but still
> in hash, then you get more and more collisions, which decreases the
> hash efficiency.

What kind of collisions? Do you mean, that we end up in the same hash
entry and the linked list in the entry becomes too long? There is not much
wizardy we can do about it:

- increase the hash size (i.e buy more RAM) if the hash is small
- create better hash function, if one can deliberately hit the same entry.

By the way, so far nobody has ever proved that the hash function is
not good enough.

> There's another side effect: when the system get's loaded (because of
> hash exhaustion or hash collisions), it can't process all packets arriving
> which means that conntrack will not see some FIN or RST packets allowing
> it to recover... This is a kind of 'vicious circle', or point of failure.

This is not true. If those FIN/RST packets belong to already existing
connections, then those are in the conntrack hash and data can be updated.
If those packets do not belong to an existing connection, then either they
can create a new entry and we are fine, or conntrack is full and the
packets will be dropped - we are fine again.

> In my opinion, a first step should be to reconsider timeout values but
> also timer mechanisms.

As Patric already wrote: there is still no proof that the timeout values
are wrong.

> > I'm against in changing the *default* timeout values, except when it is
> > based on real-life, well established cases.
>
> What sounds the most significant: 'TCP timeouts' or 'application timeouts'?
> Should (i.e) HTTP, FTP and Telnet have the same lifetime in hash?

Sorry, I have the impression that you do not know how conntrack works, how
conntrack entries created, updated and destroyed.

Applications get the same timeouts, but their lifetime (and even that of
the different connections of the same application) can be quite different.

> > The book-keeping overhead is at least doubled compared to the
> > conntrack-only case - this explains pretty well the results you got.
>
> what do you mean by 'book-keeping' ?
> Does NAT do a lookup even if there are no rules?

I have to write again: even if there are no any rules, NULL
mapping happens and new connections must be put into both nat hashes.

> > conntrack and nat are subsystems. If somebody loads them in, then they
> > start to work.
>
> work on what, since NAT has nothing to translate?

See above.

> > But why would anyone type in "iptables -t nat -L" when in reality he/she
> > does not use nat and the nat table itself??
>
> (why do we live if it's for dying in the end?)

If somebody want to shoot himself in the foot, we can give him even more
rope :-).

> > I think because only the source port varies, this is an important issue in
> > your setup. You actually tested the hash functions and could bomb some
> > hash entries. The overall effect was a DoS against conntrack.

> This was my test setup, but since I haven't verified the conntrack hash
> distribution, I didn't want to argue on that. To measure that, we should
> maintain hash counters such as max collisions, average collisions per
> key, hit/miss depth average, number of hit/miss per second, etc...
> I've planned to do that along with profiling, but unfortunately not in
> the 2 coming weeks.

In my opinion, this is the real question. But I repeat again, nobody
proved that the hash function is not good enough. It's only speculation.

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
WWW-Home: http://www.kfki.hu/~kadlec
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
