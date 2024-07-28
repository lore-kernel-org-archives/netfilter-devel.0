Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CA225622;
	Sun, 28 Jul 2024 11:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722166462; cv=fail; b=m4mWDykbCBZHsAM1LMWYsti5F6T2YSnEvAboNvhSl7zIlkAgdjIuDxAZx5SJsovQWROXZfK2jvIUTabCLE8cpPlvwhQLc9LBH2dWOFBDOAzgbrr2lMrK/QGlRJdTLdubE9gmnGMZeS7SgY8+Kj+wBZlwidvrd11TspKU2Q+5l68=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722166462; c=relaxed/simple;
	bh=/nixCiXUQUOCsSUjr67tntRpWMsrsU8ZKr6s0lLJS4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=D56vutq1IMxPri2CaaYgFcJU0ocalEz/Y6MwVO5NQaMuBiZC0aVgEoEnSG+PO7yz3gStEzNTX8GllXvLDoxj/Tof9u3l/FnyIQxqmMm9mxWCRvnBMLXZK4CXfF7w1v9Lftqe4hZTa2EEtTx24TpsLudoxvt5EsAj4MLPHeKsZgs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=a/mVXz57; arc=fail smtp.client-ip=40.107.94.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="a/mVXz57"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sgSjg+YHfdFUVOr4cftNhax/96r+XMdoy09VHlRbGEi8eMF5Eaz3fQCBNGsgxKNZYcmwpy3Y5bmB2v3cVLV5kwgQNiCFeUzBRRIA9/+q/4lO2nw8TbET0vlO+YGIwSUuKvj+1xJHa53m32uAlL9qQuqYtMdZevG89zLD+lueqTcmgij1Me7TKBmevNpk7ydT0nrLd8mNGv3vz5jlHo8BIyi7xhgg5T97rKqzuHWZHEB2wPAc6GKxEwfHbG26A8fZMsCBBTQcGXYwg5tRq+tZ4wn3U7xZc/q2UwWlmHmBfil7UkZx5f0fQOSir/ghBPOZiyMlMy+val8VLq2pfZapTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xon6wex/1T1EjB90HTLI9gEooFZhARAFh2L0n2EUWLs=;
 b=AoeV/eI3ePY2IM4e5DUfzOtaXquDw7WreYbVwE7XX2WGcil9lVBrciQUXsNOoeI7C6+6kGdRkHZGCWH/SzMVsvP1J+deJKpCK6eSK7h03OM7aDW2ALDVT+4nXYye7vPg2fQBUvKisopVl85PlsUoAAIKwygV5grGy9PB2C4DuCRLCMgRz4qnHo8Eta14xHrThDVAsgYPEiNBJqrs4gQJBoJXnZik2wU7XFYeigS4iXScJXN42U4PcfYAIcw6/tzjS+AFC4KzUxaUEhCfzH+hKybBqub3/iHL59+5jX6WGhwNY0WtKNDlf6EWyRWAHzaomct3FqZfltVautRzGetQVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xon6wex/1T1EjB90HTLI9gEooFZhARAFh2L0n2EUWLs=;
 b=a/mVXz57oFYpVugiRYpEFC8rAnLy4q+uWRc1jXU1Ty0nhPf9euinI03rXSnGfWPsJgH0DyHlL2XyQXrqDV1V0I7AemqH9Z+kGVWc78gSkyopz1p2T+X6B/1E2XQEj9pqRSTsHcMQnTHjSQF0+m4j45zxozaeMcqV2FUXhJu1VVc6/QULw2yG1aDJfweJ+ut2dHnZzDsvTHwi5xM3z/R6a2uEB1hLhL4y+eVnkk+4yVXd/5GbJtBkDVmDhgjhknXsiatS3PuUMnonbkXeyAZBfyiRl63NA0i8x8WZJm4vOCJIemuA7jz1O8RTo0nNv3BL/rq+3CaPA007ONdn5/Uzaw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DS0PR12MB8366.namprd12.prod.outlook.com (2603:10b6:8:f9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.27; Sun, 28 Jul
 2024 11:34:18 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9ec8:2099:689a:b41f]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9ec8:2099:689a:b41f%5]) with mapi id 15.20.7807.026; Sun, 28 Jul 2024
 11:34:18 +0000
Date: Sun, 28 Jul 2024 14:34:06 +0300
From: Ido Schimmel <idosch@nvidia.com>
To: Guillaume Nault <gnault@redhat.com>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, dsahern@kernel.org, pablo@netfilter.org,
	kadlec@netfilter.org, fw@strlen.de
Subject: Re: [RFC PATCH net-next 3/3] ipv4: Centralize TOS matching
Message-ID: <ZqYsrgnWwdQb1zgp@shredder.mtl.com>
References: <20240725131729.1729103-1-idosch@nvidia.com>
 <20240725131729.1729103-4-idosch@nvidia.com>
 <ZqOh24k4UQUqYLoN@debian>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZqOh24k4UQUqYLoN@debian>
X-ClientProxiedBy: FR4P281CA0346.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f4::10) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DS0PR12MB8366:EE_
X-MS-Office365-Filtering-Correlation-Id: 88dbbb83-2661-418f-c55a-08dcaef9378c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ppn9CC4mjk8HCE35PLgSCYnmmABMKBujp7bk2VM06HE6qLZVaBKX0fzDWevd?=
 =?us-ascii?Q?EDerlPeSLtaPNNJirOZOk1iMFEQgwu6iVpLeQuZu3NWRqShHB+7LxKAathl5?=
 =?us-ascii?Q?qBDV9sIA5gnzjsQh3bie21q4GcyCZYH+uIiVXC0wlDXMa4sQ9LL7OmaXNdsH?=
 =?us-ascii?Q?VQ84a0oBgmgfPfBDqLJb+7W98bqO/kNHTKctq1jKk5Kamc1+j2yIJi9XSBpy?=
 =?us-ascii?Q?fV1xicFZ2bK7Td5Q7XcK1w/WN67yPhwM4L9eEGGDSy6kQ60nSOk+vR4bwcdP?=
 =?us-ascii?Q?hidvIT2boGZyiksp8ONAJ8uJrsJmx3VCKN7x6JabsKS/QKtyBqqGfUxah5Vy?=
 =?us-ascii?Q?5uljMkw0SICmKGlWcrX+sylC/v33g85rQhR6k3P00HHv+iAQmH5qPUe4ObMW?=
 =?us-ascii?Q?Jp6NplyfGIpvCe+clzwOOnVMpz4gPImziNMCBrHgJdnS1lrluT4g8xEHFhzx?=
 =?us-ascii?Q?1OZZtQviCBJJJ/JFvXi729oKdU0RrbCjMqBWKYP7tqOSG7wKb9EXRUVMCaQv?=
 =?us-ascii?Q?wI1uAoOgE0Wej/T664GEJaEoSYHFSOlQlkhkt6IznfNll1i1AtsAbOTxCObv?=
 =?us-ascii?Q?gL5V27AGRKktT8cQgzL8U/o2xRco8C5xIKtnfe5AEmd6q01YemNmIxWumtpm?=
 =?us-ascii?Q?i09hgS8D7HHVqe7XTiw2s9nMditJCCYFuzn3EE0ffAH09NhjqLSoL+jBFrg/?=
 =?us-ascii?Q?KxMRE83S3sEOR3PYGVh98BI1kkxaGDJ8pglN+QmXDsgBGrHXlab7JOn/1nK+?=
 =?us-ascii?Q?uSycp/5kw1ag60InzEgE305QmKGTQNo3kMqI8hOJ2F6iW9yU01OIXxD3YZiZ?=
 =?us-ascii?Q?lcC7fiep8aZo+gYprGmbMxvG/IUdwhgjSTnAq6TSwq7rjkp5zAikLP0q20Eg?=
 =?us-ascii?Q?wmsgnGtLNJy0CJl1bLDTb5bgvpU6YYCBwGKBLrfcBmUHkfkRMjyhW0F99iaq?=
 =?us-ascii?Q?Ql+L01Uy2P2rlw+W1GrAGUCbhw/3uC3fJrEOKyuKQhCO0/Y3LtTVUYR7RS4X?=
 =?us-ascii?Q?s0R4Xn26Sm3LJt/HllRZmYXuvlemQ1JVVFJ5Mwq/vP5zelS+Kg9bYsiipi/2?=
 =?us-ascii?Q?ZD6JvFwRLskV2qSVXZxLgupl1gQmLGx64y+AIxwBxDCgvAybEpzaqM6PBW0i?=
 =?us-ascii?Q?Wh6uAk2hNrIfjYC2jdGRWSF8lDMkmNMMuNnQuS/e4S43WOYV/j5oCLVM1Jwt?=
 =?us-ascii?Q?4UFBp7TVxtK1PeK1f+8+smcutXUfoykKyG8W5b30ut0LuCB0ysyiVXm99lt9?=
 =?us-ascii?Q?+gkhIXZYMMao5v5rQ+Eiv+DWunXp9/NhVmD00nku0e5wbgAU8tp+kLqhSpV9?=
 =?us-ascii?Q?dW5Tp8KA3Hxuvw7W9pU9GYOftkTYmy4ZSmc8fMzfvGrOrQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZooxEU8cFYLFdhAXJf5qN+MufR82hSEpOTwpUd9acQhX76j39DhnIumKrLCr?=
 =?us-ascii?Q?MI46nOZoVgzLLZAJOWs+BU1FSGAjHd1WzdIj4NMoQEofVSJQDD6ewzu3c5uD?=
 =?us-ascii?Q?oWt/hreq3l8S1EhnbJW+dRyZou+8qamW2u9nEJpM0bkqr36eeYXjsr1Iiw7J?=
 =?us-ascii?Q?OsWtbWF8q1sKGVHY0d6n+v/bbsSO8CqCC6OedwBl/fU4vZQ6SMVbNUn4PSl2?=
 =?us-ascii?Q?kfjoNBHtaIxtnjv71Zm2Bq99KDHNFwyXfUSEZBjM09qBDXysul0LHNplDXxo?=
 =?us-ascii?Q?Kuqy3AHzLiPVNhSTIQnEU9lIrYtAqtywedqdqtgVKjNHai9jsTCh1vxAvGCm?=
 =?us-ascii?Q?JuD3a+F6iwerN7JGY3tGeGY4N6/1AVtSoINr2DM3dWuipPBg6hXjsALTcAsD?=
 =?us-ascii?Q?yu2wuZWkShUyzMndm2ANKHCeCGar+uoQ3Dur5tlwsdC+M3ZBbB8uGIldrVu6?=
 =?us-ascii?Q?9TTq6WqZgfhL9OHq9UHRSvp06TkKu0Te9aZXFoIPbRHdNzRu2YoQ8VzSmYDM?=
 =?us-ascii?Q?bImwW26cxpslP/OkKJDd51pMB2bhTdxZqs6IhPEbKYW7MNnB/3LUWmgbnVVS?=
 =?us-ascii?Q?0Xr5G4bBq3r8KzDMmtgiqqsaEvf2xBESTwQ3mY5G8sq/oQCk9kCfxFu8DNks?=
 =?us-ascii?Q?hQ7H0uRFLc5kN/Hk8r8slaohDMtKZoAQskWfQpxn5RyQIhlNJOtNdCWdBxtc?=
 =?us-ascii?Q?gpBqRO5vs8NgWN/VMrmILkHTQLIIOTm9R1pJtA9CpUFb7F5CW6zFHyeFybFi?=
 =?us-ascii?Q?4oLWBWVizb830AaJ7n9ItBLOsvfU7iMp0/VOjqXfjB/T2bZSvLgD1pvnZLdx?=
 =?us-ascii?Q?Y2EpuwR/vTECDfi06B+6cyfXANvCRUQYCsLnbEx1tHXodNsHr73CEaUJvL54?=
 =?us-ascii?Q?lqIo5rZIjWV1/msGd2RzfchFIzj3QomCJ4fd/dsV3fglFd6+CaN+t6PRwS1F?=
 =?us-ascii?Q?vMAFg5MYQBsHQXi+mBRSbwSNB9J3lf9hpP1QfDh/Nq/MK1+2LZZk3b3gajqY?=
 =?us-ascii?Q?0ko+aGwHP9rY78vHUYN8ZSJPtGDEE/18A2cvj+lZsn6haXI9x1p25ZqphffF?=
 =?us-ascii?Q?UOm9B1veSH87kFnLPKdg7NuHbyVfox9lDJgJRC7otM+7SyDFYz0A1OJgrBZ/?=
 =?us-ascii?Q?AKE4Gh+3HcyOIJRE5JxhLZi3rGvw1VPDhcyn6ip7KktSWQbnF/qVmoLzLThy?=
 =?us-ascii?Q?NDPnfJ0ssfGNHTpEU/pqgqlaw189366TzIY73Bpss8YNmM+q04gi+VxSjIFg?=
 =?us-ascii?Q?+GITsZshAIa3I3g+4kJnDEJyiBJi+27oqQb+M1bRpkFH1m+0ETZ1zpADFELF?=
 =?us-ascii?Q?pGfxE/bZEsS3VYTmanx4us0PeF/w8TM+6LD5s7rvGxo1mPPKH8XJhkRxz6iw?=
 =?us-ascii?Q?3Mf2MMgOPqs7QFV/XHGs544nBdZP6fL/Nf8SW9LIbtpQ1fsjuZzdYjazTdIi?=
 =?us-ascii?Q?fzZxhbMJcjShfXcf+2m4bWEnQfDcT29oHkoamZMKORR+hte3lNww1MVaUCm+?=
 =?us-ascii?Q?aPrGqG7c/vY5jbYC95P4ILLu3B11E9Has2oVISsyXYYvDPzfNjSDHrCam/bo?=
 =?us-ascii?Q?hv+UA9bhHtXLwUQOezAhvkQdadpQ3jsjnxG427Wn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88dbbb83-2661-418f-c55a-08dcaef9378c
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2024 11:34:18.2643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1L0gflhrsDYnnpeHEZk6wlVYcYHFAp1Ei4ZGW09xTuwvL70vlJBJflZU8GLKmDRrRirKIA9TfPjbT/NXCD8qHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8366

On Fri, Jul 26, 2024 at 03:17:15PM +0200, Guillaume Nault wrote:
> On Thu, Jul 25, 2024 at 04:17:29PM +0300, Ido Schimmel wrote:
> > diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
> > index 72af2f223e59..967e4dc555fa 100644
> > --- a/include/net/ip_fib.h
> > +++ b/include/net/ip_fib.h
> > @@ -22,6 +22,8 @@
> >  #include <linux/percpu.h>
> >  #include <linux/notifier.h>
> >  #include <linux/refcount.h>
> > +#include <linux/ip.h>
> 
> Why including linux/ip.h? That doesn't seem necessary for this change.

RT_TOS() is defined in linux/in_route.h as ((tos)&IPTOS_TOS_MASK), but
IPTOS_TOS_MASK is defined in liunx/ip.h which is not included by
linux/in_route.h for some reason.

This also works:

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 967e4dc555fa..269ec10f63e4 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -22,7 +22,6 @@
 #include <linux/percpu.h>
 #include <linux/notifier.h>
 #include <linux/refcount.h>
-#include <linux/ip.h>
 #include <linux/in_route.h>
 
 struct fib_config {
diff --git a/include/uapi/linux/in_route.h b/include/uapi/linux/in_route.h
index 0cc2c23b47f8..10bdd7e7107f 100644
--- a/include/uapi/linux/in_route.h
+++ b/include/uapi/linux/in_route.h
@@ -2,6 +2,8 @@
 #ifndef _LINUX_IN_ROUTE_H
 #define _LINUX_IN_ROUTE_H
 
+#include <linux/ip.h>
+
 /* IPv4 routing cache flags */
 
 #define RTCF_DEAD      RTNH_F_DEAD

> 
> Appart from that,
> 
> Reviewed-by: Guillaume Nault <gnault@redhat.com>

Thanks!
