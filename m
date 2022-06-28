Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CD07CCA479
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jun 2022 15:35:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347879AbiF1Pe6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Jun 2022 11:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347946AbiF1Peu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Jun 2022 11:34:50 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2063.outbound.protection.outlook.com [40.107.92.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1B22DA95
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jun 2022 08:34:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LYQq1g2rdpxwKHGsuOgfomq+lLdHfGd6R8gSiNsvAeBMNAYZPG0CCIqFKFYQ7UP7cCHv/n/V7BDZ4HpxoeHWAOjQ/n9WbLLhv84aQ3uf5viuwI3C7g047+D1IkTb7JSS2VduFHZBat/mH9RTT/U+nakdfnnG3j4yetEfipDkkpzPZIeOsaouesGG7AQog5vYUVg8rLFW79IPpeKptUK0ZKw0reoZMlBj2WoRdl0wRIjmh1eOxrqStm+/h0EnhOBUuSlmv2QzIhlgSqp0Vl1jXAcr4wcXHexZlhDdcSE/WtaQlQkMBDupz3wTEZvYx10Vj2U4va/L2t5Whm3cDk+d2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ve6QWgDpnTgIxBWz9StQdcQ9HjnI/RoLT5Qj716nDLE=;
 b=QNxf1pCccbotCMgKwOSnwRpI4NuW7CPqOD0GjyyuOJXytlwIIn6i4z57rPnf6dUgS9GG1IBZMrSl/0ZU6OXDUU66wZsdClz83E3qu14fhmDcHg2SYWNdrdOgJcip/zABx6wOu/f7E6K0AwEOQYk4+jlS/SyJnzuGcsHj/S0aySaLmAegXjo9Qb97czfDmYmfnOBehPDZRFE16hzQWvCIYMZ0XE/QO4jXpmmQKOvPfXUTx0thN5CSque76YvCdwrlY49LN0xTd5PbE/UupFKPoCw8SixAOLFDB7UNmWSSSPnGOx+IyP7aElUXXrbkETMLjgNo/wwkbOZz7LpRqTb69w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ve6QWgDpnTgIxBWz9StQdcQ9HjnI/RoLT5Qj716nDLE=;
 b=Ai9CIguUO/jB6RR4eo/fPojsPvORA6qDf9/pi/S6wJSDQoRPWUTAWK8qxqX7YlAYq4i2QvT7vMht0Id3XpQm5a7THpKWO6eQN3cPZKWk5YEp7jmG/KjXHnOI75fz0qPpUEVDXAobfAa33oCqS9Fg5T5+VJF8UwL2IhwHpgL9IesoHlkVUJXLFsIdFeZPHHEaivzzkBaa0E3xtx4JnB0wUYJSqnzB14AoaZNpbr/IZr3zItPJVJP3EVMKgM31Egn3b5XAoUDsRoH4CHXk8IoTHvuPUYShS4CZkEBXdrCQptCDxW/KXh6bFIhzUZzX+SAwSK54LAKHmaoY3TieS/2DBQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 SA0PR12MB4351.namprd12.prod.outlook.com (2603:10b6:806:71::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5373.15; Tue, 28 Jun 2022 15:34:32 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::1075:9d96:7eaa:3f9f]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::1075:9d96:7eaa:3f9f%4]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 15:34:32 +0000
Message-ID: <3f2dc8de-b7bc-f289-07fa-8a92d8618331@nvidia.com>
Date:   Tue, 28 Jun 2022 18:34:26 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH nf-next] flow_table: do not try to add already offloaded
 entries
Content-Language: en-US
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Paul Blakey <paulb@nvidia.com>
References: <95c2aa63adea29e6008ee45af17d199492f4d14b.1656340577.git.marcelo.leitner@gmail.com>
 <c5039f5a-5295-a457-65c5-d7016d6a5034@nvidia.com>
 <YrnjpSUKZdKT1NZO@t14s.localdomain>
 <d6b97751-019b-7b81-f4e9-076aaedbbc91@nvidia.com>
 <YrsdTrDaQh+JjSpn@t14s.localdomain>
From:   Oz Shlomo <ozsh@nvidia.com>
In-Reply-To: <YrsdTrDaQh+JjSpn@t14s.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP123CA0018.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:d2::30) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23abe379-3c16-4925-34a3-08da591bb252
X-MS-TrafficTypeDiagnostic: SA0PR12MB4351:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t7vGsYD4RZLnef+/CAKA2StzvGJA+pWz1TEV3molF6FHAI3gRRDf5F5uzFEwuntxlHBm/ksX94K97RbygE4IjFd52uVma+2+nr87M9ssXF6PZWL4nmLBI6yGCBnDAJisQtdZEApMGEA4Y6NAkyXW/Kz1He536mAhLxI7tsgdR13xIyvWWCTSzWXyV2d+eLhnp57yIdcHIpIPX+nIBwvDCv6rKvV4hP8Zi2I65DFrqgr2VqCt7CPIuOXhySApOvDHB4u57g1/K3ZJC5rA/DwlBuJkyEVgtTYcZLMyio2o8d2f8fbu9SezG/Dw5iGWWPrTK79sjmJSMOCP4y+KfBK2AwVyzyZirDCVPHNSiv1hQ6Z3pg+n+pkGc8jbAVcubCkG0wTQgYEPSrkFejK3jEu+7dCMBAJkRQRmTTApnI0IXt3b8QEdJDyJLFdmXVVbfD2lKAuLdfGPA5P5pWJVAMKuvDgieMBpt4C3RaMNH+OBK8LSbNQRvm4DgVTL5S5jjyvxmqJj1caMv/vkTFag21sTN6UlbvcfKaR4nvKJP60icXabSBdonRPtSzmmGWjiybRZ9RQpQCAmYJXSMLVt0rVUlP8x3wzBachaVJ5oR14yCx94uhWoJv8FH9l3sDqvgMUlWOozRaaVg6NcIbt39GueCduDXORHGEc3lRGwsfbyFbF7IN7iodVBLGUiI4C3uIVisThzqO5paF5PlE24VBgqUxkS0ZRvWrk+IPc3TckBdM50WCNSO8O36FHGbbsWMgsiD2imTHGCWpOihTfB29TDCx2BguLzoRBVnyc7oartmZgA1CMANBhSTNmC7OZzqaXlMq8BZ327MH1uIasy6ec1mg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(136003)(366004)(39860400002)(376002)(31686004)(41300700001)(86362001)(8936002)(6486002)(6916009)(6666004)(53546011)(107886003)(478600001)(31696002)(6512007)(186003)(26005)(54906003)(5660300002)(6506007)(4326008)(2616005)(66946007)(66556008)(38100700002)(36756003)(83380400001)(66476007)(316002)(8676002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eHdkN0RSd3NNWWRWMmtqR1FJaVdUWWl3b2oveEtCT3hPbDBhMnJuNXAybjFY?=
 =?utf-8?B?aFRRMFdXVG9IWlBnZUhPOWV3amdRTzhJd0xJcHhWWGxlN0VBdDVDUU9jRVJ3?=
 =?utf-8?B?c1lYMWRqaUlnRjFrL1hyaU80eGpZYkRScnFIQjZseDBnM0dOdWkrNzhWVTNu?=
 =?utf-8?B?L2xzMjVUZUNLZzRaemZaY09INFA4c1F5OXFnRk5BWEllUGtTZ3JrY2NSaUpu?=
 =?utf-8?B?ODVmTENQSERJOU5RcmZBL01hdFp3UDVIY0ZDNzdQSjYyREI0WXltd3lWMENp?=
 =?utf-8?B?U0R2aE9iVkxwQXYwRnQ0a3ZIRE1ER0dyaE5QaGpHQy9rUG9WNXMvZ29lRGd4?=
 =?utf-8?B?RHdkSWdmanVzbStIbVNjbmdXK3ZrbzI3a2sxMDB1eG5xbFdMTkNxaERVclV5?=
 =?utf-8?B?K0IrelhXUGE5Q29USDAwK1pGdjArWTc4dENaMnVMUnJIaVNIbGI3MjR1SlNh?=
 =?utf-8?B?REwvTUprdTBRNVBQQXRuejlUZjBLazJVSGRrSUlWYXFIcEFVZkpNbnV3Y29T?=
 =?utf-8?B?UGVxbUVuV3J3QnpLKzA5emlmNi9Fdm9aYlRFY0xSYjVyR1FrRCsyNmlXOE41?=
 =?utf-8?B?Tzl2d1d3dDd5aEpIVE9KSEsxbEFjaHoyb1lTVVVUMFM0dnNZNkdDVlgrL25G?=
 =?utf-8?B?dDZzTmFyQjVOZGpvUnVOMHNXQjQzWjg0eHJwdjBOL2dGc09JUlZqcXNNbnhu?=
 =?utf-8?B?VUhTTzhIbHhKMmw5SmVUWDRQM3hPeURBUHhTeEtVdUJ2SXVtbU83eFArbi93?=
 =?utf-8?B?ajlFY2xaZkQ2UUkwSVp5RXFhaE9ZLzJwTHZJWjZwSU1qTzhiZkk1cVJ6WjVk?=
 =?utf-8?B?ZXczWUQrTC9wbzJ3Y1VrcGh2d0NzbUhpR3hSSzB0Z3g5cUFTS05hZk9aeUdI?=
 =?utf-8?B?U2Z4dHJYNi9Mc0wwbDREb2gvYXdDcXNTZkcwUFA5UytCd2prcFlBb2xINjRF?=
 =?utf-8?B?ODdha2R6RnBxZWE5b1hFZHdZVmg5RWVDMitUN1lyaTJ3QmR5eEI3Q3ZVR0hp?=
 =?utf-8?B?eFozU1hnUCtTMW56L0p6NXVDK2c0T1RvaWtsdkE3b01LNkYzOEVNeGdvRjlJ?=
 =?utf-8?B?c3lYeFAxcWRFOG5aclhJcGpPWUxobTdpbUFhanQ3TEJxTG1FVmU2U1ZqYXUx?=
 =?utf-8?B?eHVXUkhlTXk0Vjh5OVB1NHU4NnU0OEtQVGlsdytra01rU1I2MUFReFRrR1U0?=
 =?utf-8?B?SFdpZG5YaTNJdUJsZ3NrQnIyK2s5M3BUblBZTUYrWHA2eXdVWm80aHF4WGNO?=
 =?utf-8?B?NmUxV1JOUGJKWmphQ1hLdUhYMkQzNk43OURib1llMmtlUTYwZ1MvSjJ4MFhW?=
 =?utf-8?B?Ym93b21vL0dvbGphVk81SnR2R0tPckt4TVNHWE9IMkVGdkZ4b2xyVkxDazBD?=
 =?utf-8?B?a3R6QWRLSCt3UG5YSHVWOTVPYXNVbVB1RGNDM0RvSytxUWdra2JEYWU2S0t3?=
 =?utf-8?B?MHZ2SGhZWmFONUROeStPTURFWnFMNEphOWk4NUdOZTBIcmFET1JFWWVZRVVO?=
 =?utf-8?B?aEZtYWlWT21zNXRReTJUbTBNSVluK0pDb0Zrc211SndrcmdUdVhWT3U0dG9u?=
 =?utf-8?B?Yk02cUY0ZHdkYU4wdy9wVFMvSlFZVEpEZGlXOVRUOXFZcmFsWW5LZkk2bWJa?=
 =?utf-8?B?RVgvZFBKc3RwM2o1Wk9PYXZBTUR0VjQ2Y2Z1SWIzcjZBWUlKME81Tnd2OXR3?=
 =?utf-8?B?ZkVYbnUxUGl1R2NGYjQwM3M5VXpKUXhFRzRzZ2NPOTV3QXpqQjNGOE4xSHZT?=
 =?utf-8?B?UWxsN1pXOFNsNmswMUpxL2hDQStEQ1phUEFGMTFySGlVMmRIWWNXeXJqVk00?=
 =?utf-8?B?bStiOEhvckYyMkVuZEM3a1RNaDBpVmpIZzNrbDZCZFR0Y05qcDl3Rktld3Rw?=
 =?utf-8?B?RXRvSDQ1aEtLVS9pT0R5N3BrbGR3MXlVNGRXNjdFaEZ5U0RnMUgvY0FPWGp0?=
 =?utf-8?B?TnJFdS90RFNDeEFNY1U5b21vUFpYcy9EcDIzK2FaWEpQbWtYMU00UHJrREZB?=
 =?utf-8?B?cE5CQlJyYWoxdkpqNWx1U21XS2xYVE9qNHVXOVoxcjZrVTg3ZkRyOVVWUXJV?=
 =?utf-8?B?SFJwcmhRRGlBd0hraVlCcEVQTmg4MDNndjNPbm9xSjdQaVM0MGx6MHdZZjI3?=
 =?utf-8?Q?1fzGqVXRCFsvklr6Po/zaR97p?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23abe379-3c16-4925-34a3-08da591bb252
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 15:34:31.9254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p/a4b5qkDZqpUajoFcPZVKeSZKpkzlWF3c0/LmtwZXmcaTVR2Yd8q4hbgpt0LYxi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4351
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 6/28/2022 6:25 PM, Marcelo Ricardo Leitner wrote:
> On Tue, Jun 28, 2022 at 04:13:05PM +0300, Oz Shlomo wrote:
>> Hi Marcelo,
>>
>>
>> On 6/27/2022 8:06 PM, Marcelo Ricardo Leitner wrote:
>>> Hi Oz,
>>>
>>> On Mon, Jun 27, 2022 at 06:19:54PM +0300, Oz Shlomo wrote:
>>>> Hi Marcelo,
>>>>
>>>> On 6/27/2022 5:38 PM, Marcelo Ricardo Leitner wrote:
>>>>> Currently, whenever act_ct tries to match a packet against the flow
>>>>> table, it will also try to refresh the offload. That is, at the end
>>>>> of tcf_ct_flow_table_lookup() it will call flow_offload_refresh().
>>>>>
>>>>> The problem is that flow_offload_refresh() will try to offload entries
>>>>> that are actually already offloaded, leading to expensive and useless
>>>>> work. Before this patch, with a simple iperf3 test on OVS + TC
>>>>
>>>> Packets of offloaded connections are expected to process in hardware.
>>>> As such, it is not expected to receive packets in software from offloaded
>>>> connections.
>>>>
>>>> However, hardware offload may fail due to various reasons (e.g. size limits,
>>>> insertion rate throttling etc.).
>>>> The "refresh" mechanism is the enabler for offload retries.
>>>
>>> Thanks for the quick review.
>>>
>>> Right. I don't mean to break this mechanism. Act_ct can also be used
>>> in semi/pure sw datapath, and then the premise of packets being
>>> expected to be handled in hw is not valid anymore. I can provide a
>>> more detailed use case if you need.
>>
>> It is clear that the refresh design introduces some overhead when act_ct is
>> used in a pure sw datapath.
> 
> Cool.
> 
>>
>>>
>>>>
>>>>
>>>>> (hw_offload=true) + CT test entirely in sw, it looks like:
>>>>>
>>>>> - 39,81% tcf_classify
>>>>>       - fl_classify
>>>>>          - 37,09% tcf_action_exec
>>>>>             + 33,18% tcf_mirred_act
>>>>>             - 2,69% tcf_ct_act
>>>>>                - 2,39% tcf_ct_flow_table_lookup
>>>>>                   - 1,67% queue_work_on
>>>>>                      - 1,52% __queue_work
>>>>>                           1,20% try_to_wake_up
>>>>>             + 0,80% tcf_pedit_act
>>>>>          + 2,28% fl_mask_lookup
>>>>>
>>>>> The patch here aborts the add operation if the entry is already present
>>>>> in hw. With this patch, then:
>>>>>
>>>>> - 43,94% tcf_classify
>>>>>       - fl_classify
>>>>>          - 39,64% tcf_action_exec
>>>>>             + 38,00% tcf_mirred_act
>>>>>             - 1,04% tcf_ct_act
>>>>>                  0,63% tcf_ct_flow_table_lookup
>>>>>          + 3,19% fl_mask_lookup
>>>>>
>>>>> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
>>>>> ---
>>>>>     net/netfilter/nf_flow_table_offload.c | 3 +++
>>>>>     1 file changed, 3 insertions(+)
>>>>>
>>>>> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
>>>>> index 11b6e19420920bc8efda9877af0dab5311c8a096..9a8fc61581400b4e13aa356972d366892bb71b9b 100644
>>>>> --- a/net/netfilter/nf_flow_table_offload.c
>>>>> +++ b/net/netfilter/nf_flow_table_offload.c
>>>>> @@ -1026,6 +1026,9 @@ void nf_flow_offload_add(struct nf_flowtable *flowtable,
>>>>>     {
>>>>>     	struct flow_offload_work *offload;
>>>>> +	if (test_bit(NF_FLOW_HW, &flow->flags))
>>>>> +		return;
>>>>> +
>>>>
>>>> This change will make the refresh call obsolete as the NF_FLOW_HW bit is set
>>>> on the first flow offload attempt.
>>>
>>> Oh oh.. I was quite sure it was getting cleared when the entry was
>>> removed from HW, but not.
>>>
>>> So instead of the if() above, what about:
>>> +       if (test_and_set_bit(IPS_HW_OFFLOAD_BIT, &flow->ct->status))
>>
>> I think this will set the IPS_HW_OFFLOAD_BIT prematurely.
>> Currently this bit is set only when the the flow has been successfully
>> offloaded.
> 
> Indeed. It was my cat that typed _and_set in there. ;-] (joking) sorry.
> 
>>
>>>
>>> AFAICT it will keep trying while the entry is not present in the flow
>>> table, and stop while it is there. Once the entry is aged from HW, it
>>> is also removed from the flow table, so this part should be okay.
>>> But if the offload failed for some reason like you said above, and the
>>> entry is left on the flow table, it won't retry until it ages out from
>>> the flow table.
>>
>> But then we will never have the chance to re-install it in hardware while
>> the connection is still active.
> 
> Unless it goes idle, yes.
> 
>>
>>>
>>> If you expect that this situation can be easily triggered, we may need
>>> to add a rate limit instead then. Even for these connections that
>>> failed to offload, this "busy retrying" is expensive and may backfire
>>> in such situation.
>>
>> Perhaps we can refresh only if the flow_block callbacks list is not empty.
> 
> It may not be empty even for sw datapath. If you have packets coming
> from the wire towards a veth/virtio, for example. It will likely
> having a matching act_ct with the same zone number on both directions.
> And/or if a zone is shared, as the the flow table then is also shared.

Hmm, I was thinking that you are targeting the use case of deployments 
with no ct offload supporting hardware.

CT action is usually proceeded by a goto action. So, a filter with ct 
and goto action list will offload even if the last chain forwards to a 
veth/virtio device.

> 
>>
>>
>>>
>>>>
>>>>>     	offload = nf_flow_offload_work_alloc(flowtable, flow, FLOW_CLS_REPLACE);
>>>>>     	if (!offload)
>>>>>     		return;
