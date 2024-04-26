Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B970F145343
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2024 14:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714142671; cv=none; b=IvMivek2Qq7u2AfeL2ojf8S1xkRjB1poIcOLWFzTXPbTs9Ebp0zieyAlLPIg4kDhQFcnTuxQ/IAOjCCUuTmpzPnJJC/J3mNNnxLdhwZwokkgHxkby9TS4bwTMIfyNKXsbx3BYGgm362GXftE4bd6KBOkfLvjIsRlCGz9nNlMhUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714142671; c=relaxed/simple;
	bh=Qa2Q47fPM2PDghiaeRci4XkQ1Yf9nQsC8DbOWnNZjfI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YnUnHezE7RNIwEUu3KMuobGFK7d7DAwYnoxqkYXUMahe7YXe9WwOgBChxHKj5qMi00EFNn1yWuQODPmhk3wqyW3NtMFZU+P6qmYyrroJUWbgtIPkXM/RDezGyBZFfwUMvbtOAV46SucIwZr1GWQU+pRYF3W87WhL7/XxBMwh8IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=qBJrqxON; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="qBJrqxON"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XDF9b6seQSJzFSgcPu66i4HqLSU9m5gPDb3KFpRhLqk=; b=qBJrqxONZtpz0S6q5as6TrMmTN
	A/in8tK4Rgk86Cycr9AJ49HSV/bhqpmUMnS3J7Jud5Du7MN6Xrab874SM5ql1VpBylRBelifj4cuY
	zsNhZtEXqqoIi19urrBzDcaMCoJe+Lg9csAuEdXmUtLCrCBk2+rnKgbAnImYA1Em0PGDRkWDKZPuC
	qS4gjlSLq9S2woDn20a+VSKOD62Ls/XHjt10821r/vnJ+5ahxOzBkBwEX7ZHzkvvSdyN4WmTgWOSg
	JcoHqOYkHf4T8xPJ5nDbAWd3GDeBGlfDvNT1aZYN/X1pOfC3JoNyyrzIiGHFUtVgMzrO4AXQSVWAk
	4gxfBbOQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1s0MoG-000000002gU-30qJ;
	Fri, 26 Apr 2024 16:44:20 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnetfilter_conntrack PATCH] conntrack: bsf: Do not return -1 on failure
Date: Fri, 26 Apr 2024 16:44:20 +0200
Message-ID: <20240426144420.12208-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Return values of the filter add functions are used to update an array
cursor, so sanely return 0 in error case.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/conntrack/bsf.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/src/conntrack/bsf.c b/src/conntrack/bsf.c
index 48fd4fafbc3e5..1e78bad9b40ec 100644
--- a/src/conntrack/bsf.c
+++ b/src/conntrack/bsf.c
@@ -336,7 +336,7 @@ add_state_filter_cta(struct sock_filter *this,
 	s = stack_create(sizeof(struct jump), 3 + 32);
 	if (s == NULL) {
 		errno = ENOMEM;
-		return -1;
+		return 0;
 	}
 
 	jt = 1;
@@ -403,7 +403,7 @@ add_state_filter(struct sock_filter *this,
 
 	if (cta[proto].cta_protoinfo == 0 && cta[proto].cta_state == 0) {
 		errno = ENOTSUP;
-		return -1;
+		return 0;
 	}
 
 	return add_state_filter_cta(this,
@@ -448,7 +448,7 @@ bsf_add_proto_filter(const struct nfct_filter *f, struct sock_filter *this)
 	s = stack_create(sizeof(struct jump), 3 + 255);
 	if (s == NULL) {
 		errno = ENOMEM;
-		return -1;
+		return 0;
 	}
 
 	jt = 1;
@@ -520,7 +520,7 @@ bsf_add_addr_ipv4_filter(const struct nfct_filter *f,
 	s = stack_create(sizeof(struct jump), 3 + 127);
 	if (s == NULL) {
 		errno = ENOMEM;
-		return -1;
+		return 0;
 	}
 
 	jt = 1;
@@ -605,7 +605,7 @@ bsf_add_addr_ipv6_filter(const struct nfct_filter *f,
 	s = stack_create(sizeof(struct jump), 3 + 80);
 	if (s == NULL) {
 		errno = ENOMEM;
-		return -1;
+		return 0;
 	}
 
 	jf = 1;
@@ -704,7 +704,7 @@ bsf_add_mark_filter(const struct nfct_filter *f, struct sock_filter *this)
 	s = stack_create(sizeof(struct jump), 3 + 127);
 	if (s == NULL) {
 		errno = ENOMEM;
-		return -1;
+		return 0;
 	}
 
 	jt = 1;
-- 
2.43.0

