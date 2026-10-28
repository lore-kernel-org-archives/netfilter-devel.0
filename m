Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793199417;
	b=Npk9Uqxr0YyUdlvNjcWNtQv+X8e5GI1oZerDlcn/RLjvNv2V26D3N1zM6itByc0G4pFM
	 1O/WNuttu5IhmmITfOVgfkZru+L+zaSGmpaxL82x1UOawStZF3dzFr55d7WSC+FN1Tziy
	 wDFnmmBtR95sU8oOw6CKqoYs2z8jPFxtVEnQzEqWdRdE/AsDD4G1Rpzm5+na5tnKnsUJb
	 8Vy0QIWaKBXQMe7QYifrrOV337fhGC23cW7hXcfI7FUTMx1a/snok6oRBQ4tGvkOWRH+o
	 OjYhB18F5maFRDMLc/EjLTDYELj52KeMbYqNqU/pVvH/2oDa5ilX7y461Dg7ApX0gjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793199417;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=7bpr3JR84e3OtUEtVIvVhLSZ/S7Yw7NB5FwzEvIgSe4=;
	b=RbXQZ6MgUkaNodsyBG9hWXOEf/OMrmHRSOsO0R9X9rPGdpmADyTaIGn3jNThSae6wEQq
	 3t6wJq/pAOT7MV2YB8bDuGd2d+JDCMroIcgYiWgmYsAzdQFB5zP66zwnnpqDsOSJ7GEo1
	 OAsIRgwafvE/8tilGGfzrA2s7xxoT1i6m1A2liA3kmN8PgNNNhKSUrqTQxFHU6wUPvFDJ
	 5BqTYf0TNTdJr0viQKGIWZMzFcd9miws3H/1ZmeMZNEn0mqhBhHCECPittf2D/tDFZYw/
	 Z44p3PKv+fMezlZXORx3NCfvIIo27V1Qp4u5FtGIKBh2RskaZzKdLYMmHjwKm6MxffQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5264D606A31C
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Oct 2026 14:56:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5264D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id F11DC60A79; Wed, 28 Oct 2026 15:56:49 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libftnl 01/12] src: common: mnl_nlmsg_batch_start may return NULL
Date: Wed, 28 Oct 2026 15:56:21 +0100
Message-ID: <20261028145632.7089-2-fw@strlen.de>
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

LLM spots that we did not check for a NULL return value from
mnl_nlmsg_batch_start().

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/common.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/common.c b/src/common.c
index c92448393b20..0f2745c686dc 100644
--- a/src/common.c
+++ b/src/common.c
@@ -120,6 +120,10 @@ int nftnl_batch_is_supported(void)
 	}
 
 	b = mnl_nlmsg_batch_start(buf, sizeof(buf));
+	if (!b) {
+		mnl_socket_close(nl);
+		return -1;
+	}
 
 	nftnl_batch_begin(mnl_nlmsg_batch_current(b), seq++);
 	mnl_nlmsg_batch_next(b);
-- 
2.55.0

