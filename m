From: Dash Four <mr.dash.four@googlemail.com>
Subject: [PATCH 3/4] iptables: add set match "inner" flag support
Date: Wed, 29 May 2013 01:13:42 +0100
Message-ID: <51A54836.4040206@googlemail.com>
References: <51A54267.8050402-git-send-email-mr.dash.four@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:56197 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409Ab3E2ANs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 May 2013 20:13:48 -0400
Received: by mail-wg0-f52.google.com with SMTP id z11so5997212wgg.19
        for <netfilter-devel@vger.kernel.org>; Tue, 28 May 2013 17:13:47 -0700 (PDT)
In-Reply-To: <51A54267.8050402-git-send-email-mr.dash.four@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds "inner" flag support for the set match.

Signed-off-by: Dash Four <mr.dash.four@googlemail.com>
---
  kernel/net/netfilter/xt_set.c |   21 +++++++++++++++++++++
  1 file changed, 21 insertions(+)

diff --git a/kernel/net/netfilter/xt_set.c b/kernel/net/netfilter/xt_set.c
index 00b9c58..430bcff 100644
--- a/kernel/net/netfilter/xt_set.c
+++ b/kernel/net/netfilter/xt_set.c
@@ -464,6 +464,27 @@ static struct xt_match set_matches[] __read_mostly = {
  		.destroy	= set_match_v3_destroy,
  		.me		= THIS_MODULE
  	},
+	/* --inner flag support */
+	{
+		.name		= "set",
+		.family		= NFPROTO_IPV4,
+		.revision	= 4,
+		.match		= set_match_v3,
+		.matchsize	= sizeof(struct xt_set_info_match_v3),
+		.checkentry	= set_match_v3_checkentry,
+		.destroy	= set_match_v3_destroy,
+		.me		= THIS_MODULE
+	},
+	{
+		.name		= "set",
+		.family		= NFPROTO_IPV6,
+		.revision	= 4,
+		.match		= set_match_v3,
+		.matchsize	= sizeof(struct xt_set_info_match_v3),
+		.checkentry	= set_match_v3_checkentry,
+		.destroy	= set_match_v3_destroy,
+		.me		= THIS_MODULE
+	},
  };

  static struct xt_target set_targets[] __read_mostly = {



