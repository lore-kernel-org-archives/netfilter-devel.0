Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795304630;
	b=WQrk4a/n0pwc5rYEbpgzYuQgPO6TMEKcLl0JQ+KHvEDEaffthaoLC8OojWCDyMCBiU/Q
	 2sCEFXqL7zSqHqUKLtQ6sZbIBoCW7Wx4Kn1bmqu8C0MHaJa/G8GudeNOWOoO+yXGkGlsm
	 zuDFwX0ZvlQIko7yJ8hE+rijw+8KQosbdz0Lq2hAm+0TcVWHg+0sy1Uqe5ZlNO7ZFW+Ud
	 A1o8eZDewynwJ4RZIgaJH1DqPWFNiMhNvUxMRGAz5cRG6S+/WJ/zdvhNhiLMEo/EnTJ4T
	 GmV581DqonfwLy4vPYjJjrLmKMvSpX0QqraWx2Neq/CSMxytTZEC5IZ1FayKnt05mrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795304630;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=e8vyIewEx5+8sXFMtuUbU6bNXqBNIitBmtC6PZLMOh4=;
	b=f8uVG6Q0+1QS1BqKteYPweIvwQzJlOvlvZMdw//Jkh7A/7Lc+ebXaHQeZLrfbTqTRROE
	 VSrAOPonfUSjhKeo8OJCVHmlxStdU8i74D8yDxAEqN5Z3ej3mBSGizA+Ne+3Ja5jDwA+z
	 LxcSy2gvpi2jQWXqfEVP2+Ge0TbqZzORtRldkDn7T2t2FSaLOhILlS6qlrTRvOalDTC/E
	 vMaaPp95xEq6+WEdFacL22nu+kbKGKE05ayH8BKHx/wZDXaqH4dSEC1eR01DhrMe/J2qG
	 6ZdH2EPSY1Xj+teIaxHAsqdLFcALlaYpqu/kZ9LRuMN3jwAl2jwfCp/YviB8wvc0RvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=P1ucIHc1;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BA5606A334
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Nov 2026 23:43:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B2BA5606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=P1ucIHc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795304627;
	bh=e8vyIewEx5+8sXFMtuUbU6bNXqBNIitBmtC6PZLMOh4=;
	h=From:To:Subject:Date:From;
	b=P1ucIHc14BJfCL+7vitLReYgXd/hmMSbS25skMqE20jrSN/4R7YWYf7gm4FxrANiN
	 Ii25piRJZ5aFoJELwCnaHHaSkUxAsKxctjyUFTnFxNR11H2nBfETnLIYceAvD7rkue
	 HM6UDIcYr/cG8+fuWOGFs2P+y31D1+mGe/sZHt4QJYxK8lI1ZCLhC2OJZCRu6e8I2q
	 IiV6hS31ptJY7HfxNwK6if/Pr/ASexRGZ65/Ctqgt3roSO8gtz9hQo8wFt16yeOqdh
	 LFOyCCOpkWEM0Y1xEGqg+2QtEfxvkoskToy/nuvvz9i+CEkOB/1haJ7beM6VER+f80
	 nenkRnc/+wb2A==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3FFF56005B
	for <netfilter-devel@vger.kernel.org>; Sun, 22 Nov 2026 00:43:47 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH libmnl] include: add unlikely() notation and use it
Date: Sun, 22 Nov 2026 00:43:44 +0100
Message-ID: <20261121234344.3749945-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add this notation to highlight codepath that is unlikely to happen.

Use it a recent LLM fix that hardens mnl_attr_get_payload_len() against.
malformed netlink messages, which should not happen in netlink messages
coming from the kernel.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/attr.c     | 2 +-
 src/internal.h | 8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/src/attr.c b/src/attr.c
index 69d23af50855..1456b0c03ad9 100644
--- a/src/attr.c
+++ b/src/attr.c
@@ -63,7 +63,7 @@ EXPORT_SYMBOL uint16_t mnl_attr_get_len(const struct nlattr *attr)
  */
 EXPORT_SYMBOL uint16_t mnl_attr_get_payload_len(const struct nlattr *attr)
 {
-	if (attr->nla_len < MNL_ATTR_HDRLEN)
+	if (unlikely(attr->nla_len < MNL_ATTR_HDRLEN))
 		return 0;
 
 	return attr->nla_len - MNL_ATTR_HDRLEN;
diff --git a/src/internal.h b/src/internal.h
index d69eaf3ef203..340f17008e55 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -8,4 +8,12 @@
 #	define EXPORT_SYMBOL
 #endif
 
+#ifdef __GNUC__
+# define likely(x)	__builtin_expect(!!(x), 1)
+# define unlikely(x)	__builtin_expect(!!(x), 0)
+#else
+# define likely(x)	(x)
+# define unlikely(x)	(x)
+#endif
+
 #endif
-- 
2.47.3

