Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B4F51E421;
	Mon,  7 Sep 2026 17:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788801464; cv=none; b=TOisPFLYXPKt+JPJn3fmgQLtQRMfO0X0od1oVfYTeXnHt0XDsDi7CyS0t2Yy+IURt16/k+FkBcebyYCRrwG8Sz2OL7S1EhpcKUBlDgRuqExxqv6QzeVbxyJO0EcGgLu2kRnZ4KJvD9pbeHlVKvFaAfBziAYix6vsbeQesmqGTzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788801464; c=relaxed/simple;
	bh=iXzGaYTy/Oqp+cbiwiF4jWxNES3dOeYJpf0jg4feALo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mpsIflyM86aiUQXUmRuEmRnAn+SDgdqSP4ZF5s71vkVBxT1EcVda8i/pM0QjnyPhnOrogmhuOws15Eg4OgAOvIPdFiNd18rjhHHjC58xwFtZKKdyV3nYWQ4A3LknyBE40R4WCUklrCWsNAlpCWlLMw25QY9M5JPhPLPodyml/DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=YrLSzIHy; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="YrLSzIHy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788801461;
	bh=SVk5xIYlvI1HY9/YlutJ14OPeJkUOoImMOBeva92XNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YrLSzIHyZP4W/O4v2QwsOYi2SUZQ5NtYpnwFUvDx74rRXH8kDB7UWrNG8y6vncGQR
	 reHBea+nlQv7OtoblCt6fE+5tIFdGe1iWRXNyxlTIY9PuhHOB+UIfNBAeL6Ou/jvvG
	 jv3n+YG9xx+YAk8/E/IKUR8Y3nrYjKv70iBox93wrUgNJ/gg+vBkKJzknqzVUQ/+g3
	 TAx3MsYHZQRg9w05IaNtDJwTpFTS/UWEQ1MDMhLGJXBzz0zGOhn2pmOURbaKRQ/NQl
	 QuCL0ug1cbV934ORVLwLzmKKrbRkWd0GFzG7yovq+b0gQ102/qIITvew9fLJ09mWJ+
	 bKR/E4I0ZvHsA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8C00F607D2;
	Mon,  7 Sep 2026 19:17:40 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 3/9] netfilter: nf_conntrack_sip: fix OOB read in sip_skip_whitespace()
Date: Mon,  7 Sep 2026 19:17:26 +0200
Message-ID: <20260907171732.1407739-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260907171732.1407739-1-pablo@netfilter.org>
References: <20260907171732.1407739-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Joas Antonio dos Santos <joasantonio108@gmail.com>

sip_skip_whitespace() returns dptr unchanged when its own loop
exhausts the buffer (dptr == limit), instead of NULL like its sibling
sip_follow_continuation() returns on its own "no more data" path.

ct_sip_get_header() only checks for NULL after calling it:

  dptr = sip_skip_whitespace(dptr, limit);
  if (dptr == NULL)
          break;
  if (*dptr != ':' || ++dptr >= limit)
          break;

so a recognized header name followed only by spaces/tabs running to
the exact end of the SIP payload, with no colon, makes the very next
statement read one byte past the buffer.

Make both "no more data" outcomes return NULL, matching the
convention sip_follow_continuation() already uses and that both
existing callers already check for.

Fixes: ea45f12a2766d ("[NETFILTER]: nf_conntrack_sip: parse SIP headers properly")
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_sip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 3ccf34fc1c53..64bc440b1181 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -423,7 +423,7 @@ static const char *sip_skip_whitespace(const char *dptr, const char *limit)
 		dptr = sip_follow_continuation(dptr, limit);
 		break;
 	}
-	return dptr;
+	return dptr < limit ? dptr : NULL;
 }
 
 /* Search within a SIP header value, dealing with continuation lines */
-- 
2.47.3

