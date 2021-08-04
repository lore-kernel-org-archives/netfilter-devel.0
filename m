Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 443C7C4338F
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Aug 2021 11:00:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2822161029
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Aug 2021 11:00:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237689AbhHDLA6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Aug 2021 07:00:58 -0400
Received: from mail-co1nam11on2054.outbound.protection.outlook.com ([40.107.220.54]:32096
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236972AbhHDLAz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Aug 2021 07:00:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DPGK5pXLHhMbmnCtdHA3zSJktCYO5W23dcNwlKYTS4N0XsG+xK5tYMk+dLHmPj7MZ3DH7jTstaZgMrCLFYmRlcP4TnX0QgXt02BxcNHKm+RlddOwM5H/JObgtL1cgU3sfEUDVxEUYJ4GitVuFdwuewcOR8HHfiUavngnOQfaHmHi/fg14PJ+vdcrzwCOHlJfNi+yj44aavJs/u+vPB7cHUShULJcBcC74j9JJnrgA/glIw/q2+sykXwcokajxty/HH9Qqb8mAHksIPdD5OZS8A197uEj08dPa9NJh9iUm7KmFHzzkQ58WIkzzxvehZXvEhNx2EJbtmPICxYWYa935A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4JQbKpIzQuw8LdQOydOpFqtK6VPlA/867CirdlwX09M=;
 b=GAH9JJExbs+nEZnWGOKKgTtrM6t5aGpTT9R9jdcVzSasSBI+UBhKJcMnUoHYfW7vWjD4QYlW3J6xjOWAOLKIoULK2HsAQi53/ro3G20qnDJcCWHqWTbiCn2Igf+uhBril1gH/pkzrkElfo4+Jj1H1JOGU0POvySh/ZoVfW9qlkq8p0Mwo7RgNdbDzfXZQd5da/hN4cS/eG0a3EWdVaYe4kSK8CK7L9M6nEHxgXJzuHD+cCNZeOW92J1AyupIH0DVStKAnH7j1Efx97lJr3KLTF8yZJYHajTa+qNYhAoSiIjMr1d0iiwP4W8pbYtmLcrqJ7jBMSOxdbFv5/WUH3bOQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4JQbKpIzQuw8LdQOydOpFqtK6VPlA/867CirdlwX09M=;
 b=NTlcsJhPe8Kp+towIbjUo/YQy9goo/C5ubDy4HxbI6HNu74636KEJ4sPdFV5tFOPNdGMQ8o8hb2QOzQrDIS/DQI+P8flue2d1HkZHR9l4jKuhtHhtymJL2go0zh3E0M8W2NxdkQ27Jq+BV+uF8HFBxu+DqKf/DpJaOvy5jvkZ3TZ6Jqm3xbVNRTscO4buJPfEamXjDJh5xK57kS0HclR9ksFFlAWHpU75fh0xoL9IiZOiSrnyKm81TSrPpjH5exogiqmakeLH5w7GQL/kEoqaYnt21kAEpqkGyIxVrefuk3iVcX5xjPp/9ZhPvRfTgyn/OSUHPmnwVU8jt+xSqea0w==
Received: from MW4PR03CA0048.namprd03.prod.outlook.com (2603:10b6:303:8e::23)
 by DM6PR12MB4450.namprd12.prod.outlook.com (2603:10b6:5:28e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Wed, 4 Aug
 2021 11:00:42 +0000
Received: from CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::f4) by MW4PR03CA0048.outlook.office365.com
 (2603:10b6:303:8e::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend
 Transport; Wed, 4 Aug 2021 11:00:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT009.mail.protection.outlook.com (10.13.175.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4394.16 via Frontend Transport; Wed, 4 Aug 2021 11:00:42 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 4 Aug
 2021 11:00:41 +0000
Received: from [172.27.15.182] (172.20.187.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 4 Aug 2021
 11:00:39 +0000
Subject: Re: [PATCH nf] netfilter: conntrack: remove offload_pickup sysctl
 again
To:     Florian Westphal <fw@strlen.de>, <netfilter-devel@vger.kernel.org>
CC:     Paul Blakey <paulb@nvidia.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
References: <20210804092549.1091-1-fw@strlen.de>
From:   Oz Shlomo <ozsh@nvidia.com>
Message-ID: <57d7336e-67a9-661e-e0ef-aa49ee08b8c5@nvidia.com>
Date:   Wed, 4 Aug 2021 14:00:17 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210804092549.1091-1-fw@strlen.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ebb5724-7154-47a2-5995-08d957371a20
X-MS-TrafficTypeDiagnostic: DM6PR12MB4450:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4450603847AA9B6E61B5A2C8A6F19@DM6PR12MB4450.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: drld/8S/nkJmgEcNdP/MM/oyUaOK46ummTKmu6+gQKqNvI4ePeg1FDWc2wP/QEzNSmMgiTwhE6z+sMZPE9dDUTR5GNzOmQZt0lV8WMID/MSafUNV8R4wHixdQKMTos2XL2118adLmwWg2HF83Ri7p4otOKbo4fChPftePPmCP0GfoWQKxPwPkuy6GXzIH5XIJj5jRLw/viV8WnmSzi9mF922CWcgcNhuK7mt5VGRWe7RQ2hyNgtamnf7X9IXMflTkuqjx/Cm5f/NTDfYZx7VE5rr5zqva8sCPOUEAy1UqyqvJF+uZ6QmL+f8ZZXySyy7cnzrILNiVk2BY3RIyNFWIJptyrvnVeSXyuQ9R9Xcd0kgrTEg0DpnaOYLQxmnKq49nXAiZThTncq/MbU6XUc/aF5FXgDXIiL/HX9SoQBndJvJVoFTfGT5cAbjmzFxt4AT3s0AdkQ/5/DtlK0rcyRUTVMmXBtfvILAN3TGgUO2itmZ46Lerr15YsdRpX3VahV1qbnSiBOohTbXuhaiiB9eAxdw/8nRgDvPI6RU7Z5HGAKgNTYnGWSSzWCFyps7YB/xwzDlqeVcH9cUgsyvAJrySMWCL9ybMM9Ax0GXUQ2LRCoalGKFLAzwXNWWJquuNfz+t2LwR4dsCOQqh5KgWbZ8ipyo7E8EtYpyKs4NUzj6fJfN2Bmx2cNH9dAJ6zL48q5ke4zDBiioyTe6+lp2D5HkwGLVHfhaj0NKRHhBZWcbzJ4=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(376002)(396003)(36840700001)(46966006)(4326008)(110136005)(54906003)(186003)(53546011)(26005)(2616005)(316002)(36906005)(16576012)(8676002)(31686004)(426003)(8936002)(16526019)(7636003)(356005)(31696002)(336012)(2906002)(70206006)(6666004)(70586007)(478600001)(36756003)(82740400003)(86362001)(83380400001)(5660300002)(82310400003)(36860700001)(47076005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 11:00:42.1392
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ebb5724-7154-47a2-5995-08d957371a20
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4450
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian/Marcelo,

On 8/4/2021 12:25 PM, Florian Westphal wrote:
> These two sysctls were added because the hardcoded defaults (2 minutes,
> tcp, 30 seconds, udp) turned out to be too low for some setups.
> 
> They appeared in 5.14-rc1 so it should be fine to remove it again.
> 
> Marcelo convinced me that there should be no difference between a flow
> that was offloaded vs. a flow that was not wrt. timeout handling.
> Thus the default is changed to those for TCP established and UDP stream,
> 5 days and 120 seconds, respectively.
> 
> Marcelo also suggested to account for the timeout value used for the
> offloading, this avoids increase beyond the value in the conntrack-sysctl
> and will also instantly expire the conntrack entry with altered sysctls.
> 
> Example:
>     nf_conntrack_udp_timeout_stream=60
>     nf_flowtable_udp_timeout=60
> 
> This will remove offloaded udp flows after one minute, rather than two.

This part of the patch looks good to me.

> 
> When flow transitions back from offload to software, also clear the
> ASSURED bit -- this allows conntrack to early-expire the entry in case
> the table is full.

Doesn't this introduce a discrpency between offloaded and non-offload connections?
IIUC, offloaded connections might timeout earlier after they are picked up by the software when the 
conntrack table is full.
However, if the same tcp connection was not offloaded it would timeout after 5 days.

> 
> The existing TCP code sets the ASSURED bit again when a valid ACK is seen
> while conntrack is in ESTABLISHED state.  UDP re-sets on next packet.
> 
> Cc: Oz Shlomo <ozsh@nvidia.com>
> Cc: Paul Blakey <paulb@nvidia.com>
> Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>   Pablo, please wait a bit before applying so that Oz, Paul and Marcelo
>   have time to ack/nack this.
> 
>   .../networking/nf_conntrack-sysctl.rst          | 10 ----------
>   include/net/netns/conntrack.h                   |  2 --
>   net/netfilter/nf_conntrack_proto_tcp.c          |  1 -
>   net/netfilter/nf_conntrack_proto_udp.c          |  1 -
>   net/netfilter/nf_conntrack_standalone.c         | 16 ----------------
>   net/netfilter/nf_flow_table_core.c              | 17 ++++++++++++++---
>   6 files changed, 14 insertions(+), 33 deletions(-)
> 
> diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
> index d31ed6c1cb0d..024d784157c8 100644
> --- a/Documentation/networking/nf_conntrack-sysctl.rst
> +++ b/Documentation/networking/nf_conntrack-sysctl.rst
> @@ -191,19 +191,9 @@ nf_flowtable_tcp_timeout - INTEGER (seconds)
>           TCP connections may be offloaded from nf conntrack to nf flow table.
>           Once aged, the connection is returned to nf conntrack with tcp pickup timeout.
>   
> -nf_flowtable_tcp_pickup - INTEGER (seconds)
> -        default 120
> -
> -        TCP connection timeout after being aged from nf flow table offload.
> -
>   nf_flowtable_udp_timeout - INTEGER (seconds)
>           default 30
>   
>           Control offload timeout for udp connections.
>           UDP connections may be offloaded from nf conntrack to nf flow table.
>           Once aged, the connection is returned to nf conntrack with udp pickup timeout.
> -
> -nf_flowtable_udp_pickup - INTEGER (seconds)
> -        default 30
> -
> -        UDP connection timeout after being aged from nf flow table offload.
> diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
> index 37e5300c7e5a..fefd38db95b3 100644
> --- a/include/net/netns/conntrack.h
> +++ b/include/net/netns/conntrack.h
> @@ -30,7 +30,6 @@ struct nf_tcp_net {
>   	u8 tcp_ignore_invalid_rst;
>   #if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
>   	unsigned int offload_timeout;
> -	unsigned int offload_pickup;
>   #endif
>   };
>   
> @@ -44,7 +43,6 @@ struct nf_udp_net {
>   	unsigned int timeouts[UDP_CT_MAX];
>   #if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
>   	unsigned int offload_timeout;
> -	unsigned int offload_pickup;
>   #endif
>   };
>   
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> index 3259416f2ea4..af5115e127cf 100644
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -1478,7 +1478,6 @@ void nf_conntrack_tcp_init_net(struct net *net)
>   
>   #if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
>   	tn->offload_timeout = 30 * HZ;
> -	tn->offload_pickup = 120 * HZ;
>   #endif
>   }
>   
> diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
> index 698fee49e732..f8e3c0d2602f 100644
> --- a/net/netfilter/nf_conntrack_proto_udp.c
> +++ b/net/netfilter/nf_conntrack_proto_udp.c
> @@ -271,7 +271,6 @@ void nf_conntrack_udp_init_net(struct net *net)
>   
>   #if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
>   	un->offload_timeout = 30 * HZ;
> -	un->offload_pickup = 30 * HZ;
>   #endif
>   }
>   
> diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
> index 214d9f9e499b..e84b499b7bfa 100644
> --- a/net/netfilter/nf_conntrack_standalone.c
> +++ b/net/netfilter/nf_conntrack_standalone.c
> @@ -575,7 +575,6 @@ enum nf_ct_sysctl_index {
>   	NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_UNACK,
>   #if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
>   	NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_OFFLOAD,
> -	NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_OFFLOAD_PICKUP,
>   #endif
>   	NF_SYSCTL_CT_PROTO_TCP_LOOSE,
>   	NF_SYSCTL_CT_PROTO_TCP_LIBERAL,
> @@ -585,7 +584,6 @@ enum nf_ct_sysctl_index {
>   	NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_STREAM,
>   #if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
>   	NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD,
> -	NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD_PICKUP,
>   #endif
>   	NF_SYSCTL_CT_PROTO_TIMEOUT_ICMP,
>   	NF_SYSCTL_CT_PROTO_TIMEOUT_ICMPV6,
> @@ -776,12 +774,6 @@ static struct ctl_table nf_ct_sysctl_table[] = {
>   		.mode		= 0644,
>   		.proc_handler	= proc_dointvec_jiffies,
>   	},
> -	[NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_OFFLOAD_PICKUP] = {
> -		.procname	= "nf_flowtable_tcp_pickup",
> -		.maxlen		= sizeof(unsigned int),
> -		.mode		= 0644,
> -		.proc_handler	= proc_dointvec_jiffies,
> -	},
>   #endif
>   	[NF_SYSCTL_CT_PROTO_TCP_LOOSE] = {
>   		.procname	= "nf_conntrack_tcp_loose",
> @@ -832,12 +824,6 @@ static struct ctl_table nf_ct_sysctl_table[] = {
>   		.mode		= 0644,
>   		.proc_handler	= proc_dointvec_jiffies,
>   	},
> -	[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD_PICKUP] = {
> -		.procname	= "nf_flowtable_udp_pickup",
> -		.maxlen		= sizeof(unsigned int),
> -		.mode		= 0644,
> -		.proc_handler	= proc_dointvec_jiffies,
> -	},
>   #endif
>   	[NF_SYSCTL_CT_PROTO_TIMEOUT_ICMP] = {
>   		.procname	= "nf_conntrack_icmp_timeout",
> @@ -1018,7 +1004,6 @@ static void nf_conntrack_standalone_init_tcp_sysctl(struct net *net,
>   
>   #if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
>   	table[NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_OFFLOAD].data = &tn->offload_timeout;
> -	table[NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_OFFLOAD_PICKUP].data = &tn->offload_pickup;
>   #endif
>   
>   }
> @@ -1111,7 +1096,6 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
>   	table[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_STREAM].data = &un->timeouts[UDP_CT_REPLIED];
>   #if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
>   	table[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD].data = &un->offload_timeout;
> -	table[NF_SYSCTL_CT_PROTO_TIMEOUT_UDP_OFFLOAD_PICKUP].data = &un->offload_pickup;
>   #endif
>   
>   	nf_conntrack_standalone_init_tcp_sysctl(net, table);
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index ec3dd1c9c8f4..8b23c19e1833 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -182,20 +182,31 @@ static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
>   {
>   	struct net *net = nf_ct_net(ct);
>   	int l4num = nf_ct_protonum(ct);
> -	unsigned int timeout;
> +	s32 timeout;
> +
> +	/* Clear assured to allow early_drop for this entry.
> +	 *
> +	 * The flag is set again if the connection sees a reply packet.
> +	 */
> +	clear_bit(IPS_ASSURED_BIT, &ct->status);
>   
>   	if (l4num == IPPROTO_TCP) {
>   		struct nf_tcp_net *tn = nf_tcp_pernet(net);
>   
> -		timeout = tn->offload_pickup;
> +		timeout = tn->timeouts[TCP_CONNTRACK_ESTABLISHED];
> +		timeout -= tn->offload_timeout;
>   	} else if (l4num == IPPROTO_UDP) {
>   		struct nf_udp_net *tn = nf_udp_pernet(net);
>   
> -		timeout = tn->offload_pickup;
> +		timeout = tn->timeouts[UDP_CT_REPLIED];
> +		timeout -= tn->offload_timeout;
>   	} else {
>   		return;
>   	}
>   
> +	if (timeout < 0)
> +		timeout = 0;
> +
>   	if (nf_flow_timeout_delta(ct->timeout) > (__s32)timeout)
>   		ct->timeout = nfct_time_stamp + timeout;
>   }
> 
