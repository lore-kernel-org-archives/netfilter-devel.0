From: Harald Welte <laforge@gnumonks.org>
Subject: Re: New Target: ipt_ACCOUNT
Date: Tue, 7 Jan 2003 20:07:57 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030107190757.GW9467@sunbeam.de.gnumonks.org>
References: <200212161736.gBGHaPn01458@moonlight.crew-kg.de> <20030106132422.GJ9467@sunbeam.de.gnumonks.org> <200301061722.h06HMsX01278@moonlight.crew-kg.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xFHWmGwbilGjB8dh"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rolf Wuerdemann <rowue@crew-kg.de>
Content-Disposition: inline
In-Reply-To: <200301061722.h06HMsX01278@moonlight.crew-kg.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--xFHWmGwbilGjB8dh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 06, 2003 at 06:22:48PM +0100, Rolf Wuerdemann wrote:

> Hi Harald (hope first name is o.k. ;) - no prob ;)

Klar doch.

> >  I think this is the wrong approach, there are way too much data
> > strucctures in non-swappable kernel momory allocated.  And kernel-OOM is
> > not something we should provoke.  A better architecture from my point of
> > view was: - use ULOG to copy the IP+TCP header of all packets to
> > userspace [it is very efficient in doing so!!!] and then do all the
> > accounting in userspace
>=20
> I was aware of the OOM-Problem (so DDoS can kill your Router!), and thoug=
ht
> about something like acctrack_max (simmilar to contrack_max) so you can
> set an maximum of tracked connections. This is not an solve for the root=
=20
> of the problem (to much data structures) - but an solve if you're afraid =
of
> running OOM from this side. -=20

> Perhaps I'll do some tests using ULOG, but
> from work with nacctd I know that copying packets from Kernel to User-Spa=
ce
> takes much time (and time/speed was something I want to save ;)

Don't even start to compare the two.  The method used is totally
different.  With ULOG you can have a in-kernel buffer of let's say 64k
and fill this buffer with the first 40 bytes per packet.  Then if 1638
packets have accumulated, the buffer is flushed via a netlink socket.
Several optimizations compared to a packet socket (what tcpdump does)
	- you only copy the header of the packets (if you want)
	- you have way less kernel/userspace transitions (and thus
	  context switches) because of the buffered concept
	- you filter the packets before you send them to userspace
	  as opposed to dumping everything and then=20

I have reports from people who are dumping 100MBit under full load to
userspace on 400-500MHz boxes from more than a year ago.

I'd love if you would give it a try, although it would mean developing
yet another implementation of what you have already working ;)

> *G* - no problem to fix (like some debug-messages, etc ;) - I've posted
> the source before "cleanup" - so I can work in suggestions/comments with
> the cleanup ;)=20

Ok, great. Thanks for taking care.


> > - the kernel/userspace interface using a socket option
>=20
> Yes - thinking about using /dev/accouning (fs i/o) to get the
> data from kernel-space - /proc-fs seems to be unlikely (approx 2M
> filesize) - any opinions?

Well, I haven't suggested an alternative because I didn't have one which
was looking better than the socket option...

This is a generic problem for everything (like ippool, the condition
match, ...) inside netfilter/iptables that wants to transport some data
from kernel to userspace.

> Nothing to sorry ;) - Hwo should I post the changed version? Complete,
> diff, link to ftp/cvs?

maybe post one more version, then convert it to patch-o-matic and submit
a patch against recent CVS.

> Hmmm ... If you want to gain speed it's one of the best solutions - accou=
nt=20
> the packets at the lowest possible level ;)

Yes. But then why do we use a multi purpose, multi user, multi tasking
operating system instead of a realtime OS?

Either we do want high efficiency and compromise security, layering,
etc. - or we want security, layering, abstraction... and will loose some
performance.

> Regard's

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--xFHWmGwbilGjB8dh
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+GyWNXaXGVTD0i/8RAhq7AJwJOBPwRwVa6ZQVM5Mzs+PE+wppawCdF2S7
1W2HE84lfxA8sb3XQpp36hk=
=bXFJ
-----END PGP SIGNATURE-----

--xFHWmGwbilGjB8dh--
