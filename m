Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68D42641CA
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Feb 2025 10:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740477754; cv=none; b=JnEofykRWN/ow2n3E0d9fK+MDR19Q419zIABHLnwYMtRPSAJNX/JwqlSw5GBsZrvO7tU0ztZ0/CJoYwtlt4kL7o8znle6AMux7LexCiIoIHtHRuLOMttdXp9H3yp4mhhiQWuE6g54gD3a/qRW8qjylE9NLkoWCfJtjaEvY6jDm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740477754; c=relaxed/simple;
	bh=YOzsteZl+MzjqNz0DU4DPnduw9bhLrbNM203UzioDzw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Pa18G5d92pE2qa0Nbpr787Tpvk/+2i0fEYhayFSIEHLDdFnXuwClsf+mn5iaejho9KVtwYbc7oUOIcFlSuZzLGiH364vgE+04oTzzoFexQJSIZ+7SElFjmqZwJA/+bx6rcwSYD3zY+fuzAKIJQWzFKjMQI4QnUpksTO3n2huutU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NxxRAcKH; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NxxRAcKH"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2211cd4463cso107852705ad.2
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Feb 2025 02:02:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740477752; x=1741082552; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=0cpRA4UjPqd2NWK5NQGlHdQEVZh1JEdezFVHhsZnAtE=;
        b=NxxRAcKHonc41CDta6NfzE89IPS7MUb4G5s3rg+OdfPzmcL1GKK6+FbTrmXFco4l27
         dTu5M4G4iUe4ezr5l6U4zs9N6l3x4UD/nznbUa0EWmwMpiRVp0pQmk2j6YNlC8RMPZYf
         JWO+6TR8VcoAKOJQelvU7dqdl4FPTtDLQ9kXEPQdhe7XUO891p7GynbJhiZvo6wyDvYw
         dt7JFBjv3OEcCwzemVi75vseq7dacDx+bBgta9ziN4oRcGZIH6ZZtmP/mypT21eVHZEP
         zYPZFGyTgJx7/VIIe+KqsRhEDN6LRuQBdFHWWhwLNMuxgv9kWo64WwvrdCW09Gfp0ed8
         uQlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740477752; x=1741082552;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0cpRA4UjPqd2NWK5NQGlHdQEVZh1JEdezFVHhsZnAtE=;
        b=X9Qzq5fb32SJrhYfA98NsJzsRlH3PzJBgepG8t1DDjXP3jd4R7367kRdHKmNDh3D+I
         qFxOkGbJr506UoKQiyv5AtwYvMDOE2PpOTNEvxx4C6eT7NX8SwnQWQOZDhavO3izyMHz
         Hu5CLFXgPr///hGv+RmIc/KGgPjfHoTU0iz/YcumsZzeML+pE64VuuJ2/kUqguddlzO4
         SafdbUWANVWBeaMpkHi9YlL3JOPXjltGP4L8BrubEAYUqQIInL22YJ8BtZBsDVZhKHUF
         4ku/GDCRQVDjdy7GNzijJ6FUoJ6xTnAzSH8fEtkye8yS5WPoptsSY0zp9l9T5znECYBs
         /f6w==
X-Gm-Message-State: AOJu0YxY+HLDt33TJQQUeZwWex5WO42g3cGa4NMd1yqKk7jB2++Dd+YJ
	kPGlHxZiqStSW0qHqaD4n+47OgyTPWhcF1hib96IJln2MofN6iOlfam52g==
X-Gm-Gg: ASbGncuKBbZBfVULwcj2nUplMkywRIoAoIBCDuA2JOp0Y7GPkdcTDpHy8lzSvhmpvmk
	3IbFxt2ba68mODTq3MEgyIVVuBb+5v4ttAwl+IJ5YTgaB+8oTzJsfWPDmW2xT7xt6ldyZsJjCTH
	BmX6dGjG8Fvsn6MPb6BoQ0wSITw+3YwTLy0squTjnHXpTCDTiPF3X6d3iImWAUDLzwDlS9Df8+y
	vuQibXAGv6OpULIOJVO1P+z669EBGRmcIB1xP4BrXVtSxnxlj2sGYxGJ21fW4a8/ld07SI/GXxX
	UAQ6hV/8gIpf0Xx8
X-Google-Smtp-Source: AGHT+IFR8Ei6JvLSpzRUmvdogEjQ2Q/FAO74/0r0+tR+jdulrhgiG/PHd4trqnFEGWqI5C8pjVy97A==
X-Received: by 2002:a17:903:2284:b0:216:2426:767f with SMTP id d9443c01a7336-22307e72782mr46117225ad.49.1740477751643;
        Tue, 25 Feb 2025 02:02:31 -0800 (PST)
Received: from ws.. ([103.167.140.11])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2230a0ae9c6sm10422135ad.219.2025.02.25.02.02.29
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 02:02:31 -0800 (PST)
From: Xiao Liang <shaw.leon@gmail.com>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] fib: Change data type of fib oifname to "ifname"
Date: Tue, 25 Feb 2025 18:02:17 +0800
Message-ID: <20250225100220.18931-1-shaw.leon@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change data type of fib oifname from "string" to "ifname", so that it
can be matched against a set of ifnames:

    set x {
            type ifname
    }
    chain y {
            fib saddr oifname @x drop
    }

Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
---
 doc/primary-expression.txt                                    | 4 ++--
 src/fib.c                                                     | 2 +-
 tests/shell/testcases/sets/0029named_ifname_dtype_0           | 1 +
 tests/shell/testcases/sets/dumps/0029named_ifname_dtype_0.nft | 1 +
 4 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/doc/primary-expression.txt b/doc/primary-expression.txt
index c6a33bbe..40aca3d3 100644
--- a/doc/primary-expression.txt
+++ b/doc/primary-expression.txt
@@ -354,10 +354,10 @@ address types can be shown with *nft* *describe* *fib_addrtype*.
 |Keyword| Description| Result Type
 |oif|
 Output interface index|
-integer (32 bit)
+iface_index
 |oifname|
 Output interface name|
-string
+ifname
 |type|
 Address type |
 fib_addrtype (see *nft* *describe* *fib_addrtype* for a list)
diff --git a/src/fib.c b/src/fib.c
index e95271c9..5a7c1170 100644
--- a/src/fib.c
+++ b/src/fib.c
@@ -179,7 +179,7 @@ struct expr *fib_expr_alloc(const struct location *loc,
 		type = &ifindex_type;
 		break;
 	case NFT_FIB_RESULT_OIFNAME:
-		type = &string_type;
+		type = &ifname_type;
 		len = IFNAMSIZ * BITS_PER_BYTE;
 		break;
 	case NFT_FIB_RESULT_ADDRTYPE:
diff --git a/tests/shell/testcases/sets/0029named_ifname_dtype_0 b/tests/shell/testcases/sets/0029named_ifname_dtype_0
index 2dbcd22b..ea581406 100755
--- a/tests/shell/testcases/sets/0029named_ifname_dtype_0
+++ b/tests/shell/testcases/sets/0029named_ifname_dtype_0
@@ -40,6 +40,7 @@ EXPECTED="table inet t {
 	chain c {
 		iifname @s accept
 		oifname @s accept
+		fib saddr oifname @s accept
 		tcp dport . meta iifname @sc accept
 		meta iifname . meta mark @nv accept
 	}
diff --git a/tests/shell/testcases/sets/dumps/0029named_ifname_dtype_0.nft b/tests/shell/testcases/sets/dumps/0029named_ifname_dtype_0.nft
index 55cd4f26..6f9832a9 100644
--- a/tests/shell/testcases/sets/dumps/0029named_ifname_dtype_0.nft
+++ b/tests/shell/testcases/sets/dumps/0029named_ifname_dtype_0.nft
@@ -51,6 +51,7 @@ table inet t {
 	chain c {
 		iifname @s accept
 		oifname @s accept
+		fib saddr oifname @s accept
 		tcp dport . iifname @sc accept
 		iifname . meta mark @nv accept
 	}
-- 
2.48.1

