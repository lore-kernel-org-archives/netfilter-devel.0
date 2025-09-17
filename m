Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15FA27B358
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Sep 2025 20:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758141314; cv=none; b=ChKOeoHPvmqfkXPHMKQsnTjtAAekhvProDv9X5O3ykTwewnr1szif9fL+usKif2yu7E8UtfyMvJg5JmIJdDCNmWklXnYmEpUKpFF/WQmI5H9nTtLDaNrjKc5qyfKpNBA6Zm5Vji1oWiuqg3BNRIQ3UhRyg4HId3RPw963TP1l9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758141314; c=relaxed/simple;
	bh=aC8+6dAc6cO4q9wE/BeKGxMNUuaIpHxUAWuXYJ5EcBY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUvdoXKquY90g441q1Nd2zopJFEwAOvcR+RAPDxxh6qbjaMxgACMsqoFCXHOSnHQ84EmoeA8dea9gj6PqAM61vnmy2WXNHwZVCax2IsM3oniGYGRpD0yGBGAhHk54pZkozAJ25PwDtZWyNcuFoNDQGFDfUy8uxA4kih+oDDOIgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=agWPLbOD; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="agWPLbOD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=MrGeAQvryJO1q2ag2BYleAZeVdFLQYBaBjUvCLg8+EM=; b=agWPLbODp2KkQybeZfhMAN+FzE
	7mmk93x3ixw+dAiQmDoIlVVb62n5Jdi6yzje6QKSBpFkkJZ8M3XiXNxTsYn0lK+Umszti0wCV6CfI
	znhIh40PGKA6TR/V9rUMXQUGAEV6wseBxDW44Qa1V29NZSh+7xD8o7bMcXaumE/GYlCkYAJKuXXjX
	mrcoCGsaIm12pEZtFY3+6+JPXsW3DD4hK4lm/I9iv1NSnvtB1vzBfqJI/3j6y3dPntWQw/eD72VaC
	qSrfpQHxLOtJIryyhFFx0gEXj1qfhZDTuF0JYrqsfNsxw7WL87qa8p/5XN1pKt+Xy2Ra76YdiyEWZ
	VrR2I71g==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <jeremy@azazel.net>)
	id 1uyyrm-000000076ym-3rXs
	for netfilter-devel@vger.kernel.org;
	Wed, 17 Sep 2025 21:35:02 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 1/2] doc: fix some man-page mistakes
Date: Wed, 17 Sep 2025 21:34:53 +0100
Message-ID: <20250917203458.1469939-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917203458.1469939-1-jeremy@azazel.net>
References: <20250917203458.1469939-1-jeremy@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false

Correct one typo and two non-native usages.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 doc/nft.txt                | 2 +-
 doc/payload-expression.txt | 2 +-
 doc/statements.txt         | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index 8712981943d7..dbf6b7c8028f 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -701,7 +701,7 @@ map policy |
 string: performance [default], memory
 |=================
 
-Users can specifiy the properties/features that the set/map must support.
+Users can specify the properties/features that the set/map must support.
 This allows the kernel to pick an optimal internal representation.
 If a required flag is missing, the ruleset might still work, as
 nftables will auto-enable features if it can infer this from the ruleset.
diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
index ce0c6a237db9..351c79bce310 100644
--- a/doc/payload-expression.txt
+++ b/doc/payload-expression.txt
@@ -562,7 +562,7 @@ GRE HEADER EXPRESSION
 *gre* *ip6* {*version* | *dscp* | *ecn* | *flowlabel* | *length* | *nexthdr* | *hoplimit* | *saddr* | *daddr*}
 
 The gre expression is used to match on the gre header fields. This expression
-also allows to match on the IPv4 or IPv6 packet within the gre header.
+also allows one to match on the IPv4 or IPv6 packet within the gre header.
 
 .GRE header expression
 [options="header"]
diff --git a/doc/statements.txt b/doc/statements.txt
index 6226713ba389..8105f8497a7f 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -456,7 +456,7 @@ Before kernel 4.18 nat statements require both prerouting and postrouting base c
 to be present since otherwise packets on the return path won't be seen by
 netfilter and therefore no reverse translation will take place.
 
-The optional *prefix* keyword allows to map *n* source addresses to *n*
+The optional *prefix* keyword allows one to map *n* source addresses to *n*
 destination addresses.  See 'Advanced NAT examples' below.
 
 If the 'address' for *dnat* is an IPv4 loopback address
-- 
2.51.0

