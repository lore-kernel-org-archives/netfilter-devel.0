From: Harald Welte <laforge@gnumonks.org>
Subject: Re: defense against conntrack attacks
Date: Sun, 16 Jun 2002 22:16:33 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020616221633.J2543@sunbeam.de.gnumonks.org>
References: <20020615132638.84C444509@lists.samba.org> <15627.49630.258601.138681@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TsHlYwxJd0kekxFz"
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: don-nf@isis.cs3-inc.com (Don Cohen)
Content-Disposition: inline
In-Reply-To: <15627.49630.258601.138681@isis.cs3-inc.com>; from don-nf@isis.cs3-inc.com on Sat, Jun 15, 2002 at 03:38:22PM -0700
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--TsHlYwxJd0kekxFz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 15, 2002 at 03:38:22PM -0700, Don Cohen wrote:

> Here's a summary of some experiments that show this is true and
> further suggest that the real expense is in creating new conntrack
> records.  If this is a well known phenomenon, then I apologize for the
> waste of bandwidth and invite you to skip to section 2.

thanks, this is the kind of testing/benchmarkin which is appreciated.

> These were done with 200MHz machines, one generating packets and
> the other forwarding.  They're connected by a 100Mbit link.
>=20
> First test:
>  on router
>  iptables -A PREROUTING -t mangle -j MARK --set-mark 2
>  traffic generator sends 7000 syn's in 2.4 sec (to an address that
>   won't reply) all packets the same except randomized destination ports
>  result: all marked and forwarded
>=20
> Second test:
>  on router
>  iptables -A PREROUTING -t mangle -m state --state new -j MARK --set-mark=
 1
>  traffic generator sends 6131 syn's in 2.06 sec, just like before
>  result: 1766 marked new (and I assume forwarded, the total number sent
>   out that interface was a little more, I suppose arp, etc.)
>=20
> This shows that conntrack is a bottleneck, at least dealing with new
> packets.

there are a couple of issues related to this:

1 the number of hash buckets in your conntrack hash table (this is a module
  loadtime parameter and the default depends on your systems total RAM size)
2 the conntrack hash function.  If all (or more/most) connections would end
  up in the same couple of buckets, performance would suffer significantly.
3 did you see any messages in your kernel log ?  any OOM messages?
  I could imagine that the kernel has difficulties allocating the needed
  memory for conntrack entries

> Third test:
>  router as in second test
>  traffic generator now sends identical syn packets,
>   8382 in 2.08 sec
>  result: all marked new (and I presume forwarded, again the total
>   number sent out that interface is a bit higher)
>=20
> This shows, I think (please correct me if I'm wrong) that it's
> creating new conntrack records (and perhaps garbage collecting old
> ones) that is the real bottleneck.

yes, the results seem to=20

> Fourth and fifth tests:
>  router as in first and second test
>  traffic generator now creates a real connection, just does rcp of
>   a large file to a third machine on the other side of the router
>  result: no difference, in each case 25MBytes copied in ~4 sec.
>=20
> Which shows that conntrack is not a bottleneck for packets in
> established connections.

it's only a very slight decrease in performance in the case of established
connections, yes.  This decrease tends to be outweighed by the performance
gain through significantly reduced complexity of the packet filtering rules=
et
with stateful firewalling.

> So what?  You might argue that=20
> - in normal usage new connections are not generated very fast=20

depends on your usage.  7000 syn's in 2 sec is not so unrealistic in front
of huge webservers.  Imagine somebody flooding you at wirespeed 100mbit
ethernet... 147k packets [which is a problem only for routing, not even
talking about firewalling/conntracking/...].

> I conclude that if the code for creating new connections could be made
> faster (it would have to be MUCH faster) there would be some benefit
> in doing so.  I've not looked at that.  I presume whoever wrote it was
> at least trying to make it efficient.  If anyone thinks this is a
> promising approach, please feel free to say so.

the question would be:  what exactly is so slow? why is it slow?

> What I'm really interested in is a defense that, e.g., rate limits
> syns.  The problem I see in the current implementation (again, correct
> me if I'm wrong) is that the very first thing that happens when a
> packet arrives is that conntrack processes it, and this includes the
> code for creating a conntrack record in the case where there is none.

yes, I think Jozsef is working on a 'conntrack exemption table' where you
could tell it that certain [maybe above a certain limit] packets are=20
not conntracked.

> If you recall my posting in April, you won't be surprised that I want
> to put the connection creation code well after the current postrouting
> hook.  After that hook the packet is enqueued for traffic control, and
> it can be dropped between then and when it is dequeued to be sent.  So
> I'd like to create a new hook after that dequeue, and this is where I
> propose to create the connection record.

This sounds odd.  First, this is too revolutionary to the overall concept.

Second, you need conntrack information before postrouting:

- for doing DNAT [which _needs_ to happen before the routing decision]
- for any stateful rules in the FORWARD chain of the filter table
- for any stateful rules in the INPUT chain of the filter table

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M+=
=20
V-- PS++ PE-- Y++ PGP++ t+ 5-- !X !R tv-- b+++ !DI !D G+ e* h--- r++ y+(*)

--TsHlYwxJd0kekxFz
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9DPIgXaXGVTD0i/8RAvyXAJwParvx8vCDZaLe3Y3jwd+0ZAhHggCfTG0q
QbOPsA7VNSNmsKOCCPKuezk=
=LPA0
-----END PGP SIGNATURE-----

--TsHlYwxJd0kekxFz--
