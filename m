Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093DC3254AD;
	Tue, 16 Dec 2025 19:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765912159; cv=none; b=tsuSUmIWRObNd1yMX6SDmndns5hvQ4LdTfr9/0m+RN9aEo1C9NdFJMV+qHigIq1uXCELVPH3Tvv99BQGsvgxGk3IsJUur74rd38o91sArngupri/i/OpzQJf6cjPccKoGIKOu9zUMgUX70JZgkzcn8k10Qx99tqLAsO9NrfB1rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765912159; c=relaxed/simple;
	bh=u9GALgD9nvWi6loeUSirYofvtN84gJ7HLjbHSnP4Um8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RAbFPGUSsnKd0RplpC8ZHbm2LVxnA/ppFZ7xH8CWuDfEHs+iGLEQ0e7fjmS3tR+53obcsMhhSJlqDa+nhSbBR+d9E/TEK7IQDFsfBH0giL8wliMNLdFwsXcXs4dcDVrJAktNVJtfFWDmxY7gRKMGyou5Li1YUD8k8POA5Zzro/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 37528605E6; Tue, 16 Dec 2025 20:09:13 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 1/6] MAINTAINERS: Remove Jozsef Kadlecsik from MAINTAINERS file
Date: Tue, 16 Dec 2025 20:08:59 +0100
Message-ID: <20251216190904.14507-2-fw@strlen.de>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251216190904.14507-1-fw@strlen.de>
References: <20251216190904.14507-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jozsef Kadlecsik <kadlec@netfilter.org>

I'm retiring from maintaining netfilter. I'll still keep an
eye on ipset and respond to anything related to it.

Thank you!

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 CREDITS     | 1 +
 MAINTAINERS | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/CREDITS b/CREDITS
index fa5397f4ebcd..cb9b2d6184d0 100644
--- a/CREDITS
+++ b/CREDITS
@@ -1983,6 +1983,7 @@ D: netfilter: TCP window tracking code
 D: netfilter: raw table
 D: netfilter: iprange match
 D: netfilter: new logging interfaces
+D: netfilter: ipset
 D: netfilter: various other hacks
 S: Tata
 S: Hungary
diff --git a/MAINTAINERS b/MAINTAINERS
index e36689cd7cc7..45b22f420593 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17808,7 +17808,6 @@ F:	drivers/net/ethernet/neterion/
 
 NETFILTER
 M:	Pablo Neira Ayuso <pablo@netfilter.org>
-M:	Jozsef Kadlecsik <kadlec@netfilter.org>
 M:	Florian Westphal <fw@strlen.de>
 R:	Phil Sutter <phil@nwl.cc>
 L:	netfilter-devel@vger.kernel.org
-- 
2.51.2

