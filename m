Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEF743B3E6
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jul 2026 10:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784802941; cv=none; b=AQpCLb1Px+bSVeYwEauJ9gUved/4iaPRnI6S/amvct3wwsyRGhsugchIWTjvNLTY98ALIASaNPS0F9i+3aEd1OxbSv8+qnyqJI7etOZWpN7pOmpaDAqCcn8DzpVlYoWwlmmh+2HXLfird4kM/7GCrVaifpCJ1iRAtpq3K5i4JZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784802941; c=relaxed/simple;
	bh=DY2dWhKzhpzIuDlDTxAiy6gCud/5Xv/1Jvy0D73mH88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oHCWCYfpb1WurwxAG6Dl5qWESASJeuWUnh2iABOvaimjT1GVGXwk12Mjce4D0o0R5xfQPHwpR8L2wWsw97KgUFz8iI27xXSXLu7uA0T4mqYGh7LlcIcCXs5a7QOcr6XbtB5d1QqG8hMay7RbVylYPe7QJ/P2merCfWb9mXFdFVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0968160E9D; Thu, 23 Jul 2026 12:35:36 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: kadlec@netfilter.org
Cc: <netfilter-devel@vger.kernel.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH ipset 5/5] tests: match_target.t check for proper cidr matching
Date: Thu, 23 Jul 2026 12:35:04 +0200
Message-ID: <20260723103504.3175-6-fw@strlen.de>
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

Add a test that covers CIDR matching ("multi" flag).

In ipsets CIDR-prefix loop, the multi-flag is re-set so the loop can
continue to less-specific prefixes when an element matched key+iface but
failed the counter constraint.  Without the reset, the loop stops at the
first prefix that has any non-expired element.

(The kernel patch that removed this reset was never
 merged, but add test coverage for this).

Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/match_target.t | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/tests/match_target.t b/tests/match_target.t
index c3ead171dd00..c4fc777ffdd9 100644
--- a/tests/match_target.t
+++ b/tests/match_target.t
@@ -54,7 +54,7 @@
 0 ./iptables.sh inet del
 # Send probe packet 10.255.255.64,icmp:host-prohibited
 0 ./sendip.sh -d r10 -p ipv4 -id 127.0.0.1 -is 10.255.255.64 -p icmp -ct 3 -cd 10 127.0.0.1
-# Check that 10.255.255.64,icmp:3/10 isn't in ipport
+# Check that 10.255.255.64,icmp:3/10 is not in ipport
 1 ipset test ipport 10.255.255.64,icmp:host-prohibited
 # Destroy sets and rules
 0 ./iptables.sh inet stop
@@ -118,4 +118,16 @@
 0 ipset l test |grep -q '^10.255.255.64 packets 2'
 # Destroy sets and rules
 0 ./iptables.sh inet stop
+# hash:net,iface set with counters.
+# /24 entry: low counter  -> will fail  --packets-gt 50
+# /16 entry: high counter -> would pass --packets-gt 50
+0 ipset create test hash:net,iface counters
+0 ipset add test 127.0.0.0/24,lo packets 5 bytes 500
+0 ipset add test 127.0.0.0/16,lo packets 100 bytes 10000
+# Match the set with a counter threshold of 50.
+0 iptables -A INPUT -i lo -p icmp -m set --match-set test src,src --packets-gt 50 -j ACCEPT
+0 ping -c 1 -W 1 127.0.0.1 > /dev/null 2>&1
+# Check whether the iptables rule matched.
+0 (set -e; pkts=$(iptables -v -n -L INPUT | grep test | awk '{print $1}') ; [ "${pkts:-0}" -ge 1 ] && exit 0 )
+0 ./iptables.sh inet stop
 # eof
-- 
2.54.0

