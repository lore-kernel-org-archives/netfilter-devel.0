Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78B72C030E
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Nov 2025 21:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763416554; cv=none; b=E+ZBBVXHpIdMOZT5GV3RwcuaQj1rYVlcnVuBgS46ebYn5ptbYoSmKmEBQUeu3lx85aKjK/Jh6nPozVl1e8W5KdLHG0i6einWwx114jaV4ZdJCVdLxrUgMq9JPok1YxftB/47MxIsGMpHDXFoc503e+TrhpeqKWCIK5L0m7R9Tog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763416554; c=relaxed/simple;
	bh=hwmt6u5yqLuZom8O6J+9Snr7gkQ64CH84iPHs6OUIj8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kamHPlV3BL/tS9DkwX2tqQon8WGqPSWofAV8MxpWSyh+u5ubq/TiJnQlKKz/oxd+zvCzj3+PSBGq5BzKenNafYCon03ix8EjDjMpZE4TbZSzU35i7/9aRcDxfNxLjhOYNkZZeAf6TL+YPAvHsvd1OROmwhmIx1YYijCY6++QE/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=wKnafAZq; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="wKnafAZq"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D066F60284
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Nov 2025 22:55:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1763416550;
	bh=QtrQcAPJAzb0RMmaVXgcdJeAsKA84aM6xeH1x0CljAs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=wKnafAZqE3GttOWad3yK7lBurJMyaRQwmUhqlCgncuttof8CFGHag2sqD7RqSORNZ
	 07V5iFuCGLM7aNPuqwC7rUks+TFs6TjkV6jVC1xNXIxx0qp5jkjv7i+BfQIAu6sI6c
	 Psf2ZemWK9MDRPGWMwOd5UsrM3aVY7yfC25kC3rqpUQj3dpWeZih3s3LcBigCG5ryn
	 5y6wG041aGQHLKH2+Khs2R7YYZnwZ2Dxi27bUP8QE8NSlaw7xnOPZkhvmdurXG+jUY
	 0mIt0QRv+SPANzZtRFLpw32lNG9l5SwvZQg1qqYUM0WhxcFA3z9bubhZ2fLC2lEwLO
	 k+IR/VRTtmoJg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] tests: shell: refer to python3 in json prettify script
Date: Mon, 17 Nov 2025 21:55:45 +0000
Message-ID: <20251117215545.859808-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251117215545.859808-1-pablo@netfilter.org>
References: <20251117215545.859808-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some distros only refer to python3, update it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/helpers/json-pretty.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/shell/helpers/json-pretty.sh b/tests/shell/helpers/json-pretty.sh
index 5407a8420058..31739b02bc6d 100755
--- a/tests/shell/helpers/json-pretty.sh
+++ b/tests/shell/helpers/json-pretty.sh
@@ -10,7 +10,7 @@ exec_pretty() {
 	fi
 
 	# Fallback to python.
-	exec python -c '
+	exec python3 -c '
 import json
 import sys
 
-- 
2.47.3

