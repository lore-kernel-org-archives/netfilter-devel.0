From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 4/4] libnftnl: examples: Modify the example to allow add TLV objects as user data.
Date: Sun,  3 Jan 2016 20:38:20 +0100
Message-ID: <1451849900-18077-4-git-send-email-carlosfg@riseup.net>
References: <1451849900-18077-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:44961 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbcACTij (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Jan 2016 14:38:39 -0500
In-Reply-To: <1451849900-18077-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Example usage:
	> nft add table mytable
	> exmample/nft-set-add ip mytable myset "5:my data 0" "5:my data 1"
	> example/nft-set-get ip json | jq #jq: https://stedolan.github.io/jq/
	{
	  "set": {
	    "name": "myset",
	    "table": "mytable",
	    "flags": 2,
	    "family": "ip",
	    "key_type": 0,
	    "key_len": 2,
	    "userdata_len": 48,
	    "userdata": [
	      {
		"type": 5,
		"len": 9,
		"val": "my data 0"
	      },
	      {
		"type": 5,
		"len": 9,
		"val": "my data 1"
	      }
	    ]
	  }
	}

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 examples/nft-set-add.c | 53 ++++++++++++++++++++++++++++++++++++++++++=
++++----
 1 file changed, 49 insertions(+), 4 deletions(-)

diff --git a/examples/nft-set-add.c b/examples/nft-set-add.c
index e040aca..42ff3c8 100644
--- a/examples/nft-set-add.c
+++ b/examples/nft-set-add.c
@@ -28,8 +28,14 @@
 #include <libmnl/libmnl.h>
 #include <libnftnl/set.h>
=20
+#define ATTRBUF_SIZE 256
+
+static bool parse_user_data(char *argv[], int argc,
+			    struct nftnl_attrbuf *attrbuf);
+
 static struct nftnl_set *setup_set(uint8_t family, const char *table,
-				 const char *name)
+				 const char *name, const char *udata,
+				 unsigned int udlen)
 {
 	struct nftnl_set *s =3D NULL;
=20
@@ -44,6 +50,8 @@ static struct nftnl_set *setup_set(uint8_t family, co=
nst char *table,
 	nftnl_set_set_u32(s, NFTNL_SET_FAMILY, family);
 	nftnl_set_set_u32(s, NFTNL_SET_KEY_LEN, 2);
 	nftnl_set_set_u32(s, NFTNL_SET_ID, 1);
+	if (udata !=3D NULL)
+		nftnl_set_set_data(s, NFTNL_SET_USERDATA, udata, udlen);
 	nftnl_set_set_u32(s, NFTNL_SET_FLAGS, NFT_SET_CONSTANT);
=20
 	return s;
@@ -71,13 +79,17 @@ int main(int argc, char *argv[])
 	struct nftnl_set *s;
 	struct nlmsghdr *nlh;
 	struct mnl_nlmsg_batch *batch;
+	struct nftnl_attrbuf *attrbuf =3D NULL;
 	uint8_t family;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	uint32_t seq =3D time(NULL);
 	int ret;
=20
-	if (argc !=3D 4) {
-		fprintf(stderr, "Usage: %s <family> <table> <setname>\n", argv[0]);
+	if (argc < 4) {
+		fprintf(stderr,
+			"Usage: %s <family> <table> <setname> [<type:user_data>[ <type:user=
_data>...]]\n",
+			argv[0]
+		);
 		exit(EXIT_FAILURE);
 	}
=20
@@ -94,7 +106,21 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
=20
-	s =3D setup_set(family, argv[2], argv[3]);
+	if (argc >=3D 5) {
+		attrbuf =3D nftnl_attrbuf_alloc(ATTRBUF_SIZE);
+		if (!parse_user_data(argv, argc, attrbuf)) {
+			fprintf(stderr, "Error parsing user data\n");
+			free(attrbuf);
+			return EXIT_FAILURE;
+		}
+
+		s =3D setup_set(family, argv[2], argv[3],
+			      (char *)nftnl_attrbuf_data(attrbuf),
+			      nftnl_attrbuf_len(attrbuf)
+			     );
+	} else {
+		s =3D setup_set(family, argv[2], argv[3], NULL, 0);
+	}
=20
 	nl =3D mnl_socket_open(NETLINK_NETFILTER);
 	if (nl =3D=3D NULL) {
@@ -147,6 +173,25 @@ int main(int argc, char *argv[])
 	}
=20
 	mnl_socket_close(nl);
+	if (attrbuf)
+		free(attrbuf);
=20
 	return EXIT_SUCCESS;
 }
+
+static bool parse_user_data(char *argv[], int argc,
+			    struct nftnl_attrbuf *attrbuf)
+{
+	int i;
+	char *type, *value;
+
+	for (i =3D 4; i < argc; i++) {
+		type =3D strchr(argv[i], ':') - 1;
+		value =3D type + 2;
+		if (!nftnl_attr_put_check(attrbuf, ATTRBUF_SIZE, atoi(type),
+					  strlen(value), value))
+			return false;
+	}
+
+	return true;
+}
--=20
2.6.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
