From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Function pointers in conntrack structures
Date: Fri, 12 Sep 2003 15:26:00 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0309121522450.5733-100000@blackhole.kfki.hu>
References: <20030905121012.GE665@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>,
	Kovacs Krisztian <piglet@sch.bme.hu>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030905121012.GE665@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 5 Sep 2003, Harald Welte wrote:

> >   So, the only problem point I've found is the expectfn field of struct
> > ip_conntrack_expect, for which I've no idea how that could be handled. Is
> > the possibility of having more than one kind of callback function for
> > expectation creation really so important? (If only one kind of function
> > would be usable by conntrack helpers, its address could be stored in
> > struct ip_conntrack_helper, and we didn't have the whole problem.)
>
> Yes, it is important.  I doubt we can support the more complex protocols
> without it.
>
> Maybe we'd have to introduce an API to register expectfn's with the
> core (including a name).  And then we store a pointer to the registered
> structure (much like the 'helper' field currently) and you can replicate
> the name.

The situation is a little bit worse: we may have unregistered conntrack
helpers, which are attached to an expected conntrack entry by the expectfn
(see H.323 conntrack module). So we should have and API to register
expectfn's and unregistered helpers as well. Grrr.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
