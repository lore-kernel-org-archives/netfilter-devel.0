Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FA3DC4361B
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Dec 2020 14:54:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11406233E2
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Dec 2020 14:54:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbgLQOyL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Dec 2020 09:54:11 -0500
Received: from mail-eopbgr00136.outbound.protection.outlook.com ([40.107.0.136]:47585
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726983AbgLQOyK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Dec 2020 09:54:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eMigBLz+vMZIaw8VxCtkHL8GvUvgQkrDSIQtPtsNMMhHNVigMI8GqpTh2bXhiTuPvfQWBlwm0i4lwq4bOFaYWBm4oITOVVysYBfmqEbj6xKd/syYnEDSgDpOwUtThnLUEdYwds5HqGppWLXocCNeLCSvv/oj6rf1D1yF+rhWGKe4p+sLApxp1Giy7XaHMTtd3fPf5uFfZdlk4B0HLnh00OXCRaW7f97Cq6pxcINxWbnaE+APGvk4Ur2zqva50INYeW/rjwA4OMd3BbP3G8n4tMRXOpqahhdZRBR0SUNPWOyeeVItcO6zGgA+8oDTs5zsVF1nJf2CZnJAsALkqGN6Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0HbkqhjkZRl9ii/uVdgVBd9Xfd+Ia/D3eqPz0QwIXcE=;
 b=VbMUvcW/HFv3C9gClfLS+S1oEAomezSIa5RTlI0zC5Y3WNAFUn1UnR9H80UNioesSHgzWpl7sZU6qeWY2jtkbMl53qtbGZTSeUhmy9MhY6vSINNRTl1xEhCFyfuQnz/ELCZPo2XlsyASv/Ya091B4eT1b8hHdhArOaJkHx96Vj256yZ9ESpOe892JiiD4vV04BWB351V3J8gX5BhGQxdSKA51B05nfGGlu48G/OAc15th0/7ZMJ23zDmC+/xza5j+ED6Vs4MegCKSXvJV3uymhV1yCYVU6B7YXJG8mbXZzIw031DlKZ7V6KLzXAryexLQ2OLZTHFF9BjHFX8F/4k8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0HbkqhjkZRl9ii/uVdgVBd9Xfd+Ia/D3eqPz0QwIXcE=;
 b=EtDfTF1SYSL+C7J8KrOGUiX1v6MaiLddz7G/VtBjaP04583DUPH/sEnUOjBvs/4/XRdZxbDOO3YaCQN/5eMduppyLQPssUVIcX0bM/zoy4U7eXmyJBQ+jS19pNtJViVOsiB4nW51oqvR6+Bk0vOPG07nbMhBnpJ4G6pAAsrsSFQ=
Authentication-Results: googlegroups.com; dkim=none (message not signed)
 header.d=none;googlegroups.com; dmarc=none action=none
 header.from=virtuozzo.com;
Received: from VI1PR0801MB1678.eurprd08.prod.outlook.com
 (2603:10a6:800:51::23) by VI1PR08MB2848.eurprd08.prod.outlook.com
 (2603:10a6:802:23::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18; Thu, 17 Dec
 2020 14:53:20 +0000
Received: from VI1PR0801MB1678.eurprd08.prod.outlook.com
 ([fe80::b18d:c047:56c0:e0d3]) by VI1PR0801MB1678.eurprd08.prod.outlook.com
 ([fe80::b18d:c047:56c0:e0d3%9]) with mapi id 15.20.3654.024; Thu, 17 Dec 2020
 14:53:20 +0000
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v2] netfilter: ipset: fix shift-out-of-bounds in htable_bits()
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        syzkaller-bugs@googlegroups.com
References: <4d915d3a-6a95-7784-4057-2faa17a061@blackhole.kfki.hu>
Message-ID: <e954ad22-83dc-e553-37a3-f0adb11cebb2@virtuozzo.com>
Date:   Thu, 17 Dec 2020 17:53:18 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <4d915d3a-6a95-7784-4057-2faa17a061@blackhole.kfki.hu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [185.231.240.5]
X-ClientProxiedBy: AM8P190CA0012.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::17) To VI1PR0801MB1678.eurprd08.prod.outlook.com
 (2603:10a6:800:51::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.16.24.21] (185.231.240.5) by AM8P190CA0012.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:219::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 17 Dec 2020 14:53:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e61be43-32a6-45cf-ca7f-08d8a29b7ee7
X-MS-TrafficTypeDiagnostic: VI1PR08MB2848:
X-Microsoft-Antispam-PRVS: <VI1PR08MB28487605030F88D183881202AAC40@VI1PR08MB2848.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JDK20L60g2AegQj429QhaZlcItidyPG4nrQZPi5M0eNOqzmb8v2RX5+sl1AWnQ97R67TUsLgOS/1OgL2cPhUg4EvKaGbLkiLWXCMXteLKGKx2RaeSpz6IB/dKFYvxqbpEuquuf9VHJjtSI87kvGbTmzJQbmEm7OSMqaQQdGnKqXMx+bVkN1M+WgXdLzWGK2n8zBU07u2BW9iiNrDaQUbEgaeGgEZKtMT/mMfkbkeSUxX8jOOrAccJEejCdVzfJXMDUvFn3ZFmLt3jqQ38YIAkr1wF1CfaiOZc0dVNEa/40jJRPSErFb7zY4aB6phNbrJ1PU85QxVlcO9HlVYTelGo8MxE4Z/o/bz7Q0g7ocFl9+5HGGNZLGvrd8WxJ4yU/mdwv2qGLG9g06VDiXkEIRGlndZfZBzMU29xDDXOscvihw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0801MB1678.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(346002)(396003)(39840400004)(316002)(31696002)(66476007)(5660300002)(66946007)(66556008)(8936002)(6486002)(16576012)(54906003)(36756003)(186003)(956004)(2616005)(31686004)(110136005)(8676002)(4326008)(478600001)(86362001)(16526019)(2906002)(26005)(52116002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?M3BaNlBIMno1eko0NTBjMW9VT2ltb05VUmZERmpXM1NnNnl3ZlBTNDNVOWtC?=
 =?utf-8?B?cW14KzZXSWNXeDB1N1llYlc4UWRCSUNQblVBNHdQTnJldENMNkg4eWYzN2tn?=
 =?utf-8?B?bFEzS1ZLZmsyVG1TWnVSWElQZkhmZFNWZUdRZHdpYnFDR1lYbGdEZm5uVG9m?=
 =?utf-8?B?eGpiSjlLL3M0aU1ISklQcWlQNCtRcE15SmVBRDlldEVLRWNjVG0yRlB2L1hi?=
 =?utf-8?B?Zjlna1V5WDhPTFZjTVBBcTdHVTdFczIrdTExM3dyRklDWTBwQXcyRHBQY3BP?=
 =?utf-8?B?Nk9lejhOeDFRR2dnbHl0dWp1a2Vzb2JUSDIyb2FuWUJVc29xYXJXM0pLcFZQ?=
 =?utf-8?B?TVVmckFNdTRkbVdVY0s1eE1MSFVJWU9WbEw1MU9NaHVPZk45ZXYvMWlXQ2pI?=
 =?utf-8?B?MFV1R05VUFJWNWxCV2J1VFJkZXR3T1dBNVFaenZoT0dQL0M3N2d6OGE5eEdn?=
 =?utf-8?B?UktjRHlEcDFZVzcveDlJY3gvSmxtbmkzOG5PY2NKSGc0SGpsV2NDRSt3K0tE?=
 =?utf-8?B?UHZySFBMSUNZQzlYdjNTZWVienNab2JsUzhlME5KSUpwcTZrVmlpME1lU1ds?=
 =?utf-8?B?QmZMVWtXWXJ6WlVOQXRIdWZRY3FSZ2Uzc2NaMVNEK3g0VjlEMGhjb3o3UEtG?=
 =?utf-8?B?bzdCbTU3SkFhcGdNNERVT3NGRVN0Q0llcGVEZytiS2x3SWJJYm1zbXFBUjdU?=
 =?utf-8?B?MVpOdjVPdVhDNmZQZytYMU9TMFVmRmVQY2FtWnFuVCtmbEwrOXFoQ1FwbG1H?=
 =?utf-8?B?UFlJd09wVU1LV25YbnpVd2RFb3dPQWJvZjE5ajg3YUdzcnk1dUk2SHB5dWZM?=
 =?utf-8?B?cU9vTG1sajI0U1pURkFraUJQTTVIemxGQUZ4eEV3OWpMYmJtVzNVcnhCSysr?=
 =?utf-8?B?ZlhpKzhYTFoxcUJudHllMDZpekIxMjd3R0tEWjJhbkFGdXlKNG8vMEFGZzgw?=
 =?utf-8?B?Qjdwaml6MW1ra0c5a2lIMElFcnl3ZlUzK1JGTCtBV0l2c1FnaTk1eGw1NTlm?=
 =?utf-8?B?Z0UzWkdnZmhJaC9JdWJZd3hneUFhN2xEZzJDVkRFbmZzZ3EvNlBOOGdvMzFz?=
 =?utf-8?B?NCszKzV3R0xTek9BQkxOVmx3TGR6L1R1OVNVYkY2ZXdFVHlRN25rL2h3VVRy?=
 =?utf-8?B?Mncyck5Cd0Z5L1NOcEVJNWoybHZQemJ4eU9tKzZWT0E2eFliK2xUZi92VjJM?=
 =?utf-8?B?MXMzVTEzQlBXVXhOaXhYMVpwL0lRdE9QNUEyTnFqNzhFMFdFUFJFWWV5cHF3?=
 =?utf-8?B?UXFFL2ZuNDE2cnBnTnZHbSt0T2NRNlhHSDY2Q2VIY0pWSkExMnV3dnI2TGN3?=
 =?utf-8?Q?QxF350dieEdf6Q8tvHD9uaaBeu0Spw+avf?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0801MB1678.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2020 14:53:20.4566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e61be43-32a6-45cf-ca7f-08d8a29b7ee7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wRBOCIPndesLCDhmEptGObozt0xn6Vp7vRiFWg9lxe/TFmEMs1tCDnr+fnQdmyV9YgTwRBGY+B1ASDJ78d2NnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB2848
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

htable_bits() can call jhash_size(32) and trigger shift-out-of-bounds

UBSAN: shift-out-of-bounds in net/netfilter/ipset/ip_set_hash_gen.h:151:6
shift exponent 32 is too large for 32-bit type 'unsigned int'
CPU: 0 PID: 8498 Comm: syz-executor519
 Not tainted 5.10.0-rc7-next-20201208-syzkaller #0
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
 __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:395
 htable_bits net/netfilter/ipset/ip_set_hash_gen.h:151 [inline]
 hash_mac_create.cold+0x58/0x9b net/netfilter/ipset/ip_set_hash_gen.h:1524
 ip_set_create+0x610/0x1380 net/netfilter/ipset/ip_set_core.c:1115
 nfnetlink_rcv_msg+0xecc/0x1180 net/netfilter/nfnetlink.c:252
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 nfnetlink_rcv+0x1ac/0x420 net/netfilter/nfnetlink.c:600
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x907/0xe40 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2345
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2399
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2432
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

This patch replaces htable_bits() by simple fls(hashsize - 1) call:
it alone returns valid nbits both for round and non-round hashsizes.
It is normal to set any nbits here because it is validated inside
following htable_size() call which returns 0 for nbits>31.

Fixes: 1feab10d7e6d("netfilter: ipset: Unified hash type generation")
Reported-by: syzbot+d66bfadebca46cf61a2b@syzkaller.appspotmail.com
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 521e970..7d01086 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -143,20 +143,6 @@ struct net_prefixes {
 	return hsize * sizeof(struct hbucket *) + sizeof(struct htable);
 }
 
-/* Compute htable_bits from the user input parameter hashsize */
-static u8
-htable_bits(u32 hashsize)
-{
-	/* Assume that hashsize == 2^htable_bits */
-	u8 bits = fls(hashsize - 1);
-
-	if (jhash_size(bits) != hashsize)
-		/* Round up to the first 2^n value */
-		bits = fls(hashsize);
-
-	return bits;
-}
-
 #ifdef IP_SET_HASH_WITH_NETS
 #if IPSET_NET_COUNT > 1
 #define __CIDR(cidr, i)		(cidr[i])
@@ -1520,7 +1506,11 @@ struct mtype_resize_ad {
 	if (!h)
 		return -ENOMEM;
 
-	hbits = htable_bits(hashsize);
+	/* Compute htable_bits from the user input parameter hashsize.
+	 * Assume that hashsize == 2^htable_bits,
+	 * otherwise round up to the first 2^n value.
+	 */
+	hbits = fls(hashsize - 1);
 	hsize = htable_size(hbits);
 	if (hsize == 0) {
 		kfree(h);
-- 
1.8.3.1

