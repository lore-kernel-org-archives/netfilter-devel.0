From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/9] netfilter: xtables: restrict TCPMSS to mangle table as intended
Date: Wed, 17 Mar 2010 14:18:58 +0100
Message-ID: <1268831945-6041-4-git-send-email-jengelh@medozas.de>
References: <1268831945-6041-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:59349 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754851Ab0CQNTT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Mar 2010 09:19:19 -0400
In-Reply-To: <1268831945-6041-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

References: http://bugs.debian.org/567050
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/xt_TCPMSS.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 5f69a20..0c485c4 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -283,6 +283,7 @@ static struct xt_target tcpmss_tg_reg[] __read_mostly = {
 	{
 		.family		= NFPROTO_IPV4,
 		.name		= "TCPMSS",
+		.table		= "mangle",
 		.checkentry	= tcpmss_tg4_check,
 		.target		= tcpmss_tg4,
 		.targetsize	= sizeof(struct xt_tcpmss_info),
@@ -293,6 +294,7 @@ static struct xt_target tcpmss_tg_reg[] __read_mostly = {
 	{
 		.family		= NFPROTO_IPV6,
 		.name		= "TCPMSS",
+		.table		= "mangle",
 		.checkentry	= tcpmss_tg6_check,
 		.target		= tcpmss_tg6,
 		.targetsize	= sizeof(struct xt_tcpmss_info),
-- 
1.7.0.2

