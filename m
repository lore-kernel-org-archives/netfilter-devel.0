From: Patrick Schaaf <bof@bof.de>
Subject: Re: PATCH: extra conntrack stats
Date: Fri, 2 May 2003 09:06:51 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030502070651.GG15143@oknodo.bof.de>
References: <1051780007.8215.200.camel@tux.rsn.bth.se> <20030502065752.5AB7D2C056@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Martin Josefsson <gandalf@wlug.westbo.se>,
  Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
  Rolf Fokkens <fokkensr@fokkensr.vertis.nl>,
  Harald Welte <laforge@netfilter.org>,
  Netfilter-devel <netfilter-devel@lists.netfilter.org>,
  Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline
In-Reply-To: <20030502065752.5AB7D2C056@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, May 02, 2003 at 03:31:50PM +1000, Rusty Russell wrote:
> In message <1051780007.8215.200.camel@tux.rsn.bth.se> you write:
> > On Thu, 2003-05-01 at 02:06, Rusty Russell wrote:
> > > If we can do this without making our hash really suck, we only need one
> > > entry per conntrack (and we then compare both ways).  This means a
> > > smaller table, and hence better cache utilization, as well as simpler
> > > locking.
> > > 
> > > Thoughts?
> > 
> > As Patrick already pointed out, it gets ugly wrt. NAT, the reply tuple
> > can be quite diffrent.
> 
> Yes, you're both right, I'm stupid.  Scratch this "great idea".

Sorry, but you are not stupid. I do care for non-NAT workloads, and the
approach would help greatly, there.

In the normal ip_conntrack, one tuple is left, which is normally used
for both directions of a non-NAT connection. In addition, there's a
pointer, ordinarily 0, which can point to a NAT-reverse-tuple.

When NAT starts to manipulate headers, it modifies ip_conntrack anyway;
in that place, it can also allocate a suitable NAT-reverse-tuple, attach
that to the conntrack, and put it into the hashes.

Hmm, we could have a list of such reverse-tuples per conntrack,
and call them expectations...

In fact, this setup gives a nice extra feature: for NATted connections,
we now logically have four flows in our hashes (physically two, due
to the key mirror property). Two of those four flows are INVALID, and
this can easily be determined when initially looking for the conntrack
of an incoming skb. Not that I know the area well, but I feel that this
could make some NAT setup decisions a lot simpler.

best regards
  Patrick
