Return-Path: <SRS0=9gIA=6L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B2CC4CECD
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Apr 2020 21:02:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E12D206E2
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Apr 2020 21:02:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=Mellanox.com header.i=@Mellanox.com header.b="PqpvnO9D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgD0VCn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Apr 2020 17:02:43 -0400
Received: from mail-db8eur05on2079.outbound.protection.outlook.com ([40.107.20.79]:30625
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726285AbgD0VCm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Apr 2020 17:02:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DtxtCM9lctigT3qNZbLJgmuPn9OpBftwlW2nfZiowufeIhgbyxmbz+AinerlYIG3U8HCF5HjZ1S1SfX8zEYYWPfS08xJ+t5D1s35Enbn3CdwGrseQyr3ToqhlUMw4w2j2QzOLZ6F7R+yBPL0O2ytHR6RzoFyrL3WKs7Ds4EE4eIrMo50meAiBGyZ7pDAdmsdaMOa782xsGMzpjTZ8o7OPtvwvA2Ss+vMMqfVlbvtEZV9zBpuAHW8etizt4W21ZFOsheVnvM2QhKzCQwlec+6fF9bTEO73BK68vU8axTH2gcW3VmzN3Q/pKVwiOW/kS5yupQ1F7cfgbwZMZuNiZbIig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PS4PH+yAoRKyllX+z6B34yheaQXiF2iTGAhZCEfobwM=;
 b=NINCx+f1batbtcRe3CXyX75fzA3aBRIT/RIMkDdp0ftPnPICMJUFc6fF/ThSYwmRrg2LkYVqRHvxhwlUDN/LRVkRE8nN5RKq+fzA+tYOiqsm2oPXEjEEb/HL+Deu3e3iFUiWnqVjfo/SnskpcOhdiIfVOstm+iznKC9iYOVBuF1nsqop6NQ885fCF5ju9QdZZ7RYGAJulRfhkaOt/Wj5YbWxXzxXbKgltIRyQZfTtU+5ZetRe6/R9DUc8Soy+eqdN8+arlsGjBW/T7cPDeSlc//y/e8OaC+MDQbLNnvP8CCN9cOWnzaXUN5y/vgvJKntMWOb5D+53lcmHJWEIbfd3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PS4PH+yAoRKyllX+z6B34yheaQXiF2iTGAhZCEfobwM=;
 b=PqpvnO9DXDb3CjJvPUISgDz3l/3zF7a9RqaaPOqzLKiFqQjcFOyuZqlNE/5YbessjQJ/9HKjBIgC5Lqq0ZgpubvAWUR2UWtQbV/ICBpvUUWTADCxwSCKBDPzBSRhDRFwsIioMr5sxKBHm/6PWOvEiVAvpu8/l9EgVvZZfqH65rQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=bodong@mellanox.com; 
Received: from DB6PR0502MB3013.eurprd05.prod.outlook.com (2603:10a6:4:98::19)
 by DB6PR0502MB2998.eurprd05.prod.outlook.com (2603:10a6:4:a2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Mon, 27 Apr
 2020 21:02:39 +0000
Received: from DB6PR0502MB3013.eurprd05.prod.outlook.com
 ([fe80::a155:fd1a:b743:9ac0]) by DB6PR0502MB3013.eurprd05.prod.outlook.com
 ([fe80::a155:fd1a:b743:9ac0%10]) with mapi id 15.20.2937.020; Mon, 27 Apr
 2020 21:02:38 +0000
Subject: Re: [nf-next V2] netfilter: nf_conntrack, add IPS_HW_OFFLOAD status
 bit
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, ozsh@mellanox.com,
        paulb@mellanox.com
References: <20200421150416.19151-1-bodong@mellanox.com>
 <20200426215332.GA2330@salvia>
From:   Bodong Wang <bodong@mellanox.com>
Message-ID: <fa12853a-ff0d-e1b6-dac1-60ea3b0798ea@mellanox.com>
Date:   Mon, 27 Apr 2020 16:02:33 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <20200426215332.GA2330@salvia>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-ClientProxiedBy: DM5PR13CA0029.namprd13.prod.outlook.com
 (2603:10b6:3:7b::15) To DB6PR0502MB3013.eurprd05.prod.outlook.com
 (2603:10a6:4:98::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.120] (70.113.14.169) by DM5PR13CA0029.namprd13.prod.outlook.com (2603:10b6:3:7b::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.14 via Frontend Transport; Mon, 27 Apr 2020 21:02:37 +0000
X-Originating-IP: [70.113.14.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c4430c45-885a-472e-5458-08d7eaee5178
X-MS-TrafficTypeDiagnostic: DB6PR0502MB2998:|DB6PR0502MB2998:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0502MB2998FD13F4C3B46C701DA75BAAAF0@DB6PR0502MB2998.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0386B406AA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR0502MB3013.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(366004)(136003)(346002)(39860400002)(107886003)(2906002)(66556008)(478600001)(316002)(6486002)(16576012)(66476007)(66946007)(5660300002)(956004)(2616005)(36756003)(81156014)(31696002)(186003)(8676002)(86362001)(52116002)(53546011)(4326008)(16526019)(6666004)(26005)(31686004)(8936002)(6916009);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dc46jPWEEJjZAlu+d3Y9dFXkitD5Y2yPW63PzsiJp+Gw1QsmI8UJ6wtgIBUrRgTwGtXqXlQjzqeBFNRE7OFfRzO+hEUsckk3WFSGGqONH67ycMqimKMKlBMjmJZk8ncnfDjc0Ey+Z+aJFjnMuCvNdyIbqd7g8idkA/qKYta/EnCxwuOhQl7ZPQirheI8AhSpECD3g7Pj8Jw2/bMOj+5ToS5rf5tcnQPF9HJXNfOgTqVwy/un34XNcGCIzs1U/8gnpE8MU/u20N54ued0ZjYE2o72l/ONnJRYjSb1g1gYSDopzpoxwA9iPl2NvrUNGrJukYODxBX8UBRSvi2mHPR+qnbvIZk5uCPn0DkVEa+yUYqN+Fr0nEIz7IoAI7IhIolljhx1hdnA+RKRv2ekxzYX8GLHHUBongc4JlGZ1HBOjppsMt2t3/wTJ++wZJE0e5xV
X-MS-Exchange-AntiSpam-MessageData: gRXGPzptgCgTmy0mHGHD76Ssy/62sYtzxO/paeQeubK1phK6spojvmAcCgR+TQBhVGCcsW19ybCf6zLkmxpgIM/s+7KosazNsDeWescgwrpNeeT1r0WZWPJD/xdFhDNnLw77D02jQy9gbGUuzMwiCGntX1Tlk6/1fhkKK1UpQtMszpzkGEnxulCmL9JmBhuPlOU3QDzKQYk0T+2Sl5aqk7U5RdS8hWSo53QH0DYy5s+foJgRzYVKLgFNgoms5h8ceG5PnTY0Q4DYcxTCFzSmBdBo2R2SHeUKWnfMyViJGyvPn8gAB1v999dxRIifVeQIYGzp5bIcGozKxsto7WsL3UN+dtiigc94dCeYvd/j9O95McRn6ccOKsO7B1Gi6lQQUOJcVFGA6HMkonnOdgCqWaehoSQBZrz9+jSpEDLMILSan9oPmrqOSytRxUPncDLVRp69LLy2S6X9VvDKYDSR8EPDYfyUt0Tr96xDhF2LvTNpUK881NIi3QFbojEP5peZyOf05jQOGYlZCsn3PVp8eD16NjK0XKjNdBucNBWCtNlf/LveGl2HVn6KPdoXg5qE+yA735K8Im6df6IETplbYI2ErSndLWp8y8Tq9KHc/GS2Z96FXEssKnGmSeHDJyefqHOvxN9EO4wk4Li9ElsLzk+I8Ok5UvBPZxMzBX7tytUpL9PP+EEx52YScuDIUttK3hWEmWmN6j7sdWzjhJXu4SgVEdPc0zxI4GXvGI+FWmhhRG7n7Oeog79axvT0LkEhgz5gpO4plmR31ZyHZZhHljQtwB44X+S3qwwBbY1OrRc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4430c45-885a-472e-5458-08d7eaee5178
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2020 21:02:38.8859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0PmfO6jDAKv/8rSGeziibyKvnrArV/2U3MIetkxkg74jDra39lEiwHsWMQ/bMI7Tjq1hzIEW73+l8hL9ZxMaKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB2998
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 4/26/2020 4:53 PM, Pablo Neira Ayuso wrote:
> On Tue, Apr 21, 2020 at 10:04:16AM -0500, Bodong Wang wrote:
>> This bit indicates that the conntrack entry is offloaded to hardware
>> flow table. nf_conntrack entry will be tagged with [HW_OFFLOAD] if
>> it's offload to hardware.
>>
>> cat /proc/net/nf_conntrack
>> 	ipv4 2 tcp 6 \
>> 	src=1.1.1.17 dst=1.1.1.16 sport=56394 dport=5001 \
>> 	src=1.1.1.16 dst=1.1.1.17 sport=5001 dport=56394 [HW_OFFLOAD] \
>> 	mark=0 zone=0 use=3
>>
>> Note that HW_OFFLOAD/OFFLOAD/ASSURED are mutually exclusive.
> Applied, thanks.
>
> Could you also test the following userspace patches for
> libnetfilter_conntrack and the conntrack-tools to get the netlink
> tools in feature parity? If they work fine there, I'll formally submit
> them.
>
> Thanks.

Hi Pablo,

I tested your patches, they worked well.

Thanks!

# conntrack -L | grep 1.1.1.16
conntrack v1.4.6 (conntrack-tools): 12 flow entries have been shown.
tcp      6 src=1.1.1.17 dst=1.1.1.16 sport=56408 dport=5001 src=1.1.1.16 
dst=1.1.1.17 sport=5001 dport=56408 [HW_OFFLOAD] mark=0 use=2
tcp      6 src=1.1.1.17 dst=1.1.1.16 sport=56404 dport=5001 src=1.1.1.16 
dst=1.1.1.17 sport=5001 dport=56404 [HW_OFFLOAD] mark=0 use=2

# cat /proc/net/nf_conntrack | grep 1.1.1.16
ipv4     2 tcp      6 src=1.1.1.17 dst=1.1.1.16 sport=56408 dport=5001 
src=1.1.1.16 dst=1.1.1.17 sport=5001 dport=56408 [HW_OFFLOAD] mark=0 
zone=0 use=3
ipv4     2 tcp      6 src=1.1.1.17 dst=1.1.1.16 sport=56404 dport=5001 
src=1.1.1.16 dst=1.1.1.17 sport=5001 dport=56404 [HW_OFFLOAD] mark=0 
zone=0 use=3

