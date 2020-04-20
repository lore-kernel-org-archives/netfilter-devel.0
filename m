Return-Path: <SRS0=IOUL=6E=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F52DC3815B
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Apr 2020 15:47:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F753206DD
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Apr 2020 15:47:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=Mellanox.com header.i=@Mellanox.com header.b="DR8SoQ1W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgDTPrG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Apr 2020 11:47:06 -0400
Received: from mail-eopbgr50061.outbound.protection.outlook.com ([40.107.5.61]:64162
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726136AbgDTPrF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Apr 2020 11:47:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e1iUyzn0AcKGHzjSaPElF8gG7fOuQqqN8/Ei5/D3JYkGKd2/WkkZqA2q4AXAvkmlozzUIh/OeD2FruGqHvgDrnMLW8cTKk/AOcGfGMc64Za8Ao9bxh9FttgktSw5EEImViLJ54QzhtoJNhSSBydlm/gB/DmpZ7s/tLzxFEjboLTThujCm9oQrSmnPXEKmtanN6R4cu4jrya6bKP40YerQI19d7D16HsNvdJBIjTiM4gXUsC9XzHBUvYuryBqNInXTkUZIw55iscwxYW7syKNxzIORJQ7LLpdFgaMRPPcy1hqF7djV/VVJrtj7mVA+MQAFvknGZNYmS4iREDybl3+DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zc/y0xzaGHCIdQrSLGIVcRqO1UIM3ryAY6kaHGYPt+0=;
 b=fkKHhWIldnrBkkIdplYzhBY6UwePA+/5IkNQbJNXzK9z/1UO8lN/gaUuTEzCC9KFE9Vz+ciZxQIPYMz7580Yywds0iIBIUtcprazIqjvLQ1J/ieqnIR1IchyIzmQA7b8pRTnORjWOYXrBWujr/SkfdlaaS6G15F5kxtUUX1C1Xtiaz4xeO20VDUYnLzoosyRW2Hq7JWERyb+JdaEhjf8ud0VXJAiksKDVIePKZEp4K9Tmbz9ukX/wsG+P5l+wa1oWP/PcQRvHlvW3XoldSbDEeKzlcAa8/vRIaiCEDIn41MP39PMRtGtep05IplWAndUpaHJd494Cp+b0C2NnQ5O+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zc/y0xzaGHCIdQrSLGIVcRqO1UIM3ryAY6kaHGYPt+0=;
 b=DR8SoQ1W4cU6K3CUGc8wGRBXOcqiI6TZRlqiMzBgyo9X1uYZ0GkcuAgLu4SOutZHkjETDMXmPxKGHNtTj5ZUiX+SY4xkIOzfCs/BmWpFhdi3qSz/xGDBK6bPArZes4YD61PDf3gs4lwkV/6m7n3THQeL3/QYHZw/ZqytXC6nWRQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=bodong@mellanox.com; 
Received: from DB6PR0502MB3013.eurprd05.prod.outlook.com (2603:10a6:4:98::19)
 by DB6PR0502MB2999.eurprd05.prod.outlook.com (2603:10a6:4:97::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25; Mon, 20 Apr
 2020 15:47:00 +0000
Received: from DB6PR0502MB3013.eurprd05.prod.outlook.com
 ([fe80::a155:fd1a:b743:9ac0]) by DB6PR0502MB3013.eurprd05.prod.outlook.com
 ([fe80::a155:fd1a:b743:9ac0%10]) with mapi id 15.20.2921.027; Mon, 20 Apr
 2020 15:47:00 +0000
Subject: Re: [nf-next] netfilter: nf_conntrack, add IPS_HW_OFFLOAD status bit
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, ozsh@mellanox.com,
        paulb@mellanox.com
References: <20200420145810.11035-1-bodong@mellanox.com>
 <20200420151525.qk764gfgydbip6u2@salvia>
 <b5f1eaca-a2c7-01f8-2d20-89762f435eaa@mellanox.com>
 <20200420153344.c2tjwmohirlnd4cj@salvia>
From:   Bodong Wang <bodong@mellanox.com>
Message-ID: <1ea59d48-c0d0-34fc-f443-eecb2ec3660e@mellanox.com>
Date:   Mon, 20 Apr 2020 10:46:54 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <20200420153344.c2tjwmohirlnd4cj@salvia>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-ClientProxiedBy: SN6PR04CA0103.namprd04.prod.outlook.com
 (2603:10b6:805:f2::44) To DB6PR0502MB3013.eurprd05.prod.outlook.com
 (2603:10a6:4:98::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.120] (70.113.14.169) by SN6PR04CA0103.namprd04.prod.outlook.com (2603:10b6:805:f2::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27 via Frontend Transport; Mon, 20 Apr 2020 15:46:58 +0000
X-Originating-IP: [70.113.14.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fa5eb91c-f010-47ca-2aa4-08d7e5421001
X-MS-TrafficTypeDiagnostic: DB6PR0502MB2999:|DB6PR0502MB2999:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0502MB29995F17A961BD1ED74D0339AAD40@DB6PR0502MB2999.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR0502MB3013.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(136003)(396003)(366004)(39860400002)(376002)(4326008)(52116002)(66946007)(66476007)(66556008)(478600001)(6916009)(6486002)(31696002)(5660300002)(53546011)(2906002)(316002)(2616005)(16576012)(86362001)(16526019)(186003)(31686004)(81156014)(36756003)(26005)(8676002)(8936002)(6666004)(107886003)(956004);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QJ7ggSWF+aEkOB4W3ILClMV02jEMUyGQFJY/9NfwgxEQ12x9BC/PwJDR9zsOoKyQUpKWH3LK7IBM5h3ml1tzQ4G5lRF0dWvxORmcRPv2dukZ+Xylwi+PGMWDfZy9LUzFTeV2yQ01MtU+bTgeG0Hi9k69qbvp91k4t2HIcn/41fBiDU8lzCm+BRQDaa6oKo0qPfa3Cbo7VKaGBkSAjmc6BClLZCASGXOhtXXicP/PEr3cVwTg1yifyuJ7hWsIy1+lE5DQq0n7ldlNWHRlGpXg2bmW1xmjHGBpwcn81lLII17/R6Jg843qXy9ps0o/+NAiLXwdIET12VSnKWn+RlON/a8QrsdLC5zMpnsLsxSlY0bMOQnE5YxtexyiP+V/PV5QJ8ccXLQ7yM7jt9O63pzBA441NPOGrzntIBl94nSrr2u6eTUs8Yg6rAd0FtpUNfS1
X-MS-Exchange-AntiSpam-MessageData: Iakxyl98NZb1DtUT5L61D/ODuaZzO9+Cza+cKxqORE/xumgquE9S8eHrnCve1rtQAmME+Fpelpyd6r1CnZUiWhm5ALzwwg0g2T5iq7R/WAZTXp2tDSmpoZ3MI/MyvO+fVH9/wrYJm2rDFQaZPPSMNg1DXczZwYK/Z4uWisZtc9ZZxuWLFnymIBFkuzoEipDOIYUcDVt6/olysQBSDYYdhPwRAR7l+GdigvPO1klWo5H1bD9mIDx//XmiVDdladmljgURPqpPI0iNSD/bTSZBDDFRYWWFs/Kkm3aiRLkaE34i/FFYzqnaseczNE/jP5GLWa3uDJgFHPsiUaC8N4TnQJt0mGpR1Kya/KpTduAYQF8cxfHKD7xnBnWQSZj5Zi0dt/TdDkyYlNEYWJaE0xlt+wnCTatxujPK3peVf3FezSXVKGPqYXOdvuPV/M/EAKf5YoZTMcRiddQHvInM1WeauGh/YtIpTtMI0bqQuX0TC/1gLrRTTh9iJc6iteX+H5SY/7ovYS6E2CZEQXMjHbt1kamdoUdqGSo0gAuda0u4UbmWKlU/c+ZHVxiwaVqDSngsyKM+S3K6vdWwMZ5tML/Ou5k2MjahkJ+fNEI42PcBl+w6IQvelCs3OvDzLRkAX3z/M2mUALPwooChInpnqAnxShZZ/fEzRvnzbYhHfIAUfdXWVpDkmvhjSOlmOuvORr6HU05Y5FNBp/4VMGxXkgTpiCUVONrF96z8iWtkaibtLuUCaXc2Lw8Ir6bv3Ki7ADt0kS8g/PgJmLzDDR8pjrBkVtVxFmk3SE6Lp/xOM8GEUA4=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa5eb91c-f010-47ca-2aa4-08d7e5421001
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 15:46:59.8797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uy4Rt6mv5f4ibqM9n0Vy20v/hKiXqnSLH0cb4mcRSEhgRiTmIQ+vCsrycMm7DuMd5ZpBCYkOZNzsxvwYFzZ75A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB2999
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 4/20/2020 10:33 AM, Pablo Neira Ayuso wrote:
> On Mon, Apr 20, 2020 at 10:28:00AM -0500, Bodong Wang wrote:
>> On 4/20/2020 10:15 AM, Pablo Neira Ayuso wrote:
>>> On Mon, Apr 20, 2020 at 09:58:10AM -0500, Bodong Wang wrote:
>>> [...]
>>>> @@ -796,6 +799,16 @@ static void flow_offload_work_stats(struct flow_offload_work *offload)
>>>>    				       FLOW_OFFLOAD_DIR_REPLY,
>>>>    				       stats[1].pkts, stats[1].bytes);
>>>>    	}
>>>> +
>>>> +	/* Clear HW_OFFLOAD immediately when lastused stopped updating, this can
>>>> +	 * happen in two scenarios:
>>>> +	 *
>>>> +	 * 1. TC rule on a higher level device (e.g. vxlan) was offloaded, but
>>>> +	 *    HW driver is unloaded.
>>>> +	 * 2. One of the shared block driver is unloaded.
>>>> +	 */
>>>> +	if (!lastused)
>>>> +		clear_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
>>>>    }
>>> Better inconditionally clear off the flag after the entry is removed
>>> from hardware instead of relying on the lastused field?
>> Functionality wise, it should work. Current way is more for containing the
>> set/clear in the same domain, and no need to ask each vendor to take care of
>> this bit.
> No need to ask each vendor, what I mean is to deal with this from
> flow_offload_work_del(), see attached patch.

Oh, I see. That is already covered in my patch as below. Howerver, 
flow_offload_work_del will only be triggered after timeout 
expired(30sec). User will see incorrect CT state within this 30 seconds 
timeframe, which the clear_bit based on lastused can solve it.

  static void flow_offload_work_del(struct flow_offload_work *offload)
  {
+	clear_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
  	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
  	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
  	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);

