Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=57.103.78.116
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792701944;
	b=3YCgwG/pia4Yicbiq5AcObum0w+QpM5XaEM2uwZBT8uzcLAefNariyXdI9+fzqIjthbz
	 P8kVwSfwkgaP0TMWfiHPI0O6aS4kc0Hj9zQwg67+Re1IK+wyxn6GfIwVwFNGP0dqRWBS2
	 bfO1onDdZtf95rSnNNSOvmM4+Qf/bfh2ihq2HcJ8J9EYyMCWdgK8a7lc4Revz9Hem095q
	 rWMLN5s+3U4C19Q61tr4jHlu2xQwyX6+0UuPJjDiPdvURUGJSB3GzxX/N7O9v3R7+UW9+
	 iIC1L4nyh9o2QwbuJpIluMFD9nVQwS6DHDhtB0mu1+v2cJOMMupeOBpTLYnOdQYuY6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792701944;
	h=DMARC-Filter:Received:X-ICL-RepId:X-ICL-Out-Info:Dkim-Signature:
	 mail-alias-created-date:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Authority-Info-Out:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:X-JNJ;
	bh=uD2b1J+iYCv07jKWkZBNZCvkZLsY9o5hLBYRoCSgwk4=;
	b=yurTDGfnhgrEQu87TfrE/dPguN6WdJyiW17Pf3Zhcai8SGVliivwq16rwDht17C3Hlhf
	 X/3lo78rghcGlLaKuZON8VGUYJ++imMLFm24cOsbKI4a3OzFg46WqbCk7W6NmLrnDd6vG
	 H7XesVgZBA0IrH2HvhuoG1pBTJ8xDKL2+jxoB8MejKNKyE6ROate91bHab7V2daOWnCPn
	 w0NHRGEpaQG95xVFz9t36dIK3ZldTex3w+iY7aBMZUtemk+TxcuPtuS543zFffnWrpzlW
	 XWp7evgXJoF+sF7+2qeAXwCvIT14DszbQatl3a/mvN3tAAL9dMrbtT5a+WYAV6K9mPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=seeber.me;
	spf=pass smtp.mailfrom=seeber.me;
	dkim=pass header.d=seeber.me header.i=@seeber.me header.a=rsa-sha256 header.s=sig1 header.b=jiZybKAT;
	arc=none smtp.remote-ip=57.103.78.116
Received: from outbound.st.icloud.com (st-2002d-snip4-3.eps.apple.com [57.103.78.116])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736FC606A319
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 20:45:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 736FC606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seeber.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seeber.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=seeber.me header.i=@seeber.me header.a=rsa-sha256 header.s=sig1 header.b=jiZybKAT
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-4 (Postfix) with ESMTPS id BB1C4180023A;
	Thu, 22 Oct 2026 20:45:42 +0000 (UTC)
X-ICL-RepId: 01a1655c-cbce-70c8-be0c-334bd31019ad
X-ICL-Out-Info: HUtFAUMEWwJACUgATUQeDx5WFlZNRAJCTQFMHVwDWhxEDlYCWAZLVxQEElwOXw5cMEodVg9SGRwdXFhVCQoYVxVbHUFDWg4SAlpFBU1fDl4fBBdGGVUERx5dVkAZGQJRHFYNV0NUBF9QSQxBUGxaAEcXSB1dGVlvUF0cDh5SDlAVS1ZeCBcGWxQERAFdBV0DQAtKAV0DXgFEF00HXwVSH0MUElwOXw5cMEodVg9SGRwdXEYTGU4bV01aDUAZWAZtFFYVUgRZ
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seeber.me; s=sig1; t=1792701943; x=1824237943; bh=uD2b1J+iYCv07jKWkZBNZCvkZLsY9o5hLBYRoCSgwk4=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=jiZybKAT4Q5/K2x2RTBSyYjv8+OyQAk1j84qOaIN7FcFLyVJprA22+5P0E/i5pymZL7NZPq4EPD3gSQ9FpCUqzu7xQNGuMyAK40mcY11YNH8kJDr4YupuzRFiNSxnWecW/tzE12QFdES+X+MsR0CIMrgy7W6pf5bL3ZiR1ZbhUBJ84u4vp3KZ1DdndSecOik5qeFMXQyTxpLqgx+CDz5uycuSONC3PUzTaKFdtX+OhtqyCmBhKeL2qu6eq/aFjWCPqwdAR8yIPXAgPy5DqP4v6H0OoJlZrECD/6kySU7Dm+yNSaVoo6Ah4sF1YHvqBdn8Kz00v3oWgQKkxeAdxyRpA==
mail-alias-created-date: 1307199970000
Received: from localhost.localdomain (unknown [17.156.216.30])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-4 (Postfix) with ESMTPSA id 9996C180022C;
	Thu, 22 Oct 2026 20:45:41 +0000 (UTC)
From: Jochen Seeber <jochen@seeber.me>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	jeremy@azazel.net,
	Jochen Seeber <jochen@seeber.me>
Subject: [PATCH nft 2/3] tests: py: add map lookups as bitwise operands
Date: Thu, 22 Oct 2026 22:45:33 +0200
Message-ID: <20261022204534.54229-3-jochen@seeber.me>
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
X-Authority-Info-Out: v=2.4 cv=YqgChoYX c=1 sm=1 tr=0 ts=6ada75f6
 cx=c_apl:c_pps:t_out a=oyWFxbOnq+dmhQrAPgaJYA==:117
 a=oyWFxbOnq+dmhQrAPgaJYA==:17 a=MKtGQD3n3ToA:10 a=1oJP67jkp3AA:10
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Ujd-PKFUCMk9q8QNyt0A:9
 a=uQihmpmM4DjATsBs:21
X-Proofpoint-ORIG-GUID: cD5qzjhOSkE4uFRRjHd2AvTTKHPsKCrJ
X-Proofpoint-GUID: cD5qzjhOSkE4uFRRjHd2AvTTKHPsKCrJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDA4MiBTYWx0ZWRfX0xlOsDBDZ4rd
 y93Ti8yV/WF6q/SoZEZHe/zKJCvOBKMtWBHrBOKcJLnymn15WlkUdkCJge5NXYHRzzq1BdeBrqo
 f1lBSOIeXtNuI1aZrQrwiXjYyj19ZVOwRePhZRInG6obd5BEtb5haOrT7a/1qk/DwH2OHTlYAkg
 o9f/W4WDYpNvNlW9fxSDBCxcmdPjPVDNo4LgEFVD5IxWA73+37pRzmBjKhT/fvDqBNWHpovXcjK
 XQYwPajWK8G9hsbUFZNnf75vpGwiln5HRbAvJkoioXqO99uofRzuxPy1nh4iVL/doHlwtzOVWdW
 HgY0OXGO73noCxIChdMZT0YrL4cinPnjUrBGqgf7AkFp317V/nrFzUDUUJJ6ms=
X-JNJ: AAAAAAABEyIwrRRRx7PHzGhU9KyemhpsGughcesgdCCMCZwI+vxEdNsTgOPw2Ha20PomE/d7/At6DADmtL+vpwV3jrNzbNfvCSP7jSV+MB6iPwT9DlTZ23JZyb7PiPkubP55lvk+F2GcdPPb0PgvPfWidNOnBXr8wRQGeIi9RvkjIQQqYD1iDit6ml5c9QBunJbzK2z6PgGfko165npNyAiG5F3TbG/Ob+U12/iBsDImEQ9Y3yEGxYC5zMMN12cNgqGxZ0rX1nGVBT+Mxn60hn9htzhlbq3vN6kyyPPfETJL00uuafTSBorjA7pRsTTCGElJkQst3Pan+McqONqGOR6uZ9ECwr6yY3zq7vj1Wc2lSdH1c3MIKgB8T4kpk5FINCyq1iB52POkyyDWXXBmesWUIDzhELypb2iZcHzQpFdleaCDNRLgPEyz+XrgZ3Vg9n1vP6vEPDy6cXhHIjWr/FFo5u7g/kg1HKgM259H7uWKcuo6IRBsadEm7IdH2y+ujWQhvrNSaL0T1YgOhtx0JG99zXUlRjd2Rem5hCd4VtyDWR6gDosGf3Zh2VGTtQoqIijFvZh/02lZfpNVVHrQIwOPEXmRWig4fFdGz3VWICvPAw81AgLUjYwWr9azoeIS3XieBVAfyZGT5SId4XlckF8BEptAZ2HN+aBfkDM+IT8074K/CZf/s/azUuu/l9J9gu30Z/n5U90+mX584rJ8mdycAriRvmjVvO/9YGqQ+Fequgs3E3z74IVS53FQSdhmFsC0ceUNLqr1WVLIGvYW/zo0DPJBY1sdgn6AIca4liEBzq+Q/HT7J+JHZOdsp6nB8hpDNE+TIZ/7Xg==

Cover a named map with concatenated key as right-hand and left-hand
operand of bitwise operations on the packet mark.

Signed-off-by: Jochen Seeber <jochen@seeber.me>
---
 tests/py/ip/sets.t                |  2 +
 tests/py/ip/sets.t.json           | 91 +++++++++++++++++++++++++++++++
 tests/py/ip/sets.t.payload.inet   | 23 ++++++++
 tests/py/ip/sets.t.payload.ip     | 19 +++++++
 tests/py/ip/sets.t.payload.netdev | 23 ++++++++
 5 files changed, 158 insertions(+)

diff --git a/tests/py/ip/sets.t b/tests/py/ip/sets.t
index ad2c8316..8bbbb368 100644
--- a/tests/py/ip/sets.t
+++ b/tests/py/ip/sets.t
@@ -54,6 +54,8 @@ add @set5 { ip saddr . ip daddr };ok
 
 !map1 type ipv4_addr . ipv4_addr : mark;ok
 add @map1 { ip saddr . ip daddr : meta mark };ok
+meta mark set meta mark & 0xffffff80 | (ip saddr . ip daddr map @map1);ok
+meta mark set (ip saddr . ip daddr map @map1) ^ meta mark;ok
 
 # test nested anonymous sets
 ip saddr { { 1.1.1.0, 3.3.3.0 }, 2.2.2.0 };ok;ip saddr { 1.1.1.0, 2.2.2.0, 3.3.3.0 }
diff --git a/tests/py/ip/sets.t.json b/tests/py/ip/sets.t.json
index f2637d93..04ce11b4 100644
--- a/tests/py/ip/sets.t.json
+++ b/tests/py/ip/sets.t.json
@@ -303,6 +303,97 @@
     }
 ]
 
+# meta mark set meta mark & 0xffffff80 | (ip saddr . ip daddr map @map1)
+[
+    {
+        "mangle": {
+            "key": {
+                "meta": {
+                    "key": "mark"
+                }
+            },
+            "value": {
+                "|": [
+                    {
+                        "&": [
+                            {
+                                "meta": {
+                                    "key": "mark"
+                                }
+                            },
+                            4294967168
+                        ]
+                    },
+                    {
+                        "map": {
+                            "data": "@map1",
+                            "key": {
+                                "concat": [
+                                    {
+                                        "payload": {
+                                            "field": "saddr",
+                                            "protocol": "ip"
+                                        }
+                                    },
+                                    {
+                                        "payload": {
+                                            "field": "daddr",
+                                            "protocol": "ip"
+                                        }
+                                    }
+                                ]
+                            }
+                        }
+                    }
+                ]
+            }
+        }
+    }
+]
+
+# meta mark set (ip saddr . ip daddr map @map1) ^ meta mark
+[
+    {
+        "mangle": {
+            "key": {
+                "meta": {
+                    "key": "mark"
+                }
+            },
+            "value": {
+                "^": [
+                    {
+                        "map": {
+                            "data": "@map1",
+                            "key": {
+                                "concat": [
+                                    {
+                                        "payload": {
+                                            "field": "saddr",
+                                            "protocol": "ip"
+                                        }
+                                    },
+                                    {
+                                        "payload": {
+                                            "field": "daddr",
+                                            "protocol": "ip"
+                                        }
+                                    }
+                                ]
+                            }
+                        }
+                    },
+                    {
+                        "meta": {
+                            "key": "mark"
+                        }
+                    }
+                ]
+            }
+        }
+    }
+]
+
 # add @map2 { ip saddr . ip daddr . th dport : 10.0.0.1 . 80 }
 [
     {
diff --git a/tests/py/ip/sets.t.payload.inet b/tests/py/ip/sets.t.payload.inet
index de8182e0..ceed8564 100644
--- a/tests/py/ip/sets.t.payload.inet
+++ b/tests/py/ip/sets.t.payload.inet
@@ -84,6 +84,29 @@ inet test-inet input
   [ meta load mark => reg 10 ]
   [ dynset add reg_key 1 set map1 sreg_data 10 ]
 
+# meta mark set meta mark & 0xffffff80 | (ip saddr . ip daddr map @map1)
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x02 ]
+  [ meta load mark => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0xffffff80 ) ^ 0x00000000 ]
+  [ payload load 4b @ network header + 12 => reg 2 ]
+  [ payload load 4b @ network header + 16 => reg 13 ]
+  [ lookup reg 2 set map1 dreg 2 ]
+  [ bitwise reg 1 = ( reg 1 | reg 2 ) ]
+  [ meta set mark with reg 1 ]
+
+# meta mark set (ip saddr . ip daddr map @map1) ^ meta mark
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x02 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ payload load 4b @ network header + 16 => reg 9 ]
+  [ lookup reg 1 set map1 dreg 1 ]
+  [ meta load mark => reg 2 ]
+  [ bitwise reg 1 = ( reg 1 ^ reg 2 ) ]
+  [ meta set mark with reg 1 ]
+
 # ip saddr vmap { 1.1.1.1 : drop, * : accept }
 __map%d test-inet b
 __map%d test-inet 0
diff --git a/tests/py/ip/sets.t.payload.ip b/tests/py/ip/sets.t.payload.ip
index 95713370..38a1c0f6 100644
--- a/tests/py/ip/sets.t.payload.ip
+++ b/tests/py/ip/sets.t.payload.ip
@@ -81,6 +81,25 @@ ip test-ip4 input
   [ meta load mark => reg 10 ]
   [ dynset add reg_key 1 set map1 sreg_data 10 ]
 
+# meta mark set meta mark & 0xffffff80 | (ip saddr . ip daddr map @map1)
+ip test-ip4 input
+  [ meta load mark => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0xffffff80 ) ^ 0x00000000 ]
+  [ payload load 4b @ network header + 12 => reg 2 ]
+  [ payload load 4b @ network header + 16 => reg 13 ]
+  [ lookup reg 2 set map1 dreg 2 ]
+  [ bitwise reg 1 = ( reg 1 | reg 2 ) ]
+  [ meta set mark with reg 1 ]
+
+# meta mark set (ip saddr . ip daddr map @map1) ^ meta mark
+ip test-ip4 input
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ payload load 4b @ network header + 16 => reg 9 ]
+  [ lookup reg 1 set map1 dreg 1 ]
+  [ meta load mark => reg 2 ]
+  [ bitwise reg 1 = ( reg 1 ^ reg 2 ) ]
+  [ meta set mark with reg 1 ]
+
 # add @map2 { ip saddr . ip daddr . th dport : 10.0.0.1 . 80 }
 ip test-ip4 input
   [ payload load 4b @ network header + 12 => reg 1 ]
diff --git a/tests/py/ip/sets.t.payload.netdev b/tests/py/ip/sets.t.payload.netdev
index 66e20fa9..cc45b2e5 100644
--- a/tests/py/ip/sets.t.payload.netdev
+++ b/tests/py/ip/sets.t.payload.netdev
@@ -105,6 +105,29 @@ netdev test-netdev ingress
   [ meta load mark => reg 10 ]
   [ dynset add reg_key 1 set map1 sreg_data 10 ]
 
+# meta mark set meta mark & 0xffffff80 | (ip saddr . ip daddr map @map1)
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0800 ]
+  [ meta load mark => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0xffffff80 ) ^ 0x00000000 ]
+  [ payload load 4b @ network header + 12 => reg 2 ]
+  [ payload load 4b @ network header + 16 => reg 13 ]
+  [ lookup reg 2 set map1 dreg 2 ]
+  [ bitwise reg 1 = ( reg 1 | reg 2 ) ]
+  [ meta set mark with reg 1 ]
+
+# meta mark set (ip saddr . ip daddr map @map1) ^ meta mark
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0800 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ payload load 4b @ network header + 16 => reg 9 ]
+  [ lookup reg 1 set map1 dreg 1 ]
+  [ meta load mark => reg 2 ]
+  [ bitwise reg 1 = ( reg 1 ^ reg 2 ) ]
+  [ meta set mark with reg 1 ]
+
 # add @map2 { ip saddr . ip daddr . th dport : 10.0.0.1 . 80 }
 netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
-- 
2.56.0

