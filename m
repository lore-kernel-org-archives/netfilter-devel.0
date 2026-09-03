Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92EA485CF2
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2026 11:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788435284; cv=none; b=TZ7xzLGLhYEMVPrFr26ddCQ7/ZDn5aLLJon7nv51OETjs9WYFapNDWdeDGbpfVhc8Ko5SzXXGcC7THDH135II0AGyOmuAJASn4AU420uMxZPWrfqi1QSmR+UD21e470UTcK0J9k1X+uYIbtIcSGUKwTc65ABaN4Oylebr2P0kDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788435284; c=relaxed/simple;
	bh=dHJMKANqyNvFfdVyCMZDCwLesV3olM7y9LC5E227Vxc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cprO4piTX33gB2t68sscktUlGRqAaMW8hS7lqhPgZfOcEXZHvz+d3jlvH3MV8wriZO2XKVZrJppH30CPZb5akGz4oEgouEG1lcbqzXMP1vZIWnUSI36cB2NTCnrevnPAuJNrBkSPXooyznnjfyEnGmlVjWMOoxfoi1ES22vuG4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=e+AZdrKz; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="e+AZdrKz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788435263;
	bh=HBTur3/HmHhlBXk3XoOK9opluAHeQKnEXIeIdOiL9Nc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=e+AZdrKzGHGsmuzuQp20fctY1OJSjDYTj2CXIBSNNCW24N+qsuFW29sbReLoCBhLd
	 Db0Q0T8AYU+aZzXaPNMdU8yGArpFS0BSe0N091nvgzLfqERl8AYW81GBUjUurwddm+
	 gvCatca/GlpNNXq1o/ZNyMbyqLSuQul3B2R429BMaTkvqVZhD45n3qFmDOqrRyxxfS
	 OGQEzFkIHh1/WHxLrV9fr/wNfx3GqvNh9hSOG46/KJReNmFnjNQinv67Zf9RcCFR+N
	 s9YJS//sICHqmrMModH9z5R4SX4alGiUTKQXKG9H7vgMqLfbwwpIslcKvi3Qshv6aK
	 6ktiO5s+L3oUA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5B594607EF
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2026 13:34:23 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2 7/8] netfilter: conncount: use GFP_KERNEL_ACCOUNT
Date: Thu,  3 Sep 2026 13:34:12 +0200
Message-ID: <20260903113413.1122606-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260903113413.1122606-1-pablo@netfilter.org>
References: <20260903113413.1122606-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

GFP_KERNEL_ACCOUNT is preferred these days for memcg, replace
GFP_KERNEL by GFP_KERNEL_ACCOUNT.

Allocate the internal nf_conncount datastructure via
GFP_KERNEL_ACCOUNT.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes

 net/netfilter/nf_conncount.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 4292c3d9addd..eca7a8d330ce 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -692,7 +692,7 @@ struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int keylen
 	    keylen == 0)
 		return ERR_PTR(-EINVAL);
 
-	data = kvzalloc_obj(*data);
+	data = kvzalloc_obj(*data, GFP_KERNEL_ACCOUNT);
 	if (!data)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.47.3

