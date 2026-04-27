Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802583D1711
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2026 14:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777298864; cv=fail; b=dE7VXO+mCv+vwTGBM7Y1ItMaaWs9oUAL1XR0hqeHWXPrXm+CMTWPoCXANy4uTqezR7Ikym11fMEwyt9vBQKiRug+zLlIx6eSEvbLqQgmthWrQhw4I+/FOOJL4DwuUuSTu/is9FyZb9fCzRBviJSH7dvAxAdFzgoOUMiiYEseVyc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777298864; c=relaxed/simple;
	bh=JLrftSsYUWakLxSI63wumJc0dJ80izpWHjubjGl6IQc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VvzgSKkWf9jNg6Trqh2XYkh22PCi0oDEXoFcFhH4/lAvMzTGwUYjsD3Z5iVrMi9hRzNG/O+5TtvT6a6rWQQu0dn5GCFbNhgrymPCWoUrWtY97snQYYWMQ1onB6yRHd3RzDUGlXxLyKV6HSszi0owChRZampR+F6ETP57z56Z6Og=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JWoh91sf; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JWoh91sf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777298861; x=1808834861;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=JLrftSsYUWakLxSI63wumJc0dJ80izpWHjubjGl6IQc=;
  b=JWoh91sfTX8fJ3mvO6TMbqq35YCA3VsrRlng+C4OZOfdsVd+aARWvSgU
   wdO27afa4r5xIH6j9KsX4cGQ+RJSGK07OMGfxIs5X7Yt0vXLktW2Pc2oW
   EINrEjfycreH0sIV5J9uI1YUcI5nbApeaFVIhVlyj0Fy2YTyOJFRv4ord
   BIUVaoJNN3qMHUOm3HFXJd/kEXwdIkJb69crpR+G/XX42mhpnq9tDrhFJ
   AgRauLb6XOVrJhWleVpSq3I0VmoZYuv8NBIz2qvr5/AtJdNL6RTX9iP2y
   43BMWJHQ5bfyX5E1w+Rw1h262pGsxdak+seE+JzF8ygMvgZs7t3dk7Cgs
   A==;
X-CSE-ConnectionGUID: 3C+pmBvVSvayWqMfajQ5Lw==
X-CSE-MsgGUID: NMos2sjWSySyBmM6pGvNBw==
X-IronPort-AV: E=McAfee;i="6800,10657,11769"; a="88880382"
X-IronPort-AV: E=Sophos;i="6.23,202,1770624000"; 
   d="scan'208";a="88880382"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2026 07:07:40 -0700
X-CSE-ConnectionGUID: N5ZZ2p4RSxiz+FBIQXpfHw==
X-CSE-MsgGUID: 1D9iJZOnQZ+SQROwu0qXRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,202,1770624000"; 
   d="scan'208";a="237978071"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2026 07:07:40 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 27 Apr 2026 07:07:39 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 27 Apr 2026 07:07:39 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.52) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 27 Apr 2026 07:07:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a2WhhARRMlZktWtdEJU0BVBSi5cVXrPx1cjmURcIHLCWSTY8ZdRdHGv7VMPvWIwzi4mybtfJ2ECutytKhDrhaOuKxcu7JfcqxyV5MYZn65T41zI7O+df0t7fwdaKnld7PKemjyI/Wyo4i770UP8Hv13yEwkzuqBbEnLUAdEDhgBzdWMsmbuvqRNCNgDopbAby4llsuNavFXf1FPS92YW3H6EQsRZGFQBanEcO2voxpkGJHwZlyBEbjFeaJKz6c7qBf7tyc0BHAnUXxmMC7Sj9aZ3iT0pWPnJByRQceUEUnc4ERNNdqx+rHy39j5Hvvi5Sq8c5QN/uq2XLN0l4NwS2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9G1ECtl9JX78t8fv1A5RzEmk4xABKqPt9dam8XerH5M=;
 b=D2qaO4xe8ZzaoeUGhxT4ryC2qQJDspbuAWD2q4CUpd4MmlqgVk4G+lT5R2I0VVcrPP1n0tutLxfL7r0srEwfHATUT8RIMhNjrIcsIrapq4t9IlFamKWFP1FH/T74o6Orc9xy7ql4vuneWL3weJUbakxIONikUjimQvubrPhcLIMtWtyJYkhzfwfp+pFN2QQQK+bTLQ2Atv1slHM9xKddMSyRGoqe8HTJ49lXMUrotW+B8/ux8jXdiEhhlbeou9GylYge2bmOEZ5/BDma1e/jsH858FyRh8lBAA0nwuD1hiw2g/bLRPxYibDCrjHrgw4gI+jB+dGEXlF/x5+syMfZGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH0PR11MB5428.namprd11.prod.outlook.com (2603:10b6:610:d3::19)
 by SA1PR11MB5947.namprd11.prod.outlook.com (2603:10b6:806:23b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.16; Mon, 27 Apr
 2026 14:07:36 +0000
Received: from CH0PR11MB5428.namprd11.prod.outlook.com
 ([fe80::b8c4:d29:c56:a2da]) by CH0PR11MB5428.namprd11.prod.outlook.com
 ([fe80::b8c4:d29:c56:a2da%4]) with mapi id 15.20.9870.013; Mon, 27 Apr 2026
 14:07:36 +0000
Date: Mon, 27 Apr 2026 22:07:25 +0800
From: Philip Li <philip.li@intel.com>
To: Florian Westphal <fw@strlen.de>
CC: Fernando Fernandez Mancera <fmancera@suse.de>, kernel test robot
	<lkp@intel.com>, <netfilter-devel@vger.kernel.org>,
	<oe-kbuild-all@lists.linux.dev>, <coreteam@netfilter.org>, <phil@nwl.cc>,
	<pablo@netfilter.org>
Subject: Re: [PATCH nf-next v5] netfilter: nf_tables: add math expression
 support
Message-ID: <ae9tnbKGr3bFitGh@rli9-mobl>
References: <20260421155859.7049-2-fmancera@suse.de>
 <202604261140.gX71SoJp-lkp@intel.com>
 <e6315242-d34d-4a9a-824e-c9ebf0b03c83@suse.de>
 <ae8ZM32SuUg2PTwV@strlen.de>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ae8ZM32SuUg2PTwV@strlen.de>
X-ClientProxiedBy: SG2PR04CA0156.apcprd04.prod.outlook.com (2603:1096:4::18)
 To CH0PR11MB5428.namprd11.prod.outlook.com (2603:10b6:610:d3::19)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5428:EE_|SA1PR11MB5947:EE_
X-MS-Office365-Filtering-Correlation-Id: 65d15938-5770-41c2-672f-08dea46654f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: Jlf9yBaprJqhGdxZQE97PdWbKMSxZGPQHCVdkZanOvZ+C9MFvpUgs3i0CdUYxmIS9Qf5hefE57VO/8vaeA8wZKvPYD8k/QqPsq6tAYbFglUBO93ghrp1roytiH8aaLfqsvI+jwxBIZvNKc35kQe1D8LOzN4BohHoB6hQm9esLQvVm0SfvN1RJTSAOyBLmlFyT34+pss3GVhgkmVhz9CP0E7ZNqs+TCVIW2jixI19O65+AFrcGZS0GtRsJZdzYmBaC3Tfbn6o4qB9uwvSSX8dWod/8BNtAvm87Gf8fX5gWZUqc7ORnYLuayCWZ2N3V1KQ3FcB8xV6cveEPDgPOIKFu/QKkVtbbzVKr9ixCGxQXNQpE4Ec1bbnzXVhE+I1eiitoD3CRd69SLS+lkBehUsbyck32dtDeY5EvNeSTJOTjyJC38zvioMXH33Wbglit8C881UtW/QIwisg/kJmos0mSJqaNKB8ItKegrvPZvL3IISZ5Zua6QoYooS4n4Sp5xlMAJyGR4JD3soLg9MNmDm1H1R5pMdcSWygx21hMvD+jZXPTAX47C4h2I7W96MSFJnQphz7+f8zkSZnTeF+PMoI2LvKCHAx1/EDBJcXILgxBSqGnR6qB9NMjaFeL0z9DORCUjYqkFyk3zYV9CcKgc4Nt9m+/Mg8kljSHB+8bu3aLF9tmRUU6zQhIWDtTkQcyWKSugaXZvlfzqeu4FHR6TmeeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5428.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1s0sBL/vSXHeO1rX6jrFGMttgcTFY2IiyNWRUdmPFZtVfL6Yxn1bZtX/cEao?=
 =?us-ascii?Q?mpFujXpbJtht1cgx2/ZfqXDTyGH9N0Aj1hzZy0eA5gPXq4rU+PmprELQK/gx?=
 =?us-ascii?Q?iyyM8wGujfc0MSFaMSrnyfP8mxrR0EU/ehiKTXrJ2q44WBM9vVU3gCNZmqLD?=
 =?us-ascii?Q?x/mY5wGDf8SILc84gk40SY1flXtFPrT6Ph1oVq1aJ366/nBQoH+MWEZC/CBJ?=
 =?us-ascii?Q?iNcidazFqjf89ZZWO3gxRSVIFJ/yOdMEjNeRhD92x76QyloVfAZgoqHUA7OT?=
 =?us-ascii?Q?dVP+Z/yJeWG9HT+yNVLgwkKPHKIjyB0G30ZaU1yN/7LH4otexULWkTVnWnpW?=
 =?us-ascii?Q?sKrfiBji8DoP+bbrS85Y7drmMkpeTFGJ0dKL4whbX7kwvZKUigToxIgE31em?=
 =?us-ascii?Q?ZpvvjSbqzx8DcZmJCZMwdSHpX/4RiesUorTdnpglqZf3CVuwkLWJ+V+0ay1b?=
 =?us-ascii?Q?MWQGaTSjUjxb2Tt5Q7RRtRZoS0JcnpLW6vGikKUmLJc1oMfrRm4iQTMhScdc?=
 =?us-ascii?Q?EqqCDGuDZ8aXRt6fYTDDlxut3DjmRgEns+HYmLWy4mEAkGikYd/AA3X38Ywc?=
 =?us-ascii?Q?MiXEHEfSY0e5ElbRqdsn/oSMKgPutmUmsqJBaxLLr8ZOiyBBmQDLWEZKcTU8?=
 =?us-ascii?Q?9sRzTuRkpV8iYcEnOQ1A6nsJx3lRGgt8greKb1haVrexCHKqZ/5D3Z2p/o3L?=
 =?us-ascii?Q?WYK3c1dtN7IfN2s+ClxVLnlD/go7CoEE4bCZaEeZiugaXzducd22V0zd+X2o?=
 =?us-ascii?Q?3n9NCpNLr5ZzFrnKRGEK/QoGibzAxMKcnQTcJhqMXfkfwcx623yfAP31s4DP?=
 =?us-ascii?Q?SQfvR/mxTQ0l3noQMclCz7EBvnnby5zkQG7xG55KrOnNPy5y3sifvf8WOInB?=
 =?us-ascii?Q?yTdtogxctvbtj9hKq2z9djsXrT8si+/I0VvQ95KqD0lik5vepmCVssHcUxMS?=
 =?us-ascii?Q?pzarcQHBH1dymnYg4YoFNZvbrgxbJMlN4rlPoDnA8z78fwQLsHvJYK/j0TpS?=
 =?us-ascii?Q?CqSl7MS1BqvegRmh8ryCVh19pWT5bdP4g57Sbf+V1Uqr1Y8zG3/3QJT855B/?=
 =?us-ascii?Q?4YNIfvsGhpyncXUZ0ddaZ6HF9d3xTPLXmGa5Wkfe6Wb5oAy3XVHiyp3BWedA?=
 =?us-ascii?Q?vDdyvZdzqyPqrZlJ8GrRoA7EdCZPdgA8bGJzG62i/33bQPFsVtK7cF2ZUl5F?=
 =?us-ascii?Q?flq/f6Xts85fGLdEe1mD416/hC1/+fXR+rki67zc1Qh+EOr4UYytajtJQ1oK?=
 =?us-ascii?Q?jsyx2uYMt2vdniGQ+bwb67Ll5iG+5mSkrsgVVEQL4CVN/MSyUXrqQOanrVDo?=
 =?us-ascii?Q?skPmA+BG9HUcRIkszNRRGxz9m1MNcEXc9SLHs5xdKO9kcX2XEVdVUVM+SVar?=
 =?us-ascii?Q?5w9zLtD51LIzhN2PhA5BQBiGxvn6enJ7a59LYjsUsWfb2nI9HxQVQTA2bVWY?=
 =?us-ascii?Q?Td/qVad5jhLKiiVht45vzzNYFHbrb8+3OjcbaQ5T8GQ4v0OOnFnUaWaBsR+P?=
 =?us-ascii?Q?VX+DDRsn6V9ON0RWi/RRXisfelM/2/Xsd9eeo/HBTxbbjvBm7NQE1ag5b/y2?=
 =?us-ascii?Q?oFAxNhTPxq6/fy93FOjG7/KkU+5xbB6lMn6cVbIccCGKGB/uTkjfyCfSbfv0?=
 =?us-ascii?Q?dGl0HCkOWySMRs+oKuP3/hPbZyY6q+OrpmInwJNt+kZTf7co+gf7wn2cHvv6?=
 =?us-ascii?Q?vod4dw5rNfV5DM4QmCglSSLygUcsAWDh0V74FygYxzuTSpdnolzdQgLCJXQ4?=
 =?us-ascii?Q?nyg1hrEFHg=3D=3D?=
X-Exchange-RoutingPolicyChecked: rHnM+vSihkMuLA9ly7YWPiH2KX3gbEy1VHxmG+9LO3ruEVpPZFVJcpM/giHK2AIgdVkAATgkewrzciFTP71XSIXPaaJgWGdtzeW36Zk8ev0iNtSDX3dYhKxgXtopaz4R93H0PaapgQdzBPm8CCpIrMt/LhDrbr4DWjlcQKLb2TjpCMh5p84wud/EYnKVK9lrWrf52PgOAEvjk26qcmU1q1QEPU2N441UZBavJKmkH6YnDMuUtaKbzFvACM+ILwP8fdJew7bPYIEfjAef/2ojId+O50uJdD+11wte7Eq8H+PlkaSDIjNAhF+Pow/0qEV1kef7jK0vtw3A9m0FVm+dhA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 65d15938-5770-41c2-672f-08dea46654f7
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5428.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 14:07:36.0151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d56gixprVA2HQKyCagbd4DQrCQO8gB1Ea3Pw+jTogj23FiuE6oAFj6h4B1bLvrfPl07OtQKPO2XF4feFA+SthA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5947
X-OriginatorOrg: intel.com

On Mon, Apr 27, 2026 at 10:07:22AM +0200, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> > On 4/26/26 5:57 AM, kernel test robot wrote:
> > > Hi Fernando,
> > > 
> > > kernel test robot noticed the following build errors:
> > > 
> > > [auto build test ERROR on nf-next/master]
> > > 
> > > url:    https://github.com/intel-lab-lkp/linux/commits/Fernando-Fernandez-Mancera/netfilter-nf_tables-add-math-expression-support/20260424-055358
> > > base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git master
>                                                                                   ~~~~~~
> 
> 
> > > | Reported-by: kernel test robot <lkp@intel.com>
> > > | Closes: https://lore.kernel.org/oe-kbuild-all/202604261140.gX71SoJp-lkp@intel.com/
> > > 
> > 
> > I am completely lost here. How is this happening? I do not see any of 
> > these errors locally with W=1.
> 
> Sure, you use main, not master. I'll remove master from the repository,
> hopefully that will stop future reports like this.

Sorry for the wrong report, this is the issue of the bot, the base candidate is configured
as master. Now i have corrected it to be main branch.

> 
> > What? But I see:
> > 
> > int nft_parse_register_load(const struct nft_ctx *ctx,
> >                              const struct nlattr *attr, u8 *sreg, u32 len);
> > 
> > Is this a bogus report?
> 
> Yes, wrong branch.
> 
