Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DB81B413D
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Jan 2025 20:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738097991; cv=none; b=jxYW9NR8yl2H5SQ9u8TXBUVCSuSf23ZHubwewOQBGfwh0LIcd2dWhktIKnJ/R9njWUv6QJuQlXc6jroXCJ9vLHJuYUx0eru1lOO4HCPjwJeHdO4ZMSHgAX4S6tS3vgBL/1H2PKfpT7dMpOC2Mmx6jI9cKEeG4DfyeqhoNtBYRnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738097991; c=relaxed/simple;
	bh=qFG7cEN7sD+Ie4zeiduqFMeJQn8fvs3l9lYCvoW5syg=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=AGRzMhPQhE5uzKjrWrPEKbxPFdqFjZS3fSDtZ9sMvLyq5vHeOXguqf4CteqlzuKcgkaaz3/ySpfSam/bXs3FLEYZIygGvP7k2kLHhLewK8d4jHT79WPVyBboKT9Appf25EgplAu/vut4vyKIdN5GKykTn8U8dxWNFqr3CYHJi0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=EsOlQIhR; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=EsOlQIhR; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="EsOlQIhR";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="EsOlQIhR"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 598776028D; Tue, 28 Jan 2025 21:59:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738097984;
	bh=lI+4CvgdBvQ9naDbU6lBivZJa3K6J72HR03KY9/xK2g=;
	h=From:To:Subject:Date:From;
	b=EsOlQIhRzwIsyfX6jTpa4urCJ/laQkEIm9HvTwXXguxgyIcVVnChZ9Xu3MVXp5qN0
	 4pCG8iuW7B433JPRIDl7Xq3LkkNByuWH0veX6oaqAn2FaZFoNbQOnCwQ7XcCVqCEkj
	 pnXdUjW8ZVu02CEijOZkxQy/E2IBwiOuplXSVxT6Mmz5bhSpLTjfZsDfrKijefYbuF
	 vYkS6rDv0NXLPfkqUi77tz1ZZqTdRNGanm/afMxpagmmkkGxUsvEPWqB+t3uf0SWE4
	 mL/xu/Wa1NIp6FmnWIk0AydmRJF7lVm7X/km/UNBfGv9zMUaJnclyCjFXmmFZ5HB5V
	 4pT/hBLYNfMBw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id ECA2E60284
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Jan 2025 21:59:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738097984;
	bh=lI+4CvgdBvQ9naDbU6lBivZJa3K6J72HR03KY9/xK2g=;
	h=From:To:Subject:Date:From;
	b=EsOlQIhRzwIsyfX6jTpa4urCJ/laQkEIm9HvTwXXguxgyIcVVnChZ9Xu3MVXp5qN0
	 4pCG8iuW7B433JPRIDl7Xq3LkkNByuWH0veX6oaqAn2FaZFoNbQOnCwQ7XcCVqCEkj
	 pnXdUjW8ZVu02CEijOZkxQy/E2IBwiOuplXSVxT6Mmz5bhSpLTjfZsDfrKijefYbuF
	 vYkS6rDv0NXLPfkqUi77tz1ZZqTdRNGanm/afMxpagmmkkGxUsvEPWqB+t3uf0SWE4
	 mL/xu/Wa1NIp6FmnWIk0AydmRJF7lVm7X/km/UNBfGv9zMUaJnclyCjFXmmFZ5HB5V
	 4pT/hBLYNfMBw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] exthdr: incomplete type 2 routing header definition
Date: Tue, 28 Jan 2025 21:59:39 +0100
Message-Id: <20250128205939.289657-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add missing type 2 routing header definition.

Listing is not correct because these IPv6 extension header are still
lacking context to properly delinearize the listing, but at least this
does not crash.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/exthdr.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/src/exthdr.c b/src/exthdr.c
index 60c7cd1e67f6..1438d7e2d2dc 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -450,13 +450,23 @@ const struct exthdr_desc exthdr_hbh = {
  * Routing header
  */
 
+/* similar to uapi/linux/ipv6.h */
+struct ip6_rt2_hdr {
+	struct ip6_rthdr	rt_hdr;
+	uint32_t		reserved;
+	struct in6_addr		addr;
+};
+
+#define RT2_FIELD(__name, __member, __dtype) \
+	HDR_TEMPLATE(__name, __dtype, struct ip6_rt2_hdr, __member)
+
 const struct exthdr_desc exthdr_rt2 = {
 	.name           = "rt2",
 	.id		= EXTHDR_DESC_RT2,
 	.type           = IPPROTO_ROUTING,
 	.templates	= {
-		[RT2HDR_RESERVED]	= {},
-		[RT2HDR_ADDR]		= {},
+		[RT2HDR_RESERVED]	= RT2_FIELD("reserved", reserved, &integer_type),
+		[RT2HDR_ADDR]		= RT2_FIELD("addr", addr, &ip6addr_type),
 	},
 };
 
-- 
2.30.2

