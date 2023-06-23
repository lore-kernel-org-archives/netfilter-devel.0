Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AAC5EB64D7
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Jun 2023 07:18:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbjFWHSr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 23 Jun 2023 03:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbjFWHSq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Jun 2023 03:18:46 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3041DE7D;
        Fri, 23 Jun 2023 00:18:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ES9E18ysU18K8oZoHXTw3wx9QgTtPxPk52/gBtAGfV//WRKoop08dCvIElC5kfIN5NOaGb6b5TqczqcP13/y1Y/HJOeZPhkKMebeFGmkzblyimfHZbr01tPAUOmxIq2H5ayboOsGiure5/kgj0vD17xJ/6943Kjk2+/eb64Zr3AkeBWl0Oab3Iore4o6k8flZN2gXg3P6EbayShqP4VWpYHSoRHuY/2B0tcqFiUP/2ktfZfQ8kBYYFEFzDgXUNohzMTY1GKJb343w1pVEAH4kBTf3t2cR12mXTNDFkZL2Auqmr5eyyGiuDcWPjKyXYj1enaKw3EI1Y84D1XuK9DMrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D607K0RJRGtAUYTdf6Giac9sNtgB+HS0kIK7+fVqi3w=;
 b=mh/SsJvhfDaNkzmS0SpKdpR8MV7FOfeUN+qprYwS9cguvO2mkmHVd3bBAahjX4tvFcTi0HE36htCBL5Op1tdcmkL+QQFgD+5K9UTMrbaAeYUCubhk752KrM9t9hkp3oBEuFxEOBJM0RPvuK9tgN3h6uuYLb+G3Dw35hepTNkbPIjp6nYKRbKuHOnpnjsEKFdhf9CFIFor6PqAzfFSmDZLuXU5li5a2PkBRxa6AxeFHxoq4tkfyvNttiZ5itizYsqSitswWY3DIfYI+yASW6ZsOGVh7SiySjQnuhjMbZAw8xKXyV8gQSONPC1aSEXjeqMt/gAxKBg0yw946M9pEUzYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D607K0RJRGtAUYTdf6Giac9sNtgB+HS0kIK7+fVqi3w=;
 b=u36r4Ef1oJmk3UbUhuGMc9KS75Pa3aNa/HoVYLur7Mkbyzh9eTwXuM+eTdmY4dewXf9fCpUzdxjz+/zYgc/SdI6js6WS02EPNRrTADMPqAApxx1nAjt//guCb5D0mD6uYuXgcWqdmNr2nbziWLU7UPxEJvt0sBp6SwQtSHnBIQU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5983.namprd13.prod.outlook.com (2603:10b6:a03:43f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21; Fri, 23 Jun
 2023 07:18:41 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6521.023; Fri, 23 Jun 2023
 07:18:41 +0000
Date:   Fri, 23 Jun 2023 09:18:34 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next] linux/netfilter.h: fix kernel-doc warnings
Message-ID: <ZJVHSnGwfAxAwgLO@corigine.com>
References: <20230623061101.32513-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230623061101.32513-1-rdunlap@infradead.org>
X-ClientProxiedBy: AM0PR03CA0084.eurprd03.prod.outlook.com
 (2603:10a6:208:69::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5983:EE_
X-MS-Office365-Filtering-Correlation-Id: d6cb9077-51ac-46be-7669-08db73ba1242
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ehTJrku8sGkmP2Y94KxNOXDHZfvmK2vmAvMe16O5VvgyrjXQH9zkzNX8JWQ2PnespL/qjPAyfeJIoz5FustHZ5h7MdzSoUg03KiY8ISnvqYZjB1pg+DkrCVwkVreRbW7YdJf4jvUWl+f05XSbHTHrcAdQ85kHN8paVKqRtLV4hR6L/H9bd/mK9UQWL7DDtO069VXWtu6PNcKl5u1qkGhOfbJD87YU/szDU2tyG+nlG6sVIXkb+6YYG+UP/RfiEjhamsOvWuyiz41BAhkhREGfaBS4rN+Flyc6HFb4t2q0aEfgcuMAMHvVWHyzgK3wv0+uBnbP45SrL4ldPWz3ZZ9DwoIwoD4vuVlrks9d19wrCW5QVbmvEVaI1Y06GdY9a9Dw06j1xA1vtmEy5g5BuJKlCpLDc3FNRHA7BZHaybCZIQWqXVuXYxu03TxynJqCi+j+QmQYX+0naDnvjD8f1W2pm1TYrXmfRszmMcs9kgmS3CsqJUbSpSFDaxiw/+a2ZagnmQvfxNCQQCv0dRCq1pHA+fanT9ytTt1vFveqfZRvIKvvY20q/9KVrK5Ioe3yQhyze8e58YfxwvNklz5pfY67e7ObQoj6KsS92uXvLS/u4M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(346002)(376002)(366004)(136003)(396003)(451199021)(38100700002)(5660300002)(316002)(8936002)(8676002)(7416002)(44832011)(66556008)(4326008)(6916009)(66476007)(41300700001)(2906002)(54906003)(66946007)(6666004)(478600001)(6486002)(6506007)(83380400001)(6512007)(186003)(36756003)(86362001)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I5cLDQLpB9GCis3ySXw1XVcc9R5ul6jDOCsyi2KE68NncU87LIBfdLOGj1Ak?=
 =?us-ascii?Q?1OW2RjIURvZ3g7oRgtrr208dMHwtTTf8DqyiiPMbR3gAalEx2Cum0LwPI7Xr?=
 =?us-ascii?Q?whGq+MPC56JohL/JE7F15Wrbq1RXwCMoENHNzrXFBevxiV3eEmHsTfjaSt3Q?=
 =?us-ascii?Q?ap2ojZcmMbxrLn0GwI6ai75wm6lB1YDOGlr4RL5Gdsw6AdoxwSRd1qSxpFN1?=
 =?us-ascii?Q?DjH2m6hdkftg7sIjGlrP/NMwRN0VC+8pO27PEhd5TfW119HMRZJBhL6B8ypm?=
 =?us-ascii?Q?yBszZPSZf4WPk/DNZXFLq7tbpSlQLw7E2HYFl6SUz3ZQ9xXkqt8e/iBD6RZb?=
 =?us-ascii?Q?9VajCC7JOsVZjQIzrT3W3HMU6nocYXdcw0XQwn+g9dFrqfHeQgy/acFhgPyO?=
 =?us-ascii?Q?xTYGe18i9jupMicGV5xUWsrz+GXj9aERhx4ybcxfIHQw2g4cwbZMWhen+y6e?=
 =?us-ascii?Q?lyHPL6tph3ilR2SSjQKKqc6sG+iU8p5cWtrU03ga7fq8kr8FmDLvMwMyb6Fn?=
 =?us-ascii?Q?Q3B1K8MXKim/Ub2uv57aTJT7/72IENVRjOCrJdvhDVOESS26XwXbCpEdPL9C?=
 =?us-ascii?Q?98Jra77G720Zw6rlDPOZT5hcUjMJ/KEGH1nfcZK3AUSbQbu4ss1YWO4QGvrc?=
 =?us-ascii?Q?3nQQFHSpmD4yABRT2Tfzg1rGoujH2/hOYNzrZlcDj5zE3gojxDn7AokmAzWk?=
 =?us-ascii?Q?lATJnicMqY4EvF4WWPZ7A0doABAserGo6RlfYv4gZOa+UD14lt8LJ9lMKJ91?=
 =?us-ascii?Q?SXv6Q9LUUQCVnE1p3BMg6MR8Lx0l40SUIe9LmCJ2xcDrfU5AC3ryrtPTfETo?=
 =?us-ascii?Q?kZSss8k5Y6OvgeEorIXuOJQTSLkVNJ/NeJZvUJJ/mXc2YN93MPtGywZyKp4a?=
 =?us-ascii?Q?QqBpc8fL/zNYi0WIBOqmy1RTLFn/VWOAaNOi3UZQDSFFlHfmA6Z9m645dYBI?=
 =?us-ascii?Q?opobStE5nTBysNMPvQk2GcQx70Y3dDgvPo74a+kpN20kQ4fq0N5Q8wBmeUzn?=
 =?us-ascii?Q?iKsEIH25IbmJ3Ownjh/tRX/3P0UCXAWvlenF376f5h0YobiOC9FqFT2eAWJQ?=
 =?us-ascii?Q?7QKhAKVwMjaxwR9Z/m/JJ0thEQi8b9whYauCKgxPz6+g6q7HMKBc8ilikZ3l?=
 =?us-ascii?Q?etZ9SG8omEUWE7LO200atKOL5cqm2DJYlggbLw3A7u+s8/gf1aY85cntdnAb?=
 =?us-ascii?Q?n78pKId1i4zmLLl5hMvdk60Hj9EW6XLvhQkGPKTK7GpHaH6inlYnMOe4l6Na?=
 =?us-ascii?Q?Fic/E5xvRgarkeCIfEnvKhFytgSzNac6XtbpU710PB1MQZk5YbE0zbOMpsVy?=
 =?us-ascii?Q?xgy5SnKYqR3E8C8ZHye05kM3/OhShKP7Gy2qeIAHaZZGzjK5oAN2HGvkxkcH?=
 =?us-ascii?Q?5FdScGNniC5Hz6dUwak9f9Rio1svB/2wiZ5DrNAtyQqG/aXUUDietsU9qOST?=
 =?us-ascii?Q?I3hQZPuq2LLf9HrwS+DcZ3vnOaT/THb1tyd0rTnOwUiqEdJdvc1CduTnIIl/?=
 =?us-ascii?Q?nq1HNAHOObiS935KB6VAezbiPekT8BaWnu8c5VgvqSYt7rFBlRoYLdpSXPiq?=
 =?us-ascii?Q?N5BFXe94EQPObFJIDoui2k5tNCF7V2XYgEn20YxJk7Ifc4ZFkYK4gSjGh+n1?=
 =?us-ascii?Q?/ypa/O1vZkJ8vs8GQdiZFyUtgOCpZjvffwhLG7cFwnizjzBAqIyRBqP5e6VL?=
 =?us-ascii?Q?Wwji6g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6cb9077-51ac-46be-7669-08db73ba1242
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2023 07:18:41.1877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I2SRORJOBAgHTmBmI4wXjty5mDih75ElMuC2oA7KMrzP0Z9HFA0pcNqvBA4s0sPji4jX1A+r9PZizdDT24L4evMB9KEPU0DNo3LWCyULo9k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5983
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 22, 2023 at 11:11:01PM -0700, Randy Dunlap wrote:
> kernel-doc does not support DECLARE_PER_CPU(), so don't mark it with
> kernel-doc notation.
> 
> One comment block is not kernel-doc notation, so just use
> "/*" to begin the comment.
> 
> Quietens these warnings:
> 
> netfilter.h:493: warning: Function parameter or member 'bool' not described in 'DECLARE_PER_CPU'
> netfilter.h:493: warning: Function parameter or member 'nf_skb_duplicated' not described in 'DECLARE_PER_CPU'
> netfilter.h:493: warning: expecting prototype for nf_skb_duplicated(). Prototype was for DECLARE_PER_CPU() instead
> netfilter.h:496: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>  * Contains bitmask of ctnetlink event subscribers, if any.
> 
> Fixes: e7c8899f3e6f ("netfilter: move tee_active to core")
> Fixes: fdf6491193e4 ("netfilter: ctnetlink: make event listener tracking global")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Florian Westphal <fw@strlen.de>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
> Cc: netfilter-devel@vger.kernel.org
> Cc: coreteam@netfilter.org
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
