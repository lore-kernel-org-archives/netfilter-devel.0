Return-Path: <SRS0=KLq8=R3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED61CC43381
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 Mar 2019 14:23:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D607222EC
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 Mar 2019 14:23:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=darbyshire-bryant.me.uk header.i=@darbyshire-bryant.me.uk header.b="CrrkPETX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbfCXOXg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 24 Mar 2019 10:23:36 -0400
Received: from mail-eopbgr10081.outbound.protection.outlook.com ([40.107.1.81]:9605
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726317AbfCXOXg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 24 Mar 2019 10:23:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=darbyshire-bryant.me.uk; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3hF2xU0UQC4o5AFfeK2KiJIc6Q/5Sm9fG9fLqQR2wnc=;
 b=CrrkPETXmFDvMZea/YnkegLPHMDCtL34gAn1jss7H83Jrvr1bmC0ekbkcKLrU99gfZo0RJIAliZ8+iARxGycvYS++M7L1ZOlGQo5tTmjHMlhBBZdtp32x1Q+O4wpGIvyAIUt+s2kqwTG2DfatI4xPkcC+Y1ymfEBvm4dAo1ljdM=
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com (10.171.105.143) by
 VI1PR0302MB2590.eurprd03.prod.outlook.com (10.171.104.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.16; Sun, 24 Mar 2019 14:23:31 +0000
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::a8fc:70f:5750:d2d8]) by VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::a8fc:70f:5750:d2d8%9]) with mapi id 15.20.1730.019; Sun, 24 Mar 2019
 14:23:31 +0000
From:   Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
CC:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [RFC PATCH 0/1] netfilter: xt_connmark: add savedscp-mark action
Thread-Topic: [RFC PATCH 0/1] netfilter: xt_connmark: add savedscp-mark action
Thread-Index: AQHU4k0nLi7DQydOI0CztlwWAyskYQ==
Date:   Sun, 24 Mar 2019 14:23:31 +0000
Message-ID: <20190324142314.92539-1-ldir@darbyshire-bryant.me.uk>
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
x-ms-office365-filtering-correlation-id: aa5d4acd-8383-4a64-dfbb-08d6b0644a16
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:VI1PR0302MB2590;
x-ms-traffictypediagnostic: VI1PR0302MB2590:
x-microsoft-antispam-prvs: <VI1PR0302MB25907488EDC6792D56C847E8C95D0@VI1PR0302MB2590.eurprd03.prod.outlook.com>
x-forefront-prvs: 09860C2161
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(136003)(376002)(396003)(39830400003)(346002)(366004)(199004)(189003)(2351001)(486006)(105586002)(186003)(2616005)(5640700003)(68736007)(2906002)(106356001)(6486002)(50226002)(6436002)(2501003)(97736004)(256004)(74482002)(81166006)(8676002)(81156014)(53936002)(5024004)(14444005)(46003)(71200400001)(71190400001)(476003)(107886003)(6512007)(316002)(99286004)(25786009)(6506007)(386003)(86362001)(7736002)(52116002)(4326008)(14454004)(66574012)(1076003)(508600001)(6116002)(6916009)(5660300002)(8936002)(102836004)(36756003)(305945005)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0302MB2590;H:VI1PR0302MB2750.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: darbyshire-bryant.me.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rY7sUvh3Nn2O5XdkYUW7gIvropuQxMd7p/6GCMQxFMjHUBUCU5Pw2tOE6nZ8fKZhUemV3XagK2Uysxo8Kfwhm9m+UuPkL6+A1ah1etxm0tdw+HdiJA3oGwFrE/upqey0P7fbZoYf4/ShzEgE9kyVpvEshnx0JWykkdfKpFY4vwjmEDA4TR8FAhqxjC/vx1w/KquZBVWl23r77MfkgjoKOgrS8kYpB7wwyO5GbcqKo9sF7EyrfTWGEDsd9Bde1elAoym1cJ58bHmfuPpr+MaYY34FU2VsVB6YS2MsZfd6CkXKd0BVwWEmL3gbuWPmJlUzZnWkCUWraJGFbxeTKdtR86bknS7sStypopOlR8/VVQ/lmlCqhrpY/2OsXJIZnIfXzhv8PEtpmFUqkHqrfhelQ2fZxENi+fYdMA8fBWlSwA0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: darbyshire-bryant.me.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: aa5d4acd-8383-4a64-dfbb-08d6b0644a16
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2019 14:23:31.3941
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9151708b-c553-406f-8e56-694f435154a4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB2590
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

What-ho Chaps!

With nervousness and trepidation I'm submitting the attached RFC patch
for an extension to 'connmark'.

savedscp-mark is designed to copy DSCPs to conntrack marks and is
intended to be used with a tc filter based companion action currently in
the process of being submitted called 'conndscp'.  The TC people are ok
with extracting information from conntrack connmarks but are much less
keen on TC changing those marks.  Hence the requirement to split the
functionality across two subsystems 'tc' & 'netfilter'.

At this stage I'm primarily interested in whether an extension to
xt_connmark that writes DSCP to conntrack marks for late use/pickup by a
tc filter is acceptable in terms of concept.

The feature is intended for use and has been found useful for restoring
ingress classifications based on egress classifications across links
that bleach or otherwise change DSCP, typically home ISP Internet links.
Restoring DSCP on ingress on the WAN link allows qdiscs such as CAKE to
shape inbound packets according to policies that are easier to implement
on egress.

Ingress classification is traditionally a challenging task since
iptables rules haven't yet run and tc filter/eBPF programs are pre-NAT
lookups, hence are unable to see internal IPv4 addresses as used on the
typical home masquerading gateway, hence the efforts in trying to
restore a classification on ingress based on a classification made on
egress.


x_tables CONNMARK with the new savedscp action solves the problem of
storing the DSCP to the conntrack mark.
   =20
It accepts 2 parameters.  The mark is a 32bit value with usually one
bit set.  This bit is set when savedscp saves the DSCP to the mark.
This is useful to implement a 'one shot'
iptables based classification where the 'complicated' iptables rules are
only run once to classify the connection on initial (egress) packet and
subsequent packets are all marked/restored with the same DSCP.  A mark
of zero disables the setting of a status bit/s.
   =20
The mask is a 32bit value of at least 6 contiguous bits and represents
the area where the DSCP will be stored.
   =20
e.g.
   =20
iptables -A QOS_MARK_eth0 -t mangle -j CONNMARK --savedscp-mark \
0x01000000/0xfc000000


A typical example of using savedscp-mark to store DSCP values for use
with a tc conndscp & hence qdisc (e.g. CAKE) is shown below, using top 6
bits to store the DSCP and the bottom bit of top byte as the state flag.

#iptables rules using the statemask flag to only do it once

iptables -t mangle -N QOS_MARK_eth0

iptables -t mangle -A QOS_MARK_eth0 -m set --match-set Bulk4  dst -j DSCP \
--set-dscp-class CS1 -m comment --comment "Bulk CS1 ipset"
#add more rules similar to above as required
#save the DSCP into conntrack mark & set the 'marked' bit
iptables -t mangle -A QOS_MARK_eth0 -t mangle -j CONNMARK --savedscp-mark 0=
x01000000/0xfc000000

# send unmarked packets to the marking chain=20
iptables -t mangle -A POSTROUTING -o eth0 -m connmark --mark 0x00000000/0x0=
1000000 -g QOS_MARK_eth0



I am not a full time programmer in any language, xt_connmark &
tc/conndscp represent something of the order of a 3 week struggle, my C
is awful, kernel & network knowledge worse, though I like to think
improving.  There are no doubt issues with this patch/feature but I hope
constructive feedback, quite possibly in very short words for my simple
brain, will knock it into shape.

More importantly is the 'connmark --savedscp-mark' concept fatally
flawed in some way that it cannot be made acceptable?

Your time, comments & guidance appreciated.


Kevin Darbyshire-Bryant (1):
  netfilter: connmark: introduce savedscp

 include/uapi/linux/netfilter/xt_connmark.h |  3 ++-
 net/netfilter/xt_connmark.c                | 30 ++++++++++++++++++++++
 2 files changed, 32 insertions(+), 1 deletion(-)

--=20
2.17.2 (Apple Git-113)

