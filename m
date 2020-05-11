Return-Path: <SRS0=NFxu=6Z=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DE7FC47255
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 May 2020 10:40:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECCFB206F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 May 2020 10:40:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=Mellanox.com header.i=@Mellanox.com header.b="WGxcRaGe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729554AbgEKKkK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 May 2020 06:40:10 -0400
Received: from mail-vi1eur05on2075.outbound.protection.outlook.com ([40.107.21.75]:6068
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728209AbgEKKkK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 May 2020 06:40:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SUe8lDXNB9KUUrXs/7DZussnOtdFXHKD2u+u5wMfxRKKAW/f1dIprVjoYoDtKbKEn4ZK6wJ+mPacSVOgQbIDFgk/2z40QWPSUmpmkc4oFdfSsiJYDrAIxL/F9NQADRSMX0pPP5EmzayXIXEkUOcWSNoXUlCUXN5Mt1PSaoLWV+VQESSwx6zGGZ/2EL+tOBNCGkXlpmzIqa0bFQIW59rDXjr153EDsc1BWF8H9hsk/nRmwV4TRR8KR4ZzoRP2OjK7jKeH9tlFV+9pooeimejvFrvRF5/sVq0asaAYwFmWT4KRVOMD8FnHeaOthBVN4FUaEvChcy1IAWVxv42ySCuUpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZd098yXwYZD2X4i6exyI8STbrriDL6Hj6U6pRjFEMI=;
 b=gCJV+jmg2TwTYA+LN6t40vmQP3aRsyZ1FRFx9ofnpGOJcPGQ7WO0v+rJLihriozqZfcG9oQCJ/dyQetw1HmPWJIGwwZh/XQbElLkb31ylELLlfo0LZiPqoK2TIWzn0/XnESO/63l3ZxjJQgy2vSLBNyRVO4yShyUu5XlexiptHKXoew9kVLnxdoWaHxwOca12niXT9W1v+Kp52YEFa+lINuV/+MLfbW8Zs9k8DuH/0Zc6m6Krk+6UHqq6rgdiQG9Fo0CyVsFJmTP5Z8NPZn9Lv4YFoSatn5XICf5oyf3/QegQX3sHh3yN29S0XdzY6zZ+9yw2CgOtowScRoYKuH/NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZd098yXwYZD2X4i6exyI8STbrriDL6Hj6U6pRjFEMI=;
 b=WGxcRaGeSkJxGn61LTPNdDBoCRocLiP0NGwxNSc8SyXdmXmC59XI3Gdvht5rqjKSD0gKkk0ALgf44Xr4PCAcX9HVhaATvuX7nfBrLO53HN/opnch1WHKUDxFomofcb+n4A0zvOT3lfVd0FncDNDyxNa5leWOTfaPAmQwfySjHWk=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from DB7PR05MB4156.eurprd05.prod.outlook.com (2603:10a6:5:18::21) by
 DB7PR05MB4841.eurprd05.prod.outlook.com (2603:10a6:10:1e::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2979.34; Mon, 11 May 2020 10:40:05 +0000
Received: from DB7PR05MB4156.eurprd05.prod.outlook.com
 ([fe80::39ab:622c:b05b:c86]) by DB7PR05MB4156.eurprd05.prod.outlook.com
 ([fe80::39ab:622c:b05b:c86%3]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 10:40:05 +0000
Subject: Re: [PATCH nf] netfilter: flowtable: set NF_FLOW_TEARDOWN flag on
 entry expiration
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     ozsh@mellanox.com, saeedm@mellanox.com
References: <20200511101742.20748-1-pablo@netfilter.org>
From:   Roi Dayan <roid@mellanox.com>
Message-ID: <d64ee421-5f7b-f40f-1ef0-654c956fc267@mellanox.com>
Date:   Mon, 11 May 2020 13:40:00 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20200511101742.20748-1-pablo@netfilter.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR10CA0004.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::14) To DB7PR05MB4156.eurprd05.prod.outlook.com
 (2603:10a6:5:18::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.170] (176.231.113.172) by AM0PR10CA0004.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Mon, 11 May 2020 10:40:03 +0000
X-Originating-IP: [176.231.113.172]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 11d56111-06fe-4a43-ddcf-08d7f597aa4c
X-MS-TrafficTypeDiagnostic: DB7PR05MB4841:|DB7PR05MB4841:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR05MB4841D12667CD0649AD47D72FB5A10@DB7PR05MB4841.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 04004D94E2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PKMhNu1T0z8fCxFuitLxRQgxsLuLs6w4ooCGolnNdE+k4ycJcHXcB1w9APFVl+Euu2+htYD0BjvQKSWwI0kR8U5dSdM9wXRtjbwraObCLWVbk/esD49M+STZAd7JaK2flY+dg0fHLsSPfkAoNseQFKX07b9xJ0c7QJBKn7fJD/3wFzfVJ+vLRian76bpioCHrhz/5CE+41TleAXOi6Qj8MOHiBUSRxGnHOh5P3pV2AnEdGhmVIrs25ArPXRc5jkH90LOkeUQn0jPvVPBGyffFAY3SVZv5SJAnZCgvOcF6Ej2UBE0JtjLU9RWJrrovk4NA9LmRMqshhZ6fQb7lsSQZqyco7RW98TbIenjF3gYaypbP9zjTQS2+VxYtF4Bk5UJ4cEjTCn5OgY9AQiq3FgZvrzkG5JvMYF/sk1HWntf9ci/RC2M8rj1M0LZa6w1s0ky6ldLzsrlHonPfguxH21SybtDunCkWNKr37+xjjgpFKz5N9KE4dvlCKU0Pi5iA65I4gesupNXiGN6HzHrZGSCxz9LcOsj8LFsU9hdznUC4HDadLE1m32hhFA8rrxf3GLd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR05MB4156.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(376002)(39860400002)(396003)(136003)(33430700001)(33440700001)(2616005)(4326008)(107886003)(86362001)(66476007)(26005)(66946007)(52116002)(186003)(16526019)(36756003)(8676002)(316002)(478600001)(53546011)(31696002)(956004)(66556008)(31686004)(2906002)(8936002)(6486002)(5660300002)(16576012)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: +LrXxKYBZV6YAkZwIw9Fw0OfxMdP8ZMwPrWxYg2iVdeOKdsRvkbkYr6s/XLm1WR+1NTiWoFaUcQeIWLn1d0Ts1LqJfRJJYIizi7LsfcIKvUg/+Nz7KO91p4bl6wZOnTGMh5+8zMjJKAM78pgVoGE7IqU6clCRosyWUWPlh5lNqxPFpq2x4LcdJn/kAYTwgYqngw8n/vvfBfarR6agQpMT7DX8Kd9DFRuYUWePcHqhRDUX6El5pBLxSw57Cc+0C2XqGwaWn8zFdWrLE+9zdUGzCYoYU5L+ly8UIhWPH6uA3vPCdhqGUGsGRI9EvW6aXGwO7ZUDWkAiFj6xLi+sTUSZb3hJqTTuZtgixd2beOYqu6/sh1wkPefbrjUiVY7nDY6lHulMBHO19lfKL6nwpl4w4uaHYGQG1Uza0clM8WOJrJW8hgVe2WSaLo73NntypSAlaqUI0wDRNB0acbRb/M4KJKILAdqStYSsFDSR0uLRUd+x21lpcaMtJCBk0lxhPEG
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11d56111-06fe-4a43-ddcf-08d7f597aa4c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2020 10:40:04.9371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k87Fb4Ky1UMBNzTGFe2hJ9HKqWI1aJOIGByExm9z4Ol4W5r5yVBo4aRPgj+Oir7v5t/a88ywhlzgnmA9NUyUcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB4841
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 2020-05-11 1:17 PM, Pablo Neira Ayuso wrote:
> If the flow timer expires, the gc sets on the NF_FLOW_TEARDOWN flag.
> Otherwise, the flowtable software path might race to refresh the
> timeout, leaving the state machine in inconsistent state.
> 
> Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
> Reported-by: Paul Blakey <paulb@mellanox.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_flow_table_core.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 4344e572b7f9..42da6e337276 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -284,7 +284,7 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
>  
>  	if (nf_flow_has_expired(flow))
>  		flow_offload_fixup_ct(flow->ct);
> -	else if (test_bit(NF_FLOW_TEARDOWN, &flow->flags))
> +	else
>  		flow_offload_fixup_ct_timeout(flow->ct);
>  
>  	flow_offload_free(flow);
> @@ -361,8 +361,10 @@ static void nf_flow_offload_gc_step(struct flow_offload *flow, void *data)
>  {
>  	struct nf_flowtable *flow_table = data;
>  
> -	if (nf_flow_has_expired(flow) || nf_ct_is_dying(flow->ct) ||
> -	    test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
> +	if (nf_flow_has_expired(flow) || nf_ct_is_dying(flow->ct))
> +		set_bit(NF_FLOW_TEARDOWN, &flow->flags);
> +
> +	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
>  		if (test_bit(NF_FLOW_HW, &flow->flags)) {
>  			if (!test_bit(NF_FLOW_HW_DYING, &flow->flags))
>  				nf_flow_offload_del(flow_table, flow);
> 

thanks

Reviewed-by: Roi Dayan <roid@mellanox.com>
