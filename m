From: Harald Welte <laforge@gnumonks.org>
Subject: Re: remove usage of __MOD_XXX_USAGE_COUNT and derivatives
Date: Fri, 10 Jan 2003 14:49:59 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030110134959.GE9467@sunbeam.de.gnumonks.org>
References: <3E1DEF2D.4080703@fugmann.dhs.org> <20030110131315.GS1353@sunbeam.de.gnumonks.org> <3E1ECF6B.5080109@fugmann.dhs.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Gtf2ElYKiUa3nI7m"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Anders Fugmann <afu@fugmann.dhs.org>
Content-Disposition: inline
In-Reply-To: <3E1ECF6B.5080109@fugmann.dhs.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Gtf2ElYKiUa3nI7m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 10, 2003 at 02:49:31PM +0100, Anders Fugmann wrote:
> Harald Welte wrote:
> >On Thu, Jan 09, 2003 at 10:52:45PM +0100, Anders Fugmann wrote:
> >
> >Ok, this seems to be some new 2.5.x api changes - I first need to get
> >familiar with this.
> Most of the documentation I found in include/linux/module.h.

Ok, will read it when I have some time...

> One thing I have noticed is that the module usage count for 'ip_tables'
> gets incremented twice when loading a module that depends on the
> ip_tables module. Unloading the module again also decrements usage count
> on ip_tables with 2. This happens both on vanilla 2.5.55 and 2.5.55 with=
=20
> the patch applied. It does not happen on 2.4.20 though.

Mh, strange. Maybe also related to the new module code.  Seems like I
should follow 2.5.x development a bit more closely.

> One question. Why is the module count increased (code wise) whenever a=20
> new module is loaded, that depends on the current module? Eg. When=20
> loading ipt_MARK, the module count for ip_tables is increased. The=20
> dependancies are still kept by the kernel so ip_tables cannot be=20
> unloaded anyhow.

I don't think that this is necessarry.  What is in fact necessarry, is
increasing the module use count for every rule created.  Otherwise it
would state 'iptable_filter:unused' in case you had 10 dropping rules.
This used to be the old behaviour, but confused a couple of users... so
we decided to change it.

> >So if the patch is accepted (still need to look at it), I will submit it
> >for kernel inclusion.=20
> Then I send it to the right place it seems.

yup :)

> Regards
> Anders Fugmann.
--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--Gtf2ElYKiUa3nI7m
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+Hs+HXaXGVTD0i/8RAtI0AJ0d3UiB2fnGybRUsFXR84yNAm5x1wCfa56f
fMXo1frKN4c51gT9Gc5XWPU=
=54Se
-----END PGP SIGNATURE-----

--Gtf2ElYKiUa3nI7m--
