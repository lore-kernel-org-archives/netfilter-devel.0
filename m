From: Martin MAURER <martinmaurer@gmx.at>
Subject: libnetfilter_queue and libnetfilter_log
Date: Thu, 14 Dec 2006 18:14:50 +0100
Message-ID: <1166116491.3905.14.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-RjVpnHZW/NyzoTeiHD8g"
Cc: FireFlier <fireflier@gibraltar.at>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


--=-RjVpnHZW/NyzoTeiHD8g
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

In one of my software projects (fireflier - interactive firewall) I have
been using QUEUE and ULOG for quite a while now.=20
When I recently decided to spend more work on fireflier again, I
remembered that those two systems are deprecated meanwhile. Looking at
the subversion archives I realized, that there is quite little
development going on there for the new ones (at least for NFQUEUE, which
I concentrated on so far).
So before spending too much time on switching to those libs I first
wanted to ask, if it comes still true, that those are the ones to use
for now. (Or should I switch later and encourage users to use ULOG and
QUEUE for now?)

During my experiments I realized, that there seems to be a problem in
libipq_compat.c(ipq_read). This function never returns positive for me
(which the former implementation did on new packets.=20
I guess it might have to do something with ipq_netlink_recvfrom being
commented out?

greetings
Martin



--=-RjVpnHZW/NyzoTeiHD8g
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFgYaKXHsqb5Up6wURAukjAKCD4fjpr/xZPonY0hVKPqMNsuSr9wCZAS7b
s+ZD0vBiS2HEa403O+J3YOE=
=hZca
-----END PGP SIGNATURE-----

--=-RjVpnHZW/NyzoTeiHD8g--
