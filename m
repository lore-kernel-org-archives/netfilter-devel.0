Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9451E32BE
	for <netfilter-devel@vger.kernel.org>; Thu, 29 May 2025 20:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748550744; cv=none; b=KmVyUoPDrQ3aGd2E5MAhWEPCss2sDCLYlVQz/4ZJ7E3G3Xgh3/gSQ7DTvMi3HCT6sa0xaw3ewOG9KXTRv3YJwr1l59jgLYynZXWJqU7IWowTXURerz7swkGShGdYVK6bM4qxsBqjK7RVLQXdlpOKXjqvIYcPHFd6yvYZ4fNeBJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748550744; c=relaxed/simple;
	bh=gmZBcy2ESMXjfTKO3w/829tMbNA07qf37FqmqiJx5BI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lgMQ5F6T3KwoFFzyWPRT3gKAvJ+4pGjHswai3vi2PJac0dQey+nAOkPIPB7P8GJXEBs2aQDJSFsL+O4Xzp+dgxEGi4Nrjs/7CQV1NMV+76rIQTIee3UK0QJCeD0zL5lRNmjprUKPqA6FsSG6acchndYTItXAr6JsZYnTtvGrTBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=BUJcnfXP; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="BUJcnfXP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=YcjwPyXHx2WWhfDQmawOqWa1cn6LRWu4XlptNY25hM8=; b=BUJcnfXPRLXNYoTQhWSymfYuKn
	CaI7VHt2taKbdyj7G/ikp9ZQiRV65pQW463jp7+GOxljpP7+7IJAmZanAAg92MuNbBnPD1kTwxQiI
	t3nL2plteJ7bbCDa9jU+/gZWYN6dV6TLhCP70IMYbYeTluIe3c+NJesGlt8HcTlauKPbuqmdoH+Is
	eq2NcgNUB82q4FljL6Ynqd2SEpXMOoWub26XWxuSHJ/JSOAxm9Z1BXb2EqZbtSACo9IofMbjfiYcZ
	hL1M2bYAfo6V5NcVsy829u/oZF0+e6LulQjC2SXGpo1snUX4q01locpesOZk99R04cNhZmguROtvs
	ObMqaxSg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1uKjvA-003Dw5-1I;
	Thu, 29 May 2025 21:32:12 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Jan Engelhardt <jengelh@inai.de>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 3/3] build: bump max. supported version to 6.15
Date: Thu, 29 May 2025 21:31:46 +0100
Message-ID: <20250529203146.2415429-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250529203146.2415429-1-jeremy@azazel.net>
References: <20250529203146.2415429-1-jeremy@azazel.net>
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

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 7acbf61dd3a5..9dd484455dcc 100644
--- a/configure.ac
+++ b/configure.ac
@@ -63,7 +63,7 @@ AS_IF([test -n "$kbuilddir"], [
 		luck=0
 		unsup=0
 		AS_IF([test "$kmajor" -gt 6], [luck=1])
-		AS_IF([test "$kmajor" -eq 6 && test "$kminor" -gt 12], [luck=1])
+		AS_IF([test "$kmajor" -eq 6 && test "$kminor" -gt 15], [luck=1])
 		AS_IF([test "$kmajor" -eq 5 && test "$kminor" -lt 4], [unsup=1])
 		AS_IF([test "$kmajor" -lt 5], [unsup=1])
 		AS_IF([test "$luck" = 1], [
-- 
2.47.2

