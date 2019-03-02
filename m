Return-Path: <SRS0=Sk6b=RF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74ADFC4360F
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:37:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3453920838
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:37:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbfCBShl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Mar 2019 13:37:41 -0500
Received: from mail.us.es ([193.147.175.20]:36396 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727219AbfCBShf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Mar 2019 13:37:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F0D491361B0
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:37:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DAFE4DA864
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:37:33 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CD1F2DA85D; Sat,  2 Mar 2019 19:37:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E720ADA796;
        Sat,  2 Mar 2019 19:37:31 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 02 Mar 2019 19:37:31 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.223.53])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 986C94265A2F;
        Sat,  2 Mar 2019 19:37:31 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 26/29] netfilter: xt_IDLETIMER: fix sysfs callback function type
Date:   Sat,  2 Mar 2019 19:37:17 +0100
Message-Id: <20190302183720.3220-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190302183720.3220-1-pablo@netfilter.org>
References: <20190302183720.3220-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Sami Tolvanen <samitolvanen@google.com>

Use struct device_attribute instead of struct idletimer_tg_attr, and
the correct callback function type to avoid indirect call mismatches
with Control Flow Integrity checking.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_IDLETIMER.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index eb4cbd244c3d..5f9b37e12801 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -41,19 +41,13 @@
 #include <linux/workqueue.h>
 #include <linux/sysfs.h>
 
-struct idletimer_tg_attr {
-	struct attribute attr;
-	ssize_t	(*show)(struct kobject *kobj,
-			struct attribute *attr, char *buf);
-};
-
 struct idletimer_tg {
 	struct list_head entry;
 	struct timer_list timer;
 	struct work_struct work;
 
 	struct kobject *kobj;
-	struct idletimer_tg_attr attr;
+	struct device_attribute attr;
 
 	unsigned int refcnt;
 };
@@ -76,15 +70,15 @@ struct idletimer_tg *__idletimer_tg_find_by_label(const char *label)
 	return NULL;
 }
 
-static ssize_t idletimer_tg_show(struct kobject *kobj, struct attribute *attr,
-				 char *buf)
+static ssize_t idletimer_tg_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
 {
 	struct idletimer_tg *timer;
 	unsigned long expires = 0;
 
 	mutex_lock(&list_mutex);
 
-	timer =	__idletimer_tg_find_by_label(attr->name);
+	timer =	__idletimer_tg_find_by_label(attr->attr.name);
 	if (timer)
 		expires = timer->timer.expires;
 
-- 
2.11.0


