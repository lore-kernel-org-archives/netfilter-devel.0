From: Oskar Andreasson <oan@frozentux.net>
Subject: [rfc][update]iptables-tutorial 1.2.2
Date: Thu, 19 Oct 2006 18:20:19 +0200
Message-ID: <1161274820.22792.91.camel@LAPTOP4.MSHOME>
Reply-To: oan@frozentux.net
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-CkHj5zM+jQNF241ZUvFJ"
Return-path: <netfilter-bounces@lists.netfilter.org>
To: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--=-CkHj5zM+jQNF241ZUvFJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi All,=20

Thought I'd make a small update on the iptables-tutorial since it's now
been longer than I originally anticipated for this release. I'm still
waiting for the first copy of the book to arrive, hence the delay.=20

I still have a few things to add to get up to 2.6.18 standards, but I
got (hopefully) 1-2 weeks before my personal deadline for the project.=20

Would anyone care to give any suggestions on things that are either more
important than the ones in the listed TODO, or that you believe should
be included?=20

Also, the book will be 'perfect bound' hard-cover, 9x6", and right now
is closing in on 400 pages, and that's where I hope it will stop for
now :-). The page count can go up/down pending any layout changes
however. It will run at 33-35 USD + shipping per copy.=20

Sidenote, the current french translation seems to be done directly from
the chunky html source, as noted in the TODO. Would anyone be willing to
make a change of this?

Also, basically all the translations needs to be updated if anyone feels
inclined...

The current changelog looks as follows:=20
1.2.2
* Added SCTP match.
* Added addrtype match.
* Added link to policy routing using linux by Matthew G. Marsh.
* Added some internal links for better cross linking.
* Added comment match.
* Added hashlimit match.
* Added new --cmd-owner to owner match.
* Added realm match.
* Added important.gif image sign.
* Fixed --limit-burst, bad explanation.
* Fixed s/package/packet/ in MARK target. ("G.W. Haywood"
<gedATjubileegroupDOTcoDOTuk>)
* Added raw table in traversing_of_tables_and_chains.sgml
* Updated tables_traverse.gif with raw table and switched fonts.
* Added UNTRACKED and new untracked connections section in
statemachine.sgml.
* Removed internal catalogs etc, living off of local ones instead.
* Added SCTP characteristics section to tcp_ip_repetition.sgml
* Added all images for the SCTP chapters.
* Remade all header images from the tcp_ip_repetition.sgml chapter.
* Added SCTP headers section in the tcp_ip_repetition.sgml chapter.

My TODO for the tutorial looks like this:
* nf-log??
* Add all new targets in 2.6 kernel and iptables-1.3.6.
-- CLUSTERIP
-- CONNMARK
-- CONNSECMARK?
-- SECMARK?
-- NOTRACK
-- NFQUEUE?
* Remake flow images (Basically all images except header images).
* Add section about VPN and iptables (ie, private incoming traffic to
netfilter box with public iface and vpn iface on top). including
routing. nat'ed ipsec, openvpn. filtering ipsec, openvpn.
* French translation needs to be done in DocBook SGML, please? Should
fix problem with wrong charset encoding.
* Improve explanation of chain traversal. Add explanation of user
defined chains.
* Create index.


--=20
--
Oskar Andreasson
http://www.frozentux.net
mail/sip: oan@frozentux.net
icq: 33147668
msn: allostra@hotmail.com


--=-CkHj5zM+jQNF241ZUvFJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQBFN6XDGadwPDPpB60RAs1hAKCIongPaos0zC7SRPSJrEnxrt0pkQCg4t0d
XcGmYNBsoPHHAIWrT75dV18=
=e8d1
-----END PGP SIGNATURE-----

--=-CkHj5zM+jQNF241ZUvFJ--
