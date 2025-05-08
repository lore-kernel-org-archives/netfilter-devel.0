Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6515CB8
	for <netfilter-devel@vger.kernel.org>; Thu,  8 May 2025 21:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746740853; cv=none; b=TDEZfadB8gwOkUnfGRy4BnCs35fTWO7VEooQuC0JdG4iBxFB3OmLWs4bifro90DNCGkHDimzwt7cSRA3jSTuZpCsjA+QXjFTKtBYmWlYZEr2K+LZVOWmLKQpcCU+8exbTMb92fPV1cR+HKKl5ezG/YPWJnaZ6qQWTP5hGao8ZoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746740853; c=relaxed/simple;
	bh=6QryJWeq7hHGDlGIv3OU/MORGbhw363qJ01RvUZOct4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pV2o3xQBQ4aq3vyZW36LpiKQ/uflrfNnG2MEFQa1PnGTiO/Em66chzY53XyUp9vfyFzvbX36VbxU4sxckEAfLorhAqXrDYsdYX/cUrXcSoDr99+hjJ7vFN3nr4SRgBditw50Mg4j4rFZWpUT43C1viMwUDTblhijHqNHPtPHoCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=GVPLJTPF; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="GVPLJTPF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/VVPixTZ9Mi0jjObfcLQkZMlbkmXdW2gABIdpSo4djU=; b=GVPLJTPFBsC/NbSSWZgoQDgtHq
	k+zxr8U1+DmEc1DlAFJ99CGfq/py3hCUBy7G9aA6E9n8SEmFVafoBxlNSQsmvB5lP6PyD7ndP82v5
	g3KEGGVSBh6gnOhh7zfnZHLXLE3zJqsQjO7r4WUddUQXOLWMjqXeeKOknEvP4uPso8ZvyY5QQU4Aj
	E9Rr3beHKWn42pwHypELQ/nop2H9y1gz5j8Q1iy15ErEAT4Y5UEm1AbL3po0LDKX22jSeHnLjHp/E
	FBu00IXFoa23FnbjMSwfPjBpNQFL/0YAIO4RkUvrr0kUGqq40T9dtB+jyZgVyQsGb6b5FCgEQlMHg
	+ybANNoA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uD95T-000000000mc-1ANm;
	Thu, 08 May 2025 23:47:27 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 6/6] tests: shell: Add test case for JSON 'flags' arrays
Date: Thu,  8 May 2025 23:47:22 +0200
Message-ID: <20250508214722.20808-7-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250508214722.20808-1-phil@nwl.cc>
References: <20250507222830.22525-1-phil@nwl.cc>
 <20250508214722.20808-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Ensure these arrays are reduced if containing just a single item and
parser interprets them correctly in any case.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/testcases/json/single_flag | 189 +++++++++++++++++++++++++
 1 file changed, 189 insertions(+)
 create mode 100755 tests/shell/testcases/json/single_flag

diff --git a/tests/shell/testcases/json/single_flag b/tests/shell/testcases/json/single_flag
new file mode 100755
index 0000000000000..41fab63b0a23b
--- /dev/null
+++ b/tests/shell/testcases/json/single_flag
@@ -0,0 +1,189 @@
+#!/bin/bash
+#
+# Test various "flags" properties in JSON syntax:
+# - single item arrays are abbreviated as non-array in output
+# - both non-array and single item array accepted in input
+# - single and multiple item values are correctly printed in output and
+#   recognized in input (checked against standard syntax input/output)
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_json)
+
+set -e
+
+json_sanitize() {
+	sed -e 's/{"metainfo": {[^}]*}}, //' \
+	    -e 's/\("handle":\) [0-9]*/\1 0/g'
+}
+back_n_forth() { # (std, json)
+	$NFT flush ruleset
+	$NFT -f - <<< "$1"
+	diff --label "line ${BASH_LINENO[0]}: JSON output" \
+	     --label "line ${BASH_LINENO[0]}: JSON expect" \
+	     -u <($NFT -j list ruleset | json_sanitize) <(echo "$2")
+
+	$NFT flush ruleset
+	$NFT -j -f - <<< "$2"
+	diff --label "line ${BASH_LINENO[0]}: std output" \
+	     --label "line ${BASH_LINENO[0]}: std expect" \
+	     -u <($NFT list ruleset) <(echo "$1")
+}
+json_equiv() { # (json_in, json_out)
+	$NFT flush ruleset
+	$NFT -j -f - <<< "$1"
+	diff --label "line ${BASH_LINENO[0]}: JSON equiv output" \
+	     --label "line ${BASH_LINENO[0]}: JSON equiv expect" \
+	     -u <($NFT -j list ruleset | json_sanitize) <(echo "$2")
+}
+
+#
+# test table flags
+#
+
+STD_TABLE_1="table ip t {
+	flags dormant
+}"
+JSON_TABLE_1='{"nftables": [{"table": {"family": "ip", "name": "t", "handle": 0, "flags": "dormant"}}]}'
+JSON_TABLE_1_EQUIV=$(sed 's/\("flags":\) \([^}]*\)/\1 [\2]/' <<< "$JSON_TABLE_1")
+
+STD_TABLE_2=$(sed 's/\(flags dormant\)/\1,persist/' <<< "$STD_TABLE_1")
+JSON_TABLE_2=$(sed 's/\("flags":\) \("dormant"\)/\1 [\2, "persist"]/' <<< "$JSON_TABLE_1")
+
+back_n_forth "$STD_TABLE_1" "$JSON_TABLE_1"
+json_equiv "$JSON_TABLE_1_EQUIV" "$JSON_TABLE_1"
+back_n_forth "$STD_TABLE_2" "$JSON_TABLE_2"
+
+#
+# test set flags
+#
+
+STD_SET_1="table ip t {
+	set s {
+		type inet_proto
+		flags interval
+	}
+}"
+JSON_SET_1='{"nftables": [{"table": {"family": "ip", "name": "t", "handle": 0}}, {"set": {"family": "ip", "name": "s", "table": "t", "type": "inet_proto", "handle": 0, "flags": "interval"}}]}'
+JSON_SET_1_EQUIV=$(sed 's/\("flags":\) \([^}]*\)/\1 [\2]/' <<< "$JSON_SET_1")
+
+STD_SET_2=$(sed 's/\(flags interval\)/\1,timeout/' <<< "$STD_SET_1")
+JSON_SET_2=$(sed 's/\("flags":\) \("interval"\)/\1 [\2, "timeout"]/' <<< "$JSON_SET_1")
+
+back_n_forth "$STD_SET_1" "$JSON_SET_1"
+json_equiv "$JSON_SET_1_EQUIV" "$JSON_SET_1"
+back_n_forth "$STD_SET_2" "$JSON_SET_2"
+
+#
+# test fib expression flags
+#
+
+STD_FIB_1="table ip t {
+	chain c {
+		fib saddr oif exists
+	}
+}"
+JSON_FIB_1='{"nftables": [{"table": {"family": "ip", "name": "t", "handle": 0}}, {"chain": {"family": "ip", "table": "t", "name": "c", "handle": 0}}, {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 0, "expr": [{"match": {"op": "==", "left": {"fib": {"result": "oif", "flags": "saddr"}}, "right": true}}]}}]}'
+JSON_FIB_1_EQUIV=$(sed 's/\("flags":\) \([^}]*\)/\1 [\2]/' <<< "$JSON_FIB_1")
+
+STD_FIB_2=$(sed 's/\(fib saddr\)/\1 . iif/' <<< "$STD_FIB_1")
+JSON_FIB_2=$(sed 's/\("flags":\) \("saddr"\)/\1 [\2, "iif"]/' <<< "$JSON_FIB_1")
+
+back_n_forth "$STD_FIB_1" "$JSON_FIB_1"
+json_equiv "$JSON_FIB_1_EQUIV" "$JSON_FIB_1"
+back_n_forth "$STD_FIB_2" "$JSON_FIB_2"
+
+#
+# test nat statement flags
+#
+
+STD_NAT_1="table ip t {
+	chain c {
+		dnat to 192.168.0.0/24 persistent
+	}
+}"
+JSON_NAT_1='{"nftables": [{"table": {"family": "ip", "name": "t", "handle": 0}}, {"chain": {"family": "ip", "table": "t", "name": "c", "handle": 0}}, {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 0, "expr": [{"dnat": {"addr": {"prefix": {"addr": "192.168.0.0", "len": 24}}, "flags": "persistent"}}]}}]}'
+JSON_NAT_1_EQUIV=$(sed 's/\("flags":\) \([^}]*\)/\1 [\2]/' <<< "$JSON_NAT_1")
+
+STD_NAT_2=$(sed 's/\(persistent\)/random,\1/' <<< "$STD_NAT_1")
+JSON_NAT_2=$(sed 's/\("flags":\) \("persistent"\)/\1 ["random", \2]/' <<< "$JSON_NAT_1")
+
+back_n_forth "$STD_NAT_1" "$JSON_NAT_1"
+json_equiv "$JSON_NAT_1_EQUIV" "$JSON_NAT_1"
+back_n_forth "$STD_NAT_2" "$JSON_NAT_2"
+
+#
+# test log statement flags
+#
+
+STD_LOG_1="table ip t {
+	chain c {
+		log flags tcp sequence
+	}
+}"
+JSON_LOG_1='{"nftables": [{"table": {"family": "ip", "name": "t", "handle": 0}}, {"chain": {"family": "ip", "table": "t", "name": "c", "handle": 0}}, {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 0, "expr": [{"log": {"flags": "tcp sequence"}}]}}]}'
+JSON_LOG_1_EQUIV=$(sed 's/\("flags":\) \([^}]*\)/\1 [\2]/' <<< "$JSON_LOG_1")
+
+STD_LOG_2=$(sed 's/\(tcp sequence\)/\1,options/' <<< "$STD_LOG_1")
+JSON_LOG_2=$(sed 's/\("flags":\) \("tcp sequence"\)/\1 [\2, "tcp options"]/' <<< "$JSON_LOG_1")
+
+back_n_forth "$STD_LOG_1" "$JSON_LOG_1"
+json_equiv "$JSON_LOG_1_EQUIV" "$JSON_LOG_1"
+back_n_forth "$STD_LOG_2" "$JSON_LOG_2"
+
+#
+# test synproxy statement flags
+#
+
+STD_SYNPROXY_1="table ip t {
+	chain c {
+		synproxy sack-perm
+	}
+}"
+JSON_SYNPROXY_1='{"nftables": [{"table": {"family": "ip", "name": "t", "handle": 0}}, {"chain": {"family": "ip", "table": "t", "name": "c", "handle": 0}}, {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 0, "expr": [{"synproxy": {"flags": "sack-perm"}}]}}]}'
+JSON_SYNPROXY_1_EQUIV=$(sed 's/\("flags":\) \([^}]*\)/\1 [\2]/' <<< "$JSON_SYNPROXY_1")
+
+STD_SYNPROXY_2=$(sed 's/\(sack-perm\)/timestamp \1/' <<< "$STD_SYNPROXY_1")
+JSON_SYNPROXY_2=$(sed 's/\("flags":\) \("sack-perm"\)/\1 ["timestamp", \2]/' <<< "$JSON_SYNPROXY_1")
+
+back_n_forth "$STD_SYNPROXY_1" "$JSON_SYNPROXY_1"
+json_equiv "$JSON_SYNPROXY_1_EQUIV" "$JSON_SYNPROXY_1"
+back_n_forth "$STD_SYNPROXY_2" "$JSON_SYNPROXY_2"
+
+#
+# test synproxy object flags
+#
+
+STD_SYNPROXY_OBJ_1="table ip t {
+	synproxy s {
+		mss 1280
+		wscale 64
+		 sack-perm
+	}
+}"
+JSON_SYNPROXY_OBJ_1='{"nftables": [{"table": {"family": "ip", "name": "t", "handle": 0}}, {"synproxy": {"family": "ip", "name": "s", "table": "t", "handle": 0, "mss": 1280, "wscale": 64, "flags": "sack-perm"}}]}'
+JSON_SYNPROXY_OBJ_1_EQUIV=$(sed 's/\("flags":\) \([^}]*\)/\1 [\2]/' <<< "$JSON_SYNPROXY_OBJ_1")
+
+STD_SYNPROXY_OBJ_2=$(sed 's/ \(sack-perm\)/timestamp \1/' <<< "$STD_SYNPROXY_OBJ_1")
+JSON_SYNPROXY_OBJ_2=$(sed 's/\("flags":\) \("sack-perm"\)/\1 ["timestamp", \2]/' <<< "$JSON_SYNPROXY_OBJ_1")
+
+back_n_forth "$STD_SYNPROXY_OBJ_1" "$JSON_SYNPROXY_OBJ_1"
+json_equiv "$JSON_SYNPROXY_OBJ_1_EQUIV" "$JSON_SYNPROXY_OBJ_1"
+back_n_forth "$STD_SYNPROXY_OBJ_2" "$JSON_SYNPROXY_OBJ_2"
+
+#
+# test queue statement flags
+#
+
+STD_QUEUE_1="table ip t {
+	chain c {
+		queue flags bypass to 1-10
+	}
+}"
+JSON_QUEUE_1='{"nftables": [{"table": {"family": "ip", "name": "t", "handle": 0}}, {"chain": {"family": "ip", "table": "t", "name": "c", "handle": 0}}, {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 0, "expr": [{"queue": {"num": {"range": [1, 10]}, "flags": "bypass"}}]}}]}'
+JSON_QUEUE_1_EQUIV=$(sed 's/\("flags":\) \([^}]*\)/\1 [\2]/' <<< "$JSON_QUEUE_1")
+
+STD_QUEUE_2=$(sed 's/\(bypass\)/\1,fanout/' <<< "$STD_QUEUE_1")
+JSON_QUEUE_2=$(sed 's/\("flags":\) \("bypass"\)/\1 [\2, "fanout"]/' <<< "$JSON_QUEUE_1")
+
+back_n_forth "$STD_QUEUE_1" "$JSON_QUEUE_1"
+json_equiv "$JSON_QUEUE_1_EQUIV" "$JSON_QUEUE_1"
+back_n_forth "$STD_QUEUE_2" "$JSON_QUEUE_2"
-- 
2.49.0

