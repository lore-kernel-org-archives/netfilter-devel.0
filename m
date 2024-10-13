Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92587148304
	for <netfilter-devel@vger.kernel.org>; Sun, 13 Oct 2024 19:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728848607; cv=none; b=nOxPrFnR2Kl0/wZxyZWdOPc5F+uR2W7HpaUerVjVjFyqHoH4WeDlVwNdmP7gei74od7gHfkp691X8btcabBjolqQE/2EAA1tYw4otwxj1iHrJ5KukShjfI+ERKvb4/KrUGvgU69PaJTDEhkpc4tncBPJ0LdtMb71onRolhuLO5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728848607; c=relaxed/simple;
	bh=NfGtOlGLYqOwlBb7ERQ150mkmdFIkp6WVPcM433abvY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QGvYHJWRTa3Fjw8pJKA9xtigA00Q8gGnMVeSSLXQVQ30cIGzQUo9DZQlQvKKNsaQR6J8KSfTHm0jGxtEH+3KHTj2DU5UBXviM5XjyFqNLyscadelgBNl+3F2clJ4FZBr8IHfqKSvRcXxpxXoh5HufaMALUG8FvnbU3b3juAOwyA=
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
Subject: [PATCH libmnl,v2] attr: expand mnl_attr_get_uint() documentation
Date: Sun, 13 Oct 2024 21:43:19 +0200
Message-Id: <20241013194319.3703-1-pablo@netfilter.org>
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
universal for 8-bit, 16-bit, 32-bit and 64-bit integers.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: fix reference to bytes instead of bits per Phil Sutter.

 src/attr.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/src/attr.c b/src/attr.c
index 399318eebaa8..20e99b195ab7 100644
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
+ * UINT64_MAX if the length of the netlink attribute is not an 8-bit, 16-bit,
+ * 32-bit and 64-bit integer. Therefore, there is no way to distinguish between
+ * UINT64_MAX and an error. Also, errno is never set.
  */
 EXPORT_SYMBOL uint64_t mnl_attr_get_uint(const struct nlattr *attr)
 {
-- 
2.30.2

