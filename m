Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB16C761A6
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Apr 2023 08:53:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjDCIxr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Apr 2023 04:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjDCIxq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Apr 2023 04:53:46 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2093.outbound.protection.outlook.com [40.107.14.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8276D172B
        for <netfilter-devel@vger.kernel.org>; Mon,  3 Apr 2023 01:53:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NNTn/y4SnUm+ASFXgwgr2DsG7s8Es4IDjKdXmHzLTMAAZcxKduAlxHufbXRPavVvpNdGpT7Oh3m9k8ubfdmoq5zSsRdnD7GQmLOaty9qhlLborFnXayMbULFc1npvJa0ogZvAs8CuuLjnOVvCcB1d/jWzzGLO1HmNpfjGvpEu/LpfavN4NHLjlmVKkR4QiJy1GM15lykUGf5O6W+V+yGqhvD4AIOPVswNBmPzMslAUptgXK5VqBJGcpwWEvWQMFHpBzrXD2JFOXwPfnh9NbiLjlINuAcHw+SnJ/gp+PHSne4MX6G7UDMB7Wxri6F25O98iWQO1cj6iwbPdNbgcYxpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eoCVC8E9Yzp4RiWPSbwodDdd7Yr82so7NmNzJYGOE/E=;
 b=m8wGnidKuw2Z17HVb2BoT+Iw4WClBR7yeffNJdFQSCH32PuFhhs+LlPS4AjuhD5DBmh9mmOzDH9Rm+l0E+AbTllqHCW7r2w6W7a4b2TDDdjrd1gvDZJVYy6CB81/B8TgTlUQMZ9t8sDKJNe6Xx5nHN0oMEmLtgEH/EtapX24CEWdo3Hh3SB14ErV68Cu89ySR6Vk3VdS3ohdDPwRAmi3Ijlri6adlPJq6UlVzKTeuVc8cV4bAoOohbLa+pgtpStahB2nrZ/N1qg7U/BdMgM2Qzo4eR37u3XZ9A7m0RfJjLst+9NHT0qHSTB5c2g5RNnoiw78ypsEcbIM9UA+PITy5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eoCVC8E9Yzp4RiWPSbwodDdd7Yr82so7NmNzJYGOE/E=;
 b=SYmu8OqKlv0rwDKoEtmO6EKAPdDcgxX+T1SsL5vUYSLew8/f1VrNKdnDJI5hGBY0Qk3N+f9t4SBSV3WulYsKBcRqmqY8CCzX8Q0Og+TKtIWTw6PtLF4HhOrg8b4etY3wl5mVcBADvhXzHshijh2a596VSthL+1cKTzU8eNmJa/A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com (2603:10a6:20b:438::20)
 by PAXPR05MB8557.eurprd05.prod.outlook.com (2603:10a6:102:1a2::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 08:53:42 +0000
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d]) by AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d%8]) with mapi id 15.20.6254.033; Mon, 3 Apr 2023
 08:53:42 +0000
Date:   Mon, 3 Apr 2023 10:53:38 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        abdelrahmanhesham94@gmail.com, ja@ssi.bg
Subject: Re: [PATCH v5] netfilter: nf_flow_table: count offloaded flows
Message-ID: <20230403085338.5tj6uiszyxuvhxrk@SvensMacbookPro.hq.voleatech.com>
References: <20230317163300.gary4wtvrbyyhyow@Svens-MacBookPro.local>
 <ZCqOewgq0z9tGXi7@strlen.de>
 <ZCqPRPaHuXXhjb66@salvia>
 <ZCqTZ6XK/vb87Hyt@salvia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCqTZ6XK/vb87Hyt@salvia>
X-ClientProxiedBy: FR2P281CA0081.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::8) To AM9PR05MB8857.eurprd05.prod.outlook.com
 (2603:10a6:20b:438::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR05MB8857:EE_|PAXPR05MB8557:EE_
X-MS-Office365-Filtering-Correlation-Id: 04bcb06e-75dc-4369-437a-08db3420ed00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1xSkAKT17RzOHSVDMw7beRRG33jwQ6jgAcBUJNCLda4NlAZTKKInpBWJVXKu+uat00H8MdrOiM50ZrlFEV7MPK9p02VBAE5ZMcQLKxUFALwDKywQ7Ngbdtk9e6dIiZ35renV6j4KeMzH4t8F71/hITQT9WHJQI1I9v7uU3l5UyRGRfDwsU/hGFGc8bBhKE6Km/xHvbjyosIPIyM4YK+AgxExoeadnc+OrwykqDzS6HlCLsHsUR9c8IfrOlE3wdkdiVNsA1P7smkk8KvhgIzCIFJRvZ6k4I8TGP7ZIZ5tVwehSICJ1q4PsUeCkAHN0EWaFs8rVDC1t64JaLTqmHjaoAWl4vanCa8++ErqxITrgKlXWw4letHhbJipUvHnBhVOAhtHvjkunQt6GIIkv4F8r5xkJWlwAZGHS6yOI4zPOegnOHM6//d7BDn0R8ABjUACXxug9FeX/leu/WjvGycQEsns0p0TwqLZ6XzTbxU2Bl63LC/SON5Xs0os53Kp4vxlPB4wCzWXF1CmMctcVS5HbiwxAdQiQwT9Ti1Tol0tEUlTyz+NrIqRK/9LXZJIiJiA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR05MB8857.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(376002)(136003)(366004)(346002)(396003)(451199021)(83380400001)(8676002)(4326008)(6916009)(66946007)(66556008)(86362001)(66476007)(2906002)(41300700001)(316002)(478600001)(38100700002)(6486002)(8936002)(5660300002)(9686003)(6512007)(186003)(6666004)(26005)(1076003)(6506007)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?USdk96EG2k1PvWpM2Ku27OWi76ObO+bN7yHVH7iiSlm4MEWGv/IzRCrIOhx5?=
 =?us-ascii?Q?ogCpnlfQDjkCohrX2A+YR3AmWKCU7hHciec7zF8fTWq4CfsICPDAT2OK3Loy?=
 =?us-ascii?Q?RiwptFTU8Zt29vvyJyz/GHTKMkZztBFtJh/egJGslh552qHDanXDIIxXiP63?=
 =?us-ascii?Q?AuBmg8FXtuBV0BoKYtH4vL9AwehHCgte5R2XxUxdv8wHWtHaJCgBJv2ycZ80?=
 =?us-ascii?Q?lLxdMpvRYbB4UYZ2z1/8lNRzPNpVQNYbq9N8OXGXKXLhC4TJIIedQ3a7ImdK?=
 =?us-ascii?Q?8C+1t2jUmBxh2oqT2EnBLk2i5FnD93OsuPB54GlW2O4adUUDg7vy300XjY0g?=
 =?us-ascii?Q?CF3tMnhYeNUxTbsWPQCqkHyRsgDZFcA5tUYHIm8+bhhugdUfpmypmhiK/uUN?=
 =?us-ascii?Q?06FmamLqZ9acs4NBgLcTBk4bFkQ6bl8w/m8+FfeKUatjBVlIYH2A1BspLFPh?=
 =?us-ascii?Q?2S64ZI9N2dhSHFYU4vlgj8oz1+g7YNYGluK2tWW3ihH4r0l090ZypV6Kjlls?=
 =?us-ascii?Q?EtTcu0oAb58cDiZSyiukjwbilBsufMiSta5xoXQMdJ1PElU7D4XZ8frOdyra?=
 =?us-ascii?Q?58IB7MudupNhsTP4WWLAmdAd32pSvkV1vOY4VqH/cAQyhkMjQjEv64AlveTh?=
 =?us-ascii?Q?SXzwCnwzzQh/WoYFhVfuMfYczNzX97/OduX3Xz3QXaRoSfBZtgVDrbhlKAJL?=
 =?us-ascii?Q?ZZF8xF0NlaCwyEGqm7W706Vzul8y4xiYmGNcga9Aw3GiApPGbeA1uPoMvsDo?=
 =?us-ascii?Q?/KmwVzpxxuZBzdg8KgRy3TjKpUJ0DbH2VjtiFc6t2zZaxwxwcJjunH3j/afe?=
 =?us-ascii?Q?bwBevGh1RnYLT+wp3sWLNKApMxamhOLZEkSkWp4gGSpb+xI2V0UtPz274lNv?=
 =?us-ascii?Q?4t9Rvu+3+iGX6ve/hwtCnplhuwHmeDmhbWn2zyR6TdUAtJAylIvLHkOqebVH?=
 =?us-ascii?Q?ICn8Jkr0paxgM9Y/pOS12bK2mU5/sryp0HMRWS+hJQj6MGoBvwL+VAK6iTWj?=
 =?us-ascii?Q?rlt7aog7cAlyeEiUUsPJrCg4AqaSlHSshQcs9ltUfSfvI5a8hv0M3SxvgxaK?=
 =?us-ascii?Q?AkEG2PwPVPQxHD7AaNcsBa6Mljixa/rJcISh7AH4oxstraXZx78F6ftEnKrf?=
 =?us-ascii?Q?hhBmrm0kRFLPZNp9vOUmW6agjfSeLz/DkZJ0xAGemk5ezIAXPle3ZStl+TD7?=
 =?us-ascii?Q?fncaizGZE4eLWEeATt4TCfqz67gpUsP69wrKWi4P4qpvsrIx7LQBdIg4QF6y?=
 =?us-ascii?Q?/t2pC8hmL9nOJ3mVq4L/jwX+av4BszDDX6/aWXWzp/PHrVWSw545j2lvsziy?=
 =?us-ascii?Q?R9gyZvPZjY+3vrND9TNq5RFYpSBHnKNMnNOy2wPlImc32VdQEQxeOhI2McdV?=
 =?us-ascii?Q?v9tXKHPxDtCY09pB6bBv6JSIzvaiE6pX5Sw8C5ZUZIhEN4bVrXzd+shzD71N?=
 =?us-ascii?Q?uR3temQZ/Jy/1r9XTEkVxLJhkKvje2sdH80hcJzEj2ggPUqqFfHMEV+gbyki?=
 =?us-ascii?Q?ZAocOduEDePyWd7xVI3xgn43B/eoTJ25FYJddv4TlUZ1MZW4n0Kynm6uHq+f?=
 =?us-ascii?Q?wcMs+LAFiuhedFeE7s4QlfJOaBVXpVZ6bDE8xei53cizIgUZ6u4CsTb0tsy1?=
 =?us-ascii?Q?hA=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 04bcb06e-75dc-4369-437a-08db3420ed00
X-MS-Exchange-CrossTenant-AuthSource: AM9PR05MB8857.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 08:53:42.4409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C7H5t4/cKeVfvmAGbvPXtVLi8qBQtLtJ2fLXotYWecKypZUs5jcC+YhuGMtM+2EHPIMrPn2iLVq29xuVmC8V0Jnwxf8ycnB2dr/p6B/OHxk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR05MB8557
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Apr 03, 2023 at 10:50:47AM +0200, Pablo Neira Ayuso wrote:
> On Mon, Apr 03, 2023 at 10:33:11AM +0200, Pablo Neira Ayuso wrote:
> > On Mon, Apr 03, 2023 at 10:29:47AM +0200, Florian Westphal wrote:
> > > Sven Auhagen <Sven.Auhagen@voleatech.de> wrote:
> > > > Change from v4:
> > > > 	* use per cpu counters instead of an atomic variable
> > > 
> > > > diff --git a/include/net/netns/flow_table.h b/include/net/netns/flow_table.h
> > > > index 1c5fc657e267..1496a6af6ac4 100644
> > > > --- a/include/net/netns/flow_table.h
> > > > +++ b/include/net/netns/flow_table.h
> > > > @@ -6,6 +6,8 @@ struct nf_flow_table_stat {
> > > >  	unsigned int count_wq_add;
> > > >  	unsigned int count_wq_del;
> > > >  	unsigned int count_wq_stats;
> > > > +	unsigned int count_flowoffload_add;
> > > > +	unsigned int count_flowoffload_del;
> > > 
> > > Do we really need new global stats for this?
> > > 
> > > Would it be possible to instead expose the existing ht->nelems during
> > > flowtable netlink dumps?
> > > 
> > > This way we do not need any new counters.
> > 
> > I would prefer a netlink interface for this too.
> 
> I can post a sketch code to make it easier for v6.

That would be much appreciated.
If you have a recent example how to add a new attribute to the
netlink interface, that would work too.

