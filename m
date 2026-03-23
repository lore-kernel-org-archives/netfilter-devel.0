Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348B93D666F
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Mar 2026 19:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774295150; cv=none; b=mxR2Nbvjs8zjOCvLyJy/lt1FHzaYc7zGMFJ58Edwx3f7yJKo55i5Kau+z0mfTObLrg5SPHWX+V3MUDMOr1O+mEwWWjBkNP/mzzNJGDaceJLB3CfYE48NFvuKbO3cLaB/UCgRx8CSqlIT1Asm6Fjh9L3+0csaN/D0Qu9NB23hHqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774295150; c=relaxed/simple;
	bh=FW6AamUap6IdmQX7aPqFLUAtEVmtALZ7207pa5FRLO4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VkSaF0iWoDIsBDr8tyxkfCc+u1FuZWNNmURgdm44vXQ7frTTiEnSI0xIdZj1M9m+U6uVJeeP7EkQmmun3xdsjx/7hqQ8b6J3SiTlcsF0DCicQpUX8QqHhkLijlY7IxwUbrdKMU9ciJ5q5n6E1veqISoGdK1W/n4yGrqAVL868Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LIDRrHUb; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LIDRrHUb"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-43b45bb7548so3301672f8f.1
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Mar 2026 12:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774295147; x=1774899947; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UN064Xn+atoreMZyKcgTmEcbQ1sNIRtDXi68fcy3LFc=;
        b=LIDRrHUbpTJXgS+fjUjImb5BwM0xbGzVBd77FXYVKyeRPxGxzrDVp9iohf871osA20
         1AUmTeuTiVCA5eD4nbVHBxh3I1wmKcZdlqzUZc17E6XkO/F5Xi0AvSb3oe5jWZTkV0uo
         1cPfwuGJfNdKzRd6gWLHUtDQsVuMuI+Moaol5MmO9eb35obpiJYIvITXdjoW63LI21EC
         MNLqfS5mzt75xTtfUE2Cb4nPArGknBa6ZTz17QbQNYWvMbzfvK9zeDG42oLOlAARTOuE
         aFzCKOlwg3zzDNeZGA/1CNzt6sYDSmGkUPmpL9zMrqClBnMnGCJ2SmaRr9kPw7bbHSzu
         3WXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774295147; x=1774899947;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UN064Xn+atoreMZyKcgTmEcbQ1sNIRtDXi68fcy3LFc=;
        b=s2SASbe7awwFYiHxvVRlQVFIiE/mu3moxDJbgvjoXcoZzYrGF6fKdd+ot0e3hNhOSl
         XR8yxTAwoqBgVqrae7dIr44WksmRPNcxhUzmiXN+SSE5Jy/EFVgVnBj4f2fHhnCjMN6U
         49Wwqx7/2qQKJXaMoIcUraiWguhXgYbgASOnEssDSTTwUlhRI8kOhuDKozVTJiIIf2/g
         tWuR6J89ELpKmdj7r1kolRABm/uR0IBb1VG3vCjXMBVw+n0ZYRw0XT7Lc4yRmduwn8vD
         tk8SzwjgnuOTYQoqjUNLoVuSbsmLP1dy8H+KdUcdEPdi8PqNPV41UBvpAFgLVcB8ya/f
         hzZA==
X-Gm-Message-State: AOJu0Yw1cWeF1ZN8ZiHsXR3KXYpuIeStWiss4r1kzB3VazffJ/7g2hcO
	mM/23X4bYhn0LNfbNYSNR3igHPw24NSEOQELXwqAEp0o4DZ53bBBzrAnZzOrFhZ1
X-Gm-Gg: ATEYQzxIsG0Z8HFl7hYMy44u4alpgN/VfKPeG7jc3oW+YXUK7RGG56kgCG1oOXeJx3b
	XxGWcwp/yw8TukFo8HhyWnYsiGk0i88PVC9VNNL0tau0cyrI9GUQc6+6PgPqG0SMHA5Be3eKYy0
	5sM6/ibHFYCRZz091AfD6PAvEulrSxDE09rTk2Kyx7cyIkaEQR3d/cGlHdfyAX/R20rFxvfjR/y
	NydEy2CZ/3/YNApKhI+EJhiGgN/mz7qZKSc4CBvUp7vwc2elYV8GF8VG5qKPZ8xM9yZg846UEPT
	ClEN1zkhi24Cs670dsxSHrL11bBEo5wSO48UjrmyW+4RxE9LEEgediHpIw11ZeUZU67cnXWgbLr
	eVyaSKAscAhTawMwsWDAlN3FhsJfM7zbaxKoKlgr2L+YHKDlwJa7EYtRjO+ydmm+kyBrjJgCkWN
	sf6OFTY3JRutf0Dg==
X-Received: by 2002:a05:6000:26c8:b0:439:bcb8:54b7 with SMTP id ffacd0b85a97d-43b6424b9eemr20058423f8f.15.1774295147052;
        Mon, 23 Mar 2026 12:45:47 -0700 (PDT)
Received: from erlkoenig-dev.. ([2a01:4f8:1c19:fa6a::1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b646b0b0csm30324660f8f.15.2026.03.23.12.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 12:45:46 -0700 (PDT)
From: "=?UTF-8?q?Rudolf=20R=C3=B6dl?=" <roedlrudi@gmail.com>
X-Google-Original-From: =?UTF-8?q?Rudolf=20R=C3=B6dl?= <roedlrudi@googlemail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	=?UTF-8?q?Rudolf=20R=C3=B6dl?= <roedlrudi@googlemail.com>
Subject: [PATCH] include: fix NLA type comments for log attributes
Date: Mon, 23 Mar 2026 19:41:34 +0000
Message-ID: <20260323194414.347527-1-roedlrudi@googlemail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The UAPI header comments for NFTA_LOG_GROUP and NFTA_LOG_QTHRESHOLD
state NLA_U32, but the kernel implementation uses NLA_U16 since commit
09d27a8 ("netfilter: nft_log: group and qthreshold are 2^16").

The nft userspace also correctly uses nftnl_expr_set_u16() for both
attributes (netlink_linearize.c).

Sync the comments to match the actual wire format.

Signed-off-by: Rudolf Rödl <roedlrudi@googlemail.com>
---
 include/linux/netfilter/nf_tables.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 45d0b92b..11737fed 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1281,10 +1281,10 @@ enum nft_last_attributes {
 /**
  * enum nft_log_attributes - nf_tables log expression netlink attributes
  *
- * @NFTA_LOG_GROUP: netlink group to send messages to (NLA_U32)
+ * @NFTA_LOG_GROUP: netlink group to send messages to (NLA_U16)
  * @NFTA_LOG_PREFIX: prefix to prepend to log messages (NLA_STRING)
  * @NFTA_LOG_SNAPLEN: length of payload to include in netlink message (NLA_U32)
- * @NFTA_LOG_QTHRESHOLD: queue threshold (NLA_U32)
+ * @NFTA_LOG_QTHRESHOLD: queue threshold (NLA_U16)
  * @NFTA_LOG_LEVEL: log level (NLA_U32)
  * @NFTA_LOG_FLAGS: logging flags (NLA_U32)
  */
-- 
2.43.0

