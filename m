Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81C83D5255
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Apr 2026 10:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776163753; cv=none; b=a6duUqKUDsS4Ex0yKqcIbQHR7EMHCGtEH22EEI0P24UXoqPNIGVrX9oCK92nuS/W5f3k6Q8/iL/BauteS1EHtQvDtr0Iuj2wuyJGH0OyvymvgSvm9BpiDJPdNLDHhsQOjIPZ/nL83/OFaV37Ii9b3B18EohDaO1ktJHpNFTknkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776163753; c=relaxed/simple;
	bh=ii6RV1ygzwacH0zsmbOvUdY7N1HLtKusBUxFfTTs880=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXXaHn6RrKbD326s6/TJRHDapTh+FPcmvdvo6Xe3h3CVVBC+8s+qkxCkOspVV7bsraYCIb6v9NPrC7xyLbgjwk8gNZDIItiDOKcUxJRg8IKQ9yNfithqAHRGwZ9TTXzuQ7HDQXfboDjglJWaBn12vNtEkhyt4DE06muOSplM6hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d7iBFd94; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d7iBFd94"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8296dabef74so5213854b3a.1
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Apr 2026 03:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776163749; x=1776768549; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qdNNcNCom14+hME7vkl9Ojg8yeM3zI8TCPW0A6x3yd0=;
        b=d7iBFd94OtA2PzD9vTFRILEHBlV/R1ybwhL84mjC1XMApTIkreP5T/mCDAELWdEBFh
         ZYyT+6f16P3f9qJLrBiFVWYWoL7yjGJXMHV8odKotPllfdbWFhaaxnG82AxqHl6pdD7I
         pwbMg2zxHyJYtTLKXOqLd8FSNZEhZm2473tPRvG89BLFPva+LOWUdiyZ0Zml/ffoCEcZ
         aui90YfrvYLQ4UzT//BvGbLS7xzAz3ljGKu5B/J7srUoAHjf0nv2bUkLz6qJh0qauyHt
         w0XtadPNTh9F10XanRnwVySwUsaanDue4CB5YDbBPGQKPtAX9thEahPs8+fOvsSclxMg
         rjdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776163749; x=1776768549;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qdNNcNCom14+hME7vkl9Ojg8yeM3zI8TCPW0A6x3yd0=;
        b=m03uubd8QQuIOD6XXFfQvbgEYkIp7/cC8UMQA7nNoIaGru17HXdePklZSHlL1eRE0s
         7oMUKFUD7m3at8DZuTG/5/LwUWjrl9al6Fifk6WODTl/Z6AIbZ0qkb8lhEdmBnnMj2p5
         8sh67HDx/lbEgU9dRnrQaLzRT8dT6T+pYlydT86O+1jwH8m3rP6eWCn2HAXjK7jJcV3b
         Lu9DDY7qrnB0E8FwA9Si6KtDdVKzmLXF9kPCXolxUDTkB4+klWOcgvhIDXOdziLfydHj
         6IRs/o/Pb18JLq0qQgKyV40u6MTPVYyB6KvV7tn2yX4H8B1NZfQZqulI6bogpEITJkZL
         z1Tw==
X-Forwarded-Encrypted: i=1; AFNElJ94w4tQGHAqtOa5jAm6jHTgj4re4WXK7rjELc0xNk1hdwPkYdVC3CdztkEG+ytq6ua+pTXvTGbLn9q4O20ST8Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2ETTxEngpVuHG38byDn+sDwVn1zX1dS3V19qo/obcDo0yBbLw
	w9j0S56p3Redbd9pInV1dtAJJLXk3hxWGDt2+cT1JpxVoJdZlE0V81s+
X-Gm-Gg: AeBDietWDuSsTs4ct+j35YH67nAB8EuYmVKL9kEQOgHxmUzjSUzNf/MoEAjBnYfjd0G
	Il9s16EbNZ597YTUBx8sEiAKQBVYBFQAvePgwlkjMkYCeBzGOrp2MTKnz5J30sMTFeFErTd5907
	x2+fYSRCJqe2fq8IbmGtUdLcZu1PXDCf2qakqZdhhR93f3IV7dvpAWlhYiJhebPzVyjCypXXy9D
	7M/rsER++4yitsjHYgsl7eianp5FhvylebCBtcb3K7p56KIflGI3UBQ61OtCE618t8t47HUx8YM
	D9HBdoZmTI8fnkZ1L3EKGQDbOvQ1lxl9+L1Q4tWp54XB9rczwGKwM8w5HrRCaWT7p8JzxDWk9z9
	TpWlaFLNsB4e73uf2/bB+eIgk6Q7T10fH2AfBgwHcwwsGXAJxZqjFOaO7wuuXOjfajoCxTF9U7L
	xLTOSnidb6JyDv25hRcBb5uqHrI6+7hbcZ
X-Received: by 2002:a05:6a00:bd85:b0:82c:9c90:54cf with SMTP id d2e1a72fcca58-82f0c2c3c43mr16170482b3a.43.1776163748735;
        Tue, 14 Apr 2026 03:49:08 -0700 (PDT)
Received: from localhost.localdomain ([180.167.178.215])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c30ee32sm14570388b3a.7.2026.04.14.03.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 03:49:08 -0700 (PDT)
From: "Kito Xu (veritas501)" <hxzene@gmail.com>
To: pablo@netfilter.org
Cc: coreteam@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	ffmancera@riseup.net,
	fw@strlen.de,
	horms@kernel.org,
	hxzene@gmail.com,
	kuba@kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	pabeni@redhat.com,
	phil@nwl.cc
Subject: [PATCH v2] netfilter: nfnetlink_osf: fix null-ptr-deref in nf_osf_ttl
Date: Tue, 14 Apr 2026 18:49:00 +0800
Message-ID: <20260414104900.2617863-1-hxzene@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260414074556.2512750-1-hxzene@gmail.com>
References: <20260414074556.2512750-1-hxzene@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nf_osf_ttl() calls __in_dev_get_rcu(skb->dev) and passes the result
to in_dev_for_each_ifa_rcu() without checking for NULL. When the
receiving device has no IPv4 configuration (ip_ptr is NULL),
__in_dev_get_rcu() returns NULL and in_dev_for_each_ifa_rcu()
dereferences it unconditionally, causing a kernel crash.

This can happen when a packet arrives on a device that has had its
IPv4 configuration removed (e.g., MTU set below IPV4_MIN_MTU causing
inetdev_destroy) or on a device that was never assigned an IPv4
address, while an xt_osf or nft_osf rule with TTL_LESS mode is
active and the packet TTL exceeds the fingerprint TTL.

Add a NULL check for in_dev before using it. When in_dev is NULL,
return 0 (no match) since source-address locality cannot be
determined without IPv4 addresses on the device.

KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
RIP: 0010:nf_osf_match_one+0x204/0xa70
Call Trace:
 <IRQ>
 nf_osf_match+0x2f8/0x780
 xt_osf_match_packet+0x11c/0x1f0
 ipt_do_table+0x7fe/0x12b0
 nf_hook_slow+0xac/0x1e0
 ip_rcv+0x123/0x370
 __netif_receive_skb_one_core+0x166/0x1b0
 process_backlog+0x197/0x590
 __napi_poll+0xa1/0x540
 net_rx_action+0x401/0xd80
 handle_softirqs+0x19f/0x610
 </IRQ>

Fixes: a218dc82f0b5 ("netfilter: nft_osf: Add ttl option support")
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Kito Xu (veritas501) <hxzene@gmail.com>
---
 net/netfilter/nfnetlink_osf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index d64ce21c7b55..dd2cbbd449e7 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -36,6 +36,9 @@ static inline int nf_osf_ttl(const struct sk_buff *skb,
 	const struct in_ifaddr *ifa;
 	int ret = 0;
 
+	if (!in_dev)
+		return 0;
+
 	if (ttl_check == NF_OSF_TTL_TRUE)
 		return ip->ttl == f_ttl;
 	if (ttl_check == NF_OSF_TTL_NOCHECK)
-- 
2.43.0

