From: Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH] iptables: extensions: Add/Remove the braces where necessary
Date: Fri, 31 Mar 2017 15:36:59 +0530
Message-ID: <20170331100659.GA21407@arushi-HP-Pavilion-Notebook>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33568 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932342AbdCaKHI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 Mar 2017 06:07:08 -0400
Received: by mail-pg0-f67.google.com with SMTP id 79so16233147pgf.0
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Mar 2017 03:07:07 -0700 (PDT)
Received: from arushi-HP-Pavilion-Notebook ([14.139.82.6])
        by smtp.gmail.com with ESMTPSA id z185sm9507241pfb.6.2017.03.31.03.07.04
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 31 Mar 2017 03:07:05 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

To follow the coding style of kernel the braces are removed/added and
placed properly, if not.

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
 extensions/libebt_802_3.c | 3 +--
 extensions/libebt_ip.c    | 5 ++---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/extensions/libebt_802_3.c b/extensions/libebt_802_3.c
index f05d02e..801fb51 100644
--- a/extensions/libebt_802_3.c
+++ b/extensions/libebt_802_3.c
@@ -111,8 +111,7 @@ static void br802_3_print(const void *ip, const struct xt_entry_match *match,
 	}
 }
 
-static struct xtables_match br802_3_match =
-{
+static struct xtables_match br802_3_match = {
 	.name		= "802_3",
 	.revision	= 0,
 	.version	= XTABLES_VERSION,
diff --git a/extensions/libebt_ip.c b/extensions/libebt_ip.c
index 6b301e2..5943120 100644
--- a/extensions/libebt_ip.c
+++ b/extensions/libebt_ip.c
@@ -274,11 +274,10 @@ static void brip_print(const void *ip, const struct xt_entry_match *match,
 		if (info->invflags & EBT_IP_PROTO)
 			printf("! ");
 		pe = getprotobynumber(info->protocol);
-		if (pe == NULL) {
+		if (pe == NULL)
 			printf("%d ", info->protocol);
-		} else {
+		else
 			printf("%s ", pe->p_name);
-		}
 	}
 	if (info->bitmask & EBT_IP_SPORT) {
 		printf("--ip-sport ");
-- 
2.11.0

