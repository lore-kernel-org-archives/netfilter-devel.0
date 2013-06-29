From: Dash Four <mr.dash.four@googlemail.com>
Subject: [PATCH v3 4/5] iptables: add set match "inner" flag support
Date: Sat, 29 Jun 2013 22:33:01 +0100
Message-ID: <51CF528D.4000907@googlemail.com>
References: <cover.1372540515.git.mr.dash.four@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:64623 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3F2VdM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Jun 2013 17:33:12 -0400
Received: by mail-wi0-f170.google.com with SMTP id ey16so2911288wid.3
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Jun 2013 14:33:09 -0700 (PDT)
In-Reply-To: <cover.1372540515.git.mr.dash.four@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds "inner" flag support for the set match.

Revision history:

v1 * initial revision

Signed-off-by: Dash Four <mr.dash.four@googlemail.com>
---
  kernel/net/netfilter/xt_set.c | 21 +++++++++++++++++++++
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

