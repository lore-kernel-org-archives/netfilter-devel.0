From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: [nf-failover] Re: [RFC] ct_sync 0.15 (corrected)
Date: Mon, 27 Sep 2004 15:30:28 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1096291827.2803.73.camel@nienna.balabit>
References: <1092407190.2402.120.camel@nienna.balabit>
	<1095993739.1044.9.camel@jzny.localdomain>
	<20040925075253.GQ3236@sunbeam.de.gnumonks.org>
	<1096290473.1075.64.camel@jzny.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: Harald Welte <laforge@netfilter.org>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: hadi@cyberus.ca
In-Reply-To: <1096290473.1075.64.camel@jzny.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


  Hi,

2004-09-27, h keltez=E9ssel 15:07-kor jamal ezt =EDrta:
> > well it exactly does this, with an additional security:  A master wil=
l
> > be downgraded to slave as soon as another master announces itself.  T=
his
> > is a security guard against invalid mode of operation.
>=20
> I think it would be better to separate the election process (who is
> master) from the syncing code. For some reason i thought this separatio=
n
> was there (and that all you had to do was bag some /proc entry).=20
> i.e if VRRP is the code that makes the decision that it wants you to be
> the master, thats how you become master. If someothericandohabetter (eg
> forCES) protocol wants you to be the master, thats how you become the
> master. There is no point in inventing a new HA scheme.
> And if you do it should probably be in user space (there is no
> perfomance issues with it) i.e its such a protocol (in user space) that=
=20
> should tell your syncing code to send syncs or not.
> Unless i missed something fundamental.

  The election process is completely independent, as Harald already
mentioned. The procfs interface is provided so that ct_sync can be used
with any other cluster manager/failover daemon.

 However, ct_sync is not capable of load balancing at the moment, and
not just because the protocol has some things which are single-master
specific. The main problem is with NAT and preserving the uniqueness of
tuples in the whole cluster, and unfortunately this would make a lot of
things much more complicated. So, even if the protocol would be
completely multi-master compatible ct_sync would be capable of
single-master operation.

  You're right that the protocol itself was designed with failover in
mind, and it won't support load balancing clusters without modification.
This is mainly because of the sequence numbers, and could be easily
corrected by maintaining a per-node seqno state on each node. The
security guard against multiple masters was implemented just to make
sure that we won't have multiple masters even if some administrator is
experimenting with ct_sync and the proc interface.

  I don't consider these issues as fundamental flaws, we tried to make
the election process as independent from ct_sync as possible.

--=20
 Regards,
   Krisztian KOVACS
