Return-Path: <SRS0=uYLw=7H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B02B3C433E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 May 2020 08:38:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 526A52070A
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 May 2020 08:38:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="oaD2e0Eb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387636AbgEYIiC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 May 2020 04:38:02 -0400
Received: from mail-db8eur05on2122.outbound.protection.outlook.com ([40.107.20.122]:23201
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731246AbgEYIiB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 May 2020 04:38:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O5bm4tj4/t+zR522K7KLob1LjznqfGdyhzSx9IXKkLP5psJUSOnzsAhTY7bSh4HYBOoDvg2gc0z2AfQZd4jc8tsPbXHCG5V0JUsqNdDDha4ioFkzIvCQv8mlyoU9T15dOotPo6ffRXOkXfChtz6y9jDKWEfphupU1wpt02L5zDMVSGV+bdEdu8MJT4EcELpC2fJzCdfG93VMrzmMlyQLaWwBndKlOugf/ihp+LDxs6ibb06EQC+LqzkRK/HhoRdtIduEr8YpTfUpfm1Rl2RHV2dGlbB/c9RCCKmHGWxVPM7LgBNI7wE1M7MkHbm2QLrvSvEqbZ9tmpDdfnvlPKo4Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tddABIH81Q3lSHh6F9lPFi74zzaH+IUHAVhQLrcJYM4=;
 b=DBfeWYolVUysPtF6DQ+6OfsiHMVClwXXo9ImN9pf5Xr2n/kJEAV9Cn2zZHJUzAiMgAmMJ0Xb3vhYDFhgCa+Lk7ZcBhO8G37k762Qw8ikCkvq7E7Nd+qWvl/CZaTGBj2eZdYhBp0CWE8efQL2fc9l0m/1U/QqRaPJvwJtIvAS2VpRgVWGiWwnG3wqMMtC4ogcEZxhm2+dwkzQzX38bxnadstIwFLMogwYeNNCGgxUaDi+D6iR5CRdnWWeSZNI4n1iyNmHLegBM77FOvY1H+6wBbgxeflO5KpW7o36A1w8i5mYVt8B04OwQ4MSdtkmMajkVw55P/hdSre+5rWfGpFddA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tddABIH81Q3lSHh6F9lPFi74zzaH+IUHAVhQLrcJYM4=;
 b=oaD2e0EbzMKan85c7X/A5qJ1o9kwjTbSx1I8pxZ2RSyZy6+B7n1phFfu5peCUIX71TumAR3mC6+iqG4nJAYaejl6x49GVoJuR8JZjltnEM2q1l79I0ddNHrGwI67YFSJkwuvOoXuKCZnaz+CrSkn+mdq3F06g54iR6C7Mi4QHmk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=virtuozzo.com;
Received: from HE1PR0802MB2218.eurprd08.prod.outlook.com (2603:10a6:3:c7::11)
 by HE1PR0802MB2345.eurprd08.prod.outlook.com (2603:10a6:3:ca::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 08:37:58 +0000
Received: from HE1PR0802MB2218.eurprd08.prod.outlook.com
 ([fe80::f4e4:ca6:29ff:b5b7]) by HE1PR0802MB2218.eurprd08.prod.outlook.com
 ([fe80::f4e4:ca6:29ff:b5b7%11]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 08:37:58 +0000
To:     netfilter-devel@vger.kernel.org
From:   Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: How to test the kernel netfilter logic?
Message-ID: <e925907a-475f-725e-a2b7-6b9d78b236d1@virtuozzo.com>
Date:   Mon, 25 May 2020 11:37:57 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.6.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR07CA0020.eurprd07.prod.outlook.com
 (2603:10a6:205:1::33) To HE1PR0802MB2218.eurprd08.prod.outlook.com
 (2603:10a6:3:c7::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from linux-e4ne.site (79.165.243.60) by AM4PR07CA0020.eurprd07.prod.outlook.com (2603:10a6:205:1::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.20.3045.13 via Frontend Transport; Mon, 25 May 2020 08:37:57 +0000
X-Originating-IP: [79.165.243.60]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d709b84-fe5b-4af8-b4b8-08d80086ed68
X-MS-TrafficTypeDiagnostic: HE1PR0802MB2345:
X-Microsoft-Antispam-PRVS: <HE1PR0802MB234590140C515E730A1EA75CC8B30@HE1PR0802MB2345.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0414DF926F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H6g7t7E19JXvEjNGffDZVFwjEDbJiys287/oYvo1rkRGHlEDUwZuY/hRoc1LCxJzQ1hWbTRXWzB6su3f0ZfMtKYsz4zooqOI/42IoG03SF4ZMcraXS8ldyPdJgGgzg3nAwZFKtbBvjt2/dSHqj0fZzwOXiUURfF8UrED7qZ6pGB7H7tZrFnWW/ZTFgndwTHYZSk9x3XpQuHJXrHegdy1z2odBTkB2Bel+lsNVDl3I1UPlwbmciVhoxUrBmXDDqhdJriUO9EMIsj2VvMO4X28HaM4FlnTtl2hHYZNa/bJYTEoU+1toUjl8KeACoLyCKbLkhlmjfFL1y66ZW3HEDvdz0UXEQT0xxJ3G8o0sgrVokN8+iO+iYsTj1FI85X3YRzO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0802MB2218.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39830400003)(396003)(346002)(376002)(366004)(136003)(66946007)(2906002)(66476007)(66556008)(6916009)(36756003)(8886007)(2616005)(8936002)(956004)(5660300002)(6512007)(16526019)(6506007)(186003)(4744005)(6486002)(26005)(478600001)(31696002)(86362001)(52116002)(31686004)(316002)(8676002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: KzgX+XRur6FGLuWqV6xmr365XmUxF0uxpP8cdKW0sqRx3OQotVcEtIGixKbHEDnYZWXSR0VlkkofqQc/M3KCY+KKQuUB5WainlgxfuqxkSW52TF7ZjYO8/E0eS9mUBtjwugLOvQUyzrufuXISXhmzfxnCZsPPTHgwZH7Vyv+Nm37IS0jkZJsDdOUPxNGGb0OQkSd91PSpMQyoiyJ7u4unfCf37eCXfM8Eiprh25QfumDgKzoAzC1M6T18WOpfh975Ei9k1534wTC3kaqZeFLNPsuvJn2K8zZ9VYY1DydGoWQkTULlsCc1yWOXP99WsWy+cCRqtwN4SrLq0LkJlNZ6dICftrQc/bCFaStKu6BuMAdZFb2ppiKdTjb/m5uXfZeEqhb9PXCOuS8QDiAfG9pLMnCvTSgfeshkJDuBFMNPRFU6ip9jQKX88wYe56Vs/+bZowAgyQFfDbKfYvIWQhKa3vW8SxVKn8PHoif2E8JFZw=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d709b84-fe5b-4af8-b4b8-08d80086ed68
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2020 08:37:58.4623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lGuoYGh49cw5k1Vxf0isNul8c3AGzk/OOv2umGdDDX/3h63TAXx2hQW+As5GnHM1JENVyMUOSCPnFJgMPuG4eQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2345
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

are there any tests for netfilter kernel logic?

i've taken a look at iptables and nftables repo,
there are a lot of tests, but all of them (if i see correctly)
are about loading/unloading rules, chains, etc,
but not actually checking that those rules work properly.

i mean i did not find tests which configure some rules,
then send traffic and check if the traffic is changed by the rule
in the expected way.

i understand that this is not userspace's work to process the traffic,
so i'd expect the tests somehow are bound to the kernel,
but did not find netfilter tests in kernel git repo as well.

Can you please help me?

Thank you in advance!

--
Best regards,

Konstantin Khorenko,
Virtuozzo Linux Kernel Team
