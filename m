From: Harald Welte <laforge@gnumonks.org>
Subject: Re: performance issues (nat / conntrack)
Date: Tue, 25 Jun 2002 21:01:26 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020625190125.GJ7975@naboo.ols.wavesec.org>
References: <Pine.LNX.4.33.0206251119260.4927-100000@blackhole.kfki.hu> <01ff01c21c45$c90eb2a0$0489cb8a@etbx180>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Jean-Michel Hemstedt <jean-michel.hemstedt@alcatel.be>
Content-Disposition: inline
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

On Tue, Jun 25, 2002 at 02:42:36PM +0200, Jean-Michel Hemstedt wrote:
> There's another side effect: when the system get's loaded (because of
> hash exhaustion or hash collisions), it can't process all packets arriving
> which means that conntrack will not see some FIN or RST packets allowing
> it to recover... This is a kind of 'vicious circle', or point of failure.

if conntrack  doesn't see a FIN or RST packet, it won't be forwarded by
the machine and thus never arrive at the receiver.  The sender will thus
retransmit, and hope the packet makes it next time.

> In my opinion, a first step should be to reconsider timeout values but
> also timer mechanisms.

no, the timeout values are reasonable.

> > I'm against in changing the *default* timeout values, except when it is
> > based on real-life, well established cases.
> 
> What sounds the most significant: 'TCP timeouts' or 'application timeouts'?
> Should (i.e) HTTP, FTP and Telnet have the same lifetime in hash?

yes, they should.  They are TCP connections.  We shouldn't impose
any application-protocol specific layer4 timeouts, that sounds horrible.

the port versus application protocol (i.e. 80 == http) are by
convention, not by protocol design.

> But unfortunately it doesn't meet my 'timeout per protocol' needs.

well, so go ahead and implement it. nobody prevents you from doing that.

> indeed, this dimensioning is quite conservative, and it assumes that
> conntrack is distributed on src+dst+proto, not on ports. But we can
> live with that, since it's only a memory overhead (except if we start
> considering memory pages swapping).

kernel memory is never swapped out.

> > conntrack and nat are subsystems. If somebody loads them in, then they
> > start to work.
> 
> work on what, since NAT has nothing to translate?

they start the work necessary to be prepared to nat packets/connections.

> > But why would anyone type in "iptables -t nat -L" when in reality he/she
> > does not use nat and the nat table itself??
> 
> (why do we live if it's for dying in the end?)

I don't know what kind of weird position you are claiming.  I think it
is now clear that you have a different perspective on how conntrack/nat
should work.

If the netfilter people respond to this as 'this is by design and not a
bug', you will have to live with that or implement a different system.
That's something different from improving load under DoS situations or
improving conntrack performance in general, where we have the same goal.

> This was my test setup, but since I haven't verified the conntrack hash
> distribution, I didn't want to argue on that. To measure that, we should
> maintain hash counters such as max collisions, average collisions per
> key, hit/miss depth average, number of hit/miss per second, etc...
> I've planned to do that along with profiling, but unfortunately not in
> the 2 coming weeks.

this sounds very constructive and we're looking forward to the results.

> last points I wanted to clarify:
> 
> 2) My test was artificial, but not unrealistic: one endpoint sustaining
>    1000 conn/s wathever the responsiveness of the target, or 10000 users
>    trying to connect through the gw in a time lapse of 10 seconds is
>    similar.
>    Now, if some of you are telling me that I'm not allowed, or that I'm nuts
>    to place my box in front of 10000 users, that's another debate.
>    I'm not talking about dimensioning, I'm talking about relative
>    performances, and strange weaknesses.

conntrack should definitely be able to handle this case and I'm looking
forward to see detailed results.

I'm away from my testing equipment for almost three weeks, so I cannot
really reproduce or try to verify any of your claims, neither reject
them.

It should at least deal with 10kconn/s

> kr,
> -jmhe-

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
