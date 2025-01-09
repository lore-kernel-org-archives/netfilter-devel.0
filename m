Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFFD2040BF
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2025 13:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736428956; cv=none; b=GfpmMROLUJsrBPkpNK4+fMbek7YFs2T9t86cKRD8gGikh3+dVRUBxUD7tWnqQSV8k5cL4Tbb3V7EQ4QnZw1y2CU4OGhxjJC3CEovVc0aiWxPup+g2581DtpvCgSAyU8dtXy+teSG2MX1GwGZBO/F2bb9cBNbD1JHeTOWnIXN79Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736428956; c=relaxed/simple;
	bh=It++sY37SgJ0Vp2+KdOtHB1WaUW9eLyUY1VCb1s4D6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BEaG+9OVLlOk1qpqP37DQUjhsqoQv1lIJ7Ri+3LUjrBFdtQMxwlNSbjgzAyOEILBDAFKFNF1z5pU90lWI8xR6Un6PBfz6pLwBJHAf97oNoHSAniP7c/YZJCkBUrraY4BYOmwJEl1TIFeZOLLfMzmu+3bpEte3okrG2Q5IQqad/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tVsUa-0007aX-7X; Thu, 09 Jan 2025 14:22:32 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH conntrack-tools 2/2] conntrack: prefer kernel-provided event timestamp if it is available
Date: Thu,  9 Jan 2025 14:15:37 +0100
Message-ID: <20250109131541.5856-2-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250109131541.5856-1-fw@strlen.de>
References: <20250109131541.5856-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If kernel provided the event timestamp, then use it, else fall back
to gettimeofday.

This needs a recent kernel with
    netfilter: conntrack: add conntrack event timestamp

and net.netfilter.nf_conntrack_timestamp sysctl set to 1.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/conntrack.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 52ba4ac5e44f..22058736b374 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -1914,6 +1914,26 @@ static char *get_progname(uint32_t portid)
 	return NULL;
 }
 
+static void event_print_timestamp(const struct nf_conntrack *ct)
+{
+	struct timeval tv;
+
+	/* nfct_attr_is_set returns -1 if attr is unknown */
+	if (nfct_attr_is_set(ct, ATTR_TIMESTAMP_EVENT) > 0) {
+		uint64_t event_ts = nfct_get_attr_u64(ct, ATTR_TIMESTAMP_EVENT);
+		static const uint64_t ns_per_s = 1000000000ul;
+		static const uint64_t ns_to_usec = 1000ul;
+
+		tv.tv_sec = event_ts / ns_per_s;
+
+		tv.tv_usec = (event_ts % ns_per_s) / ns_to_usec;
+	} else {
+		gettimeofday(&tv, NULL);
+	}
+
+	printf("[%-.8ld.%-.6ld]\t", tv.tv_sec, tv.tv_usec);
+}
+
 static int event_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nfgenmsg *nfh = mnl_nlmsg_get_payload(nlh);
@@ -1969,9 +1989,7 @@ static int event_cb(const struct nlmsghdr *nlh, void *data)
 		op_flags = NFCT_OF_SHOW_LAYER3;
 	if (output_mask & _O_TMS) {
 		if (!(output_mask & _O_XML)) {
-			struct timeval tv;
-			gettimeofday(&tv, NULL);
-			printf("[%-.8ld.%-.6ld]\t", tv.tv_sec, tv.tv_usec);
+			event_print_timestamp(ct);
 		} else
 			op_flags |= NFCT_OF_TIME;
 	}
-- 
2.45.2

