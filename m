Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76FC4291C3F;
	Thu, 17 Jul 2025 09:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752745901; cv=none; b=FZ5toWPqQIfY9Rj80vnOOwZ6jMDFmRhjRWh4/p78MjPGoAIgPgOl78rqMisG9uEEUKTiDaQwhgzvH2TCtLIhzMaFLFZi3aigEbgKtEYZvlgx20HN0OucVX+iNfWaFeyeRPm3PlhXsUMDjInL2pEJ+ULJq2aC9jMzPS3372Rdw+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752745901; c=relaxed/simple;
	bh=Si75dH7/wWeMzUUDSP78FvPaBx0UILlIk3S9CrM1eds=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kVtME7MKoCa1o294TYx8xikP2XlQue2sNyJpO/9jGoC68dF5G3Q9hZC/mmS8nXPZJe0JFCwAUWIzJTlRUrTocKMy8eLwasqbNIwzjpQzd53HecjoApRu49jccGfIT36Z/xJ8aO6/fnoT7DejWYiB1eKJVgeMwOO6dC8sEjbOkZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=LUl65uLE; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=NYt/3L9w; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="LUl65uLE";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="NYt/3L9w"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id D2A30602AE; Thu, 17 Jul 2025 11:51:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752745889;
	bh=K4XVAzVpKwjFPII5onfGMrwnJkfaSd6M0PgmfWU5LUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LUl65uLE1OUS/fLvz2rKAyYopdLLrW7F2ZYxhU6pb4qHIJQGdmj8c3h2BTsSKx/3u
	 P9aIg9GMFYzolSJm/mihrsgFEjdb2FlqoZN0W+MIgPRToWod2fMFi8kPVy3a/sKOcs
	 GTxoI39vGUVutMgjUZQ0Kt6Fm0px5RbNW5sF7JJeNHHM7/h0tO2l9sHRv560Kvkg45
	 nuo0EPDNxLMYnoKJvi0lfCkNhADw9mAmNex9NVcrluV73uXCl8wQAb2Jx1AfOJHQ9W
	 Nlppgh18anx0vXO7TrhiXiVQZ6CzQbKGuq1f3qdUgNlzH/C3g/4pEvkQb99wQQEgsy
	 LooOFeeNfkIJA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BF3D0602B2;
	Thu, 17 Jul 2025 11:51:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752745888;
	bh=K4XVAzVpKwjFPII5onfGMrwnJkfaSd6M0PgmfWU5LUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NYt/3L9w9usiCYUSTh2Nsy13JJnJ7u+9UGKzX5oTZ2SLhungbhkOJK5DPavD/mOvC
	 NLwgG/hAzYfMl4sajfNOx6zEAff/TnUUo04Pc4piuKeyGN7v3xKFWExBex6iWbWzGH
	 Nms5ZQpWNZ55KLFfefEZRqlTKSH0uUuTnaGEDpTwEe8p4LGkgI0/boMfQYQmPZAWiR
	 LgDZfEHI7rc8IQ7gyhyJX2v8l2yUY6fNf3l5PXYI0RZFen9J6XxQ/kK7wwpM6tyN2D
	 5SehYZoBvfmq0P7bhWaHi5F3yq6VxsKsEd9h+2sF1NGD93hCmn9RIzxyg4z2ANeu/s
	 JPix+tFdXtg6g==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 1/7] selftests: netfilter: conntrack_resize.sh: extend resize test
Date: Thu, 17 Jul 2025 11:51:16 +0200
Message-Id: <20250717095122.32086-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250717095122.32086-1-pablo@netfilter.org>
References: <20250717095122.32086-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Extend the resize test:
 - continuously dump table both via /proc and ctnetlink interfaces while
   table is resized in a loop.
 - if socat is available, send udp packets in additon to ping requests.
 - increase/decrease the icmp and udp timeouts while resizes are happening.
   This makes sure we also exercise the 'ct has expired' check that happens
   on conntrack lookup.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../net/netfilter/conntrack_resize.sh         | 80 +++++++++++++++++--
 1 file changed, 75 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/conntrack_resize.sh b/tools/testing/selftests/net/netfilter/conntrack_resize.sh
index 9e033e80219e..aa1ba07eaf50 100755
--- a/tools/testing/selftests/net/netfilter/conntrack_resize.sh
+++ b/tools/testing/selftests/net/netfilter/conntrack_resize.sh
@@ -12,6 +12,9 @@ tmpfile=""
 tmpfile_proc=""
 tmpfile_uniq=""
 ret=0
+have_socat=0
+
+socat -h > /dev/null && have_socat=1
 
 insert_count=2000
 [ "$KSFT_MACHINE_SLOW" = "yes" ] && insert_count=400
@@ -123,7 +126,7 @@ ctflush() {
         done
 }
 
-ctflood()
+ct_pingflood()
 {
 	local ns="$1"
 	local duration="$2"
@@ -152,6 +155,28 @@ ctflood()
 	wait
 }
 
+ct_udpflood()
+{
+	local ns="$1"
+	local duration="$2"
+	local now=$(date +%s)
+	local end=$((now + duration))
+
+	[ $have_socat -ne "1" ] && return
+
+        while [ $now -lt $end ]; do
+ip netns exec "$ns" bash<<"EOF"
+	for i in $(seq 1 100);do
+		dport=$(((RANDOM%65536)+1))
+
+		echo bar | socat -u STDIN UDP:"127.0.0.1:$dport" &
+	done > /dev/null 2>&1
+	wait
+EOF
+		now=$(date +%s)
+	done
+}
+
 # dump to /dev/null.  We don't want dumps to cause infinite loops
 # or use-after-free even when conntrack table is altered while dumps
 # are in progress.
@@ -169,6 +194,48 @@ ct_nulldump()
 	wait
 }
 
+ct_nulldump_loop()
+{
+	local ns="$1"
+	local duration="$2"
+	local now=$(date +%s)
+	local end=$((now + duration))
+
+        while [ $now -lt $end ]; do
+		ct_nulldump "$ns"
+		sleep $((RANDOM%2))
+		now=$(date +%s)
+	done
+}
+
+change_timeouts()
+{
+	local ns="$1"
+	local r1=$((RANDOM%2))
+	local r2=$((RANDOM%2))
+
+	[ "$r1" -eq 1 ] && ip netns exec "$ns" sysctl -q net.netfilter.nf_conntrack_icmp_timeout=$((RANDOM%5))
+	[ "$r2" -eq 1 ] && ip netns exec "$ns" sysctl -q net.netfilter.nf_conntrack_udp_timeout=$((RANDOM%5))
+}
+
+ct_change_timeouts_loop()
+{
+	local ns="$1"
+	local duration="$2"
+	local now=$(date +%s)
+	local end=$((now + duration))
+
+        while [ $now -lt $end ]; do
+		change_timeouts "$ns"
+		sleep $((RANDOM%2))
+		now=$(date +%s)
+	done
+
+	# restore defaults
+	ip netns exec "$ns" sysctl -q net.netfilter.nf_conntrack_icmp_timeout=30
+	ip netns exec "$ns" sysctl -q net.netfilter.nf_conntrack_udp_timeout=30
+}
+
 check_taint()
 {
 	local tainted_then="$1"
@@ -198,10 +265,13 @@ insert_flood()
 
 	r=$((RANDOM%$insert_count))
 
-	ctflood "$n" "$timeout" "floodresize" &
+	ct_pingflood "$n" "$timeout" "floodresize" &
+	ct_udpflood "$n" "$timeout" &
+
 	insert_ctnetlink "$n" "$r" &
 	ctflush "$n" "$timeout" &
-	ct_nulldump "$n" &
+	ct_nulldump_loop "$n" "$timeout" &
+	ct_change_timeouts_loop "$n" "$timeout" &
 
 	wait
 }
@@ -306,7 +376,7 @@ test_dump_all()
 
 	ip netns exec "$nsclient1" sysctl -q net.netfilter.nf_conntrack_icmp_timeout=3600
 
-	ctflood "$nsclient1" $timeout "dumpall" &
+	ct_pingflood "$nsclient1" $timeout "dumpall" &
 	insert_ctnetlink "$nsclient2" $insert_count
 
 	wait
@@ -368,7 +438,7 @@ test_conntrack_disable()
 	ct_flush_once "$nsclient1"
 	ct_flush_once "$nsclient2"
 
-	ctflood "$nsclient1" "$timeout" "conntrack disable"
+	ct_pingflood "$nsclient1" "$timeout" "conntrack disable"
 	ip netns exec "$nsclient2" ping -q -c 1 127.0.0.1 >/dev/null 2>&1
 
 	# Disabled, should not have picked up any connection.
-- 
2.39.5

