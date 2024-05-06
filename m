Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FDA13664A
	for <netfilter-devel@vger.kernel.org>; Mon,  6 May 2024 14:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715004903; cv=none; b=XTOf04AkxVsgXZALne82DUx0gPT3LY1ql2mAppenTbXWfqRAaJtDunJcPX7vzMR/Bz5MzWFXA2eqvL1XJ0auMphugY0evjI1ezh7naH0q0k+DWbHz4mB4fVeMTBWxPgd67zPtaKLPUx98KGzXqXmYomOIBzbJ5kIhx0Wszqlcac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715004903; c=relaxed/simple;
	bh=wcidanXZQTb3aE8biUO7m9uGWdjY9fC00+u5PTnfNfg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sg08B5UfTxv4hemzu14bHafXP46IUy15nZjPfQ05DO/IwcICVyhwZYkAxqdj/7g/ThQl4jQBkgqciOWKPzEp5M5KK25qfIKTcKSRu9hlLuhONVSwyKXx2pQp3Qr+RoHtikcYye6c6XKOwasUSSQ1yoGK4gpvkuv615E25eLUzyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=phcptJ2Q; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="phcptJ2Q"
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id A61E33FD47
	for <netfilter-devel@vger.kernel.org>; Mon,  6 May 2024 14:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1715004894;
	bh=ZyaYKGnkDPnTk6rgEgUZ2eoc97Zq0+zWClbbP5jrG5Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
	b=phcptJ2QVN0G8jM8cNMMBXZ5gNfWBLDEoemhGjO0tdU90Nb3ykM8qrXT3sAjsxcpr
	 KREGP2NgUd6/12S7lw8jJCPz2dG2vx6r5sJdR4sr5UzGCFp7HCyzSNiPcSuWowiNiP
	 NkAXKTkYpHInv2dEAo1VPpGQYblhUWHpQIs/SoU3gSebJOSBbigY0CPFItPAPdE/R4
	 eFtGOVo4zZYzW4u7xhq/hAba2J2TS3M3aBGduEP9kw4VZ94PnHbwPnt4L1AFo7BcOx
	 RkIJ06U88vNhmFzum63uBDrQQrvJ6vlr9OuEoVsrqZqZdV0Q/FBULMxdJDiWtRqAfc
	 0DljOOaRMjI/A==
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a59a5b06802so122819766b.1
        for <netfilter-devel@vger.kernel.org>; Mon, 06 May 2024 07:14:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715004894; x=1715609694;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZyaYKGnkDPnTk6rgEgUZ2eoc97Zq0+zWClbbP5jrG5Y=;
        b=NNOiVc5To6TlUjZYCop5RrYz1IZQLAuz3AjzH8FUmFc3ICF0VRKOZSZsKPYQ7oNfum
         4rV4E77OTEwEUvD7FyJz+aWiH8EOYfRDg25m6GM5xYHd6pkLSmHMPQHMCZ2MLUy57f3d
         HVmpxEb24eZzVmyrbEoPKWhqSy5k5cKMS0w1dG3EU3tRIQ5hJmk5JW9rXgPbnE9y1g9S
         Iy9dsyqumESl/Buxf2sZyn2Pfm8RoJw+hVPbAYB3z7G1rJ6FEJ644GCj1XceaeDe4LaR
         FBFokL02YvZBWE657UtKzqIgR6Mm5x60AI4EWoF/zpf+h2yzyXNqr9QyesUIUTB7E+u8
         w5gA==
X-Forwarded-Encrypted: i=1; AJvYcCXIDyAoxz0iR7r6RMe/OLacTser5JatyD8YGdmFfhw0cnUFjaOskz1e9E+J27WE49DpwZRGgY+7VLq9WCM3uydg8g0T32aFXSjnWsecr1XP
X-Gm-Message-State: AOJu0YyMF1soPPwlqJ4qP6r8kL8nPWGANf5PfENAy6rISw7OmDQd1DPf
	uw1fsYBJXAGCgOLWTTElr7tknMqqoyGd+iPrFYWH0hgCjcvtmL0j8t5kHK5JH4vFUgc3TuHnUeL
	S+UGHT0DLdqJIscQT5jimB+ZvDUTbuDo7N6sBFFFYuZ26dSRzYERfBQveWjQIORXnOz0gqr0VU3
	O77mBsKg==
X-Received: by 2002:a17:906:4899:b0:a59:bfd3:2b27 with SMTP id v25-20020a170906489900b00a59bfd32b27mr2701615ejq.70.1715004894082;
        Mon, 06 May 2024 07:14:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEk/9m6RYfEf0M6hlNPk6/CFatHUn4Rb6d03W4Hp+pLLGOwdF9b9V1H4mNBZdkFpbMX/boBAw==
X-Received: by 2002:a17:906:4899:b0:a59:bfd3:2b27 with SMTP id v25-20020a170906489900b00a59bfd32b27mr2701599ejq.70.1715004893754;
        Mon, 06 May 2024 07:14:53 -0700 (PDT)
Received: from amikhalitsyn.lan ([2001:470:6d:781:4703:a034:4f89:f1de])
        by smtp.gmail.com with ESMTPSA id xh9-20020a170906da8900b00a597ff2fc0dsm4663754ejb.69.2024.05.06.07.14.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 May 2024 07:14:53 -0700 (PDT)
From: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To: horms@verge.net.au
Cc: netdev@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH v4 1/2] ipvs: add READ_ONCE barrier for ipvs->sysctl_amemthresh
Date: Mon,  6 May 2024 16:14:43 +0200
Message-Id: <20240506141444.145946-1-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Cc: Julian Anastasov <ja@ssi.bg>
Cc: Simon Horman <horms@verge.net.au>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Suggested-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 50b5dbe40eb8..e122fa367b81 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -94,6 +94,7 @@ static void update_defense_level(struct netns_ipvs *ipvs)
 {
 	struct sysinfo i;
 	int availmem;
+	int amemthresh;
 	int nomem;
 	int to_change = -1;
 
@@ -105,7 +106,8 @@ static void update_defense_level(struct netns_ipvs *ipvs)
 	/* si_swapinfo(&i); */
 	/* availmem = availmem - (i.totalswap - i.freeswap); */
 
-	nomem = (availmem < ipvs->sysctl_amemthresh);
+	amemthresh = max(READ_ONCE(ipvs->sysctl_amemthresh), 0);
+	nomem = (availmem < amemthresh);
 
 	local_bh_disable();
 
@@ -145,9 +147,8 @@ static void update_defense_level(struct netns_ipvs *ipvs)
 		break;
 	case 1:
 		if (nomem) {
-			ipvs->drop_rate = ipvs->drop_counter
-				= ipvs->sysctl_amemthresh /
-				(ipvs->sysctl_amemthresh-availmem);
+			ipvs->drop_counter = amemthresh / (amemthresh - availmem);
+			ipvs->drop_rate = ipvs->drop_counter;
 			ipvs->sysctl_drop_packet = 2;
 		} else {
 			ipvs->drop_rate = 0;
@@ -155,9 +156,8 @@ static void update_defense_level(struct netns_ipvs *ipvs)
 		break;
 	case 2:
 		if (nomem) {
-			ipvs->drop_rate = ipvs->drop_counter
-				= ipvs->sysctl_amemthresh /
-				(ipvs->sysctl_amemthresh-availmem);
+			ipvs->drop_counter = amemthresh / (amemthresh - availmem);
+			ipvs->drop_rate = ipvs->drop_counter;
 		} else {
 			ipvs->drop_rate = 0;
 			ipvs->sysctl_drop_packet = 1;
-- 
2.34.1

