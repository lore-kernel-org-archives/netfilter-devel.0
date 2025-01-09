Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2399321882B
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2025 13:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736428954; cv=none; b=Wn1HEJ4CNoxzECp+EOJ/YPZ+Y8Wfpx5f9osUues9QmpWj2aIdz5yNIHHSkFCub2nEAhWEUczkZTS0AyoSiqSP6igJTa4AAUqS+0NvSDOZUFR9wIHq4oQT1uHlXY3O686KdkCbath2WK2hCwJgZdxpOZJrW5W7iHJb8loPTf8IW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736428954; c=relaxed/simple;
	bh=mPCIQXzOlUHP40dRBSWANEjb6sPhk7gT13wbA95rG3I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D8QdpmAUGoCeLFcbTRWdvNZ5WUUIcI5CgnOxOIkxFGWMDx2eHnBnkJKaglWJi1mLYSRMfIn4bvZZHzvEwDHuY7ODZn0Izlqn/wu3xyHfzHx3cSDGJkPEdRl/pc5aAi1se1TiBqUAZ5oQXDvhNdaXcADUb0mreepEBNOPCaXv3Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tVsUW-0007aP-5x; Thu, 09 Jan 2025 14:22:28 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnetfilter_conntrack 1/2] src: add support for CTA_TIMESTAMP_EVENT
Date: Thu,  9 Jan 2025 14:15:36 +0100
Message-ID: <20250109131541.5856-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow libnetfilter_conntrack to parse CTA_TIMESTAMP_EVENT attribute.
This will be included for all ctnetlink events if the kernel has commit

    netfilter: conntrack: add conntrack event timestamp

and net.netfilter.nf_conntrack_timestamp sysctl is set to 1.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/internal/object.h                              |  1 +
 .../libnetfilter_conntrack/libnetfilter_conntrack.h    |  1 +
 .../libnetfilter_conntrack/linux_nfnetlink_conntrack.h |  1 +
 src/conntrack/getter.c                                 |  6 ++++++
 src/conntrack/parse_mnl.c                              | 10 ++++++++++
 5 files changed, 19 insertions(+)

diff --git a/include/internal/object.h b/include/internal/object.h
index 658e4d270a84..d72b31c740b3 100644
--- a/include/internal/object.h
+++ b/include/internal/object.h
@@ -201,6 +201,7 @@ struct nf_conntrack {
 
 	struct nfct_bitmask *connlabels;
 	struct nfct_bitmask *connlabels_mask;
+	uint64_t timestamp_event;
 };
 
 /*
diff --git a/include/libnetfilter_conntrack/libnetfilter_conntrack.h b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
index 27d972d76584..086c81ace0e3 100644
--- a/include/libnetfilter_conntrack/libnetfilter_conntrack.h
+++ b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
@@ -144,6 +144,7 @@ enum nf_conntrack_attr {
 	ATTR_SYNPROXY_ISN = 72,			/* u32 bits */
 	ATTR_SYNPROXY_ITS,			/* u32 bits */
 	ATTR_SYNPROXY_TSOFF,			/* u32 bits */
+	ATTR_TIMESTAMP_EVENT,			/* u64 bits */
 	ATTR_MAX
 };
 
diff --git a/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h b/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
index b8ffe02cba42..88c14c8786c5 100644
--- a/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
+++ b/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
@@ -60,6 +60,7 @@ enum ctattr_type {
 	CTA_SYNPROXY,
 	CTA_FILTER,
 	CTA_STATUS_MASK,
+	CTA_TIMESTAMP_EVENT,
 	__CTA_MAX
 };
 #define CTA_MAX (__CTA_MAX - 1)
diff --git a/src/conntrack/getter.c b/src/conntrack/getter.c
index d1f9a5ac27ad..c9615d5016b8 100644
--- a/src/conntrack/getter.c
+++ b/src/conntrack/getter.c
@@ -384,6 +384,11 @@ static const void *get_attr_synproxy_tsoff(const struct nf_conntrack *ct)
 	return &ct->synproxy.tsoff;
 }
 
+static const void *get_attr_timestamp_event(const struct nf_conntrack *ct)
+{
+	return &ct->timestamp_event;
+}
+
 const get_attr get_attr_array[ATTR_MAX] = {
 	[ATTR_ORIG_IPV4_SRC]		= get_attr_orig_ipv4_src,
 	[ATTR_ORIG_IPV4_DST] 		= get_attr_orig_ipv4_dst,
@@ -460,4 +465,5 @@ const get_attr get_attr_array[ATTR_MAX] = {
 	[ATTR_SYNPROXY_ISN]		= get_attr_synproxy_isn,
 	[ATTR_SYNPROXY_ITS]		= get_attr_synproxy_its,
 	[ATTR_SYNPROXY_TSOFF]		= get_attr_synproxy_tsoff,
+	[ATTR_TIMESTAMP_EVENT]		= get_attr_timestamp_event,
 };
diff --git a/src/conntrack/parse_mnl.c b/src/conntrack/parse_mnl.c
index 3cbfc6a6f0ba..0f87f69df287 100644
--- a/src/conntrack/parse_mnl.c
+++ b/src/conntrack/parse_mnl.c
@@ -897,6 +897,10 @@ nfct_parse_conntrack_attr_cb(const struct nlattr *attr, void *data)
 	case CTA_NAT_DST:
 		/* deprecated */
 		break;
+	case CTA_TIMESTAMP_EVENT:
+		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
+			abi_breakage();
+		break;
 	}
 	tb[type] = attr;
 	return MNL_CB_OK;
@@ -1029,6 +1033,12 @@ nfct_payload_parse(const void *payload, size_t payload_len,
 			return -1;
 	}
 
+	if (tb[CTA_TIMESTAMP_EVENT]) {
+		set_bit(ATTR_TIMESTAMP_EVENT, ct->head.set);
+		ct->timestamp_event =
+			be64toh(mnl_attr_get_u64(tb[CTA_TIMESTAMP_EVENT]));
+	}
+
 	return 0;
 }
 
-- 
2.45.2

