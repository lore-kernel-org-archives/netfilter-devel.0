Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE671B6535;
	Thu, 29 Aug 2024 16:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724948231; cv=none; b=kLsmTxR6hZCA+tCEFsnCYFU8OCrLU2TJljMkWt8v3AjQnvjnl+9YEVx7t8D43DOyG8WbNXp3JFCUSs2G/QfAE1Di9P12A++6JMI5YhUhg3XkQH1eJBaFGvoj1D1COmbIt4Yk67JL3ngUv977W1AlzXSNGxC1ri+612JX2QgRuJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724948231; c=relaxed/simple;
	bh=irLUQ4gbeTJd62aAXuvP5vhYeXx4WQ1xX/5+JoSGrU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RkGW5YDVvkTiGMj+E1yFpuT5YJDOl4on2kOfkdd8WVLU6SH6+db97NUNnVrmNgnMn6WmXoiqIm85kjD8HNk0Rx2dlsH2/vvAqXryzYQL+c3IjAYIonsrLWz6zD/yy30UUu/hKI3wHQAguCq24cLEjYybpinpYqxfu/4THDI/9IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2f029e9c9cfso9923031fa.2;
        Thu, 29 Aug 2024 09:17:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724948228; x=1725553028;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qkan8LeGRBctmqDZP0OyBITGW6dkD5hNUPXowO4Cr6E=;
        b=Qr7FVBYdgY8SPJshO6yDw9lZy4ous3lk5gmK/cTzBKSo5e0h/Olu9pwC6csQrcURqm
         CNgLoHe7qzsIewFjmnvJwlxY7GYrgdzoFWqevNss3s/QC5gqTXt/Xi6+ZOHXmLjJj0wb
         EKHfppW6HdATCnCmkFX81NP4x/kOqw6emeQz9XA7W6NWo24vEJEhXXtDfvTxq8eXkQGU
         70S0zS4+HVmXPn5FOmykEjOpRakEzCNrVGxEBb6a4R/ai/FStPYK70qLJ6vNTQSas1fv
         2Em3Ke3ehOd3dfB85A6PoOx4gdggTPSpC1noGGdHMazQcOq73mD+SeJlxBFfzVjWVzQF
         4jkQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1C22W17xsiZvY414GQxAfnHhPZUMjif6DRvFhcfEBwJmXcnAjUZ0RuOgomZUNTgl36ViDZvcvxlXhSDs=@vger.kernel.org, AJvYcCVaFeiLICOlyNXK5dYCa9FOlZZCUX7jOEQoudDm73p1gcCytpmvTtlW70c6Yj7P7DoCj/Ma2Uqb@vger.kernel.org, AJvYcCXKeOxp3foOFGjj+tJ09b4oDucXe5hgQOzq1Vkl7AA8DBHGyR4XIdMHeilt3VUkTaSYG2IewWyRpQS47SZJDCuh@vger.kernel.org
X-Gm-Message-State: AOJu0YwvGmFZT8L6I/yX6Nh7v/vtcCGC3AJrDsjD9KKkN8oCXBgkPv9I
	Fsuxxs0uzU2mzjxHSwZY5B8np5P9SA20gPg12MW0tR3yEgtLhAil
X-Google-Smtp-Source: AGHT+IHPgeRnaKZDSFySv1PLJDT9l2yECzfEsYxeTwNaLrM3Rf8uebtotADgxJlxJqRPMk0cyi4SMg==
X-Received: by 2002:a05:651c:b20:b0:2ec:4093:ec7 with SMTP id 38308e7fff4ca-2f6108937e3mr29152661fa.30.1724948227166;
        Thu, 29 Aug 2024 09:17:07 -0700 (PDT)
Received: from localhost (fwdproxy-lla-013.fbsv.net. [2a03:2880:30ff:d::face:b00c])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c226c72d40sm862319a12.31.2024.08.29.09.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2024 09:17:06 -0700 (PDT)
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
Subject: [PATCH nf-next v4 1/2] netfilter: Make IP6_NF_IPTABLES_LEGACY selectable
Date: Thu, 29 Aug 2024 09:16:54 -0700
Message-ID: <20240829161656.832208-2-leitao@debian.org>
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

This option makes IP6_NF_IPTABLES_LEGACY user selectable, giving
users the option to configure iptables without enabling any other
config.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 net/ipv6/netfilter/Kconfig | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index f3c8e2d918e1..cbe88cc5b897 100644
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
-- 
2.43.5

