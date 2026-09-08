Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58775513550
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Sep 2026 09:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788860645; cv=none; b=P5G2dqmVES8R873qzIZegs0VuZu2npFUe9ULvDFnBgHa2ebvJawULvwwv4GR8Jc50NYwaKANlNOIJOhctb++WYlh6nDqbi7Um9OSHJEHKmwskkt7YFreO+70vKJ8QNmECYSq6v/wGLghhd2S/eXvnQyBvcoIb/CfcsddghA8NdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788860645; c=relaxed/simple;
	bh=MkAvtpfh4cqcvlCIMoVJ3FPqoyvs95gTPPSA8yCs7G8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V4B6WEt/zpUn/VxXR505h03THS7UZvC25eZqvrAHf1yOjXdHijsiiLZENoHGHAkm5pS9/YHxCOTw+NghV0Ost0X8T6qJqADuVKeoJFjwUqREyhDz/rwO8p9NM6JjaGy0zUT0WzHeybwzLypTAYWq4ZuTjPPGgEhcd0ZwXanGA4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cyPbmCiS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cyPbmCiS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788860643;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=QvyGJHL4paqmlHUuBc2wG1LtucGrrZSE5Yeq6Aebfcc=;
	b=cyPbmCiSD68Cq1Bxk0nYicHjKoOX52midilcD4mtEYGipFazBhe9iWo1cEO+Y5KK+iH6zQ
	0La9vhl40BDhdj13HAc5J0fD9YeWf/u6CBLOKP/3mji0t91jXwj1NU34nA1MiUBwBxGU/M
	mSo8y8UVgD5PQseN5hZq5IssRXJibPA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-613-d-4ofFW2MIOGlItT8goFdw-1; Tue,
 08 Sep 2026 05:44:01 -0400
X-MC-Unique: d-4ofFW2MIOGlItT8goFdw-1
X-Mimecast-MFC-AGG-ID: d-4ofFW2MIOGlItT8goFdw_1788860640
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BC0DA183F9D4
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Sep 2026 09:44:00 +0000 (UTC)
Received: from fedora.localdomain (unknown [10.43.3.90])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5947C427;
	Tue,  8 Sep 2026 09:44:00 +0000 (UTC)
Received: by fedora.localdomain (Postfix, from userid 1000)
	id 96F2C97F4EA; Tue, 08 Sep 2026 11:43:58 +0200 (CEST)
From: Jiri Peska <jpeska@redhat.com>
To: netfilter-devel@vger.kernel.org
Cc: jpeska@redhat.com,
	fwestpha@redhat.com
Subject: [PATCH nft v2] extend ct_label_set with a negative ct label match and switch to inline counter checks (.nodump).
Date: Tue,  8 Sep 2026 11:43:40 +0200
Message-ID: <20260908094340.30826-1-jpeska@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

Signed-off-by: Jiri Peska <jpeska@redhat.com>
---
 tests/shell/testcases/packetpath/ct_label_set |   4 +
 .../packetpath/dumps/ct_label_set.json-nft    | 132 ------------------
 .../packetpath/dumps/ct_label_set.nft         |  11 --
 .../packetpath/dumps/ct_label_set.nodump      |   0
 4 files changed, 4 insertions(+), 143 deletions(-)
 delete mode 100644 tests/shell/testcases/packetpath/dumps/ct_label_set.json-nft
 delete mode 100644 tests/shell/testcases/packetpath/dumps/ct_label_set.nft
 create mode 100644 tests/shell/testcases/packetpath/dumps/ct_label_set.nodump

diff --git a/tests/shell/testcases/packetpath/ct_label_set b/tests/shell/testcases/packetpath/ct_label_set
index 554829c0..9d1184a3 100755
--- a/tests/shell/testcases/packetpath/ct_label_set
+++ b/tests/shell/testcases/packetpath/ct_label_set
@@ -7,12 +7,15 @@ ip link set lo up
 $NFT -f - <<EOF
 table ip test {
     counter labeled {}
+    counter unlabeled {}
     chain output {
         type filter hook output priority filter; policy accept;
             # set bit 1 on each echo-request
             icmp type echo-request ip daddr 127.0.0.1 ct label set 1
             # count only if label is already set
             icmp type echo-request ip daddr 127.0.0.1 ct label 1 counter name labeled
+            # label 3 is never set, must not match
+            icmp type echo-request ip daddr 127.0.0.1 ct label 3 counter name unlabeled
     }
 }
 EOF
@@ -25,3 +28,4 @@ ping -c 2 -W 1 127.0.0.1 >/dev/null
 
 # Assert correct number of matched packets
 $NFT list counter ip test labeled | grep -q 'packets 3'
+$NFT list counter ip test unlabeled | grep -q 'packets 0'
diff --git a/tests/shell/testcases/packetpath/dumps/ct_label_set.json-nft b/tests/shell/testcases/packetpath/dumps/ct_label_set.json-nft
deleted file mode 100644
index f8e2945a..00000000
--- a/tests/shell/testcases/packetpath/dumps/ct_label_set.json-nft
+++ /dev/null
@@ -1,132 +0,0 @@
-{
-  "nftables": [
-    {
-      "metainfo": {
-        "version": "VERSION",
-        "release_name": "RELEASE_NAME",
-        "json_schema_version": 1
-      }
-    },
-    {
-      "table": {
-        "family": "ip",
-        "name": "test",
-        "handle": 0
-      }
-    },
-    {
-      "chain": {
-        "family": "ip",
-        "table": "test",
-        "name": "output",
-        "handle": 0,
-        "type": "filter",
-        "hook": "output",
-        "prio": 0,
-        "policy": "accept"
-      }
-    },
-    {
-      "counter": {
-        "family": "ip",
-        "name": "labeled",
-        "table": "test",
-        "handle": 0,
-        "packets": 3,
-        "bytes": 252
-      }
-    },
-    {
-      "rule": {
-        "family": "ip",
-        "table": "test",
-        "chain": "output",
-        "handle": 0,
-        "expr": [
-          {
-            "match": {
-              "op": "==",
-              "left": {
-                "payload": {
-                  "protocol": "icmp",
-                  "field": "type"
-                }
-              },
-              "right": "echo-request"
-            }
-          },
-          {
-            "match": {
-              "op": "==",
-              "left": {
-                "payload": {
-                  "protocol": "ip",
-                  "field": "daddr"
-                }
-              },
-              "right": "127.0.0.1"
-            }
-          },
-          {
-            "mangle": {
-              "key": {
-                "ct": {
-                  "key": "label"
-                }
-              },
-              "value": 1
-            }
-          }
-        ]
-      }
-    },
-    {
-      "rule": {
-        "family": "ip",
-        "table": "test",
-        "chain": "output",
-        "handle": 0,
-        "expr": [
-          {
-            "match": {
-              "op": "==",
-              "left": {
-                "payload": {
-                  "protocol": "icmp",
-                  "field": "type"
-                }
-              },
-              "right": "echo-request"
-            }
-          },
-          {
-            "match": {
-              "op": "==",
-              "left": {
-                "payload": {
-                  "protocol": "ip",
-                  "field": "daddr"
-                }
-              },
-              "right": "127.0.0.1"
-            }
-          },
-          {
-            "match": {
-              "op": "in",
-              "left": {
-                "ct": {
-                  "key": "label"
-                }
-              },
-              "right": 1
-            }
-          },
-          {
-            "counter": "labeled"
-          }
-        ]
-      }
-    }
-  ]
-}
diff --git a/tests/shell/testcases/packetpath/dumps/ct_label_set.nft b/tests/shell/testcases/packetpath/dumps/ct_label_set.nft
deleted file mode 100644
index 261677f8..00000000
--- a/tests/shell/testcases/packetpath/dumps/ct_label_set.nft
+++ /dev/null
@@ -1,11 +0,0 @@
-table ip test {
-	counter labeled {
-		packets 3 bytes 252
-	}
-
-	chain output {
-		type filter hook output priority filter; policy accept;
-		icmp type echo-request ip daddr 127.0.0.1 ct label set 1
-		icmp type echo-request ip daddr 127.0.0.1 ct label 1 counter name "labeled"
-	}
-}
diff --git a/tests/shell/testcases/packetpath/dumps/ct_label_set.nodump b/tests/shell/testcases/packetpath/dumps/ct_label_set.nodump
new file mode 100644
index 00000000..e69de29b
-- 
2.54.0

