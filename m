From: Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH 2/2] netfilter: helper: Fix helper unregister count.
Date: Sat, 14 May 2016 22:19:53 +0900
Message-ID: <1463231993-26917-1-git-send-email-ap420073@gmail.com>
Cc: netfilter-devel@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>
To: pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33441 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146AbcENNUB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 May 2016 09:20:01 -0400
Received: by mail-pf0-f195.google.com with SMTP id y7so11543613pfb.0
        for <netfilter-devel@vger.kernel.org>; Sat, 14 May 2016 06:20:01 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

helpers should unregister the only registered ports.
but, helper cannot have correct registered ports value when
failed to register.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/netfilter/nf_conntrack_ftp.c  | 1 +
 net/netfilter/nf_conntrack_irc.c  | 1 +
 net/netfilter/nf_conntrack_sane.c | 1 +
 net/netfilter/nf_conntrack_sip.c  | 1 +
 net/netfilter/nf_conntrack_tftp.c | 1 +
 5 files changed, 5 insertions(+)

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 883c691..19efeba 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -632,6 +632,7 @@ static int __init nf_conntrack_ftp_init(void)
 			if (ret) {
 				pr_err("failed to register helper for pf: %d port: %d\n",
 				       ftp[i][j].tuple.src.l3num, ports[i]);
+				ports_c = i;
 				nf_conntrack_ftp_fini();
 				return ret;
 			}
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 20ae74f..9844e62 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -271,6 +271,7 @@ static int __init nf_conntrack_irc_init(void)
 		if (ret) {
 			pr_err("failed to register helper for pf: %u port: %u\n",
 			       irc[i].tuple.src.l3num, ports[i]);
+			ports_c = i;
 			nf_conntrack_irc_fini();
 			return ret;
 		}
diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack_sane.c
index 7523a57..3fcbaab 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -223,6 +223,7 @@ static int __init nf_conntrack_sane_init(void)
 			if (ret) {
 				pr_err("failed to register helper for pf: %d port: %d\n",
 				       sane[i][j].tuple.src.l3num, ports[i]);
+				ports_c = i;
 				nf_conntrack_sane_fini();
 				return ret;
 			}
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index d523052..2c748bc 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1669,6 +1669,7 @@ static int __init nf_conntrack_sip_init(void)
 			if (ret) {
 				pr_err("failed to register helper for pf: %u port: %u\n",
 				       sip[i][j].tuple.src.l3num, ports[i]);
+				ports_c = i;
 				nf_conntrack_sip_fini();
 				return ret;
 			}
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index 47239fb..6d9c441 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -142,6 +142,7 @@ static int __init nf_conntrack_tftp_init(void)
 			if (ret) {
 				pr_err("failed to register helper for pf: %u port: %u\n",
 				       tftp[i][j].tuple.src.l3num, ports[i]);
+				ports_c = i;
 				nf_conntrack_tftp_fini();
 				return ret;
 			}
-- 
2.7.4

