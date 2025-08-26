Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86B22F6593
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Aug 2025 09:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756201002; cv=none; b=TLPUl3Aia7JJNWARaR2fsGZ/oOD9yCc8DLrHVAVGPf7jfBW2C8hDoqneqIq75MfFkwLOoO6MQR8TP70G0ogZFQ4Z0y1m0i6grdkMdQL/oygpRy2A0bIjk+1S5wS1njpro+gAUphfAb3T+o/3yBItayev1mjbPefKdGFQgdai7gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756201002; c=relaxed/simple;
	bh=DOfkJxDn5JPKZzkS/fqffL23zREofkqhdCFO3ZUD1/Y=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=WtXhEOGysPjvlcbrUo3cRXHqp2VJZfd3yhyaLoxTsZkXyZ/rIuVHYjdDOTj4DLPXbgKg6WGix7hpLeoMHZK5m7JnVaTYwZNo1+VJgVfb3Aq1VU0fBchggX4Gd5B4Kb8W3lIELO4+zbiYllKFcgoUbF83tKxDIfoYfYWyUeO+yJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dkxW7b23; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dkxW7b23; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dkxW7b23";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dkxW7b23"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 534F66026E; Tue, 26 Aug 2025 11:36:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756200998;
	bh=xPveC13T3CFZSWp9+QMER56TKvlABkDOC8wAxMG1UPU=;
	h=From:To:Subject:Date:From;
	b=dkxW7b23ZuKcspbhys4rW9I0atJ43WdwDjgfRW8XWZ9cgPVmpOEHV4xfYapsxGEUb
	 MciceqJS0xSgvRV5XplmirOm9KnQ8loCfbF8FyEEKw3m7w0YG+iNXng7cxVss6FJrO
	 DgAMSA3UnyaaCKgvHS3GREufK0MII5TVgbe8Y68grMF89XyDy/F1twggkIeQmHpXHc
	 uwGhCOtsGlBZtERjNsdMOKewfVzGZhXwRMHB1pTb2CxYg2icDtghK1KVXEDgBabLgZ
	 TNxpgywwpoZ400Am4o4kDE4hUBCmtCCVO8pBIvVD3nHjofAtaf9UtcTgTF1qLOdZbt
	 +BZRmBcf4Zizw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E46846026C
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Aug 2025 11:36:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756200998;
	bh=xPveC13T3CFZSWp9+QMER56TKvlABkDOC8wAxMG1UPU=;
	h=From:To:Subject:Date:From;
	b=dkxW7b23ZuKcspbhys4rW9I0atJ43WdwDjgfRW8XWZ9cgPVmpOEHV4xfYapsxGEUb
	 MciceqJS0xSgvRV5XplmirOm9KnQ8loCfbF8FyEEKw3m7w0YG+iNXng7cxVss6FJrO
	 DgAMSA3UnyaaCKgvHS3GREufK0MII5TVgbe8Y68grMF89XyDy/F1twggkIeQmHpXHc
	 uwGhCOtsGlBZtERjNsdMOKewfVzGZhXwRMHB1pTb2CxYg2icDtghK1KVXEDgBabLgZ
	 TNxpgywwpoZ400Am4o4kDE4hUBCmtCCVO8pBIvVD3nHjofAtaf9UtcTgTF1qLOdZbt
	 +BZRmBcf4Zizw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v3] mnl: continue on ENOBUFS errors when processing batch
Date: Tue, 26 Aug 2025 11:36:33 +0200
Message-Id: <20250826093633.525032-1-pablo@netfilter.org>
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
v3: consolidate check, simply skip ENOBUFS for batch.

 src/mnl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/mnl.c b/src/mnl.c
index 6684029606e5..934e5d4e79ee 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -449,7 +449,8 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
 			break;
 
 		ret = mnl_socket_recvfrom(nl, rcv_buf, sizeof(rcv_buf));
-		if (ret == -1)
+		/* ENOBUFS means too many errors, not all errors are displayed. */
+		if (ret == -1 && errno != ENOBUFS)
 			return -1;
 
 		/* Continue on error, make sure we get all acknowledgments */
-- 
2.30.2

