Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB8E215F48
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Nov 2024 20:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730838952; cv=none; b=pkkzRNJ+Ka1ntwBrMkaZZfH4aswTbJy5BewTVNZzm+n+NGpmA5R79TKY4m/uiksXLvXJjH1RqAstr0lQr/GC9vxw2rOPMspkqwENZRzI/98iZrR7MxUSLQ/3E3Bb8jD1BliM4Edd8TeikdUWcY69d9I0f9R+QUHSUVOAsmwr+44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730838952; c=relaxed/simple;
	bh=N2pSTH25iL+iuveGoRoghu5NMq8liGUkiMtn35+IyFs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QrXla5IGcBUKx39EWhmVGdAVGRgNRWShupBQtaLWEo0eqefCRa3La2M+UslU7kOa/0UR20VivFYdmPI6OTxuloC4hCSouIsmV/DJeHeD0XFUC75TSF+BR1giqocIwpayF4r7Th3BvhFV/Xs523p/UAGpyPDwjUPTDeuKoe0Pkss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=R5hjhtZ+; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="R5hjhtZ+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=aq+igimjUePDirrpJjxiFpmfZBbtjLbQiYAuH2qvPDE=; b=R5hjhtZ+xrC/XV38dxjKjjThI8
	xLsEyW5IdNKDRvJoPLAe+XHjsVxHRzhoQssmHjts2SYZmdaXQDBegbFaYxGo5wX3c5wvuFEcna60i
	GtzGVLH/SvE1LVO3emLkk7uE8r9ECLg0cAwTTipZNVVFa9BJO3HRv9Zq/gJsKSRIq/Z7pADNVoM7q
	kGG9xU/tRWIRBl9mMGJgQv3lAODVNCffj/wIBBdtAjYr22DSaOF+wQmt/EgBApFot2CMwR/DiBpOs
	nkv2vx9X9MibkPG7NbfwlJPovDxq3v92bZ8xEYxJVCSG7dDmL8EdAbB2kDt6J86SEQPgrEUg/49f3
	XVFZl6xg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t8QHD-000000002vi-19fK
	for netfilter-devel@vger.kernel.org;
	Tue, 05 Nov 2024 21:35:47 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/3] ebtables: Simplify ebt_add_{match,watcher}
Date: Tue,  5 Nov 2024 21:35:42 +0100
Message-ID: <20241105203543.10545-2-phil@nwl.cc>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241105203543.10545-1-phil@nwl.cc>
References: <20241105203543.10545-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that extension options are parsed after these functions return, no
modifications need to be carried over to the clone and undone in the
original.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-eb.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 06386cd90830c..86c33b4e7dcb6 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -371,23 +371,17 @@ struct xtables_match *ebt_add_match(struct xtables_match *m,
 				    struct iptables_command_state *cs)
 {
 	struct xtables_rule_match **rule_matches = &cs->matches;
-	struct xtables_match *newm;
 	struct ebt_match *newnode, **matchp;
-	struct xt_entry_match *m2;
+	struct xtables_match *newm;
 
 	newm = xtables_find_match(m->name, XTF_LOAD_MUST_SUCCEED, rule_matches);
 	if (newm == NULL)
 		xtables_error(OTHER_PROBLEM,
 			      "Unable to add match %s", m->name);
 
-	m2 = xtables_calloc(1, newm->m->u.match_size);
-	memcpy(m2, newm->m, newm->m->u.match_size);
-	memset(newm->m->data, 0, newm->size);
+	newm->m = xtables_calloc(1, m->m->u.match_size);
+	memcpy(newm->m, m->m, m->m->u.match_size);
 	xs_init_match(newm);
-	newm->m = m2;
-
-	newm->mflags = m->mflags;
-	m->mflags = 0;
 
 	/* glue code for watchers */
 	newnode = xtables_calloc(1, sizeof(struct ebt_match));
@@ -409,17 +403,13 @@ struct xtables_target *ebt_add_watcher(struct xtables_target *watcher,
 
 	clone = xtables_malloc(sizeof(struct xtables_target));
 	memcpy(clone, watcher, sizeof(struct xtables_target));
-	clone->udata = NULL;
-	clone->tflags = watcher->tflags;
 	clone->next = clone;
+	clone->udata = NULL;
+	xs_init_target(clone);
 
 	clone->t = xtables_calloc(1, watcher->t->u.target_size);
 	memcpy(clone->t, watcher->t, watcher->t->u.target_size);
 
-	memset(watcher->t->data, 0, watcher->size);
-	xs_init_target(watcher);
-	watcher->tflags = 0;
-
 
 	newnode = xtables_calloc(1, sizeof(struct ebt_match));
 	newnode->u.watcher = clone;
-- 
2.47.0

