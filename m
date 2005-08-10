From: Eric Leblond <eric@inl.fr>
Subject: NuFW port to libnfnetlink_queue
Date: Wed, 10 Aug 2005 22:54:10 +0200
Message-ID: <1123707250.4996.9.camel@porky>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-YreCIeMwgPOXLzhMOscv"
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


--=-YreCIeMwgPOXLzhMOscv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I've just finished to port NuFW to NFQUEUE.

For the moment, only svn is up-to-date but the daily export will soon
contains this new feature.
Svn access method is described at :
	http://www.nufw.org/-Downloads-.html

It seems to work fine and I will soon do some more extensive tests to
see how it works under some load. I was able to use both nufw and the
test program so it is now officially possible to have more than on
programs using queueing to userspace at the same time.

Thanks everyone for the good work !
--=20
Eric Leblond <eric@regit.org>
NuFW, Now User Filtering Works : http://www.nufw.org

--=-YreCIeMwgPOXLzhMOscv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBC+mlynxA7CdMWjzIRAmmJAJ9pz4ORK6qSw4QiA/mQM2zlUyAYHQCgh+dt
n3I860j+lD8yvy6yPD1lSoo=
=1POX
-----END PGP SIGNATURE-----

--=-YreCIeMwgPOXLzhMOscv--
