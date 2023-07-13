Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D2ABC0015E
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Jul 2023 15:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbjGMPDT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 13 Jul 2023 11:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232533AbjGMPDQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Jul 2023 11:03:16 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2091.outbound.protection.outlook.com [40.107.244.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119DE1B6;
        Thu, 13 Jul 2023 08:03:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HtqE83GllPLZDXc3UdI5129d4i32oHq2jGXtmuIHCpL+h4lXWE4O/XjH26HSdOahosOXVN+xJOgkSor7JO7bNI1b5r2/ssgoXxLblR40UKXReRlaf+EMtXTo+mlxJC1b/kk7BEFiI0+Ox35zbuOC4pAYUQU/eVzjuj+9uzTQXlMBUfcHl0hwSuz1VmuMSmCbF1hFaM0bvOLDmtJ3zLcQLrviBVTPF941MMMnuHUmUdU25B+sFzbGDcY8IRwjzL+fpVH/m1ZKjioL/tRTBj5CDA/GxfRkmT2scYU3XLBqqGvA6ign9ugywCohdqLwEKJh5I1ti5q1b1kJgLTTw3sWfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vXx38A7I9rqwKgRv7jAojrP8gaE963Tx2SBryjGSQ9k=;
 b=Xd9e9V5Tp314kH1nO0y5J978/qbTwKv2PG9EpeG60MEDVg4M93kGmid7CHDMs2yeH7ivWSDvKNp4d7vt8MBVKruQcmgW1+y/emcPyRMEdYkeh26PB2dRJllF+NplSY7fP5MpkJog/NaGB2+eC5j9LS1DChLEMQIaiRxs2nID7TKwLxdrM3Aasiv73bpavqqOT1iOjPr7VppnMeW2df0NlN4/PhypkLILshckGAnzwCGzTURGLIHC7xxhiaiHFZPwHAOEUl06GoWzJsq72QHbcuIgcfJLnx0XUwYP2XoS3CEz9nD12Ple87WXancMrUgAr8/qDxgubMj5U7kkvYy7gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vXx38A7I9rqwKgRv7jAojrP8gaE963Tx2SBryjGSQ9k=;
 b=U8UVVPX97HswGscdgGRidDmzVY646e9e8/qFfwM3qTv3B89HmvVLp8pWh4LikrA3aUO/EKhML9EImDE1Cnw5hV9gXcX0TEYZVTz4+z2urc4MUlR+CynzzTooVOWZhDP60mP81phsh4A3gOUoB/grKC8XC+oeEedSWn/YKtjhWqw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3643.namprd13.prod.outlook.com (2603:10b6:5:242::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.24; Thu, 13 Jul
 2023 15:03:11 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d23a:8c12:d561:470]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d23a:8c12:d561:470%6]) with mapi id 15.20.6588.024; Thu, 13 Jul 2023
 15:03:11 +0000
Date:   Thu, 13 Jul 2023 16:03:04 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Lin Ma <linma@zju.edu.cn>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] netfilter: conntrack: validate cta_ip via parsing
Message-ID: <ZLASKOr2ZqZtkpCb@corigine.com>
References: <20230712133236.280999-1-linma@zju.edu.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230712133236.280999-1-linma@zju.edu.cn>
X-ClientProxiedBy: LO4P123CA0576.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3643:EE_
X-MS-Office365-Filtering-Correlation-Id: e454bc23-1f9a-4508-dddb-08db83b246ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mu+LjTwI0Xz3kb4OGMX6eCi6GhyM3TC6+8Uc+slfnCuIXfEsBtRcp5uoRPf/9eZktcb01KO3WpnFd0Sv5zKyAZOMTJKHrQgWWXpPNoikjA973s4EWjEPFop+GsVB3YLWvDddXtgV4Jhnh97lm38KBze824VCIDO3imTr9sg8JMcB8DDRVyOmel4m3knkB5cJojYz2T0PssmJvvTw6DfEOJ3B4b6Vk7MYlkaHdY98TRMqzZKx4ggBeFZeNVSE4BXqduOXTZFPTrVus0+Zop6lOFC4AuanyySqxzmUbYcal+amuBvikQdBF6ETSBeXqB9iPgBc0TpQq7Rn4P1cDPyrjibaRUJluq3cn60knI6JKeiru5gBE90PzTOI38OawuEHwxbo0ZvXvviA70HdjAdfVI5fGvFdDB8zo2pFz1WnTAkZghJbM/eVzIr160QfG7DYwgSQEOBgMMfecem7K0y+A/GArpL6EHTGS0H89c2LvY9ebsgWRA5baqNqDsGQgU7UDWBTVGHKVUIqp5+KV3SmOEDrwlFZ3LfFvsXp6vrfzPZeTasbjvSAs35uOdrHbfDBv44pUCbcCBbOEW6mx6suMnqL0mcuFS2vQ9/Yd3dSEpA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(376002)(366004)(39840400004)(396003)(451199021)(6486002)(38100700002)(6512007)(186003)(6666004)(2906002)(26005)(6506007)(41300700001)(86362001)(36756003)(478600001)(4744005)(316002)(2616005)(15650500001)(66556008)(66946007)(66476007)(5660300002)(4326008)(6916009)(8936002)(44832011)(83380400001)(7416002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sXRmEm+HuxyGjnP93cOYhEAX1mLG9yMQr10RLYsznpLfsmBFtssyxAxWbVxP?=
 =?us-ascii?Q?2pmwhJOggdkZrIkT6GihZXeWwCWm2my7ms13H1W2SXR8ufJJEEpPXejFzLYB?=
 =?us-ascii?Q?PqcVClb3SvcgN1OYQYdr0FbkkP9MyS0yoKE9+5haKN1Axtio5rzjTPopqjPg?=
 =?us-ascii?Q?p9WKQdSTVdnOQAwxjT0sQJmPOI5pwJvTkYocyI1YyWbQgXbmnp9dEgcyCWUa?=
 =?us-ascii?Q?s6hjKxk1Bwmi65nWBAdlVGHLymsRgA+dyIMO4wUdukqZk94e9iYihZKNdXjB?=
 =?us-ascii?Q?ao9W++Mu8qGdiOz9BYteJX/h6YF1W+/XULWfH9ggS9wxYR/fqQ00qMD3+RoI?=
 =?us-ascii?Q?but5mb6h+2TFgOSP8djgPucHM7mTLN8TbF7UBLZClT3hZrVbQzZsJ5v3u6Bj?=
 =?us-ascii?Q?1ilJ5AmnUjItHwsa+3Ai0ygSAUOPTI6uFfjyd6fQb6++dqHn9Xdp510DqWFr?=
 =?us-ascii?Q?BLEuEaANVZCDjBTHMZcByH4UNnnzpJuiyI7AOFXZn2sw+VLHj0E0mdFvvYNv?=
 =?us-ascii?Q?/MiSBIGgppiOIY+Tsux4g3dXD5XyG1lXXVYGMONCF4UpEjUjTqKKyJK5OeRI?=
 =?us-ascii?Q?VaWDG7i8SW6Fwq9YHk73SuIEfZg4+LfOX95xBejOoS0g7aRLNqQWPfhMseA0?=
 =?us-ascii?Q?gaSRufk0wZg0wSFaW/41QI1C5CxnO3CJMGmvv+LdbkSC6btfizqU0s30PwAq?=
 =?us-ascii?Q?PAwugg8VAl6uXmDpsUUgw/+mz9C7R0l/b2EXGOUc8N/m4lSFQxdFvktJoa6g?=
 =?us-ascii?Q?sTMtNjxc9xVX+tRCyfx4YHFWkouB9ZDVCBGIOZOmM0QaI2R/3vgLnj82a8+g?=
 =?us-ascii?Q?rxOM47/93ft/5+yHilC4anNdjjb3INt+RtVNqIM9IB4LMdyuXnCaX+ggKPef?=
 =?us-ascii?Q?6Nam5JxnhGeW6AQf2YzVBZ6oi9vPB4jSp6a1yA0rG+haup6Pfo4CliU5jaf3?=
 =?us-ascii?Q?X5b6EWjiQ+SDL68eMCR+noWegfA2oqV+D2dNmpbXv34f8B3Dqr/bNIh0JDR+?=
 =?us-ascii?Q?/gMLSOdgJbJeisIIYLklpQBxEGwOm5daAhvJhA6GZIq5scwmnGbCAO6JZ2L9?=
 =?us-ascii?Q?CiNsXPy0vQcWxaEbR4ky+1yaa3fHrEjjQacpgOSIEI9kaVUnh60p7wAYePWI?=
 =?us-ascii?Q?4QU1ndvT454PHGCUgLNkMptBx/xkuiFAraZ9NyQ/K2YcM/EBS3OZEaQONYx3?=
 =?us-ascii?Q?ZECVjRNzVKet7a9t9iA+7mCDJEG6H3h86C96tCjsUsSYRJS1VGQzwSH33z74?=
 =?us-ascii?Q?fz3n7Mo2N3Il/1f3kgJ10aqj622N9CQB4ZiG54AUf91E/wIvKgxOo32+ZcKt?=
 =?us-ascii?Q?wRhDCLjUGdhn0Mfr5Zk1gPdaNPyhu7ycxnr1LyS53rjvKpZqF2yhFvZHJGve?=
 =?us-ascii?Q?f0qFknJ10ngip12icazLw08vH2nnAzHJEPD77jDd0pLClMU5erb0DJ35O277?=
 =?us-ascii?Q?+EN15/JD76oNO7yurMyaBKisRrsaikf/RLh3H+kPdn5IXnYAJBBmm2cfHgQM?=
 =?us-ascii?Q?eaJ2dOxYnXXZviKBkVjbiP6oriu+twEgRZq5tGLqM4nmsV3FqCkj5pq3ZIQq?=
 =?us-ascii?Q?k3AovQbT2g4UgKzKwC6PuSl/jZAj8sFAPyU6Y1B8VrKkFON3DyfkRctnu7Wm?=
 =?us-ascii?Q?fg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e454bc23-1f9a-4508-dddb-08db83b246ac
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2023 15:03:11.7924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U4GvCueiGI7hwmH48O3WAKUGDi4Hop7S23S9I0UBfkq8VecT2cFb0jV2bmxphhMn8H1RSjXXO2wl9G6GtKu9YfQ1VD1su1zeKXHUmEXnldI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3643
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jul 12, 2023 at 09:32:36PM +0800, Lin Ma wrote:
> In current ctnetlink_parse_tuple_ip() function, nested parsing and
> validation is splitting as two parts,  which could be cleanup to a
> simplified form. As the nla_parse_nested_deprecated function
> supports validation in the fly. These two finially reach same place
> __nla_validate_parse with same validate flag.
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
> Signed-off-by: Lin Ma <linma@zju.edu.cn>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

