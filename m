From: Harald Welte <laforge@gnumonks.org>
Subject: Re: iptables u32 match code for review/testing/...
Date: Tue, 7 Jan 2003 19:57:48 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030107185748.GV9467@sunbeam.de.gnumonks.org>
References: <200212271854.gBRIsf131987@isis.cs3-inc.com> <20030106125720.GF9467@sunbeam.de.gnumonks.org> <15897.46884.822054.847738@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wbs6g7essDTrqL3S"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Don Cohen <don-nf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <15897.46884.822054.847738@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--wbs6g7essDTrqL3S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 06, 2003 at 09:04:36AM -0800, Don Cohen wrote:
> Does that mean you like the content or that you're not willing to
> read it until the style is correct?

I did read it before.

I like the content (code/implementation/idea of having u32).

The only issue is that it doesn't really fit into the current iptables
architecture. Why?
	- because it is a whole classification engine on it's own
	- because it has an arbitrary [variable] amount of match data
	-

Those issues are not possible to resolve, unfortunately.

> I was hoping to hear some response to the *** questions.

please see my other mail, although the answers will be unsatisfactory.

> I was expecting complaints about not yet being in PoM form.

No, this is the last step.

> I assume you mean Documentation/CodingStyle.

yup.

> hmm, I do tend to put }'s at the end of a line - fixed below
> Was the indentation a problem?  The tabs were all 8 spaces, but
> perhaps you want wider indentation?
no, but look at the structure definitions in your header file.

> I try the suggested (c-set-style "K&R") (setq c-basic-offset 8).
> (Wow, so much for 80 columns!)

indent [or emacs styles] don't solve the problem thoroughly. but they
are an acceptable approximation ;)

Thanks again.
--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--wbs6g7essDTrqL3S
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+GyMsXaXGVTD0i/8RAmVqAJ4gztAzkImhZNpZwpzchqS0g5LhRQCfRmnY
alSsIPMCELuUg4hBUTT1lwU=
=kC5q
-----END PGP SIGNATURE-----

--wbs6g7essDTrqL3S--
