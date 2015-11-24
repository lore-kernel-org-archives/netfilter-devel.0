From: Linmujia <linmujia@huawei.com>
Subject: [nft]: fix some bugs of return value
Date: Tue, 24 Nov 2015 09:00:21 +0000
Message-ID: <0A900C78B9F2324AB7F4F7A51D1A2F8577977E97@szxema505-mbs.china.huawei.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_0A900C78B9F2324AB7F4F7A51D1A2F8577977E97szxema505mbschi_"
Cc: "pablo@netfilter.org" <pablo@netfilter.org>
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:57270 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbbKXJEv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 04:04:51 -0500
Content-Language: zh-CN
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--_002_0A900C78B9F2324AB7F4F7A51D1A2F8577977E97szxema505mbschi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


linmujia - Nov. 24, 2015, 04:03 p.m.

Signed-off-by: linmujia <linmujia@huawei.com>
---
hello ,i reviewed nftables code and found some bugs of return value.

Thanks!



Patch

diff --git a/src/netlink.c b/src/netlink.c
index 974afb1..c555621 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -307,6 +307,8 @@ static void netlink_gen_verdict(const struct expr *expr=
,
 		strncpy(data->chain, expr->chain, NFT_CHAIN_MAXNAMELEN);
 		data->chain[NFT_CHAIN_MAXNAMELEN-1] =3D '\0';
 		break;
+	default:
+		BUG("invalid verdict value %u\n", expr->verdict);
 	}
 }
=20
@@ -467,7 +469,7 @@ static int list_rule_cb(struct nftnl_rule *nlr, void *a=
rg)
 	if (h->family !=3D family ||
 	    strcmp(table, h->table) !=3D 0 ||
 	    (h->chain && strcmp(chain, h->chain) !=3D 0))
-		return 0;
+		return -1;
=20
 	netlink_dump_rule(nlr);
 	rule =3D netlink_delinearize_rule(ctx, nlr);
diff --git a/src/rule.c b/src/rule.c
index 5d3cd84..9d6d945 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -930,7 +930,7 @@ static int do_command_add(struct netlink_ctx *ctx, stru=
ct cmd *cmd, bool excl)
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
-	return 0;
+	return -1;
 }
=20
 static int do_command_replace(struct netlink_ctx *ctx, struct cmd *cmd)
@@ -942,7 +942,7 @@ static int do_command_replace(struct netlink_ctx *ctx, =
struct cmd *cmd)
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
-	return 0;
+	return -1;
 }
=20
 static int do_command_insert(struct netlink_ctx *ctx, struct cmd *cmd)
@@ -954,7 +954,7 @@ static int do_command_insert(struct netlink_ctx *ctx, s=
truct cmd *cmd)
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
-	return 0;
+	return -1;
 }
=20
 static int do_command_delete(struct netlink_ctx *ctx, struct cmd *cmd)
@@ -974,6 +974,7 @@ static int do_command_delete(struct netlink_ctx *ctx, s=
truct cmd *cmd)
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
+    return -1;
 }
=20
 static int do_command_export(struct netlink_ctx *ctx, struct cmd *cmd)
@@ -1258,6 +1259,7 @@ int do_command(struct netlink_ctx *ctx, struct cmd *c=
md)
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
+	return -1;
 }
=20
 static int payload_match_stmt_cmp(const void *p1, const void *p2)



--_002_0A900C78B9F2324AB7F4F7A51D1A2F8577977E97szxema505mbschi_
Content-Type: application/octet-stream; name="p001.patch"
Content-Description: p001.patch
Content-Disposition: attachment; filename="p001.patch"; size=2059;
	creation-date="Tue, 24 Nov 2015 07:29:10 GMT";
	modification-date="Tue, 24 Nov 2015 07:29:10 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL3NyYy9uZXRsaW5rLmMgYi9zcmMvbmV0bGluay5jCmluZGV4IDk3NGFmYjEu
LmM1NTU2MjEgMTAwNjQ0Ci0tLSBhL3NyYy9uZXRsaW5rLmMKKysrIGIvc3JjL25ldGxpbmsuYwpA
QCAtMzA3LDYgKzMwNyw4IEBAIHN0YXRpYyB2b2lkIG5ldGxpbmtfZ2VuX3ZlcmRpY3QoY29uc3Qg
c3RydWN0IGV4cHIgKmV4cHIsCiAJCXN0cm5jcHkoZGF0YS0+Y2hhaW4sIGV4cHItPmNoYWluLCBO
RlRfQ0hBSU5fTUFYTkFNRUxFTik7CiAJCWRhdGEtPmNoYWluW05GVF9DSEFJTl9NQVhOQU1FTEVO
LTFdID0gJ1wwJzsKIAkJYnJlYWs7CisJZGVmYXVsdDoKKwkJQlVHKCJpbnZhbGlkIHZlcmRpY3Qg
dmFsdWUgJXVcbiIsIGV4cHItPnZlcmRpY3QpOwogCX0KIH0KIApAQCAtNDY3LDcgKzQ2OSw3IEBA
IHN0YXRpYyBpbnQgbGlzdF9ydWxlX2NiKHN0cnVjdCBuZnRubF9ydWxlICpubHIsIHZvaWQgKmFy
ZykKIAlpZiAoaC0+ZmFtaWx5ICE9IGZhbWlseSB8fAogCSAgICBzdHJjbXAodGFibGUsIGgtPnRh
YmxlKSAhPSAwIHx8CiAJICAgIChoLT5jaGFpbiAmJiBzdHJjbXAoY2hhaW4sIGgtPmNoYWluKSAh
PSAwKSkKLQkJcmV0dXJuIDA7CisJCXJldHVybiAtMTsKIAogCW5ldGxpbmtfZHVtcF9ydWxlKG5s
cik7CiAJcnVsZSA9IG5ldGxpbmtfZGVsaW5lYXJpemVfcnVsZShjdHgsIG5scik7CmRpZmYgLS1n
aXQgYS9zcmMvcnVsZS5jIGIvc3JjL3J1bGUuYwppbmRleCA1ZDNjZDg0Li45ZDZkOTQ1IDEwMDY0
NAotLS0gYS9zcmMvcnVsZS5jCisrKyBiL3NyYy9ydWxlLmMKQEAgLTkzMCw3ICs5MzAsNyBAQCBz
dGF0aWMgaW50IGRvX2NvbW1hbmRfYWRkKHN0cnVjdCBuZXRsaW5rX2N0eCAqY3R4LCBzdHJ1Y3Qg
Y21kICpjbWQsIGJvb2wgZXhjbCkKIAlkZWZhdWx0OgogCQlCVUcoImludmFsaWQgY29tbWFuZCBv
YmplY3QgdHlwZSAldVxuIiwgY21kLT5vYmopOwogCX0KLQlyZXR1cm4gMDsKKwlyZXR1cm4gLTE7
CiB9CiAKIHN0YXRpYyBpbnQgZG9fY29tbWFuZF9yZXBsYWNlKHN0cnVjdCBuZXRsaW5rX2N0eCAq
Y3R4LCBzdHJ1Y3QgY21kICpjbWQpCkBAIC05NDIsNyArOTQyLDcgQEAgc3RhdGljIGludCBkb19j
b21tYW5kX3JlcGxhY2Uoc3RydWN0IG5ldGxpbmtfY3R4ICpjdHgsIHN0cnVjdCBjbWQgKmNtZCkK
IAlkZWZhdWx0OgogCQlCVUcoImludmFsaWQgY29tbWFuZCBvYmplY3QgdHlwZSAldVxuIiwgY21k
LT5vYmopOwogCX0KLQlyZXR1cm4gMDsKKwlyZXR1cm4gLTE7CiB9CiAKIHN0YXRpYyBpbnQgZG9f
Y29tbWFuZF9pbnNlcnQoc3RydWN0IG5ldGxpbmtfY3R4ICpjdHgsIHN0cnVjdCBjbWQgKmNtZCkK
QEAgLTk1NCw3ICs5NTQsNyBAQCBzdGF0aWMgaW50IGRvX2NvbW1hbmRfaW5zZXJ0KHN0cnVjdCBu
ZXRsaW5rX2N0eCAqY3R4LCBzdHJ1Y3QgY21kICpjbWQpCiAJZGVmYXVsdDoKIAkJQlVHKCJpbnZh
bGlkIGNvbW1hbmQgb2JqZWN0IHR5cGUgJXVcbiIsIGNtZC0+b2JqKTsKIAl9Ci0JcmV0dXJuIDA7
CisJcmV0dXJuIC0xOwogfQogCiBzdGF0aWMgaW50IGRvX2NvbW1hbmRfZGVsZXRlKHN0cnVjdCBu
ZXRsaW5rX2N0eCAqY3R4LCBzdHJ1Y3QgY21kICpjbWQpCkBAIC05NzQsNiArOTc0LDcgQEAgc3Rh
dGljIGludCBkb19jb21tYW5kX2RlbGV0ZShzdHJ1Y3QgbmV0bGlua19jdHggKmN0eCwgc3RydWN0
IGNtZCAqY21kKQogCWRlZmF1bHQ6CiAJCUJVRygiaW52YWxpZCBjb21tYW5kIG9iamVjdCB0eXBl
ICV1XG4iLCBjbWQtPm9iaik7CiAJfQorICAgIHJldHVybiAtMTsKIH0KIAogc3RhdGljIGludCBk
b19jb21tYW5kX2V4cG9ydChzdHJ1Y3QgbmV0bGlua19jdHggKmN0eCwgc3RydWN0IGNtZCAqY21k
KQpAQCAtMTI1OCw2ICsxMjU5LDcgQEAgaW50IGRvX2NvbW1hbmQoc3RydWN0IG5ldGxpbmtfY3R4
ICpjdHgsIHN0cnVjdCBjbWQgKmNtZCkKIAlkZWZhdWx0OgogCQlCVUcoImludmFsaWQgY29tbWFu
ZCBvYmplY3QgdHlwZSAldVxuIiwgY21kLT5vYmopOwogCX0KKwlyZXR1cm4gLTE7CiB9CiAKIHN0
YXRpYyBpbnQgcGF5bG9hZF9tYXRjaF9zdG10X2NtcChjb25zdCB2b2lkICpwMSwgY29uc3Qgdm9p
ZCAqcDIpCg==

--_002_0A900C78B9F2324AB7F4F7A51D1A2F8577977E97szxema505mbschi_--

