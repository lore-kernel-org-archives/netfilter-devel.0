Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 999B95A4D4
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Mar 2024 12:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711023849; cv=none; b=f52Od9EdAoKuRi9B3exdS8SCgrRXC7YDBgLHm7x9k2C/0rsmTTgeDlBXenOJdH5Xx6TLa5rpJyNFrkmYaXw8peDqTe+qDd8cExYfYca5IWX/Q3pq6k+L65n96D5BbEfdVZ/sKe8tmc9XTZeR0nuxEjgyZyWxd8BXeXvjpFP6Ouo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711023849; c=relaxed/simple;
	bh=9Y+iDB2kpa11/N8tm74FqUL/5DZnx/fV2adFugr74CQ=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=hwuJ81u26T/f/L7uTUnkC49rgYJ1WewEWBxpEaImjgQPJ+YHtd97mXL1GhR4LWmswhFQV3HQn1fMLVVb8RsWlEFtq6v06aQqzHs6XQJIdoLd/Q/Hufg6ArdqwQF0owl5zCyFyrJ+kn8tL/VIVXUYuyjIcNw2ozZhhv/GSyGmUH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] datatype: leave DTYPE_F_PREFIX only for IP address datatype
Date: Thu, 21 Mar 2024 13:24:01 +0100
Message-Id: <20240321122401.310768-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

DTYPE_F_PREFIX flag provides a hint to the netlink delinearize path to
use prefix notation.

It seems use of prefix notation in meta mark causes confusion, users
expect to see prefix in the listing only in IP address datatypes.

Untoggle this flag so (more lengthy) binop output such as:

  meta mark & 0xffffff00 == 0xffffff00

is used instead.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1739
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/datatype.c      | 1 -
 src/meta.c          | 1 -
 src/rt.c            | 1 -
 tests/py/any/meta.t | 2 +-
 4 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index 3205b214197f..b368ea9125fc 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1015,7 +1015,6 @@ const struct datatype mark_type = {
 	.print		= mark_type_print,
 	.json		= mark_type_json,
 	.parse		= mark_type_parse,
-	.flags		= DTYPE_F_PREFIX,
 };
 
 static const struct symbol_table icmp_code_tbl = {
diff --git a/src/meta.c b/src/meta.c
index eca8dac72098..a17bacf07d0e 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -363,7 +363,6 @@ const struct datatype devgroup_type = {
 	.print		= devgroup_type_print,
 	.json		= devgroup_type_json,
 	.parse		= devgroup_type_parse,
-	.flags		= DTYPE_F_PREFIX,
 };
 
 const struct datatype ifname_type = {
diff --git a/src/rt.c b/src/rt.c
index d8f3352f4b4a..9320b8322456 100644
--- a/src/rt.c
+++ b/src/rt.c
@@ -61,7 +61,6 @@ const struct datatype realm_type = {
 	.basetype	= &integer_type,
 	.print		= realm_type_print,
 	.parse		= realm_type_parse,
-	.flags		= DTYPE_F_PREFIX,
 };
 
 const struct rt_template rt_templates[] = {
diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index 718c7ad96186..bd10c56dfe5f 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -56,7 +56,7 @@ meta mark and 0x03 == 0x01;ok;meta mark & 0x00000003 == 0x00000001
 meta mark and 0x03 != 0x01;ok;meta mark & 0x00000003 != 0x00000001
 meta mark 0x10;ok;meta mark 0x00000010
 meta mark != 0x10;ok;meta mark != 0x00000010
-meta mark 0xffffff00/24;ok
+meta mark 0xffffff00/24;ok;meta mark & 0xffffff00 == 0xffffff00
 
 meta mark or 0x03 == 0x01;ok;meta mark | 0x00000003 == 0x00000001
 meta mark or 0x03 != 0x01;ok;meta mark | 0x00000003 != 0x00000001
-- 
2.30.2

