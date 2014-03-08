From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnftnl PATCH 1/3] example: fix the example for deleting rules
Date: Sat, 08 Mar 2014 15:00:39 +0100
Message-ID: <20140308140039.13220.89013.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:50260 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaCHOAx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Mar 2014 09:00:53 -0500
Received: by mail-bk0-f47.google.com with SMTP id w10so1058576bkz.34
        for <netfilter-devel@vger.kernel.org>; Sat, 08 Mar 2014 06:00:51 -0800 (PST)
Received: from [127.0.1.1] ([2001:bf0:c001:30:3d1f:93c2:7e21:8d5c])
        by mx.google.com with ESMTPSA id xj2sm5719225bkb.15.2014.03.08.06.00.50
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Mar 2014 06:00:51 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

=46ixed the example for deleting rules. Before this patch,
the program tried to delete the rule without using
the correct header

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 examples/nft-rule-del.c |   43 +++++++++++++++++++++++++++++++++++++++=
----
 1 file changed, 39 insertions(+), 4 deletions(-)

diff --git a/examples/nft-rule-del.c b/examples/nft-rule-del.c
index 6f665b0..06a28c7 100644
--- a/examples/nft-rule-del.c
+++ b/examples/nft-rule-del.c
@@ -17,15 +17,33 @@
=20
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
+#include <linux/netfilter/nfnetlink.h>
=20
 #include <libmnl/libmnl.h>
 #include <libnftnl/rule.h>
=20
+static void nft_mnl_batch_put(char *buf, uint16_t type, uint32_t seq)
+{
+	struct nlmsghdr *nlh;
+	struct nfgenmsg *nfg;
+
+	nlh =3D mnl_nlmsg_put_header(buf);
+	nlh->nlmsg_type =3D type;
+	nlh->nlmsg_flags =3D NLM_F_REQUEST;
+	nlh->nlmsg_seq =3D seq;
+
+	nfg =3D mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
+	nfg->nfgen_family =3D AF_INET;
+	nfg->version =3D NFNETLINK_V0;
+	nfg->res_id =3D NFNL_SUBSYS_NFTABLES;
+}
+
 int main(int argc, char *argv[])
 {
 	struct mnl_socket *nl;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
+	struct mnl_nlmsg_batch *batch;
 	uint32_t portid, seq;
 	struct nft_rule *r =3D NULL;
 	int ret, family;
@@ -56,8 +74,6 @@ int main(int argc, char *argv[])
 	}
=20
 	seq =3D time(NULL);
-	nlh =3D nft_rule_nlmsg_build_hdr(buf, NFT_MSG_DELRULE, family,
-					NLM_F_ACK, seq);
 	nft_rule_attr_set(r, NFT_RULE_ATTR_TABLE, argv[2]);
 	nft_rule_attr_set(r, NFT_RULE_ATTR_CHAIN, argv[3]);
=20
@@ -69,8 +85,24 @@ int main(int argc, char *argv[])
 	nft_rule_snprintf(tmp, sizeof(tmp), r, 0, 0);
 	printf("%s\n", tmp);
=20
+	batch =3D mnl_nlmsg_batch_start(buf, sizeof(buf));
+
+	nft_mnl_batch_put(mnl_nlmsg_batch_current(batch),
+			  NFNL_MSG_BATCH_BEGIN, seq++);
+	mnl_nlmsg_batch_next(batch);
+
+	nlh =3D nft_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				NFT_MSG_DELRULE,
+				family,
+				NLM_F_ACK, seq++);
+
 	nft_rule_nlmsg_build_payload(nlh, r);
 	nft_rule_free(r);
+	mnl_nlmsg_batch_next(batch);
+
+	nft_mnl_batch_put(mnl_nlmsg_batch_current(batch), NFNL_MSG_BATCH_END,
+	seq++);
+	mnl_nlmsg_batch_next(batch);
=20
 	nl =3D mnl_socket_open(NETLINK_NETFILTER);
 	if (nl =3D=3D NULL) {
@@ -84,14 +116,17 @@ int main(int argc, char *argv[])
 	}
 	portid =3D mnl_socket_get_portid(nl);
=20
-	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+	if (mnl_socket_sendto(nl, mnl_nlmsg_batch_head(batch),
+			      mnl_nlmsg_batch_size(batch)) < 0) {
 		perror("mnl_socket_send");
 		exit(EXIT_FAILURE);
 	}
=20
+	mnl_nlmsg_batch_stop(batch);
+
 	ret =3D mnl_socket_recvfrom(nl, buf, sizeof(buf));
 	while (ret > 0) {
-		ret =3D mnl_cb_run(buf, ret, seq, portid, NULL, NULL);
+		ret =3D mnl_cb_run(buf, ret, 0, portid, NULL, NULL);
 		if (ret <=3D 0)
 			break;
 		ret =3D mnl_socket_recvfrom(nl, buf, sizeof(buf));

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
