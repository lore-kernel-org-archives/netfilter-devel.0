From: Harald Welte <laforge@netfilter.org>
Subject: Re: [RFC] updated ctnetlink patches
Date: Sat, 31 May 2003 22:52:10 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030531205210.GE29312@sunbeam.de.gnumonks.org>
References: <3ED4BD16.8030606@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rmZDAlAp7pllCg/D"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3ED4BD16.8030606@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--rmZDAlAp7pllCg/D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2003 at 03:43:50PM +0200, Patrick McHardy wrote:
>=20
> I've done some work on ctnetlink, here is what i've got so far. The=20
> patch is still incomplete,

First of all, thanks a lot for contributing to ctnetlink.

> - Attributes:
> Removed CTA_IIF and CTA_OIF, there is no relation between conntrack and =
=20
> interfaces.=20

oh yes, this is I think my fault.  At that time I was doing a project
that required interface tracking in conntrack.

> - Creation and manipulation of conntrack entries:
> It is possible now to create and change conntrack entries. Only=20
> confirmed entries are accessible trough ctnetlink, also only confirmed
> ones can be created.=20

Makes sense, I don't see a need for this to be changed

> All attributes except CTA_HELPINFO and CTA_NATINFO are implemented.

we should get HELPINFO implemented,

> For NATINFO probably another ugly pointer somewhere is required to
> access either functions inside ip_nat_core or nat_lock without
> requiring nat to be loaded.

mh.

> - Conntrack event notifications:
> The patch adds event notifications to conntrack. Since there are very=20
> much events, it is tried to cache them where possible and to deliver
> all cached ones at once. Still, there are a lot. The notifications can
> be disabled at compile time while keeping parts of ctnetlink that
> don't rely on them working.=20

Yes, this is the way to go.

> Also noteworthy is the fact that the NEW event is in fact CONFIRM
> since there is no way to access unconfirmed connections. The DESTROY
> event is currently in destroy_conntrack, this should probably move to
> clean_from_lists.=20

ACK. We can have conntracks that are forced to live longer because some
sibling is still holding a refcount on it.  But userspace should get
notified once the entry is deactivated - that is, at the time it is
removed from the lists.  This change would also make it symmetric
(NEW=3D=3Dconfirm, DESTROY=3D=3Dremove_from_lists

> ip_ct_refresh is changed to only update the timer if timer.expires !=3D
> jiffies+extra_jiffies. This reduces timeout change messages to at most
> HZ/s instead of 1/packet.=20

> I'm unclear if this change introduces a race condition of some kind.

I don't think so.

> There are currently no messages for things done on behalf of ctnetlink
> itself.

This means that listener B doesn't get notified if listener A
adds/changes something via ctnetlink.  This needs to get implemented in
order to sanely support multiple listeners

> -Table dumping:
> Previous code crashed (known issue i think),=20

Yes, Martin has a fix for it.

> also if it worked entries would have been dumped multiple times if
> there was no room in the skb while in the middle of dumping a hash
> chain.=20

true, but not too problematic.  If we send the address of the conntrack
entry as ID to userspace, userspace could detect those copies. But it's
not nice, of course.

> With my current solution confirmed entries are assigned a unique
> increasing id and held in an ordered list.=20

Mh, this is the part i really dislike (sorry).  The unique ID is IMHO
going to be expensive (the cacheline of this ID will always ping-pong,
as heavy contention is to be expected).  And the ordered list..  is it
really necessarry to yet again increase the size of ip_conntrack?=20

> The last id successfully dumped is stored in the struct
> netlink_callback and after an interruption it is continued with the
> next one. Unfortunately this adds two new fields to struct
> ip_conntrack. The id field could be useful for ctnetlink itself (since
> tuples can be reused it is the only unique identifier).

yes, but passing the address of the conntrack as ID would be much easier
than than a unique sequential ID.

Or what about using a timestamp as ID? it would not be unique, but at
least you can say something like 'entries created before jiffies=3D=3Dfoo h=
ave
already been sent'.

This still doesn't eliminate the need for the ordered list.  We need to
find a way around that.

> Some thoughts/problems for discussion:
> - There are too much messages, messages get lost if the socket receive=20
> buffer is exhausted. I only tested on UML so it might have been just
> too slow.

did you try to increase the buffer?

> - If NEW message is lost all further changes are pointless. One could=20
> make messages redundant by always including the attributes required to
> create new entries. OTOH, this is only interesting for state
> synchronisation, not for other listeners.=20

No, I don't think this is necessarry.  If a sync receiver gets updates
for an entry it doesn't have, it can issue an request to receive a full
[new] copy of this entry.

> Different messages for different multicast groups ? This is probably
> needlessly expensive, the overhead of the extra attributes is not
> much.  It could of course also be handled in userspace (but with high
> overhead).

Well, I don't care about the overhead in userspace if it's about a rare
case (message loss).

> - Helpers: should it be possible to assign arbitary helpers to=20
> connections (respecting protocol, disrespecting ports) or not ?=20

might be a nice feature to have, but I wouldn't consider this important

> Should connections created on behalf of ctnetlink be assigned
> a helper automatically if there is a matching one ?

yes.

> - nat: masq_index is current not included in NATINFO. could it be useful ?

> Ok my brain is empty now, if i remember some more i'll write a new=20
> message ..

I can imagine...

a couple of thoughts:

- stuff like 'conntrack->proto.tcp =3D *(struct ip_ct_tcp *)p;' makes the
  compiler to generate inline memcpy, which is less optimal than the
  kernel-provided asm memcpy implementation, so let's not do this.

- you add two new callback functions 'new' and 'change' to
  ip_conntrack_protocol.  Can't we unify those two somehow?

> Sorry about expecting a connmark patched kernel, but i started to work=20
> on ctnetlink because i wanted to change connection marks ..

no problem, we can 'fix' this later.

Thanks once again, keep up the good work.

> Best regards,
> Patrick

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--rmZDAlAp7pllCg/D
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+2RX5XaXGVTD0i/8RAqs4AKCgGRb5ZsV1eAaY+bPkAn5sPijBTgCZAfkY
vHjdrmTqK4zwkldK0tzKlZ0=
=DdpW
-----END PGP SIGNATURE-----

--rmZDAlAp7pllCg/D--
