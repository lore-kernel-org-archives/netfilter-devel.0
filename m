Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.25.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793992753;
	b=mz9Gj5sAOqh8OfgRYRJYeE5voaK9aRj5tQVLXj35VGlKzcWxTDrVy5TR6oAAmuiUwGg6
	 HfGNy4V2Yv22XXf3rpjOJeHq3H8mUxN8jg93w5hOufwxVWopWb8ctYXMQb8/4M22nLeU5
	 s3QV5PwEf20d5OB9vBfXDwIhzm+ggRuZTcFaceqicLWUUE0mPaAnZBTVLPeAj4aKZncdi
	 MuvhUS/aRrVAksJAzjak/ktVLnwoWEn5C85yPR+wFYrayaZvRBpBfQp3Zj9O/gVPEVev8
	 DxBSig4Cm/ZaU+MPQU7H5Cf9FfWfZeFJkp2Jy2hJlMGgeQoSV8ymTJX+giqFjsR5vTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793992753;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Infomaniak-Routing;
	bh=ZdJwSSu4XDWRRPSSM76ag6LxfawMdJOFxE7hkxdXU+o=;
	b=h+wXyBBRVFnvgzZq9SElFKj86UYgq1Ajcv7W10z3FrLmojwfJIcwn8/pLr9KLnWyTHDO
	 O053ClVBRGatHM5qvF+k0vGcyiDHHhIyWcg7rdNfuVQDa6601My6N+vN1FOhBqubaPqma
	 w2gtpZFhv8bkTEnQkYyPMjWfPlAGUKC5s7YXE6yaugBSYZLhz8aDuqnbaO4M6CTlmtGAi
	 fG9MBywzx0odk+ZmJJ0jJqciljJPL2nmTo4LzK4D4F/HzoYPmLQr0V163PsWWBNN3y/ef
	 ElaiWq6IwgMQJNa5W4KnfKedho6mH1k/vOWJdTLqUWxwa0P+qYhEsCu57EHGtFYNMjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=harvester.fr;
	spf=pass smtp.mailfrom=harvester.fr;
	dkim=pass header.d=harvester.fr header.i=@harvester.fr header.a=rsa-sha256 header.s=20260519 header.b="dXCY/0ck";
	arc=none smtp.remote-ip=185.125.25.15
Received: from smtp-190f.mail.infomaniak.ch (smtp-190f.mail.infomaniak.ch [185.125.25.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BA3606A32E
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Nov 2026 19:19:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55BA3606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=harvester.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harvester.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=harvester.fr header.i=@harvester.fr header.a=rsa-sha256 header.s=20260519 header.b=dXCY/0ck
Received: from smtp-4-0000.mail.infomaniak.ch (smtp-4-0000.mail.infomaniak.ch [10.7.10.107])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4jLprS6pt6zVKB;
	Fri,  6 Nov 2026 20:19:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harvester.fr;
	s=20260519; t=1793992744;
	bh=ZdJwSSu4XDWRRPSSM76ag6LxfawMdJOFxE7hkxdXU+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dXCY/0ckCW0HYUatI1Gh/6BlWZ2rKrME9Kg5cjQYf4WsglloCh6MwopQnvVQ1FDQ/
	 YJylY3zBIqI6azRshQilF5UW+lt8sbx7RMUeisgG5ur6RSN4WS5C5FZmu60Kj7bd2m
	 b0g4Yf+tYmdj6DOdpulhytp5pAFjCl0KY16KDW8zaZthnkgiwKSv8eZ5d1uBaaTCg+
	 eRVRL6MrLrHxPWz4SwZrWOxVUPHUzuOTT+CrF8K+NcMwKWrfHvre4043sAcDPZP4Ou
	 8zneuGGpVtbV5lIrM/MOlbVDpTybwWCxKj/IIBqqPgGg1LCNT1pvHF9Hslhst2O5nT
	 s4u89Ny6ovT2A==
Received: from unknown by smtp-4-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4jLprS1FCmzS2k;
	Fri,  6 Nov 2026 20:19:04 +0100 (CET)
From: Florian Stosse <florian.stosse@harvester.fr>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Stosse <florian.stosse@harvester.fr>
Subject: [PATCH libmnl 3/5] attr: do not wrap mnl_attr_get_payload_len() for nla_len < 4
Date: Fri,  6 Nov 2026 20:18:38 +0100
Message-ID: <20261106191841.1645-4-florian.stosse@harvester.fr>
X-Mailer: git-send-email 2.56.0.windows.4
In-Reply-To: <20261106191841.1645-1-florian.stosse@harvester.fr>
References: <20261106191841.1645-1-florian.stosse@harvester.fr>
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
X-Infomaniak-Routing: alpha

For an attribute whose nla_len is smaller than the attribute header,
nla_len - MNL_ATTR_HDRLEN wraps and is truncated to 65532..65535.
mnl_attr_for_each_nested() (and so mnl_attr_parse_nested()) uses it as
the nest length, so mnl_attr_ok() is told there is room for attributes
and reads a header past the end of the nest.

Return 0 in that case, so the nest iterates no attributes.

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
Signed-off-by: Florian Stosse <florian.stosse@harvester.fr>
---
 src/attr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/attr.c b/src/attr.c
index 0254190..69d23af 100644
--- a/src/attr.c
+++ b/src/attr.c
@@ -63,6 +63,9 @@ EXPORT_SYMBOL uint16_t mnl_attr_get_len(const struct nlattr *attr)
  */
 EXPORT_SYMBOL uint16_t mnl_attr_get_payload_len(const struct nlattr *attr)
 {
+	if (attr->nla_len < MNL_ATTR_HDRLEN)
+		return 0;
+
 	return attr->nla_len - MNL_ATTR_HDRLEN;
 }
 
-- 
2.56.0.windows.4

