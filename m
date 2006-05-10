From: Harald Welte <laforge@netfilter.org>
Subject: [RFC] [PATCH] clean up nf_log API
Date: Wed, 10 May 2006 21:10:34 +0200
Message-ID: <20060510191034.GA29531@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Cc: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
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


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

After spending some more time with the nf_log API, I think it still
needs some further cleanup.

The main point of nf_log was to get some unfied support for packet
logging backends, independent of the ruleset.  We currently have logging
backend functionality tied to ipt_LOG, ipt_ULOG packet filter rules,
which is inflexible and unsuitable for other entities within netfilter
that want to log packets.

However, on thing that I missed during the nf_log implementation was the
fact that it was no longer possible to have some rules using LOG, some
others ULOG.  With the introduction of nf_log, it was only possible to
use only one logging mechanism at any given point in time.

Also, there was no fallback support.  If you had configured
nfnetlink_log as your backend and the admin decides to remove that
module, nothing will be logged, even though other mechanisms might be
available and present in the kernel.

Another problem was that neither the ULOG nor the LOG target supported
all of the arguments/parameters that the nfnetlink_log backend needed.
Therefore, it is practically impossible to exploit all the features=20
with the current kernel.

Therefore, I now propose the following patchset, which

1) enhances 'struct nf_logger' with a list_head, usage counter a
   priority and pf field
2) cleans up the api.  we now call nf_log_[un]register() once from every
   backend.  registering doesn't mean that it's actually active.
   successive calls to nf_log_[un]bind_pf() will actually bind a given
   backend to the specified protocol family.
3) introduction of a new NFLOG target.  Only that NFLOG target supports
   all the arguments that all our backends support.
4) Adds 'fallback' support.  This means that during unbind or
   unregistration of a given backend, we check in the global list of
   logging backends and chose the one with the hightest priority that
   supports our protocol family.
4) modify ipt_LOG, ipt_ULOG, ip6t_LOG and nfnetlink_log to reflect the
   abovementioned changes.

I have implemented the NFLOG target as iptables target (not xtables) due
to 'customer need'.  However, once we decide that this patch should be
merged, I'll provide an x_tables version.

There are some open questions:

a) we only search for 'fallback' backends during unregistration/unbind.
   Should we also do this during registration?  Or whenever we receive
   a packet and don't have a backend?  Early registration might become
   problematic, since we don't really know what the user wants...
b) reference counting.  We could actually get_module / put_module the
   module that implements a specific backend rather than using our own
   use counter.

Comments welcome.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFEYjqqXaXGVTD0i/8RAtr2AJ48kvGrF+UHRxTKmMaoLrQIVe0INACfd4OM
TkVz5Ldz2nlF1FjxOffgZRM=
=g+Ge
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
