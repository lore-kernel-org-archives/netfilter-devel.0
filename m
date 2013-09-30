From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 2/2] netfilter: ipt_ULOG: fix info leaks
Date: Mon, 30 Sep 2013 22:05:08 +0200
Message-ID: <1380571508-15486-3-git-send-email-minipli@googlemail.com>
References: <1380571508-15486-1-git-send-email-minipli@googlemail.com>
Cc: Mathias Krause <minipli@googlemail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:52547 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755Ab3I3UFb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Sep 2013 16:05:31 -0400
Received: by mail-bk0-f48.google.com with SMTP id my13so2260366bkb.35
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2013 13:05:30 -0700 (PDT)
In-Reply-To: <1380571508-15486-1-git-send-email-minipli@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The ulog messages leak heap bytes by the means of padding bytes and
incompletely filled string arrays. Fix those by memset(0)'ing the
whole struct before filling it.

Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 net/ipv4/netfilter/ipt_ULOG.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index cbc2215..9cb993c 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -220,6 +220,7 @@ static void ipt_ulog_packet(struct net *net,
 	ub->qlen++;
 
 	pm = nlmsg_data(nlh);
+	memset(pm, 0, sizeof(*pm));
 
 	/* We might not have a timestamp, get one */
 	if (skb->tstamp.tv64 == 0)
@@ -238,8 +239,6 @@ static void ipt_ulog_packet(struct net *net,
 	}
 	else if (loginfo->prefix[0] != '\0')
 		strncpy(pm->prefix, loginfo->prefix, sizeof(pm->prefix));
-	else
-		*(pm->prefix) = '\0';
 
 	if (in && in->hard_header_len > 0 &&
 	    skb->mac_header != skb->network_header &&
@@ -251,13 +250,9 @@ static void ipt_ulog_packet(struct net *net,
 
 	if (in)
 		strncpy(pm->indev_name, in->name, sizeof(pm->indev_name));
-	else
-		pm->indev_name[0] = '\0';
 
 	if (out)
 		strncpy(pm->outdev_name, out->name, sizeof(pm->outdev_name));
-	else
-		pm->outdev_name[0] = '\0';
 
 	/* copy_len <= skb->len, so can't fail. */
 	if (skb_copy_bits(skb, 0, pm->payload, copy_len) < 0)
-- 
1.7.10.4

