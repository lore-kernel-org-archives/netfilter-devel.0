From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 1/2] set: add Json Export Support
Date: Fri, 05 Jul 2013 14:41:28 +0200
Message-ID: <20130705124128.23285.30238.stgit@Ph0enix>
References: <20130705123837.23285.5489.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:44658 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab3GEMlb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jul 2013 08:41:31 -0400
Received: by mail-wi0-f171.google.com with SMTP id hj3so7181376wib.16
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Jul 2013 05:41:29 -0700 (PDT)
In-Reply-To: <20130705123837.23285.5489.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 examples/nft-set-elem-get.c |   15 ++++++++----
 examples/nft-set-get.c      |   15 ++++++++----
 include/libnftables/set.h   |    5 ++++
 src/set.c                   |   56 +++++++++++++++++++++++++++++++++++=
++++++--
 src/set_elem.c              |   49 +++++++++++++++++++++++++++++++++++=
+--
 5 files changed, 126 insertions(+), 14 deletions(-)

diff --git a/examples/nft-set-elem-get.c b/examples/nft-set-elem-get.c
index 34dfca2..353a752 100644
--- a/examples/nft-set-elem-get.c
+++ b/examples/nft-set-elem-get.c
@@ -23,6 +23,7 @@ static int set_cb(const struct nlmsghdr *nlh, void *d=
ata)
 {
 	struct nft_set *t;
 	char buf[4096];
+	uint32_t *type =3D data;
=20
 	t =3D nft_set_alloc();
 	if (t =3D=3D NULL) {
@@ -35,7 +36,7 @@ static int set_cb(const struct nlmsghdr *nlh, void *d=
ata)
 		goto err_free;
 	}
=20
-	nft_set_snprintf(buf, sizeof(buf), t, 0, 0);
+	nft_set_snprintf(buf, sizeof(buf), t, *type, 0);
 	printf("%s\n", buf);
=20
 err_free:
@@ -50,11 +51,12 @@ int main(int argc, char *argv[])
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 	uint32_t portid, seq, family;
+	uint32_t type =3D NFT_SET_O_DEFAULT;
 	struct nft_set *t =3D NULL;
 	int ret;
=20
-	if (argc !=3D 4) {
-		fprintf(stderr, "%s <family> <table> <set>\n", argv[0]);
+	if (argc < 4 || argc > 5) {
+		fprintf(stderr, "%s <family> <table> <set> [default|json]\n", argv[0=
]);
 		return EXIT_FAILURE;
 	}
 	t =3D nft_set_alloc();
@@ -67,13 +69,16 @@ int main(int argc, char *argv[])
 		family =3D AF_INET;
 	else if (strcmp(argv[1], "ip6") =3D=3D 0)
 		family =3D AF_INET6;
-	else if (strcmp(argv[2], "bridge") =3D=3D 0)
+	else if (strcmp(argv[1], "bridge") =3D=3D 0)
 		family =3D AF_BRIDGE;
 	else {
 		fprintf(stderr, "Unknown family: ip, ip6, bridge\n");
 		exit(EXIT_FAILURE);
 	}
=20
+	if (argc =3D=3D 5 && strcmp(argv[4], "json") =3D=3D 0 )
+		type =3D NFT_SET_O_JSON;
+
 	nlh =3D nft_set_nlmsg_build_hdr(buf, NFT_MSG_GETSETELEM, family,
 					NLM_F_DUMP|NLM_F_ACK, seq);
 	nft_set_attr_set(t, NFT_SET_ATTR_NAME, argv[3]);
@@ -100,7 +105,7 @@ int main(int argc, char *argv[])
=20
 	ret =3D mnl_socket_recvfrom(nl, buf, sizeof(buf));
 	while (ret > 0) {
-		ret =3D mnl_cb_run(buf, ret, seq, portid, set_cb, NULL);
+		ret =3D mnl_cb_run(buf, ret, seq, portid, set_cb, &type);
 		if (ret <=3D 0)
 			break;
 		ret =3D mnl_socket_recvfrom(nl, buf, sizeof(buf));
diff --git a/examples/nft-set-get.c b/examples/nft-set-get.c
index d4588ba..5ef654c 100644
--- a/examples/nft-set-get.c
+++ b/examples/nft-set-get.c
@@ -23,6 +23,7 @@ static int set_cb(const struct nlmsghdr *nlh, void *d=
ata)
 {
 	struct nft_set *t;
 	char buf[4096];
+	uint32_t *type =3D data;
=20
 	t =3D nft_set_alloc();
 	if (t =3D=3D NULL) {
@@ -35,7 +36,7 @@ static int set_cb(const struct nlmsghdr *nlh, void *d=
ata)
 		goto err_free;
 	}
=20
-	nft_set_snprintf(buf, sizeof(buf), t, 0, 0);
+	nft_set_snprintf(buf, sizeof(buf), t, *type, 0);
 	printf("%s\n", buf);
=20
 err_free:
@@ -50,11 +51,12 @@ int main(int argc, char *argv[])
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 	uint32_t portid, seq, family;
+	uint32_t type =3D NFT_SET_O_DEFAULT;
 	struct nft_set *t =3D NULL;
 	int ret;
=20
-	if (argc !=3D 3) {
-		fprintf(stderr, "%s <family> <table>\n", argv[0]);
+	if (argc < 3 || argc > 4) {
+		fprintf(stderr, "%s <family> <table> [default|json]\n", argv[0]);
 		return EXIT_FAILURE;
 	}
 	t =3D nft_set_alloc();
@@ -67,13 +69,16 @@ int main(int argc, char *argv[])
 		family =3D AF_INET;
 	else if (strcmp(argv[1], "ip6") =3D=3D 0)
 		family =3D AF_INET6;
-	else if (strcmp(argv[2], "bridge") =3D=3D 0)
+	else if (strcmp(argv[1], "bridge") =3D=3D 0)
 		family =3D AF_BRIDGE;
 	else {
 		fprintf(stderr, "Unknown family: ip, ip6, bridge\n");
 		exit(EXIT_FAILURE);
 	}
=20
+	if (argc =3D=3D 4 && strcmp(argv[3], "json") =3D=3D 0)
+		type =3D NFT_SET_O_JSON;
+
 	nlh =3D nft_set_nlmsg_build_hdr(buf, NFT_MSG_GETSET, family,
 					NLM_F_DUMP|NLM_F_ACK, seq);
 	nft_set_attr_set(t, NFT_SET_ATTR_TABLE, argv[2]);
@@ -99,7 +104,7 @@ int main(int argc, char *argv[])
=20
 	ret =3D mnl_socket_recvfrom(nl, buf, sizeof(buf));
 	while (ret > 0) {
-		ret =3D mnl_cb_run(buf, ret, seq, portid, set_cb, NULL);
+		ret =3D mnl_cb_run(buf, ret, seq, portid, set_cb, &type);
 		if (ret <=3D 0)
 			break;
 		ret =3D mnl_socket_recvfrom(nl, buf, sizeof(buf));
diff --git a/include/libnftables/set.h b/include/libnftables/set.h
index 63b30fc..2d41c8e 100644
--- a/include/libnftables/set.h
+++ b/include/libnftables/set.h
@@ -62,6 +62,11 @@ enum {
 	NFT_SET_ELEM_ATTR_DATA,
 };
=20
+enum {
+	NFT_SET_O_DEFAULT	=3D 0,
+	NFT_SET_O_JSON,
+};
+
 struct nft_set_elem;
=20
 struct nft_set_elem *nft_set_elem_alloc(void);
diff --git a/src/set.c b/src/set.c
index b8d431e..f60999c 100644
--- a/src/set.c
+++ b/src/set.c
@@ -316,8 +316,46 @@ int nft_set_nlmsg_parse(const struct nlmsghdr *nlh=
, struct nft_set *s)
 }
 EXPORT_SYMBOL(nft_set_nlmsg_parse);
=20
-int nft_set_snprintf(char *buf, size_t size, struct nft_set *s,
-		     uint32_t type, uint32_t flags)
+static int nft_set_snprintf_json(char *buf, size_t size, struct nft_se=
t *s,
+			   uint32_t type, uint32_t flags)
+{
+	int ret;
+	int len =3D size, offset =3D 0;
+	struct nft_set_elem *elem;
+
+	ret =3D snprintf(buf, size, "{ \"set\" : { \"name\" : \"%s\", \"table=
\" : \"%s\", \"flags\" : %u",
+			s->name, s->table, s->set_flags);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	/* Empty set? Skip printinf of elements */
+	if (list_empty(&s->element_list)){
+		ret =3D snprintf(buf+offset, size, "}}");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		return offset;
+	}
+
+	ret =3D snprintf(buf+offset, size, ", \"set_elem\" : [");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	list_for_each_entry(elem, &s->element_list, head) {
+		ret =3D snprintf(buf+offset, size, "{");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		ret =3D nft_set_elem_snprintf(buf+offset, size, elem, type, flags);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		ret =3D snprintf(buf+offset, size, "}, ");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	ret =3D snprintf(buf+offset-2, size, "]}}");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+
+static int nft_set_snprintf_default(char *buf, size_t size, struct nft=
_set *s,
+			      uint32_t type, uint32_t flags)
 {
 	int ret;
 	int len =3D size, offset =3D 0;
@@ -344,6 +382,20 @@ int nft_set_snprintf(char *buf, size_t size, struc=
t nft_set *s,
=20
 	return offset;
 }
+
+int nft_set_snprintf(char *buf, size_t size, struct nft_set *s,
+		      uint32_t type, uint32_t flags)
+{
+	switch(type) {
+	case NFT_SET_O_DEFAULT:
+		return nft_set_snprintf_default(buf, size, s, type, flags);
+	case NFT_SET_O_JSON:
+		return nft_set_snprintf_json(buf, size, s, type, flags);
+	default:
+		break;
+	}
+	return -1;
+}
 EXPORT_SYMBOL(nft_set_snprintf);
=20
 void nft_set_elem_add(struct nft_set *s, struct nft_set_elem *elem)
diff --git a/src/set_elem.c b/src/set_elem.c
index 0cbb9b7..288f843 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -384,8 +384,39 @@ int nft_set_elems_nlmsg_parse(const struct nlmsghd=
r *nlh, struct nft_set *s)
 }
 EXPORT_SYMBOL(nft_set_elems_nlmsg_parse);
=20
-int nft_set_elem_snprintf(char *buf, size_t size, struct nft_set_elem =
*e,
-			  uint32_t type, uint32_t flags)
+static int nft_set_elem_snprintf_json(char *buf, size_t size, struct n=
ft_set_elem *e)
+{
+	int ret, len =3D size, offset =3D 0, i;
+
+	ret =3D snprintf(buf, size, "\"flags\" : %u", e->set_elem_flags);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	if (e->key.len/sizeof(uint32_t) !=3D 0) {
+		ret =3D snprintf(buf+offset, len, ", \"key\" : \"0x");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		for (i=3D0; i<e->key.len/sizeof(uint32_t); i++) {
+			ret =3D snprintf(buf+offset, len, "%.8x", e->key.val[i]);
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		}
+		ret =3D snprintf(buf+offset, len, "\"");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (e->data.len/sizeof(uint32_t) !=3D 0) {
+		ret =3D snprintf(buf+offset, size, " ,\"data\" : \"0x");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		for (i=3D0; i<e->data.len/sizeof(uint32_t); i++) {
+			ret =3D snprintf(buf+offset, len, "%.8x", e->data.val[i]);
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		}
+		ret =3D snprintf(buf+offset, len, "\"");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return offset;
+}
+
+static int nft_set_elem_snprintf_default(char *buf, size_t size, struc=
t nft_set_elem *e)
 {
 	int ret, len =3D size, offset =3D 0, i;
=20
@@ -407,6 +438,20 @@ int nft_set_elem_snprintf(char *buf, size_t size, =
struct nft_set_elem *e,
=20
 	return offset;
 }
+
+int nft_set_elem_snprintf(char *buf, size_t size, struct nft_set_elem =
*e,
+			   uint32_t type, uint32_t flags)
+{
+	switch(type) {
+	case NFT_SET_O_DEFAULT:
+		return nft_set_elem_snprintf_default(buf, size, e);
+	case NFT_SET_O_JSON:
+		return nft_set_elem_snprintf_json(buf, size, e);
+	default:
+		break;
+	}
+	return -1;
+}
 EXPORT_SYMBOL(nft_set_elem_snprintf);
=20
 int nft_set_elem_foreach(struct nft_set *s,

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
