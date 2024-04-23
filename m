Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2076.outbound.protection.outlook.com [40.107.244.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18E083CD6
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Apr 2024 12:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713874946; cv=fail; b=MyxL5WRs5vW+z8kwNurgRN8Ozj/eigC5eFWa/fmM4FqsKfHm1KzyAS6AOnm9Z/ISJSajaR3fvpwiZURfFFhUbCq+2MUzLNIwg65msbnSP6rLqazND13QFonoidJicUu4U7K5IM8uFXOK8WlD50U/5B/hONSOpPeep0a9x+Vj0ho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713874946; c=relaxed/simple;
	bh=hux+ZUwoWmpkwDKE9xw9cEEJuiNTLh59Ttmjlr9DzL4=;
	h=References:From:To:CC:Subject:Date:In-Reply-To:Message-ID:
	 MIME-Version:Content-Type; b=pkg3vS2QSRTM3K5o8s80oNpMmlvr63n2VWvdxD+oqcsbUP1grjLyQbDls/LkqeyyhMyAwEOKAG+hTnuS9KGrXUsNZwHt1XrxpNBMrb6q4VsKpcgD9XV0/YRgbwx02VmOtqmaeCeNyl3+JbNS96c6zCHYCACTWgmhpJ2GTBnU8ys=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nZw4AMHY; arc=fail smtp.client-ip=40.107.244.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nZw4AMHY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z07SSIPHbMPdg01gb/+QJp75CQLaHQE/yHUar2jEvEJs7otwn9Tpewk0mo/F7JPB3JDCgS9fhfaDowX/v/Y8PgoPm4/Hfk6P3+eBi15+7SRoNaxQ3Grbep1xWhL7KfjUl1xQX+n4dELQI6qobZI5TzQcsIww/3T5KX1yWvcwlxXiUT3Hghz5M0EGFcGuHUhih7mpVXTeg5fpwgBpjJbwdvnCJLq2TpLQrMHSMNZwbnCcWxWHzIB7+Ke11u5DrjgrP5HGOEOB26cbwDTGEu1x2B1qZtdh+8Md+ROxvs1g6kHXAXX+kK7pn0vjsu60MwZUbPMEJ9eRZxTbtTD5izyh9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LhirtZeANUG9Zr4C9YDX2tWhx/OfN3N6fuD3psd8COE=;
 b=DHHOXQ2FVc9mE6m8967rczzmlEdenfBWTkLHFY/H0ayp8ntw0JbrX7nFtkqFt4smAS++yZbnC6vRmuAkFSvJj7xgO4PtfqRjQeTIfCnRIOqpBks8f1Sw+p78+WDXxjlQr+p9pJ4hXPmON0+MHbqODHrxq8FXsQv/k3lGtTG/x0d2mfXgk8XjmVoondbFBOfE0V9Fu++8bzvZ9JjdQyjtu020kVw2OSo7Z5/FWLgPu2mQcdCHKknJ0o4akGwoRKlP/GjiCpmfWcdQjLaBWlNI3K5FpIyStisXj1kA4uW9GSRJW0pWfIHjHsgEED0PMR+psyKre9oshzzJpezHw/SVlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LhirtZeANUG9Zr4C9YDX2tWhx/OfN3N6fuD3psd8COE=;
 b=nZw4AMHY29BuizUjlt7eiITW9UA9Bf62Ef734rqDBkAytKwee9MXnr5LWMi3A5bo9MvfR0JgsZlBYZ5lMcNoiNMsktKurSQQGG+SG0rS31KD5aUp9VI9kh2/1bnNI5aqZfWzNx+tOydzBp/9QCCPAmqpLkTylaOfwOnvEGz4DK8okjCWNcqDg5g1o8vJY1pozsO1l+73NNtraoJrkf/DdDPgT3ib9XL663+EfzQbJd9XpONixs9wD55k15m+20+goHMhEUaiY+NKJbBmwbXvsbQFTj4OnkHtHgmtZfVQZ5TFwaIWPTzZKFTSBTPz450naDoJhcNqIMdirOiqhmlKCg==
Received: from CH0P220CA0020.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:ef::33)
 by SJ2PR12MB8033.namprd12.prod.outlook.com (2603:10b6:a03:4c7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Tue, 23 Apr
 2024 12:22:22 +0000
Received: from CH1PEPF0000AD7F.namprd04.prod.outlook.com
 (2603:10b6:610:ef:cafe::53) by CH0P220CA0020.outlook.office365.com
 (2603:10b6:610:ef::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.35 via Frontend
 Transport; Tue, 23 Apr 2024 12:22:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH1PEPF0000AD7F.mail.protection.outlook.com (10.167.244.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7452.22 via Frontend Transport; Tue, 23 Apr 2024 12:22:21 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 23 Apr
 2024 05:22:07 -0700
Received: from fedora.nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 23 Apr
 2024 05:22:06 -0700
References: <20240423134434.8652-1-fw@strlen.de>
User-agent: mu4e 1.10.5; emacs 29.2.50
From: Vlad Buslov <vladbu@nvidia.com>
To: Florian Westphal <fw@strlen.de>
CC: <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next] netfilter: conntrack: remove flowtable
 early-drop test
Date: Tue, 23 Apr 2024 15:16:31 +0300
In-Reply-To: <20240423134434.8652-1-fw@strlen.de>
Message-ID: <87sezc2rro.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7F:EE_|SJ2PR12MB8033:EE_
X-MS-Office365-Filtering-Correlation-Id: 80b81f92-9abc-4454-3760-08dc639006b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?StnUjSTiu4OyaKs6RcGtcC3f6LHBSHGfx1RiQRWBolZBFiYNIjjBI8kgB8cG?=
 =?us-ascii?Q?4tReN1Ja+DtET6Yqg7puMPW/EabGfPfOeJuxNrID6HeHkG0t+gVPpPwNGcO2?=
 =?us-ascii?Q?ARAy+/YJRr+hqTi7fRA8T8jrqCuzxBk96z3ns87vRkbiGBQUElE2lTi61L7y?=
 =?us-ascii?Q?FVPKHww6c9uDuwA6QiTfDJcYmO38tFrhnVXEE6xzZUd12onwq22RteBGrPW+?=
 =?us-ascii?Q?HPigas/t4LnYhoultkQhT6LTOpq9izH+2gixCF/qcivvIprQcUD7awJUF1vi?=
 =?us-ascii?Q?OC80+FkrHtJfYAMKk1tGSYm6gZeTH8nMKXqL+gEGkrTbRJ2bACk4BfELzQs+?=
 =?us-ascii?Q?YnMiqVwxoQifapXw5QsPkHK+VoIUlpc5/lQgme3US6hogBGqZmOn0yajJh5a?=
 =?us-ascii?Q?oBB8oVZ1G0CQg28jk/5ADGZ2EjSQ9/wl6+oYqx2CNaK+66Ie0WWtwwfVwwWU?=
 =?us-ascii?Q?d7JM7ORW8aIckSbls7G+pyMBiiUkfjVT4xUEemZWfETB5UFDH6TM8OZHpI5w?=
 =?us-ascii?Q?uZ9wgKCRDhkJNSzXkTo4cidY+5w+unI8BZfV7p7425q1l+7Rfut6sQdZBNlf?=
 =?us-ascii?Q?JDQrRVE5BIWTqvpHyOdb2IFJlIpoPPab8I/uoZBiznJbGiDh1NS67BBDMSyH?=
 =?us-ascii?Q?6eHnttR+DWJqMuqrdRzK6UzrGbS8iB8uay0pGd5dWKUYpaWqVe50XTAuxy2Y?=
 =?us-ascii?Q?TIuV0vlSCpXrSoBI20H9wpo5uuOdsUWqhe+LOh5NRW9nSBl0dSkmUo1Hej9A?=
 =?us-ascii?Q?n8/aOuw4xXwQ4erlBZRubRz0R4uv2Vh/7+RBKurQBYUXZr1X0nD5mlOzo25D?=
 =?us-ascii?Q?1xspzhT0ZVJSe7HUAV4TNQ4n/0tY3M8RFfJ84x2ESdIcgpsUEVay/x2YrLYX?=
 =?us-ascii?Q?7pimX11Im9mQjUNIspWYR5UCci/J7JZydFUieW62ZxWdoausvmxqVo1z7hAn?=
 =?us-ascii?Q?FFqckbmLdIQFgPHjwJ+xT633+5tDHAlZU/M+J/e6ftiElOTOe/M8oqMmCwx6?=
 =?us-ascii?Q?NhUiT6IlHUPVIYYAePrzde2KKqBaUJGiDWifkaC4w6XaBz5ZWyKwFQNhTRs2?=
 =?us-ascii?Q?vWLLGr0reWdPpeLq/R01Tk9dYOhWjSv+ZAftZzlHyxmlxx8ov1le2/oedQNV?=
 =?us-ascii?Q?GyXLEa9erqlqqG+e+7JBkUJiA9mKalJkB0BSFBs4qXEZjZ0Le+lcWNGr3fbg?=
 =?us-ascii?Q?tx1o8+mYhNCltxM/k/r3X/MLUEQ+4udOZEoosxwaxWXj2tRHPrIgsxEdm96t?=
 =?us-ascii?Q?tjxTkwCtyYgWZzKTXPqYUO5/yCrJ12wJt/jl9MqIBHtU66i3ur2StDfIoqnJ?=
 =?us-ascii?Q?MRAjnKl9ai3UwNulZfrsAv79gCkBLym/NL84aQwLog2lJfmTegGLi2og1quJ?=
 =?us-ascii?Q?vQv9Ms9/FUtj4f0NtpJoYXWgVtCn?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(376005)(82310400014)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 12:22:21.7225
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 80b81f92-9abc-4454-3760-08dc639006b8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8033

On Tue 23 Apr 2024 at 15:44, Florian Westphal <fw@strlen.de> wrote:
> Not sure why this special case exists.  Early drop logic
> (which kicks in when conntrack table is full) should be independent
> of flowtable offload and only consider assured bit (i.e., two-way
> traffic was seen).
>
> flowtable entries hold a reference to the conntrack entry (struct
> nf_conn) that has been offloaded. The conntrack use count is not
> decremented until after the entry is free'd.
>
> This change therefore will not result in exceeding the conntrack table
> limit.  It does allow early-drop of tcp flows even when they've been
> offloaded, but only if they have been offloaded before syn-ack was
> received or after at least one peer has sent a fin.
>
> Currently 'fin' packet reception already stops offloading, so this
> should not impact offloading either.
>
> Cc: Vlad Buslov <vladbu@nvidia.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Vlad, do you remember why you added this test?

I added it when I introduced UDP NEW connection offload. As far as I
remember the concern was that since at the time early drop algorithm
completely ignored all offloaded connections malicious user could fill
the whole table by just sending a single packet per range of distinct 5
tuples and none of the resulting connections would be early dropped
until they expire.

>
>  For reference, this came in
>  df25455e5a48 ("netfilter: nf_conntrack: allow early drop of offloaded UDP conns")
>  and maybe was just a 'move-it-around' from the check in
>  early_drop_list, which would mean this was there from the
>  beginning.  Doesn't change "i don't understand why this test
>  exists" though :-)
>
>  net/netfilter/nf_conntrack_core.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index c63868666bd9..43629e79067d 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -1440,8 +1440,6 @@ static bool gc_worker_can_early_drop(const struct nf_conn *ct)
>  	const struct nf_conntrack_l4proto *l4proto;
>  	u8 protonum = nf_ct_protonum(ct);
>  
> -	if (test_bit(IPS_OFFLOAD_BIT, &ct->status) && protonum != IPPROTO_UDP)
> -		return false;
>  	if (!test_bit(IPS_ASSURED_BIT, &ct->status))
>  		return true;

