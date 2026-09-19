Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78719395D8B
	for <netfilter-devel@vger.kernel.org>; Sat, 19 Sep 2026 21:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789854771; cv=none; b=lI+H2zFVAqAEuFBWUnhUEMgMnwj9XUuQWJEBM5ORTlQg3FEIBca7HuXpfSvUVZ/8E00x7Xfs6cvglfhfUK36HB7zrAhqh6qsvAO4BbuDCG3TtMgZqceGzFQRZSzZrT2WOqzGDjw6cEEDmcSv5cfC8qTvcsv94+GZ/XkaeXy968w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789854771; c=relaxed/simple;
	bh=ok7q8RjuE02Bww+2QvSjqNtvkMyCStknUKyLWbBaTyI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XfAS9JTxQmuBIzenj95Uo+y3Zc1PDRrOdV/ubfU5tkprS+ShTMZXCKE8bpOBpsjP2pdpG7emrGR6LuKvD5985+azpt6lQxjKqg4CjJk5yzVetCn/F1Wa4Haz9X0huDdl4qtUoiOrqath8I4jPDSTTUqo4G1tNQPIV+ZhV5X/Fl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PwXrRn6c; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PwXrRn6c"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d91c22d27dso10932135ad.1
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Sep 2026 14:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789854763; x=1790459563; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Cp35LkaPgGuGmcugrLJDe3EFri8Cdl2WjJc6hIpiryg=;
        b=PwXrRn6cQlBooUIymKChwIp4+XG5Gw6XmGayioQv/YymQnxBptgc9e77iOSJ2PipL5
         dqJgc6xz6QTUkcGOPunig3s+D/W+89ajnwtsg8ntizY1qBDVP1styBx+4gBF+D2Y3pPj
         W7yibt025sqDOPNQz19Ac4tZ/zKEwFxUQfQ708Il9Tq/CZ/+jtcNEQPZu6dff32mTzQC
         WgAK9H234C4VnQtFC4nlAQyxa3gjQVIxXFDzo60w3TiIVz9ivVYxh+/aSX6Qq4lEnPOA
         l7EJf2pGe2gZCCRkWJbllFvlHXOjv7huQj4GbIoOvGb7WhOr5foSFIE4P5NqG1JcL2Gs
         zmog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789854763; x=1790459563;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Cp35LkaPgGuGmcugrLJDe3EFri8Cdl2WjJc6hIpiryg=;
        b=Win0CV6WBdbYRbwUypp8CJRHqJKRRpiqgazCzTNxFR4TFk9YvJCU/SI8JzYAmiuAyn
         NVrHceGXrTCUu9sqdgjzJK786E9bgj4gmAIelqRspM+WKjGuUVyYzRNWxNU42PndLGev
         6Jc1x0wfQufAalI2Xrs+nxq9/CLxCiZza/FdMbSO32ybnsEIAY1ytg2zCtUAWskBVWQj
         XJnB/s30c2Rbsd8oSx9Jh4iOi90FB70rK6VS5APk7FFxz1VOPzogL3Nbas+ZYCN1Lh7W
         NO6OCB9PsOxNb7/xQeh8VSHLSMHrl2jXS7A7IyMnO3s2mLM+NUJpsTzDm3Y9IWqXDRjo
         MiLw==
X-Gm-Message-State: AFuF++mLQxFhRUBhB0H+jIT/zPa44hzudJCCMlb4wO1kn4Zp3zvwX22N
	j86NtB0LjXWMiRaO8k9VNh8OijXAYs//E2cnz7CIaN3X84kaTY3J6Hk4
X-Gm-Gg: AYBFou29tYitcHuGB1LwIHHjzz7g+MY5gNoinDTrz6cHKtU8PZYZiS91u0YhCjCyHYK
	uP+3VKUCNboEhYRYKd56wZmBCQDSjus77dg9qWN+MTdrIF8MK1uBVeG3ckHAFXH368VVFPOUZ0G
	80EVFFxHM3SGBC3I0XHv2PF9HGgTIPdndeUHajojjHPVF8SIUuPRiB7zFVg5MgTpCbNmPRHNawf
	8EvvNF38hYh09jz76rapCkBywmerpCEZ+HVcpC8cRlmxQuWn78HMUkW4+37QYpCE1F7rWzQB4r7
	mUE11mQ9HqjMGxfzy+VUUPg1kCkIM9eTRYTupugp80ckS6BTkE6RoExwHwp9HCNmWhCj5T6UDaS
	OBFQuh5IOoClUojT6VS8eXE+Z3JJx+1gFr9rkeRFdnwiTCIKB0SUYgAnEAGwdxDx+Kkz+szCSYT
	+RCeYbIFmlIA1TeB7pHVhvoG/XaDswsVDc5qNIHJbIPnTS7NfypfzVbLZ2Sw9SFhE1sV0t4zw2j
	kK5QyswMJdOyEdDZFDLEzRi+2WGq4hcXRkxDuaeaeGGbV8l7cRaY1Y3+PBA4Mx9pMxo35gzX2DI
	MbnqMCjFnw==
X-Received: by 2002:a17:903:2343:b0:2db:3b35:1ac6 with SMTP id d9443c01a7336-2ddb1ab24edmr114324035ad.5.1789854763351;
        Sat, 19 Sep 2026 14:52:43 -0700 (PDT)
Received: from phui-2.c.googlers.com.com (78.123.83.34.bc.googleusercontent.com. [34.83.123.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df3ae73eb9sm3264875ad.44.2026.09.19.14.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 14:52:42 -0700 (PDT)
From: Hui Peng <benquike@gmail.com>
To: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] netfilter: nf_nat: fix unsigned range_size underflow for ICMP and GRE when max < min
Date: Sat, 19 Sep 2026 21:52:42 +0000
Message-ID: <20260919215242.3471883-1-benquike@gmail.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In nf_nat_l4proto_unique_tuple(), when NF_NAT_RANGE_PROTO_SPECIFIED is set
for IPPROTO_ICMP, IPPROTO_ICMPV6, or IPPROTO_GRE with max < min,
computing max - min + 1 in a u16 range_size underflows (and wraps to 0 when
min == max + 1, causing a divide-by-zero in % range_size for GRE). Handle
max < min gracefully by swapping min and max for ICMP/ICMPv6 and clamping
range_size to 1 for GRE, matching the TCP/UDP/SCTP path.

Fixes: 203f2e78200c ("netfilter: nat: remove l4proto->unique_tuple")
Assisted-by: LLM
Signed-off-by: Hui Peng <benquike@gmail.com>
---
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index a4858c2b2d65..83f4eb63a584 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -575,8 +575,10 @@ static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
 			range_size = 65536;
 		} else {
 			min = ntohs(range->min_proto.icmp.id);
-			range_size = ntohs(range->max_proto.icmp.id) -
-				     ntohs(range->min_proto.icmp.id) + 1;
+			max = ntohs(range->max_proto.icmp.id);
+			if (unlikely(max < min))
+				swap(max, min);
+			range_size = max - min + 1;
 		}
 		goto find_free_id;
 #if IS_ENABLED(CONFIG_NF_CT_PROTO_GRE)
@@ -596,7 +598,11 @@ static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
 			range_size = 65535;
 		} else {
 			min = ntohs(range->min_proto.gre.key);
-			range_size = ntohs(range->max_proto.gre.key) - min + 1;
+			max = ntohs(range->max_proto.gre.key);
+			if (max < min)
+				range_size = 1;
+			else
+				range_size = max - min + 1;
 		}
 		goto find_free_id;
 #endif
