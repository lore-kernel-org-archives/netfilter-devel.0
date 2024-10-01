Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A811D1BD000
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Oct 2024 11:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727781668; cv=none; b=Qy6MlwyzY59usnKANfULNQpz5xx7FGIXJCmjSLMSOGGxbdlCyXE7eQzvZCYf4Ew3G6+R9SZFwBM9gM3l6ETAHWzfQNCgv8aGnbCYluYeHQ9qBoLJPkRnhoZVWeZIHj99uRtBIL2TgiyEh6CfU8pqMXquCGVQMlQlFgjNEkdr7tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727781668; c=relaxed/simple;
	bh=HUySr2cDaUAXe4DoIAOQwwNsAOpyCX/jAsqNaPeg//M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ij0ocF44T3mBdtOgUxWayq/EgoGrfTLpLCb6+SxVHlEdNrE5vtsLVcIW2CSVDSEB+VLMyLr/m1Sc+707M1z5sZpB7QKQRXkk+L1IQsWy7QQVozPbkL9hPFQoC4a8ZfPsuTrIdCsF3FhqXwe7hiATuF77DrzVhdTB/O7gs9H3at8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=MV6gprA6; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="MV6gprA6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=83tfekc5Rl3tqjvutKPqLSSUwEAjcxZQQJqHQww19nM=; b=MV6gprA6wIFcxXJqwbSiKrSmZ1
	r2fe+XHvEScfdXMKpVyyEoC/0fGJLH2F323gcxmpjGuE8s4fFoQ4ZYfhOVYl0pLA6gXbBUG7Ni85N
	MVhYmwSoKwY0EIWXHSSkDwaxBbax4Pg2kmNN7zSqAOYZ6A80gKbNzjZRuf92ae5WBvU3hlnr/GKy3
	OZANK2JPyS9gb8c86HiDUOzyvAjobWCVjjs4VtPr3PnHLyT9z8aJ8BPzllEbo6MUs0Akr0fyQaWg5
	MZApBzhJYtho6SJj6kWhDMKjIc8wOvDTdqxIjymdR/2c0yLb3itsquUvdaKu+kPC0jaSVAA6e+opt
	vq5jnhBQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1svaw5-000000005sp-3RqU;
	Tue, 01 Oct 2024 13:20:57 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH] Partially revert "rule, set_elem: remove trailing \n in userdata snprintf"
Date: Tue,  1 Oct 2024 13:20:54 +0200
Message-ID: <20241001112054.16616-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts the rule-facing part of commit
c759027a526ac09ce413dc88c308a4ed98b33416.

It can't be right: Rules without userdata are printed with a trailing
newline, so this commit made behaviour inconsistent.

Fixes: c759027a526ac ("rule, set_elem: remove trailing \n in userdata snprintf")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/rule.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/rule.c b/src/rule.c
index 811d5a213f835..51d778d095317 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -601,7 +601,7 @@ static int nftnl_rule_snprintf_default(char *buf, size_t remain,
 			SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 		}
 
-		ret = snprintf(buf + offset, remain, " }");
+		ret = snprintf(buf + offset, remain, " }\n");
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	}
-- 
2.43.0

