Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6DC2DF7D
	for <netfilter-devel@vger.kernel.org>; Sat,  9 Mar 2024 11:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709984137; cv=none; b=HTR2fb/hAwmK2uVcRp/VCU+c/laoe1QAq+HnpS0z96i+jyU1KhMAhf0Y4P4Sf2qgjQtQU45cbvLTaxIxSZ0VlMMLYLu2gKwZv8b1etIrlGPjrCIXnEZoNaGQ/U8CFbixw6B4f7+WwTX/6Aighu6qXhB6B6UxCftnr6YIOWJyvQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709984137; c=relaxed/simple;
	bh=xfw8vK0izvlJzUgBy3/FCib9T1Fw7nAGZ3q5iXwEyZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKOj/GDsTwpYdhI4UecYBo4pQEETQpxu7bo3JaL/9yFPUS5UAswKRb/ZGcGN5FsXTARvobf0/KsmAF1ecC2yO6En348OFcqJtM9k2Zpw3QFMS8drnNXFB13rmGFhf9/CQSFzkrQyN6AgEO58nKH46GFG7djWr/UI4gHihxAxLEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=nq2gCyJ2; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="nq2gCyJ2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=dWen0EdBzbLmkxk9jaNzIukcIIxCikAR/xOqXWblL4k=; b=nq2gCyJ2L6gPI0eS8ZnKn5m+aJ
	m7kXNHx3PIDIxvM+Za4JlILCy9Fn/bqemGZl+6aMvABosHk5PT8vMXQnGtwpo0QHqI4CAklgLEu+I
	TJPGvq561jPDE76C2vN2OhTsfX7A+KC4mUewwBs/2ttHt7QDmwRwcRFaJnIHXnhTu7R0bQ46u6rhV
	AO0AGpZs7e9UFpwdTvbJCPiqajAmAUJ8QO+VZus8bfQ55g0l7d7m86wBBvEQLvAtCmWhByPaUTr3N
	9A/fXZIioEFce9j1dDdsdCUQjFFImluCCDvQfQkBUuFyTqH4gxRTDKpaoEZf47D/Ul4kS+AxfdRBn
	qrEgamjQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1riuzE-000000003h7-0MPL;
	Sat, 09 Mar 2024 12:35:32 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [nft PATCH 7/7] tests: shell: Add missing json-nft dumps
Date: Sat,  9 Mar 2024 12:35:27 +0100
Message-ID: <20240309113527.8723-8-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240309113527.8723-1-phil@nwl.cc>
References: <20240309113527.8723-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Given that a bunch of issues got fixed, add some more dumps.

Also add tests/shell/testcases/owner/dumps/0002-persist.nft while at it,
even though it's really small.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../dumps/0011endless_jump_loop_1.json-nft    |  75 +++
 .../maps/dumps/0010concat_map_0.json-nft      | 106 ++++
 .../testcases/maps/dumps/0011vmap_0.json-nft  | 145 +++++
 .../maps/dumps/0024named_objects_0.json-nft   | 165 ++++++
 .../dumps/map_catchall_double_free_2.json-nft |  46 ++
 .../maps/dumps/vmap_mark_bitwise_0.json-nft   | 158 +++++
 .../maps/dumps/vmap_timeout.json-nft          | 229 ++++++++
 .../dumps/comments_objects_0.json-nft         | 102 ++++
 .../owner/dumps/0002-persist.json-nft         |  19 +
 .../testcases/owner/dumps/0002-persist.nft    |   3 +
 .../dumps/0008create_verdict_map_0.json-nft   |  78 +++
 .../sets/dumps/0024synproxy_0.json-nft        | 131 +++++
 .../sets/dumps/sets_with_ifnames.json-nft     | 551 ++++++++++++++++++
 13 files changed, 1808 insertions(+)
 create mode 100644 tests/shell/testcases/chains/dumps/0011endless_jump_loop_1.json-nft
 create mode 100644 tests/shell/testcases/maps/dumps/0010concat_map_0.json-nft
 create mode 100644 tests/shell/testcases/maps/dumps/0011vmap_0.json-nft
 create mode 100644 tests/shell/testcases/maps/dumps/0024named_objects_0.json-nft
 create mode 100644 tests/shell/testcases/maps/dumps/map_catchall_double_free_2.json-nft
 create mode 100644 tests/shell/testcases/maps/dumps/vmap_mark_bitwise_0.json-nft
 create mode 100644 tests/shell/testcases/maps/dumps/vmap_timeout.json-nft
 create mode 100644 tests/shell/testcases/optionals/dumps/comments_objects_0.json-nft
 create mode 100644 tests/shell/testcases/owner/dumps/0002-persist.json-nft
 create mode 100644 tests/shell/testcases/owner/dumps/0002-persist.nft
 create mode 100644 tests/shell/testcases/sets/dumps/0008create_verdict_map_0.json-nft
 create mode 100644 tests/shell/testcases/sets/dumps/0024synproxy_0.json-nft
 create mode 100644 tests/shell/testcases/sets/dumps/sets_with_ifnames.json-nft

diff --git a/tests/shell/testcases/chains/dumps/0011endless_jump_loop_1.json-nft b/tests/shell/testcases/chains/dumps/0011endless_jump_loop_1.json-nft
new file mode 100644
index 0000000000000..e1a2262fdf04f
--- /dev/null
+++ b/tests/shell/testcases/chains/dumps/0011endless_jump_loop_1.json-nft
@@ -0,0 +1,75 @@
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
+        "name": "t",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "t",
+        "name": "c1",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "t",
+        "name": "c2",
+        "handle": 0
+      }
+    },
+    {
+      "map": {
+        "family": "ip",
+        "name": "m",
+        "table": "t",
+        "type": "inet_service",
+        "handle": 0,
+        "map": "verdict",
+        "elem": [
+          [
+            2,
+            {
+              "jump": {
+                "target": "c2"
+              }
+            }
+          ]
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "t",
+        "chain": "c1",
+        "handle": 0,
+        "expr": [
+          {
+            "vmap": {
+              "key": {
+                "payload": {
+                  "protocol": "tcp",
+                  "field": "dport"
+                }
+              },
+              "data": "@m"
+            }
+          }
+        ]
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/maps/dumps/0010concat_map_0.json-nft b/tests/shell/testcases/maps/dumps/0010concat_map_0.json-nft
new file mode 100644
index 0000000000000..fcc23bb8095fa
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/0010concat_map_0.json-nft
@@ -0,0 +1,106 @@
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
+        "family": "inet",
+        "name": "x",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "x",
+        "name": "y",
+        "handle": 0,
+        "type": "nat",
+        "hook": "prerouting",
+        "prio": -100,
+        "policy": "accept"
+      }
+    },
+    {
+      "map": {
+        "family": "inet",
+        "name": "z",
+        "table": "x",
+        "type": [
+          "ipv4_addr",
+          "inet_proto",
+          "inet_service"
+        ],
+        "handle": 0,
+        "map": [
+          "ipv4_addr",
+          "inet_service"
+        ],
+        "elem": [
+          [
+            {
+              "concat": [
+                "1.1.1.1",
+                "tcp",
+                20
+              ]
+            },
+            {
+              "concat": [
+                "2.2.2.2",
+                30
+              ]
+            }
+          ]
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "x",
+        "chain": "y",
+        "handle": 0,
+        "expr": [
+          {
+            "dnat": {
+              "family": "ip",
+              "addr": {
+                "map": {
+                  "key": {
+                    "concat": [
+                      {
+                        "payload": {
+                          "protocol": "ip",
+                          "field": "saddr"
+                        }
+                      },
+                      {
+                        "payload": {
+                          "protocol": "ip",
+                          "field": "protocol"
+                        }
+                      },
+                      {
+                        "payload": {
+                          "protocol": "tcp",
+                          "field": "dport"
+                        }
+                      }
+                    ]
+                  },
+                  "data": "@z"
+                }
+              }
+            }
+          }
+        ]
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/maps/dumps/0011vmap_0.json-nft b/tests/shell/testcases/maps/dumps/0011vmap_0.json-nft
new file mode 100644
index 0000000000000..8f07378a84e4c
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/0011vmap_0.json-nft
@@ -0,0 +1,145 @@
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
+        "family": "inet",
+        "name": "filter",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "filter",
+        "name": "ssh_input",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "filter",
+        "name": "wan_input",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "filter",
+        "name": "prerouting",
+        "handle": 0,
+        "type": "filter",
+        "hook": "prerouting",
+        "prio": -300,
+        "policy": "accept"
+      }
+    },
+    {
+      "map": {
+        "family": "inet",
+        "name": "portmap",
+        "table": "filter",
+        "type": "inet_service",
+        "handle": 0,
+        "map": "verdict",
+        "elem": [
+          [
+            {
+              "elem": {
+                "val": 22,
+                "counter": {
+                  "packets": 0,
+                  "bytes": 0
+                }
+              }
+            },
+            {
+              "jump": {
+                "target": "ssh_input"
+              }
+            }
+          ],
+          [
+            {
+              "elem": {
+                "val": "*",
+                "counter": {
+                  "packets": 0,
+                  "bytes": 0
+                }
+              }
+            },
+            {
+              "drop": null
+            }
+          ]
+        ],
+        "stmt": [
+          {
+            "counter": null
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "filter",
+        "chain": "wan_input",
+        "handle": 0,
+        "expr": [
+          {
+            "vmap": {
+              "key": {
+                "payload": {
+                  "protocol": "tcp",
+                  "field": "dport"
+                }
+              },
+              "data": "@portmap"
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "filter",
+        "chain": "prerouting",
+        "handle": 0,
+        "expr": [
+          {
+            "vmap": {
+              "key": {
+                "meta": {
+                  "key": "iif"
+                }
+              },
+              "data": {
+                "set": [
+                  [
+                    "lo",
+                    {
+                      "jump": {
+                        "target": "wan_input"
+                      }
+                    }
+                  ]
+                ]
+              }
+            }
+          }
+        ]
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/maps/dumps/0024named_objects_0.json-nft b/tests/shell/testcases/maps/dumps/0024named_objects_0.json-nft
new file mode 100644
index 0000000000000..aa2f6f8c22874
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/0024named_objects_0.json-nft
@@ -0,0 +1,165 @@
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
+        "family": "inet",
+        "name": "x",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "x",
+        "name": "y",
+        "handle": 0,
+        "type": "filter",
+        "hook": "input",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
+    {
+      "counter": {
+        "family": "inet",
+        "name": "user123",
+        "table": "x",
+        "handle": 0,
+        "packets": 12,
+        "bytes": 1433
+      }
+    },
+    {
+      "counter": {
+        "family": "inet",
+        "name": "user321",
+        "table": "x",
+        "handle": 0,
+        "packets": 0,
+        "bytes": 0
+      }
+    },
+    {
+      "quota": {
+        "family": "inet",
+        "name": "user123",
+        "table": "x",
+        "handle": 0,
+        "bytes": 2000,
+        "used": 0,
+        "inv": true
+      }
+    },
+    {
+      "quota": {
+        "family": "inet",
+        "name": "user124",
+        "table": "x",
+        "handle": 0,
+        "bytes": 2000,
+        "used": 0,
+        "inv": true
+      }
+    },
+    {
+      "set": {
+        "family": "inet",
+        "name": "y",
+        "table": "x",
+        "type": "ipv4_addr",
+        "handle": 0
+      }
+    },
+    {
+      "map": {
+        "family": "inet",
+        "name": "test",
+        "table": "x",
+        "type": "ipv4_addr",
+        "handle": 0,
+        "map": "quota",
+        "elem": [
+          [
+            "192.168.2.2",
+            "user124"
+          ],
+          [
+            "192.168.2.3",
+            "user124"
+          ]
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "x",
+        "chain": "y",
+        "handle": 0,
+        "expr": [
+          {
+            "counter": {
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
+                      "1.1.1.1",
+                      "user123"
+                    ],
+                    [
+                      "2.2.2.2",
+                      "user123"
+                    ],
+                    [
+                      "192.168.2.2",
+                      "user123"
+                    ]
+                  ]
+                }
+              }
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "x",
+        "chain": "y",
+        "handle": 0,
+        "expr": [
+          {
+            "quota": {
+              "map": {
+                "key": {
+                  "payload": {
+                    "protocol": "ip",
+                    "field": "saddr"
+                  }
+                },
+                "data": "@test"
+              }
+            }
+          },
+          {
+            "drop": null
+          }
+        ]
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/maps/dumps/map_catchall_double_free_2.json-nft b/tests/shell/testcases/maps/dumps/map_catchall_double_free_2.json-nft
new file mode 100644
index 0000000000000..a9d4c8e9fde3c
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/map_catchall_double_free_2.json-nft
@@ -0,0 +1,46 @@
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
+        "name": "testchain",
+        "handle": 0
+      }
+    },
+    {
+      "map": {
+        "family": "ip",
+        "name": "testmap",
+        "table": "test",
+        "type": "ipv4_addr",
+        "handle": 0,
+        "map": "verdict",
+        "elem": [
+          [
+            "*",
+            {
+              "jump": {
+                "target": "testchain"
+              }
+            }
+          ]
+        ]
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/maps/dumps/vmap_mark_bitwise_0.json-nft b/tests/shell/testcases/maps/dumps/vmap_mark_bitwise_0.json-nft
new file mode 100644
index 0000000000000..df156411c346c
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/vmap_mark_bitwise_0.json-nft
@@ -0,0 +1,158 @@
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
+        "name": "x",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "x",
+        "name": "sctm_o0_0",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "x",
+        "name": "sctm_o0_1",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "x",
+        "name": "SET_ctmark_RPLYroute",
+        "handle": 0
+      }
+    },
+    {
+      "counter": {
+        "family": "ip",
+        "name": "c_o0_0",
+        "table": "x",
+        "handle": 0,
+        "packets": 0,
+        "bytes": 0
+      }
+    },
+    {
+      "map": {
+        "family": "ip",
+        "name": "sctm_o0",
+        "table": "x",
+        "type": "mark",
+        "handle": 0,
+        "map": "verdict",
+        "elem": [
+          [
+            0,
+            {
+              "jump": {
+                "target": "sctm_o0_0"
+              }
+            }
+          ],
+          [
+            1,
+            {
+              "jump": {
+                "target": "sctm_o0_1"
+              }
+            }
+          ]
+        ]
+      }
+    },
+    {
+      "map": {
+        "family": "ip",
+        "name": "sctm_o1",
+        "table": "x",
+        "type": "mark",
+        "handle": 0,
+        "map": "counter",
+        "elem": [
+          [
+            0,
+            "c_o0_0"
+          ]
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "x",
+        "chain": "SET_ctmark_RPLYroute",
+        "handle": 0,
+        "expr": [
+          {
+            "vmap": {
+              "key": {
+                "&": [
+                  {
+                    ">>": [
+                      {
+                        "meta": {
+                          "key": "mark"
+                        }
+                      },
+                      8
+                    ]
+                  },
+                  15
+                ]
+              },
+              "data": "@sctm_o0"
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "x",
+        "chain": "SET_ctmark_RPLYroute",
+        "handle": 0,
+        "expr": [
+          {
+            "counter": {
+              "map": {
+                "key": {
+                  "&": [
+                    {
+                      ">>": [
+                        {
+                          "meta": {
+                            "key": "mark"
+                          }
+                        },
+                        8
+                      ]
+                    },
+                    15
+                  ]
+                },
+                "data": "@sctm_o1"
+              }
+            }
+          }
+        ]
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/maps/dumps/vmap_timeout.json-nft b/tests/shell/testcases/maps/dumps/vmap_timeout.json-nft
new file mode 100644
index 0000000000000..1c3aa590f846e
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/vmap_timeout.json-nft
@@ -0,0 +1,229 @@
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
+        "family": "inet",
+        "name": "filter",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "filter",
+        "name": "ssh_input",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "filter",
+        "name": "log_and_drop",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "filter",
+        "name": "other_input",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "filter",
+        "name": "wan_input",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "filter",
+        "name": "prerouting",
+        "handle": 0,
+        "type": "filter",
+        "hook": "prerouting",
+        "prio": -300,
+        "policy": "accept"
+      }
+    },
+    {
+      "map": {
+        "family": "inet",
+        "name": "portmap",
+        "table": "filter",
+        "type": "inet_service",
+        "handle": 0,
+        "map": "verdict",
+        "flags": [
+          "timeout"
+        ],
+        "gc-interval": 10,
+        "elem": [
+          [
+            22,
+            {
+              "jump": {
+                "target": "ssh_input"
+              }
+            }
+          ]
+        ]
+      }
+    },
+    {
+      "map": {
+        "family": "inet",
+        "name": "portaddrmap",
+        "table": "filter",
+        "type": [
+          "ipv4_addr",
+          "inet_service"
+        ],
+        "handle": 0,
+        "map": "verdict",
+        "flags": [
+          "timeout"
+        ],
+        "gc-interval": 10,
+        "elem": [
+          [
+            {
+              "concat": [
+                "1.2.3.4",
+                22
+              ]
+            },
+            {
+              "jump": {
+                "target": "ssh_input"
+              }
+            }
+          ]
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "filter",
+        "chain": "log_and_drop",
+        "handle": 0,
+        "expr": [
+          {
+            "drop": null
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "filter",
+        "chain": "other_input",
+        "handle": 0,
+        "expr": [
+          {
+            "goto": {
+              "target": "log_and_drop"
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "filter",
+        "chain": "wan_input",
+        "handle": 0,
+        "expr": [
+          {
+            "vmap": {
+              "key": {
+                "concat": [
+                  {
+                    "payload": {
+                      "protocol": "ip",
+                      "field": "daddr"
+                    }
+                  },
+                  {
+                    "payload": {
+                      "protocol": "tcp",
+                      "field": "dport"
+                    }
+                  }
+                ]
+              },
+              "data": "@portaddrmap"
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "filter",
+        "chain": "wan_input",
+        "handle": 0,
+        "expr": [
+          {
+            "vmap": {
+              "key": {
+                "payload": {
+                  "protocol": "tcp",
+                  "field": "dport"
+                }
+              },
+              "data": "@portmap"
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "filter",
+        "chain": "prerouting",
+        "handle": 0,
+        "expr": [
+          {
+            "vmap": {
+              "key": {
+                "meta": {
+                  "key": "iif"
+                }
+              },
+              "data": {
+                "set": [
+                  [
+                    "lo",
+                    {
+                      "jump": {
+                        "target": "wan_input"
+                      }
+                    }
+                  ]
+                ]
+              }
+            }
+          }
+        ]
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/optionals/dumps/comments_objects_0.json-nft b/tests/shell/testcases/optionals/dumps/comments_objects_0.json-nft
new file mode 100644
index 0000000000000..b5359d8b10c0f
--- /dev/null
+++ b/tests/shell/testcases/optionals/dumps/comments_objects_0.json-nft
@@ -0,0 +1,102 @@
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
+        "name": "filter",
+        "handle": 0
+      }
+    },
+    {
+      "quota": {
+        "family": "ip",
+        "name": "foo1",
+        "table": "filter",
+        "handle": 0,
+        "comment": "12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678",
+        "bytes": 0,
+        "used": 0,
+        "inv": false
+      }
+    },
+    {
+      "quota": {
+        "family": "ip",
+        "name": "q",
+        "table": "filter",
+        "handle": 0,
+        "comment": "12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678",
+        "bytes": 1200,
+        "used": 0,
+        "inv": true
+      }
+    },
+    {
+      "counter": {
+        "family": "ip",
+        "name": "c",
+        "table": "filter",
+        "handle": 0,
+        "comment": "test2",
+        "packets": 0,
+        "bytes": 0
+      }
+    },
+    {
+      "ct helper": {
+        "family": "ip",
+        "name": "h",
+        "table": "filter",
+        "handle": 0,
+        "comment": "test3",
+        "type": "sip",
+        "protocol": "tcp",
+        "l3proto": "ip"
+      }
+    },
+    {
+      "ct expectation": {
+        "family": "ip",
+        "name": "e",
+        "table": "filter",
+        "handle": 0,
+        "comment": "test4",
+        "protocol": "tcp",
+        "dport": 666,
+        "timeout": 100,
+        "size": 96,
+        "l3proto": "ip"
+      }
+    },
+    {
+      "limit": {
+        "family": "ip",
+        "name": "l",
+        "table": "filter",
+        "handle": 0,
+        "comment": "test5",
+        "rate": 400,
+        "per": "hour",
+        "burst": 5
+      }
+    },
+    {
+      "synproxy": {
+        "family": "ip",
+        "name": "s",
+        "table": "filter",
+        "handle": 0,
+        "comment": "test6",
+        "mss": 1460,
+        "wscale": 2
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/owner/dumps/0002-persist.json-nft b/tests/shell/testcases/owner/dumps/0002-persist.json-nft
new file mode 100644
index 0000000000000..f0c336a86e52f
--- /dev/null
+++ b/tests/shell/testcases/owner/dumps/0002-persist.json-nft
@@ -0,0 +1,19 @@
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
+        "name": "t",
+        "handle": 0,
+        "flags": "persist"
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/owner/dumps/0002-persist.nft b/tests/shell/testcases/owner/dumps/0002-persist.nft
new file mode 100644
index 0000000000000..b47027d35a30c
--- /dev/null
+++ b/tests/shell/testcases/owner/dumps/0002-persist.nft
@@ -0,0 +1,3 @@
+table ip t {
+	flags persist
+}
diff --git a/tests/shell/testcases/sets/dumps/0008create_verdict_map_0.json-nft b/tests/shell/testcases/sets/dumps/0008create_verdict_map_0.json-nft
new file mode 100644
index 0000000000000..fa5dcb2571b1a
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/0008create_verdict_map_0.json-nft
@@ -0,0 +1,78 @@
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
+        "name": "t",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "t",
+        "name": "postrouting",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "t",
+        "name": "c",
+        "handle": 0
+      }
+    },
+    {
+      "map": {
+        "family": "ip",
+        "name": "sourcemap",
+        "table": "t",
+        "type": "ipv4_addr",
+        "handle": 0,
+        "map": "verdict",
+        "elem": [
+          [
+            "100.123.10.2",
+            {
+              "jump": {
+                "target": "c"
+              }
+            }
+          ]
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "t",
+        "chain": "postrouting",
+        "handle": 0,
+        "expr": [
+          {
+            "vmap": {
+              "key": {
+                "payload": {
+                  "protocol": "ip",
+                  "field": "saddr"
+                }
+              },
+              "data": "@sourcemap"
+            }
+          },
+          {
+            "accept": null
+          }
+        ]
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/sets/dumps/0024synproxy_0.json-nft b/tests/shell/testcases/sets/dumps/0024synproxy_0.json-nft
new file mode 100644
index 0000000000000..0af613333592d
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/0024synproxy_0.json-nft
@@ -0,0 +1,131 @@
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
+        "family": "inet",
+        "name": "x",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "x",
+        "name": "y",
+        "handle": 0,
+        "type": "filter",
+        "hook": "input",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
+    {
+      "synproxy": {
+        "family": "inet",
+        "name": "https-synproxy",
+        "table": "x",
+        "handle": 0,
+        "mss": 1460,
+        "wscale": 7,
+        "flags": [
+          "timestamp",
+          "sack-perm"
+        ]
+      }
+    },
+    {
+      "synproxy": {
+        "family": "inet",
+        "name": "other-synproxy",
+        "table": "x",
+        "handle": 0,
+        "mss": 1460,
+        "wscale": 5
+      }
+    },
+    {
+      "map": {
+        "family": "inet",
+        "name": "test2",
+        "table": "x",
+        "type": "ipv4_addr",
+        "handle": 0,
+        "map": "synproxy",
+        "flags": [
+          "interval"
+        ],
+        "elem": [
+          [
+            {
+              "prefix": {
+                "addr": "192.168.1.0",
+                "len": 24
+              }
+            },
+            "https-synproxy"
+          ],
+          [
+            {
+              "prefix": {
+                "addr": "192.168.2.0",
+                "len": 24
+              }
+            },
+            "other-synproxy"
+          ]
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "x",
+        "chain": "y",
+        "handle": 0,
+        "expr": [
+          {
+            "synproxy": {
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
+                      {
+                        "prefix": {
+                          "addr": "192.168.1.0",
+                          "len": 24
+                        }
+                      },
+                      "https-synproxy"
+                    ],
+                    [
+                      {
+                        "prefix": {
+                          "addr": "192.168.2.0",
+                          "len": 24
+                        }
+                      },
+                      "other-synproxy"
+                    ]
+                  ]
+                }
+              }
+            }
+          }
+        ]
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/sets/dumps/sets_with_ifnames.json-nft b/tests/shell/testcases/sets/dumps/sets_with_ifnames.json-nft
new file mode 100644
index 0000000000000..ac4284293c32a
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/sets_with_ifnames.json-nft
@@ -0,0 +1,551 @@
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
+        "family": "inet",
+        "name": "testifsets",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "testifsets",
+        "name": "v4icmp",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "testifsets",
+        "name": "v4icmpc",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "testifsets",
+        "name": "input",
+        "handle": 0,
+        "type": "filter",
+        "hook": "input",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "testifsets",
+        "name": "do_nothing",
+        "handle": 0
+      }
+    },
+    {
+      "set": {
+        "family": "inet",
+        "name": "simple",
+        "table": "testifsets",
+        "type": "ifname",
+        "handle": 0,
+        "elem": [
+          "abcdef0",
+          "abcdef1",
+          "othername"
+        ]
+      }
+    },
+    {
+      "set": {
+        "family": "inet",
+        "name": "simple_wild",
+        "table": "testifsets",
+        "type": "ifname",
+        "handle": 0,
+        "flags": [
+          "interval"
+        ],
+        "elem": [
+          "abcdef*",
+          "othername",
+          "ppp0"
+        ]
+      }
+    },
+    {
+      "set": {
+        "family": "inet",
+        "name": "concat",
+        "table": "testifsets",
+        "type": [
+          "ipv4_addr",
+          "ifname"
+        ],
+        "handle": 0,
+        "elem": [
+          {
+            "concat": [
+              "10.1.2.2",
+              "abcdef0"
+            ]
+          },
+          {
+            "concat": [
+              "10.1.2.2",
+              "abcdef1"
+            ]
+          }
+        ]
+      }
+    },
+    {
+      "set": {
+        "family": "inet",
+        "name": "concat_wild",
+        "table": "testifsets",
+        "type": [
+          "ipv4_addr",
+          "ifname"
+        ],
+        "handle": 0,
+        "flags": [
+          "interval"
+        ],
+        "elem": [
+          {
+            "concat": [
+              "10.1.2.2",
+              "abcdef*"
+            ]
+          },
+          {
+            "concat": [
+              "10.1.2.1",
+              "bar"
+            ]
+          },
+          {
+            "concat": [
+              {
+                "prefix": {
+                  "addr": "1.1.2.0",
+                  "len": 24
+                }
+              },
+              "abcdef0"
+            ]
+          },
+          {
+            "concat": [
+              {
+                "prefix": {
+                  "addr": "12.2.2.0",
+                  "len": 24
+                }
+              },
+              "abcdef*"
+            ]
+          }
+        ]
+      }
+    },
+    {
+      "map": {
+        "family": "inet",
+        "name": "map_wild",
+        "table": "testifsets",
+        "type": "ifname",
+        "handle": 0,
+        "map": "verdict",
+        "flags": [
+          "interval"
+        ],
+        "elem": [
+          [
+            "abcdef*",
+            {
+              "jump": {
+                "target": "do_nothing"
+              }
+            }
+          ],
+          [
+            "eth0",
+            {
+              "jump": {
+                "target": "do_nothing"
+              }
+            }
+          ]
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "testifsets",
+        "chain": "v4icmp",
+        "handle": 0,
+        "expr": [
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "meta": {
+                  "key": "iifname"
+                }
+              },
+              "right": "@simple"
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
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "testifsets",
+        "chain": "v4icmp",
+        "handle": 0,
+        "expr": [
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "meta": {
+                  "key": "iifname"
+                }
+              },
+              "right": "@simple_wild"
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
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "testifsets",
+        "chain": "v4icmp",
+        "handle": 0,
+        "expr": [
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "meta": {
+                  "key": "iifname"
+                }
+              },
+              "right": {
+                "set": [
+                  "eth0",
+                  "abcdef0"
+                ]
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
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "testifsets",
+        "chain": "v4icmp",
+        "handle": 0,
+        "expr": [
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "meta": {
+                  "key": "iifname"
+                }
+              },
+              "right": {
+                "set": [
+                  "abcdef*",
+                  "eth0"
+                ]
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
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "testifsets",
+        "chain": "v4icmp",
+        "handle": 0,
+        "expr": [
+          {
+            "vmap": {
+              "key": {
+                "meta": {
+                  "key": "iifname"
+                }
+              },
+              "data": "@map_wild"
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "testifsets",
+        "chain": "v4icmpc",
+        "handle": 0,
+        "expr": [
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "concat": [
+                  {
+                    "payload": {
+                      "protocol": "ip",
+                      "field": "saddr"
+                    }
+                  },
+                  {
+                    "meta": {
+                      "key": "iifname"
+                    }
+                  }
+                ]
+              },
+              "right": "@concat"
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
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "testifsets",
+        "chain": "v4icmpc",
+        "handle": 0,
+        "expr": [
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "concat": [
+                  {
+                    "payload": {
+                      "protocol": "ip",
+                      "field": "saddr"
+                    }
+                  },
+                  {
+                    "meta": {
+                      "key": "iifname"
+                    }
+                  }
+                ]
+              },
+              "right": "@concat_wild"
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
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "testifsets",
+        "chain": "v4icmpc",
+        "handle": 0,
+        "expr": [
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "concat": [
+                  {
+                    "payload": {
+                      "protocol": "ip",
+                      "field": "saddr"
+                    }
+                  },
+                  {
+                    "meta": {
+                      "key": "iifname"
+                    }
+                  }
+                ]
+              },
+              "right": {
+                "set": [
+                  {
+                    "concat": [
+                      "10.1.2.2",
+                      "abcdef0"
+                    ]
+                  }
+                ]
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
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "testifsets",
+        "chain": "v4icmpc",
+        "handle": 0,
+        "expr": [
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "concat": [
+                  {
+                    "payload": {
+                      "protocol": "ip",
+                      "field": "saddr"
+                    }
+                  },
+                  {
+                    "meta": {
+                      "key": "iifname"
+                    }
+                  }
+                ]
+              },
+              "right": {
+                "set": [
+                  {
+                    "concat": [
+                      "10.1.2.2",
+                      "abcdef*"
+                    ]
+                  }
+                ]
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
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "testifsets",
+        "chain": "input",
+        "handle": 0,
+        "expr": [
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "payload": {
+                  "protocol": "ip",
+                  "field": "protocol"
+                }
+              },
+              "right": "icmp"
+            }
+          },
+          {
+            "jump": {
+              "target": "v4icmp"
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "testifsets",
+        "chain": "input",
+        "handle": 0,
+        "expr": [
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "payload": {
+                  "protocol": "ip",
+                  "field": "protocol"
+                }
+              },
+              "right": "icmp"
+            }
+          },
+          {
+            "goto": {
+              "target": "v4icmpc"
+            }
+          }
+        ]
+      }
+    }
+  ]
+}
-- 
2.43.0

