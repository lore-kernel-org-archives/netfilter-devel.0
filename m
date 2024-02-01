Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109995336C
	for <netfilter-devel@vger.kernel.org>; Thu,  1 Feb 2024 13:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706795463; cv=none; b=h+d0+SMt5a81RlcnD6bcFfx0cUD9mzHWQERSnl85k+i5InnBzivxkEmhuijJD2N23atV1q1798p1rpoo/dxS9NNCV9gVaPx59UGLZkvz481pOe7c7fE/XCi6xj0fCVsTo1QsBmdaJFjdvuVvq+HKHLKk6LDs9Rm5TkUoJXpFB2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706795463; c=relaxed/simple;
	bh=f4UIlS3uoUiXg3E1PTTu9pTJ7E5Zf0QYFRbvQjKwPqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=irvB4rQtGirppphqLqTzwmCYN3yCN65XMXESi5gmZ+oqqyIyoCHOkNq3EE8JpdDl+Em1SFtyKeTazWkcCEmD40tj4KjoeHjMaBC0T+QTPAyiumD/L1iC2xwXxCA+EQHkIFLbQh9tO5wuYd9oBsXOUYfl3Q5WPoXG7my9lh/nIIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=oUgXsLOY; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="oUgXsLOY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mj64cQUHMGcLodVpEQVciBdlhgsBwvgbLQUPIz2ErZY=; b=oUgXsLOYYRxUVNaT2kLAcrS1ww
	E9o0oR4GlcJL2XIeFr2kKG16PpKDSx4nFnVNvhI0OWSeoHSVRfTw5MymV9Aw4CcuGBhHbwxqUBRYt
	oVLpAUzH1MX8+o6bi7XfWGF7pjHRePQxqn19JFy+CbakV5OPccZwG9qNly3U+0MQQi788Sc1cxKpb
	VdtOE/bsh5Pu3G5KxYTRo94NqxfKNoA8x3kXkicYEqLu+bztnV+YAlBGBT5JLFGkJ5ksRMppvF5NQ
	xs+pdawggfe9Npchip9l1HxspBYPJF+OeiNsGZ08StDyeS1Ad6x1kKjldyf+a1oTNs885tRHN1rkc
	Bno8M1FQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rVXT0-000000001Ls-1yLi;
	Thu, 01 Feb 2024 14:50:58 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [iptables PATCH 3/7] libxtables: Fix memleak of matches' udata
Date: Thu,  1 Feb 2024 14:50:53 +0100
Message-ID: <20240201135057.24828-4-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240201135057.24828-1-phil@nwl.cc>
References: <20240201135057.24828-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the extension specifies a non-zero udata_size, field 'udata' points
to an allocated buffer which needs to be freed upon extension deinit.

Interestingly, this bug was identified by ASAN and missed by valgrind.

Fixes: 2dba676b68ef8 ("extensions: support for per-extension instance "global" variable space")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 libxtables/xtables.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index b4339e8d31275..856bfae804ea9 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -1420,6 +1420,10 @@ void xtables_rule_matches_free(struct xtables_rule_match **matches)
 			free(matchp->match->m);
 			matchp->match->m = NULL;
 		}
+		if (matchp->match->udata_size) {
+			free(matchp->match->udata);
+			matchp->match->udata = NULL;
+		}
 		if (matchp->match == matchp->match->next) {
 			free(matchp->match);
 			matchp->match = NULL;
-- 
2.43.0

