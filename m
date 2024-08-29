Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9739A1B654D;
	Thu, 29 Aug 2024 16:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724948233; cv=none; b=LjW5pD5ZQxCSz9/o3vz1jMNLol1qMKXZwO3trjLirxNsSz3LZ8HjErlUFuz6rHqsxWwiBt0DDkNl3IdV0eRxbE/GZkmTeajezCtAl/vcioVJVBnqyCVKbthHodPrGf86KUjQuESaGcHAuX3wPYhT6/MbJB0IxldYQiK8TezrjE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724948233; c=relaxed/simple;
	bh=tiajQYn9nsePlqD4415CMV+9WOMc1VSANwqYlFxVtUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=os+y2R69hPPzJILQtvy4WGjuj2m/8PHcWMfa8balsN+cyqdqLnynrCygztBbDWaTe91h0XEhhOV6mXRKrBjtfsrzFG5TB7a6y8P89jGb0QwbIHh23avQs6nCWxp/QS6qZWcunIgeWBSxqrq7QorZAPdHKo66vBo0V9vcSzlkFJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5bed72ff443so1054441a12.1;
        Thu, 29 Aug 2024 09:17:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724948230; x=1725553030;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i4tTQIMCvK8JaDCUUSonRDoAPxJVCvvDpjeKG9dSjwU=;
        b=wr7VH12CmxDuo4YBvXTynAr89rzdsH0CVe3DdMvsNC6lULHali7QMaWGJMkUTfRJrT
         7zB/yiiNOdFGwy9CySICwl9yIoQ5kSXS50N2r3ETN5RD7t6E9h3UKgPLf4q5xCCzHWW8
         023H6cBkwKbd0xf01639wVewbMnHemhV7TTaESglcCsTFgrjUWFCWhhBvPIjqi2zTUwt
         BJ9aU+qjVMKuUDXwr7FpNJl0NgTjxYFRdbPSg94pjdk9lTMv7+eJfvF6sXpi6YMwe6nq
         SibIPS++rWy7LRLfnATXzj1AUycH+0ntbHgBn1UlfWoeLFnTPOFCLgtLNjrCaoRDw58l
         sNyQ==
X-Forwarded-Encrypted: i=1; AJvYcCUB4pbzGqWN5iup7KjiCuaRRMvexYFKQCk9GfPaFotrFu9o6vqyc5dL9bh+kKlswa0qsGLsuyuHOUZ5AKQ=@vger.kernel.org, AJvYcCVXcPKQq3Rbc4VM1BCZDimpT5dkebGw03zmdzf6qvL2X4PavMvzdvFjlJQgVz4TuGMCrF7l3z5TtVw0RlWAKO2W@vger.kernel.org, AJvYcCXR6vo38w6v2/8Om5nylc0AsFv32KVKhbe/CQcTnW8X5QrQtXqUvYnkPX7COzSESUkU8Mton0SX@vger.kernel.org
X-Gm-Message-State: AOJu0YyqSNpVX1Sgj6F+9ip+Y+A3rgCA2h2Cl0uoH3RYNZJHjoWGTsjZ
	vYzFpUGxcpW1GtZKJqawJMYyw4uJNVwHVl02myfqxjjLszx2coSF
X-Google-Smtp-Source: AGHT+IF3lPqELwq5st4WQCl0HD/aCaayvrDgmEklE4DTN8jPOXGQRz1na1bRSeVbktGDwZM+2psK3Q==
X-Received: by 2002:a17:907:7f25:b0:a86:8166:1b0a with SMTP id a640c23a62f3a-a897fad100dmr303802666b.56.1724948229273;
        Thu, 29 Aug 2024 09:17:09 -0700 (PDT)
Received: from localhost (fwdproxy-lla-116.fbsv.net. [2a03:2880:30ff:74::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8988feb112sm96683466b.39.2024.08.29.09.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2024 09:17:08 -0700 (PDT)
From: Breno Leitao <leitao@debian.org>
To: fw@strlen.de,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	David Ahern <dsahern@kernel.org>
Cc: rbc@meta.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org (open list:NETFILTER)
Subject: [PATCH nf-next v4 2/2] netfilter: Make IP_NF_IPTABLES_LEGACY selectable
Date: Thu, 29 Aug 2024 09:16:55 -0700
Message-ID: <20240829161656.832208-3-leitao@debian.org>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20240829161656.832208-1-leitao@debian.org>
References: <20240829161656.832208-1-leitao@debian.org>
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

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 net/ipv4/netfilter/Kconfig | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 1b991b889506..16507ae13736 100644
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
-- 
2.43.5

