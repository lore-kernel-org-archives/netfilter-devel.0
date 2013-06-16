From: Dash Four <mr.dash.four@googlemail.com>
Subject: [PATCH v2 4/5] iptables: add set match "inner" flag support
Date: Mon, 17 Jun 2013 00:27:38 +0100
Message-ID: <51BE49EA.5070708@googlemail.com>
References: <cover.1371423775.git.mr.dash.four@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:47103 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408Ab3FPX1t (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Jun 2013 19:27:49 -0400
Received: by mail-wi0-f182.google.com with SMTP id m6so1668625wiv.3
        for <netfilter-devel@vger.kernel.org>; Sun, 16 Jun 2013 16:27:48 -0700 (PDT)
In-Reply-To: <cover.1371423775.git.mr.dash.four@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds "inner" flag support for the set match.

Revision history:

v1 * initial revision

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

