From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 2/2 libnftnl] tests: Check set user data
Date: Mon, 27 Jun 2016 19:05:23 +0200
Message-ID: <20160627170523.6560-2-carlosfg@riseup.net>
References: <20160627170523.6560-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:49984 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbcF0RFr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Jun 2016 13:05:47 -0400
In-Reply-To: <20160627170523.6560-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 tests/nft-set-test.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tests/nft-set-test.c b/tests/nft-set-test.c
index f6fbfb5..173c17f 100644
--- a/tests/nft-set-test.c
+++ b/tests/nft-set-test.c
@@ -47,6 +47,9 @@ static void cmp_nftnl_set(struct nftnl_set *a, struct=
 nftnl_set *b)
 	if (nftnl_set_get_u32(a, NFTNL_SET_DATA_LEN) !=3D
 	    nftnl_set_get_u32(b, NFTNL_SET_DATA_LEN))
 		print_err("Set data-len mismatches");
+	if (strcmp(nftnl_set_get_str(a, NFTNL_SET_USERDATA),
+		   nftnl_set_get_str(b, NFTNL_SET_USERDATA)) !=3D 0)
+		print_err("Set userdata mismatches");
 }
=20
 int main(int argc, char *argv[])
@@ -68,6 +71,7 @@ int main(int argc, char *argv[])
 	nftnl_set_set_u32(a, NFTNL_SET_DATA_TYPE, 0x12345678);
 	nftnl_set_set_u32(a, NFTNL_SET_DATA_LEN, 0x12345678);
 	nftnl_set_set_u32(a, NFTNL_SET_FAMILY, 0x12345678);
+	nftnl_set_set_str(a, NFTNL_SET_USERDATA, "testing user data");
=20
 	/* cmd extracted from include/linux/netfilter/nf_tables.h */
 	nlh =3D nftnl_set_nlmsg_build_hdr(buf, NFT_MSG_NEWSET, AF_INET, 0, 12=
34);
--=20
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
