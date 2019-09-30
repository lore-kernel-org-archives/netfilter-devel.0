Return-Path: <SRS0=Tpyl=XZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14563C32792
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Sep 2019 22:46:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C85D82086A
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Sep 2019 22:46:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="aLCZk9FZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbfI3Wq4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Sep 2019 18:46:56 -0400
Received: from mx1.riseup.net ([198.252.153.129]:48794 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726350AbfI3Wq4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Sep 2019 18:46:56 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 46hqBD1SkyzDvrw
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2019 10:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1569864516; bh=f7WzG+dPGpbDADwZOFytU94CBXfrPQUEQncYS3Nlp3c=;
        h=From:To:Subject:Date:From;
        b=aLCZk9FZltBU+jfOVTRYagBBlt44uFVTFh25bbEAfkyOA8IXdHOf4kTq0D2qrSZcn
         te6/q7zOHnoqmF7XU0prEGyZnsSNdMcgixCSI3+GObN4IVGnc5QQcseNzBD/O52BPk
         /8KGTpj6b4xKi3XODHL77kOI8NeWb0H4yZhv/Dsw=
X-Riseup-User-ID: 16226807323C5B0F2934F18E6EF1FE24248A95BB83A4AD22AC0E3FCEF8F8FB1D
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 46hqBC49LBzJr3v
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2019 10:28:35 -0700 (PDT)
From:   "Jose M. Guisado Gomez" <guigom@riseup.net>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH iptables] extensions: add libxt_SYNPROXY xlate method
Date:   Mon, 30 Sep 2019 19:28:07 +0200
Message-Id: <20190930172807.5452-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This adds translation capabilities when encountering SYNPROXY inside
iptables rules.

Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
---
 extensions/libxt_SYNPROXY.c      | 23 +++++++++++++++++++++++
 extensions/libxt_SYNPROXY.txlate |  2 ++
 2 files changed, 25 insertions(+)
 create mode 100644 extensions/libxt_SYNPROXY.txlate

diff --git a/extensions/libxt_SYNPROXY.c b/extensions/libxt_SYNPROXY.c
index 475590ea..6a0b913e 100644
--- a/extensions/libxt_SYNPROXY.c
+++ b/extensions/libxt_SYNPROXY.c
@@ -106,6 +106,28 @@ static void SYNPROXY_save(const void *ip, const struct xt_entry_target *target)
 		printf(" --ecn");
 }
 
+static int SYNPROXY_xlate(struct xt_xlate *xl,
+		          const struct xt_xlate_tg_params *params)
+{
+	const struct xt_synproxy_info *info =
+		(const struct xt_synproxy_info *)params->target->data;
+
+	xt_xlate_add(xl, "synproxy ");
+
+	if (info->options & XT_SYNPROXY_OPT_SACK_PERM)
+		xt_xlate_add(xl, "sack-perm ");
+	if (info->options & XT_SYNPROXY_OPT_TIMESTAMP)
+		xt_xlate_add(xl, "timestamp ");
+	if (info->options & XT_SYNPROXY_OPT_WSCALE)
+		xt_xlate_add(xl, "wscale %u ", info->wscale);
+	if (info->options & XT_SYNPROXY_OPT_MSS)
+		xt_xlate_add(xl, "mss %u ", info->mss);
+	if (info->options & XT_SYNPROXY_OPT_ECN)
+		xt_xlate_add(xl, "ecn ");
+
+	return 1;
+}
+
 static struct xtables_target synproxy_tg_reg = {
 	.family        = NFPROTO_UNSPEC,
 	.name          = "SYNPROXY",
@@ -119,6 +141,7 @@ static struct xtables_target synproxy_tg_reg = {
 	.x6_parse      = SYNPROXY_parse,
 	.x6_fcheck     = SYNPROXY_check,
 	.x6_options    = SYNPROXY_opts,
+	.xlate         = SYNPROXY_xlate,
 };
 
 void _init(void)
diff --git a/extensions/libxt_SYNPROXY.txlate b/extensions/libxt_SYNPROXY.txlate
new file mode 100644
index 00000000..b347d3b7
--- /dev/null
+++ b/extensions/libxt_SYNPROXY.txlate
@@ -0,0 +1,2 @@
+iptables-translate -t mangle -A INPUT -i iifname -p tcp -m tcp --dport 80 -m state --state INVALID,UNTRACKED -j SYNPROXY --sack-perm --timestamp --wscale 7 --mss 1460
+nft add rule ip mangle INPUT iifname "iifname" tcp dport 80 ct state invalid,untracked  counter synproxy sack-perm timestamp wscale 7 mss 1460 
-- 
2.23.0

