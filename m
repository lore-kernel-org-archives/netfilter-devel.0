Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356FB1E2858;
	Tue,  8 Apr 2025 14:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744122452; cv=none; b=es1BBhcQ1285v1bam72Ee9Tp1l5sq32pj0DyIvb5ujpuPjqNiCh0s7iqEJrRwXEsmyXfBF0NYYQ3rc9MEPagrDzb+rs2QKERhqoUbli/yknVtEQ8O+Md/FUL0FwLx+Hf5Wq15XPK31iFoskYshxzVPIefh738bhVf29exnXKHCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744122452; c=relaxed/simple;
	bh=eoY5ZDeqkWc/fTWUEPR+4PRh+ioAiobGt1prQcCq8ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M11VuiezgzHDygl6d1rpBfwVC5PESCDTeJXJB+e3WxubQiV4qOYMHYv0GIIBGXTt1dRFXAmeecyG5V+e9dDtTIWnZxnkUZ2tqWy0kkmT8EsLTHEOsKCdM6UF6M8QdJy/YhJ45lRHVmnxXaV9hwavKRPm+UsrqYIK2A9SDeiGz/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JVcplAhy; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JVcplAhy"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5e5c7d6b96fso9925135a12.3;
        Tue, 08 Apr 2025 07:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744122449; x=1744727249; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CZWb82/PgasUd3hxc4hu0fam4KL28GGEvVzyBGiqFMA=;
        b=JVcplAhylLBF7PE8tpZXJ9WXvxTa/KZL4TrDuZHiolCoVpHnsbCXTr6Ac3dvTKLzXk
         KjlcGyVrO9icvXhRi3R4lEMvM6HGtwRdhiBUf4c96bKHxkql6P2Q5rBiZDKE8bicybmo
         WczaHe/U1G7jOSX87L3i1DZYa1B+Xsd901pnQRYjDdJJ8gg6sK0a81hQQOqxx77jjJIi
         Z8+rtgnqYpNBXTKbh447CVCAkI2bkOLU0byoMI15OGH8TIrFsDZw4cZpzjTe+rmZtbdQ
         FsChV2Q5bQJMty6EjLkMYm2DEo+XmPS/ZZiE09HJOj/Fqaqfssk6L0+DSl0V3iGBwpst
         RlbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744122449; x=1744727249;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CZWb82/PgasUd3hxc4hu0fam4KL28GGEvVzyBGiqFMA=;
        b=rkggRLBB9TBVF5AH0LRhmBqPGQrugkzKas6VJaZNoadX6c6eoLqrq2XAy+RAu+dlCz
         iagbVVB2i8ikYefYfB4SIDkoH8eZ9vpJ1s+AIvXAYTnfSl2VCKZRr/9Bz2nv8T4ETBuP
         DYYLIqmtXDJBIXixWJ6yX34fm8Ybu6YeAy3oNCynCh0DvIporIdOkeP+3VRj/3f3xX3Y
         cnZsKuYEIVrD6voYeCE+r4lVwh+GmYqHFas7F5fY4xOl1S90kI5BFfGVc00RfxDrdldD
         ApGSf2Kr0LW+syLdJlRBJYC+1bI02rW0pvad2EVh5KDJ0J07u/RaIIO9VrfBq4wVFOrS
         sSSQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDpS3NCGRAmeRg64wcLsYp2HsoV+YYbKnpamrE67KEFtH3o4sHi08aS10ApTGcrBc1Y69QOafQ3NmL+nBMiYE=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywn6nUhIGcOIZ3EyDUutv+MQlZL09+rLHWFa93eyp3gf39jpr8l
	CXcfwakSLiECxzU1iRrNNmjVVq6d65eVICdW2tH+ul++j6mSWVSo
X-Gm-Gg: ASbGncvRsrScRnHehlF3bSwr5wtZD7TtgurAtwbysmEpXY88WOm2cgi4q0//fCH7fVK
	2zQugO/IEEyj5N3Jy8RuI8oA4PrcsnriLmdA2Gj3nWRXxaOWsK7gQka5qfchztJh9X/QjO4QpvO
	X9gXjZKy8uSHYhvUtYzf40rI2R/OlBgJWhlmu+WY8yZN4QzEG0eFvT8faNxVsuI5bR9WSKz2jPw
	+vHC9/EPdLFocOnFhRWPT6J9LgnqvFeKRb2LpVfIXFO84jynTdBJn9Vg66iYX+oP0zhBB+RIa8A
	AkyCs+NAooZJQyCvlPiFtbmhWcBSJYlaQKPBtXtc/12iBgq07buDiP7nbr4shokUHdSWjmvsS5p
	8X9Qql77cdwdFH9mJYq8lVuuv7i++mR4bgqerD+YNQ9Zr+SHUtiP2b5ZgPmo10y0=
X-Google-Smtp-Source: AGHT+IFVjpjwhiim+Bxc5j4VTe0TH54Bm1QrpuWBGrq3gtJayc9WyUqiJ7bQRpxPiIXdRTszdGVxkA==
X-Received: by 2002:a17:907:7f90:b0:ac1:da09:5d32 with SMTP id a640c23a62f3a-ac7d6c9f77dmr1145483566b.6.1744122449312;
        Tue, 08 Apr 2025 07:27:29 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7bfe9be67sm910393266b.46.2025.04.08.07.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 07:27:28 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Jiri Pirko <jiri@resnulli.us>,
	Ivan Vecera <ivecera@redhat.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: netdev@vger.kernel.org,
	bridge@lists.linux.dev,
	netfilter-devel@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v11 nf-next 1/3] netfilter: nft_flow_offload: Add DEV_PATH_MTK_WDMA to nft_dev_path_info()
Date: Tue,  8 Apr 2025 16:27:14 +0200
Message-ID: <20250408142716.95855-2-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250408142716.95855-1-ericwouds@gmail.com>
References: <20250408142716.95855-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In case of using mediatek wireless, in nft_dev_fill_forward_path(), the
forward path is filled, ending with mediatek wlan1.

Because DEV_PATH_MTK_WDMA is unknown inside nft_dev_path_info() it returns
with info.indev = NULL. Then nft_dev_forward_path() returns without
setting the direct transmit parameters.

This results in a neighbor transmit, and direct transmit not possible.
But we want to use it for flow between bridged interfaces.

So this patch adds DEV_PATH_MTK_WDMA to nft_dev_path_info() and makes
direct transmission possible.

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/nft_flow_offload.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 221d50223018..d84e677384da 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -106,6 +106,7 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 		switch (path->type) {
 		case DEV_PATH_ETHERNET:
 		case DEV_PATH_DSA:
+		case DEV_PATH_MTK_WDMA:
 		case DEV_PATH_VLAN:
 		case DEV_PATH_PPPOE:
 			info->indev = path->dev;
@@ -118,6 +119,10 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 				i = stack->num_paths;
 				break;
 			}
+			if (path->type == DEV_PATH_MTK_WDMA) {
+				i = stack->num_paths;
+				break;
+			}
 
 			/* DEV_PATH_VLAN and DEV_PATH_PPPOE */
 			if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX) {
-- 
2.47.1

