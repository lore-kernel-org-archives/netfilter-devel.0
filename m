Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704EE26AC3
	for <netfilter-devel@vger.kernel.org>; Sat,  8 Aug 2026 01:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786152813; cv=none; b=FxhCuXcOTZeqdOaucdYsA+CZLFA7REvygz2rNEXSF6ydN1Wk7I1n464Du1C9wj+i4mV5BUCfviUhX0Q/bkFhLDuc9rBIur8NVJwT9soBKzHcKvT52nd+eFpz0Uw7UJlL5Cf5a4E00Y+UHxHlzAOzKrh8fTyAo15z+oopzWbuG0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786152813; c=relaxed/simple;
	bh=CQZydE/CEjjEjCbQzv1Jupp7nvuRypMcRCritcg7L4o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z6FEWYb8EadKQHTUsugWq0zaPpCKcQEna+TTPaFOaX+AS2rWAAsSDAcyRibbUvAzziJMuWsOFmtVHDVsLh+2Mou8jsb1r3LlWUjqJzV9dfQQ3qSHIyTM51/5xF0NyyGS/+WH6bnAP4DjgmYzs4H8wRrUcQJLa2Rj1go4+9PzvuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MNPuHOlU; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MNPuHOlU"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-38fdeaed181so147208a91.1
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Aug 2026 18:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786152812; x=1786757612; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ebDQ8eacTaBTOc8nyoU6iNag7ccTAIoX2lG0pzfgOw8=;
        b=MNPuHOlUDDxSrhQP3yocFEqfAUpckzrVmrN756CLJIAFtHzgG5Fsi2gDw4NDtltSXS
         K/4uSaTOnhBIJBpsocVhR+o9KhLLGHjo/GP5T2A4nEQwcuurgJAbUxcspHc99JkAZ2OG
         N6q2oIzo0h8qxE5HczBwgHTWvbf2IkAlMX6ZO/S6kAPgxk3uxCp+1WeSa/yuyJba9hjF
         YN99SW7SQgjZ6BysLTrDTGRKMNrN40lK9UguLlOpS2EsfrK0PS9LjCoSDZ4PkO+O6ljP
         OaDeGCjPCGoI4a8EFspPaeBpystflWP9ziD5/Q2cXDaqZE10FSYj0M4OH/cwd+HRI/C/
         ZlVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786152812; x=1786757612;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ebDQ8eacTaBTOc8nyoU6iNag7ccTAIoX2lG0pzfgOw8=;
        b=Vm8s8whbyfiDx26csKGf3FVHehfqTlODdEEFhBtBLGA24HqmgclXuFQR1HCYOoko3d
         HpDXrYywdfSP8Gf6vNf6Wubvwpoz2vdyfMg3/KcbqRo2d/dHg3P8an0iglE1tAelcThd
         tVXTvE/z2+MbwyGeq3oEaqY4wgeAzCsqhUj3soxWfdUhD0UcEmeP9d9sgFJbsx0bTkjR
         YAT6Ks3G3j0bwNQeveVb87zZT3v4z59iNN9rmcIbzYxCSME89Ln+iZt8CzYjNSqaK5C3
         ggicPZqHt9gWKyAjVRYhWjQs0qlN6ts1cAUSWhNX+z6rR5cnmhClT2/VyKgcSuLQ94b6
         oAaw==
X-Gm-Message-State: AOJu0YzEefGwQ34mIAsAMNKyR80VwAVeemVMW3P0JWt18sKs2uNbMvy5
	lqV4fWYtlr+IK9+VPNeAooDymDTDoSY+BHBCf6dZxs5g7qulB8M/pigqvu5gz4fA
X-Gm-Gg: AR+sD11u2jonM3+i/LqU6gwnJ54tIhzZPfWZXO6gnoMxpATebbZ4ZXJ4nNQ8cQb81qv
	UeKpkAWtxPu8VLxESv3mwjtsQ4GC6xiB/fo5HYF1/JrLNot46oKsUW3xAx50jUjCk4g1/CFFa7G
	ZFLLfsgkHn3efKMIYiFkdw7BO3yGXplHEunV4c8N9otBtFFBnS//Y1mMXCryxzVmuuTKiQREB1B
	vXSgdjYWCyReB/Qw+rodQ+ZESJkjSEnnCj/pqZN+Jpfeh48zuCSmNjA+cYVjTQPWUjm7QLI9/2R
	9nDKJ6DjIq+bzMJAIZiV0s8Vv3Ax2SqFLM7/GWEqmt0Mdhv9QPatQXpcjpfzs5UU73/87CrFhlw
	iiyfKfcaxWf5jB10+iGfxBnp1LKrDs8y+7/lLArDc2J2iRb0Xm9riP6lEKLcSA35zipvQHlqnFd
	/jMNcmuwgc+xEDS7vH0L5xravQHnNEoxFynzRieEaazXBvmXOkzxfH7jl6Mkzn781FpSGWRX5gP
	gq/SmgAu0ib199R52DnLVjbjT6GDKmp2eg=
X-Received: by 2002:a17:90b:5683:b0:38e:6aa7:68ad with SMTP id 98e67ed59e1d1-3903c54fbc4mr27456316a91.5.1786152811789;
        Fri, 07 Aug 2026 18:33:31 -0700 (PDT)
Received: from r912.tailbb6e1e.ts.net ([160.30.85.32])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315beb88413sm19360205eec.18.2026.08.07.18.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 18:33:31 -0700 (PDT)
From: Avinash Duduskar <avinash.duduskar@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft] tests: shell: use an unassigned protocol number in exclusive_start_cond
Date: Sat,  8 Aug 2026 07:03:27 +0530
Message-ID: <20260808013327.2766739-1-avinash.duduskar@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nft renders nexthdr through getprotobynumber(), so the dump records whichever
name the host's /etc/protocols gives for the value. 0 is "ip" on Debian, which
carries the legacy alias ahead of hopopt, and "hopopt" where /etc/protocols is
generated from the IANA registry, which assigns only HOPOPT. The test fails
there, and the dump cannot be reloaded either, because getprotobyname("ip")
finds nothing.

200 is unassigned in both, so it prints numerically everywhere. 255 would not
do: Arch's iana-etc names it "reserved".

Signed-off-by: Avinash Duduskar <avinash.duduskar@gmail.com>
---
 .../parsing/dumps/exclusive_start_cond.json-nft        | 10 +++++-----
 .../testcases/parsing/dumps/exclusive_start_cond.nft   | 10 +++++-----
 tests/shell/testcases/parsing/exclusive_start_cond     |  6 +++---
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/tests/shell/testcases/parsing/dumps/exclusive_start_cond.json-nft b/tests/shell/testcases/parsing/dumps/exclusive_start_cond.json-nft
index a1fbaafd..35d6889a 100644
--- a/tests/shell/testcases/parsing/dumps/exclusive_start_cond.json-nft
+++ b/tests/shell/testcases/parsing/dumps/exclusive_start_cond.json-nft
@@ -2207,7 +2207,7 @@
                   "field": "nexthdr"
                 }
               },
-              "right": "ip"
+              "right": 200
             }
           }
         ]
@@ -2247,7 +2247,7 @@
                   "field": "nexthdr"
                 }
               },
-              "right": "ip"
+              "right": 200
             }
           }
         ]
@@ -2407,7 +2407,7 @@
                   "field": "nexthdr"
                 }
               },
-              "right": "ip"
+              "right": 200
             }
           }
         ]
@@ -2447,7 +2447,7 @@
                   "field": "nexthdr"
                 }
               },
-              "right": "ip"
+              "right": 200
             }
           }
         ]
@@ -2487,7 +2487,7 @@
                   "field": "nexthdr"
                 }
               },
-              "right": "ip"
+              "right": 200
             }
           }
         ]
diff --git a/tests/shell/testcases/parsing/dumps/exclusive_start_cond.nft b/tests/shell/testcases/parsing/dumps/exclusive_start_cond.nft
index 2b94feaa..5eb28085 100644
--- a/tests/shell/testcases/parsing/dumps/exclusive_start_cond.nft
+++ b/tests/shell/testcases/parsing/dumps/exclusive_start_cond.nft
@@ -94,14 +94,14 @@ table ip t {
 table ip6 t {
 	chain c {
 		meta l4proto tcp limit rate 1/second burst 5 packets ip6 saddr ::
-		meta l4proto tcp limit rate 1/second burst 5 packets hbh nexthdr ip
-		meta l4proto tcp limit rate 1/second burst 5 packets rt nexthdr ip
+		meta l4proto tcp limit rate 1/second burst 5 packets hbh nexthdr 200
+		meta l4proto tcp limit rate 1/second burst 5 packets rt nexthdr 200
 		meta l4proto tcp limit rate 1/second burst 5 packets srh last-entry 0
 		meta l4proto tcp limit rate 1/second burst 5 packets srh sid[1] ::
 		meta l4proto tcp limit rate 1/second burst 5 packets srh tag 0
-		meta l4proto tcp limit rate 1/second burst 5 packets frag nexthdr ip
-		meta l4proto tcp limit rate 1/second burst 5 packets dst nexthdr ip
-		meta l4proto tcp limit rate 1/second burst 5 packets mh nexthdr ip
+		meta l4proto tcp limit rate 1/second burst 5 packets frag nexthdr 200
+		meta l4proto tcp limit rate 1/second burst 5 packets dst nexthdr 200
+		meta l4proto tcp limit rate 1/second burst 5 packets mh nexthdr 200
 		meta l4proto tcp limit rate 1/second burst 5 packets exthdr hbh missing
 	}
 }
diff --git a/tests/shell/testcases/parsing/exclusive_start_cond b/tests/shell/testcases/parsing/exclusive_start_cond
index f769e7dd..8c359d93 100755
--- a/tests/shell/testcases/parsing/exclusive_start_cond
+++ b/tests/shell/testcases/parsing/exclusive_start_cond
@@ -70,9 +70,9 @@ stmts+=("sctp sport 0" "th sport 0")
 udp_stmts+=("vxlan vni 0" "geneve vni 0")
 stmts+=("gre flags 0" "gretap ip saddr 0")
 # exthdr_expr
-ip6_stmts+=("hbh nexthdr 0" "rt nexthdr 0" "rt0 addr[0] 0")
-ip6_stmts+=("rt2 addr ::" "srh tag 0" "frag nexthdr 0")
-ip6_stmts+=("dst nexthdr 0" "mh nexthdr 0" "exthdr hbh 0")
+ip6_stmts+=("hbh nexthdr 200" "rt nexthdr 200" "rt0 addr[0] 0")
+ip6_stmts+=("rt2 addr ::" "srh tag 0" "frag nexthdr 200")
+ip6_stmts+=("dst nexthdr 200" "mh nexthdr 200" "exthdr hbh 0")
 # meta_expr
 stmts+=("meta length 0" "mark 0" "iif 0" "iifname foo" "iiftype 0")
 stmts+=("oif 0" "oifname foo" "oiftype 0" "skuid 0" "skgid 0" "rtclassid 0")

base-commit: 49e418238ece947e92f87a35ef6cf50755485370
-- 
2.55.0

