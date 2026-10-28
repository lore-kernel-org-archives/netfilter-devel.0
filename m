Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793199420;
	b=NzZDta7cJia+Jd2C7Ja0hyZ22zTAt5ooS5uv94PvNcP1N8i/yyz2SaxWAHWIa0nkX/4w
	 pPEUO7jjXLuYzxWhmrTsY4n9yknu0ImaaQLwhdJDnTZFJ2gEdSKBYRqnpR1L6TTXl5VkE
	 89RjL74QgE4l+dJqaorwLQaUgTRJJogcKcwrh6znaaxD/X1TkVrPVhF/YYD5+jdMA48iZ
	 xrsQMxdxh6hDMhATukCgjm6+fvdi82iCuDEiopFFIC14g4FUqEHiNpLNeryLjtirJ85Ie
	 6KU46wq47p3eaRQmRhDLtIHeb7kZx8udu5SYtxkNS1XmJaMrgOj3GPaIeS0nSVM77Rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793199420;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=WCoXg8b0DNI2ic+4O1080jJL7h4+IoJWgbmi2OSU9y0=;
	b=QdxiewI5NxmREAK2RZXdfsiiIlD6sqlM9q4tT7DIX81o7L5x6h5DDl5WQg9M20jCWtLI
	 ilG8W+KkKpsYuIXU9hMdYxjjSdNgQHC5KabdERdOFUeMq2l+vVSmPiP/RQ8/CFo0yeYig
	 UqfT2Me7p9OfpX9Tr6v+/Q8+lONMzbYt00ifrB4QUwA6gNJ06iAGOFbzUzkYbGGDGINWG
	 WfNpID5CdfZaYMJROkWA7ciSpJIuLbSVIlAfEKfgW524f8U9mRXWNxqeI+oN3aWN+v9pq
	 smFIEqtpe2P21ncVRU4dpfPSl/CuAEa2xyq09qu5YLJ+0CZr1MKYgA7aV97B/PIoaOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A81E606A31D
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Oct 2026 14:57:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1A81E606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7B000609D0; Wed, 28 Oct 2026 15:56:58 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libftnl 03/12] src: move several MNL_STRING types to MNL_NUL_STRING
Date: Wed, 28 Oct 2026 15:56:23 +0100
Message-ID: <20261028145632.7089-4-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261028145632.7089-1-fw@strlen.de>
References: <20261028145632.7089-1-fw@strlen.de>
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

LLM finding:
mnl_attr_get_str() returns a pointer into a fixed-length TLV payload with
no guaranteed NUL terminator.

This is the classic 'NLA_STRING' vs. 'NUL_STRING'.
libmnl only checks for terminating NUL when asked to validate a
NUL_STRING attribute.  As we parse nf_tables data coming from kernel,
we can actually rely on the kernel including the terminating NUL
character for us, even for NLA_STRING.

Just switch those affected attributes (strdup() after
mnl_attr_validate(... MNL_STRING) to MNL_NUL_STRING.

This doesn't break any existing users, closes the finding and
hardens future users that might parse netlink attributes coming
from a different source than the kernel.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/chain.c         | 2 +-
 src/expr/data_reg.c | 2 +-
 src/set.c           | 2 +-
 src/utils.c         | 5 +++--
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index 13b0231ee345..c72505c22e17 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -613,7 +613,7 @@ static int nftnl_chain_parse_hook_cb(const struct nlattr *attr, void *data)
 			abi_breakage();
 		break;
 	case NFTA_HOOK_DEV:
-		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+		if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0)
 			abi_breakage();
 		break;
 	}
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 0a1c0bdee6c2..e38e493f0592 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -155,7 +155,7 @@ static int nftnl_verdict_parse_cb(const struct nlattr *attr, void *data)
 			abi_breakage();
 		break;
 	case NFTA_VERDICT_CHAIN:
-		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+		if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0)
 			abi_breakage();
 		break;
 	}
diff --git a/src/set.c b/src/set.c
index f7b0526253ff..22fd4a839f80 100644
--- a/src/set.c
+++ b/src/set.c
@@ -491,7 +491,7 @@ static int nftnl_set_parse_attr_cb(const struct nlattr *attr, void *data)
 	case NFTA_SET_TABLE:
 	case NFTA_SET_NAME:
 	case NFTA_SET_TYPE:
-		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+		if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0)
 			abi_breakage();
 		break;
 	case NFTA_SET_HANDLE:
diff --git a/src/utils.c b/src/utils.c
index f7d035baa3ae..95a252ed44f3 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -200,14 +200,15 @@ void nftnl_attr_put_ifname(struct nlmsghdr *nlh, const char *ifname)
 
 char *nftnl_attr_get_ifname(const struct nlattr *attr)
 {
+	uint16_t dlen = mnl_attr_get_payload_len(attr);
 	const char *dev = mnl_attr_get_str(attr);
 	char buf[IFNAMSIZ];
 
 	switch (mnl_attr_get_type(attr)) {
 	case NFTA_DEVICE_NAME:
-		return strdup(dev);
+		return strndup(dev, dlen);
 	case NFTA_DEVICE_PREFIX:
-		snprintf(buf, IFNAMSIZ, "%s*", dev);
+		snprintf(buf, IFNAMSIZ, "%.*s*", (int)dlen, dev);
 		return strdup(buf);
 	default:
 		return NULL;
-- 
2.55.0

