From: "Preston A. Elder" <prez@srealm.net.au>
Subject: Re: [netfilter-core] iptables/conntrack in enterprise environment.
Date: Fri, 30 May 2003 01:33:22 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200305300133.44822.prez@srealm.net.au>
References: <200305290113.58552.prez@srealm.net.au> <20030529083953.GB2461@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter@lists.netfilter.org,
	netfilter-devel@lists.netfilter.org, coreteam@netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030529083953.GB2461@sunbeam.de.gnumonks.org>
Content-Description: clearsigned data
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

=2D----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I'd like to add some more to this issue.

I did some more testing, and figured out the exact scenario that is causing=
 me=20
problems, here goes.

I have my router box, say, 192.168.0.1, and a range of IP's behind it, say,=
=20
10.0.0.0/24, for arguments sake.  I also have an application on the router=
=20
box listening on 100 ports, say, 5000-5100.  My uplink interface is eth0, a=
nd=20
the interface with all the 10.0.0.0 addresses is on eth1.

Now, I add an iptables rules something like the following:

iptbales -t nat -A PREROUTING -j REDIRECT -i eth0 -p tcp -d 10.0.0.0/24=20
=2D --destination-port 1025:65535 --to-ports 5000-5100

If I then telnet to 10.0.0.1 on port 5050, the connection is immediate, and=
 my=20
application receives a new connection on port 5050.  If, however, I telnet =
to=20
10.0.0.1 on port 5150, there is a small (but noticable) delay between when=
=20
the telnet session shows the connection as established, and when the=20
application receives the connection (on a random port between 5000 and 5100=
=20
inclusive).

=46irst, I cannot see why this delay is even there, choosing a random port=
=20
between 5000 and 5100 is not exactly an onerous task, especially not one th=
at=20
should cause a noticable delay.  And the connection itself is quite=20
responsive once established (closing it down takes no more time one way or=
=20
the other).

The problems really start when you multiply this out to enterprise proporti=
ons=20
=2D - I'm talking a system than can get thousands of new connections a seco=
nd=20
(the hardware is up to it, we're talking gb's of ram, and SMP machines).  A=
s=20
with my above small test case, connecting to a port in the 'to-ports' range=
=20
gives me an immediate connection (on the application), but the delay betwee=
n=20
telnet showing the connection established, and the application receiving th=
e=20
connection (and establishing it) grows dramaticaly, even taking over a minu=
te=20
for the application to receive the connection.  Hell, even the time for=20
telnet to show the connection as established is much greater when connectin=
g=20
to a port outside the 'to-ports' range than when connecting to one within=20
this range.

This is just an abserd delay, and I really can't see a logical reason that=
=20
this delay would be there.  Can anyone shed some light onto the situation,=
=20
and more importantly, how to fix it?  I'm willing to test some patches=20
(obviously in my test environment) to see if they resolve the problem as=20
necessary.

Thanks in advance for your help,

=2D --=20
PreZ
Systems Administrator
Shadow Realm

PGP FingerPrint: B3 0C F3 32 DE 5A 7D 90  26 F6 FA 38 CC 0A 2D D8
=46inger prez@srealm.net.au for full PGP public key.

Shadow Realm, a hobbyist ISP supplying real internet services.
http://www.srealm.net.au
=2D----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE+1u04KFp14D8AGEQRAlg3AJ9c4LBfDIZ+3PQ5NzhM7tCdsqCdhQCfdIFz
JFA7Y0hHt0bVtuhKiA+qtMY=3D
=3DNKyf
=2D----END PGP SIGNATURE-----
