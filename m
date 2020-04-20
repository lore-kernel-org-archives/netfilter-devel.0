Return-Path: <SRS0=IOUL=6E=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30F39C54FCB
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Apr 2020 15:28:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0496C2074F
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Apr 2020 15:28:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=Mellanox.com header.i=@Mellanox.com header.b="S9GFnYkW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbgDTP2K (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Apr 2020 11:28:10 -0400
Received: from mail-db8eur05on2056.outbound.protection.outlook.com ([40.107.20.56]:16032
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725988AbgDTP2K (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Apr 2020 11:28:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N5jcgv3/S0lba9CI66GRjqne/+afCXFYgNv9aUBIYtAA/gIQMwwZa/IdmjcJKO4qpL1n4HGPO1r+d5gomdK7H14/Qu0ro8WFgwQlGYuAGThpz0aqA8lWhkXNrRUygRWyMdI0XQwWzmUx+8vdI1Z/F5AycOF7xsrkCaC7JTErtErw67rU5kDTkY4yGVUOrXv5hKPtjjUm20A9A68+cYC6uG/nWEw/ioP1PYFuVKfeSSd+6xAj6BF0/KPwlWkJ4SlSlraa4rLoIg9BD4jOchbhVjvLsRpIhwbtra8V+KrXek7wK2PBZANUHcNUwWe08SUFhLmoYNo+8YVrrWyb6Wif4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X84d5BrHytZ3j3eYAGJrYY0ccBqKO+kC/F/jHdQKfGw=;
 b=bhkSzCtzVQ0NyiSwZPFALRkpFhCNhqpIpk2WWGSl0JVh1V6JpiFRIY6nqAsOlHcP+h8mrsTxqUEbZHVv3O9rsU5WcqJrHCYp6XZlE+YFlijNeXNJoctb+qMEFqJAq53aunDTHyhQg/seogvpSGF2AK6LJSFJ++EyaE8rBkIlkRWshME5kngYWkoy0PPC71n+KK9r1tCqwk6eC/VthPjbkccsEAek1jgmdP6qSAVK0+cpVekB8cs2ApuA8ckGP7m4qECwDTt5bG3mBj4yIFrBl96SbYqM2zRYZrfMg8xXyF9KyWwUDakv7W62Vu+3pLpvHRWThpqXuQihPiz6Be7eMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X84d5BrHytZ3j3eYAGJrYY0ccBqKO+kC/F/jHdQKfGw=;
 b=S9GFnYkW6MVzsQREzHOiNts4fQTSxp25owuOvUtEYICSgpM+TU0hbYkGlY0SyWIUKBbN/AORABJOFXcV5FF6FxtqFV3ZA8YjlCIcCuFFoW+Wg6TZa7S7Lf9HX1GiFhVTbvPR0YIQrO7Q4HZt3MB0lBrv/iyZtYYyCZItDrxbfSw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=bodong@mellanox.com; 
Received: from DB6PR0502MB3013.eurprd05.prod.outlook.com (2603:10a6:4:98::19)
 by DB6PR0502MB2904.eurprd05.prod.outlook.com (2603:10a6:4:9f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27; Mon, 20 Apr
 2020 15:28:06 +0000
Received: from DB6PR0502MB3013.eurprd05.prod.outlook.com
 ([fe80::a155:fd1a:b743:9ac0]) by DB6PR0502MB3013.eurprd05.prod.outlook.com
 ([fe80::a155:fd1a:b743:9ac0%10]) with mapi id 15.20.2921.027; Mon, 20 Apr
 2020 15:28:06 +0000
Subject: Re: [nf-next] netfilter: nf_conntrack, add IPS_HW_OFFLOAD status bit
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, ozsh@mellanox.com,
        paulb@mellanox.com
References: <20200420145810.11035-1-bodong@mellanox.com>
 <20200420151525.qk764gfgydbip6u2@salvia>
From:   Bodong Wang <bodong@mellanox.com>
Message-ID: <b5f1eaca-a2c7-01f8-2d20-89762f435eaa@mellanox.com>
Date:   Mon, 20 Apr 2020 10:28:00 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
In-Reply-To: <20200420151525.qk764gfgydbip6u2@salvia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-ClientProxiedBy: SN4PR0501CA0014.namprd05.prod.outlook.com
 (2603:10b6:803:40::27) To DB6PR0502MB3013.eurprd05.prod.outlook.com
 (2603:10a6:4:98::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.120] (70.113.14.169) by SN4PR0501CA0014.namprd05.prod.outlook.com (2603:10b6:803:40::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.6 via Frontend Transport; Mon, 20 Apr 2020 15:28:05 +0000
X-Originating-IP: [70.113.14.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 841cb49a-da0b-44e8-74c0-08d7e53f6c4d
X-MS-TrafficTypeDiagnostic: DB6PR0502MB2904:|DB6PR0502MB2904:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0502MB2904BD72C98287A961947030AAD40@DB6PR0502MB2904.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR0502MB3013.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(366004)(376002)(346002)(4744005)(5660300002)(4326008)(478600001)(66556008)(86362001)(31696002)(6916009)(66476007)(6666004)(6486002)(66946007)(16526019)(2906002)(186003)(31686004)(107886003)(316002)(8676002)(53546011)(81156014)(2616005)(8936002)(36756003)(956004)(52116002)(26005)(16576012);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eOB+X/C3gK+o134g7zvwNgb/p3DerEKM4sQR11Jjk0ekp/zHBeB3i0dvpeYz3fFqbIWeQ53PFzpTmRcbjMipTQZHS4hvopz2zKmHjjcxK++XS16zgeJUjNaaAFEDW5rQ7nYA/xTag5wRwTDGymdNleZaYvIG9sCmO3B50cNLdbBLOGDoqmeqHmyk50Din4DFb8/XZK5nw9vZs1UKX6tY9Rv73/DCyljN542ag01ZjRkcxgoJkBgykwvw5EJ0c3qECtQyCjPna87DjSdvnMWHgSIDfrJWAoCAANTlV5NQYvNwa+TTTlSTEismhgzA41kZkd4gush66X1E5eQrOSjS6jNvJDF1DHeX7jYic55VaitT+dc5lrj19ZOJuXivUX1UDBiIJ2kcVIhxHxytrogkkPuxZpbY5dRkZUCd2L0Ku0jULLkiG1DKhOWKrlbO4c2x
X-MS-Exchange-AntiSpam-MessageData: Mkqbxhnl920CS0QT7eMErHf/yZCnqt81k20CUK9Lgmp77ef0eer3amU8AJEWh5ECkcsco6pZAMWJcbYV0GeFL3GVOFknH8k4jroX1JWoYUzBqur7wmWUEiV4SfChFUYDu9du7EcJ01frs2u9X8ccdVI9VzxUZ7wRqclqK9ykGbg/gwkFce6SUbFrXHx9F9LZ78kCwvMIS16sGopnKRvBAnOPHc47AeBwQhA1slypSnWwdZFUaZInkY2kmDTOGtPhbsbYXodX20AF78yQz2ZjpTbcnNBltciCWU8G/Lhi/p27YrucMznwaAlTxTAdHqs8Spztz25eJWyzaKmJ6HUXA4eXMyVCRn146vYc+UmjSRLXXxE5L0gRMeyKzoB0rpKpV93KmlTYQY2LYdugG7LLDxF5sCbaJVHO5udWSLay9gYbYcqk+rB7l9hHPnxeenx6iCsHXOZCzb5Lsq30/KltBLxWqjSmAV11iXaE7MKiN2Yw7jwe8rNQnJjG+V+3MtbyiiwLy3M06qoJaoahCIT25VgW/YxPYFsbBhG7obVNo0IwJ52LFMCXoJ+9mHt+AEUI7854d4ZIzFIaHFU0Oc2QVrVhKobb5fkiJIKFOTNb3moeSDjFA+8FnRuzKD+QU/Odc+4qyo1xNruAQQVnV9LR6GSpa5Y7u/pAfOHPnvq0Tkz5yWEhhlQGFFsskhwYIuNQMjFB6Ah+hWpGkq6BMwctM5VtMd/uFpCjdovPsUaYbT1uu51kKCUyGk0sVqcgVrnO5/6ddXng0peURGv0WgStb16hEh0UGHnk92IvWQ6A4U4=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 841cb49a-da0b-44e8-74c0-08d7e53f6c4d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 15:28:06.2538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JW/htXVi7aN+BTsw6etzXmfXCpOfPtEJtVJxAN/pY0hFqrmLL9H8cztKn+NrDqhDZq03g3e65qC04bjQs92ISw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB2904
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 4/20/2020 10:15 AM, Pablo Neira Ayuso wrote:
> On Mon, Apr 20, 2020 at 09:58:10AM -0500, Bodong Wang wrote:
> [...]
>> @@ -796,6 +799,16 @@ static void flow_offload_work_stats(struct flow_offload_work *offload)
>>   				       FLOW_OFFLOAD_DIR_REPLY,
>>   				       stats[1].pkts, stats[1].bytes);
>>   	}
>> +
>> +	/* Clear HW_OFFLOAD immediately when lastused stopped updating, this can
>> +	 * happen in two scenarios:
>> +	 *
>> +	 * 1. TC rule on a higher level device (e.g. vxlan) was offloaded, but
>> +	 *    HW driver is unloaded.
>> +	 * 2. One of the shared block driver is unloaded.
>> +	 */
>> +	if (!lastused)
>> +		clear_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
>>   }
> Better inconditionally clear off the flag after the entry is removed
> from hardware instead of relying on the lastused field?

Functionality wise, it should work. Current way is more for containing 
the set/clear in the same domain, and no need to ask each vendor to take 
care of this bit.

