Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F98E299A82;
	Mon, 17 Nov 2025 21:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763415629; cv=none; b=n2YE6HXHj4uxjEV28LA8oG6asFa1qE3lk2OJi5p1WqYmgMcKylFGZhcEWLFP57FI4W3DRi805WY7tkeA++FELE6BgUJ7dgosSbXvYTsSASN12Vft6rZ2/OvIkhbHk5TLw+c7J9bDRY8NB6ohdFF6N4qJ/c8+jptgROv43NQFPtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763415629; c=relaxed/simple;
	bh=LE5Kt0YGJY6Xem8eJ3hFxVpCpoUUNmjsBy6L3cjya9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pmLvHbKF4iGSeRkZkbLjQTuuE+G0ecqBAVft6a2i82ZgvVs7/IB+AsElZJI0+AHIQf14n5q7i2mWlBDMLzbj58mh0AgYLQzJx0bRQGfilaRDP6sPrzHdBgRVVHSGTEziMFsZnRj5u22z9VYlqxOO4iiuJUEogVGt9IunPaeDkzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=oJX5L85j; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="oJX5L85j"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5D22760276;
	Mon, 17 Nov 2025 22:40:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1763415626;
	bh=JsGt8UETBwMcJwfz/M3Zv4UximhBn/qvX3WZewJNOkY=;
	h=From:To:Cc:Subject:Date:From;
	b=oJX5L85j8nY2kYFOYCYJdAd/NfkLqxoKD5QeKvt7mdKykgiVCye01haVx/zJd35jj
	 XqrMMa8EsYsKGW01lwxbPnlFE8HYogK9QonI/d4WqVMst6SduMRYccPQGcd/H0t21/
	 i8F2lYPjK7DedeMitCntcYQMxJNp9ANCnm9kvzrmhdh5m8LTGEgCXHMUOEIJy0PiRv
	 GGH9A321YtC80XyDYSRP3Wj905dGSNtG1e0jcALQu0a6WQLdLuVf5l3P1r+o4+nNJ6
	 SrZ/GATeVGCDu8X+ACr3j0zOsaEpKmtv4D4JnDCnbcoD9MkhRLNwRZrXXtUMVl7+c0
	 I9A2TZf84GVig==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,5.15 0/1] Netfilter fixes for -stable
Date: Mon, 17 Nov 2025 21:40:22 +0000
Message-ID: <20251117214023.858943-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Greg, Sasha,
 
This batch contains backported fixes for 5.15 -stable.
 
The following list shows the backported patch:
 
1) cf5fb87fcdaa ("netfilter: nf_tables: reject duplicate device on updates")
   This only includes the flowtable chunk because chain cannot be updated
   in this kernel version.

Please, apply,
Thanks

Pablo Neira Ayuso (1):
  netfilter: nf_tables: reject duplicate device on updates

 net/netfilter/nf_tables_api.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

-- 
2.47.3

