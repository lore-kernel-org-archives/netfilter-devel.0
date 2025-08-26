Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61F02FF178
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Aug 2025 08:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756197960; cv=none; b=rejUKwrcgKz33pyt2par4ka1hQCB8poRfdIV9KQEhISGB1wOB3BRE4p7H3SN1tAykYrhUmFYSo4XaLZw6fembmfljx6gTgcPCqgTC7XV6OJtrJCfL36l6lKi5u0FMEcx3fae//RQoP7OhiTlLvsqOpTpPn60lptZx275rUQQETY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756197960; c=relaxed/simple;
	bh=6GnUPyqiDL4ze8iDMjkngkjarRRlAkEc3HzRq2TvLpI=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=jQLC8IjMUpEelzdHcX/AGdP1WWcPpHr34CCtJRewQGT6bvnXAKZM+bagBTMMjzj4+AMTHMTQd1VlP6I3wuoNZvU1D0013tMKp0I0LzwTOkaU8Z6DJO+28XquvYd9yAbSoD4nKte6QsJjyAyFs7uCv1e4tkwBb6ToY6JYJL2JAy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Dgl4ELp9; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=REP25/CS; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Dgl4ELp9";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="REP25/CS"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 4FC00605F2; Tue, 26 Aug 2025 10:45:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756197955;
	bh=zB+YQ0cJCaRGBvQTabG91HUn625IXVbEwtsj4yfQMMY=;
	h=From:To:Subject:Date:From;
	b=Dgl4ELp9P5SB7cEo7QrJz9B/rSBbkq4pc/CL8nkIYr2EvySou7IjzRKAVUrYCPFOe
	 ThS7+rygxcCXfUPNxd87yG1YyOIpIpxtvJc1wdtHLl4JxlXDWMLXicMwGz0qZvJfkI
	 ccGjTxJpmv2KZr2ddEKugsVCzY0XJu0ShSMTy/MFDnFhEyzaFeyTlVHToYN7ThwGXp
	 iLQea+vQLMzJrsHjSH+L8nLwG6n19gWmu2OaTNxb6f96+d0Z1e+ysON4z7tg+NGALv
	 Qscs2uHiYbmhv/OLFnqYjUOL3x6EQw91AtftYtlprwkJISQw3d3+ZSCKJHXKYbWW3/
	 9GW/hENgrEE0w==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C2A13605F0
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Aug 2025 10:45:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756197954;
	bh=zB+YQ0cJCaRGBvQTabG91HUn625IXVbEwtsj4yfQMMY=;
	h=From:To:Subject:Date:From;
	b=REP25/CSNSUuiM3AV68dRhBoQ/Ng/7cp/LMfImlCGFSEZkDl6ewiWiuKp+MqPTOIZ
	 3OW+GJKCzOSvOZFZfpajhbFBp29FE9jVp1i97yLtcvpj30RgYOABvmVLHXb/gGVGgf
	 6vQ1S9y6UIMyGKyklUndrgwyVOhvJUDEir/GO4pi2MTxwlDE1Pqt7TlmOdbKPcCQ1N
	 peM7LPQo/Wfu00UHDjywr7QbnPVvJsMJTcMAvRP2EtEYvY1ZlLvMUGpIHtv342jgeW
	 wFT4Xz9psraHNyrRWRnh5J2o/PyNadAbsWzABbqk5MWI3bZz/a4sWDoBY9/4oGISAg
	 c39kIF+nq08Iw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] libnftables: continue on ENOBUFS errors when processing batch
Date: Tue, 26 Aug 2025 10:45:49 +0200
Message-Id: <20250826084549.356243-1-pablo@netfilter.org>
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

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/libnftables.c |  2 +-
 src/mnl.c         | 16 ++++++++++++++--
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index c8293f77677f..b3f56f69d68d 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -58,7 +58,7 @@ static int nft_netlink(struct nft_ctx *nft,
 		goto out;
 
 	ret = mnl_batch_talk(&ctx, &err_list, num_cmds);
-	if (ret < 0) {
+	if (ret < 0 && errno != ENOBUFS) {
 		if (ctx.maybe_emsgsize && errno == EMSGSIZE) {
 			netlink_io_error(&ctx, NULL,
 					 "Could not process rule: %s\n"
diff --git a/src/mnl.c b/src/mnl.c
index 6684029606e5..294b90c5537a 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -419,6 +419,7 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
 		.err_list = err_list,
 		.nl_ctx = ctx,
 	};
+	bool enobufs = false;
 
 	mnl_set_sndbuffer(ctx);
 
@@ -449,14 +450,25 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
 			break;
 
 		ret = mnl_socket_recvfrom(nl, rcv_buf, sizeof(rcv_buf));
-		if (ret == -1)
-			return -1;
+		if (ret == -1) {
+			/* Too many errors, not all errors are displayed. */
+			if (errno != ENOBUFS)
+				return -1;
+
+			enobufs = true;
+		}
 
 		/* Continue on error, make sure we get all acknowledgments */
 		ret = mnl_cb_run2(rcv_buf, ret, 0, portid,
 				  netlink_echo_callback, &cb_data,
 				  cb_ctl_array, MNL_ARRAY_SIZE(cb_ctl_array));
 	}
+
+	if (enobufs) {
+		errno = ENOBUFS;
+		return -1;
+	}
+
 	return 0;
 }
 
-- 
2.30.2

