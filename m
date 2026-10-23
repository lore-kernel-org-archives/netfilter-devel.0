Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792763907;
	b=Gr41xhet9V4cE2TerwASGYWLjC93zRzQEi3nRasUziM9adahUx+3UR2L6uVYv8EX94jp
	 ec0QcRZRg+BPBnPeLuZ2+puKI7OGQrVCECbLhZO4SsKi0hDbrTANQxxi8t2U3f/vdUcWk
	 BrahM3OCrV+yPZw8H3kkY7nQS8pCygiv4d8PvnECDZQzdbQgC/LNlO77QWxrlA8XucWoz
	 NRmkl9qjmLPMd2lcjEgBuv5BJyCDDZhQcTYhvnJTS32uRvZ1fLeRh6Jr8UE7lKhRSDH7y
	 fT+KVYEKxaz7xxkvr97UqfAEyfZs4BOwrhcVuOTsgOAIgylSG96kWXzcxKfcHTzNBBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792763907;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=608K0YczLuc+VSBzg1XgNj1cdRagqX2vy3XXy2Rf2yI=;
	b=OYy5R+LHHSUf3QARHoNR2lHxALJfX3iVTXETVpXs+TsJs0WUMq82HACj32S5ko+CEczx
	 0q85S1CRS2Ijf28T2buMBODnjEXtMi1edr6r0svsPpECakRqXXRwbyN7ns7JODpv9BRbo
	 jefYFCbGF4ihwyMkkSEP3bswQq9586ptm4jA6+5zM1jVZmKjqrBTW8lh8SbRrTnEItBOx
	 +vYwqt+cVPtJp500syFzfQadEAPPUjUZ+TiTfGTgwnPA0yzC/mbkY2JWQ6PW7Tt+4n3ot
	 lzpf1+fn3RosW9moiQ6RH7tq3BV8u/OjlZEqGOv+DszlvOqJzXQf0sdPCR5ihSG7u6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36246606A31E
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Oct 2026 13:58:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36246606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 885F160796; Fri, 23 Oct 2026 15:58:25 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnftnl 2/7] src: chain: fix NFTNL_CHAIN_TYPE data_len
Date: Fri, 23 Oct 2026 15:58:01 +0200
Message-ID: <20261023135806.7259-3-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261023135806.7259-1-fw@strlen.de>
References: <20261023135806.7259-1-fw@strlen.de>
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

Should return length of string like other attributes.  LLM finding.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/chain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/chain.c b/src/chain.c
index 8433f7db4126..5ee8e128556c 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -345,7 +345,7 @@ const void *nftnl_chain_get_data(const struct nftnl_chain *c, uint16_t attr,
 		*data_len = sizeof(uint32_t);
 		return &c->family;
 	case NFTNL_CHAIN_TYPE:
-		*data_len = sizeof(uint32_t);
+		*data_len = strlen(c->type) + 1;
 		return c->type;
 	case NFTNL_CHAIN_DEV:
 		*data_len = strlen(c->dev) + 1;
-- 
2.55.0

