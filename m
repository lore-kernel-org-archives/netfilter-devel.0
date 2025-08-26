Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA51143ABC
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Aug 2025 09:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756199980; cv=none; b=EgiBCo8RMhyHBXq7ZouJUhRzGkBbDn37vMKa3Xm3sWKtnARFllitmfQoWInWF+OOca0wzTgTH9XPLBae5nKahmprcmPqPgw1wjmhb4xbDZqnsuGQL6s75FUeW+8kl/GaPHAmOkjQyi09z+rHvVPiAVlMJhPTjORr8qUTXWjN7oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756199980; c=relaxed/simple;
	bh=5V2bxHsGn2KnsdZHW21gWHysBfRwVeGmUcKuoQVVD7o=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=EwEpGcC8TCI3luURJjlBuLXQ6BWqj4hljqdpNCjwQfKkREIebbLTRtOFUa4QxKGMmSAmZ0NHxFReW/YFWgganE2cV9kGMXfur3UgILFT39z+CmnXiDtA6D6lnrqE1rNYEPub+7R88ZaOCfQTz4Ashq7+XEuncamnvDZ4Nb6fP2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jvmGAP1s; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jvmGAP1s; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jvmGAP1s";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jvmGAP1s"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id E69DD60281; Tue, 26 Aug 2025 11:19:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756199974;
	bh=h4Mk9d2lJx0T54Vf9Jm7gqzXcpuO1Y2VPDyGU9yUqds=;
	h=From:To:Subject:Date:From;
	b=jvmGAP1sey0SROm2ua7tPWtshVWohNejnMjHJvvIfCImXQbacQNSniQ10TmKyLBRF
	 r2/xQz3eStwj8RF0mEtifeZtbDSHGrC/mI4b+980v8BzxB4AFSeiotH9CKSoWxlo/p
	 KxmrK+zbwwE5qI4v55sqKcUuKWNY2XiYVh5kHLGyVQu2tiRRlzfKb5sFqvEPoswXSF
	 SUjC+KJ0OIgzQZbbc1/WIRTjYbrS0Y+543Q5RXFSn4v5JBi3Acr08W5w7RVPun/Z7q
	 dI2nBKV3qyfUqFl1xg70foealfDeJrgTCDJR+9IstU3XCA7oOzR2uToR4mbmFsDbke
	 0hiQMAfL6ZvsQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6A9656027F
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Aug 2025 11:19:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756199974;
	bh=h4Mk9d2lJx0T54Vf9Jm7gqzXcpuO1Y2VPDyGU9yUqds=;
	h=From:To:Subject:Date:From;
	b=jvmGAP1sey0SROm2ua7tPWtshVWohNejnMjHJvvIfCImXQbacQNSniQ10TmKyLBRF
	 r2/xQz3eStwj8RF0mEtifeZtbDSHGrC/mI4b+980v8BzxB4AFSeiotH9CKSoWxlo/p
	 KxmrK+zbwwE5qI4v55sqKcUuKWNY2XiYVh5kHLGyVQu2tiRRlzfKb5sFqvEPoswXSF
	 SUjC+KJ0OIgzQZbbc1/WIRTjYbrS0Y+543Q5RXFSn4v5JBi3Acr08W5w7RVPun/Z7q
	 dI2nBKV3qyfUqFl1xg70foealfDeJrgTCDJR+9IstU3XCA7oOzR2uToR4mbmFsDbke
	 0hiQMAfL6ZvsQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2] mnl: continue on ENOBUFS errors when processing batch
Date: Tue, 26 Aug 2025 11:19:30 +0200
Message-Id: <20250826091930.357582-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A user reports that:

  nft -f ruleset.nft

fails with:

  netlink: Error: Could not process rule: No buffer space available

This was triggered by:

table ip6 fule {
  set domestic_ip6 {
    type ipv6_addr
    flags dynamic,interval
    elements = $domestic_ip6
  }
  chain prerouting {
    type filter hook prerouting priority 0;
    ip6 daddr @domestic_ip6 counter
  }
}

where $domestic_ip6 contains a large number of IPv6 addresses.

This set declaration is not supported currently, because dynamic sets
with intervals are not supported, then every IPv6 address that is added
triggers an error, overruning the userspace socket buffer with lots of
NLMSG_ERROR messages.

In the particular context of batch processing, ENOBUFS is just an
indication that too many errors have occurred. The kernel cannot store
any more NLMSG_ERROR messages into the userspace socket buffer.

However, there are still NLMSG_ERROR messages in the socket buffer to be
processed that can provide a hint on what is going on.

Instead of breaking on ENOBUFS in batches, continue error processing.

After this patch, the ruleset above displays:

ruleset.nft:2367:7-18: Error: Could not process rule: Operation not supported
  set domestic_ip6 {
      ^^^^^^^^^^^^
ruleset.nft:2367:7-18: Error: Could not process rule: No such file or directory
  set domestic_ip6 {
      ^^^^^^^^^^^^

Fixes: a72315d2bad4 ("src: add rule batching support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index 6684029606e5..4595b5aea11d 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -449,8 +449,11 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
 			break;
 
 		ret = mnl_socket_recvfrom(nl, rcv_buf, sizeof(rcv_buf));
-		if (ret == -1)
-			return -1;
+		if (ret == -1) {
+			/* Too many errors, not all errors are displayed. */
+			if (errno != ENOBUFS)
+				return -1;
+		}
 
 		/* Continue on error, make sure we get all acknowledgments */
 		ret = mnl_cb_run2(rcv_buf, ret, 0, portid,
-- 
2.30.2

