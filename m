Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B039830DEB6
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Jan 2026 11:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769169533; cv=none; b=jgBtILJdZG66SMESLCJlMfCmi0Y2nYeeYeo/e5a/3Dr52+bFGmgRuD4gToMHNHHdRABD4+ByLaBIxsdKnXlnTgNdt0dkwxdZ+CY56AOps3aVHf+NBfvhzE4ULtkV22Ggano/G03exAjHirMLiOZNf9Se9h4R00F/XlMTE6lhdrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769169533; c=relaxed/simple;
	bh=CQopa4ToxngkCLW6db0R5eNTrakO2VnTE25Sduk1lpg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=PgmypAWXJvEJ0ufZRTvw6NveAnlkg/yYReVJfM/MR8zbpiLNDcV37WQ1MZRL4/fw1a9BqjON2epvp52em1jy/qgLiX8gqg+ui1qJmWkmAbmNdbZq7f/wwxjZU02Scq7v4cOw0cx93Ud0+HKCV39P6vTrBUqHXhmj6xgDjP2a3bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=SllLmm+i; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="SllLmm+i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=RMSEOgpetGnw9wHtcKhya/9wJrMUF9Vpbtmc2eQccSI=; b=SllLmm+iQ5inh2DCkwCJB2NibV
	ornSpfpjLftYjzTsaK5EGRusj6390JWLL28GBg5FbtBArbDKrl4gqV5HwgZxJwFQ6QZoGzkI5PR3j
	SzIF0pCyHMYDFlNIb5cKHwKPAwHhQZ2WQUWPWl/1VimTlKAl89ngsT6t3WMKVE6SS4mJF/HIWlfJy
	NbQJPTfE+EG89O1AgV+mgQOMGht5RJFbxFnpRTDa32co1e1EOTmyxLp/2GDRcOmH0ui/Rq5CqnImU
	XHt8RR+QgOTsohWR7yio35Z85Xnw33qd2ZG8ce5C9yjfs+sMoY+plHlerGCbxv3svNXnTwBvykb7j
	GWurTzOg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vjFoJ-0000000046E-0abA
	for netfilter-devel@vger.kernel.org;
	Fri, 23 Jan 2026 12:58:43 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] libxtables: Store all requested target types
Date: Fri, 23 Jan 2026 12:58:37 +0100
Message-ID: <20260123115837.11177-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Repeat the change in commit 1a696c99d278c ("libxtables: store all
requested match types") for target registration. An obvious use-case
affected as described in that commit is an 'nft list ruleset' process
translating different families' extensions in one go. If the same
extension is used in multiple families, only the first one is being
found.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 libxtables/xtables.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 5fc50a63f380b..af56a75fcb117 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -1345,10 +1345,6 @@ void xtables_register_target(struct xtables_target *me)
 	if (me->extra_opts != NULL)
 		xtables_check_options(me->name, me->extra_opts);
 
-	/* ignore not interested target */
-	if (me->family != afinfo->family && me->family != AF_UNSPEC)
-		return;
-
 	/* order into linked list of targets pending full registration */
 	for (pos = &xtables_pending_targets; *pos; pos = &(*pos)->next) {
 		/* group by name */
-- 
2.51.0

