Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95CC0EB64DD
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Jul 2023 08:52:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbjGMIwO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 13 Jul 2023 04:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjGMIwM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Jul 2023 04:52:12 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2107.outbound.protection.outlook.com [40.107.94.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98F51B6;
        Thu, 13 Jul 2023 01:52:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nzo9zROzUP8VyXzEuRoR4/td/r34dPqLJr3hk1KT0yvgr8+0RxHmOHrigJRmkjXKRsL1iP8K0W4AXL3JBJf4hDzSPHCW0RhtbdyKwZf5SthGcKm3LVOeuogcfqBVDuxWyJv6RVKfXVxTpsXrplH/9ocHhTH4UlEXjlFL9vSXGSnYjFRx1l8r8LsX/NtjzLADyct5FtD5sOtEnZiXYOr0rn4lr+7ZlBG+DBL211kLMs1V9JBNKNmRUd45whkZuHiRZDDgDTcXmNa7v2PPtuaWD2Xez31qQqIujCvr3mqfdIlYRFO0Crx2os+Y3m+287DugvBJWP3JUlzoiwiw6Me4dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VI2K4xYi4gf/VuDNoCuy//SJ+6v07UOqI1xcOaDKa0o=;
 b=gn6lZPj7nm9MebUgixezCnmGrSMUTaRuyxEliOO0wnyS/vnw7RR0pNSJ3PUvvH2uMPXOYA7TizSq+YWaHNFcJemDYnq4so3pAlE0438ZasLui+MV+Pj7Z3IgP/E4TOYJd2TfrZW21WZsfCl+H9UDujbtS8UMbjvHAJUwndUWYVw7pK9oBs1bACPuJs0CUk65amwhnffqPu7QCLu09G0Td9ABOBzj6ed848z4Gx7I88K0tXzIASPuBNFnY0GkBLXYBFATdgvrtMrbjoe+DREoPBr7Q55fMcZY3YpD5DvyQN/OH9+Ee0c/KzkWpchySUYeauxl0L6x7GSHmAvdEeW5WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VI2K4xYi4gf/VuDNoCuy//SJ+6v07UOqI1xcOaDKa0o=;
 b=iw9QRR2CRts3a5CmHxJ0TdwMydPKWZVCXxfYcWCSCMuY94nzfozKTmeTlfLcPpDGhuzqrk0K+Im0tJlX4uGWgX7MKBep1w6VbgqJSKf+5ux7m9MU4ke2Tg9C1AiGZB6g7UqY5f8KYkifvc9Bty77GmXAg5oXiJZ7BAD7MNH2PwM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4889.namprd13.prod.outlook.com (2603:10b6:510:98::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.20; Thu, 13 Jul
 2023 08:52:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d23a:8c12:d561:470]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d23a:8c12:d561:470%6]) with mapi id 15.20.6588.024; Thu, 13 Jul 2023
 08:52:10 +0000
Date:   Thu, 13 Jul 2023 09:52:02 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Lin Ma <linma@zju.edu.cn>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH v1] netfilter: conntrack: validate cta_ip via parsing
Message-ID: <ZK+7Mp/t9P/IJCXO@corigine.com>
References: <20230711032257.3561166-1-linma@zju.edu.cn>
 <ZK6nwn99T8NAP6pC@corigine.com>
 <65fa5eb3.cd95a.1894a47d75b.Coremail.linma@zju.edu.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65fa5eb3.cd95a.1894a47d75b.Coremail.linma@zju.edu.cn>
X-ClientProxiedBy: LO4P265CA0237.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:315::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4889:EE_
X-MS-Office365-Filtering-Correlation-Id: 392fd53b-141b-46df-7008-08db837e719d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a+Lq3WihW51Ye7q3rO/F/TwOtlq75w/6JDl687804PD6x3isTE95LmcnM+xN9UNG10PEZMT2MguoI+X8wZHLJY3bLfCnnzQZ7T6zGLNcohVf6FIgrMaDm5J1ONFOLCt2fDxw3mQIeh/EOr8o7xtMlUAJzkAC5k+xXFbh704QkAqbwR4cCeyLne62MQlBc+pP0ucKwauv2zhf99Mz8J4SeZgDioGkxGoi4UIt48HpfGIiTIrCkDTjv/E6TyqMmAtbVsqmFGt7yEkB/myoxkukWnJRBwnqjNGRDAFoq/FCfO8yB9iJk6/tt0O2GTvAQBxHLYyPIwg+oRdS3kWaGF19IFaV/iPsAjeATBNIQc430FYkvuyhXtSc3pBrWEHHn+d9h44UG+pUCsgYasOwsCb+6jn/Y6n6TUK3plWsznuVqnee2IXvvolgwrM10ixpCtyBP4ynfGMv3CZlEyQQTn/eDHQZYYB6EMftmDKzeojCogj3KuPh0xt6se244dmqhpuT8Fh3reNq4yjVhn10iBaZ2bXlAVvQ1yFRXsfjQrwZpyaYsSoj8PfxLRjeGlFr6PY2Y8MkSgEXzl+LzIxu+4z+9tCiSm1tqnMRzFIK8XR/xo4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(396003)(39840400004)(346002)(376002)(451199021)(6512007)(6916009)(4326008)(66476007)(66556008)(66946007)(38100700002)(86362001)(186003)(26005)(6506007)(2616005)(83380400001)(558084003)(36756003)(478600001)(41300700001)(8676002)(8936002)(44832011)(7416002)(15650500001)(6486002)(6666004)(2906002)(316002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l+hBim4MB2liEieXkCL/w+D9OJejC3tFLS6aR7F07gfwlVyj6zy24h04yLvI?=
 =?us-ascii?Q?2Mpe53ss+Yso1gtVesZPiS1RTCxo75LFZNMyWESR2aMXMe2Gcd2YrlpSetFS?=
 =?us-ascii?Q?Ml4NIiJ+YDBZ9uQ7zB4N+uK+ILaHjtzeIKU8HeX8y9N1cwCeBmLL+N/cLYA6?=
 =?us-ascii?Q?DKxPZJ9fFNrOqIg9wyvlzKFTLF1U2OJIl82b2zgVsxzC+8XFlbHtJsDsVnye?=
 =?us-ascii?Q?jTw/dPE1ngtOuZJ9azuMDo6m6uGvX+NE8gUou6fOHoOXC9q0YFAeQi4Yw78v?=
 =?us-ascii?Q?Tt6rAvxUjt96jeRideCqqaWvXHJOq6lrBlC2FxMvOfZjcP7MWYLgKWwbBj6S?=
 =?us-ascii?Q?6Y0PWFjcsNfIdf9APnKVAX6dU6yRdKvmnEGpo7MgR4/n9GU62UWPHDj8mi+I?=
 =?us-ascii?Q?x+cXTf85oo4IYJtJSYQDJpOg0rgWWPATnb9GV489N4sqRQ6QDTp94xgvyuom?=
 =?us-ascii?Q?/eyNFQe7fTkurVbBDb/Ak3GSRl23KDfdGPpYZIxvTM9bO+2LRTzCql6Z+BBC?=
 =?us-ascii?Q?HuLZI6FC02o3DKt6DFymsaueAUFFOY2v1XL/gK/fWWbK6I70g4U2ZP/RHYjW?=
 =?us-ascii?Q?JpFfttp3Mw1aO0KqesWk+cumopICFRr1RRgqBvxRwdd6LEv4nJd9uQAa1TLZ?=
 =?us-ascii?Q?AFMEG+V68k3HAYWSqlUPYtAE1aXEAg7xJhRYYq9uytvu+QyRk2grSgYh0M1h?=
 =?us-ascii?Q?XxbU0lV28Ws6YRh+GPyCLXdx0LAmApe6rOXEY8T4dKPTtNITBlq528w6qKs1?=
 =?us-ascii?Q?+UP/22bfW2UN2qdEezq+mP3Vd+o5Nctlq1pjmsUqyfJ98xdguQf2B2J3quAD?=
 =?us-ascii?Q?hv69HMmJETlqnfC3QX3WIvjr5NJXxtwXKkP3M5Z0r1a8RmEtMGb5U6NmuPql?=
 =?us-ascii?Q?pplxPdiuhC9XZX31tu8nJbE64L3sQZK/qm/9yQPoc2e3ksGnTcOR9XSpaW2m?=
 =?us-ascii?Q?dLcjeSnhJIKX3tmPPqzS89zk97RM79JEQ5DEKQXdxDSDEdEOv40zhcyP8zfk?=
 =?us-ascii?Q?uHskcSMUNIzOwKM06enSfDrXaFEbVo9CkOwKm8p8xzs436/wuM90NccZU425?=
 =?us-ascii?Q?Bk279CPsF19Uq+nJ/Np75rYZUMYo5K147xLnu+OeeS/ylitPH2ZJ5X+bfWAO?=
 =?us-ascii?Q?n+QpKOwmemMHurYCW1JDZrMtY33+aILkOkhsCazdWB6ARpGJCmExnbVNEoXs?=
 =?us-ascii?Q?vEl3wt29eF5JuCnhFtSV1dSnvtJZLZ0VJBgWFG28D4Xua//Xfec1Pnp5ykhk?=
 =?us-ascii?Q?PTuT5QBXQ57Wc8q13Tu8T8do2G9Futap9+S6MiUHKRhIbTVnn6DRL0YqyfS9?=
 =?us-ascii?Q?4ugd1VvDKaImayjoTdx+1PSfQXAHjZJXJLC6bV4HP0MwUdyN8r9uL/5zQ5s5?=
 =?us-ascii?Q?cnsgVWTh6wwGAVLc3AkivLgkLzJz1bmA7c6LJ9zA9Km85mc8mlmaYKITJg4K?=
 =?us-ascii?Q?Miseb2UAmrR3to+/LG9SN3xAjxqRB+RmkCYrFLUCk0I3AVmKRoHBo6aUtgVD?=
 =?us-ascii?Q?NoRwLrR2msYX8r507P+jHbkSQzEyTxNrOCnPcDVJG9C5EOnaxKzzf43Iouvw?=
 =?us-ascii?Q?fbkOKMmin319jbKqT0ZyhKyaFoJoh3vO+DB4eXKeetEqcE61C1xY4mwsv8/L?=
 =?us-ascii?Q?nA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 392fd53b-141b-46df-7008-08db837e719d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2023 08:52:10.0060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JTCec7ybBEx/uHZim9TP4snbM0Bhny8Ch+5Z8lyyHXQD6WzBPKcC24E9vqGcKT5XegHokW0jjj98a3QaDKSEeskuSRQwflcQ29Y4jwAanjQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4889
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jul 12, 2023 at 09:26:09PM +0800, Lin Ma wrote:
> Hello Simon,
> 
> > 
> > I don't think this warrants a fixes tag, as it's not fixing any
> > user-visible behaviour. Rather, it is a clean-up.
> > 
> 
> My bad, I will resend one with adjusted message.

Thanks, much appreciated.
