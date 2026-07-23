Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4594322E8
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jul 2026 10:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784802937; cv=none; b=dwEVvVbSLKZUSVpkt0MeJfSv+mun5XggzeRq9ibWcIqaEB3XLsjGV0e1ny/3rHZeO9MuYTkva/33jHnnQazICtvBuOAeJ3EgvUc6RigGaWWO7bKJgrDzQhKkCtjwynL/Nv7EKNQ/noSyxpEl4bY/xOMzeQS6TQcJI8n+NytL6ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784802937; c=relaxed/simple;
	bh=LjqfEWSV0IJM+St2RhAj9ce4P92S72BzDfRRV7L9Eh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gkgf9A/lI1OLcuR64XlnlsUAyheO31133OaRPgT3c83b3j0ZaLsmOMmsQjXGKE0gBTKvuUpUC8LpIaPtCYZudVg8uQkN93Dl/hDnjYml5BhYYqKGbUxqyCc7Ut9D9vop8dzmG8QosHtK5x8MUTXfew6CRkaFcy6iXhjNHpX+8lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B831F60E86; Thu, 23 Jul 2026 12:35:31 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: kadlec@netfilter.org
Cc: <netfilter-devel@vger.kernel.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH ipset 4/5] tests: hash:net,iface.t: add reproducer for UaF
Date: Thu, 23 Jul 2026 12:35:03 +0200
Message-ID: <20260723103504.3175-5-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260723103504.3175-1-fw@strlen.de>
References: <20260723103504.3175-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A faulty (never merged) kernel patch for ipset had a use-after-free
where an element was free'd without unlinking it from the table, yet
the faulty kernel passed all tests.  Check that we don't free
non-matching elements, the request to delete is for non-existing
element, no free must happen and the command must fail.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/hash:net,iface.t | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tests/hash:net,iface.t b/tests/hash:net,iface.t
index bcd0ba451c62..556d56df5c4b 100644
--- a/tests/hash:net,iface.t
+++ b/tests/hash:net,iface.t
@@ -228,6 +228,11 @@
 0 ipset -! a test 2.0.0.20/25,wlan0 timeout 700
 # Counters and timeout: check counters
 0 ./check_extensions test 2.0.0.0/25,wlan0 700 13 12479
+0 ipset flush test
+0 ipset add test 10.0.1.0/24,eth0
+1 ( for i in $(seq 1 10000); do ipset del test 10.0.1.0/24,eth1 ; done )
+0 ipset t test 10.0.1.0/24,eth0
+0 ipset list
 # Counters and timeout: destroy set
 0 ipset x test
 # eof
-- 
2.54.0

