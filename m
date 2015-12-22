From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 3/3,libnftnl] examples: Modify the example 'nft-set-add' to
Date: Tue, 22 Dec 2015 19:00:30 +0100
Message-ID: <1450807230-18208-3-git-send-email-carlosfg@riseup.net>
References: <1450807230-18208-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:51521 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932863AbbLVSAm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2015 13:00:42 -0500
In-Reply-To: <1450807230-18208-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It lets you to add an string:
	> nft add table mytable
	> exmample/nft-set-add ip mytable myset "hello world!"
	> example/nft-set-get ip json
	{"set":{"name":"myset","table":"mytable","flags":2,"family":"ip","key_=
ty
	pe":0,"key_len":2,"userdata_len":12,"userdata":"hello world!"}}

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 examples/nft-set-add.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/examples/nft-set-add.c b/examples/nft-set-add.c
index e040aca..42d99ce 100644
--- a/examples/nft-set-add.c
+++ b/examples/nft-set-add.c
@@ -29,7 +29,8 @@
 #include <libnftnl/set.h>
=20
 static struct nftnl_set *setup_set(uint8_t family, const char *table,
-				 const char *name)
+				 const char *name, const char *udata,
+				 unsigned int udlen)
 {
 	struct nftnl_set *s =3D NULL;
=20
@@ -44,6 +45,8 @@ static struct nftnl_set *setup_set(uint8_t family, co=
nst char *table,
 	nftnl_set_set_u32(s, NFTNL_SET_FAMILY, family);
 	nftnl_set_set_u32(s, NFTNL_SET_KEY_LEN, 2);
 	nftnl_set_set_u32(s, NFTNL_SET_ID, 1);
+	if (udata !=3D NULL)
+		nftnl_set_set_data(s, NFTNL_SET_USERDATA, udata, udlen);
 	nftnl_set_set_u32(s, NFTNL_SET_FLAGS, NFT_SET_CONSTANT);
=20
 	return s;
@@ -72,12 +75,15 @@ int main(int argc, char *argv[])
 	struct nlmsghdr *nlh;
 	struct mnl_nlmsg_batch *batch;
 	uint8_t family;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
+	char buf[2*MNL_SOCKET_BUFFER_SIZE];
 	uint32_t seq =3D time(NULL);
 	int ret;
=20
-	if (argc !=3D 4) {
-		fprintf(stderr, "Usage: %s <family> <table> <setname>\n", argv[0]);
+	if (argc < 4 || argc > 5) {
+		fprintf(stderr,
+			"Usage: %s <family> <table> <setname> [<user_data>]\n",
+			argv[0]
+		);
 		exit(EXIT_FAILURE);
 	}
=20
@@ -94,7 +100,10 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
=20
-	s =3D setup_set(family, argv[2], argv[3]);
+	if (argc =3D=3D 5)
+		s =3D setup_set(family, argv[2], argv[3], argv[4], strlen(argv[4]));
+	else
+		s =3D setup_set(family, argv[2], argv[3], NULL, 0);
=20
 	nl =3D mnl_socket_open(NETLINK_NETFILTER);
 	if (nl =3D=3D NULL) {
@@ -107,7 +116,7 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
=20
-	batch =3D mnl_nlmsg_batch_start(buf, sizeof(buf));
+	batch =3D mnl_nlmsg_batch_start(buf, sizeof(buf)/2);
=20
 	nftnl_mnl_batch_put(mnl_nlmsg_batch_current(batch),
 			  NFNL_MSG_BATCH_BEGIN, seq++);
--=20
2.6.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
