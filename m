Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5685F390C95
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jul 2026 09:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783415482; cv=none; b=n/p6Tqio4M1apQ7nILvggoDP6NKPiFvpcTp55Xxed/v/APmfosJBUHZ+RmiH8T0fLZ2qqLo2qJv+2YEiGKct1HJjn6BOltJZZRAbNJFlPUeBaoNezF7knqEbfvHbDIvV8FGPECbJezoR1E9fc4JOE5lpJ1tq39z/5FLSQChrNvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783415482; c=relaxed/simple;
	bh=LwGdfVE6zCNMfNmWNHYheA/PzogaUt5+b/oAPBRLVHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uzACKRRN5AGQJJW8h+uR1q+VuEvaVC/dtQV+YcdLL3MLnn8snQF+2fY1Q67dUGX5ikdGwumcSgs2G9PjnYwNeks8Zxm3DFBcwJYHUQ+uR8gcWHihi9iS19a90efeb7zM7uhVEMMovv7lC9O5QaNBYFYN/tID9Y+3CSTjSfpOAXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XVx8VmDX; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XVx8VmDX"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-697763eeafcso6253025a12.3
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Jul 2026 02:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783415479; x=1784020279; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=017gAsipokr31hcEOs9r+XS73NV9N5N3+SvjZqA1EbI=;
        b=XVx8VmDXH0Hs7kW8toIo8uufVGYvgCrAZfFRzPimBYfUefqmKvGBL5/4APTSmFqd/l
         hPBmgd+SO2J3Yv47ZVmOjlJfVOGC0TOiuPa8i5ZLfxCdvob5IsoWLPirsJzv0fE/OH2/
         QyARwi68gRWoUcEfY9kB8Fj0pd07GY2uDB+bxV8ek5IbGMCvjpCRL6fXeb3QFinysdAl
         wPCEXv0ey/sszQ+0U+RAbaHjK9dEDVHEqDi5kATDWUwoxr4zELcsQE1qpX/ejNZeW368
         xkW4GNQV15UYP1DA8tWX0WQ29mO8dfDRuSH3A5AfvjOel1IdCuvoXxdBpEcatO4NWpJZ
         HoXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783415479; x=1784020279;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=017gAsipokr31hcEOs9r+XS73NV9N5N3+SvjZqA1EbI=;
        b=ZxKGhWzebgo3Ze5+Lsw8NN+zbq8aLxEVwmz3uGQdUPB6mvr99CD/+Si912P9/A3atW
         pcxcOKWI/kRz2C8Nt4E5sonLyQV/llMz52j9fC6c1z59zPD5QtG0Vex+krUT7fNv+EDD
         MO4UUNUCwo859mGusMPoeye+7MN9U2KYep7dDV8R0f2pwe80+97/p3a/D3SMycwxgFk7
         BtMZvtXfTC6GERY7IRP70GcgPmOqK9XoxnnB0ynCDJ3AA2Uno1/uqbAPARkk9CbUtPj0
         +RmBdM80Hkq/CROAGAarJ2i0a8eebzw70ZHJCjuT9QKd9OrZVgsxiZ/yC2dlve8yWEx5
         PbxQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpig1xLTwotINzwEjlA6pHM9yaYQYAt+0MKwLPjOFTC3E/IJ9ecjM+UO3EHhkjh9TIdGgf2R4k3erhoFwEdud0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyt41nNG0qkYlm9JsLbwgSuYMp5NW8ViuRnP4iqfiRrfIT3WWQZ
	hHUOZr1SeZr3h7DBA0GD5znaOQDr5gh5BKCvWknKIHFkR+ZH+/6SAPKi
X-Gm-Gg: AfdE7cm5mfZhlgucTfBy/0rn2wp0pl47jcID/sOUDJyLD2LNkE6Q9xuyUqxEJ2AjG1w
	Xd5FX+BQNFFjSWQi4Ww/1ZA4pFAyyfxfdzcwIRIdULPEwlFMfjTuwvRW0+QnsTWPRICSPMAkT3i
	yIuLP5pCJhqClt/hUP4o+lHaSPmEKf8geupU0gl/Icm5Ari1SAdn7NmsLQkzgA2Ch2lZI1cMhQc
	dY1wPJaxdLReHfCHnIpbKNYZBCJWHpIkNJjJYPcckX1rDn6vsOFpCa2R9VsFY9fXgH7gRl42Niy
	su8w2aUZYPBKhd6pjwPuIVfnwVnt+zWBYs4r8HTGX7zIG0RIsErfBDeICCVHIeoZVSjDi1X5QHc
	NlKIGFkjVliZTs6zGj2puwrbYPJqc9hQwZwF89RoxmeIXYR0ebSHj0eVVPC90AhH94Kv41ae0VB
	YB0RKG3BHL9GOke44h28pKmwg5Xau8yQRs+SAXzd8idynuEeifuA/1byWNjo/PCTXO3AHD52kWm
	2CnZwJqaP7PMNUxVIUfyTdANAaTjUKofSNDjvqqZr6FcCt+bx9leNw=
X-Received: by 2002:aa7:c588:0:b0:698:be56:d7cf with SMTP id 4fb4d7f45d1cf-69a85bb21cfmr1640778a12.16.1783415479480;
        Tue, 07 Jul 2026 02:11:19 -0700 (PDT)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69a19cd87d6sm5297152a12.6.2026.07.07.02.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 02:11:19 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Stanislav Fomichev <sdf.kernel@gmail.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Krishna Kumar <krikku@gmail.com>,
	Martin Karsten <mkarsten@uwaterloo.ca>
Cc: netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v12 nf-next 4/7] netfilter: nf_flow_table_inet: Add nf_flowtable_type flowtable_bridge
Date: Tue,  7 Jul 2026 11:10:42 +0200
Message-ID: <20260707091045.967678-5-ericwouds@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260707091045.967678-1-ericwouds@gmail.com>
References: <20260707091045.967678-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will allow a flowtable to be added to the nft bridge family.

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/nf_flow_table_inet.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/netfilter/nf_flow_table_inet.c b/net/netfilter/nf_flow_table_inet.c
index b0f1991719324..80b238196f29b 100644
--- a/net/netfilter/nf_flow_table_inet.c
+++ b/net/netfilter/nf_flow_table_inet.c
@@ -65,6 +65,16 @@ static int nf_flow_rule_route_inet(struct net *net,
 	return err;
 }
 
+static struct nf_flowtable_type flowtable_bridge = {
+	.family		= NFPROTO_BRIDGE,
+	.init		= nf_flow_table_init,
+	.setup		= nf_flow_table_offload_setup,
+	.action		= nf_flow_rule_bridge,
+	.free		= nf_flow_table_free,
+	.hook		= nf_flow_offload_inet_hook,
+	.owner		= THIS_MODULE,
+};
+
 static struct nf_flowtable_type flowtable_inet = {
 	.family		= NFPROTO_INET,
 	.init		= nf_flow_table_init,
@@ -97,6 +107,7 @@ static struct nf_flowtable_type flowtable_ipv6 = {
 
 static int __init nf_flow_inet_module_init(void)
 {
+	nft_register_flowtable_type(&flowtable_bridge);
 	nft_register_flowtable_type(&flowtable_ipv4);
 	nft_register_flowtable_type(&flowtable_ipv6);
 	nft_register_flowtable_type(&flowtable_inet);
@@ -109,6 +120,7 @@ static void __exit nf_flow_inet_module_exit(void)
 	nft_unregister_flowtable_type(&flowtable_inet);
 	nft_unregister_flowtable_type(&flowtable_ipv6);
 	nft_unregister_flowtable_type(&flowtable_ipv4);
+	nft_unregister_flowtable_type(&flowtable_bridge);
 }
 
 module_init(nf_flow_inet_module_init);
@@ -118,5 +130,6 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
 MODULE_ALIAS_NF_FLOWTABLE(AF_INET);
 MODULE_ALIAS_NF_FLOWTABLE(AF_INET6);
+MODULE_ALIAS_NF_FLOWTABLE(AF_BRIDGE);
 MODULE_ALIAS_NF_FLOWTABLE(1); /* NFPROTO_INET */
 MODULE_DESCRIPTION("Netfilter flow table mixed IPv4/IPv6 module");
-- 
2.53.0

