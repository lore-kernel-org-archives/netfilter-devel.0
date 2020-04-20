Return-Path: <SRS0=IOUL=6E=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EEB6C3A5A0
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Apr 2020 16:45:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FAD120B1F
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Apr 2020 16:45:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=Mellanox.com header.i=@Mellanox.com header.b="iHqKvGlx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgDTQpz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Apr 2020 12:45:55 -0400
Received: from mail-eopbgr80070.outbound.protection.outlook.com ([40.107.8.70]:14854
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726049AbgDTQpy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Apr 2020 12:45:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LxbtYczBvNTH/FmMl/BWdrHrsYzybPf7Zf8vRL6CW//WxhkefHjZwPauzNIm9NR3hWEYL89d4rA6MI/aI0IwRa/YqBLLA+pidPEqcaTbBqT73SyNnAQN6FsjAAqVd7gjdejs0N9YDwaFzbjjCllaouBTX3sUGL37G3o55v5SwZ5hxCxchATD1GDbcba3VqqgJRKCyR4XOBQe+yIb7gyvNWlj1keFWh1FWjAnokff22HdhDUlj/umWba4FEsf2gDV/ZxAEF+lI9bsaCuyBjpeuGEIfh7wEvXJOScbAgglTxgcAr94PaBx5kiWIJw2Hbkmrq7CcHDqDh7YLcJmUw4h0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jd2b41W3e1Gy6Cc66cUjnDAn72kDOmazZE/nDBHqrwc=;
 b=nJEYDOUyzD1pi57kn+shCWmP/bGBekk0vQL+a4xAiSObHQeuivjmczOZdsFVR5lU7pkgm5ClZKgqjgdDMVeIzRZ0IHHgetihCOAtWWhYaw3qvK7ATlXB5Nty6nQU/SbVzUQq2rif32IrwIKR6xhUp1DX9GRd/oVxtIJjzuDoWHG8F7BOfOQE4ksjWGfKDx4Hns+klWS+BoYDxpMI/chmNaXDMIcaK0ytsSgjpX17QCBUheyRYvIFpjRhDccfl/2pxXFul2kK1AtA773kE+ZNcX8mXykdqKkqS6/ba02U70Bv50BJj24QydFMaBvaHDuV5giKmbY1SgBY2L7w7ane3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jd2b41W3e1Gy6Cc66cUjnDAn72kDOmazZE/nDBHqrwc=;
 b=iHqKvGlxz9iNGXsqr4u281w1H9e/6AmBEgZzSv1KEWrmcGUB01xaij/3FmLVeYd/Z2LF7xVTVBBqdQsmOG+B5Rr4UlP+ecT6xQ+vhTqd/bflsXStIejK37wDD+5EUpcEMiIxW19a8tovGVtl5ZGdT/sI95l4Sea4PsMsmtbCWsg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=bodong@mellanox.com; 
Received: from DB6PR0502MB3013.eurprd05.prod.outlook.com (2603:10a6:4:98::19)
 by DB6PR0502MB3064.eurprd05.prod.outlook.com (2603:10a6:4:95::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 16:45:50 +0000
Received: from DB6PR0502MB3013.eurprd05.prod.outlook.com
 ([fe80::a155:fd1a:b743:9ac0]) by DB6PR0502MB3013.eurprd05.prod.outlook.com
 ([fe80::a155:fd1a:b743:9ac0%10]) with mapi id 15.20.2921.027; Mon, 20 Apr
 2020 16:45:50 +0000
Subject: Re: [nf-next] netfilter: nf_conntrack, add IPS_HW_OFFLOAD status bit
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, ozsh@mellanox.com,
        paulb@mellanox.com
References: <20200420145810.11035-1-bodong@mellanox.com>
 <20200420151525.qk764gfgydbip6u2@salvia>
 <b5f1eaca-a2c7-01f8-2d20-89762f435eaa@mellanox.com>
 <20200420153344.c2tjwmohirlnd4cj@salvia>
 <1ea59d48-c0d0-34fc-f443-eecb2ec3660e@mellanox.com>
 <20200420155828.yyo2wwkwnpav4dtp@salvia>
From:   Bodong Wang <bodong@mellanox.com>
Message-ID: <1641b7e5-6558-7184-496a-840af538d9ed@mellanox.com>
Date:   Mon, 20 Apr 2020 11:45:44 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <20200420155828.yyo2wwkwnpav4dtp@salvia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-ClientProxiedBy: SN6PR05CA0028.namprd05.prod.outlook.com
 (2603:10b6:805:de::41) To DB6PR0502MB3013.eurprd05.prod.outlook.com
 (2603:10a6:4:98::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.120] (70.113.14.169) by SN6PR05CA0028.namprd05.prod.outlook.com (2603:10b6:805:de::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.6 via Frontend Transport; Mon, 20 Apr 2020 16:45:49 +0000
X-Originating-IP: [70.113.14.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6f0e9787-0503-43c0-8b3e-08d7e54a487f
X-MS-TrafficTypeDiagnostic: DB6PR0502MB3064:|DB6PR0502MB3064:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0502MB3064AD087FAA6B61F2874112AAD40@DB6PR0502MB3064.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR0502MB3013.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(396003)(366004)(346002)(478600001)(26005)(6486002)(2906002)(36756003)(2616005)(956004)(86362001)(316002)(16576012)(31696002)(6916009)(5660300002)(52116002)(66476007)(81156014)(107886003)(8676002)(66946007)(66556008)(53546011)(8936002)(31686004)(6666004)(4326008)(16526019)(186003);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +7oLXdwzaC2KmdGbEjMyhXr1CzJ2pztvH7hUQOdor5akcEQ52gpEFcBESJz4vZwTftt6tLgA0as69S13yCe27h9F00KTzz+a0KzbEwdvrpx9StkOw7fMZWk6WpNVK0ASJtko9L0nno2vgMAtowAXxQKUrdcKGpcV5yZ3YiO9T2ShvDahP+s+RIFWQEr9XbNnaHJUUTPRsYLuq41Kg7shzJqNB6yzjL8hggHZCXR8forCye3JoCu8PrFhj/NXJA5zaMNgws+KxtNufMOMVLoTY6OF1psPulklVi+Ddn7IDBGhtx7fL1nr3rYWrC2nGUQALzqpJHbyd64mFGZkNYYwEohYQOaAvc4rRODKFY7DaI4eAQNUFMKKTCdCSEn4ye8405jCuYTDZxnewxmgUUCtSrmYFWpo+JtYa4tcX58KrJFZ2RromfcaHUd9vmBhMRTo
X-MS-Exchange-AntiSpam-MessageData: cy//Qe1mjFPgZHQiJqkguEYMoA/zl1fdAHCHHPfKGNoNXW4YHwl3cJA3N0NFt+R2lJ+rioR3Lu2XHPPUpaGhCSx5S3reYv9bpx0O2i6waWFPzfR8JMt1pzdYo44DnuiYFoApsRUAoX6QX95KJnp7TihQlISdx4kW+Ha1Lat+Od/S5OSg3463y6Jwuk6S/pauZzv7sSNQhnSCYpvrlPdkJZd8KEfiMEPrsuIZw0g9irlcyMSlZ5GXTspnoGWgTXPGDJCwiLByRVWH/wUNRafi5YTSmX1Xp+i3UPEGu2QZNCzwcbBU6XgZ4onhPQ86PIcNkr4Ec9dweQCnGad4Z1sRP63pib+zMIh4Wk95XEE9VAUU5tuyrvlmXH4eq/BQLsZT3G/4UBSdUd9AENWwK34W9nasPjz1q9MSiR0NUxGFUCeAVMSHg197pBf+3GLAWB51dg15tMFl4w4k6R0xbhECrL6XxQQ8DdFmVE7fw6e7aypz0wxJNm4yrnexRnLDYnyVnODoNKvbiC2JVvWMFlilXQhjISgF4y52VL7qN5AYIBc8STsOg1Jh+0ip+jcagHyN0NzGcbwW7KaFBvTdpm2/5K9CUF3ldKnvJK9PfdqGtS/F2796+F58vN4mDjZqnV105AXmjqYL4/mSw387/hEsTIUMcJTZd6aHcr8kR5KBduXedd72ZnLjq9duMl4HREDPZfrbQ4Cme5Et6iunSy0A4Zg32H1Wn53K6HEPKG8rRcfdZytycKGwJRfsTTfajII/h3QBMQTgU0q+lFZTqKpBYsi3X1WDMu/tGUo1Kk51Jwg=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f0e9787-0503-43c0-8b3e-08d7e54a487f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 16:45:50.5662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IpMPEoB5qmbx4D+DN4q0zgwIbFiMxI8Au5ZxHJ0M7lEmQfIopSZAD5uZQtnu/QkLemXyHvv4JP/TXt9LPQ3rpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB3064
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 4/20/2020 10:58 AM, Pablo Neira Ayuso wrote:
> On Mon, Apr 20, 2020 at 10:46:54AM -0500, Bodong Wang wrote:
>> On 4/20/2020 10:33 AM, Pablo Neira Ayuso wrote:
>>> On Mon, Apr 20, 2020 at 10:28:00AM -0500, Bodong Wang wrote:
>>>> On 4/20/2020 10:15 AM, Pablo Neira Ayuso wrote:
>>>>> On Mon, Apr 20, 2020 at 09:58:10AM -0500, Bodong Wang wrote:
>>>>> [...]
>>>>>> @@ -796,6 +799,16 @@ static void flow_offload_work_stats(struct flow_offload_work *offload)
>>>>>>     				       FLOW_OFFLOAD_DIR_REPLY,
>>>>>>     				       stats[1].pkts, stats[1].bytes);
>>>>>>     	}
>>>>>> +
>>>>>> +	/* Clear HW_OFFLOAD immediately when lastused stopped updating, this can
>>>>>> +	 * happen in two scenarios:
>>>>>> +	 *
>>>>>> +	 * 1. TC rule on a higher level device (e.g. vxlan) was offloaded, but
>>>>>> +	 *    HW driver is unloaded.
>>>>>> +	 * 2. One of the shared block driver is unloaded.
>>>>>> +	 */
>>>>>> +	if (!lastused)
>>>>>> +		clear_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
>>>>>>     }
>>>>> Better inconditionally clear off the flag after the entry is removed
>>>>> from hardware instead of relying on the lastused field?
>>>> Functionality wise, it should work. Current way is more for containing the
>>>> set/clear in the same domain, and no need to ask each vendor to take care of
>>>> this bit.
>>> No need to ask each vendor, what I mean is to deal with this from
>>> flow_offload_work_del(), see attached patch.
>> Oh, I see. That is already covered in my patch as below. Howerver,
>> flow_offload_work_del will only be triggered after timeout expired(30sec).
>> User will see incorrect CT state within this 30 seconds timeframe, which the
>> clear_bit based on lastused can solve it.
> For TCP fin/rst the removal from hardware occurs once once the
> workqueue has a chance to run.
>
> For UDP, or in case the TCP connection stalls or no packets are seeing
> after 30 seconds, then the flow is removed from hardware after 30
> seconds.
>
> The IPS_HW_OFFLOAD_BIT flag should be cleaned up when the flow is
> effectively removed from hardware.
>
> Why do you want to clean it up earlier than that? With your approach,
> the flag is cleared but the flow is still in hardware?

In normally cases(no driver unload, etc), it is imdediately removed by 
flow_offload_work_del. Requests to remove the HW flow are from netfilter 
layer to driver via block_cb->cb. We're well covered in such cases.

The lastused is more for conner cases such as: iperf is still running, 
but driver is unloaded. In such case, driver removed all HW flows 
without notifying netfilter. Flow_offload_work_del will only be called 
once timeout expired, and the indication of HW_OFFLOAD is incorrect 
within the timeout period. Meanwhile, lastused stopped updating once 
driver unloading process destroied flow couters. So, relying on this 
field to clear the HW_OFFLOAD bit to cover such conner cases.

