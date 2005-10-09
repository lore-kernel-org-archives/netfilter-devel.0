From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 3/5] NETFILTER nfnetlink: Explicitly mark nested nfattr's
Date: Mon, 10 Oct 2005 00:15:03 +0200
Message-ID: <20051009221503.GC6493@rama.customers.eurospot.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+nBD6E3TurpgldQp"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David Miller <davem@davemloft.net>
Content-Disposition: inline
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


--+nBD6E3TurpgldQp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave, [sorry for the wrong subject in the last patch]

please apply this fix to you 2.6.14 tree.

[NETFILTER] nfnetlink: use highest bit of nfa_type to indicate nested TLV

As Henrik Nordstrom pointed out, all our efforts with "split endian" (i.e.
host byte order tags, net byte order values) are useless, unless a parser
can determine whether an attribute is nested or not.

This patch steals the highest bit of nfattr.nfa_type to indicate whether
the data payload contains a nested nfattr (1) or not (0).

This will break userspace compatibility, but luckily no kernel with
nfnetlink was released so far.

Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit ff438dea2c776f065b7260b850a19d5f7a0bfec9
tree d43426c7fa24265a3dfd5bc692cb575d7a4d7a98
parent 6a8989e4852be3ac973abadd3a273c64492e02ee
author Harald Welte <laforge@netfilter.org> Sun, 09 Oct 2005 18:16:06 +0200
committer Harald Welte <laforge@netfilter.org> Sun, 09 Oct 2005 18:16:06 +0=
200

 include/linux/netfilter/nfnetlink.h |   12 ++++++++----
 net/netfilter/nfnetlink.c           |    4 ++--
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/=
nfnetlink.h
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -41,11 +41,15 @@ enum nfnetlink_groups {
 struct nfattr
 {
 	u_int16_t nfa_len;
-	u_int16_t nfa_type;
+	u_int16_t nfa_type;	/* we use 15 bits for the type, and the highest
+				 * bit to indicate whether the payload is nested */
 } __attribute__ ((packed));
=20
-/* FIXME: Shamelessly copy and pasted from rtnetlink.h, it's time
- * 	  to put this in a generic file */
+/* FIXME: Apart from NFNL_NFA_NESTED shamelessly copy and pasted from
+ * rtnetlink.h, it's time to put this in a generic file */
+
+#define NFNL_NFA_NEST	0x8000
+#define NFA_TYPE(attr) 	((attr)->nfa_type & 0x7fff)
=20
 #define NFA_ALIGNTO     4
 #define NFA_ALIGN(len)	(((len) + NFA_ALIGNTO - 1) & ~(NFA_ALIGNTO - 1))
@@ -59,7 +63,7 @@ struct nfattr
 #define NFA_PAYLOAD(nfa) ((int)((nfa)->nfa_len) - NFA_LENGTH(0))
 #define NFA_NEST(skb, type) \
 ({	struct nfattr *__start =3D (struct nfattr *) (skb)->tail; \
-	NFA_PUT(skb, type, 0, NULL); \
+	NFA_PUT(skb, (NFNL_NFA_NEST | type), 0, NULL); \
 	__start;  })
 #define NFA_NEST_END(skb, start) \
 ({      (start)->nfa_len =3D ((skb)->tail - (unsigned char *) (start)); \
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -133,7 +133,7 @@ int nfattr_parse(struct nfattr *tb[], in
 	memset(tb, 0, sizeof(struct nfattr *) * maxattr);
=20
 	while (NFA_OK(nfa, len)) {
-		unsigned flavor =3D nfa->nfa_type;
+		unsigned flavor =3D NFA_TYPE(nfa);
 		if (flavor && flavor <=3D maxattr)
 			tb[flavor-1] =3D nfa;
 		nfa =3D NFA_NEXT(nfa, len);
@@ -177,7 +177,7 @@ nfnetlink_check_attributes(struct nfnetl
 		int attrlen =3D nlh->nlmsg_len - NLMSG_ALIGN(min_len);
=20
 		while (NFA_OK(attr, attrlen)) {
-			unsigned flavor =3D attr->nfa_type;
+			unsigned flavor =3D NFA_TYPE(attr);
 			if (flavor) {
 				if (flavor > attr_count)
 					return -EINVAL;
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--+nBD6E3TurpgldQp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDSZZnXaXGVTD0i/8RAvsBAJ9yE2fwH9dR07YQZPejWWwhzhxHTwCglr7M
pUP6N/lQVjG4TJtPhWsCMOM=
=4iRS
-----END PGP SIGNATURE-----

--+nBD6E3TurpgldQp--
