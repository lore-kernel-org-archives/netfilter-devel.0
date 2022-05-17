Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B956CC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 May 2022 16:20:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347758AbiEQQU0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 May 2022 12:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiEQQUZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 May 2022 12:20:25 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2052.outbound.protection.outlook.com [40.107.243.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3892D3A5FC
        for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2022 09:20:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OR+wMxH3yY5A/x7AEyEjd/RMSvlAK4JSOlWNgPkQhIws5ij5JQ2z5rhXjvMUSxC17NbNup/JvVGGFAoDI1KJb6UYKrnPQgLxPZn0t4IYZdrMbxmC5D7UN04dWVY0s2AAmtcTFa4vP8yvaWYt5/yDpTIUSydvuAnv0sXC7yy1D81cg7gN8KNdVVCMuoDhOf1zFz+fHtHD8zdyuEOtnPxAfXoG1iE80Lkjp/sfNsVhP9QuMDFDdZpkUrmRNIvfnPzK6KAnbqTDGrtXfaChU8G811R2JuimnNMiIXQra3Jw640h7CyPaMcyWvGgNUAlPwbFCLRNEvGyjHmQhtREFWfwIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IIZAJi4qeClYU3D/dlyvr+5ma/n1IltdZVY5ZuaT8oc=;
 b=LxMVrg2u45hPrQN9goqRTk89LwDnBgoDDsz8WTfVIkrHd8HNjau6Lvc56fvygPfHx52hplf2N5gM5vRRoind7mRcBq0OFrKqwQX4yPU0vARGYExxGpJeSJh6nQLc3OIwSRMjBJcqwom1fGt2fbsfArUptp4lCRHul38q8wCIHGjz6O0LLcR7JY5CAohV5Xo+ULeMiiAF4FBfecNiWWE+P5uF1HRSpZDtulWDgzeiWX9UyJFccf2xFPShBROPceX9FefGH9X7uROLBfVEZMWMqtz4Qt99MVriXBKnbaBcqDOYDLpTnheSURVXQc3qANh6xzX8rEIkZVfL5q9Xmb6LjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IIZAJi4qeClYU3D/dlyvr+5ma/n1IltdZVY5ZuaT8oc=;
 b=lg2e2J4fs+C+gpZ7qZX3lLMTBsL2pKq1my7uusPVdUr1V3/WABD/z/LpHGJLbQ68+aHmR8BTD3sDVEgSxJeoXcy0l+BQ27yKwvwR3RFbAwNtrRTEjvOQcNhh2BWc2EP24yuKAHBj+Kj6/yUl6+f0hZOsKZOpy5ZCe7WKuSwIP8d+k7lXdQdz0/jSD3s/fHj1u0d9bFEjy4VbqvAiUsydxTFKIZ8L2bmbG4MC+qud1oe9IBD2A2JDB0DhIIEsfr/N0mSIPNtYPBy9JBNdd9qg7eGPJAls08WKoPwveCIBQmflYyo0uS1LRXvUpP4qr05SF/KDZNTQIH/ZiGLA36aONA==
Received: from BN9PR03CA0063.namprd03.prod.outlook.com (2603:10b6:408:fc::8)
 by BY5PR12MB4855.namprd12.prod.outlook.com (2603:10b6:a03:1dd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Tue, 17 May
 2022 16:20:22 +0000
Received: from BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fc:cafe::2a) by BN9PR03CA0063.outlook.office365.com
 (2603:10b6:408:fc::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14 via Frontend
 Transport; Tue, 17 May 2022 16:20:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT068.mail.protection.outlook.com (10.13.177.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Tue, 17 May 2022 16:20:22 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 17 May
 2022 16:20:13 +0000
Received: from fedora.nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 17 May
 2022 09:19:25 -0700
References: <20220516191032.340243-1-vladbu@nvidia.com>
 <20220516191032.340243-4-vladbu@nvidia.com> <YoOFA1Tz68/rQDR3@salvia>
 <87mtfg76ex.fsf@nvidia.com> <YoOUhKnNvLNudyjr@salvia>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <netfilter-devel@vger.kernel.org>, <kadlec@netfilter.org>,
        <fw@strlen.de>, <ozsh@nvidia.com>, <paulb@nvidia.com>
Subject: Re: [PATCH net-next v2 3/3] netfilter: nf_flow_table: count pending
 offload workqueue tasks
Date:   Tue, 17 May 2022 18:18:05 +0300
In-Reply-To: <YoOUhKnNvLNudyjr@salvia>
Message-ID: <87ilq46vbp.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef3dfd0c-0591-4fbe-4552-08da38212472
X-MS-TrafficTypeDiagnostic: BY5PR12MB4855:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB485573AF929A2FD5B0C6B119A0CE9@BY5PR12MB4855.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jf+yPVq/1tF3hzQIzxTm7yYz14ogvhcnv+jmzNBm+kPbpK2KznWPeoy3V0MsZvj/OxPLTvK5okvnUPH+xblEr4UEFsKvEaT15cE6H1l1xm+2jQtxsPiQNpQEdy6YEq6yi+9jllUbA5Bpf0JjZCrz2LOSmC6WHNvSjayfWV/GOWiuSakwxASXro/k7G+IwTUxiBfo0apsHujzz3wRujwDunwNAMN1kn0GW+WtB01+DoZVHFZhMWeZJOVkeDa6sloKsdBcWvK16P73P0uQRMPVBjCwF+u20nygRtPMnSFcrM7G3q3TzU8dBtZOjdCAaQa4i85bZA0noi6bJ7tz2lN2mY8G2Be9Ebg8wqNDq+fcI1LJMrJVFMguvQGBUJANmym/jmDVNvsUQHhas1f7Hp0U+V7EHdLmlWMWRtJql4yuXMP9vzOEyvkW2mgBw0g3cP/XIgoHglCcqfZznwgKRIlGAdMDt5qBHhQdBJiAE6G9CuRzC4RK78hVR6wJ/yu9XTRgXMEhtg/+AKy5SgLJThuXxXMYytpci7CD3hukuWIri49pDvDeTY8o2o/14zc1iTr745xAa9kNVlz3od/owUTeqNatdfzq8o7QEt93J5+VNCtrqNojXfczJJaGCl2UoZ/NejR/O+cT5evcHIByL87tEP+us8AWWDhrVB5RUTTPN3UW3xXjfS9Ty/Cp98zV+OQ+hgQEuj53hXznohtD18hw/Q==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(81166007)(356005)(86362001)(36860700001)(6666004)(36756003)(26005)(6916009)(82310400005)(508600001)(7696005)(16526019)(107886003)(2906002)(8936002)(54906003)(4326008)(70206006)(2616005)(8676002)(186003)(5660300002)(336012)(47076005)(426003)(316002)(40460700003)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 16:20:22.1016
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef3dfd0c-0591-4fbe-4552-08da38212472
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4855
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Tue 17 May 2022 at 14:26, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, May 17, 2022 at 02:16:04PM +0300, Vlad Buslov wrote:
>> 
>> On Tue 17 May 2022 at 13:20, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> > On Mon, May 16, 2022 at 10:10:32PM +0300, Vlad Buslov wrote:
>> > [...]
>> >> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
>> >> index ddc54b6d18ee..c8fc5c7ef04a 100644
>> >> --- a/net/netfilter/Kconfig
>> >> +++ b/net/netfilter/Kconfig
>> >> @@ -734,6 +734,14 @@ config NF_FLOW_TABLE
>> >>  
>> >>  	  To compile it as a module, choose M here.
>> >>  
>> >> +config NF_FLOW_TABLE_PROCFS
>> >> +	bool "Supply flow table statistics in procfs"
>> >> +	default y
>> >> +	depends on PROC_FS
>> >> +	help
>> >> +	  This option enables for the flow table offload statistics
>> >> +	  to be shown in procfs under net/netfilter/nf_flowtable.
>> >
>> > This belongs to patch 2/3.
>> >
>> > Then, use NF_FLOW_TABLE_PROCFS to conditionally add it to
>> > nf_flow_table if this is enabled in .config? To honor this new Kconfig
>> > toggle.
>> >
>> > I mean instead of:
>> >
>> > obj-$(CONFIG_NF_FLOW_TABLE)    += nf_flow_table.o
>> >  nf_flow_table-objs             := nf_flow_table_core.o nf_flow_table_ip.o \
>> > -                                  nf_flow_table_offload.o
>> > +                                  nf_flow_table_offload.o \
>> > +                                  nf_flow_table_sysctl.o
>> >
>> > this?
>> >
>> > nf_flow_table-$(CONFIG_NF_FLOW_TABLE_SYSCTL)    += nf_flow_table_sysctl.o
>> 
>> In V2 I have both sysctl and procfs implementations in single file.
>> As I replied for previous patch in series: Should I split those in two
>> separate files (nf_flow_table_sysctl.c and nf_flow_table_procfs.c) that
>> both could be conditionally compiled depending on their respective
>> configs?
>
> Same file is fine.
>
> Probably instead ?
>
> nf_flow_table-$(CONFIG_SYSCTL)    += nf_flow_table_sysctl.o
>
> so the #ifdef CONFIG_SYSCTL in nf_flow_table_sysctl.c can go away.
>
> you would need to move:
>
>         unsigned int nf_ft_hw_max __read_mostly;
>
> to nf_flow_table_offload.c
>
> Make sense?

Yep. Will send the V3 soon.

Thanks,
Vlad


[...]

