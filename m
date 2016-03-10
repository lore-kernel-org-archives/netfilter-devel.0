From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 3/4 v4] libnftnl: test: Actualize test to check new nftnl_udata features of nftnl_rule
Date: Thu, 10 Mar 2016 22:37:15 +0100
Message-ID: <1457645836-10996-3-git-send-email-carlosfg@riseup.net>
References: <1457645836-10996-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:45091 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932180AbcCJVhf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Mar 2016 16:37:35 -0500
In-Reply-To: <1457645836-10996-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Modify nft-rule-test.c to check TLV attribute inclusion in nftnl_rule.
Add "*-rule-udata.[json|xml]" to check parsers.

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 tests/jsonfiles/71-rule-udata.json |  1 +
 tests/nft-rule-test.c              | 21 +++++++++++++++++++++
 tests/xmlfiles/82-rule-udata.xml   |  1 +
 3 files changed, 23 insertions(+)
 create mode 100644 tests/jsonfiles/71-rule-udata.json
 create mode 100644 tests/xmlfiles/82-rule-udata.xml

diff --git a/tests/jsonfiles/71-rule-udata.json b/tests/jsonfiles/71-ru=
le-udata.json
new file mode 100644
index 0000000..02d7903
--- /dev/null
+++ b/tests/jsonfiles/71-rule-udata.json
@@ -0,0 +1 @@
+{"nftables":[{"add":[{"rule":{"family":"ip","table":"filter","chain":"=
input","handle":71,"expr":[{"type":"counter","pkts":135,"bytes":21655}]=
,"userdata":[{"type":0,"length":12,"value":"68656C6C6F20776F726C6400"},=
{"type":1,"length":9,"value":"627920776F726C6400"}]}}]}]}
diff --git a/tests/nft-rule-test.c b/tests/nft-rule-test.c
index dff9634..eb10270 100644
--- a/tests/nft-rule-test.c
+++ b/tests/nft-rule-test.c
@@ -15,6 +15,7 @@
 #include <netinet/in.h>
 #include <linux/netfilter/nf_tables.h>
 #include <libnftnl/rule.h>
+#include <libnftnl/udata.h>
=20
 static int test_ok =3D 1;
=20
@@ -26,6 +27,9 @@ static void print_err(const char *msg)
=20
 static void cmp_nftnl_rule(struct nftnl_rule *a, struct nftnl_rule *b)
 {
+	const void *udata_a, *udata_b;
+	uint32_t len_a, len_b;
+
 	if (nftnl_rule_get_u32(a, NFTNL_RULE_FAMILY) !=3D
 	    nftnl_rule_get_u32(b, NFTNL_RULE_FAMILY))
 		print_err("Rule family mismatches");
@@ -47,6 +51,12 @@ static void cmp_nftnl_rule(struct nftnl_rule *a, str=
uct nftnl_rule *b)
 	if (nftnl_rule_get_u64(a, NFTNL_RULE_POSITION) !=3D
 	    nftnl_rule_get_u64(b, NFTNL_RULE_POSITION))
 		print_err("Rule compat_position mismatches");
+
+	udata_a =3D nftnl_rule_get_data(a, NFTNL_RULE_USERDATA, &len_a);
+	udata_b =3D nftnl_rule_get_data(b, NFTNL_RULE_USERDATA, &len_b);
+
+	if (len_a !=3D len_b || memcmp(udata_a, udata_b, len_a) !=3D 0)
+		print_err("Rule userdata mismatches");
 }
=20
 int main(int argc, char *argv[])
@@ -54,12 +64,20 @@ int main(int argc, char *argv[])
 	struct nftnl_rule *a, *b;
 	char buf[4096];
 	struct nlmsghdr *nlh;
+	struct nftnl_udata_buf *udata;
=20
 	a =3D nftnl_rule_alloc();
 	b =3D nftnl_rule_alloc();
 	if (a =3D=3D NULL || b =3D=3D NULL)
 		print_err("OOM");
=20
+	udata =3D nftnl_udata_alloc(NFT_USERDATA_MAXLEN);
+	if (!udata)
+		print_err("OOM");
+
+	if (!nftnl_udata_put_strz(udata, 0, "hello world"))
+		print_err("User data too big");
+
 	nftnl_rule_set_u32(a, NFTNL_RULE_FAMILY, AF_INET);
 	nftnl_rule_set_str(a, NFTNL_RULE_TABLE, "table");
 	nftnl_rule_set_str(a, NFTNL_RULE_CHAIN, "chain");
@@ -67,6 +85,9 @@ int main(int argc, char *argv[])
 	nftnl_rule_set_u32(a, NFTNL_RULE_COMPAT_PROTO, 0x12345678);
 	nftnl_rule_set_u32(a, NFTNL_RULE_COMPAT_FLAGS, 0x12345678);
 	nftnl_rule_set_u64(a, NFTNL_RULE_POSITION, 0x1234567812345678);
+	nftnl_rule_set_data(a, NFTNL_RULE_USERDATA,
+			    nftnl_udata_data(udata),
+			    nftnl_udata_len(udata));
=20
 	nlh =3D nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, =
1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
diff --git a/tests/xmlfiles/82-rule-udata.xml b/tests/xmlfiles/82-rule-=
udata.xml
new file mode 100644
index 0000000..b986926
--- /dev/null
+++ b/tests/xmlfiles/82-rule-udata.xml
@@ -0,0 +1 @@
+<nftables><add><rule><family>ip6</family><table>filter</table><chain>i=
nput</chain><handle>82</handle><expr type=3D"counter"><pkts>3</pkts><by=
tes>177</bytes></expr><userdata><attr><type>0</type><length>12</length>=
<value>68656C6C6F20776F726C6400</value></attr><attr><type>1</type><leng=
th>9</length><value>627920776F726C6400</value></attr></userdata></rule>=
</add></nftables>
--=20
2.7.2

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
