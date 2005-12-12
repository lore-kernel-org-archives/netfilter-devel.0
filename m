From: Harald Welte <laforge@netfilter.org>
Subject: Re: execution context in netfilter hooks.
Date: Mon, 12 Dec 2005 21:43:37 +0100
Message-ID: <20051212204337.GE3420@sunbeam.de.gnumonks.org>
References: <439C8E74.9070206@libero.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O5XBE6gyVG5Rl6Rj"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Giacomo <jacum@libero.it>
Content-Disposition: inline
In-Reply-To: <439C8E74.9070206@libero.it>
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


--O5XBE6gyVG5Rl6Rj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 11, 2005 at 09:39:16PM +0100, Giacomo wrote:
> Good morning, i would like to know exactly the context of execution
> of code registered with netfilter hooks.

>  As far as  I understood, the context is that of a softirq, inside a
> bottom half. Correct me if i'm wrong..

'bottom half' context doesn't really exist anymore in 2.6.x, so it's
softirq.  But that's only true for forwarded packets.  locally-generated
packets at LOCAL_OUT are in 'kernel on behalf of process' context.

> But is it concerned with tasklets?

what do you mean by "is it concerned" ?

> Is execution serialized? In other words, if packet A fr instance is
> received from the net, and then packet B immediately, is packet A
> processed entirely before packet B? Or code can be executed in
> parallel for packet A and B?

on multiple cpu's it's fully parallel, so yes, packet A will execute the
same netfilter hook (plus attached code) on CPU1 where packet B will run
on CPU2.=20

On a single CPU, Packet B will be put onto a queue (by the hardirq
handler of the network driver) until packet A's softirq processing has
finished.  Then packet B will enter softirq context and pulled from that
queue.

> Moreover: interrupts are enabled in such context, aren't they? And that
> means that also a software timer can interrupt a routine being
> executed in bottom half.

software timers dont interrupt softirq context. (neither did the
interrupt bottom half context, when it still existed). you seem to be
confused about the kernel contexts and their interaction.

> But software timers run with sw interrupts disabled, so a timeout
> handler for instance cannot be interrupted by a routine managing
> reception of a packet arrived on the wire.

I think you should read some general information on how softirq and
hardirq processing work.  This is not really netfilter related.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--O5XBE6gyVG5Rl6Rj
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDneD5XaXGVTD0i/8RAvcQAJwMbiQgaxNDxzplpsKlVphBunhtWACfXugp
kBtybUioy2U3e+sJ90S3YnM=
=8Kwl
-----END PGP SIGNATURE-----

--O5XBE6gyVG5Rl6Rj--
