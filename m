Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07371B29B1;
	Mon,  9 Sep 2024 08:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725871593; cv=none; b=DLD+/JJygMcEx3ndHpU+9GFFM8SaTW/hVjgq21TthWRzOf73bitRJN44qs6j41W/w9AmiMdMJJXaJqPjiiGLBw+1XVcvJ4+JGJZrXvTkXgfWNcYVvTTuevuLRWo75wCplUMv2GJSEUv0+7Uz+3nIhFUJHce4yNVVckib0v7Q1T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725871593; c=relaxed/simple;
	bh=Ns2AtI8I7t5JBaUKdhe2k71dODiv3aVspAhi+vyxmRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOcuTpbk72rhfuA0QhKe/AmZKHjhRswZApUzRLaloyAkMNKNT+oHgMV3AhL3/jEBCBLlD78HP096eQ4+ktX0wIN9WQ+7hvg+RGofOFLTDVirI8yhDh0EGITMMrEDwcws/BMZ88CeYfLhVfeXDU4KYuKWvusIy6GBd9Gim1Jet5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2f753375394so23358271fa.0;
        Mon, 09 Sep 2024 01:46:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725871589; x=1726476389;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6hIykSoM04+//185oqUh7DHYlgRnWQA9ouYKEvUWIsk=;
        b=Hs8+lGsSrL5BuwboitFRsuqVE8GcdPI+tqy4rvATFZjb5kt/41d2fa6phpl43/+hHf
         CFu6YykWXG/fBnA5XRgL9DPoBkHUH9spffGGVPDJCqsAFjuADid2WNffH/1DiL7CAsVC
         b/3GkLmmcvRQOa3EPvHsjWIgordI6ekoTs6oSkdVVNayc4uEyIb25xYb2GuKaPbrq9qk
         /I2+STftHZru6APpDPS+K19mcYS2V/cdDG9DdvLEPpD+gPImCMkE3KdQt0z2Zk4t3V19
         36OCBf8ngu+WQP6CXAmiXa5v1XWX4ATZacksN/8Eu47ZD3cjS9F2NToLgn9h6jEzbGlw
         2iyw==
X-Forwarded-Encrypted: i=1; AJvYcCUSaRPLtJpGXTYC/YFapwmSTVzgN68UtxFAXOjUaDT2m5GJdrb1Wn9lSDSo9UdJPBMH8kexx4q7mW827WM=@vger.kernel.org, AJvYcCWdnLgbrVN6zGImAw1BPA8z9tj9jjBPTomQiRHRqcMYK4ZTGggyE97MoLuvainJvnfmVpXdlOvF@vger.kernel.org, AJvYcCXAiU9htrB2P6nFbek6HHa+1SiME8xHw0eeF8yRWbbzALV3VFJ4P18NtIq3sborHrjqSE/dyWg5ETlkiIPDbQS0@vger.kernel.org
X-Gm-Message-State: AOJu0Yyw353mIwMh3xLHXCXPaur05Dubh5pvSmOMYxHToFVRitYdyhdx
	1SmyD8hvYr7cDhMZiQll1ntXGcY6HStB0wGzpFh0e85N/x57DRvL
X-Google-Smtp-Source: AGHT+IHHKVUVB3zpwnzhKx151WVBlQCwmizkZWV05LZJcBmNzi9b6/Z2JmTtjfJCy5L8iJuul8Wngw==
X-Received: by 2002:a2e:bc12:0:b0:2f0:1f06:2b43 with SMTP id 38308e7fff4ca-2f751fa9403mr40413211fa.41.1725871588250;
        Mon, 09 Sep 2024 01:46:28 -0700 (PDT)
Received: from localhost (fwdproxy-lla-114.fbsv.net. [2a03:2880:30ff:72::face:b00c])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c3ebd41cedsm2755047a12.5.2024.09.09.01.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2024 01:46:27 -0700 (PDT)
From: Breno Leitao <leitao@debian.org>
To: fw@strlen.de,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	pablo@netfilter.org,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	David Ahern <dsahern@kernel.org>
Cc: rbc@meta.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org (open list:NETFILTER)
Subject: [PATCH nf-next v5 1/2] netfilter: Make IP6_NF_IPTABLES_LEGACY selectable
Date: Mon,  9 Sep 2024 01:46:18 -0700
Message-ID: <20240909084620.3155679-2-leitao@debian.org>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20240909084620.3155679-1-leitao@debian.org>
References: <20240909084620.3155679-1-leitao@debian.org>
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
 net/ipv6/netfilter/Kconfig | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index f3c8e2d918e1..425cb7a3571b 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -8,7 +8,14 @@ menu "IPv6: Netfilter Configuration"
 
 # old sockopt interface and eval loop
 config IP6_NF_IPTABLES_LEGACY
-	tristate
+	tristate "Legacy IP6 tables support"
+	depends on INET && IPV6
+	select NETFILTER_XTABLES
+	default n
+	help
+	  ip6tables is a legacy packet classification.
+	  This is not needed if you are using iptables over nftables
+	  (iptables-nft).
 
 config NF_SOCKET_IPV6
 	tristate "IPv6 socket lookup support"
-- 
2.43.5

