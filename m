From: Harald Welte <laforge@netfilter.org>
Subject: Re: patch for conntrack expectations
Date: Tue, 24 Feb 2004 10:40:14 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040224094014.GV13386@sunbeam.de.gnumonks.org>
References: <403014C5.8080102@eurodev.net> <20040217213217.GF30968@obroa-skai.de.gnumonks.org> <4032F4DE.3050402@eurodev.net> <20040218172539.GX9464@sunbeam.de.gnumonks.org> <4038B14C.901@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W18qbkTAGYos9/y6"
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <4038B14C.901@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--W18qbkTAGYos9/y6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 22, 2004 at 02:40:28PM +0100, Pablo Neira wrote:
> Hi Harald and list!

Thanks pablo.

I am fine with that patch, and I'd like to put it in patch-o-matic for
now.  As the changes are fairly obvious, I hope we won't get too much
trouble with it ;)  However, please see my following comments.

> I finished my patch to add an ip_conntrack_expect_alloc(...) function. I=
=20
> also patched all the current conntrack helpers available in the stable=20
> branch and patch-o-matic-ng.

thanks. This means that once we get it into the core kernel, we should
definitely have  the first pom-ng release out, otherwise people will
still use the old API.

This makes me think of another issue.  We should either rename the
function, reorder arguments, do whatever.   We cannot just make all old
(unpatched) code compile without any warning, and still have it crash :(
I think it's best to exchange the order of the two arguments in
ip_conntrack_expect_related().  This way a compiler would complain if
some old helper was compiled with the new core.

> - I saw that Patrick submitted recently a patch to clean up the amanda=20
> helper (BTW, nice work!), I tried to patch my kernel with his patch=20
> available in patch-o-matic but it failed. So I patched the current. I=20
> also have no problem about patching the new one.

I thought this was included already in the stock kernel. At least in
2.4.x the patch went in.  Patrick, can you comment on this?

> BTW, I know that there's a skeleton of a helper in the documention, due=
=20
> to they mostly look the same but I think that I could add it more details.

yes, please.  Use the SGML master file, don't edit the HTML

> - There's a memset in expect_alloc (see expect.patch) after the=20
> allocation is done, I don't like it anyway but I just added to keep=20
> backward compatibility because some helper usually do it. I think that=20
> it's better setting all the fields of the new expectation in the helper=
=20
> (this implies being a bit more restrictive with the programmer but well,=
=20
> this is kernel programming anyway, it's restrictive :-)).

yes, sometimes code like this is included mainly for debugging purpose
and then left behind.

> I could delete that memset and have a look at all the helpers to make=20
> sure that all the fields are correctly set.

The issue is not very easy in this case.  Assume that tuple->dst.u
is 32bits wide (like after applying the pptp patch).  This in turn means
that every helper has to explicitly take care not to initialize
tuple->dst.u with a 16bit tcp/udp port number, since it could end
up in the 'other' 16bit half.  Rather, they have to assign
tuple->dst.u.tcp.port.  Those cases should all be fixed by now.

Now look what tuple_cmp does.  It memcmp's the whole union, not just the
individual fields.  This means that a tuple always has to be cleanly
initialized with zero, even in those parts that don't contain any
useful information.

So for now, I'd like to keep that memset until all the code is audited
with that regard.

> - I didn't exported the expect_insert function, but you could do it=20
> later to use it in the ct_sync code.

that's fine.

> - I found a condition where expect_related could succesfully insert an=20
> expectaction when removing an old one and return EPERM (see=20
> expect_related-newnat14.patch). I think that this doesn't make sense. Am=
=20
> I forgetting something? That patch fix that problem.

=20
> - I also have no problem about updating the documentation to add info=20
> about expect_alloc.

ok, please do so.

One issue with your patch:  It doesn't seem to use tab's for
indentation, but rather 8 spaces. Please clean this up.

Also, we cannot export that symbol GPL only, since it doesn't add a new
API but rather replaces an old one.
=20
> cheers,
> Pablo

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--W18qbkTAGYos9/y6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAOxv+XaXGVTD0i/8RAsEBAJwLoc5eKZri/NNAqiV+DNEv5Y8HXgCggxME
XxWypKvpafLvGRyZlFcN5zw=
=fh89
-----END PGP SIGNATURE-----

--W18qbkTAGYos9/y6--
