Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5D73DA5DB
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Mar 2026 18:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773424900; cv=none; b=kdVUvtfNYQIDa2kzYVN1rImktT4y8JQOixM56QmZnBdzuX/B6M9H17jYiqDxaZzhSKCDyjENczXaB2AhM8Z0JIp4c/uj6CmZW1Yw1hUXr9lS3WAaUwKSO+ys8RvMLnUpp2/tOrsycj0ZUv788f/O4FviNLjaRtiRfzKwZkMcjVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773424900; c=relaxed/simple;
	bh=MWXEFQ381SLQSXiwYPD6PgTvLJBhNSUHPAJpUG638dI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LgoXSe+r7vH3KTYORj+VR19pDr6sAH/VlUCs/QRPcHu/31C3pEZc1t0mE/UWcDcmRO8NoP3g8IHoREoj8ZIvFmieDqV4yjhA6EucAZkt0CXhF4+AcawbOQYq8mr2Z8cEQBtXkislU/11vd1PwKHzgXzqDq2J3iROjI/ZBdrh2nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IkBQYwHq; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IkBQYwHq"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-79863ab8478so26968867b3.3
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Mar 2026 11:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773424899; x=1774029699; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MDVR6LO95DY7vyobG5JaDyJauzh65mLzZY7eX52aAWM=;
        b=IkBQYwHqaHSHPu+6JjTmwo+VWeLZUhwwGliyMuoa2dHFK9guFuF80n6s6Q681+14Ni
         t986a79tnycPyxYSgtJFM+NUhBzWVdsoAiioeiGFlJZxDR1hY34+0BlFn4bmO0J/aWmY
         GqHs8ukPG+wCPH/md/l1u5FNRjhzDvA3OzZYX+F68+FSZ2xaw9Wlywsek+hN7Hc3zt78
         LXtJHEKOrxgHXHvhZN9EIMRNeQ+3s/A9ppDcEjIBf0oY+gkvPxZEcPFHukBVDLIhauAD
         mkdFC4GEBnIpK+zC1+o+1KX/VQRea59F0AjgJrL8isTA5l1n9SgQlNHBRsydWLqZTVP5
         c1/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773424899; x=1774029699;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MDVR6LO95DY7vyobG5JaDyJauzh65mLzZY7eX52aAWM=;
        b=gVUvz7S+X28bI9E62k7WrySuBrFX/AnpQ2OQdERufJgDj96McRmwkiwcUses55sIdN
         qeYWYNBEF2zlBHOYx+zfmE6tiPg/sMj4q3WneAvvnkhptzyhimxfsgoNhBg+BnC7x+Cn
         GDKT4S014heJu7fAsxKLuK3KniE4w4GwYUsoTnOGIV+5YSn5LS7ZM9hcBw+QvOPy8XHU
         hQPFCwBBcpCmASjQJJ2d1nQ9EcDm3xVSaUuTCpt/+u0uFlRKXKICnPCg5AXkX3rhTczd
         JROCe9nwaN5+Ii2XeYPEb1Csz2uR+TuU/xlfAmjC/qYKzauRzGTnEUGRttE6NPP0ugks
         0SGQ==
X-Forwarded-Encrypted: i=1; AJvYcCVtJ/ruGWMUDjEXT9LnC93e2Z4zHM2/wuiSNnNe+nzcmew/fZp1yqQ1KHdyTdEHBZ97QOThLeEQjl6he6xcf9I=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqxEM9ch6KOMI6S/hEecKHgATd28S7vPdrPglSRV2eM99QW96r
	wX/tsaAyhxjzBHHlAYDvT5WjjZTFpjCjGfjaqOy/y1MxCV78jDJrNK/c
X-Gm-Gg: ATEYQzxWUeC2wV64jJrA1ghvoG71GZVe1XegdsawnlX3DEwkmqPmAoBAjTAQECUATh2
	DVjsqfbtlgr1bljTIy8MLi5zuEaUlEcqKSDN6JXRzf8lM99lpoyFpkEtHKcWtDPUw2AsGm1JC55
	JlSzcOWBA/STbxQlTumujGVpcchtCU7gxVM81eI3hTg7xtCtv8Y5ZqtnGWCc426GjHlwCl/zaMu
	kjpvEp9yPe3O8UDfrDlUJPgam++L6ji9dDOnRSDcxJPM0zgANCrUKrvGAzwmpsjpOYH59mdT/T3
	9IhjJx9+zcSP3lQRW9VOwrnJmfpTnzSaw0snyMyd/E3vfc3DKt2RLxHQLsK3sIdT6bacYaenK0B
	Ww63Sll1fPdyMR8z69mj6isl5ahg42HZuoeb03wstN3Lp6BOh+LMds8d4d5IeO85GjaNBFAzUCS
	fbeFhU/qjPp6t+EzD+DbYjqZmajfYJ3x7Emf+VwPiCI7ZyMSXruH5T9Z7E5pQolrDNKshMKaMSC
	jQDlq4GgidasKdG28cQyr8M9MhxnS9Pmg==
X-Received: by 2002:a05:690c:c50d:b0:798:5333:ce0d with SMTP id 00721157ae682-79a1c08d4ebmr44869727b3.4.1773424898390;
        Fri, 13 Mar 2026 11:01:38 -0700 (PDT)
Received: from localhost.localdomain (99-47-159-199.lightspeed.mmphtn.sbcglobal.net. [99.47.159.199])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79917f42c4csm49980107b3.52.2026.03.13.11.01.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 13 Mar 2026 11:01:37 -0700 (PDT)
From: David Baum <davidbaum461@gmail.com>
To: pablo@netfilter.org,
	fw@strlen.de
Cc: phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	David Baum <davidbaum461@gmail.com>
Subject: [PATCH] netfilter: ipset: harden payload calculation in call_ad()
Date: Fri, 13 Mar 2026 13:01:32 -0500
Message-ID: <20260313180132.75655-1-davidbaum461@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

call_ad() computes the netlink error payload size with
min(SIZE_MAX, sizeof(*errmsg) + nlmsg_len(nlh)), but min(SIZE_MAX, x)
is always x, so the guard is a no-op.

Replace it with an explicit negative-length check and
check_add_overflow() so the addition is validated before being passed
to nlmsg_new().

Signed-off-by: David Baum <davidbaum461@gmail.com>
---
 net/netfilter/ipset/ip_set_core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index a2fe711cb5e3..11d3854d9b11 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/ip.h>
+#include <linux/overflow.h>
 #include <linux/skbuff.h>
 #include <linux/spinlock.h>
 #include <linux/rculist.h>
@@ -1763,13 +1764,18 @@ call_ad(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 		struct nlmsghdr *rep, *nlh = nlmsg_hdr(skb);
 		struct sk_buff *skb2;
 		struct nlmsgerr *errmsg;
-		size_t payload = min(SIZE_MAX,
-				     sizeof(*errmsg) + nlmsg_len(nlh));
+		int nlmsg_payload_len = nlmsg_len(nlh);
+		size_t payload;
 		int min_len = nlmsg_total_size(sizeof(struct nfgenmsg));
 		struct nlattr *cda[IPSET_ATTR_CMD_MAX + 1];
 		struct nlattr *cmdattr;
 		u32 *errline;
 
+		if (nlmsg_payload_len < 0 ||
+		    check_add_overflow(sizeof(*errmsg),
+				       (size_t)nlmsg_payload_len, &payload))
+			return -ENOMEM;
+
 		skb2 = nlmsg_new(payload, GFP_KERNEL);
 		if (!skb2)
 			return -ENOMEM;
-- 
2.50.1 (Apple Git-155)

