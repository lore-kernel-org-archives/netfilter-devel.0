Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0366715DBA1
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Apr 2024 11:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713438567; cv=none; b=NeTuiVCPZ3au58Co9jbb5a18yxzQyhL6hFUSlmR0IIj3bG24k6A7Rb0TiexSFU9lDRM6PQxARl0Bxvd+VA/iPOnNqMWRfR4AKIGfCyRtBiaYd8OPqplYshhh5KRPS+Hp0T4Lz5b4W5Pwxc0kY7CsCT3A5FU9ULI6dxkST2ot9jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713438567; c=relaxed/simple;
	bh=aWz5Gig2xv2dqOzuJfPq1HgDbmDRmwb4+kS753Y/Y7o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i7X9UPji93874GVAeSntCzv9KESM9wVRdTgNUFb98E3r3X3hN497Dd9G6MiiBcFEEJp0+DErbDvaJWmfG04aHLkYjvev+POr++hAeRu33V1zXBuUWe4z3Y7Zq2erOsMtzlcltDud+7D9K/HkQOYUW9ySZzkSng01s0f050Yi8Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=lpYe4hx/; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="lpYe4hx/"
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 4286040D7C
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Apr 2024 11:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1713438129;
	bh=ktW00F9DIAhL7DS4TlvR8U57g+A/C2nEvJUjlW8cwMw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type;
	b=lpYe4hx/C8c3+Uq4BzQVzrFs2MoXisxVRCW5jlg4WZ8S24xBMwOKPuhdbSsQ67jOg
	 dCXa7bcAPqBoloz/6lxHT2wGEB1COfjPKOLfhH7gqGgmbLzZtNVsX9vvz/MG0nBm0W
	 +PKSN047yU1bf+OhZ3A8ONB87b/46XSV8o6AaJvlmk2CFA8ZhY4T/dx6tiXYo8CbiO
	 nH+v/RAZL8pW20hXXFVpLs6vPvO+qlhggfGyg8B1p/cPiHKe77W3ctDONVasRBUhHD
	 QnKNVQPjIefaO+xtAvLRAILBKoquGMsNT2RVPfD0iqYR3GXHo9JhBcjTbE4ddQopn4
	 CyCIRm0HnxpWg==
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a51c76700adso176036166b.0
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Apr 2024 04:02:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713438128; x=1714042928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ktW00F9DIAhL7DS4TlvR8U57g+A/C2nEvJUjlW8cwMw=;
        b=tqcXkUxenV8Jz9MM2IUWiHS9t77Y0/ZssJI5HaFLB3dSnK1p+YgFSlPS8HKys4oiVy
         fD8DWhyjDJeNVh1s0AIFVxiVM1PM9+kWjNslmAe7AKJ8cN5LtL+H5ZBX4vzIi5wWxa5A
         DsnhLp22mG74idmUMD+4uonjqceCYPGiQLpmQ4U5hrdebdIeUmSFLHBSaN/WXIX0+F/9
         a7vpUaI+qOS1MLO+rWVb7oruStwUwiowIQmFvpoqAGSMzET65TSOtQxOnsQO2GYYUIHN
         3YU8E9Du41JmnA2h45nOI/gDVJ3X/ChBXLJ/YIEA9m7bQqx8P3wU/dplDrBciqQe5rzV
         FDCw==
X-Forwarded-Encrypted: i=1; AJvYcCURLfmXQ+L7KXHsaC6/ZQyo8O4q0uzXcO81FiJ3mbkjZvg8cZps+5TQF4UnTgYpqHwjPKUTbE+DR0D//ZldB+aD/BQr805yDdIMPj+FSBP7
X-Gm-Message-State: AOJu0YwYv/nnnMHQGizEP/lfKAkI6AYIzJ0+8fbSlprntoRVCAoLOiYC
	WwDN861oJCkozS/qYvvJQ+hNmjx2M+Vft9V7Wgl0leVw9NkdFCGThyH65GVFSVUGvT2rpd7oBTi
	hydkW5WEr5/4o97bOclddCB+Wrn2vfPbfVJT/G4bPrj8wTHmE/0rZS0BcRfoL9uij0xSCJ7WCNu
	HPPnIj3Vmvth3n1g==
X-Received: by 2002:a17:907:9447:b0:a52:30d4:20e6 with SMTP id dl7-20020a170907944700b00a5230d420e6mr1974029ejc.10.1713438128377;
        Thu, 18 Apr 2024 04:02:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEv+5q9kt1eWZoXNQEPQAWf0LPsfHN7n2d9j+DQUT0Ja9+xBCd4zGciLDlc/mEh9WbiEhFr4w==
X-Received: by 2002:a17:907:9447:b0:a52:30d4:20e6 with SMTP id dl7-20020a170907944700b00a5230d420e6mr1974004ejc.10.1713438128069;
        Thu, 18 Apr 2024 04:02:08 -0700 (PDT)
Received: from amikhalitsyn.lan ([2001:470:6d:781:320c:9c91:fb97:fbfc])
        by smtp.gmail.com with ESMTPSA id yk18-20020a17090770d200b00a51983e6190sm728594ejb.205.2024.04.18.04.02.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Apr 2024 04:02:07 -0700 (PDT)
From: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To: horms@verge.net.au
Cc: netdev@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
	=?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@stgraber.org>,
	Christian Brauner <brauner@kernel.org>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next v2 2/2] ipvs: allow some sysctls in non-init user namespaces
Date: Thu, 18 Apr 2024 13:01:53 +0200
Message-Id: <20240418110153.102781-2-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240418110153.102781-1-aleksandr.mikhalitsyn@canonical.com>
References: <20240418110153.102781-1-aleksandr.mikhalitsyn@canonical.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Let's make all IPVS sysctls writtable even when
network namespace is owned by non-initial user namespace.

Let's make a few sysctls to be read-only for non-privileged users:
- sync_qlen_max
- sync_sock_size
- run_estimation
- est_cpulist
- est_nice

I'm trying to be conservative with this to prevent
introducing any security issues in there. Maybe,
we can allow more sysctls to be writable, but let's
do this on-demand and when we see real use-case.

This patch is motivated by user request in the LXC
project [1]. Having this can help with running some
Kubernetes [2] or Docker Swarm [3] workloads inside the system
containers.

[1] https://github.com/lxc/lxc/issues/4278
[2] https://github.com/kubernetes/kubernetes/blob/b722d017a34b300a2284b890448e5a605f21d01e/pkg/proxy/ipvs/proxier.go#L103
[3] https://github.com/moby/libnetwork/blob/3797618f9a38372e8107d8c06f6ae199e1133ae8/osl/namespace_linux.go#L682

Cc: Stéphane Graber <stgraber@stgraber.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Julian Anastasov <ja@ssi.bg>
Cc: Simon Horman <horms@verge.net.au>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index daa62b8b2dd1..f84f091626ef 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -4272,6 +4272,7 @@ static int __net_init ip_vs_control_net_init_sysctl(struct netns_ipvs *ipvs)
 	struct ctl_table *tbl;
 	int idx, ret;
 	size_t ctl_table_size = ARRAY_SIZE(vs_vars);
+	bool unpriv = net->user_ns != &init_user_ns;
 
 	atomic_set(&ipvs->dropentry, 0);
 	spin_lock_init(&ipvs->dropentry_lock);
@@ -4286,12 +4287,6 @@ static int __net_init ip_vs_control_net_init_sysctl(struct netns_ipvs *ipvs)
 		tbl = kmemdup(vs_vars, sizeof(vs_vars), GFP_KERNEL);
 		if (tbl == NULL)
 			return -ENOMEM;
-
-		/* Don't export sysctls to unprivileged users */
-		if (net->user_ns != &init_user_ns) {
-			tbl[0].procname = NULL;
-			ctl_table_size = 0;
-		}
 	} else
 		tbl = vs_vars;
 	/* Initialize sysctl defaults */
@@ -4317,10 +4312,17 @@ static int __net_init ip_vs_control_net_init_sysctl(struct netns_ipvs *ipvs)
 	ipvs->sysctl_sync_ports = 1;
 	tbl[idx++].data = &ipvs->sysctl_sync_ports;
 	tbl[idx++].data = &ipvs->sysctl_sync_persist_mode;
+
 	ipvs->sysctl_sync_qlen_max = nr_free_buffer_pages() / 32;
+	if (unpriv)
+		tbl[idx].mode = 0444;
 	tbl[idx++].data = &ipvs->sysctl_sync_qlen_max;
+
 	ipvs->sysctl_sync_sock_size = 0;
+	if (unpriv)
+		tbl[idx].mode = 0444;
 	tbl[idx++].data = &ipvs->sysctl_sync_sock_size;
+
 	tbl[idx++].data = &ipvs->sysctl_cache_bypass;
 	tbl[idx++].data = &ipvs->sysctl_expire_nodest_conn;
 	tbl[idx++].data = &ipvs->sysctl_sloppy_tcp;
@@ -4343,15 +4345,22 @@ static int __net_init ip_vs_control_net_init_sysctl(struct netns_ipvs *ipvs)
 	tbl[idx++].data = &ipvs->sysctl_conn_reuse_mode;
 	tbl[idx++].data = &ipvs->sysctl_schedule_icmp;
 	tbl[idx++].data = &ipvs->sysctl_ignore_tunneled;
+
 	ipvs->sysctl_run_estimation = 1;
+	if (unpriv)
+		tbl[idx].mode = 0444;
 	tbl[idx].extra2 = ipvs;
 	tbl[idx++].data = &ipvs->sysctl_run_estimation;
 
 	ipvs->est_cpulist_valid = 0;
+	if (unpriv)
+		tbl[idx].mode = 0444;
 	tbl[idx].extra2 = ipvs;
 	tbl[idx++].data = &ipvs->sysctl_est_cpulist;
 
 	ipvs->sysctl_est_nice = IPVS_EST_NICE;
+	if (unpriv)
+		tbl[idx].mode = 0444;
 	tbl[idx].extra2 = ipvs;
 	tbl[idx++].data = &ipvs->sysctl_est_nice;
 
-- 
2.34.1

