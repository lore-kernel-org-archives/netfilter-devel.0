Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DAE2D8364;
	Thu,  3 Sep 2026 00:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788396123; cv=none; b=sL5pEaq2VzDX6BPvn9hPEl2J03u9OpqagKmAqIlAdhF2IpHWQFjBUpl1bM50joLfk5F3eMp5ByclHudK0e+4Mana0bAptNyKNXFmL6AdTUBnhE8qNLx38uZcnv9BtpcquMNXvre8UHb+dYmvjPuk0jxlbuc5bFpvEyMiC/r9uHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788396123; c=relaxed/simple;
	bh=iXzGaYTy/Oqp+cbiwiF4jWxNES3dOeYJpf0jg4feALo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hap3Iy430Pofcu9ZsRr/Z7WGHLh0gxI8abrtHt4j/wJsYeymz/YGvlZmdmy6TKBsTdts6pphylpT65FedZVACNUcuZh8KhZXoAQoRM3PyGOOW3u4iLasZr1ajJRHFtj6LlbNIRCe3dArgaQpKeHXbVkNNSRuHkOxgNgNhcqixk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=D4HU7EMd; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="D4HU7EMd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788396119;
	bh=SVk5xIYlvI1HY9/YlutJ14OPeJkUOoImMOBeva92XNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D4HU7EMdcYEPLxMxRGkH5QTbQ+jHMtxYXY4IjO3x7+mebyIoMwDQZDzZcgRF+i5xq
	 5W1wX3Sqsssis4G0PRAqKNSgfiVwcuIBAHeWgnHiIzOw+w8VkQQp8MctmWZiTF+kAX
	 f0I1anxkgcJ1Yq6AhxSjPYWhWQ+GuN1Ipq8oJwRW8pJ4RDmml4FNp2Fjgc6I9S2EIU
	 ZtFX84sRMHRIYsMmXMMbWxBep2/AXPHqZvrBVNZwWDhjaW4bjnRXlVdjdiRxwUF7KL
	 UHtvVTcifyTgRXcNZ9kZIKWjZyvpLZFqhYLuOiY7tcOnEf+pQIWTOBGjmD1DD+wpwV
	 8+tv8d4Yx8t3w==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 84433607AE;
	Thu,  3 Sep 2026 02:41:58 +0200 (CEST)
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
Subject: [PATCH net 03/12] netfilter: nf_conntrack_sip: fix OOB read in sip_skip_whitespace()
Date: Thu,  3 Sep 2026 02:41:40 +0200
Message-ID: <20260903004149.1037028-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260903004149.1037028-1-pablo@netfilter.org>
References: <20260903004149.1037028-1-pablo@netfilter.org>
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

