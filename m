Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0435DC636D4
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Jan 2023 12:37:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbjAaMhi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 Jan 2023 07:37:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231890AbjAaMhf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Jan 2023 07:37:35 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2054.outbound.protection.outlook.com [40.107.92.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A35CF4DCD2
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Jan 2023 04:37:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V5QWLSueTki/YcHVUFcWhYSwUBcL7N/a4tqEk8BvdSd1wrkjZD/hK3lJRJFOmZuumc69KXXJp1WGqs+3nzHRxmsJXmwgAizkiS7wej9hmdo+xXZudWd80K5rKRuGejbLgG8RZ327kGe59BgALASjF37goFsNNLBG9RVj3B7rrvN0R2BDmMMiYmscqgW42ytrtQqNO8++ZIgCizdeaV30v7DwzI+9Lh6e1IGFWq9D4FYmENG5oA+sOn90OxN3LvMv7ld24kSHRXrWa9lw19dVX4ME1Z+zucCU6VneIOIZIE4VTReLRnIHWQoZPd0yMsWoiZp1LhuXuR80iblCx73AIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kZ/UHpDNHndTHaJ+jVolT4oIkBICX6ObR1vK3g9IILI=;
 b=UZZ4laiiY/YD06EfrMf9/5z/wreaNp4kakpdh139qtxwlzEdH9+owJHUKL1t4UMufZLPfRmT8ni7zEXCZpORO7TsZwGXZLaX9i6Bzd9yBRTAlOlLV7Z14kyibV5ZQR7QnPUVTjvkuHc6jn80z9Erq3XhtuKL8PTfOWKMdTyLb8lcPkbWPhTjWwIWmntN8jNPfcKu3DBNnBZ30XDLuWrYGV3Uy/A6AaeI8yfUd+tYp7DGC4z8M3IVu0uk9WEqqWdHZRnfiGoZIrQUv93KpLOKYqd8muDJGcVGne4LCzdOGfnV334HIulXkK6JSZ+PlHGQAmab1kIYH0QW7NBoln1tDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZ/UHpDNHndTHaJ+jVolT4oIkBICX6ObR1vK3g9IILI=;
 b=AnYg2LiQAqzvLsVVH9jOEN3DINkqmOSmNWOoLYd1ydOJBe9IfrioHetxeczlvl6jxN45SIISjyGS55KpN4S0bpAQsz8CfhP+NSiSywzwIraUYvHQYEdVl+zt6NBHqdrKQdNJHWFplALwwdRO7wjdlT3n2pZzd1L0wV0NzJpvZXdCDu9EK8z+D9nfRRjYwOAh/62vgx3X0jj+1fkDdzKB5k3uJcqfeG2A4ibHSTOog2Pj6lVWi+WhaBlbpJI+0a739B4VVEZ2yXjh1fBMbTAqn8qHv/sDxXnO7/AiQHDdrR9zpwCrUh2tP8NWlQxwkmsFCN3r/LN4Sfsja/cqHOqH6Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH0PR12MB5330.namprd12.prod.outlook.com (2603:10b6:610:d5::7)
 by SN7PR12MB7912.namprd12.prod.outlook.com (2603:10b6:806:341::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Tue, 31 Jan
 2023 12:37:27 +0000
Received: from CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::9ac7:2373:addf:14ec]) by CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::9ac7:2373:addf:14ec%8]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 12:37:27 +0000
Message-ID: <2a1a5bb8-a656-bce9-7a17-e7c949cab135@nvidia.com>
Date:   Tue, 31 Jan 2023 14:37:21 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:110.0) Gecko/20100101
 Thunderbird/110.0
Subject: Re: [PATCH nf-next] netfilter: conntrack: udp: fix seen-reply test
Content-Language: en-US
From:   Roi Dayan <roid@nvidia.com>
To:     Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
References: <20230123120433.98002-1-fw@strlen.de>
 <a6323260-da2e-1403-4764-423219b604a4@nvidia.com>
In-Reply-To: <a6323260-da2e-1403-4764-423219b604a4@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0543.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::15) To CH0PR12MB5330.namprd12.prod.outlook.com
 (2603:10b6:610:d5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR12MB5330:EE_|SN7PR12MB7912:EE_
X-MS-Office365-Filtering-Correlation-Id: c38b203f-a829-4e1f-88a7-08db0387e96a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N92KQBcl5d2dqY6XwamSxV0MwhBwDl+dl9676y94uRKrBM0PMTVxmSzHaCjY/IiDyfHX6MM8k0KAPHTHnTwzLqKz2N6QE/6jKwxIpk3YfonPo4kU1bKUss6mCC72rc7NPqfN9fnHI6S+lY3YZMWDyYXw2AClieAfEPjNVM03Eg7/iBI+csRmN7Bf34gtpxsNXmp0KKehvQFGKldTgGM0TrvqQ4jdV19/mrgTtXz4BCOdw7j2z8KHv2DmyTqolx0UvvYQ04cVZxNsgOZbeojOogPgdgna8SioQKPd/TjsFhozAdltKUb9B0jDIu5OHDya7s1LM9aZ1xnYYowXO0z6wNtUpOvCWx48d04dftWfEz2pJhVyRGKEe64fkEBp44LZOuRbx/AHCv/YyWkuuCmU3f1pVVR8RaRwBFx40Xy6rnSQ4tVe0WzgJG7eocbMoUmZaTlGuxHhdKBbv0AISACRmhUby/jTT+Wj8GWWr1fYPODdHCJVguuIUXKYnbz32xiKVKEEs2iVsLXkBys1h7oP5Mza63APtL4UABETIAvX6y/qVKkYsxsrr4TR1oc2ams2g0fCppSX/Xgvht95sFVcURhne8L2ZjqpIdGNz6wduuveifGuWouIPp3hs1dr7Ujlq+DuMz7vL5+neZK/er/uYbI6ujS4MaiLxQ4xaIznCHKkUW6zDW08ZzCbsRqZg8y5tiZmTlUiKEkUHqeSfK99FxNuB9Z4p4BMXj3oIEE5MFA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5330.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(396003)(39860400002)(376002)(136003)(451199018)(86362001)(31696002)(38100700002)(478600001)(110136005)(2906002)(41300700001)(6486002)(6666004)(26005)(8936002)(5660300002)(2616005)(66946007)(83380400001)(66556008)(66476007)(6512007)(53546011)(8676002)(6506007)(186003)(316002)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R0gvOGJBc0k3Q3RGVUZOTWdpUUhoWTV0OFA1cGJaenBydWhSZVpZMkNqK2U0?=
 =?utf-8?B?WWdmT3JmcmFBUkR5aDlwNkxXMlJUakNvRy91MHNuelBBMUNIMXNSQVlYc2Y4?=
 =?utf-8?B?cTVLa3hib2k1SzgyOW1PZFBzWTlGcGRWRnoyUklpdk9KS3BybmNoQVVUZzZZ?=
 =?utf-8?B?QjgvTENoQXpJM2x4a0tBcWVqWnkvektYTlZvY1FPZ3JHYjc1TDA2bFo4bmVK?=
 =?utf-8?B?SFFKTnJGa28xQW5xZUIxc3k1V2tBTDhKMUtxNVdCQkdMQWxrcXgzZ3JWZVJu?=
 =?utf-8?B?SmtTckxqckU1eHBVUzN0OE1TYklKZHB0WU1LSEV1Qzdpam0zL2JHVHhGdGMr?=
 =?utf-8?B?WEY0WXg1Q3diUWQ5S2EzTHNvWkxIeXBGcy83WVhnZjY0RGJhOFBtSS9UREVh?=
 =?utf-8?B?ZWJqam5JYlBOaW44OXB6ME9SbE42NGovcXJkUUdpalh4RkZncGE2MXZCUU41?=
 =?utf-8?B?bENqcGZ0TkF0UHpRdHBMaE1nL1hoL29NdHR4WHVqRDArOXlTMXpRTi9ZRDBO?=
 =?utf-8?B?NWNPdnplUkRHelhwb1ZrQmJVRG9XM1B3dEhvTUx4ZStidm14MnZqTGhEL3NQ?=
 =?utf-8?B?bWg4bGJRMXlKRVk3S1FVM21xeUJKUkkyOU9jRTJOOGVTZHBZTnVveWlGQ2hH?=
 =?utf-8?B?K0lXK1Z0NU9zK0xKeVBSRnpIYUdpSWExVWx3a0x5VmwxcHp6ZncvZTJYOStt?=
 =?utf-8?B?eTVrK25xVFMzYThFN0JDQ1lCV2xEdEdQTzRSaXMycGJraGxZZGE3RFFCbnVD?=
 =?utf-8?B?WjgxZjBrdlVOL3p6QmZSVmVLaTJ2RjM3T1RKRGwvQUViZDNUTDZxWXhvakxB?=
 =?utf-8?B?WmJ6TzhLYm9PamthazIwYnVqQWhNY0o1cytkTHVEZk9PdVpmN2UzRmd3aEJU?=
 =?utf-8?B?MWNWVlVVdVB2RWxwRXIxWUxwd0JQOXd3T1JiMmNRcWpjN3NiK1BUWG5ZMUFv?=
 =?utf-8?B?Ty9wMTU0dithOXYrd05DYnNGblFVQzZWaTBIMm5hcDFKSEM5dW9Ea0tDbGVU?=
 =?utf-8?B?SHlVYVJqZFhya2hiZDVzSXliYU5GQWJqQmlmK3dkdXlNRHdwNnlRM1hPTlFE?=
 =?utf-8?B?R2tJMWVkclA0dGd3aGtDajJ6bjdSMXNKOGlQODhmVnBCUzFSWDdKZHZkUFdw?=
 =?utf-8?B?d0t4UlVhMDRlb3REN0hMaVBuNkx4eURTSXgyenhZQ2dXdjJma3pZQTEwVmtP?=
 =?utf-8?B?ZlRmTSt5VUpudklzdXJpRkwrMWZsQmlMdTU1V1dGNkFna2lQRzA1VG1Fa1Fw?=
 =?utf-8?B?eXRvRXFoa3pjQlZEODhYN0d2c3JEbUNkWm1BNUhaZEhobUpSQXpLRy9Ca0J4?=
 =?utf-8?B?MGUzei9EYjZ6ODVHL1l6RzZtNFl0U0FGU01rNDd0NVhTczQ2anF0Mi92azlG?=
 =?utf-8?B?SEhPNzduaUNid29RT3ZJZTUxYkxTdHJTKytQa2lydGN5NFQ3U0d5TFBtVVMx?=
 =?utf-8?B?OTBoMmxSU1FQeFJNSG5FQjFQK08rempzdUtwYUxVM3pKNzJSbElFUi94WWky?=
 =?utf-8?B?d1MrZ3BlNVlCTzlNSXJNZ0d1VjgwbVFXdlpZMUkzcVF5WGV1VURKMzhSeVZQ?=
 =?utf-8?B?SGtxeDFCZkh2L0xjeVcwTVkzU09kUlRINU9CQUlOOUJDKzhGTWMzVkxWWFRv?=
 =?utf-8?B?WVhOb0VXWjJjU1JHbVQ0bkFLeGJWSzFuK2pnQWltVVl1L3RJdWFIR0RaOU1I?=
 =?utf-8?B?czNZeEpINHJGZjNhM2NibERSd1dJQjJ5Rjk5c1dGRmdCaTZrQUxlc3RYTTJV?=
 =?utf-8?B?bHpIMjExejdOTUtQejV0MzNmUTk2TW56UWJvM1JtSFdtOUdHd1NqdDhWeVBB?=
 =?utf-8?B?OHEyTUtMQjAzUkFIWVN2ZGNoMEw3Y0c4MENwWGxVNmxHVVU4M2xMeVcrWTcr?=
 =?utf-8?B?YzBuYjcyQXVXWVplYkxCc1R0NFRmM1FwMklPSmtFU0lPNkYxSG9WMUNHMVpZ?=
 =?utf-8?B?TW1DZ2pRUHVzdHJpQzVHd0Rib1ZCR0ZFaUM4Z2gxZ1I4ampVQTZoNXpDWFZ5?=
 =?utf-8?B?cmpQMEJIM0xmTXFWUkdsa2FCdWpQQ3FXY0NlUWEvbUJpK3VOQlo2RldWNjAx?=
 =?utf-8?B?L0czTVA2OFFRWHRHQXFXdmFxMGhxZVBYS1FvOEFqRU9NYkE4NmVOYzBWNmUr?=
 =?utf-8?Q?/Gv03fR/D/L1vXqtYuNatVgni?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c38b203f-a829-4e1f-88a7-08db0387e96a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5330.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 12:37:27.6941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ae/hNeBtLNHodSYxBKRMSKmor0jtoR/e3o1sjisSPfhiXJe06xxntCebnMOuY5Jk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7912
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 23/01/2023 18:16, Roi Dayan wrote:
> 
> 
> On 23/01/2023 14:04, Florian Westphal wrote:
>> IPS_SEEN_REPLY_BIT is only useful for test_bit() api.
>>
>> Fixes: 4883ec512c17 ("netfilter: conntrack: avoid reload of ct->status")
>> Reported-by: Roi Dayan <roid@nvidia.com>
>> Signed-off-by: Florian Westphal <fw@strlen.de>
>> ---
>>  net/netfilter/nf_conntrack_proto_udp.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
>> index 6b9206635b24..0030fbe8885c 100644
>> --- a/net/netfilter/nf_conntrack_proto_udp.c
>> +++ b/net/netfilter/nf_conntrack_proto_udp.c
>> @@ -104,7 +104,7 @@ int nf_conntrack_udp_packet(struct nf_conn *ct,
>>  	/* If we've seen traffic both ways, this is some kind of UDP
>>  	 * stream. Set Assured.
>>  	 */
>> -	if (status & IPS_SEEN_REPLY_BIT) {
>> +	if (status & IPS_SEEN_REPLY) {
>>  		unsigned long extra = timeouts[UDP_CT_UNREPLIED];
>>  		bool stream = false;
>>  
> 
> Reviewed-by: Roi Dayan <roid@nvidia.com>
> 
> thanks

hi, just pinging. when is this fix going to be merged?
thanks
