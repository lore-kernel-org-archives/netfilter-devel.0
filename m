Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4639E22F0F;
	Fri,  8 Mar 2024 09:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709890164; cv=none; b=JNfl/lB5ZE2XAfYRh56dXi7mFD1/BhOGWBNBpLpprdVur4LNRuNBdGGOSywpOdw0J5lVh0Oo4QkQIibb2I3vbh/0GlzZmltKyef+RHEN2fF70osZQpbHojn6G/XDNFv4NazQJ69ercz5iQYAMtwW2FGuN1O9Y2Zg/xGy10a3Tis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709890164; c=relaxed/simple;
	bh=g+Ary5J7O5Fu0wFVLDbo5dWH+BoCRSoUQeruUGAsVos=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uDjmPcPBEi4so5hd4zPKTdLgAjZ3SYmtJPh9150VrvvT+VnDh4TcFKJliMpahrJZMQcAbam5wAthY0FU7PvO6SNpD5BkXP/FucF/GpSlZA9CpvO7vjgcBgWg+iYh5XexZnqMFM1gL4F6MGOdpg4mCnh3YMvgkiVgD89wz9BojV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y/c73erH; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y/c73erH"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6e66e8fcc2dso262402b3a.3;
        Fri, 08 Mar 2024 01:29:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709890162; x=1710494962; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Q5LUw2+4jv0MJgeX3mrmHBcnaH5rMiClPvVd/LqRsqg=;
        b=Y/c73erHq0YHK8GNF5dmf1LRtwFW+KZCJAn7pqbyEGAtTlMR319tZ6pI442ibQyh6X
         GkUMxgkY9pwBYyTJJZSHKR/hE0Cm07O5eakTNZa86ZkCuiRAiD1pXdA5RcHm0YCVg/uD
         YaRB8yFWrffDQWXgBeY/EkJ3ZzUu6K6dr5czaUv3HXKhl8ogAEZGBc/PJfZK2TBLF15p
         69SFdzixSJK/t8qHgh59y3oXbrLtTY5hYpaSL+oUgil5M159zCSF+M/YrQsyjhJRU+tJ
         emD9Q9n71ff/lvX3x5fL+GzZl3n3jpTOHYImA8Vn3WaBpCEn63DDVGQZighVrm2hgxTI
         c8ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709890162; x=1710494962;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q5LUw2+4jv0MJgeX3mrmHBcnaH5rMiClPvVd/LqRsqg=;
        b=KtD0XamEefzLF90aMiAeI66SFB/DUKJ7cMrKpFdzu7kefhwddgMRvx+aHHlhnYFJoS
         i/oYnYkf/O9TFNRvG7DIH0Bj0b5G04jKC878DH80JpBCs6NizJhbkqudMNcIPmIKothx
         F1PXE5LWvwQQOHBsOxycSM/81ZvQHVnjXs5oYwVDSk+PJMzRz0rcaX6UJT/gJx2tIQ0d
         dzn+egiVpZo4TXP1GGbPS6a4k18aeiBMJ+YLkm53XR5UXuKFyzX7nOzAf4/7PRrNQVDJ
         O8ntd7fT8yK7aFNuPPL/8YP48IwrzwlVB/2WlGN5klUQL3hDb1ckEIFwxj+KoOdxNjYp
         YoDA==
X-Forwarded-Encrypted: i=1; AJvYcCXbuJjXfchXNeJG1ctD3nhJ90nmbEPTLI3USNH1CO6KvbBpljaydxcyHYu/X4apOF+JZkL/cWjBWywSCMZ6ueTNhmNkgPaL
X-Gm-Message-State: AOJu0YwTtVbTDl5zrRBfGlNs4v4sEGuiAzqjun7wS1XRpZoFCMxKpmIB
	k8rHLzX4IsJEpi5twrhCu1DsxFhUUeDky/6J/fl/DonlJ6XhcLhy
X-Google-Smtp-Source: AGHT+IGJ4vg6MaBba70jCI6cmfv4uRKZ1SwNamPYMsp1IacfjKMbWDACFVlL33y6GlArMtAirRk8XQ==
X-Received: by 2002:a05:6a20:548a:b0:1a1:6cf5:5bf1 with SMTP id i10-20020a056a20548a00b001a16cf55bf1mr6344768pzk.12.1709890162406;
        Fri, 08 Mar 2024 01:29:22 -0800 (PST)
Received: from KERNELXING-MB0.tencent.com ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id q6-20020a170902a3c600b001dd6290283fsm1547332plb.248.2024.03.08.01.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Mar 2024 01:29:21 -0800 (PST)
From: Jason Xing <kerneljasonxing@gmail.com>
To: edumazet@google.com,
	pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	kuba@kernel.org,
	pabeni@redhat.com,
	davem@davemloft.net
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	kerneljasonxing@gmail.com,
	Jason Xing <kernelxing@tencent.com>
Subject: [PATCH net-next] netfilter: conntrack: dccp: try not to drop skb in conntrack
Date: Fri,  8 Mar 2024 17:29:14 +0800
Message-Id: <20240308092915.9751-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jason Xing <kernelxing@tencent.com>

It would be better not to drop skb in conntrack unless we have good
alternative as Florian said[1]. So we can treat the result of testing
skb's header pointer as nf_conntrack_tcp_packet() does.

[1]
Link: https://lore.kernel.org/all/20240307141025.GL4420@breakpoint.cc/

Signed-off-by: Jason Xing <kernelxing@tencent.com>
---
 net/netfilter/nf_conntrack_proto_dccp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index e2db1f4ec2df..ebc4f733bb2e 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -525,7 +525,7 @@ int nf_conntrack_dccp_packet(struct nf_conn *ct, struct sk_buff *skb,
 
 	dh = skb_header_pointer(skb, dataoff, sizeof(*dh), &_dh.dh);
 	if (!dh)
-		return NF_DROP;
+		return -NF_ACCEPT;
 
 	if (dccp_error(dh, skb, dataoff, state))
 		return -NF_ACCEPT;
@@ -533,7 +533,7 @@ int nf_conntrack_dccp_packet(struct nf_conn *ct, struct sk_buff *skb,
 	/* pull again, including possible 48 bit sequences and subtype header */
 	dh = dccp_header_pointer(skb, dataoff, dh, &_dh);
 	if (!dh)
-		return NF_DROP;
+		return -NF_ACCEPT;
 
 	type = dh->dccph_type;
 	if (!nf_ct_is_confirmed(ct) && !dccp_new(ct, skb, dh, state))
-- 
2.37.3

