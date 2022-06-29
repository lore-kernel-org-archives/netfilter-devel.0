Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16CC5C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Jun 2022 21:21:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbiF2VVu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Jun 2022 17:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbiF2VVs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Jun 2022 17:21:48 -0400
X-Greylist: delayed 76 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 29 Jun 2022 14:21:47 PDT
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0A11A064
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jun 2022 14:21:47 -0700 (PDT)
Received: from pps.filterd (m0050095.ppops.net [127.0.0.1])
        by m0050095.ppops.net-00190b01. (8.17.1.5/8.17.1.5) with ESMTP id 25TKUEnS032045;
        Wed, 29 Jun 2022 22:21:41 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=jan2016.eng;
 bh=EEMKFfKFKc5h88yx6GJ5XjjaSLB7eJSVkypWhloPIac=;
 b=Lu9FGlrJcawjUe+0yExpLupBm4mYrZBM6fV3y0kGOGMyQjDLcoU3ETWWWxGphaQ7hy8o
 3vLGChsLR8cYKMqwwVMYEjkgsCef5zRPKAtYkjQtIx8EkJ86sFTMoXXF5UUcxgSPsSMX
 e0SS2soApsXIk5KgT66MdlJTJ+onfhAoV5Ir19erh7G+5yPZOnMj5MIrRHUT7KtsFOSN
 Y83CpH1huVGTYQlqkoqUKAR2BQhpbJvMPo+hpNhBfp7TFPgHe5Lt12Thwx8gspveuKk5
 KO2t9f58YMfY20PaUvy4NDVjo7cuTJ2BTevGZZ0K86UDsubf3HLFoV0BH6j+NlMI4SC3 Jg== 
Received: from prod-mail-ppoint6 (prod-mail-ppoint6.akamai.com [184.51.33.61] (may be forged))
        by m0050095.ppops.net-00190b01. (PPS) with ESMTPS id 3h035c5t5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Jun 2022 22:21:41 +0100
Received: from pps.filterd (prod-mail-ppoint6.akamai.com [127.0.0.1])
        by prod-mail-ppoint6.akamai.com (8.17.1.5/8.17.1.5) with ESMTP id 25TJDFfe002929;
        Wed, 29 Jun 2022 17:21:40 -0400
Received: from email.msg.corp.akamai.com ([172.27.91.22])
        by prod-mail-ppoint6.akamai.com (PPS) with ESMTPS id 3gwwpwy5r3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Jun 2022 17:21:39 -0400
Received: from usma1ex-dag4mb1.msg.corp.akamai.com (172.27.91.20) by
 usma1ex-dag4mb8.msg.corp.akamai.com (172.27.91.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Wed, 29 Jun 2022 17:21:39 -0400
Received: from bos-lhvuce.bos01.corp.akamai.com (172.28.220.70) by
 usma1ex-dag4mb1.msg.corp.akamai.com (172.27.91.20) with Microsoft SMTP Server
 id 15.2.986.26 via Frontend Transport; Wed, 29 Jun 2022 17:21:39 -0400
Received: by bos-lhvuce.bos01.corp.akamai.com (Postfix, from userid 35863)
        id 7D17D15F504; Wed, 29 Jun 2022 17:21:39 -0400 (EDT)
From:   Vishwanath Pai <vpai@akamai.com>
To:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>
CC:     Vishwanath Pai <vpai@akamai.com>, <johunt@akamai.com>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH] netfilter: ipset: ipset list may return wrong member count on bitmap types
Date:   Wed, 29 Jun 2022 17:21:07 -0400
Message-ID: <20220629212109.3045794-1-vpai@akamai.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-29_22,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 suspectscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206290074
X-Proofpoint-GUID: 5mdvLdJ6E9QU0vxl6Cfcs37gMhcrE2vc
X-Proofpoint-ORIG-GUID: 5mdvLdJ6E9QU0vxl6Cfcs37gMhcrE2vc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-29_22,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 malwarescore=0 adultscore=0 bulkscore=0
 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206290074
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We fixed a similar problem before in commit 7f4f7dd4417d ("netfilter:
ipset: ipset list may return wrong member count for set with timeout").
The same issue exists in ip_set_bitmap_gen.h as well.

Test case:

$ ipset create test bitmap:ip range 10.0.0.0/8 netmask 24 timeout 5
$ ipset add test 10.0.0.0
$ ipset add test 10.255.255.255
$ sleep 5s

$ ipset list test
Name: test
Type: bitmap:ip
Revision: 3
Header: range 10.0.0.0-10.255.255.255 netmask 24 timeout 5
Size in memory: 532568
References: 0
Number of entries: 2
Members:

We return "Number of entries: 2" but no members are listed. That is
because when we run mtype_head the garbage collector hasn't run yet, but
mtype_list checks and cleans up members with expired timeout. To avoid
this we can run mtype_expire before printing the number of elements in
mytype_head().

Reviewed-by: Joshua Hunt <johunt@akamai.com>
Signed-off-by: Vishwanath Pai <vpai@akamai.com>
---
 net/netfilter/ipset/ip_set_bitmap_gen.h | 46 ++++++++++++++++++-------
 1 file changed, 34 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index 26ab0e9612d8..dd871305bd6e 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -28,6 +28,7 @@
 #define mtype_del		IPSET_TOKEN(MTYPE, _del)
 #define mtype_list		IPSET_TOKEN(MTYPE, _list)
 #define mtype_gc		IPSET_TOKEN(MTYPE, _gc)
+#define mtype_expire		IPSET_TOKEN(MTYPE, _expire)
 #define mtype			MTYPE
 
 #define get_ext(set, map, id)	((map)->extensions + ((set)->dsize * (id)))
@@ -88,13 +89,44 @@ mtype_memsize(const struct mtype *map, size_t dsize)
 	       map->elements * dsize;
 }
 
+/* We should grab set->lock before calling this function */
+static void
+mtype_expire(struct ip_set *set)
+{
+	struct mtype *map = set->data;
+	void *x;
+	u32 id;
+
+	for (id = 0; id < map->elements; id++)
+		if (mtype_gc_test(id, map, set->dsize)) {
+			x = get_ext(set, map, id);
+			if (ip_set_timeout_expired(ext_timeout(x, set))) {
+				clear_bit(id, map->members);
+				ip_set_ext_destroy(set, x);
+				set->elements--;
+			}
+		}
+}
+
 static int
 mtype_head(struct ip_set *set, struct sk_buff *skb)
 {
 	const struct mtype *map = set->data;
 	struct nlattr *nested;
-	size_t memsize = mtype_memsize(map, set->dsize) + set->ext_size;
+	size_t memsize;
+
+	/* If any members have expired, set->elements will be wrong,
+	 * mytype_expire function will update it with the right count.
+	 * set->elements can still be incorrect in the case of a huge set
+	 * because elements can timeout during set->list().
+	 */
+	if (SET_WITH_TIMEOUT(set)) {
+		spin_lock_bh(&set->lock);
+		mtype_expire(set);
+		spin_unlock_bh(&set->lock);
+	}
 
+	memsize = mtype_memsize(map, set->dsize) + set->ext_size;
 	nested = nla_nest_start(skb, IPSET_ATTR_DATA);
 	if (!nested)
 		goto nla_put_failure;
@@ -266,22 +298,12 @@ mtype_gc(struct timer_list *t)
 {
 	struct mtype *map = from_timer(map, t, gc);
 	struct ip_set *set = map->set;
-	void *x;
-	u32 id;
 
 	/* We run parallel with other readers (test element)
 	 * but adding/deleting new entries is locked out
 	 */
 	spin_lock_bh(&set->lock);
-	for (id = 0; id < map->elements; id++)
-		if (mtype_gc_test(id, map, set->dsize)) {
-			x = get_ext(set, map, id);
-			if (ip_set_timeout_expired(ext_timeout(x, set))) {
-				clear_bit(id, map->members);
-				ip_set_ext_destroy(set, x);
-				set->elements--;
-			}
-		}
+	mtype_expire(set);
 	spin_unlock_bh(&set->lock);
 
 	map->gc.expires = jiffies + IPSET_GC_PERIOD(set->timeout) * HZ;
-- 
2.25.1

