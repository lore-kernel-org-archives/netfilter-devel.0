From: Harald Welte <laforge@netfilter.org>
Subject: Re: target MARK in filter table?
Date: Mon, 14 Jul 2003 10:05:03 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030714080503.GE6538@naboo>
References: <Pine.LNX.3.95.1030713150116.17878A-100000@cannabis.dataforce.net> <Pine.LNX.3.95.1030713163717.31849A-100000@cannabis.dataforce.net> <20030713141944.GB1284@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="brEuL7wsLY8+TuWz"
Cc: Poltorak Serguei <poltorak@df.ru>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20030713141944.GB1284@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--brEuL7wsLY8+TuWz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 13, 2003 at 04:19:44PM +0200, Patrick Schaaf wrote:
> > If you do know a reason why this must not be done, please tell me. MARK=
 is
> > usefull even without advanced routing.
>=20
> I do not disagree, the rerouting indecision was just the one possible rea=
son
> I could think of.
>=20
> What do other developers think? What other reasons were there to keep the=
 MARK
> target from working in the filter table?

Because it violates our idea of the iptables framework.  It is a policy
kind of decision, not a 'what is technically possible' decision.

The idea is to have targets for filtering in the filter table - and
anything that modifies the packet [or potentially affect other kernel
subsystems such as policy routing] in 'mangle'.

We could enable almost all mangle targets to be used in the filter
table, there is no inherent technical limitation.

But it just feels wrong with regard to the policy we are trying to
enforce.

In that particular practical case, I think Poltorak Serguei is 'abusing'
the mark mechanism for something that we didn't think it should be=20

> While we are on the topic of seemingly arbitrary "sanity" checks, why is
> it that using the TCPMSS option throws a vague "invalid argument" error
> when one forgets to also specify --syn? Can't that target just check for
> tcp/syn dynamically, i.e. become a NOOP for non-syn packets, instead of
> forcing me to specify --syn at rule insertion time?

Error reporting is a whole discussion that I've had at least once a
couple of years ago.  There is no sane way to add verbose error
reporting back to iptables userspace because of the set/getsockopt
interface :(

the best we can do is printk() the error and ask the user to check dmesg
in case we receive -EINVAL.

But returning an error in this case is IMHO the correct behaviour.  What
is the idea behind blindly accepting rules that don't make sense for
non-syn packets?

And if there is one mechanism of checking for SYN, why should we
implement this check in other places as well?

Also, it gives the user/administrator a chance to see what is really
happening.  The user will know that TCPMSS will only affect SYN packets,
not any other (something he most likely doesn't know when it just
magically works).

> best regards
>   Patrick

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--brEuL7wsLY8+TuWz
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/EmQuXaXGVTD0i/8RAjoqAJ41fd14sjGLAtEDSuo9PzDYKEL9ZQCgtTLn
jW+rWcBEk95ZtPGOOftyq5g=
=Zohp
-----END PGP SIGNATURE-----

--brEuL7wsLY8+TuWz--
