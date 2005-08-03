From: Eric Leblond <eric@inl.fr>
Subject: NFQUEUE man page and problem
Date: Thu, 04 Aug 2005 00:52:48 +0200
Message-ID: <1123109568.5961.4.camel@porky>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-j4R+gv4k8ursk7U6Y6yl"
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


--=-j4R+gv4k8ursk7U6Y6yl
Content-Type: multipart/mixed; boundary="=-LplId1HRhlhGYriJLB8a"


--=-LplId1HRhlhGYriJLB8a
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I'm currenty testing NFQUEUE. I've got problem with the option :

/usr/local/sbin/iptables -A OUTPUT -p tcp --dport 23 --syn  -j NFQUEUE --qu=
eue-num 42
iptables v1.3.3: Unknown arg `42'

without the option --queue-num it's ok.

I've modified the man page to add indication about the option (patch
attached to the mail).

BR,
--=20
Eric Leblond <eric@inl.fr>
INL

--=-LplId1HRhlhGYriJLB8a
Content-Disposition: attachment; filename=nfqueue.man.diff
Content-Type: text/x-patch; name=nfqueue.man.diff; charset=ISO-8859-15
Content-Transfer-Encoding: base64

SW5kZXg6IGV4dGVuc2lvbnMvbGliaXB0X05GUVVFVUUubWFuDQo9PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQotLS0gZXh0
ZW5zaW9ucy9saWJpcHRfTkZRVUVVRS5tYW4JKHLDqXZpc2lvbiA0MjEwKQ0KKysrIGV4dGVuc2lv
bnMvbGliaXB0X05GUVVFVUUubWFuCShjb3BpZSBkZSB0cmF2YWlsKQ0KQEAgLTEsNyArMSwxMCBA
QA0KIFRoaXMgdGFyZ2V0IGlzIGFuIGV4dGVuc2lvbiBvZiB0aGUgUVVFVUUgdGFyZ2V0LiBBcyBv
cHBvc2VkIHRvIFFVRVVFLCBpdCBhbGxvd3MNCiB5b3UgdG8gcHV0IGEgcGFja2V0IGludG8gYW55
IHNwZWNpZmljIHF1ZXVlLCBpZGVudGlmaWVkIGJ5IGl0cyAxNi1iaXQgcXVldWUNCi1udW1iZXIu
ICANCitudW1iZXIuICBJdCB0YWtlcyBvbmUgb3B0aW9uOg0KIC5UUA0KKy5CUiAiLS1xdWV1ZS1u
dW0gIiAiXGZJdmFsdWUiDQorVGhpcyBzcGVjaWZpZXMgdGhlIFFVRVVFIG51bWJlciB0byB1c2Uu
IFZhbGlkIHF1ZXVlIG51bWJlcnMgYXJlIDAtNjU1MzUuIA0KKy5UUA0KIEl0IGNhbiBvbmx5IGJl
IHVzZWQgd2l0aCBLZXJuZWwgdmVyc2lvbnMgMi42LjE0IG9yIGxhdGVyLCBzaW5jZSBpdCByZXF1
aXJlcw0KIHRoZQ0KIC5CDQo=


--=-LplId1HRhlhGYriJLB8a--

--=-j4R+gv4k8ursk7U6Y6yl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBC8UrAnxA7CdMWjzIRArUgAJ9wJQtI2DqPOT3fRCzhFTSCPxujdQCfXihH
rhgh+3r1SFqvZarZq4ceVxI=
=uCQG
-----END PGP SIGNATURE-----

--=-j4R+gv4k8ursk7U6Y6yl--
