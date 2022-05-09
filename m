Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E4F9C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 May 2022 17:11:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239358AbiEIRPt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 May 2022 13:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbiEIRPs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 May 2022 13:15:48 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140121.outbound.protection.outlook.com [40.107.14.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0CD716D12C
        for <netfilter-devel@vger.kernel.org>; Mon,  9 May 2022 10:11:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vt2NREWHjMA6RLGlETjm5GdVLwCEEz4z3jGzRXE+PuotdlM3d9VUjBCR2A2Y+ft7qhxcEbF8mVJSVLceQSUg29BG23jRqL3dg8GiGnJDRCZGr2aycbvuKyllr8HgUD9DStvOaVBRYf3BNc37IappQlqyfxghswQ6+HBO6lbbIrcc4C1uNbhK7kwWcUz2USph4d0yGiUTor5ZoYxfZgFKZvPkkkVRCEzYx/c/A3SwdyM40Ty0VI8CKTPYvSeu5Tjs6vn8LO6T7qM0BEGZHl+KiIsGsx7maTBdk6ONvHngzwjZpi50KMgGEyetg4OGl0MyFXM0KfvHXA0LpPHmu53qsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uUAfgQa2UL8A8d7t6rgrQQk6YCBtXBdUfCIGjQnqUf0=;
 b=KfaaY/msXlyYYtdgRqy+nE6ioX9tjsiqAnfiNTu6W9vzZ4P8t4k5O6lgXA6FwdMg9vzphIU4hiy8UQEAcyfxaM33iO2G9MIMEm59oCvRgZSjAtxbEqvZKmA1ACJ2P5eoL9P851CBWGNEy9vLdrUQmS8o80Z1TcBAs+x9riERM7W2Wt2MmTkgebAgKArIY9D5/owFpTTy++cLU5XsE67PmDdW91woxqYkjfM1bF08xC3js/dxxJsxg540eP+/adw4I+yqsYhH98nsN0Rp7DVLdQ44az9EmsCg3/I4HVYTH7qVFHEDc1sBZJLpI4VR4hwIwFHynlWrJcHAdemexCPbiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uUAfgQa2UL8A8d7t6rgrQQk6YCBtXBdUfCIGjQnqUf0=;
 b=CikBGoFGQD4W+ttiUw/Cw1f7X+Hwh7eTFW5rEE7q1+6kM5gYFqGsOtUXa9D7vlpmlyWUrRMJu3Hj6csqnK8ODKUM0fnOog6J4hknE4CyqV37Nh9WgfGtXODIh+3Sg/zAMDzaKc6AvRWjDYkXqaXSy39IE5LEgduCDAPneO6PbAo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from PA4PR05MB8996.eurprd05.prod.outlook.com (2603:10a6:102:2a7::10)
 by DB8PR05MB6650.eurprd05.prod.outlook.com (2603:10a6:10:142::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Mon, 9 May
 2022 17:11:50 +0000
Received: from PA4PR05MB8996.eurprd05.prod.outlook.com
 ([fe80::c4b9:8da4:3f97:a2c6]) by PA4PR05MB8996.eurprd05.prod.outlook.com
 ([fe80::c4b9:8da4:3f97:a2c6%5]) with mapi id 15.20.5186.021; Mon, 9 May 2022
 17:11:49 +0000
Date:   Mon, 9 May 2022 19:11:44 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, pablo@netfilter.org, nbd@nbd.name,
        paulb@nvidia.com, ozsh@nvidia.com
Subject: Re: [PATCH] nf_flowtable: teardown fix race condition
Message-ID: <20220509171144.32oms7zygfkjypd6@svensmacbookpro.sven.lan>
References: <20220509093132.fmxxhhogq7jhhpks@SvensMacbookPro.hq.voleatech.com>
 <20220509164733.GA12438@breakpoint.cc>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509164733.GA12438@breakpoint.cc>
X-ClientProxiedBy: AS9PR06CA0551.eurprd06.prod.outlook.com
 (2603:10a6:20b:485::12) To PA4PR05MB8996.eurprd05.prod.outlook.com
 (2603:10a6:102:2a7::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3059342-6ed4-4245-d6ed-08da31df0150
X-MS-TrafficTypeDiagnostic: DB8PR05MB6650:EE_
X-Microsoft-Antispam-PRVS: <DB8PR05MB66506E4FEFE28F300BC90D56EFC69@DB8PR05MB6650.eurprd05.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KLODx2ApCPZV0r9i64cBhuGZ4AWFvkPJxNggEsHC2HILLOQ5scJxqFsFbhmNA4R6Dn6Ko1Pdb+1gfuPoKS0N1jAZajB9D9tM1sabDuZiWFm43NIAAexZRr5FRMWAt+g8ncZ26UNKwTmf1pNtl45Zo3LR8UChRXciloaKXdjeH7wtgYkWoLR5a5Ep8H0ZbsadcRznj7uXqJB+dT1+XTHJjlRX5/NNpJ9OEj9XQ+9F0wCkYr6qu5wN36TuB66XulfXGnKlcWvxiVpLarK7entFJkKvQs2mDhgyvmMnWk6vq+m4pcYmH4uOUjwsWHt/IvXXz64QM/nH4VayrNeWv7Hf8ybzkQbadjnO5VUyizWUFI6/gMypmaemJ5u5bDOgKao7K5wlAcnq+uRATARMCnnxUd8zgKwFQYkBCah6oEKGltnh6wSB4jZ/1enJdr5FthrsrRdL6Sz6dK6NS9vUwVl8pqntfWuxQy5pQZ8unElU+Wq4Z3l/AbFZ5QniquMaPtgMRLUZlfXrzPEm25Md8C4idXz/ktmrvsQPAtYVArNpvlh1TK1brQZaxhlwt81xrMua/maetWE3YpJtA7x8jgJ00DDcGnYE/tJd184hVE8XzoXRioIApi4/vDIJfrb/pKOY7XKQ5+z4LrYEH2Ifmj8zhQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR05MB8996.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(376002)(366004)(39830400003)(396003)(136003)(346002)(6486002)(508600001)(38100700002)(316002)(6916009)(26005)(66946007)(66556008)(86362001)(66476007)(6666004)(5660300002)(6512007)(8676002)(9686003)(4326008)(6506007)(2906002)(186003)(44832011)(83380400001)(1076003)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o39jg47qjdQledP4QVgT/fS5NCEcugI/0whDdLzumbi9/YuqQJJIr36OaTWE?=
 =?us-ascii?Q?6FNnitiEjygWEZkjYGlTt/7ysiRjLvPTo+cQQ9ZDdvwnPWADIw4B73zJy4R8?=
 =?us-ascii?Q?GSQM//W49cBT0ig8CROOyobWj5aHwMKmvsVw4hjdfGNzvGnsQxqH81xzY/vG?=
 =?us-ascii?Q?AWSp43tUZWjzck42mQXVgFZaIy035JtPodu2kSl3qs3KvHd3JdU0o7ApE2IC?=
 =?us-ascii?Q?EUXhyZIxH2KqNZQuac/Tyo87xtRpm1Y/aSgXZVuGHL9tyWCJGUOsM6gWC6ab?=
 =?us-ascii?Q?KBd8NXavzEHioqExfjxObbz2XVxuq+M0DITwntf2GicJZ5gPN3yvU2W63a3j?=
 =?us-ascii?Q?qDKtWo3jnH4YajWQrCPuMUgdBHKym/XRv7lWJzkExaxIXzqorXOk5ckuoM0O?=
 =?us-ascii?Q?u/QwQ2M9jp2LbpUhzeFTxTJehb4fcleySlV/HNz21mFvUJF8glo82LEbQ8xz?=
 =?us-ascii?Q?gjIThPj2GqZKa+Zfa8IEl5Lxi76JtSbnwmSfOu3wIrATzcT3ezZC68HWGQiX?=
 =?us-ascii?Q?7U/sCg0n4Y8zogyKhxbFcMNV4itzX/HAiZqTrySm6oUZ/SiDKWoMu7px5MQx?=
 =?us-ascii?Q?o1Uj7JX/szOLs78TDrgpIkLzirJo/QCVFkZ9REVWi9mXmB7beSj8iyZE9tne?=
 =?us-ascii?Q?q+vk2y8j1IXQqw8oEJJiG0ERYlghbJZmDgsCOenpAdTJ7vKmCEb+/3Ge+zS/?=
 =?us-ascii?Q?UqHFBl8GzSD27orEwuF5zvQkBAXe45YfP2iaNS5ZC+PVKIweU0zurvO31gWL?=
 =?us-ascii?Q?7NGfASeaa/vrdUKW5ruJg3ddwqQncNvxp6vC8RLzIbrEtPrHscI4YYKKeApG?=
 =?us-ascii?Q?fRPaEs9zXuwTh0oFcFR3kk78dr12yvY+hLSoY8mOwmPSFJ7R/sQwLlXaffZ8?=
 =?us-ascii?Q?GmEqrjeVo7wG5vHVz+fQLySI1jRldwqRRGET9XwzavfBO6pPllNPz2RVMQ8T?=
 =?us-ascii?Q?V6VXKWrpChdKsQ70gelLlvesWVwfBhECe1eQaI15rU77rxSUlR4Dg0FEOkXv?=
 =?us-ascii?Q?jDYsp4hxCMgeJ8wu1uH2W1B++pVW87/CbkIowvzw+gL+qAsOxeYkUOMoQWtz?=
 =?us-ascii?Q?XR5r+X46lSTltz4czn9BrMCuAjpcCebTME9azoQJhTd4/1ET2k8CqyIKlarE?=
 =?us-ascii?Q?i9T13W0Yh3PLWTkfoNjExvSEqWVzAQbimeDjr+uNApwVSeyHeK0MtPm0j5H6?=
 =?us-ascii?Q?/ZDkAVLIIeULWjbRbDQ/Dn5R+ICNIJteS/9jalOXHvKesj9IQa5uCyxGF4Pp?=
 =?us-ascii?Q?UnoeBZkxbDOZ5vOLgSQlwOwe0nLP7taYo3ryV5PPTlLYDDWo6XWI0heplMYT?=
 =?us-ascii?Q?F/4hX2lFz0sL/SmT29kgpULVVXVqlrHpZ2OptPr9koPaMwhZ7UoQ3FptEbwl?=
 =?us-ascii?Q?JqH+7oq1Y0GPI/tZORMvlemgUct0iUq7oPQilAGX+JDY8HW2y3WSsDHtJfGF?=
 =?us-ascii?Q?KvkW42W6+erHAm509kZLfORc9FiMooVnmaiOtuQZ64tdftZhhTPSu9JJJs7T?=
 =?us-ascii?Q?p3Nz+8UA5HViya9CeD1XfkaaVAB+fDPWKgq6x+BQ5FI3+a4h+Qs5w8zVESTY?=
 =?us-ascii?Q?b0RyvYz7rxu7risqecygnOTViDVWTVKgrROAYbW4omVX66GRjv6ljj2ovw4H?=
 =?us-ascii?Q?3vrQtEAMD02zpELZH3qCGMwPm21DbwCMnWMgm/I1gvLYRZrenT92PuMfpwZD?=
 =?us-ascii?Q?wV5i+iQGPFvSsOXNKD5TgBZo14AwJGNOiB+eeo/Cdw+awbGsTrye/bPTfx96?=
 =?us-ascii?Q?5yGHyZ+a5zENL31FKTksw8vxlpQl9fQ=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: d3059342-6ed4-4245-d6ed-08da31df0150
X-MS-Exchange-CrossTenant-AuthSource: PA4PR05MB8996.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 17:11:49.8858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9/GbYT7k60wntDD+DAEP2xP2CYteu4l8vW/zN/ZbHKLWBdLke8CYj6u4tNsPPemG3jZgGb8y8G/hLdAOZaTi+hH7AQnbImEI4k5yye1JCqI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6650
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, May 09, 2022 at 06:47:33PM +0200, Florian Westphal wrote:
> Sven Auhagen <Sven.Auhagen@voleatech.de> wrote:
> > +	if (unlikely(!test_bit(IPS_ASSURED_BIT, &flow->ct->status))) {
> > +		spin_lock_bh(&flow->ct->lock);
> > +		flow->ct->proto.tcp.state = TCP_CONNTRACK_ESTABLISHED;
> > +		spin_unlock_bh(&flow->ct->lock);
> > +		set_bit(IPS_ASSURED_BIT, &flow->ct->status);
> 
> Uh. Whats going on here?  ASSURED bit prevents early-eviction,
> it should not be set at random.

It is not set at random but when the TCP state is set to established.
The problem with the flow offload code at the moment is that it
is setting the TCP state to established on flow teardown disregarding
the current TCP state which might be CLOSED or FIN WAIT and therefore
creating a lot of long living dead state entries.

I need the tcp state to be ESTABLISHED at this point to distinguish
the right cases at flow teardown, because the TCP state at
flow creation is SYN_RECV and it will most likely stay like that
during offload.
It can transition to a different state though if the flow offload code
bumps up a packet to the nftables slow path in case of a processing
error or after flow teardown and before flow delete, because there is
a race condition at the moment.

After talking to Oz today, he rightfully mentioned that the offload
should not be allocated if the TCP state is not established to avoid
the hack here.

I will send a v2 with that implementation.

Best
Sven

