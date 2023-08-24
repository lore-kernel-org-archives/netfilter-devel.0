Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D441FC7EE43
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Aug 2023 11:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241230AbjHXL47 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Aug 2023 07:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241290AbjHXL4s (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2023 07:56:48 -0400
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0395E198B;
        Thu, 24 Aug 2023 04:56:46 -0700 (PDT)
Received: from mg.bb.i.ssi.bg (localhost [127.0.0.1])
        by mg.bb.i.ssi.bg (Proxmox) with ESMTP id 91C0B9232;
        Thu, 24 Aug 2023 14:56:44 +0300 (EEST)
Received: from ink.ssi.bg (ink.ssi.bg [193.238.174.40])
        by mg.bb.i.ssi.bg (Proxmox) with ESMTPS id 795659231;
        Thu, 24 Aug 2023 14:56:44 +0300 (EEST)
Received: from ja.ssi.bg (unknown [213.16.62.126])
        by ink.ssi.bg (Postfix) with ESMTPSA id 55FB33C0325;
        Thu, 24 Aug 2023 14:56:42 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=ssi.bg; s=ink;
        t=1692878202; bh=DEFhqn/SUwHt36fsBBUJoTeVBuql/eCobbe3o7v28gY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=XQjAB+wUXA8RmxiQhrQ5hm6JSlPASZJWbJxmY3ak+nACy4E5wHv2iRKreS7FXhb/W
         CI0PRxAkt2syeqzLXzQc3L5paBoYt+JC6h8E9I3ULoXN5R8OxLy/eyCWVhpntEkX+L
         eRGbCTlpWgesvjcOXm6rEoOIXMfQuuTQ+lmvVrmc=
Received: from ja.home.ssi.bg (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.17.1) with ESMTP id 37OBsdrN061806;
        Thu, 24 Aug 2023 14:54:39 +0300
Received: (from root@localhost)
        by ja.home.ssi.bg (8.17.1/8.17.1/Submit) id 37OBsdlQ061805;
        Thu, 24 Aug 2023 14:54:39 +0300
From:   Julian Anastasov <ja@ssi.bg>
To:     stable@vger.kernel.org
Cc:     Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Junwei Hu <hujunwei4@huawei.com>,
        Sishuai Gong <sishuai.system@gmail.com>
Subject: [PATCH -stable,4.14.y,4.19.y 1/1] ipvs: Improve robustness to the ipvs sysctl
Date:   Thu, 24 Aug 2023 14:53:54 +0300
Message-ID: <20230824115354.61669-2-ja@ssi.bg>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230824115354.61669-1-ja@ssi.bg>
References: <2023082114-remix-cable-0852@gregkh>
 <20230824115354.61669-1-ja@ssi.bg>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Junwei Hu <hujunwei4@huawei.com>

The ipvs module parse the user buffer and save it to sysctl,
then check if the value is valid. invalid value occurs
over a period of time.
Here, I add a variable, struct ctl_table tmp, used to read
the value from the user buffer, and save only when it is valid.
I delete proc_do_sync_mode and use extra1/2 in table for the
proc_dointvec_minmax call.

Fixes: f73181c8288f ("ipvs: add support for sync threads")
Signed-off-by: Junwei Hu <hujunwei4@huawei.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
(cherry picked from commit 1b90af292e71b20d03b837d39406acfbdc5d4b2a)
[Julian: Backport by changing SYSCTL_ZERO/SYSCTL_ONE to zero/one]
Signed-off-by: Julian Anastasov <ja@ssi.bg>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 70 +++++++++++++++++-----------------
 1 file changed, 36 insertions(+), 34 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index ecc16d8c1cc3..4e78c2a6a3ca 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1648,6 +1648,7 @@ static int ip_vs_zero_all(struct netns_ipvs *ipvs)
 #ifdef CONFIG_SYSCTL
 
 static int zero;
+static int one = 1;
 static int three = 3;
 
 static int
@@ -1659,12 +1660,18 @@ proc_do_defense_mode(struct ctl_table *table, int write,
 	int val = *valp;
 	int rc;
 
-	rc = proc_dointvec(table, write, buffer, lenp, ppos);
+	struct ctl_table tmp = {
+		.data = &val,
+		.maxlen = sizeof(int),
+		.mode = table->mode,
+	};
+
+	rc = proc_dointvec(&tmp, write, buffer, lenp, ppos);
 	if (write && (*valp != val)) {
-		if ((*valp < 0) || (*valp > 3)) {
-			/* Restore the correct value */
-			*valp = val;
+		if (val < 0 || val > 3) {
+			rc = -EINVAL;
 		} else {
+			*valp = val;
 			update_defense_level(ipvs);
 		}
 	}
@@ -1678,33 +1685,20 @@ proc_do_sync_threshold(struct ctl_table *table, int write,
 	int *valp = table->data;
 	int val[2];
 	int rc;
+	struct ctl_table tmp = {
+		.data = &val,
+		.maxlen = table->maxlen,
+		.mode = table->mode,
+	};
 
-	/* backup the value first */
 	memcpy(val, valp, sizeof(val));
-
-	rc = proc_dointvec(table, write, buffer, lenp, ppos);
-	if (write && (valp[0] < 0 || valp[1] < 0 ||
-	    (valp[0] >= valp[1] && valp[1]))) {
-		/* Restore the correct value */
-		memcpy(valp, val, sizeof(val));
-	}
-	return rc;
-}
-
-static int
-proc_do_sync_mode(struct ctl_table *table, int write,
-		     void __user *buffer, size_t *lenp, loff_t *ppos)
-{
-	int *valp = table->data;
-	int val = *valp;
-	int rc;
-
-	rc = proc_dointvec(table, write, buffer, lenp, ppos);
-	if (write && (*valp != val)) {
-		if ((*valp < 0) || (*valp > 1)) {
-			/* Restore the correct value */
-			*valp = val;
-		}
+	rc = proc_dointvec(&tmp, write, buffer, lenp, ppos);
+	if (write) {
+		if (val[0] < 0 || val[1] < 0 ||
+		    (val[0] >= val[1] && val[1]))
+			rc = -EINVAL;
+		else
+			memcpy(valp, val, sizeof(val));
 	}
 	return rc;
 }
@@ -1717,12 +1711,18 @@ proc_do_sync_ports(struct ctl_table *table, int write,
 	int val = *valp;
 	int rc;
 
-	rc = proc_dointvec(table, write, buffer, lenp, ppos);
+	struct ctl_table tmp = {
+		.data = &val,
+		.maxlen = sizeof(int),
+		.mode = table->mode,
+	};
+
+	rc = proc_dointvec(&tmp, write, buffer, lenp, ppos);
 	if (write && (*valp != val)) {
-		if (*valp < 1 || !is_power_of_2(*valp)) {
-			/* Restore the correct value */
+		if (val < 1 || !is_power_of_2(val))
+			rc = -EINVAL;
+		else
 			*valp = val;
-		}
 	}
 	return rc;
 }
@@ -1782,7 +1782,9 @@ static struct ctl_table vs_vars[] = {
 		.procname	= "sync_version",
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_do_sync_mode,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
 	},
 	{
 		.procname	= "sync_ports",
-- 
2.41.0


