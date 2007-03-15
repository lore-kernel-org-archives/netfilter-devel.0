From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: [PATCH 1/1] Re: dangerous? Setting mark in nat table
Date: Thu, 15 Mar 2007 01:41:04 +0100
Message-ID: <1173919264.12805.25.camel@henriknordstrom.net>
References: <et6fp4$l04$1@sea.gmane.org>
	<Pine.LNX.4.61.0703131632190.18488@yvahk01.tjqt.qr>
	<45F6CD7C.40708@ufomechanic.net>
	<Pine.LNX.4.61.0703131717440.18488@yvahk01.tjqt.qr>
	<1173868532.26913.39.camel@henriknordstrom.net>
	<45F7D657.8070907@trash.net>
	<1173876211.26913.73.camel@henriknordstrom.net>
	<45F7F027.9050300@ufomechanic.net> <45F7F3C6.3060908@trash.net>
	<Pine.LNX.4.64.0703141415200.26704@blackhole.kfki.hu>
	<Pine.LNX.4.64.0703141453400.26704@blackhole.kfki.hu>
	<45F85C89.7070107@trash.net>	<1173905134.1760.59.camel@henriknordstrom.net>
	<Pine.LNX.4.61.0703142148180.1199@yvahk01.tjqt.qr>
	<1173910894.1760.89.camel@henriknordstrom.net> <45F87E06.20201@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-KDtJZsWVp5ANqVexRQZx"
Cc: netfilter-devel@lists.netfilter.org
To: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45F87E06.20201@gmx.net>
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


--=-KDtJZsWVp5ANqVexRQZx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

ons 2007-03-14 klockan 23:58 +0100 skrev Carl-Daniel Hailfinger:

> Speaking of HiPAC, when is it going to be merged?

Hard to say. The goals and implementation of HiPAC is pretty much in
line with the long term goals of Netfilter, but merging such big
projects is not easy with complications at many levels most of which
outside the code as such.

On the negative side of HiPAC there isn't very many people fully
understanding HiPAC, and as with most complex tree operations it's not
very easy to penetrate which is a bit scary from a maintenance point of
view. But thankfully at least the end results (the lookup tree) is
pretty simple, and so is the reasoning on what the lookup tree should
look like based on a given ruleset.. just what happens inbetween there
on rule updates is a little bit magic..

The hipac core is about 11000 lines of C, compared to ca 2000 for
iptables..

On the good side the current release is a whole lot easier to follow
than the earlier release for 2.4..

Regards
Henrik

--=-KDtJZsWVp5ANqVexRQZx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQCVAwUARfiWHUNPQ5Kbx8daAQII0AQAiSR6uzgTbtVf1pGk9A1BySuaFGhk3SKQ
/vkeK0sSa9/K4TauxSSX1N0bD2v4t4LX8kP8b2nUUhQMSF5DeVSTWBnSM3pm0y84
5oY9ZKa+ecZ9FKjG7V7kRXN/IDmk42T1pJeMA8ts4wU9g2Xf23bxg/7fAihSjTmY
mQHEZE+/A9o=
=o+NK
-----END PGP SIGNATURE-----

--=-KDtJZsWVp5ANqVexRQZx--
