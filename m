Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612DE16C6AF
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Apr 2024 14:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713452282; cv=none; b=Yds/v1/4DdUCOdWJ3hQFVV7XIGzMAu+15I8P2nTXFlAz3kHqfd1eLQKxPsj0oht7it4qalUva1U7RVA0dWzCKYCt4vKX/2gfIxLHlNkG1NJQDllmAGqW3jt9HPU5u1fTqdR8TrKu94PRyGwJp7lsqj9ghIcjlzqI9OC8RSYRotw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713452282; c=relaxed/simple;
	bh=XnWJOnILBcBRDeU1BqBLAtGDVWZ7R54SvcYt0DpJjys=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TU+G26rbvjJmxAA1jnleO8NDhErTu6tkhcPVcFc5baxI3X5g9lgKystagUJ4PhF7NxHxpAoJzTDavUTXxDQHFKivyJeY8/gn5jjuxzFo2/T1a06yAXsoohUP5bSly5FX3KNjyiRSDdTS3zmGyx8H6jE1sKc8DJ82EmtXBNLIWfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=BAT8MIoK; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="BAT8MIoK"
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 7123F4061D
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Apr 2024 14:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1713452272;
	bh=TPzhJ3AAYaNuKmuKpflVm92Wqe6tHXbtl8g4S4zlOco=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
	b=BAT8MIoKlopi90CacwOQVPh0v/pBJBYgIWvrP5qRLoZbLA2NqWDQHgyvXwiI8UEMW
	 boJDhO6wVH6BH7mzp8Ow73Im10o8w+rMrgerZmcKTcYFIJDBknvCST6yCW3mHRykZM
	 0BizvkRbPrM9H3XgXAf0ilFPS46mONPfyCS+QVy70t7LQzYpqFhwkCIYqwPoj9oT3h
	 1YhQ0DXnF0rC3nmN1v3u5PyDfTA4r0v2m9wb/Quo2487xqk3uaBRR+SbHUfqAesfn7
	 CEK/p7Db17pH0wwod0eVQHbuvDuv06EdP+R+fBKJnM1d40nWBWmqwQz27d6lQBW7L1
	 9SCG5jpPRdd2w==
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a5569434b26so58441966b.0
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Apr 2024 07:57:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713452271; x=1714057071;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TPzhJ3AAYaNuKmuKpflVm92Wqe6tHXbtl8g4S4zlOco=;
        b=CuR4yTO02XpbimaYzy9LHFabCwm0Kk7uLl124KehMVuruTgftYo9FJ/pw5BYkjzC99
         YqO7vLIM5PtIisKGhoGikqB4Nq7vPWi78uuA9v8XSCmFwHPlDwHx91QvlYu28eFjFJOE
         zdwmP6XQfz7dFyzhlpk4TTiGbJnWIyopqrGtHO3EhU4MOEhCe71ADF51voVIK5Sz1rKp
         KCPX6FDMvYG4PgtKynYT3tygGl6aXFjkBn17ybXdaBZq93YOKN0ZiaGg2YvS1m4a2Yds
         8HV27n6hPs9lPWQYVWasVKQv2FlJTRTvQAu1TUnCwXfKGoOeTzVeBw+JYgSfQVW2hPf+
         aDuw==
X-Forwarded-Encrypted: i=1; AJvYcCW1vFin6iZAU7OauX9WbEpnQfTK23jIFS9BZZbjavi9vuKCtzmy5ggTPXx2dXP1NoBUK+sJ+rGsnhty4vYqVgJIUj6YatAiwGRn3oTKfmsC
X-Gm-Message-State: AOJu0Yz9jzpVFaZDobxPSTf3nKyna9krbfujyFYH6O5jfcI/vhKj34Tj
	V8KzdYqUrPC3a2zSz6bp+eo22oPuzUe5aa24yytsow3gBqpWHwg2cAPK5YRaHu3uhvFtOWHzQL+
	H1sy8EQvajRm7IgkWJHiwunpJ+/oqMdGXT1VhDo5BM6MWsc2JBX/Xx0uVm2E9FGEzruWGzA6CbH
	BrzJsy3g==
X-Received: by 2002:a17:906:1182:b0:a52:58a7:11d1 with SMTP id n2-20020a170906118200b00a5258a711d1mr1836770eja.38.1713452271345;
        Thu, 18 Apr 2024 07:57:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFhzDZOsSyjW2YgiF+3b9SbPzp6uVKID7mT1Wura27dE1HKH8MQkcJys3WmmEXVTnVSN92wWQ==
X-Received: by 2002:a17:906:1182:b0:a52:58a7:11d1 with SMTP id n2-20020a170906118200b00a5258a711d1mr1836755eja.38.1713452271043;
        Thu, 18 Apr 2024 07:57:51 -0700 (PDT)
Received: from amikhalitsyn.lan ([2001:470:6d:781:320c:9c91:fb97:fbfc])
        by smtp.gmail.com with ESMTPSA id jj17-20020a170907985100b00a522a073a64sm993665ejc.187.2024.04.18.07.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Apr 2024 07:57:50 -0700 (PDT)
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
Subject: [PATCH net-next v3 1/2] ipvs: add READ_ONCE barrier for ipvs->sysctl_amemthresh
Date: Thu, 18 Apr 2024 16:57:42 +0200
Message-Id: <20240418145743.248109-1-aleksandr.mikhalitsyn@canonical.com>
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
index 143a341bbc0a..32be24f0d4e4 100644
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

