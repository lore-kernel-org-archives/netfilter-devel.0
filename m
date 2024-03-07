Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE8D12AAFD
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Mar 2024 12:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709814784; cv=none; b=bl2ERpij7PuoyzfgCGblI3+q7ubzVMplGV4lPf3ZrMzrM+hlzUbjj9nRRv7k4vWioogBhFrA2F5wNluD9SpKlJXgbGj99GWs8AVlbQVwRnA+c9iql4YfIRUub4+lC2A7tTDa2fyPm89FtMeKXYIyVv12na8ypIfUfCwARbGaQfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709814784; c=relaxed/simple;
	bh=UbBPpArcMRf1U+o2T3ykds1G4S4NVnFVFVrkdgWbgb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nee2a+KPBWypB0tXIIugusk85tIkly+2120j5OTNqDZ9pNxXqvcliFJglUJlBGmlwyEDju1THXrZ9ziBdtsAyinmj4U9H6uXL+8uZwgcWIUz7mzslz2/MZ68VmMQ6Vn9zg4vB5wDiYs7Rxm6ZEnDjyXG50vfGZUwmSyAktOSDes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1riCvk-00074G-Cw; Thu, 07 Mar 2024 13:33:00 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: phil@nwl.cc,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 5/5] tests: shell: add more json-nft dumps
Date: Thu,  7 Mar 2024 13:26:35 +0100
Message-ID: <20240307122640.29507-6-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240307122640.29507-1-fw@strlen.de>
References: <20240307122640.29507-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The previous patch makes json input build transactions in
the correct order so these dumps now work as expected.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../dumps/0011endless_jump_loop_1.json-nft    |  75 +++
 .../testcases/maps/dumps/0011vmap_0.json-nft  | 145 +++++
 .../dumps/map_catchall_double_free_2.json-nft |  46 ++
 .../maps/dumps/vmap_mark_bitwise_0.json-nft   | 158 +++++
 .../maps/dumps/vmap_timeout.json-nft          | 229 ++++++++
 .../dumps/0008create_verdict_map_0.json-nft   |  78 +++
 .../sets/dumps/sets_with_ifnames.json-nft     | 551 ++++++++++++++++++
 7 files changed, 1282 insertions(+)
 create mode 100644 tests/shell/testcases/chains/dumps/0011endless_jump_loop_1.json-nft
 create mode 100644 tests/shell/testcases/maps/dumps/0011vmap_0.json-nft
 create mode 100644 tests/shell/testcases/maps/dumps/map_catchall_double_free_2.json-nft
 create mode 100644 tests/shell/testcases/maps/dumps/vmap_mark_bitwise_0.json-nft
 create mode 100644 tests/shell/testcases/maps/dumps/vmap_timeout.json-nft
 create mode 100644 tests/shell/testcases/sets/dumps/0008create_verdict_map_0.json-nft
 create mode 100644 tests/shell/testcases/sets/dumps/sets_with_ifnames.json-nft

diff --git a/tests/shell/testcases/chains/dumps/0011endless_jump_loop_1.json-nft b/tests/shell/testcases/chains/dumps/0011endless_jump_loop_1.json-nft
new file mode 100644
index 000000000000..2521e1094c3c
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
diff --git a/tests/shell/testcases/maps/dumps/0011vmap_0.json-nft b/tests/shell/testcases/maps/dumps/0011vmap_0.json-nft
new file mode 100644
index 000000000000..76d9aeb11b22
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
diff --git a/tests/shell/testcases/maps/dumps/map_catchall_double_free_2.json-nft b/tests/shell/testcases/maps/dumps/map_catchall_double_free_2.json-nft
new file mode 100644
index 000000000000..0a123b700dd6
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
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "test",
+        "name": "testchain",
+        "handle": 0
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/maps/dumps/vmap_mark_bitwise_0.json-nft b/tests/shell/testcases/maps/dumps/vmap_mark_bitwise_0.json-nft
new file mode 100644
index 000000000000..df9e597b20b6
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
index 000000000000..ec5dce577d6c
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
diff --git a/tests/shell/testcases/sets/dumps/0008create_verdict_map_0.json-nft b/tests/shell/testcases/sets/dumps/0008create_verdict_map_0.json-nft
new file mode 100644
index 000000000000..69c7e2df5a54
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
diff --git a/tests/shell/testcases/sets/dumps/sets_with_ifnames.json-nft b/tests/shell/testcases/sets/dumps/sets_with_ifnames.json-nft
new file mode 100644
index 000000000000..10e69dcac199
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

