Received: from mail-qk1-f193.google.com (mail-qk1-f193.google.com [209.85.222.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53A034D4D2
	for <netfilter-devel@vger.kernel.org>; Sun, 11 Jan 2026 16:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768149619; cv=none; b=josMqrSF8PjMVbHY70+vtFAPk2kOIL2GN2GTNyvx6wiQ0+0d1Sy+KF40JVTNMOHOD4p3JhM0KN8NigCCpws6P2+6O6RD1uI8xT/crUQTA2EgKJ9AR2/aDa2DK9Tw5Y2AumULFPDckti6K52brpXxkqaHT1VmS84pLOBAwBWnD2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768149619; c=relaxed/simple;
	bh=PfQuUtyBeAJe+pofE4Hha9Bv47Gpih/GI5MxsWmeONI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fNRC0KgcYymEjlkA5ktNzqPUNfDxA5EzMlbpD71anqcaz0gByImLWMQ/1GVOkhlfmnPM7V3hzQqTjhTxg1Gk73DMJ/rR7pVNy/F9XFVQ2ljPHko9Sz/ZzpRpjSi1IT2X1N0b4vTORoLzuuu4LLaneXBFtCBk3B0Fmbnv76h1rt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b=mgv2wK97; arc=none smtp.client-ip=209.85.222.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b="mgv2wK97"
Received: by mail-qk1-f193.google.com with SMTP id af79cd13be357-8c15e8b2f1aso588918785a.0
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Jan 2026 08:40:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20230601.gappssmtp.com; s=20230601; t=1768149616; x=1768754416; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CJyehmBvW9DPuVDZsw3GruKuvCyFCwdzD3V1PqXRjY4=;
        b=mgv2wK97iKFq1SkbMPdg2Gupkm8ErUYMeqEerKfR1NClzkIfbt2NP0qlZx+yaUaPGM
         Noh/3Re0O7tfeRDLpJAGL1XvQBJsvESXP+37BkKJWDJYCONQcoJw2iE4KSG2QpvXwZzH
         cx99NCBNpBQdQi651oEaeMWSsTBql1NobYx5nAZ8eO/WtMfxmyKVdFCe9mIYRzRZRGHq
         iG/dBVmyBapZB8JrpM5wWKtMtbo/LsgQRtVyau3gu4GjmzB3T7fTsqqszh7MvWcAW3Z5
         iHW/5ZcanfMvzIBhAaRSI6hnEzrAIewnDDacZZ059XdfVx/vZwFTE51WMcwlY1ssQc0R
         P9Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768149616; x=1768754416;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CJyehmBvW9DPuVDZsw3GruKuvCyFCwdzD3V1PqXRjY4=;
        b=XkDry4hjKZXM9qfyygqk9YqFPm9XpNbaE5HMz23763GPovvD03GgRPfPEsNH+BLsHS
         bvf/rD2SOg/scFw8CWO0GSapzqYsjU9phUkD8o9RIxpPrZVj8qzkrNTjSYwo5sCRqBjq
         BpqTE6yzAGWcKbiIJPG4JCQUVNG8LIUoJYKNFP7svm23lnWAzxJNUJ1vI7zKcXjDyg23
         gIRmQlGc9kE0sC8LkRw+A4M+2zQm1W6bnksCDqeqh8VC5xEMz1Wy4UjYrT6pNYyR7Sax
         dkL2npOY2hA6lIlrwGduqk3wxvI+tgwnzPxr2Ge/Hh4xCMzec+RFVs6jmw3S5YD0zhKD
         +bOA==
X-Forwarded-Encrypted: i=1; AJvYcCUxr3QLs9JhbsXaZu+ZYrWxCggZc3p4TUcSGLQ3GTJ364tyXaKvLdd9ZTrzpJstE7QcNPtSMy9vagCPF5MvUB8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKZIt9eeSXt3Ec4m3bpyrtAWWC4zZWBQNSZzCRHe1E+KGyHw6+
	G2rELBwDtJG7JXwTYp0HjPbxZTTZyHJlVzhjQdE8dV5FVi3FE1mTjA318M6mlJt9iw==
X-Gm-Gg: AY/fxX6pP01RwjgxQ1KOsfho6uaaQlfD2OB90GmGsBBgqd6kXuCK7ucxoAXXK8+iCTp
	WUC4IXmnaG0C52I+jPwyxU6lyZzFQZRyGnxcrWuZmHBzrHDF8Z61+blsxr0XNkOiurDCkROBZsC
	xGyWT//uL7LeiQzq0dj3OkytN54+KwgqojCDJq5U00hPtzi47d2Sfi6+uoefWR0KvUc7o3QmCFu
	46zgfw3PhbAZcX1hwNOGVknXrTz7mlELON439NDoKYtr1MBfP6Ik280y4KpbV3NwYXuwxCgLpDt
	2lkREsuaE3se47TjcTx70gyjLVFVW5Cpaepm1vk4hbs2ErGAqXexPgKQK+UF/pKvRGNGYAM4cTj
	MzuOyw474VB5zZtTqTJmFzPo252czdF+A78ysdMQu6lgzpFnogSZMzTc6SmamlYBGvHmrm47Tnr
	LN7TRelVvgXDc=
X-Google-Smtp-Source: AGHT+IG4foGDloQniaon3MpLXUBpHI3UeS1RoEs1YQ9a28qLfYXVLJJzx5xeo2cWlNJqEujiYzbqjw==
X-Received: by 2002:a05:620a:172b:b0:8a4:107a:6772 with SMTP id af79cd13be357-8c389432833mr2043006385a.76.1768149615663;
        Sun, 11 Jan 2026 08:40:15 -0800 (PST)
Received: from majuu.waya ([70.50.89.69])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c37f4a8956sm1276589085a.10.2026.01.11.08.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jan 2026 08:40:14 -0800 (PST)
From: Jamal Hadi Salim <jhs@mojatatu.com>
To: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	andrew+netdev@lunn.ch
Cc: netdev@vger.kernel.org,
	xiyou.wangcong@gmail.com,
	jiri@resnulli.us,
	victor@mojatatu.com,
	dcaratti@redhat.com,
	lariel@nvidia.com,
	daniel@iogearbox.net,
	pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	zyc199902@zohomail.cn,
	lrGerlinde@mailfence.com,
	jschung2@proton.me,
	Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH net 6/6] selftests/tc-testing: Add netem/mirred test cases exercising loops
Date: Sun, 11 Jan 2026 11:39:47 -0500
Message-Id: <20260111163947.811248-7-jhs@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260111163947.811248-1-jhs@mojatatu.com>
References: <20260111163947.811248-1-jhs@mojatatu.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Victor Nogueira <victor@mojatatu.com>

Add mirred loop test cases to validate that those will be caught and other
test cases that were previously misinterpreted as loops by mirred.
Also add a netem nested duplicate test case to validate that it won't
cause an infinite loop

This commit adds 14 test cases:

- Redirect multiport: dummy egress -> dev1 ingress -> dummy egress (Loop)
- Redirect multiport: dev1 ingress -> dev1 egress -> dev1 ingress (Loop)
- Redirect multiport: dev1 ingress -> dummy ingress -> dev1 egress (No Loop)
- Redirect multiport: dev1 ingress -> dummy ingress -> dev1 ingress (Loop)
- Redirect multiport: dev1 ingress -> dummy egress -> dev1 ingress (Loop)
- Redirect multiport: dummy egress -> dev1 ingress -> dummy egress (Loop)
- Redirect multiport: dev1 ingress -> dummy ingress -> dummy egress -> dev1 egress (No Loop)
- Redirect multiport: dev1 ingress -> dummy egress -> dev1 egress (No Loop)
- Redirect multiport: dev1 ingress -> dummy egress -> dev1 egress (No Loop)
- Redirect multiport: dev1 ingress -> dummy egress -> dummy ingress (No Loop)
- Redirect singleport: dev1 ingress -> dev1 ingress (Loop)
- Redirect singleport: dummy egress -> dummy ingress (No Loop)
- Redirect multiport: dev1 ingress -> dummy ingress -> dummy egress (No Loop)
- Test netem's recursive duplicate

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
---
 .../tc-testing/tc-tests/actions/mirred.json   | 616 +++++++++++++++++-
 .../tc-testing/tc-tests/qdiscs/netem.json     |  33 +-
 2 files changed, 647 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/mirred.json b/tools/testing/selftests/tc-testing/tc-tests/actions/mirred.json
index b056eb966871..9eb32cdf1ed3 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/mirred.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/mirred.json
@@ -1144,6 +1144,620 @@
         "teardown": [
             "$TC qdisc del dev $DUMMY clsact"
         ]
+    },
+    {
+        "id": "531c",
+        "name": "Redirect multiport: dummy egress -> dev1 ingress -> dummy egress (Loop)",
+        "category": [
+            "filter",
+            "mirred"
+        ],
+        "plugins": {
+            "requires": [
+                "nsPlugin"
+            ]
+        },
+        "setup": [
+            "$IP link set dev $DUMMY up || true",
+            "$IP addr add 10.10.10.10/24 dev $DUMMY || true",
+            "$TC qdisc add dev $DUMMY clsact",
+            "$TC filter add dev $DUMMY egress protocol ip prio 10 matchall action mirred ingress redirect dev $DEV1 index 1",
+            "$TC qdisc add dev $DEV1 clsact",
+            "$TC filter add dev $DEV1 ingress protocol ip prio 10 matchall action mirred egress redirect dev $DUMMY index 2"
+        ],
+        "cmdUnderTest": "ping -c1 -W0.01 -I $DUMMY 10.10.10.1",
+        "expExitCode": "1",
+        "verifyCmd": "$TC -j -s actions get action mirred index 1",
+        "matchJSON": [
+            {
+                "total acts": 0
+            },
+            {
+                "actions": [
+                    {
+                        "order": 1,
+                        "kind": "mirred",
+                        "mirred_action": "redirect",
+                        "direction": "ingress",
+                        "index": 1,
+                        "stats": {
+                            "packets": 3
+                        },
+                        "not_in_hw": true
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            "$TC qdisc del dev $DUMMY clsact",
+            "$TC qdisc del dev $DEV1 clsact"
+        ]
+    },
+    {
+        "id": "b1d7",
+        "name": "Redirect multiport: dev1 ingress -> dev1 egress -> dev1 ingress (Loop)",
+        "category": [
+            "filter",
+            "mirred"
+        ],
+        "plugins": {
+            "requires": [
+                "nsPlugin",
+                "scapyPlugin"
+            ]
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 clsact",
+            "$TC filter add dev $DEV1 ingress protocol ip prio 10 matchall action mirred egress redirect dev $DEV1 index 1"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 egress protocol ip prio 11 matchall action mirred ingress redirect dev $DEV1 index 2",
+        "scapy": [
+            {
+                "iface": "$DEV0",
+                "count": 1,
+                "packet": "Ether()/IP(dst='10.10.10.1', src='10.10.10.10')/ICMP()"
+            }
+        ],
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j -s actions get action mirred index 1",
+        "matchJSON": [
+            {
+                "total acts": 0
+            },
+            {
+                "actions": [
+                    {
+                        "order": 1,
+                        "kind": "mirred",
+                        "mirred_action": "redirect",
+                        "direction": "egress",
+                        "index": 1,
+                        "stats": {
+                            "packets": 3
+                        },
+                        "not_in_hw": true
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            "$TC qdisc del dev $DEV1 clsact"
+        ]
+    },
+    {
+        "id": "c66d",
+        "name": "Redirect multiport: dev1 ingress -> dummy ingress -> dev1 egress (No Loop)",
+        "category": [
+            "filter",
+            "mirred"
+        ],
+        "plugins": {
+            "requires": [
+                "nsPlugin",
+                "scapyPlugin"
+            ]
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 clsact",
+            "$TC filter add dev $DEV1 ingress protocol ip prio 10 matchall action mirred ingress redirect dev $DUMMY index 1",
+            "$TC qdisc add dev $DUMMY clsact"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DUMMY ingress protocol ip prio 11 matchall action mirred egress redirect dev $DEV1 index 2",
+        "scapy": [
+            {
+                "iface": "$DEV0",
+                "count": 1,
+                "packet": "Ether()/IP(dst='10.10.10.1', src='10.10.10.10')/ICMP()"
+            }
+        ],
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j -s actions get action mirred index 1",
+        "matchJSON": [
+            {
+                "total acts": 0
+            },
+            {
+                "actions": [
+                    {
+                        "order": 1,
+                        "kind": "mirred",
+                        "mirred_action": "redirect",
+                        "direction": "ingress",
+                        "index": 1,
+                        "stats": {
+                            "packets": 1
+                        },
+                        "not_in_hw": true
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            "$TC qdisc del dev $DEV1 clsact",
+            "$TC qdisc del dev $DUMMY clsact"
+        ]
+    },
+    {
+        "id": "aa99",
+        "name": "Redirect multiport: dev1 ingress -> dummy ingress -> dev1 ingress (Loop)",
+        "category": [
+            "filter",
+            "mirred"
+        ],
+        "plugins": {
+            "requires": [
+                "nsPlugin",
+                "scapyPlugin"
+            ]
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 clsact",
+            "$TC filter add dev $DEV1 ingress protocol ip prio 10 matchall action mirred ingress redirect dev $DUMMY index 1",
+            "$TC qdisc add dev $DUMMY clsact"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DUMMY ingress protocol ip prio 11 matchall action mirred ingress redirect dev $DEV1 index 2",
+        "scapy": [
+            {
+                "iface": "$DEV0",
+                "count": 1,
+                "packet": "Ether()/IP(dst='10.10.10.1', src='10.10.10.10')/ICMP()"
+            }
+        ],
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j -s actions get action mirred index 1",
+        "matchJSON": [
+            {
+                "total acts": 0
+            },
+            {
+                "actions": [
+                    {
+                        "order": 1,
+                        "kind": "mirred",
+                        "mirred_action": "redirect",
+                        "direction": "ingress",
+                        "index": 1,
+                        "stats": {
+                            "packets": 2,
+                            "overlimits": 1
+                        },
+                        "not_in_hw": true
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            "$TC qdisc del dev $DEV1 clsact",
+            "$TC qdisc del dev $DUMMY clsact"
+        ]
+    },
+    {
+        "id": "37d7",
+        "name": "Redirect multiport: dev1 ingress -> dummy egress -> dev1 ingress (Loop)",
+        "category": [
+            "filter",
+            "mirred"
+        ],
+        "plugins": {
+            "requires": [
+                "nsPlugin",
+                "scapyPlugin"
+            ]
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 clsact",
+            "$TC filter add dev $DEV1 ingress protocol ip prio 10 matchall action mirred egress redirect dev $DUMMY index 1",
+            "$TC qdisc add dev $DUMMY clsact"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DUMMY egress protocol ip prio 11 matchall action mirred ingress redirect dev $DEV1 index 2",
+        "scapy": [
+            {
+                "iface": "$DEV0",
+                "count": 1,
+                "packet": "Ether()/IP(dst='10.10.10.1', src='10.10.10.10')/ICMP()"
+            }
+        ],
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j -s actions get action mirred index 1",
+        "matchJSON": [
+            {
+                "total acts": 0
+            },
+            {
+                "actions": [
+                    {
+                        "order": 1,
+                        "kind": "mirred",
+                        "mirred_action": "redirect",
+                        "direction": "egress",
+                        "index": 1,
+                        "stats": {
+                            "packets": 3
+                        },
+                        "not_in_hw": true
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            "$TC qdisc del dev $DEV1 clsact",
+            "$TC qdisc del dev $DUMMY clsact"
+        ]
+    },
+    {
+        "id": "6d02",
+        "name": "Redirect multiport: dummy egress -> dev1 ingress -> dummy egress (Loop)",
+        "category": [
+            "filter",
+            "mirred"
+        ],
+        "plugins": {
+            "requires": [
+                "nsPlugin"
+            ]
+        },
+        "setup": [
+            "$IP link set dev $DUMMY up || true",
+            "$IP addr add 10.10.10.10/24 dev $DUMMY || true",
+            "$TC qdisc add dev $DUMMY clsact",
+            "$TC filter add dev $DUMMY egress protocol ip prio 10 matchall action mirred ingress redirect dev $DEV1 index 1",
+            "$TC qdisc add dev $DEV1 clsact",
+            "$TC filter add dev $DEV1 ingress protocol ip prio 11 matchall action mirred egress redirect dev $DUMMY index 2"
+        ],
+        "cmdUnderTest": "ping -c1 -W0.01 -I $DUMMY 10.10.10.1",
+        "expExitCode": "1",
+        "verifyCmd": "$TC -j -s actions get action mirred index 1",
+        "matchJSON": [
+            {
+                "total acts": 0
+            },
+            {
+                "actions": [
+                    {
+                        "order": 1,
+                        "kind": "mirred",
+                        "mirred_action": "redirect",
+                        "direction": "ingress",
+                        "index": 1,
+                        "stats": {
+                            "packets": 3
+                        },
+                        "not_in_hw": true
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            "$TC qdisc del dev $DUMMY clsact",
+            "$TC qdisc del dev $DEV1 clsact"
+        ]
+    },
+    {
+        "id": "8115",
+        "name": "Redirect multiport: dev1 ingress -> dummy ingress -> dummy egress -> dev1 egress (No Loop)",
+        "category": [
+            "filter",
+            "mirred"
+        ],
+        "plugins": {
+            "requires": [
+                "nsPlugin",
+                "scapyPlugin"
+            ]
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 clsact",
+            "$TC filter add dev $DEV1 ingress protocol ip prio 10 matchall action mirred ingress redirect dev $DUMMY index 1",
+            "$TC qdisc add dev $DUMMY clsact",
+            "$TC filter add dev $DUMMY ingress protocol ip prio 11 matchall action mirred egress redirect dev $DUMMY index 2"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DUMMY egress protocol ip prio 12 matchall action mirred egress redirect dev $DEV1 index 3",
+        "scapy": [
+            {
+                "iface": "$DEV0",
+                "count": 1,
+                "packet": "Ether()/IP(dst='10.10.10.1', src='10.10.10.10')/ICMP()"
+            }
+        ],
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j -s actions get action mirred index 1",
+        "matchJSON": [
+            {
+                "total acts": 0
+            },
+            {
+                "actions": [
+                    {
+                        "order": 1,
+                        "kind": "mirred",
+                        "mirred_action": "redirect",
+                        "direction": "ingress",
+                        "index": 1,
+                        "stats": {
+                            "packets": 1
+                        },
+                        "not_in_hw": true
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            "$TC qdisc del dev $DEV1 clsact",
+            "$TC qdisc del dev $DUMMY clsact"
+        ]
+    },
+    {
+        "id": "9eb3",
+        "name": "Redirect multiport: dev1 ingress -> dummy egress -> dev1 egress (No Loop)",
+        "category": [
+            "filter",
+            "mirred"
+        ],
+        "plugins": {
+            "requires": [
+                "nsPlugin",
+                "scapyPlugin"
+            ]
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 clsact",
+            "$TC filter add dev $DEV1 ingress protocol ip prio 10 matchall action mirred egress redirect dev $DUMMY index 1",
+            "$TC qdisc add dev $DUMMY clsact"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DUMMY egress protocol ip prio 11 matchall action mirred egress redirect dev $DEV1 index 2",
+        "scapy": [
+            {
+                "iface": "$DEV0",
+                "count": 1,
+                "packet": "Ether()/IP(dst='10.10.10.1', src='10.10.10.10')/ICMP()"
+            }
+        ],
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j -s actions get action mirred index 1",
+        "matchJSON": [
+            {
+                "total acts": 0
+            },
+            {
+                "actions": [
+                    {
+                        "order": 1,
+                        "kind": "mirred",
+                        "mirred_action": "redirect",
+                        "direction": "egress",
+                        "index": 1,
+                        "stats": {
+                            "packets": 1
+                        },
+                        "not_in_hw": true
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            "$TC qdisc del dev $DEV1 clsact",
+            "$TC qdisc del dev $DUMMY clsact"
+        ]
+    },
+    {
+        "id": "d837",
+        "name": "Redirect multiport: dev1 ingress -> dummy egress -> dummy ingress (No Loop)",
+        "category": [
+            "filter",
+            "mirred"
+        ],
+        "plugins": {
+            "requires": [
+                "nsPlugin",
+                "scapyPlugin"
+            ]
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 clsact",
+            "$TC filter add dev $DEV1 ingress protocol ip prio 10 matchall action mirred egress redirect dev $DUMMY index 1",
+            "$TC qdisc add dev $DUMMY clsact"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DUMMY egress protocol ip prio 11 matchall action mirred ingress redirect dev $DUMMY index 2",
+        "scapy": [
+            {
+                "iface": "$DEV0",
+                "count": 1,
+                "packet": "Ether()/IP(dst='10.10.10.1', src='10.10.10.10')/ICMP()"
+            }
+        ],
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j -s actions get action mirred index 1",
+        "matchJSON": [
+            {
+                "total acts": 0
+            },
+            {
+                "actions": [
+                    {
+                        "order": 1,
+                        "kind": "mirred",
+                        "mirred_action": "redirect",
+                        "direction": "egress",
+                        "index": 1,
+                        "stats": {
+                            "packets": 1
+                        },
+                        "not_in_hw": true
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            "$TC qdisc del dev $DEV1 clsact",
+            "$TC qdisc del dev $DUMMY clsact"
+        ]
+    },
+    {
+        "id": "2071",
+        "name": "Redirect multiport: dev1 ingress -> dev1 ingress (Loop)",
+        "category": [
+            "filter",
+            "mirred"
+        ],
+        "plugins": {
+            "requires": [
+                "nsPlugin",
+                "scapyPlugin"
+            ]
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 clsact"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 ingress protocol ip prio 10 matchall action mirred ingress redirect dev $DEV1 index 1",
+        "scapy": [
+            {
+                "iface": "$DEV0",
+                "count": 1,
+                "packet": "Ether()/IP(dst='10.10.10.1', src='10.10.10.10')/ICMP()"
+            }
+        ],
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j -s actions get action mirred index 1",
+        "matchJSON": [
+            {
+                "total acts": 0
+            },
+            {
+                "actions": [
+                    {
+                        "order": 1,
+                        "kind": "mirred",
+                        "mirred_action": "redirect",
+                        "direction": "ingress",
+                        "index": 1,
+                        "stats": {
+                            "packets": 1,
+                            "overlimits": 1
+                        },
+                        "not_in_hw": true
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            "$TC qdisc del dev $DEV1 clsact"
+        ]
+    },
+    {
+        "id": "0101",
+        "name": "Redirect singleport: dummy egress -> dummy ingress (No Loop)",
+        "category": [
+            "filter",
+            "mirred"
+        ],
+        "plugins": {
+            "requires": [
+                "nsPlugin"
+            ]
+        },
+        "setup": [
+            "$IP addr add 10.10.10.10/24 dev $DUMMY || true",
+            "$TC qdisc add dev $DUMMY clsact",
+            "$TC filter add dev $DUMMY egress protocol ip prio 11 matchall action mirred ingress redirect dev $DUMMY index 1"
+        ],
+        "cmdUnderTest": "ping -c1 -W0.01 -I $DUMMY 10.10.10.1",
+        "expExitCode": "1",
+        "verifyCmd": "$TC -j -s actions get action mirred index 1",
+        "matchJSON": [
+            {
+                "total acts": 0
+            },
+            {
+                "actions": [
+                    {
+                        "order": 1,
+                        "kind": "mirred",
+                        "mirred_action": "redirect",
+                        "direction": "ingress",
+                        "index": 1,
+                        "stats": {
+                            "packets": 1
+                        },
+                        "not_in_hw": true
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            "$TC qdisc del dev $DUMMY clsact"
+        ]
+    },
+    {
+        "id": "cf97",
+        "name": "Redirect multiport: dev1 ingress -> dummy ingress -> dummy egress (No Loop)",
+        "category": [
+            "filter",
+            "mirred"
+        ],
+        "plugins": {
+            "requires": [
+                "nsPlugin",
+                "scapyPlugin"
+            ]
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 clsact",
+            "$TC filter add dev $DEV1 ingress protocol ip prio 10 matchall action mirred ingress redirect dev $DUMMY index 1",
+            "$TC qdisc add dev $DUMMY clsact"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DUMMY ingress protocol ip prio 11 matchall action mirred egress redirect dev $DUMMY index 2",
+        "scapy": [
+            {
+                "iface": "$DEV0",
+                "count": 1,
+                "packet": "Ether()/IP(dst='10.10.10.1', src='10.10.10.10')/ICMP()"
+            }
+        ],
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j -s actions get action mirred index 1",
+        "matchJSON": [
+            {
+                "total acts": 0
+            },
+            {
+                "actions": [
+                    {
+                        "order": 1,
+                        "kind": "mirred",
+                        "mirred_action": "redirect",
+                        "direction": "ingress",
+                        "index": 1,
+                        "stats": {
+                            "packets": 1
+                        },
+                        "not_in_hw": true
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            "$TC qdisc del dev $DEV1 clsact",
+            "$TC qdisc del dev $DUMMY clsact"
+        ]
     }
-
 ]
diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/netem.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/netem.json
index 3c4444961488..7c954989069d 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/netem.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/netem.json
@@ -336,5 +336,36 @@
         "teardown": [
             "$TC qdisc del dev $DUMMY handle 1: root"
         ]
-    }
+    },
+    {
+        "id": "8c17",
+        "name": "Test netem's recursive duplicate",
+        "category": [
+            "qdisc",
+            "netem"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link set dev $DUMMY up || true",
+            "$IP addr add 10.10.11.10/24 dev $DUMMY || true",
+            "$TC qdisc add dev $DUMMY root handle 1: netem limit 1 duplicate 100%",
+            "$TC qdisc add dev $DUMMY parent 1: handle 2: netem duplicate 100%"
+        ],
+        "cmdUnderTest": "ping -c 1 10.10.11.11 -W 0.01",
+        "expExitCode": "1",
+        "verifyCmd": "$TC -s -j qdisc ls dev $DUMMY root",
+        "matchJSON": [
+            {
+                "kind": "netem",
+                "handle": "1:",
+                "bytes": 294,
+                "packets": 3
+            }
+        ],
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root"
+        ]
+     }
 ]
-- 
2.34.1

