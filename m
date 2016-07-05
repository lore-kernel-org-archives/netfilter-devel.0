From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 1/2 libnfntl] Fix nftnl_*_set_str
Date: Tue,  5 Jul 2016 19:15:16 +0200
Message-ID: <1467738917-17597-1-git-send-email-carlosfg@riseup.net>
References: <20160705123125.GA27152@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:58726 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755383AbcGERPc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jul 2016 13:15:32 -0400
In-Reply-To: <20160705123125.GA27152@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These lengths must be one character longer to take account the null
character

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 src/chain.c    | 2 +-
 src/rule.c     | 2 +-
 src/set.c      | 2 +-
 src/set_elem.c | 2 +-
 src/table.c    | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index bfffbe0..cab64b5 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -260,7 +260,7 @@ EXPORT_SYMBOL_ALIAS(nftnl_chain_set_u8, nft_chain_a=
ttr_set_u8);
=20
 int nftnl_chain_set_str(struct nftnl_chain *c, uint16_t attr, const ch=
ar *str)
 {
-	return nftnl_chain_set_data(c, attr, str, strlen(str));
+	return nftnl_chain_set_data(c, attr, str, strlen(str) + 1);
 }
 EXPORT_SYMBOL_ALIAS(nftnl_chain_set_str, nft_chain_attr_set_str);
=20
diff --git a/src/rule.c b/src/rule.c
index c87fea7..2b23c8e 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -198,7 +198,7 @@ EXPORT_SYMBOL_ALIAS(nftnl_rule_set_u64, nft_rule_at=
tr_set_u64);
=20
 int nftnl_rule_set_str(struct nftnl_rule *r, uint16_t attr, const char=
 *str)
 {
-	return nftnl_rule_set_data(r, attr, str, strlen(str));
+	return nftnl_rule_set_data(r, attr, str, strlen(str) + 1);
 }
 EXPORT_SYMBOL_ALIAS(nftnl_rule_set_str, nft_rule_attr_set_str);
=20
diff --git a/src/set.c b/src/set.c
index 9315bf0..e48ff78 100644
--- a/src/set.c
+++ b/src/set.c
@@ -203,7 +203,7 @@ EXPORT_SYMBOL_ALIAS(nftnl_set_set_u64, nft_set_attr=
_set_u64);
=20
 int nftnl_set_set_str(struct nftnl_set *s, uint16_t attr, const char *=
str)
 {
-	return nftnl_set_set(s, attr, str);
+	return nftnl_set_set_data(s, attr, str, strlen(str) + 1);
 }
 EXPORT_SYMBOL_ALIAS(nftnl_set_set_str, nft_set_attr_set_str);
=20
diff --git a/src/set_elem.c b/src/set_elem.c
index 00b7327..40b5bfe 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -149,7 +149,7 @@ EXPORT_SYMBOL_ALIAS(nftnl_set_elem_set_u64, nft_set=
_elem_attr_set_u64);
=20
 int nftnl_set_elem_set_str(struct nftnl_set_elem *s, uint16_t attr, co=
nst char *str)
 {
-	return nftnl_set_elem_set(s, attr, str, strlen(str));
+	return nftnl_set_elem_set(s, attr, str, strlen(str) + 1);
 }
 EXPORT_SYMBOL_ALIAS(nftnl_set_elem_set_str, nft_set_elem_attr_set_str)=
;
=20
diff --git a/src/table.c b/src/table.c
index 32d119f..966b923 100644
--- a/src/table.c
+++ b/src/table.c
@@ -131,7 +131,7 @@ EXPORT_SYMBOL_ALIAS(nftnl_table_set_u8, nft_table_a=
ttr_set_u8);
=20
 int nftnl_table_set_str(struct nftnl_table *t, uint16_t attr, const ch=
ar *str)
 {
-	return nftnl_table_set_data(t, attr, str, 0);
+	return nftnl_table_set_data(t, attr, str, strlen(str) + 1);
 }
 EXPORT_SYMBOL_ALIAS(nftnl_table_set_str, nft_table_attr_set_str);
=20
--=20
2.5.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
