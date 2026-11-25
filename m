Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795636490;
	b=k9SyUnG5iLlg74yPihqy2h4GdtcV75yQ36TWp/3lYV4QOyPryWW7yOQApEgJQ0eZnDB6
	 9BmzIoYwRuJppb4EGw5Khq1C/373esr67rNx212lw+DJ5l0kvn9B2u80ZOy9RPza6bV/y
	 fxyoCbl3QTXkPyHK/4SO6bsN3P0Iem/Zq8B/vvkeNtvfySLexTf6rk83qSaBkk2wl82Jv
	 hfkzrZ/8+VSX5Wu2xk6SUZhiRqm/iVKQeXefAnFSZ+hvFPhxS707yvQFiVK5f3bEmv+kq
	 0OFnxZ5lzgzjrJ56dVNDAT2tR0Pdtdu6xxAR8f1U8Rm/VDXcnJ9RAuNuhkbOiff2ZFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795636490;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yk4sQdTGHDvnf6uulMmqAhaaahLBnsUv08fqjU1ilO8=;
	b=38OUHUN8J9kSlIygGJ3Xtjh16SBT5c2ttOk9bXOgmlSQ0tmCNC4uW4KJ0q3VuE8rnvUc
	 W2vC8ItlSJmhV79eLMBTuue5DZ/3vST/Xk4T7+TUT7DXtDoPpiCJVJbkIcHH0nquIxHqo
	 7L4gmIpIj7dCyNFB4fD8jqgb4wvXv6CYVdW8iq53dvl7AIJK8882csRvSahq9LV/BPl+a
	 TONnN1eT7h+yejMQ9doyb9bN8LgJjPoEtJmwqyfQP5Jw/P57ibu1ZbI3nfT+9gIWj46Or
	 VHdZ4tJuc16hdoK7avLDB8xew6VW9TVJvvyBk3oaiEHLZLAcrprPwjknoioyUa0qfNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lWcl9LfA;
	arc=none smtp.remote-ip=209.85.221.53
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9C8606A31E
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2026 19:54:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EE9C8606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lWcl9LfA
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-498f5fa5103so3704344f8f.2
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2026 11:54:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795636488; x=1796241288; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=yk4sQdTGHDvnf6uulMmqAhaaahLBnsUv08fqjU1ilO8=;
        b=lWcl9LfAVZiJ+QJNEsNYCLHoHPFueniRl9m/9+rjxJwI63YZMOCKbIU4r5iZVbQZuT
         31LbrgqYALF4qfZyyhqZcpwTTK+jU9qQLVRMm07srAW44MCI7j41E9bBn1x2BKjZDQMU
         I2zglX+PYcj9lb69GlJ0x4A4lECv6bM6AOX34WLH0QluEDZHCzIqp2KqoaMB3/Tvl7+E
         Z/HNTxbSkqtyJG+D5fKelv+WQ0Tuv9FiHtilkCZeXrr3P7HTrb+GvtMtE/W/UOsMJBYM
         N1lYrkbZdg1wz98kBG6gfIE6U74yaepX3T8bjsmKjB6oD2ohnlNQBd2Rw0SLkqb/V4Vg
         Gcuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795636488; x=1796241288;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yk4sQdTGHDvnf6uulMmqAhaaahLBnsUv08fqjU1ilO8=;
        b=JHNuUaX57/dgp4G7Ba25hNUOyglTXB4XyJhHhB9R9tuM47u8LiNRRrrUkx1WZqjj43
         68FzheNFXkBhvFetXCOnAGnDKhIC2YAmIcA/apI3OHk1wYfvoV3ehdDNm9LyfW0vEpsC
         Qg2/4XNVZ9I3ST91FdiBZRmgUMT35rU5E8X1RY4ulktvFwHFi6mZjEdVZJQFzisPbNi+
         CJrMdusLHsj7fMiq2aEwXq3uxf43gtOTaoczf1zGJKq4BFBgj6j97jJAKgrgr9qMFPTZ
         yts0VwyIkXU+bi/9l8I/tOciEfqQbi1AWb2kjaXfo9qjY36b6BQc6mBOY9qPQcIIFrYK
         DmqQ==
X-Gm-Message-State: APuU4Z+bmjnHai9UpPJ3dyOVhL/Mdst6YgLzpox1xeEPalMTZPoooMHC
	yXG67yXR4/Q3wCkWLFZ8EgMZIdJog2OFrY5Cv08mDS82MPs2dxRO5yas5ks/+NPo
X-Gm-Gg: AZFdTZc4hBeTp8KBAQUd4hSDXdaZiud6ZDTVyVz8a3pUFRK89z0O3XWYZPhloCfej6w
	DiWcnYD9GNjXAbWCSH6eG1GgeNpV30TBmRg0W12xd3fYYJ4jlgMtvpzIOMo5LK5E0D/QyQOX2U3
	HQ7WmIItOwcaLZnSmumUE2Rl7NNcK+sFaxKqwj2wkmbOmG1bWYx76FqlCzTKkxxvShnxaNDJDf9
	IKFklorK0NvCp/DrueUrdTuq7a1z6B9kCOtBwo0yHyJcfdcMSWpzM1WRROz5E+V8bNYChDIrSgL
	D1mihAJw/sgFd+2B2L/vYVGfIkJAeNnhMijBj8PfgAZ5v50ePoFTEs/P5Jp+K6WYPnt/mvjIBks
	I7ceRFA4oj8qowwLK5br3aeAO3dsCLubAJ70ZEv8wC8U9fqT3oDp0avHNjZgbp6j5axDA/BZ+yM
	SnEyjWm/36Lt8DJBgWhBSSyg7SF9Frj424tXRZL1P95gwlZN6NKUEmYlYjLJfswooZJ20cL4/cY
	znZOAEHFoNmQTKwkcv6LeLE7sCXsztebT8QUTLL6x0TjUe/Xd6fT0VDcC+lw0YqHBVNnOJzMwW7
	Kq6VZHkVHMOST1RTmSgigwfy8GW6GhwywZ1qJnCMlquciQQmCQ==
X-Received: by 2002:adf:e197:0:b0:4a4:14db:233b with SMTP id ffacd0b85a97d-4abb3678774mr32452452f8f.12.1795636487949;
        Wed, 25 Nov 2026 11:54:47 -0800 (PST)
Received: from serv08250.test.local ([2a00:801:4aa:f0d2:a00:27ff:fed3:de1f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6b10b2c9sm37464001f8f.31.2026.11.25.11.54.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 11:54:47 -0800 (PST)
From: Rohit Geetha Bal <rohitgbal@gmail.com>
X-Google-Original-From: Rohit Geetha Bal <rohit.geetha-bal@telenor.se>
To: netfilter-devel@vger.kernel.org
Cc: Rohit Geetha Bal <rohit.geetha-bal@telenor.se>
Subject: [PATCH] trace: Fix incorrect ICMP code representation
Date: Wed, 25 Nov 2026 19:54:05 +0000
Message-ID: <20261125195405.2279-1-rohit.geetha-bal@telenor.se>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix incorrect ICMP code representation in packet trace output.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=222272
Signed-off-by: Rohit Geetha Bal <rohit.geetha-bal@telenor.se>
Tested-by: Rohit Geetha Bal <rohit.geetha-bal@telenor.se>
---
 src/trace.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/src/trace.c b/src/trace.c
index 051cc12d..ec7f9e5b 100644
--- a/src/trace.c
+++ b/src/trace.c
@@ -12,6 +12,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <linux/netfilter.h>
 
+#include <netinet/ip_icmp.h>
 #include <nftables.h>
 #include <mnl.h>
 #include <parser.h>
@@ -232,6 +233,10 @@ next:
 			payload_dependency_kill(pctx, lhs, ctx->family);
 		if (lhs->flags & EXPR_F_PROTOCOL)
 			payload_dependency_store(pctx, stmt, b);
+		if (desc == &proto_icmp &&
+		    payload_hdr_field(lhs) == ICMPHDR_CODE &&
+		    pctx->icmp_type == ICMP_ECHO)
+			expr_set_type(rel->right, &integer_type, lhs->byteorder);
 
 		goto next;
 	}
-- 
2.43.0

