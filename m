From: Harald Welte <laforge@netfilter.org>
Subject: Re: [NETFILTER]: Kill ebt_ulog
Date: Sun, 24 Jul 2005 13:17:54 -0400
Message-ID: <20050724171754.GA3873@rama>
References: <42E1ADB2.1080109@trash.net>
	<1122119412.4484.5.camel@localhost.localdomain>
	<42E267C8.9090005@trash.net>
	<1122148193.3382.16.camel@localhost.localdomain>
	<42E2A2E9.8050800@trash.net>
	<1122154479.3382.29.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Content-Disposition: inline
In-Reply-To: <1122154479.3382.29.camel@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 23, 2005 at 09:34:39PM +0000, Bart De Schuymer wrote:
> Op za, 23-07-2005 te 22:04 +0200, schreef Patrick McHardy:
> > The QUEUE target will get a queue-number argument. Userspace can
> > register for different queues using netlink messages. All this
> > will be handled by the core to we don't need ipt_ULOG/ebt_ulog
> > anymore.
>=20
> What if someone wants to just get a copy sent to userspace while the
> kernel continues routing the copied packet? AFAIK this behaviour can't
> be obtained using the queue target.

> > The problem is that we can't create two kernel sockets for the same
> > netlink family. Netlink families are a scarce resource, so I don't think
> > it makes much sense to waste another one for a soon (couple of days)
> > deprecated mechanism. I propose to continue this discussion once the
> > new code is there, so we can see if it fits your needs.
>=20
> If the generic code is such that other modules can make it send messages
> through the NETLINK_NFLOG socket, then those problems are over. I think
> there is no problem in keeping ULOG and QUEUE as long as they use the
> generic framework, those targets do different things.

yes, that is what I'm doing at the moment.  nfnetlink_nflog is
registering with the already-existing nf_log_packet() api.

The architecture is like follows:

The iptables LOG (and ebt_ulog) modules would do nothing else but do a
single call to nf_log_packet() every time the want to log a packet.
nf_log_packet() will be extended to specify the log group.

Everything else is dealt with by the core.  A userspace process can use
nfnetlink to tell the kernel "please register as nf_log_packet() handler
for PF_BRIDGE, PF_INET, ... - and then register to one or multipe
groups.=20

> I'll be unreachable, most of the time, from July 25 'till August 7, I
> hope I can catch up on the discussion then...

the new code should be fixed until then.  I'm resolving some oopses at
the moment, it's a matter of days..

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC481CXaXGVTD0i/8RAuMeAJsFNRcih9BnYdXNWor6ETgJ+LY3SwCghgV2
VeV75kvD6Qn2qyy85kka4B0=
=Sld4
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
