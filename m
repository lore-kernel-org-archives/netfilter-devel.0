From: Harald Welte <laforge@netfilter.org>
Subject: Re: NFQUEUE: packet accumulation in queue, queue overflows
Date: Mon, 30 Jan 2006 09:50:35 +0100
Message-ID: <20060130085035.GS4603@sunbeam.de.gnumonks.org>
References: <43D7529D.000004.17272@ariel.yandex.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Av0MaMCQQeg4b3so"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: KdF <dkiba@yandex.ru>
Content-Disposition: inline
In-Reply-To: <43D7529D.000004.17272@ariel.yandex.ru>
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


--Av0MaMCQQeg4b3so
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 25, 2006 at 01:27:41PM +0300, KdF wrote:
> Hi all
>=20
> After switching to NFQUEUE from ip_queue mechanism in our billing
> system=20

A billing system should probably better use nfnetlink_log (or ULOG)
rather than nfnetlink_queue (or ip_queue).

> we've got strange trouble: all works fine, but some packets
> seem not to leave queue, and after some time queue overflows, and
> packets get dropped. I increased maximum queue length in kernel during
> setup, and built new kernel, but even with 16384 entries instead 1024
> it doesn't flush, but grows with time.

Others have also reported _single_ stuck packets in a queue, but not the
queue itself filling up.

> cat /proc/net/netfilter/nfnetlink_queue
>=20
> 3   1296  1697 2    64     0     0   123739  1
>=20
> I have an idea that only packets for which verdict NF_DROP is set in
> our program don't leave queue? Or it is a userspace program perfomance
> issue? But on tests with simultaneous `ping -f` from four stations all
> worked fine, and only 64 bytes is copied to userspace to get ip
> headers.

I would recommend writing a small 'short-circuit' program for
libnetfilter_queue, which just receives packets and issues verdicts (and
also counts how many packets have been processed).  Then send a defined
amount of packets, and see what happens.

Also, make sure you properly check errors with all libnetfilter_queue
functions that get called.

By using this short-circuit program, you can be sure that userspace
always issues a verdict for every packet it receives.

> If problem in userspace application perfomance, does NETFILTER have a
> mechanism to flush old packets from queue, if they were not processed
> by userspace application?

no. you have to return a verdict for every packet you receive in
userspace. flushing the queue (by dropping all packets) can only be
achieved by closing the queue and re-opening it.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Av0MaMCQQeg4b3so
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFD3dNbXaXGVTD0i/8RAskhAJ0REK9bq9+6cUXUiNnz4qLI2LQ/6QCfdwWx
n5VAdEHrBDbV4ezblhM+ouc=
=AQ1u
-----END PGP SIGNATURE-----

--Av0MaMCQQeg4b3so--
