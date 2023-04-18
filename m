Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ED6AC77B75
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Apr 2023 10:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjDRKCf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Apr 2023 06:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjDRKCe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Apr 2023 06:02:34 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A2FAF525D
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Apr 2023 03:02:30 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     dave@pifke.org
Subject: [PATCH nft] mnl: set SO_SNDBUF before SO_SNDBUFFORCE
Date:   Tue, 18 Apr 2023 12:02:23 +0200
Message-Id: <20230418100223.158964-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Set SO_SNDBUF before SO_{SND,RCV}BUFFORCE: Unpriviledged namespace do
not have CAP_NET_ADMIN on the host (user_init_ns) namespace.

SO_SNDBUF always succeeds in Linux, always try SO_{SND,RCV}BUFFORCE
after it.

Moreover, suggest the user to bump socket limits if EMSGSIZE is hit.

Provide a hint to the user too:

 # nft -f test.nft
 netlink: Error: Could not process rule: Message too long
 Please, rise /proc/sys/net/core/wmem_max on the host namespace. Hint: 4194304 bytes

Dave Pfike says:

 Prior to this patch, nft inside a systemd-nspawn container was failing
 to install my ruleset (which includes a large-ish map), with the error

 netlink: Error: Could not process rule: Message too long

 strace reveals:

 setsockopt(3, SOL_SOCKET, SO_SNDBUFFORCE, [524288], 4) = -1 EPERM (Operation not permitted)

 This is despite the nspawn process supposedly having CAP_NET_ADMIN,
 and despite /proc/sys/net/core/wmem_max (in the main host namespace)
 being set larger than the requested size:

 net.core.wmem_max = 16777216

 A web search reveals at least one other user having the same issue:

 https://old.reddit.com/r/Proxmox/comments/scnoav/lxc_container_debian_11_nftables_geoblocking/

Reported-by: Dave Pifke <dave@pifke.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/netlink.h |  1 +
 include/utils.h   |  1 +
 src/libnftables.c |  7 +++++++
 src/mnl.c         | 17 ++++++++++++-----
 src/utils.c       | 12 ++++++++++++
 5 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index 0d97f71ccff3..d52434c72bc2 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -84,6 +84,7 @@ struct netlink_ctx {
 	const void		*data;
 	uint32_t		seqnum;
 	struct nftnl_batch	*batch;
+	int			maybe_emsgsize;
 };
 
 extern struct nftnl_expr *alloc_nft_expr(const char *name);
diff --git a/include/utils.h b/include/utils.h
index ffbe2cbb75be..7782640888c9 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -136,5 +136,6 @@ extern void *xzalloc(size_t size);
 extern void *xzalloc_array(size_t nmemb, size_t size);
 extern char *xstrdup(const char *s);
 extern void xstrunescape(const char *in, char *out);
+extern int round_pow_2(int value);
 
 #endif /* NFTABLES_UTILS_H */
diff --git a/src/libnftables.c b/src/libnftables.c
index 4f538c44b998..de16d203a017 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -55,6 +55,13 @@ static int nft_netlink(struct nft_ctx *nft,
 
 	ret = mnl_batch_talk(&ctx, &err_list, num_cmds);
 	if (ret < 0) {
+		if (ctx.maybe_emsgsize && errno == EMSGSIZE) {
+			netlink_io_error(&ctx, NULL,
+					 "Could not process rule: %s\n"
+					 "Please, rise /proc/sys/net/core/wmem_max on the host namespace. Hint: %d bytes",
+					 strerror(errno), round_pow_2(ctx.maybe_emsgsize));
+			goto out;
+		}
 		netlink_io_error(&ctx, NULL,
 				 "Could not process rule: %s", strerror(errno));
 		goto out;
diff --git a/src/mnl.c b/src/mnl.c
index 26f943dbb4c8..ce9e4ee1c059 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -245,9 +245,10 @@ void mnl_err_list_free(struct mnl_err *err)
 	xfree(err);
 }
 
-static void mnl_set_sndbuffer(const struct mnl_socket *nl,
-			      struct nftnl_batch *batch)
+static void mnl_set_sndbuffer(struct netlink_ctx *ctx)
 {
+	struct mnl_socket *nl = ctx->nft->nf_sock;
+	struct nftnl_batch *batch = ctx->batch;
 	socklen_t len = sizeof(int);
 	int sndnlbuffsiz = 0;
 	int newbuffsiz;
@@ -260,9 +261,15 @@ static void mnl_set_sndbuffer(const struct mnl_socket *nl,
 		return;
 
 	/* Rise sender buffer length to avoid hitting -EMSGSIZE */
+	setsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_SNDBUF,
+		   &newbuffsiz, sizeof(socklen_t));
+
+	/* unpriviledged containers check for CAP_NET_ADMIN on the init_user_ns. */
 	if (setsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_SNDBUFFORCE,
-		       &newbuffsiz, sizeof(socklen_t)) < 0)
-		return;
+		       &newbuffsiz, sizeof(socklen_t)) < 0) {
+		if (errno == EPERM)
+			ctx->maybe_emsgsize = newbuffsiz;
+	}
 }
 
 static unsigned int nlsndbufsiz;
@@ -409,7 +416,7 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
 		.nl_ctx = ctx,
 	};
 
-	mnl_set_sndbuffer(ctx->nft->nf_sock, ctx->batch);
+	mnl_set_sndbuffer(ctx);
 
 	mnl_nft_batch_to_msg(ctx, &msg, &snl, iov, iov_len);
 
diff --git a/src/utils.c b/src/utils.c
index 925841c571f5..c32ac220b127 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -100,3 +100,15 @@ void xstrunescape(const char *in, char *out)
 	}
 	out[k++] = '\0';
 }
+
+int round_pow_2(int value)
+{
+	value--;
+	value |= value >> 1;
+	value |= value >> 2;
+	value |= value >> 4;
+	value |= value >> 8;
+	value |= value >> 16;
+
+	return value + 1;
+}
-- 
2.30.2

