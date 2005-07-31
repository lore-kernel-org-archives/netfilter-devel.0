From: Harald Welte <laforge@netfilter.org>
Subject: Re: [ANNOUNCE] netfilter-2.6.14 git tree / TODO
Date: Sun, 31 Jul 2005 12:38:12 +0200
Message-ID: <20050731103812.GF14874@rama.de.gnumonks.org>
References: <20050731080143.GA10374@rama.de.gnumonks.org>
	<1122802193.4159.12.camel@porky>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hUH5gZbnpyIv7Mn4"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eleblond@inl.fr>
Content-Disposition: inline
In-Reply-To: <1122802193.4159.12.camel@porky>
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


--hUH5gZbnpyIv7Mn4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 31, 2005 at 11:29:53AM +0200, Eric Leblond wrote:
> Hi,
>=20
> On Sun, 2005-07-31 at 10:01 +0200, Harald Welte wrote:
> > Hi!
> >=20
> > The areas of most work are currently nfnetlink, nfnetlink_log,
> > nfnetlink_queue and ip_conntrack_netlink (previously called ctnetlink).
> > Work in the kernel should be mostly finished, but the respective
> > userspace counterparts definitely need some work.
>=20
> I'm writing you as one of the NuFW developers. As you may know this
> project do an intensive use of ip_queue.=20

Yes, it's a good candidate for testing nfnetlink_queue.

> So, we are really interested in userspace counterparts. In particular,
> our center of interest is libnfnetlink_queue. I will do some test in
> the coming days to check if NuFW is working with NFQUEUE.

great.  Please consider supporting nfnetlink_queue natively, rather than
using the (still incomplete) compat_libipq interface.  The latter has to
do one additional copy of every packet (to build the fake
ipq_packet_msg_t), which you definitely want to avoid.

> > I've put together a quick TODO list at=20
> > 	http://people.netfilter.org/laforge/TODO
>=20
> I will start from point one of libnfnetlink_queue and let you know.

Ok.  Please be aware that it doesn't currently implement any parsing of
the incoming messages.  I'm not really sure how a good api would look
like.  Maybe you can tell me what would work best from NuFW point of
view. =20

The problem are the optional attributes.  A packet from the kernel could
optionally contain
	PAYLOAD
	MARK
	TIMESTAMP
	IFINDEX_IN
	IFINDEX_OUT
	...
and this may change from packet to packet.  so we cannot just pass a
fixed structure to the application program like libipq did.  OTOTH, I
don't want the applications have to do their own netlink message parsing
(with NFA_... macros), since that would violate the layering. Any ideas?

> I also have got one related question :
> Is the userspace marking enable in NFQUEUE ?

yes, it's all based on optional attributes. So if userspace sends a
NFQA_MARK attribute, the mark will be set by the kernel.  IF not, no
mark is set.

> Thanks for the work ! I can not wait to see a snort-inline, NuFW
> firewall.

Well, it should be pretty easy now - since you can have 65535 different
queues (and corresponding userspace processes).   One userspace process
can even tell the kernel to put a packet directly into another queue (by
sending a verdict "(group_num << 16) | NF_QUEUE".  I didn't test it, but
the code is designed to make this work.  Obviously in the normal case
the userspace apps wouldn't do that, since they don't know of each
other.

One problem that might become apparent now, is that the iptables QUEUE
target terminates execution of iptables, and the packets don't reappear
in the chain, but rather continue at the next function at the netfilter
hookfn with next priority.  NF_REPEAT might be an option, but I'm not
sure how stuff like conntrack and nat would deal with packets
reappearing at the same hook.  Feedback welcome.

Cheers,
	Harald

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--hUH5gZbnpyIv7Mn4
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC7KoUXaXGVTD0i/8RAq40AJ98rB0N4VHlbDLjHB+YGE4uAqhpZQCfeq0k
BFHk6jTNqAPCjyVf6r2VREs=
=kOkT
-----END PGP SIGNATURE-----

--hUH5gZbnpyIv7Mn4--
