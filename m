Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5D56376E9
	for <netfilter-devel@vger.kernel.org>; Tue, 11 Jun 2024 18:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718129914; cv=none; b=oQrH9Igja9OT1BSEssI7Qc99Aw1KjAc0PwVu45sV7ThsL+efOewT8FqQkqqHa+FAeDIb6WGxVj9Q+eW1j0YItIQTzws06vT56gb+VZSb4ydBPYPbK+qJGjBexTj5ktWRVR9kptmT6HDCwyf1jocKXEiVn3eS1mO4UQ9qjSaURFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718129914; c=relaxed/simple;
	bh=sgMbDNfnNtYC8pIl/HFHjz7dl/jRS8v5xDdOxtuquHU=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=JVkmiqgRz6fx//DrpHnKvL52zvgx6RwOwwunfe+VQ2LdjKdReVehrQErH5fh6DgNS/6DfBHzMRyi53rRiasi4/yOkOwDA7M7VCHAVzo84ntNOgTwy2ZvPBySV4YgP81BndIwUghOarQuXStjosrqxHrW+7aAN19P1ZmheBjLyrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2] monitor: too large shift exponent displaying payload expression
Date: Tue, 11 Jun 2024 20:18:25 +0200
Message-Id: <20240611181825.328419-1-pablo@netfilter.org>
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

skip if proto_unknown_template is set on in this payload expression.

Fixes: be5d9120e81e ("nft monitor [ trace ]")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: check for proto_unknown_template, otherwise problem persists.

 src/netlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/netlink.c b/src/netlink.c
index 0088b742d573..efb0b69939dc 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -2096,6 +2096,7 @@ restart:
 		/* Skip unknown and filtered expressions */
 		desc = lhs->payload.desc;
 		if (lhs->dtype == &invalid_type ||
+		    lhs->payload.tmpl == &proto_unknown_template ||
 		    desc->checksum_key == payload_hdr_field(lhs) ||
 		    desc->format.filter & (1 << payload_hdr_field(lhs))) {
 			expr_free(lhs);
-- 
2.30.2

