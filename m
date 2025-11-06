Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1CD30DD3C
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Nov 2025 11:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762427847; cv=none; b=jF7i+Mvqow04P5HzpRqxGUiE9UnBPb52x38KLcCYRmB6K5aON1h3fm0UVSqfhZhQL+tamT07prOrCBQw7mDi30At/y9LuKwRdqx6pqSHiho1Zm8riZ+gp9G1pqTXaJLkQqyrbW5F62sdCHzYQmpnl1IwmNTe95Tv56eFPWVeoLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762427847; c=relaxed/simple;
	bh=w5HlPIaZK9SmP64cRE+seGVcRBfxyLu2qTH5krNQbTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eGzfE1p9cMjsXXSBFvqTZvRbHh/SU5Srl6Li9EggB+5vWdr/UpCWA61t4hN0YEMOY7q/zmES8Aw9m9uiVobz1Lojwalbbq1vsEN5JMifwI7g0Q/A+zpM6GY/Shy/e0Ojz8E9kawJC/GACakHv5NhM0l3cJ6SmzKkExySAyQsEzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Z3cyjhj9; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Z3cyjhj9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9MwYBqBmzO30ukN4OapwnhPI/sV1qpM3Lcxn+zEMjcg=; b=Z3cyjhj99YMnKOt+zpyRGvvwK5
	Xt4L6qyO4ZqOCB1g1cRfd4LzGuKnSBwkkOQ225XSaPyZElhj8nr7HlYBTmokos4lyYfmpPIUoy+rf
	eMxilhNRbYDLnq6cXxat/dYgRgJeShKnCk02KJny91jTx0GZ83YZhEfZKAkxSK2h3nIw3N6NFQCxf
	kweUbn/ZjYxAlFAGetbFJDCDlx9bc4ekgo2blXhpYbMl+QHo8a1c29eKoMsXlykWR1DOunxMZknHn
	Ygmb/xWMiXzmZjzRURzNUJRpQFpqGvP5qhE/qxkuqv+PWHXmaq2aFAO+mRja1KqVDEP7Q3QQ6Zh4r
	5X/RcYyQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vGxzW-000000000bw-2WOY;
	Thu, 06 Nov 2025 12:17:22 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] doc: libnftables-json: Describe RULESET object
Date: Thu,  6 Nov 2025 12:17:17 +0100
Message-ID: <20251106111717.9609-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Document the syntax of this meta-object used by "list" and "flush"
commands only.

872f373dc50f7 ("doc: Add JSON schema documentation")

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/libnftables-json.adoc | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/doc/libnftables-json.adoc b/doc/libnftables-json.adoc
index 643884d5c1063..049c3254ff03f 100644
--- a/doc/libnftables-json.adoc
+++ b/doc/libnftables-json.adoc
@@ -200,6 +200,18 @@ Rename a chain. The new name is expected in a dedicated property named
 
 == RULESET ELEMENTS
 
+=== RULESET
+[verse]
+____
+*{ "ruleset":* 'RULSET_PROPERTIES' *}*
+
+'RULESET_PROPERTIES' := *null* | *{ "family":* 'STRING' *}*
+____
+
+This is a special object for use with *list* and *flush* commands which will
+then operate on either the whole ruleset or the parts of it belonging to the
+given family.
+
 === TABLE
 [verse]
 ____
-- 
2.51.0

