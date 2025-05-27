Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2288E1FFC45
	for <netfilter-devel@vger.kernel.org>; Tue, 27 May 2025 19:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748375756; cv=none; b=UOns1NupD/Try0U5QNNrKXO79Arhfd4Fhks5RIedZ7q4rIR1vd+8O2FSJdBJYbEsQXapodToFvK02dnG4r0irWXVvZIKiPZakcGotMysj4K4pQ7UvCjrhgv2qxGmq9HM/hF198UTbyDbnjYm41nuyG0QUGcgXmfT49VjSLMIteY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748375756; c=relaxed/simple;
	bh=VzHeOHuyQgpS5RVrSQiLFvsvEsSH45NrPppD15lOkZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NkeGOeRAJDVmWqD8m5Reuk8jj2VySDt5D+hSU60afGpItOq0LmzfyCOuo6Mz38GJDW8jzqrCjigV6XdB7Wvj4F3dAikGLLb67SzT7JlDSnCJ6So+mvzEDbIYN04JC8mA8ZOXkMZzyIpUZkOhOtM9fUBzNXOogz4Tv81aZJH6AEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=GYXUEcPZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kqylwRmV; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=GYXUEcPZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kqylwRmV; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="GYXUEcPZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kqylwRmV";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="GYXUEcPZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kqylwRmV"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 791352118D;
	Tue, 27 May 2025 19:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748375743; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V2U7OdBUpQXsidFQ46c9lTx51HBgFYUFLOQ4isHGg6I=;
	b=GYXUEcPZHpjA8lBVN8FYjKv/CIlZ7k10O2ofE4yOqnIUcadV9pmrhAnuyeayMWXixU9H+O
	uEMTzhBw/JjWcDmJgy/QCzBiTMYiCZ2ej+xLNKMPUZbRqkmZoNmvYOlsd5KdOFF0qXh9cR
	fxX7kpXEXxLjNUFQGqSrTPeIhqAjaoQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748375743;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V2U7OdBUpQXsidFQ46c9lTx51HBgFYUFLOQ4isHGg6I=;
	b=kqylwRmVB43AIFXmcwgb6zFOc42r66n7+4jTH+xNPSUZhZYhswVpxNcHWyHh3Btb9Cq01O
	9zUwHN/u/mFHVFAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748375743; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V2U7OdBUpQXsidFQ46c9lTx51HBgFYUFLOQ4isHGg6I=;
	b=GYXUEcPZHpjA8lBVN8FYjKv/CIlZ7k10O2ofE4yOqnIUcadV9pmrhAnuyeayMWXixU9H+O
	uEMTzhBw/JjWcDmJgy/QCzBiTMYiCZ2ej+xLNKMPUZbRqkmZoNmvYOlsd5KdOFF0qXh9cR
	fxX7kpXEXxLjNUFQGqSrTPeIhqAjaoQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748375743;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V2U7OdBUpQXsidFQ46c9lTx51HBgFYUFLOQ4isHGg6I=;
	b=kqylwRmVB43AIFXmcwgb6zFOc42r66n7+4jTH+xNPSUZhZYhswVpxNcHWyHh3Btb9Cq01O
	9zUwHN/u/mFHVFAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2FBDF136E0;
	Tue, 27 May 2025 19:55:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iGVpCL8YNmhJGgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 27 May 2025 19:55:43 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 7/7 nft] tests: add tunnel shell and python tests
Date: Tue, 27 May 2025 21:54:44 +0200
Message-ID: <4416bded671aa530d10c72bc49e9375d4ee3d527.1748374810.git.fmancera@suse.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1748374810.git.fmancera@suse.de>
References: <cover.1748374810.git.fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Spam-Level: 

Add tests for tunnel statement and object support. Shell and python
tests both cover standard nft output and json.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 tests/py/netdev/tunnel.t                      |   7 +
 tests/py/netdev/tunnel.t.json                 |  45 +++++
 tests/py/netdev/tunnel.t.json.payload         |  12 ++
 tests/py/netdev/tunnel.t.payload              |  12 ++
 tests/shell/features/tunnel.nft               |  17 ++
 tests/shell/testcases/sets/0075tunnel_0       |  75 ++++++++
 .../sets/dumps/0075tunnel_0.json-nft          | 171 ++++++++++++++++++
 .../testcases/sets/dumps/0075tunnel_0.nft     |  63 +++++++
 8 files changed, 402 insertions(+)
 create mode 100644 tests/py/netdev/tunnel.t
 create mode 100644 tests/py/netdev/tunnel.t.json
 create mode 100644 tests/py/netdev/tunnel.t.json.payload
 create mode 100644 tests/py/netdev/tunnel.t.payload
 create mode 100644 tests/shell/features/tunnel.nft
 create mode 100755 tests/shell/testcases/sets/0075tunnel_0
 create mode 100644 tests/shell/testcases/sets/dumps/0075tunnel_0.json-nft
 create mode 100644 tests/shell/testcases/sets/dumps/0075tunnel_0.nft

diff --git a/tests/py/netdev/tunnel.t b/tests/py/netdev/tunnel.t
new file mode 100644
index 00000000..920d21ff
--- /dev/null
+++ b/tests/py/netdev/tunnel.t
@@ -0,0 +1,7 @@
+:tunnelchain;type filter hook ingress device lo priority 0
+
+*netdev;test-netdev;tunnelchain
+
+tunnel path exists;ok
+tunnel path missing;ok
+tunnel id 10;ok
diff --git a/tests/py/netdev/tunnel.t.json b/tests/py/netdev/tunnel.t.json
new file mode 100644
index 00000000..3ca877d9
--- /dev/null
+++ b/tests/py/netdev/tunnel.t.json
@@ -0,0 +1,45 @@
+# tunnel path exists
+[
+    {
+        "match": {
+            "left": {
+                "tunnel": {
+                    "key": "path"
+                }
+            },
+            "op": "==",
+            "right": true
+        }
+    }
+]
+
+# tunnel path missing
+[
+    {
+        "match": {
+            "left": {
+                "tunnel": {
+                    "key": "path"
+                }
+            },
+            "op": "==",
+            "right": false
+        }
+    }
+]
+
+# tunnel id 10
+[
+    {
+        "match": {
+            "left": {
+                "tunnel": {
+                    "key": "id"
+                }
+            },
+            "op": "==",
+            "right": 10
+        }
+    }
+]
+
diff --git a/tests/py/netdev/tunnel.t.json.payload b/tests/py/netdev/tunnel.t.json.payload
new file mode 100644
index 00000000..df127b6c
--- /dev/null
+++ b/tests/py/netdev/tunnel.t.json.payload
@@ -0,0 +1,12 @@
+# tunnel path exists
+netdev test-netdev tunnelchain
+  [ tunnel load path => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+# tunnel path missing
+netdev test-netdev tunnelchain
+  [ tunnel load path => reg 1 ]
+  [ cmp eq reg 1 0x00000000 ]
+# tunnel id 10
+netdev test-netdev tunnelchain
+  [ tunnel load id => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
diff --git a/tests/py/netdev/tunnel.t.payload b/tests/py/netdev/tunnel.t.payload
new file mode 100644
index 00000000..df127b6c
--- /dev/null
+++ b/tests/py/netdev/tunnel.t.payload
@@ -0,0 +1,12 @@
+# tunnel path exists
+netdev test-netdev tunnelchain
+  [ tunnel load path => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+# tunnel path missing
+netdev test-netdev tunnelchain
+  [ tunnel load path => reg 1 ]
+  [ cmp eq reg 1 0x00000000 ]
+# tunnel id 10
+netdev test-netdev tunnelchain
+  [ tunnel load id => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
diff --git a/tests/shell/features/tunnel.nft b/tests/shell/features/tunnel.nft
new file mode 100644
index 00000000..64b2f70b
--- /dev/null
+++ b/tests/shell/features/tunnel.nft
@@ -0,0 +1,17 @@
+# v5.7-rc1~146^2~137^2~26
+# 925d844696d9 ("netfilter: nft_tunnel: add support for geneve opts")
+table netdev x {
+        tunnel y {
+                id 10
+                ip saddr 192.168.2.10
+                ip daddr 192.168.2.11
+                sport 10
+                dport 20
+                ttl 10
+                geneve {
+                        class 0x1010 opt-type 0x1 data "0x12345678"
+                        class 0x2010 opt-type 0x2 data "0x87654321"
+                        class 0x2020 opt-type 0x3 data "0x87654321abcdeffe"
+                }
+        }
+}
diff --git a/tests/shell/testcases/sets/0075tunnel_0 b/tests/shell/testcases/sets/0075tunnel_0
new file mode 100755
index 00000000..f8a8cf00
--- /dev/null
+++ b/tests/shell/testcases/sets/0075tunnel_0
@@ -0,0 +1,75 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_tunnel)
+
+# * creating valid named objects
+# * referencing them from a valid rule
+
+RULESET="
+table netdev x {
+	tunnel geneve-t {
+		id 10
+		ip saddr 192.168.2.10
+		ip daddr 192.168.2.11
+		sport 10
+		dport 10
+		ttl 10
+		tos 10
+		geneve {
+			class 0x1 opt-type 0x1 data \"0x12345678\"
+			class 0x1010 opt-type 0x2 data \"0x87654321\"
+			class 0x2020 opt-type 0x3 data \"0x87654321abcdeffe\"
+		}
+	}
+
+	tunnel vxlan-t {
+		id 20
+		ip saddr 192.168.2.20
+		ip daddr 192.168.2.21
+		sport 20
+		dport 20
+		ttl 10
+		tos 10
+		vxlan {
+			gbp 200
+		}
+	}
+
+	tunnel erspan-tv1 {
+		id 30
+		ip saddr 192.168.2.30
+		ip daddr 192.168.2.31
+		sport 30
+		dport 30
+		ttl 10
+		tos 10
+		erspan {
+			version 1
+			index 5
+		}
+	}
+
+	tunnel erspan-tv2 {
+		id 40
+		ip saddr 192.168.2.40
+		ip daddr 192.168.2.41
+		sport 40
+		dport 40
+		ttl 10
+		tos 10
+		erspan {
+			version 2
+			direction ingress
+			id 10
+		}
+	}
+
+	chain x {
+		type filter hook ingress priority 0; policy accept;
+		tunnel name ip saddr map { 10.141.10.123 : "geneve-t", 10.141.10.124 : "vxlan-t", 10.141.10.125 : "erspan-tv1", 10.141.10.126 : "erspan-tv2" } counter
+	}
+}
+"
+
+set -e
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/sets/dumps/0075tunnel_0.json-nft b/tests/shell/testcases/sets/dumps/0075tunnel_0.json-nft
new file mode 100644
index 00000000..c3a7d522
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/0075tunnel_0.json-nft
@@ -0,0 +1,171 @@
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
+        "family": "netdev",
+        "name": "x",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "netdev",
+        "table": "x",
+        "name": "x",
+        "handle": 0,
+        "type": "filter",
+        "hook": "ingress",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
+    {
+      "tunnel": {
+        "family": "netdev",
+        "name": "geneve-t",
+        "table": "x",
+        "handle": 0,
+        "id": 10,
+        "src": "192.168.2.10",
+        "dst": "192.168.2.11",
+        "sport": 10,
+        "dport": 10,
+        "tos": 10,
+        "ttl": 10,
+        "type": "geneve",
+        "tunnel": [
+          {
+            "class": 1,
+            "opt-type": 1,
+            "data": "0x12345678"
+          },
+          {
+            "class": 4112,
+            "opt-type": 2,
+            "data": "0x87654321"
+          },
+          {
+            "class": 8224,
+            "opt-type": 3,
+            "data": "0x87654321abcdeffe"
+          }
+        ]
+      }
+    },
+    {
+      "tunnel": {
+        "family": "netdev",
+        "name": "vxlan-t",
+        "table": "x",
+        "handle": 0,
+        "id": 20,
+        "src": "192.168.2.20",
+        "dst": "192.168.2.21",
+        "sport": 20,
+        "dport": 20,
+        "tos": 10,
+        "ttl": 10,
+        "type": "vxlan",
+        "tunnel": {
+          "gbp": 200
+        }
+      }
+    },
+    {
+      "tunnel": {
+        "family": "netdev",
+        "name": "erspan-tv1",
+        "table": "x",
+        "handle": 0,
+        "id": 30,
+        "src": "192.168.2.30",
+        "dst": "192.168.2.31",
+        "sport": 30,
+        "dport": 30,
+        "tos": 10,
+        "ttl": 10,
+        "type": "erspan",
+        "tunnel": {
+          "version": 1,
+          "index": 5
+        }
+      }
+    },
+    {
+      "tunnel": {
+        "family": "netdev",
+        "name": "erspan-tv2",
+        "table": "x",
+        "handle": 0,
+        "id": 40,
+        "src": "192.168.2.40",
+        "dst": "192.168.2.41",
+        "sport": 40,
+        "dport": 40,
+        "tos": 10,
+        "ttl": 10,
+        "type": "erspan",
+        "tunnel": {
+          "version": 2,
+          "direction": "ingress",
+          "hwid": 10
+        }
+      }
+    },
+    {
+      "rule": {
+        "family": "netdev",
+        "table": "x",
+        "chain": "x",
+        "handle": 0,
+        "expr": [
+          {
+            "tunnel": {
+              "map": {
+                "key": {
+                  "payload": {
+                    "protocol": "ip",
+                    "field": "saddr"
+                  }
+                },
+                "data": {
+                  "set": [
+                    [
+                      "10.141.10.123",
+                      "geneve-t"
+                    ],
+                    [
+                      "10.141.10.124",
+                      "vxlan-t"
+                    ],
+                    [
+                      "10.141.10.125",
+                      "erspan-tv1"
+                    ],
+                    [
+                      "10.141.10.126",
+                      "erspan-tv2"
+                    ]
+                  ]
+                }
+              }
+            }
+          },
+          {
+            "counter": {
+              "packets": 0,
+              "bytes": 0
+            }
+          }
+        ]
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/sets/dumps/0075tunnel_0.nft b/tests/shell/testcases/sets/dumps/0075tunnel_0.nft
new file mode 100644
index 00000000..9969124d
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/0075tunnel_0.nft
@@ -0,0 +1,63 @@
+table netdev x {
+	tunnel geneve-t {
+		id 10
+		ip saddr 192.168.2.10
+		ip daddr 192.168.2.11
+		sport 10
+		dport 10
+		tos 10
+		ttl 10
+		geneve {
+			class 0x1 opt-type 0x1 data "0x12345678"
+			class 0x1010 opt-type 0x2 data "0x87654321"
+			class 0x2020 opt-type 0x3 data "0x87654321abcdeffe"
+		}
+	}
+
+	tunnel vxlan-t {
+		id 20
+		ip saddr 192.168.2.20
+		ip daddr 192.168.2.21
+		sport 20
+		dport 20
+		tos 10
+		ttl 10
+		vxlan {
+			gbp 200
+		}
+	}
+
+	tunnel erspan-tv1 {
+		id 30
+		ip saddr 192.168.2.30
+		ip daddr 192.168.2.31
+		sport 30
+		dport 30
+		tos 10
+		ttl 10
+		erspan {
+			version 1
+			index 5
+		}
+	}
+
+	tunnel erspan-tv2 {
+		id 40
+		ip saddr 192.168.2.40
+		ip daddr 192.168.2.41
+		sport 40
+		dport 40
+		tos 10
+		ttl 10
+		erspan {
+			version 2
+			direction ingress
+			id 10
+		}
+	}
+
+	chain x {
+		type filter hook ingress priority filter; policy accept;
+		tunnel name ip saddr map { 10.141.10.123 : "geneve-t", 10.141.10.124 : "vxlan-t", 10.141.10.125 : "erspan-tv1", 10.141.10.126 : "erspan-tv2" } counter packets 0 bytes 0
+	}
+}
-- 
2.49.0

