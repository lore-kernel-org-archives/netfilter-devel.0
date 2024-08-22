Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD3D168497;
	Thu, 22 Aug 2024 17:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724349352; cv=none; b=a8Yd29/LturzYZ6MAu+ZpYobeXQTy18qLJu738qVuQsMVPsTpFL9L8iMIZL+XnbPaHlhbvljYRV371ej83aKUEC+FJ2sitAIwapjGHI0zJQ5Gl459Lz1EZO8HfhnXfweUaM7PQP9XcjiOqLXRZB1apcrvW5DGSSb1A6At+Vmp/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724349352; c=relaxed/simple;
	bh=pROawHmFV2BT+O5PvWXvAmoiKYg1NL9rMqu4AAWOwOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aByE4Ofih/DhnBY4Juy7GVomSUrVr0gBa85L1HPEJxMgQq+NPx/YLdENXSicWNPUvkJ4ZQpOg7EoN09QzAhKRLC4RJm45QZwI3LyWKWnu0RM4BVge+1sQ8r+/k2VsXxmXFu78ruNXtSOgYhe/foOFw98k5HAV66DXtXF1hfi778=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5bed68129a7so1505822a12.2;
        Thu, 22 Aug 2024 10:55:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724349349; x=1724954149;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WCPimQ84Bcp6pN8w/ENlDXV/sgr5BQCEPEmtyI0sdvk=;
        b=WqDc0QuvZqSPWqMQY4zNUxTRJSqi6U8uzOMNy98kQyF0oAwRDoA36iEAByA8JKVcq2
         UBR5e2C5Vd4GAjozUcIpaf3WWPXd4vJ3GKaUqQu2eNxATy+NIVWA4wXU1uX1dyFdCGTs
         XIQutgTCASc+QY1pV33o6NVGLSOa/CVC2sKPASACi02MGDV3VLUaxrfSCOGfC1jTxdtF
         +aiHSzVPc5ldgfcCW9+8yIX5freFb29Bv1natHilqjsGP12j6AkySou/LkgmlofZ/TDT
         18V54H/l/qP1tmZjviiGDvFmMO6VRVDjNavRuX2+pFJOrO4nSw69/AlFybR6bloVhAKR
         DhfQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0qBGz786UeJfoUBAnsNz9JQXwLTCk8vFCEU2ofQsg2VkZu9FGphvyGbpcTi2vGcQUgxo96z8AJWasF+4=@vger.kernel.org, AJvYcCV3yWMUfIQZzTek5SUleChGuYbReo1ttJa8+G9gJBg0Un48dtnlmykRRWWIErTdP4QaxqcNDE/DXWMD85QpzlVN@vger.kernel.org, AJvYcCVdpmclRRBOZf4sPnkXk1L1Ui8bfCZPKGaXIbLcYlgaEt7+ivO35TT2wmSP8LLPEP4rrSylfLlj@vger.kernel.org
X-Gm-Message-State: AOJu0YwBO4CQ/tWarBjFaRXH7Fn9QzdHCn7TWOTi5xBN2rO7aTxhhGql
	IZeWYKQkEOFxUWROsw6Kvdt/QCp8X6Fj/PO2fpIMTRRfqhi5PVvE
X-Google-Smtp-Source: AGHT+IGo1m/dgH1SW/4jpR310dTx7p6yetF0QpZG78l9g2MOTp3K+MRKtOc7nZ70JE7HCctoRqlZMw==
X-Received: by 2002:a05:6402:520e:b0:5be:fadc:8707 with SMTP id 4fb4d7f45d1cf-5c0791ce631mr1725856a12.7.1724349348275;
        Thu, 22 Aug 2024 10:55:48 -0700 (PDT)
Received: from localhost (fwdproxy-lla-003.fbsv.net. [2a03:2880:30ff:3::face:b00c])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c044ddc612sm1139524a12.18.2024.08.22.10.55.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2024 10:55:47 -0700 (PDT)
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
Subject: [PATCH nf-next 2/2] netfilter: Make IP6_NF_IPTABLES_LEGACY selectable
Date: Thu, 22 Aug 2024 10:55:36 -0700
Message-ID: <20240822175537.3626036-2-leitao@debian.org>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20240822175537.3626036-1-leitao@debian.org>
References: <20240822175537.3626036-1-leitao@debian.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This option makes IP6_NF_IPTABLES_LEGACY user selectable, giving
users the option to configure iptables without enabling any other
config.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 net/ipv6/netfilter/Kconfig | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index f3c8e2d918e1..dad0a50d3ef4 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -8,7 +8,13 @@ menu "IPv6: Netfilter Configuration"
 
 # old sockopt interface and eval loop
 config IP6_NF_IPTABLES_LEGACY
-	tristate
+	tristate "Legacy IP6 tables support"
+	depends on INET && IPV6
+	select NETFILTER_XTABLES
+	default n
+	help
+	  ip6tables is a general, extensible packet identification legacy framework.
+	  This is not needed if you are using iptables over nftables (iptables-nft).
 
 config NF_SOCKET_IPV6
 	tristate "IPv6 socket lookup support"
@@ -190,7 +196,7 @@ config IP6_NF_TARGET_HL
 config IP6_NF_FILTER
 	tristate "Packet filtering"
 	default m if NETFILTER_ADVANCED=n
-	select IP6_NF_IPTABLES_LEGACY
+	depends on IP6_NF_IPTABLES_LEGACY
 	tristate
 	help
 	  Packet filtering defines a table `filter', which has a series of
@@ -227,7 +233,7 @@ config IP6_NF_TARGET_SYNPROXY
 config IP6_NF_MANGLE
 	tristate "Packet mangling"
 	default m if NETFILTER_ADVANCED=n
-	select IP6_NF_IPTABLES_LEGACY
+	depends on IP6_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `mangle' table to iptables: see the man page for
 	  iptables(8).  This table is used for various packet alterations
@@ -237,7 +243,7 @@ config IP6_NF_MANGLE
 
 config IP6_NF_RAW
 	tristate  'raw table support (required for TRACE)'
-	select IP6_NF_IPTABLES_LEGACY
+	depends on IP6_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `raw' table to ip6tables. This table is the very
 	  first in the netfilter framework and hooks in at the PREROUTING
@@ -249,9 +255,7 @@ config IP6_NF_RAW
 # security table for MAC policy
 config IP6_NF_SECURITY
 	tristate "Security table"
-	depends on SECURITY
-	depends on NETFILTER_ADVANCED
-	select IP6_NF_IPTABLES_LEGACY
+	depends on SECURITY && NETFILTER_ADVANCED && IP6_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `security' table to iptables, for use
 	  with Mandatory Access Control (MAC) policy.
@@ -260,10 +264,8 @@ config IP6_NF_SECURITY
 
 config IP6_NF_NAT
 	tristate "ip6tables NAT support"
-	depends on NF_CONNTRACK
-	depends on NETFILTER_ADVANCED
+	depends on NF_CONNTRACK && NETFILTER_ADVANCED && IP6_NF_IPTABLES_LEGACY
 	select NF_NAT
-	select IP6_NF_IPTABLES_LEGACY
 	select NETFILTER_XT_NAT
 	help
 	  This enables the `nat' table in ip6tables. This allows masquerading,
-- 
2.43.5

