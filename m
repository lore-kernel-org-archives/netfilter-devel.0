From: Harald Welte <laforge@gnumonks.org>
Subject: Re: conntrack hash function comparison
Date: Sat, 1 Feb 2003 09:37:03 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030201083703.GL27870@sunbeam.de.gnumonks.org>
References: <15916.59019.853598.788888@isis.cs3-inc.com> <Pine.LNX.4.33.0301211136020.19820-100000@blackhole.kfki.hu> <15917.31840.767508.76359@isis.cs3-inc.com> <20030131114145.GS9073@naboo.cybercafe42> <15931.6072.971476.262073@isis.cs3-inc.com> <20030201065701.GC23640@oknodo.bof.de> <15931.32301.797460.620368@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K6Vt3zCKtaqyTnPU"
Cc: Patrick Schaaf <bof@bof.de>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Don Cohen <don-netf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <15931.32301.797460.620368@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--K6Vt3zCKtaqyTnPU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 31, 2003 at 11:58:37PM -0800, Don Cohen wrote:

> not very practical if you think about it
> More reasonable: longest bucket length since last rehash
> If you really want to take the time to look at such things, I'd suggest
> a list of lengths of all buckets.

I think that whas what Jozsef really meant.

>  > 2) one read/writable /proc entry, containing an integer: the number of
>  >    hash buckets. This is missing right now, anyway (have to grep the
>  >    boot messages). Make it writable, and rehash exactly when a write
>  >    changes the hash bucket count.
> It's currently a module parameter? =20

yes, it is. =20

> Not that it would be so hard to
> change it at run time, but is that really so useful?

Especially in the case where it is not a kernel module ;)

> You could unload the module and reload it with a different parameter. =20
> If the complaint is that you then lose the data, I suggest using the
> proc file to save and restore (copy the /proc data to a real file, then
> copy it back after unload/reload).  That would even let you save and=20
> restore over a reboot.

no way. no way. no way.
sorry, but read the various discussions about the /proc/ip_conntrack
interface in general, think about all the data that is not printed (like
references to currently in-kernel packets, connection between
expectations and master connection, ...  lots of those issues are
relevant for conntrack failover as well.  This is only viable via
ctnetlink, which is not part of the stock kernel yet.

>  > This way, the policy (when to rehash) is safely in user space, the
>  > kernel gives mechanism, only - just like it should.
> /proc control over the rehash threshold (max bucket size) seems like
> an appropriate "control over policy". =20
> Whereas a user space program doing something to cause a rehash seems
> to me to be a bad choice.  (For one thing, when the kernel gets into=20
> trouble the user space program might never have a chance to run.)

yes, I agree.  and that's why i like the idea of a 'min rehash interval'
proc parameter.  If you set this to '0', kernel will rehash never.  '1'
means maximum of one rehash per second, ...

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--K6Vt3zCKtaqyTnPU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+O4cvXaXGVTD0i/8RAhvxAJoCl7Sdjn0Ow14tP+wpRbaeR3FL5wCgipnO
wOOtExlsljk8DjVj9J7xQW4=
=JxKS
-----END PGP SIGNATURE-----

--K6Vt3zCKtaqyTnPU--
