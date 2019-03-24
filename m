Return-Path: <SRS0=KLq8=R3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0862DC43381
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 Mar 2019 14:23:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1B54222EC
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 Mar 2019 14:23:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=darbyshire-bryant.me.uk header.i=@darbyshire-bryant.me.uk header.b="j2CaG/+O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbfCXOXt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 24 Mar 2019 10:23:49 -0400
Received: from mail-eopbgr10040.outbound.protection.outlook.com ([40.107.1.40]:55364
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726317AbfCXOXt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 24 Mar 2019 10:23:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=darbyshire-bryant.me.uk; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CHftDF4w5RCnOXzXChHBG1D+N/F+aXgMPUNBVgoJQ9g=;
 b=j2CaG/+OnRIWUvVcBGv+/n9fLAwhNw8I7M+ZUOPlUTNXoBm5kF7NWFt+3NOWZPlmtrhZwyjVK9BCoy3uYYWPMiV2/Cbje3iaAOqw6wx/VWel5x8wOjWzOIIFIHfRKArfjij5zfHZXHYQZHU3qTwM+NlBGwkfm7aipD9UzYKhnQU=
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com (10.171.105.143) by
 VI1PR0302MB2590.eurprd03.prod.outlook.com (10.171.104.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.16; Sun, 24 Mar 2019 14:23:45 +0000
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::a8fc:70f:5750:d2d8]) by VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::a8fc:70f:5750:d2d8%9]) with mapi id 15.20.1730.019; Sun, 24 Mar 2019
 14:23:45 +0000
From:   Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
CC:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [PATCH 1/1] netfilter: connmark: introduce savedscp
Thread-Topic: [PATCH 1/1] netfilter: connmark: introduce savedscp
Thread-Index: AQHU4k0wbxhUbO7O10G3RjU1k8f4WQ==
Date:   Sun, 24 Mar 2019 14:23:45 +0000
Message-ID: <20190324142314.92539-2-ldir@darbyshire-bryant.me.uk>
References: <20190324142314.92539-1-ldir@darbyshire-bryant.me.uk>
In-Reply-To: <20190324142314.92539-1-ldir@darbyshire-bryant.me.uk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR0501CA0012.eurprd05.prod.outlook.com
 (2603:10a6:800:92::22) To VI1PR0302MB2750.eurprd03.prod.outlook.com
 (2603:10a6:800:e2::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ldir@darbyshire-bryant.me.uk; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.2 (Apple Git-113)
x-originating-ip: [2a02:c7f:1240:ee00::dc83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 47dda4d4-2fd9-43ca-af9b-08d6b0645278
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:VI1PR0302MB2590;
x-ms-traffictypediagnostic: VI1PR0302MB2590:
x-microsoft-antispam-prvs: <VI1PR0302MB2590DA2640E80028626F555DC95D0@VI1PR0302MB2590.eurprd03.prod.outlook.com>
x-forefront-prvs: 09860C2161
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(396003)(39830400003)(346002)(366004)(199004)(189003)(2351001)(486006)(105586002)(186003)(11346002)(446003)(2616005)(5640700003)(68736007)(2906002)(106356001)(6486002)(50226002)(6436002)(2501003)(97736004)(256004)(74482002)(81166006)(8676002)(81156014)(53936002)(14444005)(46003)(71200400001)(71190400001)(476003)(107886003)(6512007)(316002)(99286004)(25786009)(6506007)(386003)(86362001)(7736002)(52116002)(76176011)(4326008)(14454004)(1076003)(508600001)(6116002)(6916009)(5660300002)(8936002)(102836004)(36756003)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0302MB2590;H:VI1PR0302MB2750.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: darbyshire-bryant.me.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XEbe73hfa7RkvguUOzZqd7J9FQccNhYf/kiwbv88GyyFLbFU9rPhyB+BxeK7Q3bdAKcAo0yxAtfdp0ktj4nHTTXupKNYTzOY8d6EtT3fzZ4w+nJQCRfpXARPjqmwVD8kR6Gt3OwvZFyKSsEeJi/CGHZ+8uwxeUWUGs1V6c8qP1gZePHIUfNVWkaoUZlgjDEJcBkAVA9Ym89R8dgyGDPLbeS+gsSQkMRWw5GolJqtKlZxuJI+EVX3MrfHKm2U6OdoZsGUzrJGdXAU6oN9KVHI44BCWYRjXtRode2tTLGPArSgOplbdFMSkGdsw3W39rxwzZhZy+I77hxMITszmlDT1DEzLrlIjAlp2mUGBQPI9YWApmhJb5yymrN/8G2cn7kakPuW9DzNwlD+MiOh3BnKAZ5+N54i75mauQ7jtVdRfiM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: darbyshire-bryant.me.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: 47dda4d4-2fd9-43ca-af9b-08d6b0645278
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2019 14:23:45.3348
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9151708b-c553-406f-8e56-694f435154a4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB2590
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

savedscp is a method of storing the DSCP of an ip packet into conntrack
mark.  In combination with a suitable tc filter action (conndscp but may
end up being integrated into connmark) DSCP values are able to be stored
on egress and restored on ingress across links that otherwise alter or
bleach DSCP.

This is useful for qdiscs such as CAKE which are able to shape according
to policies based on DSCP.

Ingress classification is traditionally a challenging task since
iptables rules haven't yet run and tc filter/eBPF programs are pre-NAT
lookups, hence are unable to see internal IPv4 addresses as used on the
typical home masquerading gateway.

The ingress problem is solved by the tc filter, but the tc people didn't
like the idea of tc setting conntrack mark values, though they are ok
with reading conntrack values and hence restoring DSCP from conntrack
marks.

x_tables CONNMARK with the new savedscp action solves the problem of
storing the DSCP to the conntrack mark.

It accepts 2 parameters.  The mark is a 32bit value with usually one
bit set.  This bit is set when savedscp saves the DSCP to the mark.
This is useful to implement a 'one shot'
iptables based classification where the 'complicated' iptables rules are
only run once to classify the connection on initial (egress) packet and
subsequent packets are all marked/restored with the same DSCP.  A mark
of zero disables the setting of a status bit/s.

The mask is a 32bit value of at least 6 contiguous bits and represents
the area where the DSCP will be stored.

e.g.

iptables -A QOS_MARK_eth0 -t mangle -j CONNMARK --savedscp-mark 0x01000000/=
0xfc000000

Would store the DSCP in the top 6 bits of the 32bit mark field, and use
the LSB of the top byte as the 'DSCP has been stored' marker.

Signed-off-by: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
---
 include/uapi/linux/netfilter/xt_connmark.h |  3 ++-
 net/netfilter/xt_connmark.c                | 30 ++++++++++++++++++++++
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/xt_connmark.h b/include/uapi/linu=
x/netfilter/xt_connmark.h
index 1aa5c955ee1e..24272cac2d37 100644
--- a/include/uapi/linux/netfilter/xt_connmark.h
+++ b/include/uapi/linux/netfilter/xt_connmark.h
@@ -16,7 +16,8 @@
 enum {
 	XT_CONNMARK_SET =3D 0,
 	XT_CONNMARK_SAVE,
-	XT_CONNMARK_RESTORE
+	XT_CONNMARK_RESTORE,
+	XT_CONNMARK_SAVEDSCP
 };
=20
 enum {
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index 29c38aa7f726..de8dc707ac5b 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -42,6 +42,7 @@ connmark_tg_shift(struct sk_buff *skb, const struct xt_co=
nnmark_tginfo2 *info)
 	u_int32_t new_targetmark;
 	struct nf_conn *ct;
 	u_int32_t newmark;
+	u8 dscp;
=20
 	ct =3D nf_ct_get(skb, &ctinfo);
 	if (ct =3D=3D NULL)
@@ -74,6 +75,34 @@ connmark_tg_shift(struct sk_buff *skb, const struct xt_c=
onnmark_tginfo2 *info)
 			nf_conntrack_event_cache(IPCT_MARK, ct);
 		}
 		break;
+	case XT_CONNMARK_SAVEDSCP:
+		if (!info->ctmask)
+			goto out;
+
+		if (skb->protocol =3D=3D htons(ETH_P_IP)) {
+			if (skb->len < sizeof(struct iphdr))
+				goto out;
+
+			dscp =3D ipv4_get_dsfield(ip_hdr(skb)) >> 2;
+
+		} else if (skb->protocol =3D=3D htons(ETH_P_IPV6)) {
+			if (skb->len < sizeof(struct ipv6hdr))
+				goto out;
+
+			dscp =3D ipv6_get_dsfield(ipv6_hdr(skb)) >> 2;
+
+		} else { /* protocol doesn't have diffserv - get out! */
+			goto out;
+		}
+
+		newmark =3D (ct->mark & ~info->ctmask) ^
+			  (info->ctmark | (dscp << info->shift_bits));
+
+		if (ct->mark !=3D newmark) {
+			ct->mark =3D newmark;
+			nf_conntrack_event_cache(IPCT_MARK, ct);
+		}
+		break;
 	case XT_CONNMARK_RESTORE:
 		new_targetmark =3D (ct->mark & info->ctmask);
 		if (info->shift_dir =3D=3D D_SHIFT_RIGHT)
@@ -86,6 +115,7 @@ connmark_tg_shift(struct sk_buff *skb, const struct xt_c=
onnmark_tginfo2 *info)
 		skb->mark =3D newmark;
 		break;
 	}
+out:
 	return XT_CONTINUE;
 }
=20
--=20
2.17.2 (Apple Git-113)

