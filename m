Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6DC215F56;
	Thu,  9 Jan 2025 10:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736418196; cv=fail; b=Bm+Di6NPNLgJggXrkAKqXTg7LqjcnkKdR+THbdUuDBFmECN4+56Wur3MKeLs1B3wDjld2GOYrDiSbz8bnmEiUpElT6Tg+tetbd7RcODwt5eCai8Lqk7f93uo0klCY2l8OXxZZH3uK6apM+peWoum6gS8QUzIYpiLmtlI4+wv+Cc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736418196; c=relaxed/simple;
	bh=6k7zF4TqmtvOadYJX3NEAUXArl+ZqAjioMApR72IESw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OGBPFbVPpCx4lu9pLBDWlDy/+ehUN04jQdW0GQjDygI/LgsCfhgnZ21ltm9CkXIN9r+59yB+c55Lvp71gV0vwckTlPY6IMyMVL+NoxG0RPI0+HSbutIHwo+36a8iofiVyrmDWgsuvhher057XnWisA2j8RuQUKEYjkfaelupzfs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jSvfl3ol; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jSvfl3ol"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736418195; x=1767954195;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6k7zF4TqmtvOadYJX3NEAUXArl+ZqAjioMApR72IESw=;
  b=jSvfl3olBnU+D2z5Wd78JJYTuSfZYHDceiENsZgAXarQdBxpU+SQTanV
   UkPnP4dWYDt7Naa51C4AMTV6ZtmhOWD/O2PicQ3XMrkxcii2HPhIQpLa4
   eWJE5eFseQdFZ8ieeveOABXzt1VVWrYm9QKTsAtj084P6bViFBrYCVjSZ
   UcE1vYkllYMHO+M5LaeuyHslyU8rEuob3hFKgDNRilBFkO6ovKt+lZmNu
   wIkwVabwV57ifksxdUl1aEDppxXyN2L4u1k8F64Tk6KonqN0bghpN4lmo
   uZV9qsaVcuS1lSsw3rENRVf0BubloSV1+EYoOCF7qtWLCUaBRt3EWECGQ
   A==;
X-CSE-ConnectionGUID: X51suhlgShGBv5Bf1Ec4qw==
X-CSE-MsgGUID: Tv9ZLzTFT/ajiomR4pRKQQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11309"; a="36571927"
X-IronPort-AV: E=Sophos;i="6.12,301,1728975600"; 
   d="scan'208";a="36571927"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2025 02:23:14 -0800
X-CSE-ConnectionGUID: NQn9uUSiSfyfx4LlaC8D2g==
X-CSE-MsgGUID: Iz7UYXBiQTWX86xHafpPEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,301,1728975600"; 
   d="scan'208";a="103172088"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Jan 2025 02:23:13 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 9 Jan 2025 02:23:12 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 9 Jan 2025 02:23:12 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 9 Jan 2025 02:23:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MC7VyOpGLcH6UzH6U8UFRAV4nTArH0WTF2EEbilkQLqRtQPRPKiA6S3LGoHziLXOGWS6JOog4X7Q//tFVVu3utlexhzFVrqt1S9lcxxLxfqfFc8iz6XXTeQfqkxJCWNexEWNqgAYLkcNyuvwAjnfzq+yLQxmeXhcp9jlNrviPOlnpPRNUd4u0bq9Rp9JUcgRkd8iAIJjYXnc1b7Jiiq8lW7nKpFYZ4JgiLywxnNuUn0AFiZBTIC93ahuGuNqQ4NZiN/qGOsgwv71uIhzByivdtEhMhX9ryWD6f8okc4c93xkz1AJI6W4Iwf5BVN5xbYwsU4bV8QBXXVVekgAWG90ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wxp+aF2GBm7HdITNkHNXtUTtQhXW/KV2yo5nOHFFU3E=;
 b=lxWZ6f5VozWHupHTxu9UTfSZwweME10kcl5/0QPuSbJcDuBMQizJW9sDV3LsuBAa7V+GwAdp1xHDPYWZtEaK4ux5ix9RGtEiHnkJHvN7uPicjCX6eObGFVu3j8Ik5hvaDn25+FDq1EFOZULuirqVhwjX6hLEP6vHgZKJZiDtcRkIhiXuOtqb11gx3xYua8vqDLUCauG+zY1aoocenSsUSs28FYIGfZWO2V+7BSIGKZMKM6evlcb3ZYzfQ71wOO5LwTvpfX/ieWle+v+q2dhshpah2yP0C+tAF3pu1M6S+RGK1vq7dSx6c+l7URw2Nj/YrlgwYvtGMYlCCLcmsSf69g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN6PR11MB8102.namprd11.prod.outlook.com (2603:10b6:208:46d::9)
 by SN7PR11MB8111.namprd11.prod.outlook.com (2603:10b6:806:2e9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.18; Thu, 9 Jan
 2025 10:22:57 +0000
Received: from MN6PR11MB8102.namprd11.prod.outlook.com
 ([fe80::15b2:ee05:2ae7:cfd6]) by MN6PR11MB8102.namprd11.prod.outlook.com
 ([fe80::15b2:ee05:2ae7:cfd6%6]) with mapi id 15.20.8335.011; Thu, 9 Jan 2025
 10:22:56 +0000
Message-ID: <33fe32ae-44aa-433d-a77f-bb75e8957842@intel.com>
Date: Thu, 9 Jan 2025 11:22:49 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/10] netfilter: Add message pragma for deprecated
 xt_*.h, ipt_*.h.
To: =?UTF-8?Q?Sz=C5=91ke_Benjamin?= <egyszeregy@freemail.hu>, Jozsef Kadlecsik
	<kadlec@netfilter.org>
CC: <fw@strlen.de>, <pablo@netfilter.org>, <lorenzo@kernel.org>,
	<daniel@iogearbox.net>, <leitao@debian.org>, <amiculas@cisco.com>,
	<davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <horms@kernel.org>,
	<netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
	<linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20250107024120.98288-1-egyszeregy@freemail.hu>
 <20250107024120.98288-10-egyszeregy@freemail.hu>
 <1cd443f7-df1e-20cf-cfe8-f38ac72491e4@netfilter.org>
 <0e51464d-301d-4b48-ad38-ca04ff7d9151@freemail.hu>
 <2b9c44e0-4527-db29-4e5e-b7ddd41bda8d@netfilter.org>
 <8d25e36a-b598-4b18-896c-d0dcb7233800@freemail.hu>
From: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Content-Language: en-US
In-Reply-To: <8d25e36a-b598-4b18-896c-d0dcb7233800@freemail.hu>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR04CA0097.eurprd04.prod.outlook.com
 (2603:10a6:803:64::32) To MN6PR11MB8102.namprd11.prod.outlook.com
 (2603:10b6:208:46d::9)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN6PR11MB8102:EE_|SN7PR11MB8111:EE_
X-MS-Office365-Filtering-Correlation-Id: 21f065c4-ca11-4861-a87f-08dd309795af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RHlaL3lvbWROcjVwN2pSMVhZVmlzQlF0TmdyekRwQ0VlQzdnNEZEY1Z3SUdn?=
 =?utf-8?B?RFUxaEI4cGM3bXg1MENvcmVpM25oVVBJenRDTmN3cDRQRW90aTJ5bVVqZ2lL?=
 =?utf-8?B?dnMyT1RJdVY2V1VCcjFLQ2paSjdyUXRwbm5uRXdWaWJEVHpIVDRsNDlUSjRW?=
 =?utf-8?B?aVZDUGNDelN0T3k2TW1KZ09Sd2x2aGFqM3EwNTV6RDlYNldMZGFnNDVRK2FM?=
 =?utf-8?B?ck45OHIzUTFzR3piSEl0d1F1NnRpNFFlaWE0L1FEcXo0Nm1LV1MzMExRS3Fw?=
 =?utf-8?B?OHNiZ0czR0lINVVFUXdON1hSMUlKOTBUek1KUXZ5NUpHVG0zUGgyMkZKeVg4?=
 =?utf-8?B?UjFUWjhYbnM4akNseDZHcTdYQzFuOERFclJYcFdSeW11N01PQy92SFNzTXRu?=
 =?utf-8?B?S3JwUjFXU0diV0szOFFLSjduWWQyT1M3eDVSTTNJL1huNGRHL3llWkRjN3ov?=
 =?utf-8?B?V3J1U2JTS0ZPbC96Vi9iUzZ3aGlrM0xjQzlLdlB5S25kQzY4UEtGTW9PVTc2?=
 =?utf-8?B?Q05lRGx2YW1RQk1kcUhXSUYrQUNZMDVOaEp0YVY5UTYwUzZWZ2NIUC9uQWxr?=
 =?utf-8?B?U1BMdWkwVklETDlFazNmalgxMUZqdmRtcyt1UnlYc0hWUlJzdDlUOEVTQUI1?=
 =?utf-8?B?bzZxaC9mUXNuZCsyOG1aaXNCOEw0L0RoNmpBeWxxUVY5UVJQeloxTEd1dXI1?=
 =?utf-8?B?clFxL0dGTmZ0enpvYWl0eVAybngwTEtlT3ByY1lkekFUTkdpRFJ6N3RlMjUy?=
 =?utf-8?B?VUFpR3d1aVRIcWVMYzhJRHMzcFo0Z0FUU0c1aVFkK0JMM0VhUjc1aHRDNUFQ?=
 =?utf-8?B?N1I3YjlrOVlNdm5KWGFWdlgwckFucWNvbXB3QktMMFBtZTZJMEoxREU2YVBi?=
 =?utf-8?B?NnBUVjhHSFJqQ0lhM014aDhnTjkxRDdtbjZmNDlFcXA1QVpFUkpEa0dIV2tQ?=
 =?utf-8?B?amhPS045SFVnWnc0N3N4Qzd0RHJWcStxb3RlOFR6V2pFUUFORVJ2Z0xHWHhi?=
 =?utf-8?B?dWJoVmZsOE8rZDUvUEhnSEpNUEFsenFLekZDZ3FNUFQ3OWFxbytrMkZITy8z?=
 =?utf-8?B?dHQ4dHdrdm1uc3NFVlJGeFpLb0tyNjVlTkVPaTZvZi9TRmI3eC9OWEZHVjU0?=
 =?utf-8?B?MEJNM0VqWFFJeVZCTjlJdFZ3b1dmTTUvL082U0V4Y1JZY0tFQ3JnYkk4UENx?=
 =?utf-8?B?bTh3dmJjTlNnSzdZaTdJbzZZTXBxZTNCaHBZQmtCRHlCdFVJV1VSQnRXb1hn?=
 =?utf-8?B?NXBMTWhWaURnclVDS0dKN1haY2QwSWN2Y2M4dkljYTlkakVWamRLODZwUFFB?=
 =?utf-8?B?NTF2ODYyS0YvaEwzeTFUQ2NnNW5LUHhIeGZwOExlL1hEYStNQld6WTJyZ0x2?=
 =?utf-8?B?d2ZMVnNGQVhGWThMa1kwL3o3V0d3Q3hRL3h4bVNaWFUzWGdoMUkwSXVleWRR?=
 =?utf-8?B?VXFFUzBiVm92T3VSUmJGRFlMQnpNNzFtK3I4MG1FeW5jSHhoeXk3QTZ5Zk1i?=
 =?utf-8?B?RlV0T3RQQTVROW1BWFVzL25OM25EYWlPc2xUdkdiY2xOQ2NSQXRSeHVBditD?=
 =?utf-8?B?Tis4S3M1Z09YSDZjOEVnOEhxNmg1dFo3VEtNdE9rMjlJRnRXVnhsbXVQczlT?=
 =?utf-8?B?L3NFWkhSWlpJL2RJTWFiYWFJZ1U5c0NzZGJaTGRQd01EZTQ4S1d1SE0zU2Mx?=
 =?utf-8?B?ei84cS9DZFdQa3NMZWRQK1RET3M3V2RLWGJtRjM3SHNLQXFvNXdnSUVpcmlv?=
 =?utf-8?B?WnlLKzJ1MU41c25mcHV2aWNoQWc3ZjFhMGRqSGIzOUZRMWhYYVNFTk9rMVJY?=
 =?utf-8?B?OXdpVUZ6VGFoUko4VWtMT05jOEMyWHRVekY2RFN3emxlWnBhUTNWcEdpQVlD?=
 =?utf-8?Q?f5lFycLt28Jhn?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN6PR11MB8102.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dDUxY25QbVdDUm45UktCc3pNV2RrcHAxZVUxTHdLd3F2R3hEMmFJQWlxdW5Y?=
 =?utf-8?B?cUtsQ1RpeStrTG1sVEhTVE04aDRMS3FiWHE2VHhPY3JhUE5KWkc5WkhIMzhj?=
 =?utf-8?B?b0REYnltVGtZbStqZjlxKzM2Q0I5WEhaMW9lUmNDVGZvT2E1VElpVmhqK2oz?=
 =?utf-8?B?QmJoWE1ETmxNd0VnRDhvWnVwaGFrNnVobjd3Z3Y2RkNiV2daN2FHZklHK1My?=
 =?utf-8?B?aDc5bFdwM2F6dVZHYTI0UDU4MUZuT3ZEYWIzMVpEMjhHZFp1ZTBUWklMMUdZ?=
 =?utf-8?B?cE1jZWR5YnVub2lXTWdZYlZQb2szeFltWjZUcWhtQ0haUGhWNmk0ZGdqd3VK?=
 =?utf-8?B?bDF1YThUa0I0eTNhaGU2YlY3YnJoMDc2WEZWMHhzclJDQUkyTHRWU3NLd2ZU?=
 =?utf-8?B?dG1IZEYyL3orVUw0VGNDRElOQjdpVzBvdUtsdVJtTEhRa0ZodnVia1M0U0JT?=
 =?utf-8?B?RzNGanVkQkZhVTArSGhaMGhscFpnUEhOZUMvUzRmQkRnMEMrRkFmdE9CcGw5?=
 =?utf-8?B?NFNLYmZZOUJZcHFmVkExZEJyTVR3ZVdZRDdqMUNDaDhlNnRzU2ZKWHJhcTU4?=
 =?utf-8?B?Y0VBNk80U1V4MXVYVzRla3dWTWNOSHY0ZVhFaElFZW83dTJpNjVvem9VdWVu?=
 =?utf-8?B?S2hJa2VyTnFsYXlrZEtHK1lBdFBibWJUQXZXYWhkZGlWRU1HM1U3ZGdFVnNJ?=
 =?utf-8?B?K1hoeVNaaXVIeFpXOUxvU0dnb05sOHhJR2xsT0ZKZzJuRDEweGFKcjF0UTFo?=
 =?utf-8?B?SGMvZVh4Q0N3NU1qTnA1VFZyZzd5cjFZVG54MlBKVVhpSmh0azUvSEVLb010?=
 =?utf-8?B?aEJwMTFZSFhxUVZMNEo3cDhybTZ2UHpPelpzYklwTEhzQUNMSHhXTzN2Q0RC?=
 =?utf-8?B?T2ZQUzNXYThDTkFyWDh5OE93dWtaeml0YSsyNzV0RUNCSEZ1WHNSUm9vVURs?=
 =?utf-8?B?aFZ3aVk2NWI2WkdGSFR0V0NSZFBzSldzWkRTZElmcmY5bGpiYlhOWjUxZ1l1?=
 =?utf-8?B?WU1nQ05Wd3V1c2JDbFNzTDJTdkpqWWxIRXQzci9weE1lSXQvOWhhVnhDSEFB?=
 =?utf-8?B?ejJZTDNvejBrTXplU3dsWGFSM09sbVFMbjYyQmx4aU14cjM3UmdoNTFRQzBH?=
 =?utf-8?B?NXZiR3lEUlRkUWNOS0xTSEtHYnlOY3RjQ0J2cHRwL1BpR1poeCtKWUdVMHFM?=
 =?utf-8?B?RC84enN3K2tNY1ZyQitheVlQa0dBR2JXU3pCN3JTeWdjR1hmL25XaHI3dlB1?=
 =?utf-8?B?RlA4dlM0MGVxNmxtUS9JbFpNTFdyanNROE9kVEpseEsvT0F3MWZvaWVmd3h1?=
 =?utf-8?B?SnQrTVVmSWFzRzN3T1RYbW9KbnA2NGxPNzVQcDU2a1Y0NXh2MDgyeXp1V2Rw?=
 =?utf-8?B?MCtTTmlkajlPN1NLOVhzNjh3eE05Rml2K0xLcHB1cUtoRVBNeGdSTmYyRUti?=
 =?utf-8?B?cnovaStuZHhTZlo5SEIrS1d5d1Y5Qno3Z1FhNk43N1NLUENuRnh5L21zQWE4?=
 =?utf-8?B?YTREbHNqTEFnQmVsL3VBV2htU1QvQ1YydHgyQWdLekcyVzE2Uk10d1FOd0tW?=
 =?utf-8?B?UzRYVS9WZ0hNSnhsS3NLWnpFeGVhb1RpNStFV2crbkhYUG5HZmNJV3JyZTRr?=
 =?utf-8?B?cWpGZmtpbXdMK2dtV0NyZnh6Mk5RUzNZK3pRME8rMkNYcVphVDlUNVZ5MHhS?=
 =?utf-8?B?WGdraW5vdG9wZXhUS1hoVndnN1I2bm5BYmEyRTZPa1YyMk5UcE9vYVNjWGhu?=
 =?utf-8?B?SUxnQmUrcXhvRU9IMWxGdUNRVi81SC9jalRjK0xOWWZDekIxUDMrSjh4bW5H?=
 =?utf-8?B?VjVlbU90VmtTUmVXRVlWdFlKaWYrMm9KT285Y3FydzVEeDdUN0hGYVBtdlMy?=
 =?utf-8?B?NjA1TG9ZNHI1MnhuL3grZFdTRy9aWXBWcGxmNzVtR1NYZ0dCa3ljNllZVzZO?=
 =?utf-8?B?TXdZZW1BZ2pLbGREQ2FpUkErcTVpMjlDSk96VDRMbmhYYnliYUVpOUdMclRI?=
 =?utf-8?B?ZVNabnExdU5rcUExdDB3TkJDNGFtR1dFZjg0Yno0Y3prejhLUk56NUVMM0Fs?=
 =?utf-8?B?QmdpV2dLU1RqWFd6UHJJNEVobzZzK1dtUUhHbWg2ckdnUjdLakhOQTlkNVRR?=
 =?utf-8?B?S3U5S1dIRDd6MkxLVnFFSmxydTFyQmgxZjRxWi81QWREWFRHNWhoeng2cVBo?=
 =?utf-8?B?K0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 21f065c4-ca11-4861-a87f-08dd309795af
X-MS-Exchange-CrossTenant-AuthSource: MN6PR11MB8102.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2025 10:22:56.7702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cr13diC17isGkGHPt46S9smNkchs1EyT97wKZTDXQLRqjYYIioE9+qa/c5GEESvm9YSgSJncAY6HmnpnOdQqJjSj2BYcOVuAt2UcsNpYH4U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8111
X-OriginatorOrg: intel.com

On 1/8/25 22:38, Szőke Benjamin wrote:
> 2025. 01. 08. 21:51 keltezéssel, Jozsef Kadlecsik írta:
>> On Tue, 7 Jan 2025, Szőke Benjamin wrote:
>>
>>> 2025. 01. 07. 20:39 keltezéssel, Jozsef Kadlecsik írta:
>>>> On Tue, 7 Jan 2025, egyszeregy@freemail.hu wrote:
>>>>
>>>>> From: Benjamin Szőke <egyszeregy@freemail.hu>
>>>>>
>>>>> Display information about deprecated xt_*.h, ipt_*.h files
>>>>> at compile time. Recommended to use header files with
>>>>> lowercase name format in the future.
>>>>
>>>> I still don't know whether adding the pragmas to notify about header
>>>> file deprecation is a good idea.
>>>
>>> Do you have any other ideas how can you display this information to the
>>> users/customers, that it is time to stop using the uppercase header
>>> files then they shall to use its merged lowercase named files instead in
>>> their userspace SW?
>>
>> Honestly, I don't know. What about Jan's clever idea of having the
>> clashing filenames with identical content, i.e.
>>
>> ipt_ttl.h:
>> #ifndef _IPT_TTL_H
>> #define _IPT_TTL_H
>> #include <linux/netfilter_ipv4/ipt_ttl_common.h>
>> #endif _IPT_TTL_H
>>
>> ipt_TTL.h:
>> #ifndef _IPT_TTL_H
>> #define _IPT_TTL_H
>> #include <linux/netfilter_ipv4/ipt_ttl_common.h>
>> #endif _IPT_TTL_H
>>
>> Would cloning such a repo on a case-insensitive filesystem produce errors
>> or would work just fine?
>>
> 
> What is this suggestion, in ipt_ttl.h and ipt_TTL.h really? How it can 
> solve and provide in compile or run-time information for the users about 
> the recomendded changes? (It seems to me that you are completely 
> misunderstanding the purpose of this message at this time.)

likely the uppercased names will be with us forever

> 
> 
> Listen carefully, this are the points/scope.
> 
> This patchset provide the following:
> - 1. Merge upper and lowercase named haeder files in UAPI netfilter.
> - 2. Merge upper and lowercase named source files in UAPI netfilter. 
> (uppercase named files can be removed)
> - 3. Keep the backward compatibility, there is no any breaking API 
> changes yet.
> - 4. Keep uppercase header files as just a "wrapper" for include same 
> lowercase header files.
> - 5. Provide a clear message for the UAPI's users that in the future 
> should have to use the lowercase named files instead.

6. lot's of drama too.

Please remember to add a proper versioning to your next revision, also
target to net-next.

> 
> Later, for example when Linux kernel goes to 7.0 version, uppercase 
> header files can be removed. Breaking API possibble when version of a SW 
> is incremented in major field. Before, in first patchset, UAPI users 

that would be correct for "semantic versioning", not used by the kernel

> were informed about what is better to use. So it can be a clear and slow 
> roadmap to solve case-insensitive filesystem issue on this files.
> 
> 
>> Best regards,
>> Jozsef
> 
> 

