Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B54A2110
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Aug 2025 12:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754657153; cv=none; b=SM3Twl86ars/LOR/QliNuWzCYz7JuW8t8VkIgdJoGQCDKknvFOoGz7op1LR54i6IOKiqbtmI4LIFj5/9I1ezwiln2WhVnG36r38p7WIqag2i8d+NtThjZDbLcgMl+jIUiFj6BOda8AYctjDEwddIZJ7XBURpgJaFaD1VxYR0s1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754657153; c=relaxed/simple;
	bh=/PkP5ljVVF/QWexPd1b0woV4DuzWOuai4cYCSdpfi9o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I2V3S10ZdWrzTNCO3EfG7j+NnbKioWcK1SQKjpeRtnUovtLX7VawhnSZVLj5+rPvLJuuAsPli/4T3Torohz6/V9EbVDe2EbrNH5WMNhM1aAxwsYXfmNC6H/evjgWaYg0uqdQIZFMblvFoXAy1BlAbRd8VZ0Ld4pn8iXeEmAiro8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=MW7JbFSl; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="MW7JbFSl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=RZCvYW5z3xlknm+jXdO7lApL8Y+3U6ooa1GLxiJzLqQ=; b=MW7JbFSlW2Q1nXJv2CdfnmAAry
	SAoS+qMd79cN2yTLhkLBGE/p/PFXQSMonkWwLrUnnJmNffRlBAxFt2MwbYeg2k0MNqE34oQKkgY6u
	ELgg2ZFCSvSGG0HmiR2OeF01QACVi6TCbJ0aDMzyN9llpKkF3xcQf3SY9TO1pimJ5ddlb5Nlm6Bxu
	U+Sin5IDH+Jfkj+a5McWP+rm1I6zrg+mt6RDg1SmaFdEsJnSWBCorG9v3PyCqzq14YqJKpnyOCPx4
	/0Z35yjXbzVeaiH05kYD544aVB000BNho4LLaLlIGvI6N2vuhr/y4Dw2amJsHW2EsUWWWxR4rxFms
	fZgZ5HHg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ukMTd-000000001rQ-3iqG;
	Fri, 08 Aug 2025 14:45:41 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] src: netlink: netlink_delinearize_table() may return NULL
Date: Fri,  8 Aug 2025 14:45:36 +0200
Message-ID: <20250808124536.30434-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Catch the error condition in callers to avoid crashes.

Fixes: c156232a530b3 ("src: add comment support when adding tables")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/monitor.c | 4 ++++
 src/netlink.c | 3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/src/monitor.c b/src/monitor.c
index e0f97b4a204dd..da1ad880f0c83 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -237,6 +237,10 @@ static int netlink_events_table_cb(const struct nlmsghdr *nlh, int type,
 
 	nlt = netlink_table_alloc(nlh);
 	t = netlink_delinearize_table(monh->ctx, nlt);
+	if (!t) {
+		nftnl_table_free(nlt);
+		return MNL_CB_ERROR;
+	}
 	cmd = netlink_msg2cmd(type, nlh->nlmsg_flags);
 
 	switch (monh->format) {
diff --git a/src/netlink.c b/src/netlink.c
index f2f4c5ea8c87b..94cbcbfc6c094 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -841,7 +841,8 @@ static int list_table_cb(struct nftnl_table *nlt, void *arg)
 	struct table *table;
 
 	table = netlink_delinearize_table(ctx, nlt);
-	list_add_tail(&table->list, &ctx->list);
+	if (table)
+		list_add_tail(&table->list, &ctx->list);
 
 	return 0;
 }
-- 
2.49.0

