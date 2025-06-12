Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0E922333B
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Jun 2025 11:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749729152; cv=none; b=hqexNPEiu9txgXNIsR1ijk+0UFlMdp6FZddZqkeTmbt4DmwwanPMhO9K1nfcb5T3r/HxH2XtiYId49rcvBKy3BBojTYFWo2Wx680Kwa+TyTrm4jxcX+k+NTf6tZExKKGPGLIFwU7gp1zz0rIbUYy85QFqnI3uALjVA2XIC2oN1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749729152; c=relaxed/simple;
	bh=cBEEf616c2IGjJ78lhC5dCsFrswc5Qq2HgiAh3BpzIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0C31fxwrk8pGBJRXbvW8zH5gUAuPxytgOWuBshP9ujWrgxHEr4Sgv0qN4ecoWHIOdehBkbIaUemBaZ7oeCef3yBoXQzHkoIphUSSgh5/r0D8lDH5eYKyKGFBdDOZES3VBoMPgOPNaaZe5Mlp9deHDTIQNE8JRXhOgb3Kgmf8po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=m997qs2q; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="m997qs2q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+7TnF4ehYvXurcSvQNQdxO8fEOw2k4H5k6OEDg5kXQY=; b=m997qs2q6cHHAl/5UiDZE9Xhpj
	3k+TtRSYvS12VReq0HrfAbIYCV4+MzVh8elPoL+/E7zrcazKKhK22fxGQ62rDMyjQYSuwP03D8sYP
	MRBY9b4W4xfreJ7BYstXTiITKHWYwyJNWD83sdpDxutSkLEtDYNYf99kJTXijBMM8rxuDTmMIDSej
	xqubvkUXhay6lqHss4s23EJpWPtwBqnrajv0xVyEVLs1fm5uQM8TBN0W0Q1BCyk58WeYEKbovSlbm
	NXwmffOVygMNW12fEUlphlS9k7i7MP1vGdGhZ5XNu/MV39t2QEtbZrSmFrdK1QRhVwpQI6UKyOd9l
	1SKcEJ8g==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uPgTs-000000006Fk-0wp5;
	Thu, 12 Jun 2025 13:52:28 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 3/7] monitor: Correctly print flowtable updates
Date: Thu, 12 Jun 2025 13:52:14 +0200
Message-ID: <20250612115218.4066-4-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250612115218.4066-1-phil@nwl.cc>
References: <20250612115218.4066-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An update deleting a hook from a flowtable was indistinguishable from a
flowtable deletion.

Fixes: 73a8adfc2432e ("monitor: Recognize flowtable add/del events")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/monitor.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/src/monitor.c b/src/monitor.c
index 4ceff94824432..e3e38c2a12b78 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -577,14 +577,18 @@ static int netlink_events_flowtable_cb(const struct nlmsghdr *nlh, int type,
 		nft_mon_print(monh, "%s ", cmd);
 
 		switch (type) {
+		case NFT_MSG_DELFLOWTABLE:
+			if (!ft->dev_array_len) {
+				nft_mon_print(monh, "flowtable %s %s %s",
+					      family,
+					      ft->handle.table.name,
+					      ft->handle.flowtable.name);
+				break;
+			}
+			/* fall through */
 		case NFT_MSG_NEWFLOWTABLE:
 			flowtable_print_plain(ft, &monh->ctx->nft->output);
 			break;
-		case NFT_MSG_DELFLOWTABLE:
-			nft_mon_print(monh, "flowtable %s %s %s", family,
-				      ft->handle.table.name,
-				      ft->handle.flowtable.name);
-			break;
 		}
 		nft_mon_print(monh, "\n");
 		break;
-- 
2.49.0

