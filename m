From: Harald Welte <laforge@netfilter.org>
Subject: Re: ctnetlink questions
Date: Mon, 20 Oct 2003 09:15:45 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031020071545.GA21521@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.44.0310200244580.17141-100000@filer.marasystems.com> <3F934FFD.7090700@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="q2B1bTINGa+6bWWJ"
Cc: Henrik Nordstrom <hno@marasystems.com>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3F934FFD.7090700@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--q2B1bTINGa+6bWWJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 20, 2003 at 05:01:17AM +0200, Patrick McHardy wrote:

> >This requires a read lock per hash bucket while dumping that bucket, and
> >some small (usually) amount of memory to keep the temporary sorted index
> >of bucket entries unless the bucket is permanently resorted in which case
> >it may be possible to solve with no memory allocation (but then requires=
=20
> >the bucket to be write locked while resorting which is probably worse).
>=20
> Sounds like a nice solution. I favour the permanent resorting for these=
=20
> reasons:
> - all temporary memory allocations should be released before
> ctnetlink_dump is left, not in ctnetlink_done since we don't know if
> and when the read will continue. this means sorting multiple times is
> required.

again, this seems a shortcoming of the netlink infrastructure.  This
would be much better, if we'd actually have a reference to the socket of
the userspace process (since table dumps could be unicast anyway...).

As for the permanent sorting:  I fear that is going to be an intrusive
change.  Either ctnetlink locks the bucket on it's own [and does the
sorting locally], or we have some ugly special-case functions in the
ip_conntrack core.  Also:  There is no primitive for upgrading a reader
lock into a writer lock.  Since we don't know if the skb is large enough
beforehand, we would need to take a write lock in any case (since we
cannot tell if we need to reorder or not).

> - we can use some sorting algorithm which benefits from pre-sorted=20
> input. this would give better average performance. IIRC new conntracks
> are added at the head of the chains, so if we sort and walk backwards
> through the chains we only have to resort after an id counter wrap.

this works with a 64bit counter, but doesn't with my proposed generation
counter.  the generation counter has two advantages:
- no global counter, just the counter field in every conntrack
- less size increase of struct ip_conntrack.=20

Oh well, yes.  We have to think about the slab cache returning objects
to the 'real' memory allocator.  Then our generation counter would
become useless.  Don't know if it is reliable enough to initialize the
counter with a random 32bits in that case.  How high is the  probability
of re-using the recently-used counter in that case?

> I agree, we should use 64 bit.

I feel like I have to cry.  As soon as we add any kind of counter (be
it 32 or 64 bits), we would definitely have to make it a compile time
option.  My vision of ctnetlink was something like a match extension:
You can always compile it as a module, and it wouldn't hurt performance
as long as you don't load it.

> Also a good idea. Thanks Henrik for your valuable input. Harald, what
> do you think of this approach ?

yes, if we really want to be reliable I don't see a better way.

> Best regards,
> Patrick (hoping mozilla will have mercy with his formatting this time)

not really :(

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--q2B1bTINGa+6bWWJ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/k4uhXaXGVTD0i/8RAnOAAKCT7zXbbc/cpmb2n3vyJuArIpheCgCdGCCk
X0jXL/kWuWdDAmBptV6Yv2g=
=lxOP
-----END PGP SIGNATURE-----

--q2B1bTINGa+6bWWJ--
