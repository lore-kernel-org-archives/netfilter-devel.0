From: Harald Welte <laforge@netfilter.org>
Subject: Re: [RFC] ct_sync 0.15 (corrected)
Date: Thu, 19 Aug 2004 13:06:46 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040819110646.GJ3921@sunbeam.de.gnumonks.org>
References: <1092407190.2402.120.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vr1sEM+RgL05fCrX"
Cc: Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>,
	jamal <hadi@cyberus.ca>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
Content-Disposition: inline
In-Reply-To: <1092407190.2402.120.camel@nienna.balabit>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--vr1sEM+RgL05fCrX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 13, 2004 at 04:26:30PM +0200, KOVACS Krisztian wrote:

>      1. There should some facility by which one can select which
>         connections have to be replicated. This way it would be possible
>         to limit replication traffic to the bare minimum. For example,
>         there is no point in replicating conntrack entries for
>         connections whose endpoint is one of the nodes (administrative
>         SSH traffic, for example). A per-conntrack flag would be needed,
>         just like CONNMARK, which could be set for conntracks needing
>         replication with a simple iptables rule. Actually, CONNMARK is
>         enough, if we choose a given bit of the mark as the SYNC bit.
>         Besides this, we should decide if we needed a SYNC or a NOSYNC
>         bit, that is, if the default mode of operation should be "sync
>         or not to sync".

I would just use connmark for now.  Let's make it a CONFIG option
though, so people can just use connmark without any interference and
replicate all connections.

>      2. The error recovery functions in the protocol layer should be
>         revamped.=20
> 	  However, to iterate over the entries of the ring, it should
> 	  hold the spinlock of the ring, which is not possible, since
> 	  the send() operation may sleep... (This is done from the
> 	  receiver thread, and the ring is accessed from the sender
> 	  thread and from softirq context as well.) What would be the
> 	  most elegant solution?

given that this is a event expected to happen very rarely, I would
propose to just:
- grab the lock
- copy the whole ring (or the needed parts)
- release the lock
- send packets from the local copy (may sleep)
- free local copy

>         On the other hand, it may be possible that the master is not
>         able to re-send the packet, for example this may be the case if
>         it is "too old", and is not present in the backlog anymore. In
>         this case, the slave should be notified that recovery is not
>         possible this way, and it needs to do a full re-sync.

Within the current protocol, the master can just make that decision and
do a full resync without telling the slave.

>	  This is why I thought that we should include some extra
>	  information in every packet: the minimal sequence number of
>	  the oldest packet in the master's backlog.=20

Agreed.  We should also add a read-only sysctl that tells userspace
whether a slave is already fully-synced.=20

>         So, do anyone know of anything which could be used by ct_sync?
>         (It has to be a semi-reliable, connectionless multicast protocol
>         with a _very_ low overhead.)

everything I've seen so far about reliable multicast is inherently
complex.

>      3. There are a few things in the connection tracking code which
>         are incompatible with replication "by design". For example,
>         the expectfn() function in the expectation structure is such:
>         simply, there is no way to replicate a stand-alone function
>         pointer which could point to any arbitrary function.=20

Yes, indeed.  we could look up the symbol name in the symbol table and
replicate that ;)   Crude hack, but it would work.

> 	 One more example could be TCP window tracking, I don't think we
> 	 have the necessary bandwidth and CPU time to send an update
> 	 message after each and every received TCP packet... Any idea
> 	 how we could solve these problems?

We already do this since the timeout is updated with every packet.  So
at this point, I see not much difference.  Jozsef and I agreed some time
in the past, that if we don't replicate all the window information, in
the event of a slave being propagated to master, the new master should
disable windowtracking or switch into a lazy mode.

>      4. The current version is 2.4-only, it is for the good old
>         ip_conntrack, and supports IPv4 only. I don't really think
>         this is the way to go, but there is commercial interest in
>         having this kind of failover functionality as fast as possible.

Ack.

>         However, I think that after reaching some state which is
>         acceptable for the users needing the basic features fast, this
>         whole thing should be re-designed and ported to 2.6 and
>         nf_conntrack. This would depend on a few other things, such as
>         porting ctnetlink for nf_conntrack, but I thing those would
>         be important to have as well. Again, this would be quite a
>         lot work to do, thus deferring the 'stable' (production ready)
>         release of the code.

I would first make the 2.4.x version stable and almost feature-complete
(as far as possible).  We have then learned our lessons and can clean it
up while porting on top of nf_conntrack.

>  Regards,
>    Krisztian KOVACS

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--vr1sEM+RgL05fCrX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBJInGXaXGVTD0i/8RAtwCAJ9NdUaHjeGS5GjXkPCOsmyuKAuT6ACdFzhF
P69qbkuFXnNaolwig9pReKQ=
=PDLK
-----END PGP SIGNATURE-----

--vr1sEM+RgL05fCrX--
