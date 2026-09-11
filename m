Received: from va-2-41.ptr.blmpb.com (va-2-41.ptr.blmpb.com [209.127.231.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3473BC696
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Sep 2026 03:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789099025; cv=none; b=sTjbgA2z7qqR4uuU1nblsdof8hKXRiMOpsbe0y4HgvuwxU4sYXMazzn6q3Ef+0M83nMHtaTiepQ6jeW05T/Y8NHfwyk1BcHu2e/cTZVmEubMM4CcB7e3DMlNv8C+NjSpdHrXPn5y9xJKZVVRp92JoFbGrgxpbrkeLV8RibieVBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789099025; c=relaxed/simple;
	bh=P3wN9CDEu2RFhQKqAwjw9EZUqAuIA35RB/NpHVyqdy4=;
	h=Content-Type:To:Cc:From:Date:Message-Id:Subject:Mime-Version; b=HRWpCeNwJ1u+YyogA6jNYiNgYVvD4cGdVZ6OGIuPo9qp/gO9DLWPsJM/5I2jGY8ynJN5TsmDcEprQS4MMOWM9GpvKsMOVurn1lXB2cxI4qp+ki9f0df2nKvoMMm3Pp2y6jVlLo9PQzMMn7CS5vvmyZiwRqjGDhcukO3M8FeKXKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com; spf=pass smtp.mailfrom=lanxincomputing.com; dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b=uu8FS7zO; arc=none smtp.client-ip=209.127.231.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lanxincomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b="uu8FS7zO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=lanxincomputing-com.20200927.dkim.feishu.cn; t=1789099011;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=gFvKIyooDli1jez1sQOWvZyfJBAMmD4w4FTDZhpGNwE=;
 b=uu8FS7zOJt1KVcRBP63hu9H4sJ6M8NmUc+dBQOSmoOgbI6htGvf6dV7cNb/+eLyldXH9Ye
 wQz9Ym9GR39GQ8aiwSupafoD1HT33ANnRZkG3FNiHArngbagGs8jGtjFs+0JxYMj6lUKWV
 e5iu4NvUFR8RcLAegKjVaaukDhXyXUj//QemFM4+T6N9iBxCKL/3i+QcATYti7G49Tz8bI
 Tbv3vw9PUwUe7sS+upc7WkOqb6dzrR4AA2aRXD8GTHGsIYMKWyg5gheht8XE6Ef/gcc5MX
 gziyvimxVojdBW8kJlK43h8jHZ9FMuQicLmEhnziMZcxyzI/MPAdTXqmLfTbjw==
X-Mailer: git-send-email 2.53.0
Content-Type: text/plain; charset=UTF-8
To: "Shuah Khan" <shuah@kernel.org>, 
	"Pablo Neira Ayuso" <pablo@netfilter.org>, 
	"Florian Westphal" <fw@strlen.de>
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, "Jin Li" <jinli@lanxincomputing.com>
From: "Jin Li" <jinli@lanxincomputing.com>
Date: Fri, 11 Sep 2026 03:56:32 +0000
Message-Id: <20260911035632.491163-1-jinli@lanxincomputing.com>
X-Original-From: Jin Li <jinli@lanxincomputing.com>
Received: from ubuntu ([123.120.5.129]) by smtp.feishu.cn with ESMTPS; Fri, 11 Sep 2026 11:56:48 +0800
X-Lms-Return-Path: <lba+26aa37c01+8b5a09+vger.kernel.org+jinli@lanxincomputing.com>
Subject: [PATCH] selftests: netfilter: fix nft_audit.sh auditd detection
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0

The auditd PID file location changed from /var/run/auditd.pid to
/run/audit/auditd.pid in newer audit-userspace versions, causing the
skip check in nft_audit.sh to fail silently.

Replace the PID file check with pgrep, which works regardless of
where the PID file is located.

Signed-off-by: Jin Li <jinli@lanxincomputing.com>
---
 tools/testing/selftests/net/netfilter/nft_audit.sh | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_audit.sh b/tools/testing/selftests/net/netfilter/nft_audit.sh
index 87f2b4c725aa..85cc4ce7742a 100755
--- a/tools/testing/selftests/net/netfilter/nft_audit.sh
+++ b/tools/testing/selftests/net/netfilter/nft_audit.sh
@@ -6,14 +6,9 @@
 SKIP_RC=4
 RC=0
 
-if [ -r /var/run/auditd.pid ];then
-	read pid < /var/run/auditd.pid
-	p=$(pgrep ^auditd$)
-
-	if [ "$pid" -eq "$p" ]; then
-		echo "SKIP: auditd is running"
-		exit $SKIP_RC
-	fi
+if pgrep -x auditd > /dev/null; then
+	echo "SKIP: auditd is running"
+	exit $SKIP_RC
 fi
 
 nft --version >/dev/null 2>&1 || {
-- 
2.53.0
