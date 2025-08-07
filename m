Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631BF23815D;
	Thu,  7 Aug 2025 11:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754566213; cv=none; b=PAvHv/GM15MQNIyoPqN3bHBH+kYYVzPbEzlh6BU7s1O4JHqf0BWP3JbiTpNQucLtuunsZUReKtm60smuRfGlEUs7Yj2SE29Qtb+QqIsrM7KcY6zfdZP6hSUH8yPc4sZBzNdcZCqRRR/7QRhaTtgrS/pwXxgrGV9jJLRG6I1Eev8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754566213; c=relaxed/simple;
	bh=8JNuS3s5jd69NTTu4pz0zehGPJtFt9vh7lXeyA5l73s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o/oFN5YKB2iARKsvsD6ybrxKEn2D8FCZdn4SS/fLLKdB2IEge6qdQ21EpBWvcqt5FQ1FEQ6tyirI8IMJ2Nmn3fAoVVCpB05Yw+YeFMdRuDIoOk6J7vjtaDFwo8f8tFpC42nEz+ySPH2vGTUPCzADi8PYf5OSDTFgvBPcKuw4/Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lZXNB7s3; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=sbfzS44e; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lZXNB7s3";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="sbfzS44e"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C326F602AF; Thu,  7 Aug 2025 13:29:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754566196;
	bh=gYhKnsz9HbJb3X1VcQvcORTM0jWKKObsXn18zpl2+DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZXNB7s3AqXK9M94iFXOFrp9uKUrELqAN0tFo2UYkDVgR46jcS6Xd2Q2gDA3Z6out
	 7XI3mUE4+5Fblsg/KOyMQN4Z3sr6e7fo5+vaUV2uNzvAaC/g2t01GCQiG4YPx/E09Y
	 rUqABpiyvCgekGVZlUmKk4Q5wHPVElPe5En3oMaZaprbt52+QwaXTXaZkbJTOIBG6C
	 3aDZBCjRPLyzyG3T+5uiuTql4iG65Qp4ZNHTTleLemtG1eBJEp7Xu0rkPN9ewQ0p1V
	 jXxVJrG7nGBbecnoZkUBzGKdGkN2m9zXim5OB5E+g+pXnYsB6kGS145mG3JU5UEpO3
	 FNI7YzHJBpSOw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 39C9460A49;
	Thu,  7 Aug 2025 13:29:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754566194;
	bh=gYhKnsz9HbJb3X1VcQvcORTM0jWKKObsXn18zpl2+DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sbfzS44egTLeRbxf7ZMVwq0KAh/Vc+ZfRnp91owZ+JPXvPzgqpQVkw3lU/CbUka9q
	 gBtnQQXdlaBhFzuO1xmmvmV4jvLTE195ub7XH7pc3nleAjf/yd945HP6EdDyfSnX9e
	 qplFb7BygOwgmQSFgPzD03xNkXru5pI81110mmC/UwI7IQDeMdVD/1EAe7CyYwi7MX
	 /LfZ+h9BCCAr6joRvaO2qoLVi1h7BcXEkgyWNUknKMTkWu2pa6EKXEljVpvT+HQjWi
	 AKCYU1YzlLEAE9TlTiLMq8qWvMstgktsFxr6piJAK+r0huYBXwvsZqgqzImcRv57c9
	 OHyzk/JH9anIA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 1/7] MAINTAINERS: resurrect my netfilter maintainer entry
Date: Thu,  7 Aug 2025 13:29:42 +0200
Message-Id: <20250807112948.1400523-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250807112948.1400523-1-pablo@netfilter.org>
References: <20250807112948.1400523-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

This reverts commit b5048d27872a9734d142540ea23c3e897e47e05c.
Its been more than a year, hope my motivation lasts a bit longer than
last time :-)

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b968bc6959d1..cd9415702b28 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17313,6 +17313,7 @@ F:	drivers/net/ethernet/neterion/
 NETFILTER
 M:	Pablo Neira Ayuso <pablo@netfilter.org>
 M:	Jozsef Kadlecsik <kadlec@netfilter.org>
+M:	Florian Westphal <fw@strlen.de>
 L:	netfilter-devel@vger.kernel.org
 L:	coreteam@netfilter.org
 S:	Maintained
-- 
2.30.2

