Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC672D0C76;
	Wed, 10 Sep 2025 19:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757531026; cv=none; b=MfMlfuE1hQENg2f/GGQ+3WoQgBHgPUhfrpd8BASPU0ZxC5O55dMuT7QVmXY8uwgRgKrrwkfNhTvmKmGiGuYd/BFVIu+QLU9ie+Is4JpS0R5CK+J8G+LSRilXgwCD5fjmxczrNRaZ6ehSsuaT7MlyxgoxMN5lJzF3Mgs/YOk5DOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757531026; c=relaxed/simple;
	bh=RjgSDV1NvNS2PoIZba8WRPPOwfsKxEUUvM31LKy6Mpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q3Nv54OorheHXHlVFJUs/QSe8YWMTfVCzVAV+s+UDPMQdqhYdnXlGFguU5dgboOJz6ttUMTKs00OJc/MpdzoFBPlGbs6DhJv+1aUwrZOVy2a5m4bxOvD0y1X8ge2+YzdO0vy7LfFjLZlsscF79NZ0BigKFRGycx0xTSaeMSi3VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3D6816061A; Wed, 10 Sep 2025 21:03:43 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 7/7] MAINTAINERS: add Phil as netfilter reviewer
Date: Wed, 10 Sep 2025 21:03:08 +0200
Message-ID: <20250910190308.13356-8-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250910190308.13356-1-fw@strlen.de>
References: <20250910190308.13356-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Phil has contributed to netfilter with features, fixes and patch reviews
for a long time.  Make this more formal and add Reviewer tag.

Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2df02e4374ed..ba11421c33e5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17480,6 +17480,7 @@ NETFILTER
 M:	Pablo Neira Ayuso <pablo@netfilter.org>
 M:	Jozsef Kadlecsik <kadlec@netfilter.org>
 M:	Florian Westphal <fw@strlen.de>
+R:	Phil Sutter <phil@nwl.cc>
 L:	netfilter-devel@vger.kernel.org
 L:	coreteam@netfilter.org
 S:	Maintained
-- 
2.49.1

