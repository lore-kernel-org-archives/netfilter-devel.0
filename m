Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B476A13D897
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 22:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728772056; cv=none; b=RaGCjwFy7kjx49WYrGO6El7disDWIBJpF+L7v5Fc2pJ8ybDds7qnBuxCITegb1mDGWDHqQF8hfpovhooB/tBH6c879dOVjPFylmIFf8chtjBL/p8443WBalriM+jvsGYVJq0YO7Vm1RGRVuOD1arIsbpiOhLOkL+H1xz/ZO/03I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728772056; c=relaxed/simple;
	bh=LOD+R+MhNzVap5yzwaqhkJsBB5so7opBYXcXRFjQOks=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JWH4v3UgajO1QfuYW8t+hDlYSOymfZwxzEQ37EtAaGS8eL8aYRPihS0j3eIO/kTezv3FR5tUawPewUm4MRZd8Vr73L715qurWCufCq+EiitDij3tVY/KOTuFny5HtsEjEakt69t0DNFQEKM3vCx3JXmKxR0bpWLiMa4bt161P3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: petrm@nvidia.com,
	danieller@nvidia.com,
	phil@nwl.cc,
	mlxsw@nvidia.com,
	kuba@kernel.org
Subject: [PATCH libmnl] attr: expand mnl_attr_get_uint() documentation
Date: Sun, 13 Oct 2024 00:27:25 +0200
Message-Id: <20241012222725.55023-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This function is modelled after rta_getattr_uint() in libnetlink to fetch the
netlink attribute payload of NLA_UINT, although it was extended to make it
universal for 2^3..2^6 byte integers.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/attr.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/src/attr.c b/src/attr.c
index 399318eebaa8..afabe5fbc8d9 100644
--- a/src/attr.c
+++ b/src/attr.c
@@ -393,7 +393,24 @@ EXPORT_SYMBOL uint64_t mnl_attr_get_u64(const struct nlattr *attr)
  * mnl_attr_get_uint - returns 64-bit unsigned integer attribute.
  * \param attr pointer to netlink attribute
  *
- * This function returns the 64-bit value of the attribute payload.
+ * This helper function reads the variable-length netlink attribute NLA_UINT
+ * that provides a 32-bit or 64-bit integer payload. Its use is recommended only
+ * in these cases.
+ *
+ * Recommended validation for NLA_UINT is:
+ *
+ * \verbatim
+	if (!mnl_attr_validate(attr, NLA_U32) &&
+	    !mnl_attr_validate(attr, NLA_U64)) {
+		perror("mnl_attr_validate");
+		return MNL_CB_ERROR;
+	}
+\endverbatim
+ *
+ * \returns the 64-bit value of the attribute payload. On error, it returns
+ * UINT64_MAX if the length of the netlink attribute is not 2^3..2^6 bytes.
+ * Therefore, there is no way to distinguish between UINT64_MAX and an error.
+ * Also, errno is never set.
  */
 EXPORT_SYMBOL uint64_t mnl_attr_get_uint(const struct nlattr *attr)
 {
-- 
2.30.2

