Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B381E379964;
	Fri,  3 Apr 2026 20:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775248863; cv=fail; b=bC4ZZ4G2xHElOAsOzyu4xdDxd6GxXul9uc+SDBvVLZIGKDd7Eo6hDn+TYqoV5UPs962JrO2zonZZcQk+xxbMjgwHBZSoQgHvT4OnYPCxT05s5vHfiy3e+/t+YwnN33Ot3QVaPZazZD+5pCM7TpKQFg1H2FtryjliQIM1T+osMGo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775248863; c=relaxed/simple;
	bh=mEPTBKs4wDOwhTF5V4Uyyv9FzDTmF55NV8MY+Be+lOg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VWmsP46HCUE898D0TPtVSeH5lZTTWD5MLNYgxlRRl2cTmCtLJ3mx3MInE39LHnW4ov0vCCOYxk1xj9vDBSIZtJrKXHUbDv/DBcab3axnUPDqUuzou8ifq/YWYURQQzrKSd+hG5WQfgK0buQtUNI2xvdLfDAhPqerFizWJd906cc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UNbMtA6F; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UNbMtA6F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775248851; x=1806784851;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mEPTBKs4wDOwhTF5V4Uyyv9FzDTmF55NV8MY+Be+lOg=;
  b=UNbMtA6FQdtKmdE9OYMFq5uMlIXwpljtAu+X3HCCS/QptvL6YV9fti/W
   4ny4lxtI2vZyFUhJWTboN6lNp8qmyhzQ8YlpwTW7oEfg3+ebGdSEa85b7
   d3b+1hbYGNLMwHbkCPPLsyLOqZS7DSF767Hia+2QGpYdJVxBtOsuTuXs8
   +EZ0/m60fKbqCIVFmpH0ShT2DGa0nFayQHF/HQzwDOD8WfjXADozBx45L
   iS1yD34WlVOu59ialiZN+v7olUM/8CDZkbd3smPF9M003c3YMdWb0Hsxg
   gsmUXmvXYdC0/h0AR70A/+HMANg9syg5eimAai4ZNuDLLdUAPdAjU1wqg
   A==;
X-CSE-ConnectionGUID: NPhGFSUiRcy0sqCf64qBHA==
X-CSE-MsgGUID: 2P6cSFxDSWadDEFxrKxgNg==
X-IronPort-AV: E=McAfee;i="6800,10657,11748"; a="78907295"
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="78907295"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 13:40:50 -0700
X-CSE-ConnectionGUID: PLSOFDPaSICCIUJbAqHLEg==
X-CSE-MsgGUID: NGmwRsUtQeOdQP8U1pM4wQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="224519923"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 13:40:49 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 3 Apr 2026 13:40:49 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 3 Apr 2026 13:40:49 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.12)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 3 Apr 2026 13:40:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TyUvyQgEfHp4NSJ+hkrxt3YEJCGK+UodXJJ3zVy/il2TvfFuo+iMre+jIkUR89kKT19i03o29z5LaU78sW4rBlYxmz0RH5C4o5TKo7zv/RNO50XYCRmus7Isn8ZrctIhKQIs9kQL2B/uGT4EjVXdzvM4IvkKeNqN0R5QZtZBQlVuUjlp7esJ3kiZXCucnsCelvPqjU4GwxLd4nrmn5A4O+qNX0z83GevEGX45bfHSggpQR2Ndng9dZc0QzDQlL4yBTKoTtfkxZr3vUI9h4l/FsV2zCV4i9kw8lGcYK7YN9AU57JY3KlsyPXAlfWP8Go2ne+OuuU+cORRQQlgvfYiLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gLhhjceXIojTJ1qZ+qkXvoKyRYDpSTe+hwJKOFx3+ys=;
 b=bNmjdUsE11cGvgiASQknrfZVvrqxE8G89V3IRd9e78MdN5XQ64WdM9GkmTpBLo6rHRWwiAmr+r8DOo1OS7MDg1EyJ10ukTkGbrzGLoYygtZTjB9hL4H+yKnEOzYlI0PlbCIn6n1Wz9rx3xqXaKnUcnlNYpmLYeE2pHKb3h8S93IseZ6vcO43584JduTiK1qwO43G9/DAHp1PaQQVd3yv/kzA6HAJIHhKLcrzaXXIbZEXJM2f4mlns8Sr4IQ9iFiWsec2W6V5H0/T+JZIhNYhUIWmj32JvTDXz8YUNbIxt9u2EtsI/Hzjcf6G7djf5zTjNgc1ZGva0JtnnAJuvbBmZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7579.namprd11.prod.outlook.com (2603:10b6:8:14d::5) by
 DS0PR11MB7903.namprd11.prod.outlook.com (2603:10b6:8:f7::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17; Fri, 3 Apr 2026 20:40:47 +0000
Received: from DS0PR11MB7579.namprd11.prod.outlook.com
 ([fe80::4199:4cb5:cf88:e79e]) by DS0PR11MB7579.namprd11.prod.outlook.com
 ([fe80::4199:4cb5:cf88:e79e%5]) with mapi id 15.20.9769.020; Fri, 3 Apr 2026
 20:40:47 +0000
Message-ID: <4002b93b-fc1b-4b8f-ad49-ecb9c258afd3@intel.com>
Date: Fri, 3 Apr 2026 13:40:45 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] netfilter: xt_HL: add pr_fmt, drop NULL checks, add
 checkentry validation
To: Marino Dzalto <marino.dzalto@gmail.com>, <pablo@netfilter.org>,
	<fw@strlen.de>
CC: <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20260403200320.90449-1-marino.dzalto@gmail.com>
From: Jacob Keller <jacob.e.keller@intel.com>
Content-Language: en-US
In-Reply-To: <20260403200320.90449-1-marino.dzalto@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR06CA0001.namprd06.prod.outlook.com
 (2603:10b6:303:2a::6) To DS0PR11MB7579.namprd11.prod.outlook.com
 (2603:10b6:8:14d::5)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7579:EE_|DS0PR11MB7903:EE_
X-MS-Office365-Filtering-Correlation-Id: a6498297-f6d0-4c5f-cee0-08de91c148b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info: bLDBbdBw9R4Fr5alnGtvSyQCNeMYTxI8W2ib09UkWDsH1UdAkY0mZrU1t/iGOTNJZGF76UhPNUDFTzh4XhgcT3LXlWLOHikMq7KcFMDKDT011OReC4i9N7LIUDROnPN3Q2ivxJ7aeBQP6vHzg0xJUVmufMt67KJ/cA7j/str/CaoEXjmMWz72SA99QrRBtKxvG7J/tbZsFbYB4/0oDLuVQ7p/E987kwuScsNL/iklTf1Q5eTJYIHNtJdZgUZKKqDBZDh2FgSNaH66HsXZK1mJ5v9aOAnLzET0pX8Jm0hjqu4VO1VtUvICwd3rfiOGUWZEnKFiddfexfqs1vCpY7yCoL5wK/0neWKljx+A9VLrgZLYpY1f+zFtb+cyzCzxln2lvlizA6wTOg11VdlkEUfGIjfsALdjsxLm3SYS+na0kauWA+/1+Y8pBQhoWqiUwwRA2WYJEgsG0//2X82HBbIvYMsr3I/Ky8ep3NFBOLWwk8zjppb7xcjVw2poOF4X3z7M6QCTrZYUBmkcsDdf5Slmqi9FtVF78pJcbBsZaLO/O4wZpVp+JsmE7ImDHWFGelSftozRLg4b/6sShHKwtcEFuKjqozI9ABfVsQKw3AEDfHy1TScc4iQ1GPoSBXVnFfScqFciq5Wh7K3gR4jHL/kkzE3IaB6zwsI3OPn5gKsTXTNLKQQukBJSCKPnlEoOc29sFbh3HMc54nRHB5w+/etPSkJ9xrPWyTuueVktDab7ZY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7579.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SWh3Y2tuamhWc1pkM25helMvTExUelB6SnNjdHlNNkNaT0l0TDVDaVBwS2Y3?=
 =?utf-8?B?YjZ1Q0o1anh0aW1xd1pEc29hSzFXTDRHRzBsSUNUdkUzTWFBTjZrTXRmRkUr?=
 =?utf-8?B?S25vQjVhZzdacnRrYWI1NjFBdU51dGtFNzg5WWU0T2svYWhCTkgwdGNMNUdi?=
 =?utf-8?B?TGxSQ2ZtdldvcjhWaW1LYkpIbU5TVEdPdlhxb2ZTd3FVZ250UUN5ME9hVlRz?=
 =?utf-8?B?MXJ2bmtrRlJXcmpDMVd0Y0k4WDNmVTBtcUIyaWZTcUxLN0MrSlFuOWszaFBP?=
 =?utf-8?B?ZXhObXgwQ0ZibGdWclZMVXpMcEFBWnJqZVRqdmo1eFh6bkJwZDFtTCtPenFt?=
 =?utf-8?B?cHorZEJtUEZOWEdrZFNLOHF2VkFZeE84bFJhMS9SQmEvVTd0dHM2b2pjaWZQ?=
 =?utf-8?B?YlJFMUkwdG5kTlIzTW1KV05idWNQMDJJenBGcUw2RTJLUEZGM1hicGFKeFFS?=
 =?utf-8?B?RXVPS1hxNDRxQmNBWDNFcjFYTDBaVTliQzZERDBtT2l1dDBnMVZJVmg5c01u?=
 =?utf-8?B?TVJkUFJTSHcrMURZMzJYYmxWdGRieHlBdWZ6N1IzQUxEK2drdy9GTGtrTzlF?=
 =?utf-8?B?U2E5cEt3blMvNzNzZ0dJWGdBbU5NclRvNUhFVFZ6OC9scWgzZWNvcUtlaW1Z?=
 =?utf-8?B?dDY2MC9meEl5MVhvNmFuUmFMdXlZTyt2ZjIza1FVQUFyNS9JeFZRWkYxTEtM?=
 =?utf-8?B?SUhOR2FLYmhiMFgwb0FUWXR6eVoxRmNydGJTTjg0S0lCTVJzVnNSRkIrc3Ir?=
 =?utf-8?B?SzRHblNiYlhUcklBMWwwNDZoUHdqd2JqY05iWG9jTEdVUkFmbTVaaExSQmVo?=
 =?utf-8?B?Q1V4cEkzTFpvcVhYaUNteFR5MloxeitESWZwb2pkaklNeU5mVlhWb2xINUhm?=
 =?utf-8?B?MmhvVHhwNVlWL1dwcmxwL1NHMGo2anF4cVAvSXo0bTNrRmhTbjY5UmRWT092?=
 =?utf-8?B?eVFJMXp1RTRldWg0UFB1N2RSRGFIek5senIzdjdHNld3a0p1bGJSTmdKVEIv?=
 =?utf-8?B?WnRERUlvcGZ3SnNENmdlZHREa1paWE56QkQ1U1dQeEJDeGlOTTczVURYM3Q2?=
 =?utf-8?B?UkIxMXF2VFAzTzVKeTNUNzNtaXpiSGx6UEppSG00YWJwOEJxNE9LNVJrTkVl?=
 =?utf-8?B?d0JDbXQrS1Q3Y3FQeTNhL1djMW1tekVIdklCRy93eFhkVTVqbU53NWJXRy9M?=
 =?utf-8?B?TGh0a282K0ppczhLcGVDejU5RU15cG5uMXIrZUVOT0ZzSjNnREE1eXJmMUt5?=
 =?utf-8?B?TlpTK3N6ZEk4Y2ZCc3VkYUorZVdvdUwyUGt6S2RMbTNsM3drdmxJemljdjJY?=
 =?utf-8?B?bnRPbjRLTTMwRS83S01EN0tvTU83ci9wYkJPeGc0dHdvV3liS0hQbE1qV0cz?=
 =?utf-8?B?RmlEZkRpZWRUeUdzcVdJVm14dG1RV3BCeDZ1MnJxSlAwSTRXQUliM2Ziamd0?=
 =?utf-8?B?RkpRUlI4ajUrTk82MUhZUHg4WDA3MXFLakxYSE13cHRBRTQzay9sV0U1b1V0?=
 =?utf-8?B?eDZOZDdETXRrUXVlUTJEa2ZSVEgzejVhMHg0a2NTOXJDaDdnV2ZPNEt3OHR1?=
 =?utf-8?B?MVI3Z3NxL1htV1hOY3FINmdXTFlpU2UwM3p2NFdBTTFQdVNEZWszUGp0Zmox?=
 =?utf-8?B?OVZlNll6NDdYMzYybjBJdGQyY1pxeHEweE9zTTV2YkoyZDJLaXVoOVRMcXpk?=
 =?utf-8?B?cHI3Z3N6L205bVJOSE9TaEZZbytIOEhSWG40c0NsbUpHM2FWaGtVWUdJaFd1?=
 =?utf-8?B?dHltVURzWmNpU2gwTGhiazRLbGFCWjdNT0tQUnc2WUthenh5eThSRDJMNThW?=
 =?utf-8?B?YTBVcW5ZdTBVTG96WVdINE9zOFBVcWZ1eWZoK24vdkpVendLdCtZVVdaTW1w?=
 =?utf-8?B?c0xOeU8xd2hBSlJzdGJ0K2lZQkVXL0hqTm5iTXNLVVk4emM2cTJFT3dNb1pI?=
 =?utf-8?B?ajVhWDlFc3ZaVTBJUm56VFc1eVRZU3YxdnRtMmNHTnZheEp4WVVBRzdwRW1B?=
 =?utf-8?B?bUlKZFV6SEpJQXcwK1pFWGlpaEJGOCt0SnVEMk9UT1d4anE4NHZZUTFPTnIz?=
 =?utf-8?B?SnowbDIrMlRlRDIvUnFIcGdVOUJGVFBMU3l3Yjh4dnRaSUNIV0Y1dmV2cVZm?=
 =?utf-8?B?TFh6OXpsNGdrV0VSZzhUb1M0N29FL1BkM3N3NXZQMTBkd1JuWHFmU2hnaFhy?=
 =?utf-8?B?YTVRQjMwWXhDMDFmQjN4MmJ6V1ZLWGtsbXh5TUd4YjJCZGd2ZXJESUFWL3dh?=
 =?utf-8?B?SkRZWmJZWXlRNi9SdDBxeXY0MWlpWUdrTVozQ0RuRmlHNHBYWThpTnc3UVV2?=
 =?utf-8?B?ay9YczlTS0E5ZzBRN0I5dlRjK0x3TXhvYkRqd1F4L3hBYllMbWN3a2NzZ1lP?=
 =?utf-8?Q?hkont9NGpDKTz7ag=3D?=
X-Exchange-RoutingPolicyChecked: fdNWLmwGWxuBhGrQn4YnIo1++L5KC6oTs+Z1yqWPedtEweNGUCpg1IrdRHUPBem0plde6wIZ04GH0cw8ojmCpHONSjX7DmYanstON8ETjaDCu+yv0rBRiOsYce6OtEJ+6IpdJmmnYfs8u5cQb1Kaa5CCZ1c9lC9smMFo8loaVlbniIReF6rrNK/DywSVl46jkncUjPftuZH6tiYaX/s/ZXjd1n+jxUWuUXXr7rYFP20CL4ozBB0ZA20TEXOHa/fHl/T1c02kOdbIZotXVkq4r0FQCExIFTvgT/QUlCm8z43ZH/9HkGrqJ1u4cLCOyd1WAkC7Sy2LsWQeS1bp5YpDHg==
X-MS-Exchange-CrossTenant-Network-Message-Id: a6498297-f6d0-4c5f-cee0-08de91c148b5
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7579.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2026 20:40:46.8926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CHxx5bYd3LEz0+pkCiwmeOWGRvMFQCJsCRMbzM6UImBWMiB+n3FFjj3079c8nNd5B5mteDEm0Z+m5v2ceauRUYcii4jb80S2hWXIXQENR7A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7903
X-OriginatorOrg: intel.com

On 4/3/2026 1:03 PM, Marino Dzalto wrote:
> Add pr_fmt for module-prefixed log messages. Remove unnecessary NULL
> checks for skb, as netfilter core guarantees skb is non-NULL. Add
> checkentry functions to validate match mode at rule registration time.
> 

The patch is small so I guess its not a huge deal, but this feels like 3
patches in a trench coat to me. The pr_fmt makes sense to combine, and
the actual patch content just appears to be implementing the .checkentry
callbacks. Seems like this description could use a little update.

> Signed-off-by: Marino Dzalto <marino.dzalto@gmail.com>
> ---
>  net/netfilter/xt_hl.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 

The patch also says it removes unnecessary NULL checks. But how is that
even possible when there are no removal lines in the diff? Is that a
leftover from the previous version?

Thanks,
Jake
