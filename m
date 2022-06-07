Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90018CCA483
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Jun 2022 21:18:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377885AbiFGVSo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Jun 2022 17:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380705AbiFGVQn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Jun 2022 17:16:43 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D66921F9B6
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2022 11:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Dp/MLLNzTemjqgeR703t0nZn+N8qYsIPYocqdss17Co=; b=Ej6Fbf7x9bUx53FxMnm8QqxMqQ
        rMUW4LcawerIcpM3KHMfmlWL+Xl2zp0jzR9jfQp6sPkk6I2ua1zYW2RkaOh9zk+3xbl554qM7Tb04
        L5GaU4V3ywd3YoJRotwKKJivGkrSOjj/QBuKilAyXbZLtLa3A8UzlkBvkEwgy02T5PDgNNvAJN+zi
        zIMPhIryAQ9hJy/yaH6NQF2mQGOdpNOgkaBNv5s0uql/namP8qnv0VY4/7k8ig6c3I2bMl1HFINDa
        kcQUO5rqMtdKxONRVrS8Bk6wlTMW9skeS5DNfTGzT1cp9+cVP3pNaRv1au70kwmm5Uq+Erru/6mdo
        W4N1Phhg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nyeNP-0002yi-0D
        for netfilter-devel@vger.kernel.org; Tue, 07 Jun 2022 20:56:27 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] arptables: Support -x/--exact flag
Date:   Tue,  7 Jun 2022 20:56:18 +0200
Message-Id: <20220607185618.4960-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Legacy arptables accepts but ignores the flag. Yet there are remains of
the functionality in sources, like OPT_EXPANDED define and a print_num()
function which acts on FMT_KILOMEGAGIGA flag being set or not. So
instead of mimicking legacy behaviour by explicitly ignoring -x flag for
arptables, just enable the feature for it.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xshared.c | 3 +++
 iptables/xshared.h | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index 9b5e5b5bddc27..76001c51cbcb2 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1685,6 +1685,9 @@ void do_parse(int argc, char *argv[],
 			break;
 
 		case 'x':
+			if (args->family == NFPROTO_ARP)
+				break;	/* arptables silently ignores its --exact option */
+
 			set_option(&cs->options, OPT_EXPANDED, &args->invflags,
 				   invert);
 			break;
diff --git a/iptables/xshared.h b/iptables/xshared.h
index f821298839687..2498e32d39e03 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -69,7 +69,7 @@ struct xtables_target;
 
 #define OPTSTRING_COMMON "-:A:C:D:E:F::I:L::M:N:P:VX::Z::" "c:d:i:j:o:p:s:t:"
 #define IPT_OPTSTRING	OPTSTRING_COMMON "R:S::W::" "46bfg:h::m:nvw::x"
-#define ARPT_OPTSTRING	OPTSTRING_COMMON "R:S::" "h::l:nv" /* "m:" */
+#define ARPT_OPTSTRING	OPTSTRING_COMMON "R:S::" "h::l:nvx" /* "m:" */
 #define EBT_OPTSTRING	OPTSTRING_COMMON "hv"
 
 /* define invflags which won't collide with IPT ones */
-- 
2.34.1

