Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC3228D8CE
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Aug 2025 10:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756204237; cv=none; b=NwezqF+2tYAwrIh4XKzdeHhzRBcpE3PtpnLX0zdflTkPrDPV6Aa9xykB0+8aIo06Jd/PkPeByGwSTiOsg7J2DdzxeGNy1tgZ0CXb+Rn1MUHo4S/a/JbS9Yuy3STuUvNBNTyh+TeruLrelfUFLs1NoNy+oDv66WJohGGm+ame9vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756204237; c=relaxed/simple;
	bh=GTQehve3WIQxyqCbFvZ7O2T8p0jHpee9qk6StgRN1jQ=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=KlumWuJXgZsRC+Y77dZd9t6nemPAArLeQVvtY1JHI7sWh4WYUKjo5jZyMpNgcU2kufaRsXDx11fOss1M7kt0opHsuLA+vsDHEEcJnaLKrtXOhD3Vm07cIpR6v6Muz05etg13lY4TUctsaCfA29eO336zH+Nwwiot94K8L88bcUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Kp9k3EIf; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=sMYPIUeM; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Kp9k3EIf";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="sMYPIUeM"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 5842160273; Tue, 26 Aug 2025 12:30:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756204226;
	bh=vXSphXzJqZppo8c4fQZgnvuKd97TkS+Ji5k2Zn7NPMs=;
	h=From:To:Subject:Date:From;
	b=Kp9k3EIfcJ8MdvUIdYBcGw9UOP3vBumpXbQVSM74f+kXzAapNR58Wwf1cCUdye/ww
	 9RE7ueQb1XZU2fhmcU/06BH+4xojPqIFPfiRRH34eAc5viJo5qAtc7H6v7iqL91/tm
	 RgS/W7wVpKO6ACxGrnmwkayT4Jv7yxmnE4c2VXBAsqIGzY2PQ66hDIUL+95MHgmVU9
	 7niYgwT4GTpNkM6rl0iIwKspHz3nhp1xmu37Hn3RyWNH05xGv/i0c88/f5Y3He3L8+
	 dxcn8nV7qnU+idH65BjAWu1iFu1RQ6tBZlS8f4ERhyHriExLD+v5EZkdFiBWaSsXDu
	 Djs84+4NWknSg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D85216026F
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Aug 2025 12:30:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756204225;
	bh=vXSphXzJqZppo8c4fQZgnvuKd97TkS+Ji5k2Zn7NPMs=;
	h=From:To:Subject:Date:From;
	b=sMYPIUeMF8jT0TLFLOm1QD6x6kBw+XrMrGrcyoRLsAnSSQAaKSo4m82HMW0tXD7ws
	 EIVKxkuulmJzIGqilK2I9KAi/WBxXCZFlgFo4G1IZ6DtYwpf7OQVO/SI0TYWgLwms5
	 0n1wdxG09XeurW9FhfsjSU1CsrBDfDIbaqpjyL8Sxtos2X5hRxaWLTHagQy6DBx7kT
	 S8f//j/GAgfJkUv4DhjKBiPLHhCEEdyEThLLDErrbHZtLTK+ShiuhKOQMq9kBryeQ8
	 c/YCSY308ubL1cKmY+mR9ecTuTKgIm2gTeOvCKPPDfW1dClsdpWil/epBhCT1HZlf7
	 SrCyxvWe525KQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v4] mnl: continue on ENOBUFS errors when processing batch
Date: Tue, 26 Aug 2025 12:30:21 +0200
Message-Id: <20250826103021.626734-1-pablo@netfilter.org>
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
v4: do not call mnl_cb_run2() with ret == -1, continue looping instead.

 src/mnl.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/src/mnl.c b/src/mnl.c
index 6684029606e5..892fb8bccdc1 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -449,8 +449,13 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
 			break;
 
 		ret = mnl_socket_recvfrom(nl, rcv_buf, sizeof(rcv_buf));
-		if (ret == -1)
+		if (ret == -1) {
+			/* Too many errors, not all errors are displayed. */
+			if (errno == ENOBUFS)
+				continue;
+
 			return -1;
+		}
 
 		/* Continue on error, make sure we get all acknowledgments */
 		ret = mnl_cb_run2(rcv_buf, ret, 0, portid,
-- 
2.30.2

