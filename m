Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135DA367295
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2026 19:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788808665; cv=none; b=ObFS7LtJyXkUiTqeNum3ve6h02oTa0aq5LyVaDJ3w2pvDskTkqmRNnp2vTCZv0Lhc8jRbard5gCAi0GaU66icX1I84xzvjlI+0UaA28i6ofFtffaLrdSVM/q59Nq1XI0lTBjowJgtrYWO4D2ay1h4NDv8UUyiurHI8+RKVOy1PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788808665; c=relaxed/simple;
	bh=06rB7xxdcCuXMcZ1MLTFW0ssuC4OGhJtSTWgYmk6UsY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=oy2iE9ucoES9UjT9QTpt/AiN24cq9U6VzQ4/GT0vdLL7iCA68JiytlPpRxFkkyVv9/DiMDI1qeZaKH4MWyywjEZd6nOz/Q1i3wPWbDKVERRoR4sLbuaDRsba0iHzmxM3/6ku89J0rCMDwxXwUrVcqWTcKh7kHls6QWQHDLPSCkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AfnGh5JX; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AfnGh5JX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788808662;
	bh=scg/9sx6svPslY+Ofr+g3GE/uA0Bqw/4YKZu2kSpDD0=;
	h=From:To:Subject:Date:From;
	b=AfnGh5JXI9Mwh4qgPQFh8Q99fveK1a/ijmOVHgsCSX3CQkltuvMmxtnnN5ITgEUje
	 grL1gsxEhE/OiO4SWH02aax+bLUXBXOhNkb/mwlRsywCek09r+r0KB/ozn4lI5Ccmt
	 FqRJZLE9HKhdE933qCt2/KynmkfxmQXF3u79JVicEWC/LXVpke0jcDQohTtPZ54n3O
	 dnuVAfUByhqO+nSsXbovHzW4TuQbgmAIjkBsUtqm7JTXwA1N7xoFJ8v4GFIO3FmoGr
	 0IUBKXMirFnC+EdrKx/YKFVkSPYYTl6brgc5A9phuDf1os9mktWnyLI6Q001UEtzhL
	 KrraqYCZiEBNg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 28B4A60792
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2026 21:17:42 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: xt_IDLETIMER: allocate timer with kzalloc()
Date: Mon,  7 Sep 2026 21:17:39 +0200
Message-ID: <20260907191739.1432385-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

According to sashiko:

"The embedded struct device_attribute attr has its show and mode fields
initialized later in this function, but its store function pointer
remains uninitialized heap garbage.

When the sysfs file is created, a process with the DAC_OVERRIDE
capability can bypass the 0444 mode restriction and write to the file.
This causes dev_attr_store() to execute the uninitialized store pointer,
leading to arbitrary kernel code execution."

Use kzalloc_obj() instead to address this issue.

Fixes: 68983a354a65 ("netfilter: xtables: Add snapshot of hardidletimer target")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_IDLETIMER.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index fe7d8d19629b..8a1d95d21991 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -196,7 +196,7 @@ static int idletimer_tg_create_v1(struct idletimer_tg_info_v1 *info)
 {
 	int ret;
 
-	info->timer = kmalloc_obj(*info->timer);
+	info->timer = kzalloc_obj(*info->timer);
 	if (!info->timer) {
 		ret = -ENOMEM;
 		goto out;
-- 
2.47.3

