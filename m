Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80D834CFB9
	for <netfilter-devel@vger.kernel.org>; Sun, 11 Jan 2026 16:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768149615; cv=none; b=T+vj9FPFaqTvtKErzObOaKhP66DqWHcAMEeHPzck4+E/UBk9F+sKJ5xsxUxN5tEGF+CXp6Z8Or3+NJ0K0ptg2ChsAU8YLuHeAhjH+LApEeGVptV4KF/ihB3eleo2blblBX/umLwT6tvfiOepqXH4f35+drciqdx0xeG3ov31UOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768149615; c=relaxed/simple;
	bh=qx55ooV+6T11EKr8LbEY4/9pXwPSeq3Qn7aMejeFIXc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=F24P0GIv8va8hV0TyU0iyILxWiwsCz9FYPg2fb7z6UtvuOtz7323ztnkrSdMThMubaKB3pkp0KylGJkhyKB8N6Hp8dWSpF3gFN2gGV/FxvkYt+4JwkWheAC3Y/SmHPfPHuo1bbhZVMpCqHsJk2ZkILwgjfYrnW1nVZSIEuT8y+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b=rWSTekkk; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b="rWSTekkk"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8b2148ca40eso827134985a.1
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Jan 2026 08:40:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20230601.gappssmtp.com; s=20230601; t=1768149612; x=1768754412; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NBtIV/EG4mn9wrmEQoCttsPhqLjU58BaxF1sqnJtk6U=;
        b=rWSTekkkwErRWnd0R/TglB2dusn0PwCitMmiW3c2CDNK/6bCDzhzdY5xzeYeFvdCOe
         xofMPQX4k+QSgS3C1+G9E/SialECEUn3LHxXCx+/51UirO3GKwmxVqlRKd6fllDLoLzy
         EB2XrUZ7LFY4ELzELY0f+D3JAcwyyWet7IuJV4XeRTQH3H9xNDHkBz5XyHVHuUOG8Ez9
         nc5fgnPUvB8sT3Eol0n0zhwv7D/nED352fXrovc1ZcLXlWtJsV1YEtJvxoBOv+JfcVQ+
         826IcW1vPEuJ0qD9zzO3PdppDVy+/mc4rCfdR82TZ1VGA/cBsLHCgd5tSGwuzBjNaU6D
         ajSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768149612; x=1768754412;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NBtIV/EG4mn9wrmEQoCttsPhqLjU58BaxF1sqnJtk6U=;
        b=kbFM0q5uRxZr9kce2E/+TGk8Ooxs9yjoeDvC1Vja4rw5YeGurPbqJqPYO0/2RGEidK
         9vZTY1uFsUr5tfzIw4+uo4GWBKJv2qfp9C2acRDXWvz4Qu2QJ7rYgRXnwmBWAvfg3x4D
         jwDCefvnVPx+j3RPu4O5Y32a0w6ZQQrfqfEIYAo0kxYPvkw0lVBiKXeW2NBjrSksT9wE
         wbtHmVl86Lo8ozNa/pHbwM178IzQF7CutQLDFwd9MVZlwhuZn2zOvFICRwrD2xjThLFA
         SlY2aqedJaLyPMNn5V7mUCPjPqZTnmsIuHRJcx+dWCr5lNqPWCTen9pdz9pSdJlTgYJD
         ktlQ==
X-Forwarded-Encrypted: i=1; AJvYcCXArZ1wZb05CO8oSHct2hPRAi12Rz+/wyTLnqgQ1slJUmvQwHzbAUaYk+1+WiCOdyEmKjB5zt/STPZ+Ny92dZU=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywjj8yZO6LK72U7od9kxpMYmkFvYmFkOiJenYGq8JLobMYDB3fN
	TV+T4sugnBjv6LqbXqh9nAfxJdYntBtxsss5H/VOa0DYND6p4iVxpuGeTFVWoDoALA==
X-Gm-Gg: AY/fxX6d2vcFVIHxMiSuyV8PXzDj/8GvWizc9+OZwJRhVV2DShTVto5xS8wkl87odvf
	CdS5OjWcsYeWX+nDSg8LsTe4YmVVV39pxzgE3YuGQnLuuvA2VOfAGg+csILSswZBeY4hVSeqJNI
	MvN9kMPCKNeYB7mlIIF7MKzj+WHf1085rmTv18yld7nHqcLaRniSWhC5Ub/zwV1GsA/17VKJ/Pd
	Lpk/JqQm22g4m5hK1l3Df32ijAq+pl7E66f4fvrerVt0Ovgw9SmANtYhI4whun59lv0bAX78MRG
	wCYMDWm3cB5XJSD6j8NvHtBoVjCxKCLMy7jDsgsvcjmiWlIu3kP7O60uPHJw1BTnVYO/3T6HiZd
	Oq7lhFlgVjAgRoX741gtzikrYLc1uIVmFmkB+cesK0Jci6wzaYB1ES+ySonFU15e3e6r5FgL/pi
	TSuBE22Q+UofU=
X-Google-Smtp-Source: AGHT+IGDqNb3NahWywwQdRkRuPYhE2RD+hcRC/vcvexYRUTidf/458a8FA7EixcA0lJQ59K4ToJUmA==
X-Received: by 2002:a05:620a:2807:b0:8b5:5a03:36e3 with SMTP id af79cd13be357-8c38936c4e7mr2312246785a.16.1768149611741;
        Sun, 11 Jan 2026 08:40:11 -0800 (PST)
Received: from majuu.waya ([70.50.89.69])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c37f4a8956sm1276589085a.10.2026.01.11.08.40.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jan 2026 08:40:11 -0800 (PST)
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
Subject: [PATCH net 4/6] Revert "selftests/tc-testing: Add tests for restrictions on netem duplication"
Date: Sun, 11 Jan 2026 11:39:45 -0500
Message-Id: <20260111163947.811248-5-jhs@mojatatu.com>
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

This reverts commit ecdec65ec78d67d3ebd17edc88b88312054abe0d.

Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 .../tc-testing/tc-tests/infra/qdiscs.json     |  5 +-
 .../tc-testing/tc-tests/qdiscs/netem.json     | 81 -------------------
 2 files changed, 3 insertions(+), 83 deletions(-)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/infra/qdiscs.json b/tools/testing/selftests/tc-testing/tc-tests/infra/qdiscs.json
index 6a39640aa2a8..ceb993ed04b2 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/infra/qdiscs.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/infra/qdiscs.json
@@ -702,6 +702,7 @@
             "$TC qdisc add dev $DUMMY parent 1:1 handle 2:0 netem duplicate 100%",
             "$TC filter add dev $DUMMY parent 1:0 protocol ip prio 1 u32 match ip dst 10.10.10.1/32 flowid 1:1",
             "$TC class add dev $DUMMY parent 1:0 classid 1:2 hfsc ls m2 10Mbit",
+            "$TC qdisc add dev $DUMMY parent 1:2 handle 3:0 netem duplicate 100%",
             "$TC filter add dev $DUMMY parent 1:0 protocol ip prio 2 u32 match ip dst 10.10.10.2/32 flowid 1:2",
             "ping -c 1 10.10.10.1 -I$DUMMY > /dev/null || true",
             "$TC filter del dev $DUMMY parent 1:0 protocol ip prio 1",
@@ -714,8 +715,8 @@
             {
                 "kind": "hfsc",
                 "handle": "1:",
-                "bytes": 294,
-                "packets": 3
+                "bytes": 392,
+                "packets": 4
             }
         ],
         "matchCount": "1",
diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/netem.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/netem.json
index 718d2df2aafa..3c4444961488 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/netem.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/netem.json
@@ -336,86 +336,5 @@
         "teardown": [
             "$TC qdisc del dev $DUMMY handle 1: root"
         ]
-    },
-    {
-        "id": "d34d",
-        "name": "NETEM test qdisc duplication restriction in qdisc tree in netem_change root",
-        "category": ["qdisc", "netem"],
-        "plugins": {
-            "requires": "nsPlugin"
-        },
-        "setup": [
-            "$TC qdisc add dev $DUMMY root handle 1: netem limit 1",
-            "$TC qdisc add dev $DUMMY parent 1: handle 2: netem limit 1"
-        ],
-        "cmdUnderTest": "$TC qdisc change dev $DUMMY handle 1: netem duplicate 50%",
-        "expExitCode": "2",
-        "verifyCmd": "$TC -s qdisc show dev $DUMMY",
-        "matchPattern": "qdisc netem",
-        "matchCount": "2",
-        "teardown": [
-            "$TC qdisc del dev $DUMMY handle 1:0 root"
-        ]
-    },
-    {
-        "id": "b33f",
-        "name": "NETEM test qdisc duplication restriction in qdisc tree in netem_change non-root",
-        "category": ["qdisc", "netem"],
-        "plugins": {
-            "requires": "nsPlugin"
-        },
-        "setup": [
-            "$TC qdisc add dev $DUMMY root handle 1: netem limit 1",
-            "$TC qdisc add dev $DUMMY parent 1: handle 2: netem limit 1"
-        ],
-        "cmdUnderTest": "$TC qdisc change dev $DUMMY handle 2: netem duplicate 50%",
-        "expExitCode": "2",
-        "verifyCmd": "$TC -s qdisc show dev $DUMMY",
-        "matchPattern": "qdisc netem",
-        "matchCount": "2",
-        "teardown": [
-            "$TC qdisc del dev $DUMMY handle 1:0 root"
-        ]
-    },
-    {
-        "id": "cafe",
-        "name": "NETEM test qdisc duplication restriction in qdisc tree",
-        "category": ["qdisc", "netem"],
-        "plugins": {
-            "requires": "nsPlugin"
-        },
-        "setup": [
-            "$TC qdisc add dev $DUMMY root handle 1: netem limit 1 duplicate 100%"
-        ],
-        "cmdUnderTest": "$TC qdisc add dev $DUMMY parent 1: handle 2: netem duplicate 100%",
-        "expExitCode": "2",
-        "verifyCmd": "$TC -s qdisc show dev $DUMMY",
-        "matchPattern": "qdisc netem",
-        "matchCount": "1",
-        "teardown": [
-            "$TC qdisc del dev $DUMMY handle 1:0 root"
-        ]
-    },
-    {
-        "id": "1337",
-        "name": "NETEM test qdisc duplication restriction in qdisc tree across branches",
-        "category": ["qdisc", "netem"],
-        "plugins": {
-            "requires": "nsPlugin"
-        },
-        "setup": [
-            "$TC qdisc add dev $DUMMY parent root handle 1:0 hfsc",
-            "$TC class add dev $DUMMY parent 1:0 classid 1:1 hfsc rt m2 10Mbit",
-            "$TC qdisc add dev $DUMMY parent 1:1 handle 2:0 netem",
-            "$TC class add dev $DUMMY parent 1:0 classid 1:2 hfsc rt m2 10Mbit"
-        ],
-        "cmdUnderTest": "$TC qdisc add dev $DUMMY parent 1:2 handle 3:0 netem duplicate 100%",
-        "expExitCode": "2",
-        "verifyCmd": "$TC -s qdisc show dev $DUMMY",
-        "matchPattern": "qdisc netem",
-        "matchCount": "1",
-        "teardown": [
-            "$TC qdisc del dev $DUMMY handle 1:0 root"
-        ]
     }
 ]
-- 
2.34.1

