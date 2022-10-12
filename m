Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBA25C4332F
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Oct 2022 15:19:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiJLPTT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Oct 2022 11:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbiJLPS6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Oct 2022 11:18:58 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3284C90DE
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Oct 2022 08:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=caIjDhEixW98C8rViRRYPkOzQzv1kADB/Dvp2nmpAFY=; b=AxJJG8OpD8F8ybPhwuzGzGAoQv
        YIvcEECC3M/T57cT0BMQ83qNB0bXqo15bMplDEmj1Z+qaYuLXtLlZzw0xEaPMI0g0X4h/wLwam1jJ
        5/LHri56Bulhgx5iNhYJLednUxG9YjEaPb/ZRXqG9gLg5yorpLJJzrFeOi/dkaRySUhmXc0T8BnL+
        rHUefn7wGrF1dj56yJcrbzkFk9TbKcFmHFf/WKcqApRjke0j7kBKm48/hZ8S9q+q62r9ICwsqFqug
        XI/TMtTORkRBG4SeM7lpTdrm78NKsbTdv3kCitFywIUg09apgMVV4v4qO6qK01J96HIaacaWpkZpA
        cVyh3vtg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oidVQ-0002pQ-Lh; Wed, 12 Oct 2022 17:18:48 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH v2 01/12] extensions: NFQUEUE: Document queue-balance limitation
Date:   Wed, 12 Oct 2022 17:17:51 +0200
Message-Id: <20221012151802.11339-2-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221012151802.11339-1-phil@nwl.cc>
References: <20221012151802.11339-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The range is not communicated to the kernel as "min and max queue
number", but "first queue number and count" instead. With 16bits for
each value, it is not possible to balance between all 65536 possible
queues. Although probably never used in practice, point this detail out
in man page and make the parser complain instead of the cryptic
"xt_NFQUEUE: number of total queues is 0" emitted by the kernel module.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_NFQUEUE.c   | 2 +-
 extensions/libxt_NFQUEUE.man | 2 ++
 extensions/libxt_NFQUEUE.t   | 5 ++---
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
index fe5190789e306..ca6cdaf49703c 100644
--- a/extensions/libxt_NFQUEUE.c
+++ b/extensions/libxt_NFQUEUE.c
@@ -64,7 +64,7 @@ static const struct xt_option_entry NFQUEUE_opts[] = {
 	{.name = "queue-num", .id = O_QUEUE_NUM, .type = XTTYPE_UINT16,
 	 .flags = XTOPT_PUT, XTOPT_POINTER(s, queuenum),
 	 .excl = F_QUEUE_BALANCE},
-	{.name = "queue-balance", .id = O_QUEUE_BALANCE,
+	{.name = "queue-balance", .id = O_QUEUE_BALANCE, .max = UINT16_MAX - 1,
 	 .type = XTTYPE_UINT16RC, .excl = F_QUEUE_NUM},
 	{.name = "queue-bypass", .id = O_QUEUE_BYPASS, .type = XTTYPE_NONE},
 	{.name = "queue-cpu-fanout", .id = O_QUEUE_CPU_FANOUT,
diff --git a/extensions/libxt_NFQUEUE.man b/extensions/libxt_NFQUEUE.man
index 1bfb7b843587f..950b0d2412e58 100644
--- a/extensions/libxt_NFQUEUE.man
+++ b/extensions/libxt_NFQUEUE.man
@@ -18,6 +18,8 @@ This specifies a range of queues to use. Packets are then balanced across the gi
 This is useful for multicore systems: start multiple instances of the userspace program on
 queues x, x+1, .. x+n and use "\-\-queue\-balance \fIx\fP\fB:\fP\fIx+n\fP".
 Packets belonging to the same connection are put into the same nfqueue.
+Due to implementation details, a lower range value of 0 limits the higher range
+value to 65534, i.e. one can only balance between at most 65535 queues.
 .PP
 .TP
 \fB\-\-queue\-bypass\fP
diff --git a/extensions/libxt_NFQUEUE.t b/extensions/libxt_NFQUEUE.t
index b51b19fd435f7..5a2df6e7d00d0 100644
--- a/extensions/libxt_NFQUEUE.t
+++ b/extensions/libxt_NFQUEUE.t
@@ -4,9 +4,8 @@
 -j NFQUEUE --queue-num 65535;=;OK
 -j NFQUEUE --queue-num 65536;;FAIL
 -j NFQUEUE --queue-num -1;;FAIL
-# it says "NFQUEUE: number of total queues is 0", overflow in NFQUEUE_parse_v1?
-# ERROR: cannot load: iptables -A INPUT -j NFQUEUE --queue-balance 0:65535
-# -j NFQUEUE --queue-balance 0:65535;=;OK
+-j NFQUEUE --queue-balance 0:65534;=;OK
+-j NFQUEUE --queue-balance 0:65535;;FAIL
 -j NFQUEUE --queue-balance 0:65536;;FAIL
 -j NFQUEUE --queue-balance -1:65535;;FAIL
 -j NFQUEUE --queue-num 10 --queue-bypass;=;OK
-- 
2.34.1

