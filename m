Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4D2CC76196
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Apr 2023 06:09:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjDJGJv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Apr 2023 02:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDJGJt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Apr 2023 02:09:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F9AC3ABD
        for <netfilter-devel@vger.kernel.org>; Sun,  9 Apr 2023 23:09:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D78C360DB5
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Apr 2023 06:09:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF689C433D2;
        Mon, 10 Apr 2023 06:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681106987;
        bh=r5DfIviWX4wKDN/JYB/EppXkw803B5eWJ3wShstRZQw=;
        h=From:To:Cc:Subject:Date:From;
        b=kV+d/buFeRg/WXv0zsUcIzVt9y8VrCoGXHPodCY8snoGQe1Md8en9TINL/RubOjlu
         rtSYm/Bhinhxx0T5alXnY3LY9sVFOi7K3x6AFPnNN5QbXBE83gBVUhAXdoPcyTkJgv
         pTCSBhtIXAQ4dIKeUhNyUG98MiETuIS7fDbnlANYf1sSpAX57x5ozLCIeRXqLk0O8U
         4F7PVNDCvPPrpObQJ9vpzbojapNvLXxAZNh1BNVo5X8UulSJsLCRHNxG1KuMo64B/t
         IUDRIGMGjeaLZrFirAp6vmCoz1TX3l3DTXr7GZBJRvQO7EQkLrGESm0SeW9b18nO2X
         xYXz3GgIlENwg==
From:   Tzung-Bi Shih <tzungbi@kernel.org>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        tzungbi@kernel.org, jiejiang@chromium.org,
        jasongustaman@chromium.org, garrick@chromium.org
Subject: [PATCH] netfilter: conntrack: fix wrong ct->timeout value
Date:   Mon, 10 Apr 2023 14:09:35 +0800
Message-Id: <20230410060935.253503-1-tzungbi@kernel.org>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

(struct nf_conn)->timeout is an interval before the conntrack
confirmed.  After confirmed, it becomes a timestamp[1].

It is observed that timeout of an unconfirmed conntrack have been
altered by calling ctnetlink_change_timeout().  As a result,
`nfct_time_stamp` was wrongly added to `ct->timeout` twice[2].

Differentiate the 2 cases in all `ct->timeout` accesses.

[1]: https://elixir.bootlin.com/linux/v6.3-rc5/source/net/netfilter/nf_conntrack_core.c#L1257
[2]: https://elixir.bootlin.com/linux/v6.3-rc5/source/include/net/netfilter/nf_conntrack_core.h#L92

Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
---
 include/net/netfilter/nf_conntrack.h      | 27 +++++++++++++++++++----
 include/net/netfilter/nf_conntrack_core.h |  2 +-
 net/netfilter/nf_conntrack_core.c         | 11 ++++-----
 net/netfilter/nf_conntrack_proto_tcp.c    |  4 ++--
 net/netfilter/nf_flow_table_core.c        |  4 ++--
 5 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index a72028dbef0c..48e020db3fb3 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -290,17 +290,36 @@ static inline bool nf_is_loopback_packet(const struct sk_buff *skb)
 
 #define nfct_time_stamp ((u32)(jiffies))
 
+static inline s32 nf_ct_read_timeout(const struct nf_conn *ct)
+{
+	s32 timeout;
+
+	if (nf_ct_is_confirmed(ct))
+		timeout = READ_ONCE(ct->timeout) - nfct_time_stamp;
+	else
+		timeout = READ_ONCE(ct->timeout);
+
+	return timeout;
+}
+
+static inline void nf_ct_write_timeout(struct nf_conn *ct, s32 timeout)
+{
+	if (nf_ct_is_confirmed(ct))
+		WRITE_ONCE(ct->timeout, timeout + nfct_time_stamp);
+	else
+		WRITE_ONCE(ct->timeout, timeout);
+}
+
 /* jiffies until ct expires, 0 if already expired */
 static inline unsigned long nf_ct_expires(const struct nf_conn *ct)
 {
-	s32 timeout = READ_ONCE(ct->timeout) - nfct_time_stamp;
-
+	s32 timeout = nf_ct_read_timeout(ct);
 	return max(timeout, 0);
 }
 
 static inline bool nf_ct_is_expired(const struct nf_conn *ct)
 {
-	return (__s32)(READ_ONCE(ct->timeout) - nfct_time_stamp) <= 0;
+	return nf_ct_expires(ct) == 0;
 }
 
 /* use after obtaining a reference count */
@@ -319,7 +338,7 @@ static inline bool nf_ct_should_gc(const struct nf_conn *ct)
 static inline void nf_ct_offload_timeout(struct nf_conn *ct)
 {
 	if (nf_ct_expires(ct) < NF_CT_DAY / 2)
-		WRITE_ONCE(ct->timeout, nfct_time_stamp + NF_CT_DAY);
+		nf_ct_write_timeout(ct, NF_CT_DAY);
 }
 
 struct kernel_param;
diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 71d1269fe4d4..7a6e49a66d20 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -89,7 +89,7 @@ static inline void __nf_ct_set_timeout(struct nf_conn *ct, u64 timeout)
 {
 	if (timeout > INT_MAX)
 		timeout = INT_MAX;
-	WRITE_ONCE(ct->timeout, nfct_time_stamp + (u32)timeout);
+	nf_ct_write_timeout(ct, (u32)timeout);
 }
 
 int __nf_ct_change_timeout(struct nf_conn *ct, u64 cta_timeout);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index db1ea361f2da..47166576c195 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -657,7 +657,7 @@ bool nf_ct_delete(struct nf_conn *ct, u32 portid, int report)
 
 	tstamp = nf_conn_tstamp_find(ct);
 	if (tstamp) {
-		s32 timeout = READ_ONCE(ct->timeout) - nfct_time_stamp;
+		s32 timeout = nf_ct_read_timeout(ct);
 
 		tstamp->stop = ktime_get_real_ns();
 		if (timeout < 0)
@@ -1063,7 +1063,7 @@ static int nf_ct_resolve_clash_harder(struct sk_buff *skb, u32 repl_idx)
 	}
 
 	/* We want the clashing entry to go away real soon: 1 second timeout. */
-	WRITE_ONCE(loser_ct->timeout, nfct_time_stamp + HZ);
+	nf_ct_write_timeout(loser_ct, HZ);
 
 	/* IPS_NAT_CLASH removes the entry automatically on the first
 	 * reply.  Also prevents UDP tracker from moving the entry to
@@ -2079,11 +2079,8 @@ void __nf_ct_refresh_acct(struct nf_conn *ct,
 		goto acct;
 
 	/* If not in hash table, timer will not be active yet */
-	if (nf_ct_is_confirmed(ct))
-		extra_jiffies += nfct_time_stamp;
-
-	if (READ_ONCE(ct->timeout) != extra_jiffies)
-		WRITE_ONCE(ct->timeout, extra_jiffies);
+	if (nf_ct_read_timeout(ct) != extra_jiffies)
+		nf_ct_write_timeout(ct, extra_jiffies);
 acct:
 	if (do_acct)
 		nf_ct_acct_update(ct, CTINFO2DIR(ctinfo), skb->len);
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 4018acb1d674..a2797d026943 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -766,7 +766,7 @@ static void __cold nf_tcp_handle_invalid(struct nf_conn *ct,
 					  "packet (index %d, dir %d) response for index %d lower timeout to %u",
 					  index, dir, ct->proto.tcp.last_index, timeout);
 
-			WRITE_ONCE(ct->timeout, timeout + nfct_time_stamp);
+			nf_ct_write_timeout(ct, timeout);
 		}
 	} else {
 		ct->proto.tcp.last_index = index;
@@ -939,7 +939,7 @@ void nf_conntrack_tcp_set_closing(struct nf_conn *ct)
 	}
 
 	timeout = timeouts[TCP_CONNTRACK_CLOSE];
-	WRITE_ONCE(ct->timeout, timeout + nfct_time_stamp);
+	nf_ct_write_timeout(ct, timeout);
 
 	spin_unlock_bh(&ct->lock);
 
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 04bd0ed4d2ae..113bd361e537 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -206,8 +206,8 @@ static void flow_offload_fixup_ct(struct nf_conn *ct)
 	if (timeout < 0)
 		timeout = 0;
 
-	if (nf_flow_timeout_delta(READ_ONCE(ct->timeout)) > (__s32)timeout)
-		WRITE_ONCE(ct->timeout, nfct_time_stamp + timeout);
+	if (nf_flow_timeout_delta(nf_ct_read_timeout(ct)) > (__s32)timeout)
+		nf_ct_write_timeout(ct, timeout);
 }
 
 static void flow_offload_route_release(struct flow_offload *flow)
-- 
2.40.0.577.gac1e443424-goog

