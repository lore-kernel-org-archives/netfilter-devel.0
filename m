Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8889112C46D
	for <netfilter-devel@vger.kernel.org>; Sat, 27 Jul 2024 21:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722116221; cv=none; b=C4kmV8Ipezu5gz0G5kdf9ZO0oNN2Lx4EF0/Mkq3JAHVnK5Dpw+PI07X0RS/caqVohS8S3+sBGQ8Ccbg4ihh0w4SpfsQvPJpFkEbxHGg40TO6wMo0NuYkpNFwmplAoj92NUt3W0zqdYtlSc55EVkXrAPW82rkgbmpZHZbeZllPfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722116221; c=relaxed/simple;
	bh=kEsXbrw70zmhkCWtetB+9ZsccnspkG8PsqhtS7DNTyg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ge5wL5pXFU6/auUSDe0Q6ZmW0GfZsKCoe373fIUL/DBAIQbWXCjZwlJ+TDwFBcYIqsxejbAgBPqqpb6FgiAbnzWr4MOIXiNZGzA0bcQuLFM0aalTnlfYQ/7xtjj9DnUgys8hYHU+SqNsMxpX722+i4qoMV12QKru/HBwDcyNGtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ALG98Dau; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ALG98Dau"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2yrRagr+/bEXw5Fz0oN2WM3UkYKpGvSZpSlZeoQw3t0=; b=ALG98Dauex9FZPZ2LmnSxRK9nD
	KRT4av3NM4YHgyj36rtri03jrtTsNpD9ipVzxt/cMWgl7qz0qjhq1QJcMPmPgzDl1Eq2ZYNDFDg6E
	tvzRMkEky4yunjaMhss9e9UW8dnfexfVbWbKNuz9cPk7NMIbrVsKxRVpA+Vub6AX+rI1KO1rUS7Y1
	DGGODiyF/ZJWTaNvpUI1E5m16NCtTgrZLs/0nU8LFGyVIticv1A5O6O6ryObIvrHTOWdjj6uSONBp
	oiRAAmFp6tRvpZnfuAi+4nx5xcIixrg022XX3BetgFULQOxQImplwxhztCRqhnLdMlaKfIP3sPd28
	r6WONe0Q==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sXp62-000000002Uu-08JA
	for netfilter-devel@vger.kernel.org;
	Sat, 27 Jul 2024 23:36:58 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 09/14] extensions: conntrack: Reuse print_state() for old state match
Date: Sat, 27 Jul 2024 23:36:43 +0200
Message-ID: <20240727213648.28761-10-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240727213648.28761-1-phil@nwl.cc>
References: <20240727213648.28761-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The extra bits supported by print_state() won't be set by the parser, no
functional change expected.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_conntrack.c | 34 ++++------------------------------
 1 file changed, 4 insertions(+), 30 deletions(-)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index ccbf731de7c4d..04940154eb314 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -1102,32 +1102,6 @@ static void state_ct23_parse(struct xt_option_call *cb)
 		sinfo->invert_flags |= XT_CONNTRACK_STATE;
 }
 
-static void state_print_state(unsigned int statemask)
-{
-	const char *sep = "";
-
-	if (statemask & XT_CONNTRACK_STATE_INVALID) {
-		printf("%sINVALID", sep);
-		sep = ",";
-	}
-	if (statemask & XT_CONNTRACK_STATE_BIT(IP_CT_NEW)) {
-		printf("%sNEW", sep);
-		sep = ",";
-	}
-	if (statemask & XT_CONNTRACK_STATE_BIT(IP_CT_RELATED)) {
-		printf("%sRELATED", sep);
-		sep = ",";
-	}
-	if (statemask & XT_CONNTRACK_STATE_BIT(IP_CT_ESTABLISHED)) {
-		printf("%sESTABLISHED", sep);
-		sep = ",";
-	}
-	if (statemask & XT_CONNTRACK_STATE_UNTRACKED) {
-		printf("%sUNTRACKED", sep);
-		sep = ",";
-	}
-}
-
 static void
 state_print(const void *ip,
       const struct xt_entry_match *match,
@@ -1135,16 +1109,16 @@ state_print(const void *ip,
 {
 	const struct xt_state_info *sinfo = (const void *)match->data;
 
-	printf(" state ");
-	state_print_state(sinfo->statemask);
+	printf(" state");
+	print_state(sinfo->statemask);
 }
 
 static void state_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct xt_state_info *sinfo = (const void *)match->data;
 
-	printf(" --state ");
-	state_print_state(sinfo->statemask);
+	printf(" --state");
+	print_state(sinfo->statemask);
 }
 
 static void state_xlate_print(struct xt_xlate *xl, unsigned int statemask, int inverted)
-- 
2.43.0

