From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] for several issues
Date: Sat, 27 Mar 2004 22:12:05 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040327211205.GB26945@sunbeam.de.gnumonks.org>
References: <405992CD.1040707@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SO98HVl1bnMOfKZd"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <405992CD.1040707@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--SO98HVl1bnMOfKZd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 18, 2004 at 01:15:09PM +0100, Pablo Neira wrote:
> Hi Harald,

Sorry for this very late reply.  But finally i found enough spare time
to look into your patches.  Since they are mostly optimizations, I
postponed them again and again :(

> Here we go:
>=20
> a) clean up for tcp_packet funtion. If a tcp packet with the rst flag=20
> set which also hasn't seen the reply yet hits the connection tracking,=20
> the conntrack will be drop inmediately. The current implemented of this=
=20
> condition is:

perfectly fine, I'm going to submit this to davem.


> b) update for expect-optimize in pom-ng.

I'll accept those patches, too.

> c) ip_ct_refresh lock issue. The conntrack table is write_lock'ed to=20
> refresh a non-confirmed conntrack but this is not needed since it's not=
=20
> inserted yet, so I consider that this lock is not needed. Actually=20
> playing with nfsim tells me that this condition only happens when a new=
=20
> conntrack is created, and this conntrack is not inserted yet.

Yes.  But isn't this optimization based on the assumption that
'is_confirmed()' is an atomic operation?  What if it gets confirmed on a
second cpu, after is_confirmed() was called and before we refresh?

Am I missing something?

> d) ip_conntrack_in issue. I didn't posted any patch because I think that=
=20
> a bit of feedback would be ok.
>=20
> - I didn't find any helper that returns -1.

that doesn't mean that there could not be one in the future.  From our
past experience we know too well that there are lots of ugly protocols.
And in some case, it might actually make sense to let the helper decide
that this connection cannot be tracked and should thus become state
INVALID.

> - I didn't find a function proto->packet (which actually calls its=20
> respective protocol specific function) that returns NF_DROP. So the=20
> condition alike(NF_DROP) is always true. In fact, all the functions that=
=20
> I had a look at return -1 and NF_ACCEPT.
> Anyway, in which case does returning NF_DROP make sense here?.

same as above.  Some weird protocol might actually behave better if a
packet is dropped.  Yes, I know it sounds insane.  Conntrack should
never drop a packet.  But people on netfilter-devel know that this is
not always the truth :(


> e) datalen variable issue in ftp conntrack helper. this calculation:
>=20
> skb->len - dataoff
>=20
> is done twice, but it's not needed because datalen already contains this=
=20
> value. Patrick said that the patch is ok.
>=20
> Patch file: ftp_helper-cleanup.patch

also fine with me.


> f) Minor issue in commark. I sent a patch to Henrik because=20
> ip_conntrack_get calculates ctinfo and this is not needed. He told me=20
> ip_conntrack_get is the official API and digging in pskb is not ok, I=20
> agree, actually I'm neither happy with my solution nor calculation=20
> ctinfo if it's not needed. He also pointed out that maybe another=20
> function which only return the conntrack without ctinfo could be=20
> implemented. Is implemented a function which does almost the same thing=
=20
> that ip_conntrack_get worthy?

In principle you're right.  The question is, whether it's worth
optimizing that case.  Maybe you can do a little analysis:  How many
direct or indirect calleers of ip_conntrack_get (or __ip_conntrack_get)
don't need ctinfo?  If it is just about connmark, I guess we can leave
it like it is.  But if a reasonable number of callers doesn't need it,
we could change it.


> g) This is just a remark. Someone reposted to linux-net yesterday a=20
> patch which fixes a circular dependency in compilation for 2.4 branch.
>=20
> Please see:=20
> http://lists.netfilter.org/pipermail/netfilter-devel/2002-November/009928=
=2Ehtml
>=20
> Attached the patch which fixes this. Don't blame if something's wrong,=20
> this patch is not mine, I'm just a forwarder.

this has already been submitted meanwhile.

> best regards,
> Pablo

You seem to be digging quite deep into the internals of
netfilter/iptables/ip_conntrack.  That's very welcome, we always need
more people who understand the complex code.  Would be nice to receive
more of your insights and optimizations.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--SO98HVl1bnMOfKZd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAZe4lXaXGVTD0i/8RAkbOAJ4hd7gW8QJ6wT4k+C2SIzj/6/FOcgCfQWV3
qVENa4OQpSd5IOXxlKHbty8=
=cII/
-----END PGP SIGNATURE-----

--SO98HVl1bnMOfKZd--
