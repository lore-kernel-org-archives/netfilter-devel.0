Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E002020298D
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Oct 2025 15:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759852785; cv=none; b=S7jofi81ScZFmI8HDz1+FClLZbSj8drNYuFM5169T29Q035kQfu7VWY1Qy1CUHIKshMiT35P2dToMOFdnkYM47thE5djf+6kjGh1Zm0XflyaHEipKNexKftpUeMYMebMvYnCVFyLfMvVrz6V87v5xfl9Tf0L8Qz/U9r8IqLLSc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759852785; c=relaxed/simple;
	bh=+PFFdVTU4Kqc2UTspvca+n1hm+ChFzYGRaLDv42jPLw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nGYxJzT5ngX4iSQx/X1jZX44Z7tl0oqgPFPrLcNt79755g9a19LVOF/tjnnHar9/ebAbf9cZe8Bu/m3TB68ckRDQWOISBJqgkLV+pJHRCJUxdKeDfwx/YP+wkLqJx+1pBU+U1yqpm2OhHgyVFjvdPo3iGmBIxMHN9e3Zno8XmnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=lbIAP4Dz; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="lbIAP4Dz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=wGGb1ezi1b9eMf8u01dT563ysfJcWWlPrSr5P8hwQJM=; b=lbIAP4DzJKzdxsLrikYpealEen
	flW245BCYm1uX0wBSXbsG9yBKmhf2/2cGJdW2HkxPJyN+E1RFncMVAXgZ04FbJ+9JMnogKviucNHq
	shwA43Th9sc4eed4AU/TU8QkRXGC9wzoSGjvWjuewxv0z/rRKdRoiuXNP9JUam8Rr+N70pXxCvEmz
	sG/sLS2bTqyl/MEhl+VwmVlWSzs2uGxCLTkjWyR0bvOqfLB6aJEc86utK3GDWGBSjnHd2j3+vaE5S
	xc0GVDxjdj/xSVz4SAk0ez+aPk7qDsTlCHY82QxTg0Lh4i5T5uOG/fsadwgjg1Ch9tc5m0zJ6L7WK
	oirE3OYw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1v6A6G-000000004bp-2PG4;
	Tue, 07 Oct 2025 17:59:40 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH] utils: Drop asterisk from end of NFTA_DEVICE_PREFIX strings
Date: Tue,  7 Oct 2025 17:58:26 +0200
Message-ID: <20251007155935.1324-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The asterisk left in place becomes part of the prefix by accident and is thus
both included when matching interface names as well as dumped back to user
space.

Fixes: f30eae26d813e ("utils: Add helpers for interface name wildcards")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
This code is currently unused by nftables at least since it builds the
netlink message itself.
---
 src/utils.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/src/utils.c b/src/utils.c
index c4bbd4f7ed171..d73c5f6175802 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -164,9 +164,16 @@ static bool is_wildcard_str(const char *str)
 
 void nftnl_attr_put_ifname(struct nlmsghdr *nlh, const char *ifname)
 {
-	uint16_t attr = is_wildcard_str(ifname) ?
-			NFTA_DEVICE_PREFIX : NFTA_DEVICE_NAME;
+	uint16_t attr = NFTA_DEVICE_NAME;
+	char pfx[IFNAMSIZ];
 
+	if (is_wildcard_str(ifname)) {
+		snprintf(pfx, IFNAMSIZ, "%s", ifname);
+		pfx[strlen(pfx) - 1] = '\0';
+
+		attr = NFTA_DEVICE_PREFIX;
+		ifname = pfx;
+	}
 	mnl_attr_put_strz(nlh, attr, ifname);
 }
 
-- 
2.51.0

