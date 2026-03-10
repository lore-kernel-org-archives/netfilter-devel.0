Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368F537267D
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Mar 2026 23:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773184284; cv=none; b=f4Pwvq/ZYANvAruc3SmTexsZPV/RcyC851yuc/6DGObCdohTuvGyM8cyB4jZDAAt5VCpkNPkNAA3CQ3CUyOMjauZxE7OBf5JlBRbZ198fQwWCZ2VbjhG5ZRXdK0A0r7VSB7Sug/Pj6mQcTTeLFY2qW5D1yJ4FmWCpLJEj66b6GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773184284; c=relaxed/simple;
	bh=iY5UzPUH/aDJWUrVAcxF4eRbBE+5U/nfb43Pv2WUFdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FBpSyQNWd+rfMDzLDOPS4VOxPbLJf+ZDqjpUyQJNZD6j9dZUqX9AqWNc6q9A4TmSDai+Ba+I93YbMhujLmfgMge3VUNRRvyrLQuIbg5zjXYaTrR7LbRzaSQ6xniBBV24NDnHeW4lCddoyQHXDGle8H18U40GPNOlqDsCcekJrFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=HGDIBWK9; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="HGDIBWK9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mf8GVkAxtfP/Q6yVQLlzuetOoc+O5aB+ZCTvZURyR8Q=; b=HGDIBWK9RBLaAdHhCbLTryszye
	zAkFnEwJier9IfDaRhfZDn0rLg61aEzfXOUbZ6ghgUWpQUWwtjzCK/WrtymUliwXMKJp4Um2nDrFe
	6Uc4/TY8M5usAFjxkF2WZhgP/4Wce41iodkXZa8EOT8+FD30037ZEPf6nbSY8nzjH5p29hSF7wHfD
	dJxGeXimtrw0Oniq3r30paDwfDFsTm6SUqp6tQuTQLiOWYXVq8xnRJ43UewGIEGh5rBhd4e5u7dP1
	xQgMo72mUWWc/v4byFRAlvp54u9O5wqz4ENWO/+05Sk6Y0paVTJririoTKfDmQU/9ESQ3RXVaXmx9
	Yzsf4GMA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1w06ET-000000004qi-3zbq;
	Wed, 11 Mar 2026 00:11:21 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 3/5] cache: Relax chain_cache_dump filter application
Date: Wed, 11 Mar 2026 00:11:13 +0100
Message-ID: <20260310231115.25638-4-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260310231115.25638-1-phil@nwl.cc>
References: <20260310231115.25638-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While populating chain cache, a filter was only effective if it limited
fetching to both a table and a chain. Make it apply to 'list chains'
command as well which at most specifies a family and table.

Since the code is OK with filter->list fields being NULL, merely check
for filter to be non-NULL (which is the case if nft_cache_update() is
called by nft_cmd_enoent_chain()).

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/cache.c b/src/cache.c
index 82efd476e3698..13d4cb19eb4f6 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -625,7 +625,7 @@ chain_cache_dump(struct netlink_ctx *ctx,
 	const char *chain = NULL;
 	int family = NFPROTO_UNSPEC;
 
-	if (filter && filter->list.table && filter->list.chain) {
+	if (filter) {
 		family = filter->list.family;
 		table = filter->list.table;
 		chain = filter->list.chain;
-- 
2.51.0

