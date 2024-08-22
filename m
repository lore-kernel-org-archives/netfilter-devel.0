Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B711CF28E;
	Thu, 22 Aug 2024 17:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724349350; cv=none; b=pY6dGRPGwh8poaVLPz6lLqkUlFE3csNVV2ABOX2AOv01Fqt4NB4VzJv+vsnfZKEF+P2FGdpmtY4N8DzAMMwhKzknC5Dn+JTXpHaBIagjsoScXF4OBlbNG86mq+uKS13cAosjo0sf8WfhzHeQzv4enyr65Mkud3OasUuMhM0Pa44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724349350; c=relaxed/simple;
	bh=svGzr/EOKthKAfM4ADjLc6AE9vcCg3xzVoqMHFWPJzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c3jRL1fQTESLqOukmLxfOsLRV5qK212g2pq+5O6YLjDfXeAtFLlUnZR6AgZ9mfgTFLgrDttxughfEDAN4N/q4VLrmOseInmqJ4H3JLYZ1iPApU4aFAr9fFDhqRb/dBKMuUOwl2x17jGaZQ8stngwKKIetm9sh5PTYVDcx5g4Wcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5bec4e00978so1255695a12.0;
        Thu, 22 Aug 2024 10:55:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724349347; x=1724954147;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pF8jJx2hGWJnI5FC+pXJw8DPGOf+ZBo1ceH028PAYOo=;
        b=EQ9Qjn/inyKvv5GGFN1oIjCxRiVUQdkgi6FcMLfWFOgH+QZrifU57ulW76tEXFRv+r
         dbC/FMFgmBvaZVfzfcSrG3waloWmWCMh+ihbWM4nS1Q/0ZK2jT4p9ukB1OUYl/lEirUS
         i4dHBYZyLv2uG0eW52XY2Plp0+8DZ5nIY8+/EfG6n5gm2QEmGMHiJIS2FDnMCGie81rA
         ZSXZr26U77t/58t9bL/WZmGrhcjlgb5xwmGy1lu00X+lez3vMcBS77ATB0TivpnBiwH5
         KeY1FlleQi+L4fXvaJ9B0N648NzXazRF+5AoIxCeLgtwYzYczQqdbyizeYS8cQMNShi9
         5q1g==
X-Forwarded-Encrypted: i=1; AJvYcCVRo3iatcOh/VVv7X8LbUsRuUmDASvdtNywVQcUNFaAC/m4CmegqIb4WUrOH5EbEPHa+lenlZdU3/sitRU=@vger.kernel.org, AJvYcCVooL9aEghe9yONaAvLVs8Y7RrI8K13xVQBDdP7pvWX2zhfvwAw2kxvTsbqwxlkCU/E+0tY+UvPRXnSZfzZxtzo@vger.kernel.org, AJvYcCWbN+WIW+15TlLkPrGSQsyzs8D4XuV6k7rLfwpXbGMGerhBBarflHW9tmy5Fivs3qCsXLhFnN9E@vger.kernel.org
X-Gm-Message-State: AOJu0Yym3QxBuvJNg+pPuPVeSI8CznftrLEAkrpi4cO3ow5hALzyfJNL
	Lm9/OIzLa6ZKy0j60IQFakXMUTBH4NPvdOudh/NbOA9/7K5UqJPZ
X-Google-Smtp-Source: AGHT+IHpGLM1fOuatWlj67HKeq4LTkSuS54BHZ1AswCdrbIDKiHS4FSe1vcQFS4Db1kJsVr44hxHcQ==
X-Received: by 2002:a17:907:944f:b0:a7a:b620:aa2f with SMTP id a640c23a62f3a-a866f2a2cabmr489778566b.15.1724349346328;
        Thu, 22 Aug 2024 10:55:46 -0700 (PDT)
Received: from localhost (fwdproxy-lla-009.fbsv.net. [2a03:2880:30ff:9::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a868f220121sm147986566b.33.2024.08.22.10.55.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2024 10:55:45 -0700 (PDT)
From: Breno Leitao <leitao@debian.org>
To: fw@strlen.de,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: leit@meta.com,
	netfilter-devel@vger.kernel.org (open list:NETFILTER),
	coreteam@netfilter.org (open list:NETFILTER),
	netdev@vger.kernel.org (open list:NETWORKING [IPv4/IPv6]),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH nf-next 1/2] netfilter: Make IP_NF_IPTABLES_LEGACY selectable
Date: Thu, 22 Aug 2024 10:55:35 -0700
Message-ID: <20240822175537.3626036-1-leitao@debian.org>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This option makes IP_NF_IPTABLES_LEGACY user selectable, giving
users the option to configure iptables without enabling any other
config.

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 net/ipv4/netfilter/Kconfig | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 1b991b889506..a06c1903183f 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -12,7 +12,12 @@ config NF_DEFRAG_IPV4
 
 # old sockopt interface and eval loop
 config IP_NF_IPTABLES_LEGACY
-	tristate
+	tristate "Legacy IP tables support"
+	default	n
+	select NETFILTER_XTABLES
+	help
+	  iptables is a general, extensible packet identification legacy framework.
+	  This is not needed if you are using iptables over nftables (iptables-nft).
 
 config NF_SOCKET_IPV4
 	tristate "IPv4 socket lookup support"
@@ -177,7 +182,7 @@ config IP_NF_MATCH_TTL
 config IP_NF_FILTER
 	tristate "Packet filtering"
 	default m if NETFILTER_ADVANCED=n
-	select IP_NF_IPTABLES_LEGACY
+	depends on IP_NF_IPTABLES_LEGACY
 	help
 	  Packet filtering defines a table `filter', which has a series of
 	  rules for simple packet filtering at local input, forwarding and
@@ -217,7 +222,7 @@ config IP_NF_NAT
 	default m if NETFILTER_ADVANCED=n
 	select NF_NAT
 	select NETFILTER_XT_NAT
-	select IP_NF_IPTABLES_LEGACY
+	depends on IP_NF_IPTABLES_LEGACY
 	help
 	  This enables the `nat' table in iptables. This allows masquerading,
 	  port forwarding and other forms of full Network Address Port
@@ -258,7 +263,7 @@ endif # IP_NF_NAT
 config IP_NF_MANGLE
 	tristate "Packet mangling"
 	default m if NETFILTER_ADVANCED=n
-	select IP_NF_IPTABLES_LEGACY
+	depends on IP_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `mangle' table to iptables: see the man page for
 	  iptables(8).  This table is used for various packet alterations
@@ -293,7 +298,7 @@ config IP_NF_TARGET_TTL
 # raw + specific targets
 config IP_NF_RAW
 	tristate  'raw table support (required for NOTRACK/TRACE)'
-	select IP_NF_IPTABLES_LEGACY
+	depends on IP_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `raw' table to iptables. This table is the very
 	  first in the netfilter framework and hooks in at the PREROUTING
@@ -305,9 +310,7 @@ config IP_NF_RAW
 # security table for MAC policy
 config IP_NF_SECURITY
 	tristate "Security table"
-	depends on SECURITY
-	depends on NETFILTER_ADVANCED
-	select IP_NF_IPTABLES_LEGACY
+	depends on SECURITY && NETFILTER_ADVANCED && IP_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `security' table to iptables, for use
 	  with Mandatory Access Control (MAC) policy.
-- 
2.43.5

