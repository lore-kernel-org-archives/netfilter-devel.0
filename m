From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: matching "many of one kind"
Date: Tue, 1 Oct 2002 12:01:02 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0210011119160.8527-100000@blackhole.kfki.hu>
References: <20020921093322.GB282@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@gnumonks.org>,
	<netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>,
	Joakim Axelsson <gozem@aaricia.hemmet.chalmers.se>
In-Reply-To: <20020921093322.GB282@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Patrick,

On Sat, 21 Sep 2002, Patrick Schaaf wrote:

> > > However, in general, I'm not so sure that it makes sense to expand
> > > all kinds of match options into multidimensional specification
> > > languages for arbitrary subsets of their keyspaces, with all kinds
> > > of option specific shortcut forms for how ranges and patterns are
> > > written. Each option becomes its own mini-language. I don't like.
> >
> > You seem to be reading my mind.  I already had this issue with the
> > multiport match (I never liked it, in fact) - and I have the same
> > trouble with this kind of patches.  Somebody seems to be solving a
> > particular problem (efficiency?) the wrong way.
>
> Do you have an idea about how to solve these efficiency problems?
> I think we do have genuine cases on our hands that profit immensely
> from such compact specification of more or less large one-dimensional
> alternative lists. My ippool extension was born out of one such case,
> where a small bitmap can replace hundreds of source or destination
> IP specifications. Jay's multi-device-list, with his application
> needing to match "one of 100 devices" out of a larger set, is
> another good case.
>
> With ippool, I decided to hide the "detailed list of set members"
> in the ippool management, i.e. kept it away from normal rule
> specification, so the rule management itself does not need a
> more complicated API. This "trick" may as well be used for the
> device list stuff, or for more complex multiport things (those
> would be two new flavors of pools).

In my opinion, we should accept and generalize ippool as the standard way
to express multiple possibilities of the same kind for iptables. The
matches could be extended as plain and ippool-aware ones, so that one
could write rules like

-i interface-pool -s address-pool -sport port-pool etc.

It'd involve extending ippool (nfpool) according to Joakim Axelsson's
suggestion by hash, list, btree and subpool pools as well.

> In any case, before the iptables matches and targets become even
> more baroque, I'd like to know what the core team things about
> these issues.

I completely agree with your message: the goal is to keep the interface
both clean and flexible. The proper way for multi-foo matching is to use
generalized pools, not introducing individual matches for every new
multi-foo.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
