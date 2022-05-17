Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43D11C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 May 2022 12:20:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235498AbiEQMUA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 May 2022 08:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233456AbiEQMT7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 May 2022 08:19:59 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFD94830C
        for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2022 05:19:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iwiydj/G3sC3ohO+2Iw1PbeFdZPJNm5+6CymEX/3ZNTgWz6cXmHoCh5mqe+wOU8+usbJYpRNF4obx2z21SntE8trregM2DMszCJjmWPiC/h70dinZRYlqqA3b8E0l6xMwuXRvsNQDZwRSnTj1ZUOM7KgBcXniLtfp3DPUlkv5R5u/hVVEfEuf4IufZ3YhLhyDh6dFpt9LeFsZ4KG0DEGPheIA25NGYUb0EC8Rf8IVqajfP4iNUlr0twzGsX7sAhlHK9vgV/m6IDsL8ZovnQsQKMfFwc//NJP2Bp2d41jqR2puwbGa9N9Wbd+kaJRhHZFyQE9/HQg/8t/VCH037R/Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9DWmj0qGeGGH5SbMnWA/ttOlRu8Rp3qjy2tcrq0zsmk=;
 b=DiGrjNuSbHIqaY6e8zHGNejY+Cs+b458quFpKVKrE4iG1cKAVkfHrsgyCiUpUS+U3qsk6fXqfJ5Mde44vpkI8e94PgGVKB6465Zt5HS12iu1LT7s8UzMKXURLSaMfQwyL6fPRa/50fgzw/BP+/qtPZyLdSzWMMjkYeIsDG67osJLJkiGPogcLtlhzLp+CNVQjxHTFoIVTd4U8NPCLIz/i5Qm/4z/GWhYuTMMSRHoL8aw0HllJdPwsH9YMDuu56/3NCIpP//qYjWEFqxq47xWffK15bpQeVqWkuG0L06TG+0l8lzcJfMpIrY//3rQqTf+XAKJU+8KYoOKk88OuNgGUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9DWmj0qGeGGH5SbMnWA/ttOlRu8Rp3qjy2tcrq0zsmk=;
 b=YkJjtJV4K+UkGR9zqEAwnT1A23ATbgSN030COf8s2pupvXdktH+9IvxDbu2IwnpZuqFeZd9ygPMpJ/8mQ4wBON3qsJKtBy3Dd1T04DdF5pBeOorlks3gfjTm4pp6xiKKln/ffiZq4kulPCpE/cNnSQZHu/EaAgUmNN6veYL+qWhJUsYQvOC/lRAmmcuzk4pB4Mbhu1Zt//jboDqHYpgVE8wbUPmRvul8aSFnZxeTZWOsUs1EXt9wfcyflqNUnLHx/8x5acBplKJkMO4nNV+GgU8+v4Q8ATqAVGr9ZtQvhnn+fAHw4e0k3VdHjR41IzRAEXWK7KICemzQhY720LWYaw==
Received: from MWH0EPF00056D03.namprd21.prod.outlook.com
 (2603:10b6:30f:fff2:0:1:0:d) by DM5PR1201MB0172.namprd12.prod.outlook.com
 (2603:10b6:4:51::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.16; Tue, 17 May
 2022 12:19:56 +0000
Received: from CO1NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2a01:111:f400:7eab::202) by MWH0EPF00056D03.outlook.office365.com
 (2603:1036:d20::b) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.4 via Frontend
 Transport; Tue, 17 May 2022 12:19:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT052.mail.protection.outlook.com (10.13.174.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Tue, 17 May 2022 12:19:56 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 17 May
 2022 12:19:55 +0000
Received: from fedora.nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 17 May
 2022 05:19:53 -0700
References: <20220516191032.340243-1-vladbu@nvidia.com>
 <20220516191032.340243-4-vladbu@nvidia.com> <YoOFA1Tz68/rQDR3@salvia>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <netfilter-devel@vger.kernel.org>, <kadlec@netfilter.org>,
        <fw@strlen.de>, <ozsh@nvidia.com>, <paulb@nvidia.com>
Subject: Re: [PATCH net-next v2 3/3] netfilter: nf_flow_table: count pending
 offload workqueue tasks
Date:   Tue, 17 May 2022 14:16:04 +0300
In-Reply-To: <YoOFA1Tz68/rQDR3@salvia>
Message-ID: <87mtfg76ex.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51973ecc-b4ec-41fd-d130-08da37ff8df1
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0172:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0172B83661619868F46A02D7A0CE9@DM5PR1201MB0172.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xxesIYa/mhUc0838B2R/QULCX83EuzCsi4S34mhdq6Lrkpm9O+QkwQtqSpbiBa/016SUrHKhRHJmwfHSOkLGegpjFVJVr8ujaRe3xeZcw4JMVq+4kQqByub+g2fL426pfLoSuTr49skeyNlwzS2qPsq9wz1T7esBNQWPw5yNdfSf8fH1HESeP0zU9sM3DjkwmX/JvVN4eEqEsrhRAp3IiqOaxwcS5rw8YooclvTbOjuKQ6b95FU29GYXsuK9fhavpqG65yyxrTpAiBudpx+5H+AkFg4ovp/ngZCcsCj85Bt4Oj/YmG74nS3AAr+5CLRHkG7xOnhpYkdADaRzEOmsDeV2kur2+ecdDcJM6RrG4G9VO6RPJ0VzVchGlbT0az9Mir5+HGJoTBkP2SBF7XAiu65Hxgd6WI9K0E/M5S2AWIjc5CplWzfhyMaei/B+v9cW2EftT7sRAblW6xw7WGFcUUqsdWtSLu31wXiLx127hqevVN5bxh0re0v9yt/nxXuc28d2bqB31/aZWlzn++StFEUf8mRlbk/FMUtXHWkPUedBciMh72eR4rVqaquJeVDKYoFDyUFSkdQiKm2kFeP+6p8QYPSNShC3XqKYKBaW3eSq7MP3gOlVJ5C5soiDLLNueHsCsPlEC8tiNmd/y91ir6ZJ3BHU8dVgtIhyrRjA0VtSDaYDgwtrQZmucC+QNdcrSS09EPpmPPhoybC3yeyfWg==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(4326008)(16526019)(82310400005)(36756003)(2906002)(81166007)(70206006)(70586007)(6666004)(7696005)(36860700001)(8676002)(40460700003)(8936002)(2616005)(6916009)(86362001)(54906003)(356005)(26005)(336012)(426003)(508600001)(316002)(107886003)(186003)(5660300002)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 12:19:56.2876
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 51973ecc-b4ec-41fd-d130-08da37ff8df1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0172
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Tue 17 May 2022 at 13:20, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, May 16, 2022 at 10:10:32PM +0300, Vlad Buslov wrote:
> [...]
>> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
>> index ddc54b6d18ee..c8fc5c7ef04a 100644
>> --- a/net/netfilter/Kconfig
>> +++ b/net/netfilter/Kconfig
>> @@ -734,6 +734,14 @@ config NF_FLOW_TABLE
>>  
>>  	  To compile it as a module, choose M here.
>>  
>> +config NF_FLOW_TABLE_PROCFS
>> +	bool "Supply flow table statistics in procfs"
>> +	default y
>> +	depends on PROC_FS
>> +	help
>> +	  This option enables for the flow table offload statistics
>> +	  to be shown in procfs under net/netfilter/nf_flowtable.
>
> This belongs to patch 2/3.
>
> Then, use NF_FLOW_TABLE_PROCFS to conditionally add it to
> nf_flow_table if this is enabled in .config? To honor this new Kconfig
> toggle.
>
> I mean instead of:
>
> obj-$(CONFIG_NF_FLOW_TABLE)    += nf_flow_table.o
>  nf_flow_table-objs             := nf_flow_table_core.o nf_flow_table_ip.o \
> -                                  nf_flow_table_offload.o
> +                                  nf_flow_table_offload.o \
> +                                  nf_flow_table_sysctl.o
>
> this?
>
> nf_flow_table-$(CONFIG_NF_FLOW_TABLE_SYSCTL)    += nf_flow_table_sysctl.o

In V2 I have both sysctl and procfs implementations in single file.
As I replied for previous patch in series: Should I split those in two
separate files (nf_flow_table_sysctl.c and nf_flow_table_procfs.c) that
both could be conditionally compiled depending on their respective
configs?

>
>>  config NETFILTER_XTABLES
>>  	tristate "Netfilter Xtables support (required for ip_tables)"
>>  	default m if NETFILTER_ADVANCED=n
>> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
>> index e2598f98017c..c86dd627ef42 100644
>> --- a/net/netfilter/nf_flow_table_core.c
>> +++ b/net/netfilter/nf_flow_table_core.c
>> @@ -662,17 +662,51 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
>>  }
>>  EXPORT_SYMBOL_GPL(nf_flow_table_free);
>>  
>> +static int nf_flow_table_init_net(struct net *net)
>> +{
>> +	net->ft.stat = alloc_percpu(struct nf_flow_table_stat);
>
> Missing check for NULL in case alloc_percpu() fails?
>

I might be missing something, but why isn't NULL check in following line
sufficient?

>> +	return net->ft.stat ? 0 : -ENOMEM;
>> +}

