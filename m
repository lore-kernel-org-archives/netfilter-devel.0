From: Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH 1/2] netfilter: helper: Fix incorrect helper name.
Date: Sat, 14 May 2016 22:19:16 +0900
Message-ID: <1463231956-26867-1-git-send-email-ap420073@gmail.com>
Cc: netfilter-devel@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>
To: pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34486 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbcENNT1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 May 2016 09:19:27 -0400
Received: by mail-pf0-f193.google.com with SMTP id 145so11567231pfz.1
        for <netfilter-devel@vger.kernel.org>; Sat, 14 May 2016 06:19:26 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

when register to helper, each helper adds port to name.
correct form is 'protocol name-port' but irc, sip and tftp adds
a iterator value. so it fix it.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/netfilter/nf_conntrack_irc.c  | 2 +-
 net/netfilter/nf_conntrack_sip.c  | 2 +-
 net/netfilter/nf_conntrack_tftp.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 8b6da27..20ae74f 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -265,7 +265,7 @@ static int __init nf_conntrack_irc_init(void)
 		if (ports[i] == IRC_PORT)
 			sprintf(irc[i].name, "irc");
 		else
-			sprintf(irc[i].name, "irc-%u", i);
+			sprintf(irc[i].name, "irc-%u", ports[i]);
 
 		ret = nf_conntrack_helper_register(&irc[i]);
 		if (ret) {
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 3e06402..d523052 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1661,7 +1661,7 @@ static int __init nf_conntrack_sip_init(void)
 			if (ports[i] == SIP_PORT)
 				sprintf(sip[i][j].name, "sip");
 			else
-				sprintf(sip[i][j].name, "sip-%u", i);
+				sprintf(sip[i][j].name, "sip-%u", ports[i]);
 
 			pr_debug("port #%u: %u\n", i, ports[i]);
 
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index 36f9640..47239fb 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -136,7 +136,7 @@ static int __init nf_conntrack_tftp_init(void)
 			if (ports[i] == TFTP_PORT)
 				sprintf(tftp[i][j].name, "tftp");
 			else
-				sprintf(tftp[i][j].name, "tftp-%u", i);
+				sprintf(tftp[i][j].name, "tftp-%u", ports[i]);
 
 			ret = nf_conntrack_helper_register(&tftp[i][j]);
 			if (ret) {
-- 
2.7.4

