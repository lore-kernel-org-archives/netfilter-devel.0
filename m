From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 1/2] updates for [nf|ct]netlink and event API
Date: Mon, 27 Jun 2005 22:26:21 +0200
Message-ID: <20050627202621.GY19928@sunbeam.de.gnumonks.org>
References: <42C03F2E.30706@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PDzrc2MStrmgSXgo"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <42C03F2E.30706@eurodev.net>
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


--PDzrc2MStrmgSXgo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 27, 2005 at 08:02:22PM +0200, Pablo Neira wrote:
> Hi Harald,
>=20
> This patchset introduces tons of updates for the nfnetlink, ctnetlink=20
> and the conntrack event API. I haven't attached the file since it's that=
=20
> big, about 100K.

> You can get an incremental diff against SVN from:
> http://people.netfilter.org/~pablo/ctnetlink-2.6.12/SVN-patches/ctnetlink=
-ctevent-nfnetlink-update-2.6.12.patch

the patch removes the whole old ip_conntrack_netlink.c file and replaces
it with a new one.  I don't really see why.  An, now, you changed the
directory name from 2.6.11 to 2.6.12.  Is this neccessarry?  Why would
your recent changes to ctnetlink not work with a 2.6.11 kernel?

If there is no good reason, I would suggest to just patch the existing
files in the 2.6.11 subdirectory.

> I've split this big patch above into four pieces to make it easier to=20
> understand the changes:
> http://people.netfilter.org/~pablo/ctnetlink-2.6.12/2.6.11-vs-2.6.12/

please remove stuff like

> -#if 0
> +#if 1
>  #define DEBUGP printk

before releasing a patch, thanks.

Also, I would rather not like to have NFNL_SUBSYS_CTNETLINK_EXP deleted.
I thought it would be nice to have expect handling separated from
conntracks, since they really are two seperate data structures.

Apart from that I'm fine with all of your modifications.

I don't understand why the order of the expectation list was changed,
though.  Would you please explain why this was done?

> - Implement ip_conntrack_stats dumping and reset (accounting)

you want to dump the statistics via netlink?  i'm not sure whether that
is required.  lnstat is the only program using those counters, and using
/proc seems fine for that.

> - Implement get conntrack and destroy (accounting)

sorry, what are you referring to?

> - Kill event/dump mask based (?). Although it's unique, I think that it=
=20
> could be useful for weak conntrack event notification (think of just=20
> new, established and destroy event notification to reduce performance=20
> impact).

well, an interesting optimization.  My major problem with this whole
system (like the other IPCTNL_MSG_CONFIG stuff) is: how to correctly
deal with multipel users. =20

Now, I think there is a way to do it right.  Basically every application
would only request the events that it is interested in, and the kernel
would bitwise-or those events to create the event mask that actually is
to be dumped into userspace.

It's a bit like multicast membership subscription with IGMP...

So the only question remaining is: how does the kernel clean up / expire
the masks?  If apps only subscribe but never unsubscribe, we would never
clean up.

I'm not sure if we could somehow (cleanly) tie into the scoket
close/destroy code.  If yes, we could check if we can reduce the mask at
socket destroy time.

Another approach would be timer-based, so applications would have to
re-subscribe to 'their' groups in regular intervals if they are still
interested in certain events.  Sounds racy and ugly, though :(

I'm always open for better solutions, though :)

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--PDzrc2MStrmgSXgo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCwGDtXaXGVTD0i/8RAmwGAKCZvwNoRXjjL8cpTQru+buRjcHtVgCdEHwN
aarvM6OfZjTOsN8+PUpbqMY=
=QCLY
-----END PGP SIGNATURE-----

--PDzrc2MStrmgSXgo--
