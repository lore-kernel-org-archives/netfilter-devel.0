From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: [RFC] ct_sync 0.15 (corrected)
Date: Thu, 19 Aug 2004 14:13:51 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1092917551.2425.28.camel@nienna.balabit>
References: <1092407190.2402.120.camel@nienna.balabit>
	 <20040819110646.GJ3921@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040819110646.GJ3921@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

  Hi,

2004-08-19, cs keltez=E9ssel 13:06-kor Harald Welte ezt =EDrta:
> >         On the other hand, it may be possible that the master is not
> >         able to re-send the packet, for example this may be the case =
if
> >         it is "too old", and is not present in the backlog anymore. I=
n
> >         this case, the slave should be notified that recovery is not
> >         possible this way, and it needs to do a full re-sync.
>=20
> Within the current protocol, the master can just make that decision and
> do a full resync without telling the slave.

  Indeed. However, I'd like to implement a new state (SLAVE_BROKEN)
later, which could be used to avoid electing a slave as new master if
that node is known to be not in sync. A facility of this kind would help
in early detection of such cases.

> >      3. There are a few things in the connection tracking code which
> >         are incompatible with replication "by design". For example,
> >         the expectfn() function in the expectation structure is such:
> >         simply, there is no way to replicate a stand-alone function
> >         pointer which could point to any arbitrary function.=20
>=20
> Yes, indeed.  we could look up the symbol name in the symbol table and
> replicate that ;)   Crude hack, but it would work.

  Unfortunately I don't think it would work... AFAIK there is no symbol
table information in 2.4 kernels and usually these functions are
declared as static anyway. Moreover, take a look at the H.323 helper, it
uses this expectfn function to set the helper of the conntrack to an
unregistered helper structure... I think there is no point in making
ct_sync overly complicated; these helpers should be fixed instead. (I
don't know why the H.323 does things this way, but it is completely
hopeless to replicate things like this.)

> > 	 One more example could be TCP window tracking, I don't think we
> > 	 have the necessary bandwidth and CPU time to send an update
> > 	 message after each and every received TCP packet... Any idea
> > 	 how we could solve these problems?
>=20
> We already do this since the timeout is updated with every packet.  So
> at this point, I see not much difference.  Jozsef and I agreed some tim=
e
> in the past, that if we don't replicate all the window information, in
> the event of a slave being propagated to master, the new master should
> disable windowtracking or switch into a lazy mode.

  Indeed, the timeout is updated with every packet. However, we do not
generate an update message for IPCT_REFRESH events at the moment. On the
other hand, we replicate the timeout changes when a state change occurs
as well, so I don't worry about incorrect (relative) timeout values at
all.

  Anyway, thanks for the comments.

--=20
 Regards,
   Krisztian KOVACS
