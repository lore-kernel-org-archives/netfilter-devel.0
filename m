From: Harald Welte <laforge@netfilter.org>
Subject: Re: New logging module
Date: Fri, 5 Sep 2003 16:04:35 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030905140435.GI1597@obroa-skai.de.gnumonks.org>
References: <20030830190453.GE17715@sunbeam.de.gnumonks.org> <200308302248.h7UMm5r04111@linux1.futureware.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="P6YfpwaDcfcOCJkJ"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Philipp =?iso-8859-1?Q?G=FChring?= <p.guehring@futureware.at>
Content-Disposition: inline
In-Reply-To: <200308302248.h7UMm5r04111@linux1.futureware.at>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--P6YfpwaDcfcOCJkJ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 31, 2003 at 12:47:36AM +0200, Philipp G=FChring wrote:

> I think that my implementation is very efficient.
> * ipt_LOG is doing far more parsing/interpretation work on every
>   packet than my module.

yes, indeed.

> * IPtables already analyzed the packet (NAT reversing)

true.

> * There is no kernel/userspace switch necessary

> * The accounting rule is very simple, just IP based traffic, nothing more=
=20
> complex
>=20
> I agree that it would not make much sense, if it would need more complex=
=20
> rules to do it that way in kernelspace.
>=20
> > and: iptables rules are not an ideal infrastructure for accounting
> > anyway.
>=20
> Why not?

You basically have different ways of doing an accounting system:

0) via raw or packet socket

this is what solutions like nacctd do. =20

pro: very flexible, very portable
con: high CPU utilization

1) as a netfilter module

then you basically implement an accounting system that captures packets
within the kernel.  There is no relation to iptables - you're just
using a netfilter hook.

pro: no per-packet contex switch
con: have to implement everything from scratch

2) as an iptables target

then all the logic (and different users have different accounting
criteria) needs to be within the target.  All configuration information
has to be passed back and forth via the targinfo structure.

pro: easy implementation, you can use iptables to account only certain
packets
con: very limited scope.
con: you'd need a very flexible language to tell the module _what_ to
account=20

3) as part of ip_conntrack

this means that every struct ip_conntrack gets two byte counters (one
for each direction).  when a connection is terminated, you send the
accounting information about this connection to usrerspace (preferrably
via netlink).   you can sum up traffic for certain ports / addresses in
userspace.

pro: very easy implementation=20
pro: you can easily generate industry-standard netflow logfiles
pro: at most one context switch per _connection_

4) in userspace, receiving packets via ULOG=20

this means that the first n (user-defined) bytes of every packet gets
copied into a buffer, and this buffer is flushed to userspace when it
fills up (usually every 1000-5000 packets) or a timer goes off.  all
further processing is just like nacctd completely userspace based

pro: easy implementation, you can use iptables to select what you want
to account
pro: low number of context switches
pro: very flexible, all information is in userspace


=46rom my point of view, either solutions 3 or 4 should be used (depending
on the specific case).   Solution 2 has the inherent problem that it
might cover a very specific case, but is difficult to generalize.
Solution 1 is just too much work...

> But without ARP Spoofing (which started one week ago), the accounting sys=
tem=20
> worked perfectly, since the beginning.

I'm not stating that it doesn't work.  I'm just saying that there are
different architectures that might enable more functionality (and thus
make it more usful to other users).

> I have the following proposal to solve the ARP spoofing problem, as much =
as=20
> possible:
>=20
> 1. Create a real static ARP table system, that not only has immutable ARP=
=20
> entries, but also does not take up new ARP entries from the network

you can insert static arp entries from userspace, and use a
netfilter-arp module to block all incoming arp traffic.

> But I am not yet sure, where the correct point to work on it is.

Sounds interesting, and definitely doable.

> I am not quite sure what you mean with session here. I do not see session=
s,=20
> since I am not using Radius (Radius Sessions), I want to account all IP=
=20
> traffic (so no TCP Sessions), I am doing both NAT and plain routing (so n=
o=20
> NAT Sessions), and it is for 24/7 internet access, so there are no natura=
lly=20
> time-based sessions.

ok.  I understand the setup now.  The module might be doing a good job
for your case - but it is not suitable as a general-purpose accounting
infrastructure.

> > should be easy to implement with adding packet/byte counters to struct
> > ip_conntrack.  Several people have been working on session-log systems
> > based on netfilter/iptables.
>=20
> That sounds interesting. Can you give me links or point me into the right=
=20
> direction?

try to look in the list archives,  I would also have to search them.
Once there was a SLOG target for session logging - and I also remember a
'connbytes' match that at least adds the counters.

> ~ Philipp G=FChring              p.guehring@futureware.at
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--P6YfpwaDcfcOCJkJ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/WJfyXaXGVTD0i/8RAgmhAJwMi38+hTaU2w6gIdKWvPSnghnfwACfYEcX
RmR8xBoLwDHgbDhnRY6Qmvg=
=D8WB
-----END PGP SIGNATURE-----

--P6YfpwaDcfcOCJkJ--
