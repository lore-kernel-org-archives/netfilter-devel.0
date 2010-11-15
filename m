From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH] netfilter: nf_ct_frag6_sysctl_table is static
Date: Mon, 15 Nov 2010 18:16:28 +0100
Message-ID: <1289841388.2607.99.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38745 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932698Ab0KORQf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:16:35 -0500
Received: by eye27 with SMTP id 27so3026432eye.19
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Nov 2010 09:16:33 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 3a3f129..eb9f1c0 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -73,7 +73,7 @@ static struct inet_frags nf_frags;
 static struct netns_frags nf_init_frags;
 
 #ifdef CONFIG_SYSCTL
-struct ctl_table nf_ct_frag6_sysctl_table[] = {
+static struct ctl_table nf_ct_frag6_sysctl_table[] = {
 	{
 		.procname	= "nf_conntrack_frag6_timeout",
 		.data		= &nf_init_frags.timeout,


