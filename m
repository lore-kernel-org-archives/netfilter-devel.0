Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=57.103.78.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792701946;
	b=4U4Tv5BMGbOvTPgj800U6ToBbJWEpbt/eDZKRspoGgzKTMt2NO6FO9VKAySJbaHr4mjZ
	 Rl9fsFOSY+96wEVuuv4tJOYUS7yRLfZ/JxzIgWscsWpwjQO22/S3zAIyrHTSQLZYTinKt
	 pHNg4fn7dvIawH3/XTB8BjO7P6ttAuuXipEnUwaJqe2qTogR2vGudVoSZ9ZExWRotvubw
	 58Q3TRbskes/IvXwmGNdSVELOCNvuvFbeYlQHJCWYzU9kzEwLtnA1eHqoiDL+v0c0qTc/
	 x8f+lRgZEkvvS7DwQlvssLXlFlwfP9kxrz8YiUcJuTBk+yM0RkZGs3VaPlB+5PdoiHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792701946;
	h=DMARC-Filter:Received:X-ICL-RepId:X-ICL-Out-Info:Dkim-Signature:
	 mail-alias-created-date:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Proofpoint-GUID:X-Authority-Info-Out:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:X-JNJ;
	bh=VxbzjLgfe7xHVCz51KMSBuDJx86Bya8PdWFRFGJq4WA=;
	b=3TaiwDG8/X/1FQrpb0FDXT7NSU9Gdqgvc3sVDA4xNVk98quDvmbQDMvFhXDUS2Ow+Ivu
	 cojozYJJDPkQMI7WftFaFxmXNh7O/HjnSdkuoeT6xPe/XYbZQ9JVu4P+X7C86PnWsrQTa
	 brTpMGJ24nd04ZPjenAMTOyUf9998WeoBw7BhWr2RJV5Fib3eLHFr+WJPsNghUM9n42B8
	 JS2BlNaN2x/kIZRMuL40kKrs2kwprasJES8AF31wphYiMDhSWCbRloKSm+/LhHlmk+wJ5
	 W2Z1E7/THvzIClnnhtzOm0g/eYWLhIZrpZ1ec1TqIo8NFxZVMdN7WHc1CjkwOxo/n4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=seeber.me;
	spf=pass smtp.mailfrom=seeber.me;
	dkim=pass header.d=seeber.me header.i=@seeber.me header.a=rsa-sha256 header.s=sig1 header.b=ffUGHcss;
	arc=none smtp.remote-ip=57.103.78.20
Received: from outbound.st.icloud.com (st-2002b-snip4-7.eps.apple.com [57.103.78.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22E4606A31D
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 20:45:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C22E4606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seeber.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seeber.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=seeber.me header.i=@seeber.me header.a=rsa-sha256 header.s=sig1 header.b=ffUGHcss
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-4 (Postfix) with ESMTPS id DF7EE1800115;
	Thu, 22 Oct 2026 20:45:43 +0000 (UTC)
X-ICL-RepId: 01a1655c-d049-7cf8-9907-12b40312fd1a
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQFMHVwDWhxEDlYCWAZLVxQEElwOXw5cMEodVg9SGRwdXFhVCQoYVxVbHUFDWg4SAlpFBU1fDl4fBBdGGVUERx5dVkAZGQJRHFYNV0NUBF9QSQxBUGxaAEcXSB1dGVlvUF0cDh5SDlAVS1ZeCBcGWxQERAFdBV0DQAtKAV0DXgFEF00HXwVSH0QUElwOXw5cMEodVg9SGRwdXEYTGU4bV01aDUAZWAZtFFYVUgRZ
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seeber.me; s=sig1; t=1792701944; x=1824237944; bh=VxbzjLgfe7xHVCz51KMSBuDJx86Bya8PdWFRFGJq4WA=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=ffUGHcssSN3WCnuHcO6CCX/7fxfXFAdpQljJSMQKNWtJMb+WfiaXkRTz2un8IE8OiI/Q8TJSdfopzXKQs7QA43b+KgGKmWSBRh0qaN0w+fXCR25NQGl2i5tusjnq9GqGsfCxmGJUt5cNh+AhFdGUmcJrFyPdYWhX96tTGFRxJMUdZoACdrva01bNYlT10pVNbRLMcl7mlx1MM0gjWqXpQzro6SOeBhsC+k+lWSK6HMMx3maz6no1D37yV9/LZdbEk7guu2f2V92xbz99UKjclrptFQkMiS8KT6UBIzYJM+OfYSxct1TsT9OyiUIEsuH0Ce3cNuc30Iui97qkqEWh1w==
mail-alias-created-date: 1307199970000
Received: from localhost.localdomain (unknown [17.156.216.30])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-4 (Postfix) with ESMTPSA id B76801800104;
	Thu, 22 Oct 2026 20:45:42 +0000 (UTC)
From: Jochen Seeber <jochen@seeber.me>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	jeremy@azazel.net,
	Jochen Seeber <jochen@seeber.me>
Subject: [PATCH nft 3/3] tests: shell: add map lookups as bitwise operands
Date: Thu, 22 Oct 2026 22:45:34 +0200
Message-ID: <20261022204534.54229-4-jochen@seeber.me>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261022204534.54229-1-jochen@seeber.me>
References: <20261022204534.54229-1-jochen@seeber.me>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: tzUmcEzus2_6kbFE2J4ZeZ_5-T8fMbwl
X-Authority-Info-Out: v=2.4 cv=eJYeTXp1 c=1 sm=1 tr=0 ts=6ada75f8
 cx=c_apl:c_pps:t_out a=oyWFxbOnq+dmhQrAPgaJYA==:117
 a=oyWFxbOnq+dmhQrAPgaJYA==:17 a=MKtGQD3n3ToA:10 a=1oJP67jkp3AA:10
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=1ZhqJXtgJzOl9jrqKewA:9
 a=Vh4d8beRIujCpdfF:21
X-Proofpoint-ORIG-GUID: tzUmcEzus2_6kbFE2J4ZeZ_5-T8fMbwl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDA4MiBTYWx0ZWRfXyVxDOzdxBPgj
 Q00Hw490pwg6kXCj4rCK3TCDyfElHqIbUWl0JecC2z6XablD5m+zkW493hd+zNRNNF6H0NMajuc
 ksEcNdxgAbSAloZTHqnF8GxeSir52hdO3X8avUa8ofsCIMMgAf0C7h8tWHcyBurKQE343gflpNP
 ew/0Gap5N5mp/sO512aTYbwX5oQDSLw8UmSf/9sPDu6bGqmb5AUHTRPKeHb3fyfUZ9173P6W3xV
 5qvLn7As3oOzBb0JgscuZqe3xAL929oNXX0qOQFv2GBAwxXGyuT60JSBSVuZP6ehRtw3O16zRrl
 0fr5du1VXuM/8ZYvYiDiUDYFkca7UNNBU6uWAiwUZplDBpe9jL6iMHqQ6g9MaA=
X-JNJ: AAAAAAABwMojdzR1E7hsQTA3MFgeAuW+26bq7mibPwrqpeNFVh9eaNrRLfEH2tswAPOx+sFrcBJ1qhGqm6Je9PDYbdZhe+alS9JLRdZqwBwl0GM9D++Wk8JXru7OtrPZqRs1CxaELBx++IWJbP0ZZ2GKtpFfC9qQjj98DtmXY1Nx7izJOMYQiqiiPBy1F2BYO0/VXq8VckW7y+ZwEak1GOZ1xJXTkIML8T+19NC5fT7CWKsAPY2eAHUo7Dd8Z3BtbufPjYYlZwrmXA1C4J1flLjTe+Zyfp9y8KfN8+mbe6UP7NEyO8tbzem18D2xM/2pwuIBwbqa3xdmnWAfV6IY85T0G7sezlrnLO8BjJ5EO8PzPY3V9yozldLZJAphzePYAyeyGSDK9J0PZGRez7UB1CMoVXXwMs7cnnaJ9bmk/OXTuMQlmu4mQuPtmmdoNBn/RtjgmYEB9H7F/S/cmx3rPD0DJbQTLIOU+DaUkpglhhlkq/pekaomwp9cU6/B7mqBvw25EY6P/bDNYMVgHWmkQ9pyv2e7lEElAdMXV1n87N2Fb/gQRlaVCCPgvrvbLMepeEH0/C8QvdRAnbp/FgEulB11H1bslTTML2RznYKWOCD3MzKofroOD1eGzblaZiSqsLSfnYZm5VrHqSpetz+eRFs78egWZFqS0NNzgFWRLaEK7+KopLSEd2uuiOUYqYLGwcau0T0HgYcazMCqq8Wu83W1vI6NeXl7Mbeb+23/w2SGgkBOSBR+g2MzhsihCRjrfQi4/AfyKjkrkOHveXDoCBfi5XYPxFP9Z3pM5UmhLHI=

Add parser tests for a named interval map with concatenated key and for
an anonymous map as binop operands of mark statements.

Add a packetpath test which checks that a map hit replaces the masked
bits of the packet mark and keeps the others, and that a map miss
leaves the mark alone.

Signed-off-by: Jochen Seeber <jochen@seeber.me>
---
 .../shell/testcases/bitwise/0040mark_binop_14 |  14 +
 .../shell/testcases/bitwise/0040mark_binop_15 |  13 +
 .../bitwise/dumps/0040mark_binop_14.json-nft  | 100 +++++++
 .../bitwise/dumps/0040mark_binop_14.nft       |  11 +
 .../bitwise/dumps/0040mark_binop_15.json-nft  |  85 ++++++
 .../bitwise/dumps/0040mark_binop_15.nft       |   6 +
 .../testcases/packetpath/bitwise_map_operand  |  62 +++++
 .../dumps/bitwise_map_operand.json-nft        | 250 ++++++++++++++++++
 .../packetpath/dumps/bitwise_map_operand.nft  |  19 ++
 9 files changed, 560 insertions(+)
 create mode 100755 tests/shell/testcases/bitwise/0040mark_binop_14
 create mode 100755 tests/shell/testcases/bitwise/0040mark_binop_15
 create mode 100644 tests/shell/testcases/bitwise/dumps/0040mark_binop_14.json-nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0040mark_binop_14.nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0040mark_binop_15.json-nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0040mark_binop_15.nft
 create mode 100755 tests/shell/testcases/packetpath/bitwise_map_operand
 create mode 100644 tests/shell/testcases/packetpath/dumps/bitwise_map_operand.json-nft
 create mode 100644 tests/shell/testcases/packetpath/dumps/bitwise_map_operand.nft

diff --git a/tests/shell/testcases/bitwise/0040mark_binop_14 b/tests/shell/testcases/bitwise/0040mark_binop_14
new file mode 100755
index 00000000..e244ca53
--- /dev/null
+++ b/tests/shell/testcases/bitwise/0040mark_binop_14
@@ -0,0 +1,14 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_bitwise_multireg)
+
+set -e
+
+RULESET="
+  add table t
+  add chain t c { type filter hook output priority filter; }
+  add map t m { type ipv4_addr . ipv4_addr : mark; flags interval; }
+  add rule t c meta mark set meta mark and 0xffffff80 or (ip daddr . ip saddr map @m)
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/bitwise/0040mark_binop_15 b/tests/shell/testcases/bitwise/0040mark_binop_15
new file mode 100755
index 00000000..e696d200
--- /dev/null
+++ b/tests/shell/testcases/bitwise/0040mark_binop_15
@@ -0,0 +1,13 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_bitwise_multireg)
+
+set -e
+
+RULESET="
+  add table t
+  add chain t c { type filter hook output priority filter; }
+  add rule t c ct mark set (ip daddr map { 10.0.0.1 : 0x1, 10.0.0.2 : 0x2 }) or ct mark and 0xfffffffc
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/bitwise/dumps/0040mark_binop_14.json-nft b/tests/shell/testcases/bitwise/dumps/0040mark_binop_14.json-nft
new file mode 100644
index 00000000..4613254f
--- /dev/null
+++ b/tests/shell/testcases/bitwise/dumps/0040mark_binop_14.json-nft
@@ -0,0 +1,100 @@
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
+        "name": "c",
+        "handle": 0,
+        "type": "filter",
+        "hook": "output",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
+    {
+      "map": {
+        "family": "ip",
+        "name": "m",
+        "table": "t",
+        "type": [
+          "ipv4_addr",
+          "ipv4_addr"
+        ],
+        "handle": 0,
+        "map": "mark",
+        "flags": [
+          "interval"
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "t",
+        "chain": "c",
+        "handle": 0,
+        "expr": [
+          {
+            "mangle": {
+              "key": {
+                "meta": {
+                  "key": "mark"
+                }
+              },
+              "value": {
+                "|": [
+                  {
+                    "&": [
+                      {
+                        "meta": {
+                          "key": "mark"
+                        }
+                      },
+                      4294967168
+                    ]
+                  },
+                  {
+                    "map": {
+                      "key": {
+                        "concat": [
+                          {
+                            "payload": {
+                              "protocol": "ip",
+                              "field": "daddr"
+                            }
+                          },
+                          {
+                            "payload": {
+                              "protocol": "ip",
+                              "field": "saddr"
+                            }
+                          }
+                        ]
+                      },
+                      "data": "@m"
+                    }
+                  }
+                ]
+              }
+            }
+          }
+        ]
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/bitwise/dumps/0040mark_binop_14.nft b/tests/shell/testcases/bitwise/dumps/0040mark_binop_14.nft
new file mode 100644
index 00000000..739537d6
--- /dev/null
+++ b/tests/shell/testcases/bitwise/dumps/0040mark_binop_14.nft
@@ -0,0 +1,11 @@
+table ip t {
+	map m {
+		type ipv4_addr . ipv4_addr : mark
+		flags interval
+	}
+
+	chain c {
+		type filter hook output priority filter; policy accept;
+		meta mark set meta mark & 0xffffff80 | (ip daddr . ip saddr map @m)
+	}
+}
diff --git a/tests/shell/testcases/bitwise/dumps/0040mark_binop_15.json-nft b/tests/shell/testcases/bitwise/dumps/0040mark_binop_15.json-nft
new file mode 100644
index 00000000..a05277e3
--- /dev/null
+++ b/tests/shell/testcases/bitwise/dumps/0040mark_binop_15.json-nft
@@ -0,0 +1,85 @@
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
+        "name": "c",
+        "handle": 0,
+        "type": "filter",
+        "hook": "output",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "t",
+        "chain": "c",
+        "handle": 0,
+        "expr": [
+          {
+            "mangle": {
+              "key": {
+                "ct": {
+                  "key": "mark"
+                }
+              },
+              "value": {
+                "|": [
+                  {
+                    "map": {
+                      "key": {
+                        "payload": {
+                          "protocol": "ip",
+                          "field": "daddr"
+                        }
+                      },
+                      "data": {
+                        "set": [
+                          [
+                            "10.0.0.1",
+                            1
+                          ],
+                          [
+                            "10.0.0.2",
+                            2
+                          ]
+                        ]
+                      }
+                    }
+                  },
+                  {
+                    "&": [
+                      {
+                        "ct": {
+                          "key": "mark"
+                        }
+                      },
+                      4294967292
+                    ]
+                  }
+                ]
+              }
+            }
+          }
+        ]
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/bitwise/dumps/0040mark_binop_15.nft b/tests/shell/testcases/bitwise/dumps/0040mark_binop_15.nft
new file mode 100644
index 00000000..c77a9b90
--- /dev/null
+++ b/tests/shell/testcases/bitwise/dumps/0040mark_binop_15.nft
@@ -0,0 +1,6 @@
+table ip t {
+	chain c {
+		type filter hook output priority filter; policy accept;
+		ct mark set (ip daddr map { 10.0.0.1 : 0x00000001, 10.0.0.2 : 0x00000002 }) | ct mark & 0xfffffffc
+	}
+}
diff --git a/tests/shell/testcases/packetpath/bitwise_map_operand b/tests/shell/testcases/packetpath/bitwise_map_operand
new file mode 100755
index 00000000..aeed0817
--- /dev/null
+++ b/tests/shell/testcases/packetpath/bitwise_map_operand
@@ -0,0 +1,62 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_bitwise_multireg)
+
+set -e
+ret=0
+
+ip link set lo up
+
+$NFT -f - <<EOF
+table ip test-binop {
+	map m {
+		type ipv4_addr . ipv4_addr : mark
+		flags interval
+		elements = { 127.0.0.1 . 127.0.0.0/8 : 0x3 }
+	}
+
+	chain in {
+		type filter hook input priority 0
+
+		icmp type echo-request meta mark 0x4003 counter
+		icmp type echo-request meta mark 0x4005 counter
+	}
+
+	chain out {
+		type filter hook output priority 0
+
+		icmp type echo-request meta mark set 0x4005
+		icmp type echo-request meta mark set meta mark & 0xffffff80 | (ip daddr . ip saddr map @m)
+	}
+}
+EOF
+
+test_match()
+{
+	mark="$1"
+	packets="$2"
+	str=$(printf "mark 0x%08x" $mark)
+
+	if ! $NFT list chain test-binop in | grep "$str" | grep "packets $packets"; then
+		$NFT list chain test-binop in
+		echo "Failed counter for mark $mark: not $packets"
+		ret=1
+	fi
+}
+
+test_ping_and_match()
+{
+	ping="$1"
+	mark="$2"
+	packets="$3"
+
+	ping -q -c 1 "$ping"
+	test_match "$mark" "$packets"
+}
+
+# map hit: low 7 bits replaced by the map value, upper bits kept
+test_ping_and_match "127.0.0.1" 0x4003 1
+# map miss: the lookup breaks the rule, mark is left as is
+test_ping_and_match "127.0.0.2" 0x4005 1
+
+exit $ret
diff --git a/tests/shell/testcases/packetpath/dumps/bitwise_map_operand.json-nft b/tests/shell/testcases/packetpath/dumps/bitwise_map_operand.json-nft
new file mode 100644
index 00000000..64e472d5
--- /dev/null
+++ b/tests/shell/testcases/packetpath/dumps/bitwise_map_operand.json-nft
@@ -0,0 +1,250 @@
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
+        "name": "test-binop",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "test-binop",
+        "name": "in",
+        "handle": 0,
+        "type": "filter",
+        "hook": "input",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "test-binop",
+        "name": "out",
+        "handle": 0,
+        "type": "filter",
+        "hook": "output",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
+    {
+      "map": {
+        "family": "ip",
+        "name": "m",
+        "table": "test-binop",
+        "type": [
+          "ipv4_addr",
+          "ipv4_addr"
+        ],
+        "handle": 0,
+        "map": "mark",
+        "flags": [
+          "interval"
+        ],
+        "elem": [
+          [
+            {
+              "concat": [
+                "127.0.0.1",
+                {
+                  "prefix": {
+                    "addr": "127.0.0.0",
+                    "len": 8
+                  }
+                }
+              ]
+            },
+            3
+          ]
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "test-binop",
+        "chain": "in",
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
+                "meta": {
+                  "key": "mark"
+                }
+              },
+              "right": 16387
+            }
+          },
+          {
+            "counter": {
+              "packets": 1,
+              "bytes": 84
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "test-binop",
+        "chain": "in",
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
+                "meta": {
+                  "key": "mark"
+                }
+              },
+              "right": 16389
+            }
+          },
+          {
+            "counter": {
+              "packets": 1,
+              "bytes": 84
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "test-binop",
+        "chain": "out",
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
+            "mangle": {
+              "key": {
+                "meta": {
+                  "key": "mark"
+                }
+              },
+              "value": 16389
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "test-binop",
+        "chain": "out",
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
+            "mangle": {
+              "key": {
+                "meta": {
+                  "key": "mark"
+                }
+              },
+              "value": {
+                "|": [
+                  {
+                    "&": [
+                      {
+                        "meta": {
+                          "key": "mark"
+                        }
+                      },
+                      4294967168
+                    ]
+                  },
+                  {
+                    "map": {
+                      "key": {
+                        "concat": [
+                          {
+                            "payload": {
+                              "protocol": "ip",
+                              "field": "daddr"
+                            }
+                          },
+                          {
+                            "payload": {
+                              "protocol": "ip",
+                              "field": "saddr"
+                            }
+                          }
+                        ]
+                      },
+                      "data": "@m"
+                    }
+                  }
+                ]
+              }
+            }
+          }
+        ]
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/packetpath/dumps/bitwise_map_operand.nft b/tests/shell/testcases/packetpath/dumps/bitwise_map_operand.nft
new file mode 100644
index 00000000..75d27615
--- /dev/null
+++ b/tests/shell/testcases/packetpath/dumps/bitwise_map_operand.nft
@@ -0,0 +1,19 @@
+table ip test-binop {
+	map m {
+		type ipv4_addr . ipv4_addr : mark
+		flags interval
+		elements = { 127.0.0.1 . 127.0.0.0/8 : 0x00000003 }
+	}
+
+	chain in {
+		type filter hook input priority filter; policy accept;
+		icmp type echo-request meta mark 0x00004003 counter packets 1 bytes 84
+		icmp type echo-request meta mark 0x00004005 counter packets 1 bytes 84
+	}
+
+	chain out {
+		type filter hook output priority filter; policy accept;
+		icmp type echo-request meta mark set 0x00004005
+		icmp type echo-request meta mark set meta mark & 0xffffff80 | (ip daddr . ip saddr map @m)
+	}
+}
-- 
2.56.0

