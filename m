Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB5F142634
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Jul 2024 08:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720774555; cv=none; b=MJnfhuwpg/eNwbl1+Qq2akzC44XD2nuB5jgD5z3XxNLdE2q/PgGJS3U538VcI4g0BJqBdSKy+RhmX2KGNdT62AfWfTAxfHp6/IaR3W2gxUlU3AwNv503Gli+9xrKX6uy1GOlGDAQn0B/zDo/xv2XfR4ZTbg7oPRQj6MZbMa5gew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720774555; c=relaxed/simple;
	bh=q9hMigfKE0OAZVnKGDEiu/8P1ZSf4gA0qpYVbhbkLa8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z1YlwA00QCLhLwws5oe5/A2fPiiZatjBlxgpvzwRQbq/9MgMAW7256cimfho0D2RL779RaHbjRLgPnnyrzRyrVor47k5KsSpxPTig5xcv1k4HX7vHiVBfpItIJZW0qqPowBRy/iEMsadM3hCZx2MF08TrSm7eIuHQNBPJAq+Q/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=osmocom.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=osmocom.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.94.2)
	(envelope-from <laforge@gnumonks.org>)
	id 1sSC45-001kjN-6H; Fri, 12 Jul 2024 10:55:41 +0200
Received: from laforge by localhost.localdomain with local (Exim 4.98-RC3)
	(envelope-from <laforge@gnumonks.org>)
	id 1sSC3z-000000006FD-2O0N;
	Fri, 12 Jul 2024 10:55:35 +0200
From: Harald Welte <laforge@osmocom.org>
To: netfilter-devel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>
Subject: [PATCH ulogd2] README: update project homepage and mailing list addresses
Date: Fri, 12 Jul 2024 10:55:17 +0200
Message-ID: <20240712085516.23982-2-laforge@osmocom.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Harald Welte <laforge@gnumonks.org>

The old links were outdated for ages; let's bring the README in sync
with reality.

Signed-off-by: Harald Welte <laforge@gnumonks.org>
---
 README | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/README b/README
index 7e56149..738a4c8 100644
--- a/README
+++ b/README
@@ -1,7 +1,7 @@
 Userspace logging daemon for netfilter/iptables
 
-Project Homepage: http://www.gnumonks.org/projects/ulogd
-Mailinglist: http://lists.gnumonks.org/mailman/listinfo/ulogd/
+Project Homepage: https://www.netfilter.org/projects/ulogd/
+Mailinglist: netfilter@vger.kernel.org, archive at https://lore.kernel.org/netfilter/
 
 This is just a short README, pleaes see the more extensive documentation
 in the doc/ subdirectory.
-- 
2.45.2

