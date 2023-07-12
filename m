Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94F8FEB64DA
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jul 2023 13:17:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233451AbjGLNRF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Jul 2023 09:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233297AbjGLNRE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jul 2023 09:17:04 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2105.outbound.protection.outlook.com [40.107.93.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D591984;
        Wed, 12 Jul 2023 06:17:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SctPp1CGqD99NjYUH8ReJHGvatObRzO8b5K6T8hTNwcFoX+ESSUnCp0CakatFPBfqGR+K/w1UYJcjwUeC1i2ZvTeOxnzn/XOTkJLNgl28E+a4K6Q6n3FQExIOqkpwGV4ZmX9Nt0I+m/5O02IgyyS8HvXnl+UE/XcNX+5/LiC3IpE0/plp2sdYzMR8aZo4BGRODRD+ctkveuiXiyVa3+KVDi8I4+HThoSlzm8YSBAmvYxi347SWROj8H19TzYOVjpjK3PGCT32lm2JgfmyGQz/gTABgb1+jm2G4Ks0969UzMw1pWxbsvUgQBH+lxuv4FJp0RyeVxxy5PZjXdDvUAmHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lR38tOdTYJugkhlE84oqW2Xb/unr+1YjFwaMDA8TgGg=;
 b=aIMzwVFlHUjQNmRDZEL2CwZ3EmcRWhtWjej5lYuRtVgSBu6TWH5OWvJuzUCqfDTwmglxjNB46jyd1BxXeVAX7+vA6gYJploMkGdU+RBsvOLsfG0NnkufCYfBwL97OuZCbN4RX0bpcU0YDkPCmEHCz86siqVmFd0fTTA5jFTQYnrg+WCfZjFzYcqnFzXoggB7dPv5d5tdMKBBI/ROHrV9pyhJuKdRzKARy0OvMahY+f8PXRe/uqwHEl6paDv1NIOqfsxATEVH8SehOSGgyUqWA6mX1lf2luqjzxmvYbouo6L9prWHf7X93qUxZQQFunZqFdl8zzdnPM9tK64pk43YKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lR38tOdTYJugkhlE84oqW2Xb/unr+1YjFwaMDA8TgGg=;
 b=c9PFLu974+n1Q3svFfXIlVPgVWYTrOgABA9ZDGBNIjk0zBuYgC4T+SCYfTHU5Podlg6sHtEWolsXowBKqq80whQmLiD+Fbt0X6HYU0WpMZRlUoArgQboBxMUx0lBJxdOM8BBUhwZKb2m9pY/R3FlkSut91Q5209Ardf/h5BrnQA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN7PR13MB6254.namprd13.prod.outlook.com (2603:10b6:806:2ed::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.30; Wed, 12 Jul
 2023 13:16:58 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d23a:8c12:d561:470]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d23a:8c12:d561:470%6]) with mapi id 15.20.6588.017; Wed, 12 Jul 2023
 13:16:57 +0000
Date:   Wed, 12 Jul 2023 14:16:50 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Lin Ma <linma@zju.edu.cn>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH v1] netfilter: conntrack: validate cta_ip via parsing
Message-ID: <ZK6nwn99T8NAP6pC@corigine.com>
References: <20230711032257.3561166-1-linma@zju.edu.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230711032257.3561166-1-linma@zju.edu.cn>
X-ClientProxiedBy: LO4P123CA0562.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:33b::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN7PR13MB6254:EE_
X-MS-Office365-Filtering-Correlation-Id: da8ee4f5-a61d-45f7-0f1a-08db82da44eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V87Bh+g5Y2q2NriHJLg6b811USL12Ku79JgHlyYgcQCEeDeCGdFEiGVRNfWn7Z6V5VJWsa5jj/mDeQVJrt99bHGQhMLDOwua46qfj0RpvQOB7WxOWOGAuJhR3XmsOZDTfCrPTkQuy87CaLiIg94lMUwmaa4aUKP0xVsNftI/4TojOzlmizUnZdME1TsmIfQGai3Lt+Ou1rHscCvD2aKib3EnaOnUGUWElngX3OZSofCm0WoE4E/xLvHOLs1tS2IQGYY7lxMMB2xk8xV25eoAbp4egAJPzn+xG8+1hQPWG58CSdaWpmwjBxrLFWli0XNXN4jHNhJEhn0XpCBXxx0X+sMk21vCoMcHfg2E6okD/V+Xf63/0lHz7pjzOnJC9uLKcqV0UkxHuOoVrKMzux76sUy2OrH8ZFgzByLs1wTUBZSXsJsuthkzsdhDFBPFSWz9cTLVJX2HI7KbfxBbnCschAI2p2JGWVXmr0J4eqefB0ODE8wAxwp77RNwuhCbX9uBds2Nuf/5zy5JL1HDAUzqL6VkG1UGUGpvT0dD2l9UQcy+LirCLHIPFt1IvYMqof2YiIIt22k+lMgtZoztjiM0ApX+8CVqdsZroDPxu8xStaI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(136003)(396003)(346002)(39840400004)(451199021)(186003)(26005)(6512007)(2616005)(6506007)(5660300002)(83380400001)(4326008)(44832011)(8936002)(478600001)(41300700001)(6916009)(2906002)(66556008)(316002)(66946007)(66476007)(8676002)(7416002)(15650500001)(36756003)(6666004)(6486002)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mRFleSNx1RRipqrklR8vVn6kQAgVqGBe5zW1tgrhwGxvYuRd0OniHHCKQ7EI?=
 =?us-ascii?Q?eqjjE16Ztn4540azI/FysTEbH0mPtGeA4WtiI1wPcs4Rwq0DJpqgmqHuG/h/?=
 =?us-ascii?Q?ukyr5FhhRFvBABWunlJVGSEbH9hISfNxrh7vSN8B5d06HR9MgkpkzuPDyURP?=
 =?us-ascii?Q?ODi9+NWxivxRY3HUHifFMViC0zUovbRRnZ/ISzyXo71ZOtqUkFqXT2/DyYsF?=
 =?us-ascii?Q?A7RxtnVdxVX4m9h/ZOk/UMszKYn89csc6U1yDa6NoyHLIPoNuMObXxXtDBD4?=
 =?us-ascii?Q?k8sPQZox6ZHTPVJIE4AGxKr0FR865dFRpGuxmyJuzlWycmrHvozwoeef3YHq?=
 =?us-ascii?Q?RxP43p0khRBzkIeKiyquqFGqxYYcJyCfr+Z1zEFALxNwB8VuZc/huCs3D6xA?=
 =?us-ascii?Q?ZSGnYVJLeqxn7FgUpYM2dvBE96+RE1pvUmsiMcXseEUeckxKtCbqWBTDl7RN?=
 =?us-ascii?Q?2Wd9bc8nR6RKmP8M5zY4959dAy72sP0L/Lj4tSpgPX0XP0UUW1WfLe9F0mH5?=
 =?us-ascii?Q?YdzEYipa0ck+3+DW1aRFL9umYeABC7G6vZoVdieX63FKiBcGKAOvVdyWOBgw?=
 =?us-ascii?Q?Y5VQ5JM59s3uEHZFKe7lOUDiAovHutUkOGc2szdiBb4eE/2MdN/kwDBlIlAR?=
 =?us-ascii?Q?1ltSu862GuEDd3TX+XPGqC0g4Fekb5/aK33e/Jx8+6Dt8N0Teye8A0/2Vw6U?=
 =?us-ascii?Q?Sp7BbdzZQ++EQ9OKtg7Br1XLK/U63G33go1yBHvlfS1L7FjfIgxvnQnMPn2f?=
 =?us-ascii?Q?XlHDPBBN8kF5SoAQPbfM9YNfMSkdlMOfNU/qox1iBE/4y3bgTrew+RGOK373?=
 =?us-ascii?Q?BZLd+e8OtmfLqijJTSLlGG+oMUnuD8HQhnaLAJI90/FEpcBLv9CpzQpDrbUY?=
 =?us-ascii?Q?5H1gZcgUaTTo2MD/LWPiTt90/uCPTZMgXePQRxdtGKju3rB4EAI6y/cShVYr?=
 =?us-ascii?Q?GqnfVkb/xAOu1cVs1MTLgiW992BfZUHdm5vv21LOOjLDUTidDEWOBmXeyd7v?=
 =?us-ascii?Q?Z+k+8WVh1YcguRd4LRLN0HN2WJUfKQDMWz1a2XldrfqS13dtLyz9I8xMKvmv?=
 =?us-ascii?Q?5VXSZXVH6yW6fs6y9L5TGQe9jk6CTty3F9qtMJvMitXAhRBO+YZKoKFLtigU?=
 =?us-ascii?Q?8eGvs1+iAkN8iKqOvf/D0IQYftgrZ80v8uRMHPKr+ElqlcarTQjkfx2VM7hq?=
 =?us-ascii?Q?1AY7kjetHY+Q3T3G0yhrX0rISAYFGKdxBnJw4/rYk9In2iYJMzSj48T3ksXB?=
 =?us-ascii?Q?db0mcNnUcDpAtiIhBLAC4iPLzlogoP8TgUc4pfMtwLmELYXsCrZnKfw8J2id?=
 =?us-ascii?Q?h9Un3FkInuMkivFgbJFq3KlqRCOkiQtVYCmOhBibB4PdWviTRBEbMLBIbLCS?=
 =?us-ascii?Q?wFFnlVnLa8OgKRSQvMv4YYHny8hqBMdJ3soyDTZLJ964c7zhu0OsrvAQIGzC?=
 =?us-ascii?Q?yyGZ+HETWP05qnO0j1vVIi4UC2IhW3I9z5yVB0B+f2PfQg3/CCzgrtBdRtx3?=
 =?us-ascii?Q?swu16OB4/+WN27mgGAswNNI4wW0QI/CXcYTK9VhGE8/raQPxjfNJgScfPW3b?=
 =?us-ascii?Q?NfN1oonBjv0v+wyMFSdewFAUsHbgY/S9GK3hY+iw1JuDIK+1OjHOYkVzyZIq?=
 =?us-ascii?Q?iA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da8ee4f5-a61d-45f7-0f1a-08db82da44eb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2023 13:16:57.6847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qsAPNpEJ215Lkkzh/8pxtfsKaqUTS3mtfnPD2OjROPzTjVHI9q3tUU3g+1ePyKkFTJtc1b7G8yWEJeM82d5bgyR9DhL2AwIHlGFuwy5JTiU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR13MB6254
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 11, 2023 at 11:22:57AM +0800, Lin Ma wrote:
> In current ctnetlink_parse_tuple_ip() function, nested parsing and
> validation is splitting as two parts. This is unnecessary as the
> nla_parse_nested_deprecated function supports validation in the fly.
> These two finially reach same place __nla_validate_parse with same
> validate flag.
> 
> nla_parse_nested_deprecated
>   __nla_parse(.., NL_VALIDATE_LIBERAL, ..)
>     __nla_validate_parse
> 
> nla_validate_nested_deprecated
>   __nla_validate_nested(.., NL_VALIDATE_LIBERAL, ..)
>     __nla_validate
>       __nla_validate_parse
> 
> This commit removes the call to nla_validate_nested_deprecated and pass
> cta_ip_nla_policy when do parsing.
> 
> Fixes: 8cb081746c03 ("netlink: make validation more configurable for future strictness")

I don't think this warrants a fixes tag, as it's not fixing any
user-visible behaviour. Rather, it is a clean-up.

> Signed-off-by: Lin Ma <linma@zju.edu.cn>
> ---
>  net/netfilter/nf_conntrack_netlink.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index 69c8c8c7e9b8..334db22199c1 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -1321,15 +1321,11 @@ static int ctnetlink_parse_tuple_ip(struct nlattr *attr,
>  	struct nlattr *tb[CTA_IP_MAX+1];
>  	int ret = 0;
>  
> -	ret = nla_parse_nested_deprecated(tb, CTA_IP_MAX, attr, NULL, NULL);
> +	ret = nla_parse_nested_deprecated(tb, CTA_IP_MAX, attr,
> +					  cta_ip_nla_policy, NULL);
>  	if (ret < 0)
>  		return ret;
>  
> -	ret = nla_validate_nested_deprecated(attr, CTA_IP_MAX,
> -					     cta_ip_nla_policy, NULL);
> -	if (ret)
> -		return ret;
> -
>  	switch (tuple->src.l3num) {
>  	case NFPROTO_IPV4:
>  		ret = ipv4_nlattr_to_tuple(tb, tuple, flags);
> -- 
> 2.17.1
> 
> 
