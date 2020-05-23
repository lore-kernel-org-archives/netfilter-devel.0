Return-Path: <SRS0=NxHY=7F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3CC9C433E0
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 May 2020 11:25:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BBB42065F
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 May 2020 11:25:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="V+dkf8eR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730372AbgEWLZj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 23 May 2020 07:25:39 -0400
Received: from mail-eopbgr00094.outbound.protection.outlook.com ([40.107.0.94]:45558
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728749AbgEWLZi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 23 May 2020 07:25:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DsGgVISuB0wqmZwJ4uTpO+wwN6L7VO/PqvY0TdRiryLrV/dW2nrW0q0etTU7ayh3wR0HQYVnYOWGklsshCfWBbqwvWkMdcYIEl23Z1xNWLO0cxSZ80QlLUd6z4BOkIGv3ikk4TVdXVDyvjcAbPbDKMqZOy0er+fgekj9TkpuwCQYWQFZqeTbmmUGJ97UQtXAGXvcwJ1aPCkA8s/ACMPg/fXY/zEPasHscdUZgfTQgHqP+/DvxYcYKaeLOLWvrX358E52v0+VXU9xHEeKSvCeViwqnsoPzOm2Srh0PIEi7e9HFmaShOAWPck7lW/VwlNwcGFikKaLic73zj+XhVga6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eaagAqJfUSlEgkkXsHVYXoyVXzm6u4xAe23ojw+UUkY=;
 b=WptWMv2tQR7ExUxEFW9cSP9bCDqjwReHr8XTxHY1VOM7qFIlBCOEWNXfiMd+FD0VapA+1ZU4lnCU1MBVnWDsu81lOxtFw4T7Wo4uhf54z2r7UfYyv1cIIFZ6S41GTO9x7HHY44XVG8Krr4UUYqNhSg3UXDqI+gK8s1MY4Du1OBpHcBgjPdSHZwo4Pm+fifP1cQsygXP4WbahUojWZdLRRiA322jTphKT7SVAj+ct8UrN1LNc8Puke30TGCsIxcZNFTaHd7/BS/kFFndSHaIYQgcunGHMeC/E9o5eoWSn6q0txxV1rMo3f9RwzanRkTBlvMrSur+Z0P+5CTISwGaBqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eaagAqJfUSlEgkkXsHVYXoyVXzm6u4xAe23ojw+UUkY=;
 b=V+dkf8eR660xemXtRfTyrlm8gfvFdFGkWVuOkICDjLOwo8KeavJsRAIw+7NEVk/IyGONBS9TyGf6p4F1t/WE7dnpMZZBcqIJ/rRxNGJd8qafvHyTYDJERktACp2r9FiBX9GrE5NxT/70kevjpgpjEfUHwQOyE0RvQMpiJFW5wEw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=voleatech.de;
Received: from AM0PR05MB5156.eurprd05.prod.outlook.com (2603:10a6:208:f7::19)
 by AM0PR05MB6465.eurprd05.prod.outlook.com (2603:10a6:208:141::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.26; Sat, 23 May
 2020 11:25:34 +0000
Received: from AM0PR05MB5156.eurprd05.prod.outlook.com
 ([fe80::d991:635:a94b:687b]) by AM0PR05MB5156.eurprd05.prod.outlook.com
 ([fe80::d991:635:a94b:687b%4]) with mapi id 15.20.3000.033; Sat, 23 May 2020
 11:25:34 +0000
Date:   Sat, 23 May 2020 13:25:33 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org
Subject: [PATCH 1/1] Remove flow offload when ct is removed from userspace
Message-ID: <20200523112533.zocclvnhlx23qhph@SvensMacBookAir.sven.lan>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: AM4PR0701CA0008.eurprd07.prod.outlook.com
 (2603:10a6:200:42::18) To AM0PR05MB5156.eurprd05.prod.outlook.com
 (2603:10a6:208:f7::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacBookAir.sven.lan (78.43.2.70) by AM4PR0701CA0008.eurprd07.prod.outlook.com (2603:10a6:200:42::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.8 via Frontend Transport; Sat, 23 May 2020 11:25:34 +0000
X-Originating-IP: [78.43.2.70]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98be5fe7-8b0a-4313-baac-08d7ff0c029b
X-MS-TrafficTypeDiagnostic: AM0PR05MB6465:
X-Microsoft-Antispam-PRVS: <AM0PR05MB646505DA5801F576E70D40E5EFB50@AM0PR05MB6465.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 0412A98A59
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8ON9JiDYQy60gvmDvZqH/W7fBubKZ5H7OfppdLf/7BRskdAu342PstZi6VqMsez8jC/RhCW7+I+PsYke9/qNdOAs7k6c6JZ7RluI/Dv60KlOblihgh+WuO9x4miYrhzPZB8K4+g7hcezw0tpgLoW7PKbh4qGyFHJF7nPJuYLI9HIqBiCU/l7ssHy8/GK0ByVRt74h/IOAjKLRbI0DHKQUlY2Fe1gy5td/nRPDXnOtmM8cEYYJtNGeXG1sQLQ7PYyJj6qbZGmR/HpgctDcIsXjw2zrmVinGFt3ClPsdvQ7Sw0lzm9DtjCx2AnBTf6gF3j
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5156.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(39830400003)(366004)(396003)(136003)(16526019)(44832011)(52116002)(66556008)(7696005)(5660300002)(6506007)(6916009)(26005)(8936002)(186003)(55016002)(66946007)(8676002)(9686003)(66476007)(1076003)(956004)(508600001)(86362001)(4326008)(316002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: H+0Neyxv4lSrZJntbye9/nuL6jv0dHsfLaClwMgtgr+OjNPmvhUpvE+W1Z8cYviYKpTrVeEu+MIBzvQJjQidTIqbWJymEYd3COsSe7T7CAZQeETBzPZF5jI54S7SX8TqZgNP8VYIOpdgy3ztl4Me5xpYKfvOF/34/cMgqp1pDGZ2xBrNhhpIUdGaZMZddNeQmcIad6G++WH5gZoYw/tjcSGdNnOOKEp9eLHAkctb7tgNE2Wrvz0ON1DkkohlHSjLb9seLOfmKctd7y9vXXOD1WRHzOo/sDWYhbQNRdEFwqZ/L4ZDrn5LKyXq/qlrinsCmukMfq9axfg/zzIQZwN276ge2jWyK3UzpS9M8SPmGFv1vMhxMyYlbRaLPrmwsz/ofXzwgTjQY2ENrsDE14wVLms525T5u0ouJv6Y3Gk+NyaBFYknXzyg7mJxVwYriW0v88aZEg5quhvyEZzXDpvspgeox62H7vvhHFijcR23fLE=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 98be5fe7-8b0a-4313-baac-08d7ff0c029b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2020 11:25:34.6983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KTlNWilbZMOEn1v+/k8GAUecNSBjSN0KoJXtAxrdbD1VLcPybObPRldDb2NvKLsCL3cGf1k1mLwPVgEpZoMcAAQnHAuoRB9oZ2jzuhfOpdM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6465
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When a ct is removed from user space through a netlink
message it currently returns an error. This
effectively makes a flow undeleteable from user space.

This causes issues when for example the interface IP changes
when using DHCP since the flow has SNAT and DNAT information
attached that are now not updated.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
---
 include/net/netfilter/nf_flow_table.h |  2 ++
 net/netfilter/nf_conntrack_netlink.c  | 10 ++++++++++
 net/netfilter/nf_flow_table_core.c    | 24 ++++++++++++++++++++++++
 3 files changed, 36 insertions(+)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index c54a7f707e50..51e300e30e62 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -177,6 +177,8 @@ struct flow_offload_tuple_rhash *flow_offload_lookup(struct nf_flowtable *flow_t
 						     struct flow_offload_tuple *tuple);
 void nf_flow_table_cleanup(struct net_device *dev);
 
+void nf_flow_table_ct_remove(struct nf_conn *ct);
+
 int nf_flow_table_init(struct nf_flowtable *flow_table);
 void nf_flow_table_free(struct nf_flowtable *flow_table);
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 9ddfcd002d3b..0048a2b597a0 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -51,6 +51,10 @@
 #include <net/netfilter/nf_nat_helper.h>
 #endif
 
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE_INET)
+#include <net/netfilter/nf_flow_table.h>
+#endif
+
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_conntrack.h>
 
@@ -1310,8 +1314,14 @@ static int ctnetlink_del_conntrack(struct net *net, struct sock *ctnl,
 	ct = nf_ct_tuplehash_to_ctrack(h);
 
 	if (test_bit(IPS_OFFLOAD_BIT, &ct->status)) {
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE_INET)
+		nf_flow_table_ct_remove(ct);
+		nf_ct_put(ct);
+		return 0;
+#else
 		nf_ct_put(ct);
 		return -EBUSY;
+#endif
 	}
 
 	if (cda[CTA_ID]) {
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 42da6e337276..9660448ca2d3 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -607,6 +607,30 @@ void nf_flow_table_cleanup(struct net_device *dev)
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_cleanup);
 
+static void nf_flow_offload_ct_remove_step(struct flow_offload *flow,
+					   void *data)
+{
+	struct nf_conn *ct = data;
+
+	if (ct == flow->ct)
+		set_bit(NF_FLOW_TEARDOWN, &flow->flags);
+}
+
+void nf_flow_table_ct_remove(struct nf_conn *ct)
+{
+	struct nf_flowtable *flow_table;
+
+	if (!test_bit(IPS_OFFLOAD_BIT, &ct->status))
+		return;
+
+	list_for_each_entry(flow_table, &flowtables, list) {
+		nf_flow_table_iterate(flow_table,
+				      nf_flow_offload_ct_remove_step,
+				      ct);
+	}
+}
+EXPORT_SYMBOL_GPL(nf_flow_table_ct_remove);
+
 void nf_flow_table_free(struct nf_flowtable *flow_table)
 {
 	mutex_lock(&flowtable_lock);
-- 
2.20.1

