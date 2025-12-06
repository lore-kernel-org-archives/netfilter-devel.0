Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C589B3B8D6B
	for <netfilter-devel@vger.kernel.org>; Sat,  6 Dec 2025 22:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765058582; cv=none; b=HHOL9amW9B27iGdqIgbK3T25ak2DEPM+jKzHOpnpXl6AGpNWDtVFL6I0fTj9lvxzFlWUuU6CYJHqhBMxGl4hohphF6DdIN13zoMH54QGtAeTh3jQs6+Hd1y/k/epmcGjC0drflc7PN3Z6vRXGDFwhSIiPyh2M5vEXOlRQT1BVRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765058582; c=relaxed/simple;
	bh=O0KaIroBTEqUIsq2enAscj3kaY2/G3J9pNa2PNSgLqg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nyu6TwbDp3WPJhO4z5qYiZMJGkPCgaUnOkfw5B8Q0QS2jReYFCedDJ1JcLtAGXwIhM71WfT3HMAsloifwmmd+J8AXnAoeqELXD4KRC7t9XWWrRIcuW3LmgIV1nEUqZcSyP2J87LOuGz7VwtIdsKR1XdGB1A32QhkbOV5S4O8Fs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=AlbZVNST; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="AlbZVNST"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Date:Subject:To:From:Sender:Reply-To:Cc:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=F7c+EsD8ah0ShcxFt1ld1eBDnWh2urpPeovhEKKj0pA=; b=AlbZVNST/QqS4KVKI7JKYl9V4l
	d7/h+vXk7AARaj7zeFkKfS1WUUogEzuYxtzAEc1oTUDZYY73dj0U6GhjP7vfM066WOqP64+0UxPLz
	St6xko+vDolt0yDqKsQEmhgm0KcnmRAvTNgVQWwlAs+Jn4pHKgtvigXOCcDA+LDm2hC8OwCvcPmQp
	TfjaetSLJHRHlfbXqUbDYTOvYQiadEs42GatQ4cc5VhoH3jZzhZ32GDkT/kCVFNpz+JF4QHqX1II2
	FsKaHpFYF0bRCkM/Rhfdg3A83elRthPLAcvcHwq3N2TqQ/+zYGOCuCkOVBFFO6BHImeremyW6KquN
	TacusNWQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <jeremy@azazel.net>)
	id 1vS0Dq-0000000E8vL-4BZ6
	for netfilter-devel@vger.kernel.org;
	Sat, 06 Dec 2025 21:53:47 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft] doc: fix typo in man-page
Date: Sat,  6 Dec 2025 21:53:36 +0000
Message-ID: <20251206215338.703540-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false

"interally" -> "internally"

Fixes: f34381547094 ("doc: minor improvements the `reject` statement")

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 doc/statements.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doc/statements.txt b/doc/statements.txt
index 0b14398117de..8f96bf6b84fa 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -203,7 +203,7 @@ ____
 ____
 
 A reject statement tries to send back an error packet in response to the matched
-packet and then interally issues a *drop* verdict.
+packet and then internally issues a *drop* verdict.
 It’s thus a terminating statement with all consequences of the latter (see
 <<OVERALL_EVALUATION_OF_THE_RULESET>> respectively <<VERDICT_STATEMENTS>>).
 This statement is only valid in base chains using the *prerouting*, *input*,
-- 
2.51.0

