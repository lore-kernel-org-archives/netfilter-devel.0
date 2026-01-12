Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65213357A4C
	for <netfilter-devel@vger.kernel.org>; Mon, 12 Jan 2026 12:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768222492; cv=none; b=gVlOYpjEL7vIOyWveWEJYMZ8r8FUWq+jY1gQ/dG0WaE5DX/OB+7cUagF9GfBBr7Syg98r6ntkzhnc/o0YATLFBORc3I8x/kXr0WJNwqJ/GmZwjI2Gybz+tquPwuLI67KAneg4Fzo9GUU8Gwo91CjZnUjVJZKcMdX484SAXHKtYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768222492; c=relaxed/simple;
	bh=V7UrOAgbBjKbnTlNQ87vW7Z6nwRklkpYJYPGjtD9Pw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iwysw2w5WDIOfgG5tIy3M1QedWwWs0MktoFxLKtVmYiPppk49nZQuNt6RmbXH1FTlTa8hdXA9P1R4N03nYoaf9W+qt6svHbIiX+rRvqQnmjlbytaRGVi94cQJezuDQTHhTPn6zkkRM1esbg8s6Hkfg8HBjFbL1xjsXtaFjyf5G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X5wkjHSk; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OOTXesEH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X5wkjHSk";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="OOTXesEH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768222487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s/ujfx9fRHizDfrh38x0NK7m/HfIxQpjC07mOPX7fVQ=;
	b=X5wkjHSkYASjPdT1nI5iE7J9Yb1uMF4TzsRZxig/PqgH4pGUbACJS5ZB4Mzg3TbeZLYyBM
	hgcow85AQ+aQXpT4NzkbWdr291Jf3KLjHxqpuEjajK0ZZntISJkRpqZeX5tEPQ7GT7F/+T
	v7vOdd+9ddhzdI58gNWH8+H4X14nvQo=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-laiZjzGAPRqBqzASxOe9tw-1; Mon, 12 Jan 2026 07:54:46 -0500
X-MC-Unique: laiZjzGAPRqBqzASxOe9tw-1
X-Mimecast-MFC-AGG-ID: laiZjzGAPRqBqzASxOe9tw_1768222485
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-b7a29e6f9a0so626152066b.1
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Jan 2026 04:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768222485; x=1768827285; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s/ujfx9fRHizDfrh38x0NK7m/HfIxQpjC07mOPX7fVQ=;
        b=OOTXesEHgTZrDgmW1E8LbtzZM//1wQEKtW7OCr9r3fEaXZVt/hvQBVzlc6XjtYsMom
         dkCZ8By6+k2PG5ZCTe3bAEXifpgujPWyzSUYEYG8Uh4DJVp464hyii3J9Caao458gEin
         wzvuNcZviQb1bD3zledX24EAIJDge4yftjESfXwwWZQ0oCMB6C3ij4KTVQ6ktqHkfaYx
         CzWJmOPxgIXtxrLFUHXEBPCRNhWCnFshyfqgbcs8da9nrWtAIsdTttHyocbxh3lrZQsd
         1VeXjBt/f5wpE/6a0SBsOxmwC4QiOTBREfI+FpmRTQJtXiF3mEW/qldt8J3oZK4UfEAZ
         iumA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768222485; x=1768827285;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s/ujfx9fRHizDfrh38x0NK7m/HfIxQpjC07mOPX7fVQ=;
        b=AyAO+Xet0/qTyEC2kTfPDBw2V0XU5qTQnsQJyn/hoHsymEN7MFuvrO0sd7l+rjfjTI
         /YRZvXxT9PeTv/embg545HMtqORagf1EDVtl6fzuAa5oJwBDIWz7uT6ECa3CLcEg94K8
         zfloM3VZMGYxS0Tj7v1pzPm0t+F/nH1Uw7XHhKT3IdBxuOcWMfARGi4fYqMbBsxm94N1
         pFE/2a5NSMRjRLVOF1wbOBolGlhj1W1aqSIAwSXqCxMVzW65kKUmM4e9nb35liQFO53+
         Pm5B71rNs2ucr9KtjMNCCPGEj4ykVviny9MVosR/ziCWrd6UzAgYsYIweiUJf7g3BJwU
         zTfA==
X-Forwarded-Encrypted: i=1; AJvYcCWBNpLTiCoFcVpWcN+QWmO/rOZxVJ+8HNWvX1+ViKQ6aje2Lmg0MFC7pkismvzVsXFZrjx3vN8l1f3NjN5tQiQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyee3OY+gznn/vFuNq9/mNHwk59uIF+L+cUqXobtJVUjpHKv+5t
	fzEpLgp5CMyBRQOiFUilGUFeHvP5+jFVf6eZwf4gpMKQ8Uq/bkltmNnwE8kO4c29Oo1q6Kk3svh
	N5aDBDPGVWbUYbXZOnUQbJDPEOOResLZBNA+4M7In8fuV56ZgTaKDx8KKdosvP4C2KL47jg==
X-Gm-Gg: AY/fxX5QHoAp0naYjUuyORMif7HvUet4x6HvhajxWU4vKRObw2QqT0o/NSLG17IqU8L
	6f/zFdFmeu9+xrnKITtmHlhUwHA4Kmvdr7kENU3/UQIx0HVZU4rfVkjBRMkFSHTkJEl723DhxBW
	x+17MkjIEKeMtOf4sSR9xC7ROMppCtcrLAnOiAthzbalUo+7YvxtxyWq/9O7SpAFET46srPOpQi
	c6X6t/IWWOChwN5qb5+NRHWWG+NeqQPhNKAtgxUspXS+QMK33t7DRYqB4I0WBnBEznr71CaVn1q
	PbIVKBRMtnILYRL4DzNdEpCyVogcGB+/D6fZ6rVNX5oqJbZSOrDY3g9Gq5raJmWZ3ts+HarOohh
	E2jA1AekG02xiR5uk2gl8hap/1c+8Ov4LJ9JhYqV3AC9VPvsixAbgZe/uaL4=
X-Received: by 2002:a17:907:9723:b0:b87:fc5:40ba with SMTP id a640c23a62f3a-b870fc61ea2mr392027866b.20.1768222484781;
        Mon, 12 Jan 2026 04:54:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFTp5OSOsuyPTMRe4k38M6nE4/+Im8kgtNw0qudOBH1k9hgAUwyjKyKRD7tIQGL1L74hJziAQ==
X-Received: by 2002:a17:907:9723:b0:b87:fc5:40ba with SMTP id a640c23a62f3a-b870fc61ea2mr392025666b.20.1768222484256;
        Mon, 12 Jan 2026 04:54:44 -0800 (PST)
Received: from lbulwahn-thinkpadx1carbongen12.rmtde.csb ([2a02:810d:7e01:ef00:ff56:9b88:c93b:ed43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8706c2604bsm497062466b.16.2026.01.12.04.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 04:54:43 -0800 (PST)
From: Lukas Bulwahn <lbulwahn@redhat.com>
X-Google-Original-From: Lukas Bulwahn <lukas.bulwahn@redhat.com>
To: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	David Ahern <dsahern@kernel.org>,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	linux-riscv@lists.infradead.org,
	linux-m68k@lists.linux-m68k.org,
	linux-s390@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lukas Bulwahn <lukas.bulwahn@redhat.com>
Subject: [RFC PATCH 1/5] net: make configs NF_LOG_{ARP,IPV4,IPV6} transitional
Date: Mon, 12 Jan 2026 13:54:27 +0100
Message-ID: <20260112125432.61218-2-lukas.bulwahn@redhat.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260112125432.61218-1-lukas.bulwahn@redhat.com>
References: <20260112125432.61218-1-lukas.bulwahn@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lukas Bulwahn <lukas.bulwahn@redhat.com>

Commit db3187ae21bb ("netfilter: nf_log_ipv4: rename to nf_log_syslog"),
commit f5466caab9a8 ("netfilter: nf_log_ipv6: merge with nf_log_syslog")
and commit f11d61e7957d ("netfilter: nf_log_arp: merge with nf_log_syslog")
deprecate the config options NF_LOG_ARP, NF_LOG_IPV4, and NF_LOG_IPV6 in
March 2021. Its corresponding functionality is provided by enabling the
config option NF_LOG_SYSLOG instead. To allow older kernel configuration to
still function, the deprecated config options are not removed but select
the new config option.

With the recent addition of the transitional attribute for config options
in commit f9afce4f32e9 ("kconfig: Add transitional symbol attribute for
migration support"), deprecated config options can be marked transitional,
and new options can be set by defaulting to the deprecated option.

So, turn NF_LOG_ARP, NF_LOG_IPV4, and NF_LOG_IPV6 into transitional config
options.

Note that transitional config options cannot have any dependencies, so the
config definitions are moved to the end of the net/Kconfig file to have no
implicit dependencies.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>
---
 net/Kconfig                | 21 +++++++++++++++++++++
 net/ipv4/netfilter/Kconfig | 16 ----------------
 net/ipv6/netfilter/Kconfig |  8 --------
 net/netfilter/Kconfig      |  1 +
 4 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/net/Kconfig b/net/Kconfig
index 62266eaf0e95..5bb1b98e8023 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -544,3 +544,24 @@ config NET_TEST
 	  If unsure, say N.
 
 endif   # if NET
+
+config NF_LOG_ARP
+	tristate
+	transitional
+	help
+	  This is a backwards-compat option for the user's convenience
+	  (e.g. when running oldconfig) to transition to NF_LOG_SYSLOG.
+
+config NF_LOG_IPV4
+	tristate
+	transitional
+	help
+	  This is a backwards-compat option for the user's convenience
+	  (e.g. when running oldconfig) to transition to NF_LOG_SYSLOG.
+
+config NF_LOG_IPV6
+	tristate
+	transitional
+	help
+	  This is a backwards-compat option for the user's convenience
+	  (e.g. when running oldconfig) to transition to NF_LOG_SYSLOG.
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 7dc9772fe2d8..dfe29cedcc2c 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -76,22 +76,6 @@ config NF_DUP_IPV4
 	  This option enables the nf_dup_ipv4 core, which duplicates an IPv4
 	  packet to be rerouted to another destination.
 
-config NF_LOG_ARP
-	tristate "ARP packet logging"
-	default m if NETFILTER_ADVANCED=n
-	select NF_LOG_SYSLOG
-	help
-	This is a backwards-compat option for the user's convenience
-	(e.g. when running oldconfig). It selects CONFIG_NF_LOG_SYSLOG.
-
-config NF_LOG_IPV4
-	tristate "IPv4 packet logging"
-	default m if NETFILTER_ADVANCED=n
-	select NF_LOG_SYSLOG
-	help
-	This is a backwards-compat option for the user's convenience
-	(e.g. when running oldconfig). It selects CONFIG_NF_LOG_SYSLOG.
-
 config NF_REJECT_IPV4
 	tristate "IPv4 packet rejection"
 	default m if NETFILTER_ADVANCED=n
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 81daf82ddc2d..60cf6269523c 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -69,14 +69,6 @@ config NF_REJECT_IPV6
 	tristate "IPv6 packet rejection"
 	default m if NETFILTER_ADVANCED=n
 
-config NF_LOG_IPV6
-	tristate "IPv6 packet logging"
-	default m if NETFILTER_ADVANCED=n
-	select NF_LOG_SYSLOG
-	help
-	  This is a backwards-compat option for the user's convenience
-	  (e.g. when running oldconfig). It selects CONFIG_NF_LOG_SYSLOG.
-
 config IP6_NF_IPTABLES
 	tristate "IP6 tables support (required for filtering)"
 	depends on INET && IPV6
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 6cdc994fdc8a..c7f9fcaf6028 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -98,6 +98,7 @@ config NF_CONNTRACK
 config NF_LOG_SYSLOG
 	tristate "Syslog packet logging"
 	default m if NETFILTER_ADVANCED=n
+	default NF_LOG_ARP || NF_LOG_IPV4 || NF_LOG_IPV6
 	help
 	  This option enable support for packet logging via syslog.
 	  It supports IPv4, IPV6, ARP and common transport protocols such
-- 
2.52.0

