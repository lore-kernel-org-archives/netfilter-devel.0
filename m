Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AA621B95B
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 15:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728747012; cv=none; b=VQSvW97lnk6h4F+DRugUIw0nHj2zlP3pPSrY1V7B6BNan+l90ktNOzGdnqt1qUD5NFGUKezOsWvgmJ4ONorjfuOfbR5dihgYGdsPV6eRkzIL1k2uLUydyDmfQIYOwfANxH7HpeSjiVXXIGwc4sSrEGN09bmHe1zY60FyL0VhVY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728747012; c=relaxed/simple;
	bh=bUp3gp7A+XHgeQeFEIUO+EKCkmOSnQQUjHJiG9MU9Lk=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B0ekyi+nWBMvMz6/G1tXFmTIw19+9lAuSaC8AklDfAXK9rvz1fstv8U5jrhlMgAu80o9iRZRejWE9O4MvH9kgGCyap0CRSbSSb/f5zWPyAL3OitEqCvZW5LXZIoCC1zKCgs7glAq+Yc5OhFHHubG7nrjKSYEcadRImIFQGVPMLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack 3/3] tests: conntrack: missing space before option
Date: Sat, 12 Oct 2024 17:29:57 +0200
Message-Id: <20241012152957.30724-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241012152957.30724-1-pablo@netfilter.org>
References: <20241012152957.30724-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Recent updates make the conntrack parser slightly more robust. A few
test lines include:

... -w 11-s 2001:DB8::1.1.1.1 ...

where space is missing. These are typos rather than valid input.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/conntrack/testsuite/09dumpopt | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tests/conntrack/testsuite/09dumpopt b/tests/conntrack/testsuite/09dumpopt
index c1e0e6ed376d..9dcd51f81638 100644
--- a/tests/conntrack/testsuite/09dumpopt
+++ b/tests/conntrack/testsuite/09dumpopt
@@ -25,7 +25,7 @@
 # delete reverse
 -D -w 11 -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 ; OK
 # delete v6 conntrack
--D -w 11-s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 ; OK
+-D -w 11 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 ; OK
 # delete icmp ping request entry
 -D -w 11 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; OK
 # delete old entries
@@ -33,7 +33,7 @@
 # delete reverse
 -D -w 10 -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 ; OK
 # delete v6 conntrack
--D -w 10-s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 ; OK
+-D -w 10 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 ; OK
 # delete icmp ping request entry
 -D -w 10 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; OK
 #
@@ -64,7 +64,7 @@
 # delete reverse
 -D -w 11 -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 ; OK
 # delete v6 conntrack
--D -w 11-s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 ; OK
+-D -w 11 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 ; OK
 # delete icmp ping request entry
 -D -w 11 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; OK
 # delete old entries
@@ -72,7 +72,7 @@
 # delete reverse
 -D -w 10 -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 ; BAD
 # delete v6 conntrack
--D -w 10-s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 ; BAD
+-D -w 10 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 ; BAD
 # delete icmp ping request entry
 -D -w 10 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; BAD
 #
@@ -161,13 +161,13 @@
 # IGMP
 -D -w 10 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 2 ; OK
 # Some fency protocol
--D -w 10  -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 200 ; OK
+-D -w 10 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 200 ; OK
 # Some fency protocol with IPv6
 -D -w 10 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p 200 ; OK
 # Delete stuff in zone 11, should succeed
 # IGMP
 -D -w 11 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 2 ; OK
 # Some fency protocol
--D -w 11  -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 200 ; OK
+-D -w 11 -s 0.0.0.0 -d 224.0.0.22 -r 224.0.0.22 -q 0.0.0.0 -p 200 ; OK
 # Some fency protocol with IPv6
 -D -w 11 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p 200 ; OK
-- 
2.30.2

