Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D01F46BA0;
	Wed, 21 Feb 2024 11:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708515028; cv=none; b=QiE+8xSXWgxdRxbge5a7iy35XG52ukWRvL9T0u+yrp98qcM5EgE2vJ0Ca8I9Ki7FAyRblWo0PzqLABd+njo10Q8SGV8sGHLAB7eE9cTSkE11QjG1JwjYbQvUSrR92SuCAS61SOSFE//iDeS1s5AQsTmiMAu5i6UdllxPoRo6Yjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708515028; c=relaxed/simple;
	bh=kk/YmLYwpFj1XkvDyAbSSRxNFtibe4c4yxnIs0kOqjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JcUD8RaqqjX7WGxlQs1fxP12t2aI0dTUJYesLqgT3UShhCb3uwlYPoqURp0QG/cED92h/csv4ddeKleTffRCFFYjXBeX+9PxIHIsa+svk4b5peGMOlpaLxWBpftOQIxZOww3QqSfYEtJF/Azb3oR55U4gEhNLe2U5t3j3CruQaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rcknu-0003vi-RH; Wed, 21 Feb 2024 12:30:22 +0100
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Simon Horman <horms@kernel.org>
Subject: [PATCH net-next 12/12] netfilter: x_tables: Use unsafe_memcpy() for 0-sized destination
Date: Wed, 21 Feb 2024 12:26:14 +0100
Message-ID: <20240221112637.5396-13-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240221112637.5396-1-fw@strlen.de>
References: <20240221112637.5396-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kees Cook <keescook@chromium.org>

The struct xt_entry_target fake flexible array has not be converted to a
true flexible array, which is mainly blocked by it being both UAPI and
used in the middle of other structures. In order to properly check for
0-sized destinations in memcpy(), an exception must be made for the one
place where it is still a destination. Since memcpy() was already
skipping checks for 0-sized destinations, using unsafe_memcpy() is no
change in behavior.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/x_tables.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 21624d68314f..da5d929c7c85 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1142,7 +1142,8 @@ void xt_compat_target_from_user(struct xt_entry_target *t, void **dstptr,
 	if (target->compat_from_user)
 		target->compat_from_user(t->data, ct->data);
 	else
-		memcpy(t->data, ct->data, tsize - sizeof(*ct));
+		unsafe_memcpy(t->data, ct->data, tsize - sizeof(*ct),
+			      /* UAPI 0-sized destination */);
 
 	tsize += off;
 	t->u.user.target_size = tsize;
-- 
2.43.0

