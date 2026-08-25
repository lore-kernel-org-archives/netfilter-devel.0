Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A8E3D8122
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Aug 2026 10:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787653479; cv=none; b=qgwc7ZMjJFecggn/Zt3i3TVJxnpCsTLIrE8zIhTzyId4DpNiz+VQ2fgu6hHybzHlUFbMURh62pD9vQbkJeD/M2Qjfp3uavCAA1FTuB7+EGP4qn+HgbfTdj35f98RRjFoog1a0zRx7AU09c/6c55ETKSUQ8Hfe47ON9kiG1tLAHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787653479; c=relaxed/simple;
	bh=huc9MNG7bnfQDb4YA1yNaZ1JkEEVRLGsxhUkXqFX9Eo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C4BILJdMMhSTu/jWZWPXiOTfKR50m0E5PJpJR6e3nwj6RS0I1HMCQbSy7O+LIk3l5qRxIqsjcDxOVRzBc5xvEAgX279n6UydfXm3unhLgjVp9IlzqaU4I+0ck+IKFRR/iThNYSsfq6q18OJLp0OrOn7GoV+qRbmenpt7gZpkfac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YFy0sSuW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YFy0sSuW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787653476;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=odcxIC4n9Nc/nLxSJzM/I6l5N26VPcNOjpqfKSsuwAA=;
	b=YFy0sSuW/orRujT33/SWmZxNYdcK45K5tIW1dOAyQrUUcMlyO8xZ4K8vnthd1CZ2iM3Pmf
	EG+v6BpWZPTpjaQs77IbMimvkmenpk1AOGt4TtFrV2QYzZo7/q7AztqHUhjNUWtaLxamPD
	m9O2TNth5WQNViOLSwL3S0/IY6N+6rc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-184-flBobaCNO8iOZQx_9XW87A-1; Tue,
 25 Aug 2026 06:24:34 -0400
X-MC-Unique: flBobaCNO8iOZQx_9XW87A-1
X-Mimecast-MFC-AGG-ID: flBobaCNO8iOZQx_9XW87A_1787653474
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0DA84195DE72
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Aug 2026 10:24:34 +0000 (UTC)
Received: from fedora.localdomain (unknown [10.43.3.90])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6A3CE1955DAA;
	Tue, 25 Aug 2026 10:24:33 +0000 (UTC)
Received: by fedora.localdomain (Postfix, from userid 1000)
	id 9495295850C; Tue, 25 Aug 2026 12:24:31 +0200 (CEST)
From: Jiri Peska <jpeska@redhat.com>
To: netfilter-devel@vger.kernel.org
Cc: jpeska@redhat.com,
	fwestpha@redhat.com
Subject: [PATCH nft] tests: shell: Add coverage for nf_connlabels_replace()
Date: Tue, 25 Aug 2026 12:24:29 +0200
Message-ID: <20260825102429.173237-1-jpeska@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Signed-off-by: Jiri Peska <jpeska@redhat.com>
---
 tests/shell/testcases/packetpath/ct_label_set |  27 ++++
 .../packetpath/dumps/ct_label_set.json-nft    | 132 ++++++++++++++++++
 .../packetpath/dumps/ct_label_set.nft         |  11 ++
 3 files changed, 170 insertions(+)
 create mode 100755 tests/shell/testcases/packetpath/ct_label_set
 create mode 100644 tests/shell/testcases/packetpath/dumps/ct_label_set.json-nft
 create mode 100644 tests/shell/testcases/packetpath/dumps/ct_label_set.nft

diff --git a/tests/shell/testcases/packetpath/ct_label_set b/tests/shell/testcases/packetpath/ct_label_set
new file mode 100755
index 00000000..554829c0
--- /dev/null
+++ b/tests/shell/testcases/packetpath/ct_label_set
@@ -0,0 +1,27 @@
+#!/bin/bash
+
+set -e
+
+ip link set lo up
+
+$NFT -f - <<EOF
+table ip test {
+    counter labeled {}
+    chain output {
+        type filter hook output priority filter; policy accept;
+            # set bit 1 on each echo-request
+            icmp type echo-request ip daddr 127.0.0.1 ct label set 1
+            # count only if label is already set
+            icmp type echo-request ip daddr 127.0.0.1 ct label 1 counter name labeled
+    }
+}
+EOF
+
+# Packet 1: replace sets bit 1
+ping -c 1 -W 1 127.0.0.1 >/dev/null
+
+# Packet 2+: same rule applies on same ICMP ct
+ping -c 2 -W 1 127.0.0.1 >/dev/null
+
+# Assert correct number of matched packets
+$NFT list counter ip test labeled | grep -q 'packets 3'
diff --git a/tests/shell/testcases/packetpath/dumps/ct_label_set.json-nft b/tests/shell/testcases/packetpath/dumps/ct_label_set.json-nft
new file mode 100644
index 00000000..f8e2945a
--- /dev/null
+++ b/tests/shell/testcases/packetpath/dumps/ct_label_set.json-nft
@@ -0,0 +1,132 @@
+{
+  "nftables": [
+    {
+      "metainfo": {
+        "version": "VERSION",
+        "release_name": "RELEASE_NAME",
+        "json_schema_version": 1
+      }
+    },
+    {
+      "table": {
+        "family": "ip",
+        "name": "test",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "test",
+        "name": "output",
+        "handle": 0,
+        "type": "filter",
+        "hook": "output",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
+    {
+      "counter": {
+        "family": "ip",
+        "name": "labeled",
+        "table": "test",
+        "handle": 0,
+        "packets": 3,
+        "bytes": 252
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "test",
+        "chain": "output",
+        "handle": 0,
+        "expr": [
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "payload": {
+                  "protocol": "icmp",
+                  "field": "type"
+                }
+              },
+              "right": "echo-request"
+            }
+          },
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "payload": {
+                  "protocol": "ip",
+                  "field": "daddr"
+                }
+              },
+              "right": "127.0.0.1"
+            }
+          },
+          {
+            "mangle": {
+              "key": {
+                "ct": {
+                  "key": "label"
+                }
+              },
+              "value": 1
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "test",
+        "chain": "output",
+        "handle": 0,
+        "expr": [
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "payload": {
+                  "protocol": "icmp",
+                  "field": "type"
+                }
+              },
+              "right": "echo-request"
+            }
+          },
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "payload": {
+                  "protocol": "ip",
+                  "field": "daddr"
+                }
+              },
+              "right": "127.0.0.1"
+            }
+          },
+          {
+            "match": {
+              "op": "in",
+              "left": {
+                "ct": {
+                  "key": "label"
+                }
+              },
+              "right": 1
+            }
+          },
+          {
+            "counter": "labeled"
+          }
+        ]
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/packetpath/dumps/ct_label_set.nft b/tests/shell/testcases/packetpath/dumps/ct_label_set.nft
new file mode 100644
index 00000000..261677f8
--- /dev/null
+++ b/tests/shell/testcases/packetpath/dumps/ct_label_set.nft
@@ -0,0 +1,11 @@
+table ip test {
+	counter labeled {
+		packets 3 bytes 252
+	}
+
+	chain output {
+		type filter hook output priority filter; policy accept;
+		icmp type echo-request ip daddr 127.0.0.1 ct label set 1
+		icmp type echo-request ip daddr 127.0.0.1 ct label 1 counter name "labeled"
+	}
+}
-- 
2.54.0

