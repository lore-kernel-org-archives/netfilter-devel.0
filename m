From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnftnl PATCH 2/3] example/nft-rule-insert: fixed and merged this
 example with nft-rule-add
Date: Sat, 08 Mar 2014 15:00:45 +0100
Message-ID: <20140308140045.13220.19401.stgit@Ph0enix>
References: <20140308140039.13220.89013.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:46627 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaCHOA7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Mar 2014 09:00:59 -0500
Received: by mail-bk0-f52.google.com with SMTP id my13so1054814bkb.11
        for <netfilter-devel@vger.kernel.org>; Sat, 08 Mar 2014 06:00:58 -0800 (PST)
Received: from [127.0.1.1] ([2001:bf0:c001:30:3d1f:93c2:7e21:8d5c])
        by mx.google.com with ESMTPSA id xj2sm5719351bkb.15.2014.03.08.06.00.57
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Mar 2014 06:00:57 -0800 (PST)
In-Reply-To: <20140308140039.13220.89013.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <anayuso@sysmocom.de>

Merged the example for inserting rules and fixed for using
the correct header.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Signed-off-by: Alvaro Neira Ayuso <anayuso@sysmocom.de>
---
 examples/nft-rule-add.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/examples/nft-rule-add.c b/examples/nft-rule-add.c
index 21b3bf8..7407a78 100644
--- a/examples/nft-rule-add.c
+++ b/examples/nft-rule-add.c
@@ -80,11 +80,12 @@ static void add_counter(struct nft_rule *r)
 }
=20
 static struct nft_rule *setup_rule(uint8_t family, const char *table,
-				   const char *chain)
+				   const char *chain, const char *handle)
 {
 	struct nft_rule *r =3D NULL;
 	uint8_t proto;
 	uint16_t dport;
+	uint64_t hand;
=20
 	r =3D nft_rule_alloc();
 	if (r =3D=3D NULL) {
@@ -96,6 +97,12 @@ static struct nft_rule *setup_rule(uint8_t family, c=
onst char *table,
 	nft_rule_attr_set(r, NFT_RULE_ATTR_CHAIN, chain);
 	nft_rule_attr_set_u32(r, NFT_RULE_ATTR_FAMILY, family);
=20
+	if (handle !=3D NULL) {
+		printf("entra\n");
+		hand =3D atoi(handle);
+		nft_rule_attr_set(r, NFT_RULE_ATTR_POSITION, &hand);
+	}
+
 	proto =3D IPPROTO_TCP;
 	add_payload(r, NFT_PAYLOAD_NETWORK_HEADER, NFT_REG_1,
 		    offsetof(struct iphdr, protocol), sizeof(uint8_t));
@@ -138,7 +145,7 @@ int main(int argc, char *argv[])
 	uint32_t seq =3D time(NULL);
 	int ret;
=20
-	if (argc !=3D 4) {
+	if (argc < 4 || argc > 5) {
 		fprintf(stderr, "Usage: %s <family> <table> <chain>\n", argv[0]);
 		exit(EXIT_FAILURE);
 	}
@@ -152,7 +159,10 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
=20
-	r =3D setup_rule(family, argv[2], argv[3]);
+	if (argc !=3D 5)
+		r =3D setup_rule(family, argv[2], argv[3], NULL);
+	else
+		r =3D setup_rule(family, argv[2], argv[3], argv[4]);
=20
 	nl =3D mnl_socket_open(NETLINK_NETFILTER);
 	if (nl =3D=3D NULL) {

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
