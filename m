From: Harald Welte <laforge@netfilter.org>
Subject: Re: BUG() in ip_ct_event_cache_flush()?
Date: Fri, 7 Oct 2005 23:35:25 +0200
Message-ID: <20051007213523.GD4719@rama>
References: <20051005.234046.88863607.davem@davemloft.net>
	<20051007040906.GC5953@rama>
	<20051006.131408.24379607.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cz6wLo+OExbGG7q/"
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline
In-Reply-To: <20051006.131408.24379607.davem@davemloft.net>
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


--cz6wLo+OExbGG7q/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 06, 2005 at 01:14:08PM -0700, David S. Miller wrote:
>=20
> > On Wed, Oct 05, 2005 at 11:40:46PM -0700, David S. Miller wrote:
> > >=20
> > > I've seen an OOPS backtrace with current 2.6.x kernels
> > > that seems to be in ip_ct_event_cache_flush().
> >=20
> > :( do you have the oops/backtrace?
>=20
> It's in a Fedora bug report here:
>=20
> http://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=3D169981

Oh, a fedora kernel.  I received some reports that fedora kernel
changelog claims to have the event cache fix, but in reality it is not
applied. =20
People who switched from fedora to a current git kernel have reported
that the problem has gone away.

Anyway, the bug report from the link above talks about=20

Call Trace:<ffffffff88308c29>{:ip_conntrack:ip_conntrack_cleanup+20}
       <ffffffff88306ab4>{:ip_conntrack:init_or_cleanup+676}
       <ffffffff80157798>{sys_delete_module+490}
       <ffffffff801118aa>{syscall_trace_enter+217>
       <ffffffff8010eb6c>{tracesys+209}

which seesm to have no relation to the event cahce, but rather some
module unload problem. Are you sure that bug report is the right one?

> The reporter is running an SMP AMD64 kernel on a laptop, FWIW.

mh, I could try that since I'm having a Turion64 notebook... but never
had the idea to run an smp kernel on it.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--cz6wLo+OExbGG7q/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDRuobXaXGVTD0i/8RAoEqAJ9UQ6PJS3MQg7jPJYJ1CcPLudSRqQCglc1J
rT/qFHLMUKFiMSuWgd2KNbE=
=d7sz
-----END PGP SIGNATURE-----

--cz6wLo+OExbGG7q/--
