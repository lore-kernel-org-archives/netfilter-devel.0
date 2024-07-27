Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E255433BE
	for <netfilter-devel@vger.kernel.org>; Sat, 27 Jul 2024 21:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722116220; cv=none; b=p2GDVrYIc+wamhZo6obreHK8pCOl+5o5Ba7+FBBYGVCpB7cpOD5VGPeYHsx+4IrPUp0D5TIFMo6p6zgaR7GXAiSRRfk3i3+B1UVeXCOCVh/Tru+0srQQVYSHvjY5PQ3GBe8DV1ol8Zi6bdUHFSrumyO8mvFRIHAjPSjptvOuU5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722116220; c=relaxed/simple;
	bh=f22gwY3JZIrGB/QtLwe6giDcEwdlmnIojpAoGaX2iRs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akSx83RRGzfVKBSKaHD7a4uAXLrZ82rCfNibNv4xeRYNhhIlF6anuTwCjeu/ZU2oVcWIYTV7Ee9+08dlTrgggTIcWSKu3+XJoQcqanzry9/WYnaW1J8R3HQOo2uOdBdxshkG1pCo9Yp6oWG5/3w6dxOfcipKwzH1lSrhYjl+84U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=nOb/4cAq; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="nOb/4cAq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1UEvJezu5GyPbAi0+FM16nExIDcWJ8a5al6Uuml+xmg=; b=nOb/4cAqAu5/4Zqvq+PAtsoHF6
	PmUOQ8PS73w/Bgp2V4bSfmYhoUkBSrmWsi9WAgs2K+5PN+wK+Tgad1pqmiXGFFZ6ZCWft7hJunl3R
	PNH5hAP+RFnGkT+46Ucb6HRea/XfUhCQQh+SXO/qA2O0RJghP8wIftrbm8vQpovo9W9N/PaDxtXm/
	N758/boUJv33mUI/88Z5444NcWBfpciQtGMbXqsP4FEvVYqdYr++PF8GTzmDxKilqcB6M/6ZQCtoC
	+L5ic2hAa5e7c086TEh/WCWm89Q+2j8LhV3xpumaQNnxdCebCyUfZD17FKXchJcqwbu8mI/G/UwYa
	6mfp0RFQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sXp60-000000002Un-3maJ
	for netfilter-devel@vger.kernel.org;
	Sat, 27 Jul 2024 23:36:56 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 12/14] libxtables: Debug: Slightly improve extension ordering debugging
Date: Sat, 27 Jul 2024 23:36:46 +0200
Message-ID: <20240727213648.28761-13-phil@nwl.cc>
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

Print the extension's real name (if present) and prefix the extension
list by a position number for clarity.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 libxtables/xtables.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 7b370d486f888..7d54540b73b73 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -1171,11 +1171,21 @@ void xtables_register_match(struct xtables_match *me)
 	me->next = *pos;
 	*pos = me;
 #ifdef DEBUG
-	printf("%s: inserted match %s (family %d, revision %d):\n",
-			__func__, me->name, me->family, me->revision);
-	for (pos = &xtables_pending_matches; *pos; pos = &(*pos)->next) {
-		printf("%s:\tmatch %s (family %d, revision %d)\n", __func__,
-		       (*pos)->name, (*pos)->family, (*pos)->revision);
+#define printmatch(m, sfx)						\
+	printf("match %s (", (m)->name);				\
+	if ((m)->real_name)						\
+		printf("alias %s, ", (m)->real_name);			\
+	printf("family %d, revision %d)%s", (m)->family, (m)->revision, sfx);
+
+	{
+		int i = 1;
+
+		printf("%s: inserted ", __func__);
+		printmatch(me, ":\n");
+		for (pos = &xtables_pending_matches; *pos; pos = &(*pos)->next) {
+			printf("pos %d:\t", i++);
+			printmatch(*pos, "\n");
+		}
 	}
 #endif
 }
-- 
2.43.0

