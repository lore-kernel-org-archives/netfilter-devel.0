From: Herve Eychenne <rv@wallfire.org>
Subject: Re: RAM and conntrack performance: first draft of the document is online
Date: Wed, 26 Nov 2003 04:42:32 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031126034231.GA1044@eychenne.org>
References: <20031028151032.GD726@eychenne.org> <20031103081240.GQ1536@sunbeam.de.gnumonks.org> <20031125153543.GD1082@eychenne.org> <20031125205723.GE2971@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	Netfilter Development <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20031125205723.GE2971@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Nov 25, 2003 at 09:57:23PM +0100, Harald Welte wrote:

 Hi,

> > Thank you very much for your detailled answer, Harald.
> > Sorry for the delay. I'm currently writing this little document, based mainly
> > on your answers.
> > 
> > > > I think it would be good to end up with a small document which would
> > > > give every detail about how to choose optimal values for HASHSIZE and
> > > > CONNTRACK_MAX, and every other mean to get the best out of the
> > > > conntracking/NAT system...
> > 
> > > I guess there hasn't been any performance testing.  Ideally you'd have
> > > as many buckets as you have conntrack entries in the system.  However,
> > > every bucket will 
> > 
> > Something was lost in space... Will? ;-)

> hm. don't remember what i wanted to say.   oh, yes. every bucket will
> occupy some space, whether there are any connections in that bucket or
> not.

Yes, but that is really negligible (2 * size_of_pointer * HASHSIZE).

> > > >   What about HASHSIZE default value? How to read it at runtime?

> > So, it cannot be read at runtime, I suppose... It would be really nice,
> > though... would /proc be ok?

> yes. It is printed at startup via syslog, however.

Syslog can be enough for humans, but not for scripts...
I think you can add "make hashsize value available through /proc" to
the TODO list (whose size is unfortunately ever growing ;-)).

> > We could put a "else" here.
> > BTW, why this hard limit of 8192? On really high-speed and high-loaded
> > networks, you may perfectly want to set to an upper value...

> yes, and you can if you do so by hand.  however, just because a system
> has loads of ram, it doesn't mean it will actually do lots of
> connections... there are people using computers for something else than
> firewalling ;)

Of course.  That was just a statement for a specific configuration, and
this must be decided by a human being.

> > > > - HASHSIZE should be an odd number, and even better: a prime number.
> > > >   What happens when you set it to an even number, or a non-prime number?

> > > hash distribution will be less optimal.

> > But reading the algorithm, hashsize is never automatically set to a
> > prime number... but an even one. So how do you explain
> > that I have 4091 (which is probably a prime number, right?) buckets on
> > my system by default?

> maybe you're running a different kernel?

Debian standard kernel.  Maybe they are patching netfilter?  These are smart
guys! ;-)

> > > > - CONNTRACK_MAX can be modified at run time with /proc. What does it
> > > >   do exactly (when shrinked, when extended)?
> > 
> > You don't really answer to my question: what happens when you set
> > conntrack_max to a smaller number than the currently stored conntrack
> > entries? I suppose conntrack entries are deleted? According to which
> > criterias?

> no, there are none deleted.  we just skip creating new ones until the
> number has dropped below the limit.  There is no special case for that,
> we just chek >= conntrack_max at conntrack allocation time.

Don't you think it would be good to shrink the lists immediately?
Waiting til the number has dropped below the limit can take days...

> > But if we take conntrack_max = hashsize,
> > size_of_mem_available_for_ct is still around 300 * ip_conntrack_max
> > (on my system, it is not 300, but exactly 292)
> > So I simply think that on firewall-only machines with 512Mo, we should
> > simply use conntrack_max = hashsize without any questioning.

> yes.  but just because your suse or redhat default packetfilter script
> modprobes ip_conntrack, there is no way we can assume that this is a
> firewall-only machine.

Of course.  Once more, I didn't propose that this should be done
automatically, I just wanted to know if someone had any objection to
that statement.

> > > yes.  You just don't do that.  You configure your firewall, and put it
> > > in place.  You should know your network traffic beforehand and configure
> > > it correctly.

> > That's not always that simple. Suppose you're working for a company for which
> > availability and performance is critical... and suppose the growing
> > network traffic forces you to increase your bandwidth by about 10.
> > Well, in these sort of cases, you certainly want to avoid to reboot
> > (and loose connections) too much, believe me.
> > Yes, netfilter is sometimes used in these kind of companies. And
> > yes, I sometimes happen to do some missions for them.
> > And no, I can hardly give you any names. ;-)

> well, patches are welcome ;)

Yet another TODO++...

Oh, I nearly forgot... The little document about conntrack/NAT tuning
is located to http://www.wallfire.org/misc/netfilter_conntrack_perf.txt
for the moment.
Corrections and ideas are welcome.

 Herve

-- 
 _
(°=  Hervé Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
