Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4759D375F93
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Mar 2026 23:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773184285; cv=none; b=RTPbjJDCFHu2JajP88dPzbBkAOLQ7kL3qAAuyvXKpMb9HJoEapV203BzgKziZ1hikZSusO3IJ0xC0spR8HpJiXJog67brzwl7BlchE4oj6y0aCjKvLv1QEy5k+e9CIKB26sYIFB/mUokYyFBZj6NBhfwhZ+0sUoBZmEW1nQabtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773184285; c=relaxed/simple;
	bh=IiFJ2sKjEilqgOGXsuLPbSxTiYrO9JKsmlcic4fiJ1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CT7k3BtLr+uKn9qVoI9Zru6RCLD+08Ge4pOUEe6k8yUHAsRHYomHwiikxlvlzyD+CBMeUhaitZVBmm/kxK7VPlN9GgVIz0JDxOTNzZ2faZnSUPf+CGTW3lHtW3dqA9enfKROxrEVLRYOOdO5kJPN9L6e8C8KNPztNvjLcJSnoxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=bCW2SgcW; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="bCW2SgcW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=MQ3/TD950fmruWTQ7os79CYxX3gvIDsYEofPrn8tQBs=; b=bCW2SgcWp7DbNAuTMy/filk4L4
	qFWLxnNUIxZ6bwQRSn+o3V/OCMl+lg31BjshmMhi6YMx3RZavKWTTwm8Wz9RIcY07jU7w9xi9nzqS
	HYREXtNXJAdf2v32CABh9ViZ2XgDlfZBw491rsTSpEGR4uTIMLb0Bvfk5pjAO3CCXt92EwCIm8Loe
	oCeRysTv88etngfzeH5M/+GA3YJcbvojWeHuahsYnWoGxJkZb+lURSlyJFPpY6IVHM6ETfPCU4Tgn
	txivJMbli9P/YREbcEzdIfeyxXymlOOUL8EGCOBroAu27XYkta9NVMFJkmK2yc1DaBpDxJtM5DOMg
	0dh64/UA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1w06EU-000000004qu-3ti5;
	Wed, 11 Mar 2026 00:11:23 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/5] cache: Respect family in all list commands
Date: Wed, 11 Mar 2026 00:11:12 +0100
Message-ID: <20260310231115.25638-3-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260310231115.25638-1-phil@nwl.cc>
References: <20260310231115.25638-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some list commands did not set filter->list.family even if one was given
on command line, fix this.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/cache.c                                 |  6 ++-
 tests/shell/testcases/listing/cache_filters | 46 +++++++++++++++++++++
 2 files changed, 51 insertions(+), 1 deletion(-)
 create mode 100755 tests/shell/testcases/listing/cache_filters

diff --git a/src/cache.c b/src/cache.c
index 62eccef991933..82efd476e3698 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -246,10 +246,12 @@ static unsigned int evaluate_cache_list(struct nft_ctx *nft, struct cmd *cmd,
 			flags |= NFT_CACHE_FULL;
 		break;
 	case CMD_OBJ_CHAINS:
+		filter->list.family = cmd->handle.family;
 		flags |= NFT_CACHE_TABLE | NFT_CACHE_CHAIN;
 		break;
 	case CMD_OBJ_SETS:
 	case CMD_OBJ_MAPS:
+		filter->list.family = cmd->handle.family;
 		flags |= NFT_CACHE_TABLE | NFT_CACHE_SET;
 		if (!nft_output_terse(&nft->output))
 			flags |= NFT_CACHE_SETELEM;
@@ -257,12 +259,12 @@ static unsigned int evaluate_cache_list(struct nft_ctx *nft, struct cmd *cmd,
 	case CMD_OBJ_FLOWTABLE:
 		if (cmd->handle.table.name &&
 		    cmd->handle.flowtable.name) {
-			filter->list.family = cmd->handle.family;
 			filter->list.table = cmd->handle.table.name;
 			filter->list.ft = cmd->handle.flowtable.name;
 		}
 		/* fall through */
 	case CMD_OBJ_FLOWTABLES:
+		filter->list.family = cmd->handle.family;
 		flags |= NFT_CACHE_TABLE | NFT_CACHE_FLOWTABLE;
 		break;
 	case CMD_OBJ_COUNTER:
@@ -301,6 +303,8 @@ static unsigned int evaluate_cache_list(struct nft_ctx *nft, struct cmd *cmd,
 		obj_filter_setup(cmd, &flags, filter, NFT_OBJECT_TUNNEL);
 		break;
 	case CMD_OBJ_RULESET:
+		filter->list.family = cmd->handle.family;
+		/* fall through */
 	default:
 		flags |= NFT_CACHE_FULL;
 		break;
diff --git a/tests/shell/testcases/listing/cache_filters b/tests/shell/testcases/listing/cache_filters
new file mode 100755
index 0000000000000..37c8f845dd4c7
--- /dev/null
+++ b/tests/shell/testcases/listing/cache_filters
@@ -0,0 +1,46 @@
+#!/bin/bash
+
+set -e
+
+fail() {
+	echo "$*"
+	exit 1
+}
+
+$NFT -f - <<EOF
+table ip ip_t {
+	flowtable ip_t_ft {
+		hook ingress priority 0
+	}
+	set ip_t_s {
+		type inet_service
+		elements = { 22, 80, 443 }
+	}
+	chain ip_t_c {
+		tcp dport 22 accept
+	}
+	chain ip_t_c2 {
+	}
+}
+EOF
+
+$NFT --debug=netlink list ruleset | \
+	grep -q 'payload load' || fail "broken list ruleset"
+$NFT --debug=netlink list ruleset ip6 | \
+	grep -q 'payload load' && fail "broken list ruleset family filter"
+
+$NFT --debug=netlink list chains | \
+	grep -q 'ip ip_t ip_t_c' || fail "broken list chains"
+$NFT --debug=netlink list chains ip6 | \
+	grep -q 'ip ip_t ip_t_c' && fail "broken list chains family filter"
+
+$NFT --debug=netlink list sets | \
+	grep -q 'family 2 ip_t_s ip_t' || fail "broken list sets"
+$NFT --debug=netlink list sets ip6 | \
+	grep -q 'family 2 ip_t_s ip_t' && fail "broken list sets family filter"
+
+$NFT --debug=netlink list flowtables | \
+	grep -q 'flow table ip_t ip_t_ft' || fail "broken list flowtables"
+$NFT --debug=netlink list flowtables ip6 | \
+	grep -q 'flow table ip_t ip_t_ft' && fail "broken list flowtables family filter"
+exit 0
-- 
2.51.0

