Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 196E2145354
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Jun 2024 17:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718040022; cv=none; b=BWcBZDE15927mF+LZ6TcEYhh7XzXAVLENvQYfwx0d6Fuj9oMboieX7b3TH8g/7g4ldqjSSjbH3X9bMjpy30k2y1e6nTs2ysRoOZx2voWT9dZpBw6EH9wzpbM7xaQfZk52bEhVxKTuK5r+6p0Tx2Qrdx0+GGYTREipGbdq/AB9+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718040022; c=relaxed/simple;
	bh=/y9QYq9CKI8QjoxQmTJtQCXTCIV2W5Sv2aO7cMqKHdA=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=RP0+dfIE9mriDUCGvU3do79dK5cjT4HTutEYi9xXbfEoXk4KUtSpTFhik64qM4aMCejgVnLUaquV6xqXRsnUmzscdKCDxt9qN0d0+xFoskinSkI+xt528TVcToWYd45/tucXdh2XSuyoPa/NcUipRrt5hLVOElBXEIUkeEUR2KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] monitor: too large shift exponent displaying payload expression
Date: Mon, 10 Jun 2024 19:20:03 +0200
Message-Id: <20240610172003.7129-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ASAN reports too large shift exponent when displaying traces for raw
payload expression:

  trace id ec23e848 ip x y packet: oif "wlan0" src/netlink.c:2100:32: runtime error: shift exponent 1431657095 is too large for 32-bit type 'int'

Check if payload field template and description are set on before
calling payload_hdr_field().

Fixes: be5d9120e81e ("nft monitor [ trace ]")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/netlink.c b/src/netlink.c
index 0088b742d573..e9adc040a8f3 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -2096,6 +2096,7 @@ restart:
 		/* Skip unknown and filtered expressions */
 		desc = lhs->payload.desc;
 		if (lhs->dtype == &invalid_type ||
+		    !lhs->payload.tmpl || !lhs->payload.desc ||
 		    desc->checksum_key == payload_hdr_field(lhs) ||
 		    desc->format.filter & (1 << payload_hdr_field(lhs))) {
 			expr_free(lhs);
-- 
2.30.2

