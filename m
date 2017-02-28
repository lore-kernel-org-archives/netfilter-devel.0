From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH lnfct 2/2] conntrack: revert getobjopt_is_nat condition
Date: Tue, 28 Feb 2017 14:00:41 +0900
Message-ID: <20170228050041.GC21582@gmail.com>
References: <20170228045359.GA21582@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: The netfilter developer mailinglist
        <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:32947 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751045AbdB1FJR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Feb 2017 00:09:17 -0500
Received: by mail-pf0-f194.google.com with SMTP id p185so242727pfb.0
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Feb 2017 21:09:15 -0800 (PST)
Received: from gmail.com (softbank218138040024.bbtec.net. [218.138.40.24])
        by smtp.gmail.com with ESMTPSA id o26sm898834pgd.25.2017.02.27.21.00.43
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Feb 2017 21:00:44 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20170228045359.GA21582@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>From 9e8aa4ed079b526faf190b69a2c1032f22776602 Mon Sep 17 00:00:00 2001
From: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
Date: Tue, 28 Feb 2017 11:34:29 +0900
Subject: [PATCH 2/2] conntrack: revert getobjopt_is_nat condition

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 src/conntrack/objopt.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/src/conntrack/objopt.c b/src/conntrack/objopt.c
index fb43d6c..1581480 100644
--- a/src/conntrack/objopt.c
+++ b/src/conntrack/objopt.c
@@ -144,10 +144,8 @@ int __setobjopt(struct nf_conntrack *ct, unsigned int option)
 
 static int getobjopt_is_snat(const struct nf_conntrack *ct)
 {
-	if (!(test_bit(ATTR_STATUS, ct->head.set)))
-		return 0;
-
-	if (!(ct->status & IPS_SRC_NAT_DONE))
+	if (test_bit(ATTR_STATUS, ct->head.set) &&
+	    !(ct->status & IPS_SRC_NAT_DONE))
 		return 0;
 
 	switch (ct->head.orig.l3protonum) {
@@ -166,10 +164,8 @@ static int getobjopt_is_snat(const struct nf_conntrack *ct)
 
 static int getobjopt_is_dnat(const struct nf_conntrack *ct)
 {
-	if (!(test_bit(ATTR_STATUS, ct->head.set)))
-		return 0;
-
-	if (!(ct->status & IPS_DST_NAT_DONE))
+	if (test_bit(ATTR_STATUS, ct->head.set) &&
+	    !(ct->status & IPS_DST_NAT_DONE))
 		return 0;
 
 	switch (ct->head.orig.l3protonum) {
-- 
2.11.0

