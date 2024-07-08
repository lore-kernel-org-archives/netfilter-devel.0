Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AECAD5A
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Jul 2024 06:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720421114; cv=fail; b=JCdA1idM2pJL1/S84xuHfXVIzJrnZb1CJO8qSAJRyl10QCxtykc9K52JYSP9xzb4sSwlFd/boU9dlQavcJy81op09EXf0Vts71IHOFUhs+zpy8I+Hau/8h9WhfwwVHfUDMjkoZGqSjbHZ7+uAvKO4TdyxHz0xY2oyj8KPWSk1k4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720421114; c=relaxed/simple;
	bh=clhvGt4K14IQK3JZTYX5lcLH4aFC9G5t8U0PHPtQZ+s=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=C8cXRP3FOpDrrTFbT2N7DMX+lficrjUnVBOjzSMou5VMmSVDxmOaiw2LAXw+1lYhUTy6frPm2r0548md4z90t5lGEh1bTU5nO+MRKCoG21FoHGGemqvsy8ODw+KuZ/47YfY957jObSHVfNY9+NZtK1IZNZ8h+Q2qyxKS14qo5xc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YXTr1HKv; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YXTr1HKv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720421111; x=1751957111;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=clhvGt4K14IQK3JZTYX5lcLH4aFC9G5t8U0PHPtQZ+s=;
  b=YXTr1HKv74YEBFIruDoww6gXmqSBsAwUdQJbvx8V1xl4wCubZeeSUxqk
   CeSIbEV92ZJI6e+yHJMuJnRmruvoD/0onvzA/etymEkQuhs50LPKx7Kh1
   1oJLYy/seAX4xkICmX0s+ywWFka/RF4GKld0B/SQN9fJr0CI/QSn+GMKt
   GYywc7t9Bgyo4q8OkbpT275czR6FvHSS1DxncfGpiFZeqtW/OAeC8+pVz
   YHQyJAg0Y2s0HnnGKmXy91jH9TbTPAvRt4sVa+kfONbe9TKvYchINi5yr
   T4q+NNB30yIPgbwCRpA9pELfxmf8oz/r9OexS8fFDvZLKwfBI5fxD78Ol
   g==;
X-CSE-ConnectionGUID: 7LPV31p1Tx6rQz34ww68hA==
X-CSE-MsgGUID: SenIHuOwTea1DwRpmCoopA==
X-IronPort-AV: E=McAfee;i="6700,10204,11126"; a="40115132"
X-IronPort-AV: E=Sophos;i="6.09,191,1716274800"; 
   d="scan'208";a="40115132"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2024 23:45:11 -0700
X-CSE-ConnectionGUID: T/vomWOCRyK5NLA0Xr1HEw==
X-CSE-MsgGUID: IPKAggOGRD63r8g3V2ciuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,191,1716274800"; 
   d="scan'208";a="47293015"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Jul 2024 23:45:11 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 7 Jul 2024 23:45:10 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 7 Jul 2024 23:45:10 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 7 Jul 2024 23:45:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aY9V5rTsFcqDXx5zwmGaULcdPpk7z8DG/RUwXbVGtKRJWWnjoNaw7R1Pux3z1mFXThNYqZR4e+zcDxKUA+B/kFmUF8rQYTvK9N4XtS41ow00HSZMjE2TPvjix38pcLANf1oH3WHnf915rI8HNxCMPO7d7Z8hacsop+/lBNO9+0+VQlKqFW2hJKhP/TiAsuxuN6MuMDwgV9Qzgu/GQTjjNiBxeVfMPIOni0wARQ3z+zy0HJcO7pO0In63edq1vo7pOj+9NLUEKXoAngsywqX2KV0lMrcWFxdI0q2GmwFf6KuFNKOVWw3R1oGYzmXISv3cxpL8sSFI4YSHoGR52nTDnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o5MQW/UA8pOqGz9NITElafh9/GVdYWu1ufIT72NPdxE=;
 b=PmV4CPH0Fq84syEsnBeR4QrriIdaHMjElD2DLo2pNqRWpLeAZRJXKL/cIUPDijM5NGKhxnadQdz1H15AgydMFXU5YpIGjwW5WkzVJulJSJjpn6r5EiflVVH9D4mIOx8zf5mwU64MN1zrCCgLLmSbQ2UJMFGm1CK/w6YmTmVfzEJC7tEqpXtPF08wGVwWaeUfy7moD3hVsMQnF78mT1wYR+q3tS4PnMWC/OwOVzU7PrPGreFHK2Jrhy6QygGK24Dm0VNb2IdBwRTYiRg8vnxofsi9uehyyQ4rJ/2XURvs97+QPNtyBcn/KqcZGip30BN3aea++FfBmLHwHpCAam6F6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by SN7PR11MB6948.namprd11.prod.outlook.com (2603:10b6:806:2ab::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.29; Mon, 8 Jul
 2024 06:45:07 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%4]) with mapi id 15.20.7741.033; Mon, 8 Jul 2024
 06:45:07 +0000
Date: Mon, 8 Jul 2024 14:44:57 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Florian Westphal <fw@strlen.de>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Linux Memory Management List
	<linux-mm@kvack.org>, Pablo Neira Ayuso <pablo@netfilter.org>,
	<netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
	<oliver.sang@intel.com>
Subject: [linux-next:master] [selftests]  742ad979f5:
 WARNING:at_net/netfilter/nfnetlink_queue.c:#nf_reinject[nfnetlink_queue]
Message-ID: <202407081453.11ac0f63-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SI1PR02CA0027.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::18) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|SN7PR11MB6948:EE_
X-MS-Office365-Filtering-Correlation-Id: dac4044c-be56-43df-5331-08dc9f19815f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?3DCMLTHGuniGGZXky7UtS108loDimLDWeon91jS6Aos2wcdYHzMv1f/FgdPb?=
 =?us-ascii?Q?+FuvNmZ8NAhTQFUxewbDNckhDyOemQD3I13IMDRtorI7UBIJ4SjGm1NYPSfD?=
 =?us-ascii?Q?+5HjoitizTlPJcwkYRE0uOFBi03RJO9MkwesJoYLgH4lfBPsXce3pFeTt7cU?=
 =?us-ascii?Q?31k7T4wIYCEGR38f9orjAJk60LJPhLsxbtdOT5CCBnvZcg+oBfoDTpWbjJRL?=
 =?us-ascii?Q?z1nG0X/XDw/2/g8/34sZmVDwElsbh+vqj4eXBWZB4++Wv+HdWpKeIM5iZtWS?=
 =?us-ascii?Q?gblLwVAfQx9MYNfLq/xFD862biOuotFRxY6lEgvpJW7FDLQLR9eEY1hiV+HQ?=
 =?us-ascii?Q?zqm7ddi4DMgd7jC1KDD6JMN12DBLxmnil9Jms7Rw1vcpc79Yo5ks4TWzaTrS?=
 =?us-ascii?Q?i0wajIRNEG9rh/RamLeQt3TtXP5VG+lN5oeFc7kxaw2rA3W5yYfe9jMhLyV8?=
 =?us-ascii?Q?n18DPBNR2II1alY5tGhmbkidvyFBGX96ZSJiiKRtCW2o3l0Vf5mKl000w5Eq?=
 =?us-ascii?Q?aeIjiWL42peYcASWOU2OEWlSNQ0dqfZXXw3y+zBjSLeeN7gTXu0qkkqUn4Nc?=
 =?us-ascii?Q?UUPm49sDEYAXHsOec22S4HRJcJ6tBL15b4jZOP/w4J/dUOqRxtrUIfdgvIy7?=
 =?us-ascii?Q?0p0itphePCj2quGHxgy0ii+ujR0xsigHmunaRdz+dO45SrOq1n+ZtuGqJJF0?=
 =?us-ascii?Q?vJsHN6dpczQEmITDRLwf9vudqic4PffCBh9FxgUEA0MSeAoe1MDWdQ3ayw9E?=
 =?us-ascii?Q?Bq8o+rKnYLFf9Hq35X8OzNMasDh6WBDXO/Y5Y81J+PNMXpAZrURpqvdEsypZ?=
 =?us-ascii?Q?/kuBLyF472lllfn8WYBl2jYy/cTd4eIzVm8YldzrXAiKKWSMAr31ndRBFGKP?=
 =?us-ascii?Q?TtPjmsfU5XHQpOvYyux80wqvsZos1RXiWwhzSvLx9HV8NF7oWZc1H/kWtSQi?=
 =?us-ascii?Q?ShVorJFZy9UD6zjN5wpktU+YdRDSUHF3EOADX52M1ksSDxHgMd4BcSzHJlGl?=
 =?us-ascii?Q?hsG1YOYkPwMppcOliuDX/I7vJfMWvfiQVL3WaIzAZ06A9hz42MwuaLXJvPmr?=
 =?us-ascii?Q?noVdmCrhuj2nzdNbHACziftE/ysG15FRHzlTEOL0GTPoFndDXWPuhEiTvtww?=
 =?us-ascii?Q?UAeqjbpkH9Wqg+/QI6VIiqsVARPq09t/DC9pYVagmtzvr7hW2DuzKAKWy+Zj?=
 =?us-ascii?Q?IH7a27Tf+AKXwgKJ5ojD12qSYhOMbtZqjR2wYYzNkcM+m3bmP4cQ0cauj3V5?=
 =?us-ascii?Q?qRMVVhKhDQS2Pq59GLoee/oxANShMa7r4SpxO/7Dhi1FpbJXIwxKsLuhOz8a?=
 =?us-ascii?Q?q1nlx/JJ67IDpLSds5JwcDS9?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ngDveycXTcJZoyl8xuCi6AR5Fa2p7JVqfkBPxee2KQ8GD7rGDUTa8iXK7BKs?=
 =?us-ascii?Q?2LcVrb8nL3PBoMViPkhoKmVDni4n1fbLA1lepcs+sMhD4QlKu8zauXLMxYS8?=
 =?us-ascii?Q?7Z/gFtpzua/CGwi7m2uzgnxQth37djCqE6kvFqFNVL3c7F38ObQ3R528x/M+?=
 =?us-ascii?Q?Nj/zKkxWn3ycF4edlBiNWy1FmbD4+dI0CzTT6CiLfjyt831bmWV7FlT+wlTe?=
 =?us-ascii?Q?HhVhlLDWO/Xilb4jmclZW4813WN6Ma2RBko1BvTxIxqm+FneUp6MGSciY62W?=
 =?us-ascii?Q?OhCJ2+rBZB2ijhnfpqJ87rHpROSFDiwr1ffEyUd3ivIcqTzSuxjA7C857mRM?=
 =?us-ascii?Q?DSQmTwj3kVwfBKNdkVK7O3zLnOz6tQAk8TKwKtvLZLKJCjIOhNQ6+cz6EaPD?=
 =?us-ascii?Q?lpjiWdi+wU8QPB+a6i657fnWq3vcMn3Qg27mGpbwllt/c9MF+Lwy+O3aql50?=
 =?us-ascii?Q?RmHRPra0NpO6b4tKtDith1QIWdE6c43yeQa5JLP0jh1q6LRxx9Mql4zMXf/K?=
 =?us-ascii?Q?NaL8BuXkPCVI+sfkcXct39ROxIGllZ0iqo3CP1uZ+Nb99CZ3xNuBaA/TbD8i?=
 =?us-ascii?Q?jBvVjkBOpGJL3ZhKxMc1809HORVuNjsyuPwhko9i8pSjCv8NErWxU0t7ko1d?=
 =?us-ascii?Q?vFoDQZ2ie69LGbBxnz3hTI7f8MXa67D8xtlew1aFNVUfwbROi8eML5aQeC+l?=
 =?us-ascii?Q?3Yha4BzQDzxOQcr1eAsM8P8umDrEgRgVoGsurJ+EJO/L3/wD34JXnoNp8ujF?=
 =?us-ascii?Q?Me8OJjT9NXDVJ9qON05L4MK6GZMSMbrI+49SIkgOoumE+Xzm43klpT51JLXI?=
 =?us-ascii?Q?1UdbqPUexnAVYAiim4gkAvQ4k8dqNO9BiatQtjualJ/VNK9Vx8D6IqAhS1jJ?=
 =?us-ascii?Q?OnK+Hh27k/gGMr25yj2S859qYMnGtdRkPJl7G8sDDL2+FYiJSO3IrgCJb+8v?=
 =?us-ascii?Q?aZgMFkkOfAwUpZKdm8s6mR2P1shXIXrVcQxtzhYNxS5tLepXvVKVl7fXA/4P?=
 =?us-ascii?Q?UNbrbgj+KIsRFBOmTY/ZSpsp0mM1iccY0XZfLICmcvxRw9A+JO9VG4uhhBKy?=
 =?us-ascii?Q?ypGqRwVM/8Iem8zfvrYgKjtN0f408FnscRGjegNIVrsDSJcF1E++xEMe8oIz?=
 =?us-ascii?Q?krxLy8hXPhJ07g3KokCd8RhNdtTawHaD8Qea7rC0QcQ4CUrO326paorTDGj9?=
 =?us-ascii?Q?x0zW51YEQ9VyEX4BrUcUaCPm0D+uyLlY2wZBm5dEl73ww1yAFipyIrUgklCh?=
 =?us-ascii?Q?T10FsZX4SUhCYX6QekIvUnSik1ykX+TwqodaoxrEzTnQbTySuv118XYLSDVF?=
 =?us-ascii?Q?01gG8JCCbCmPSKYr3zgEtc2Xci3QfLjYTHjt7JCXeM5Z+7bKSRWpXDBWyvAm?=
 =?us-ascii?Q?bwxiIQWW3RyNtE9gpFen4X+4kveZvcBHcoOaTRmWvGcVEStRhKqM3H6jQICk?=
 =?us-ascii?Q?W81KpXFXkYVdc2jSf3G4+u8N5mY//rVd6Pzo1Oer9+Ft/W+LWo3S7kAfb3sC?=
 =?us-ascii?Q?eHf5cttf3HdKzuAQFufR985FIfEzw+N3jldaj9Xyo4+G+1BFZMUg4ydXLX0U?=
 =?us-ascii?Q?oDwYdGhsahCFklyMkW+XBGLqryZEi3SAW4VQw2WwDekIqcyv5C/rdOp7oELc?=
 =?us-ascii?Q?BA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dac4044c-be56-43df-5331-08dc9f19815f
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2024 06:45:07.6248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uQxWAYq7TR4IRL1xX7+cPkH2sZZoOsI7budeXIyJMGREA/X/vKPhncefuhxzVcWCULTCiitTKK+gQXa9f965HA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6948
X-OriginatorOrg: intel.com



Hello,


we observed new added test seems introduce WARNING. just FYI.


kernel test robot noticed "WARNING:at_net/netfilter/nfnetlink_queue.c:#nf_reinject[nfnetlink_queue]" on:

commit: 742ad979f500c7707258b368c413c7215af09ed5 ("selftests: netfilter: nft_queue.sh: add test for disappearing listener")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[test failed on linux-next/master 0b58e108042b0ed28a71cd7edf5175999955b233]

in testcase: kernel-selftests-bpf
version: 
with following parameters:

	group: net/netfilter
	test: nft_queue.sh



compiler: gcc-13
test machine: 36 threads 1 sockets Intel(R) Core(TM) i9-10980XE CPU @ 3.00GHz (Cascade Lake) with 32G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202407081453.11ac0f63-lkp@intel.com



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20240708/202407081453.11ac0f63-lkp@intel.com



kern  :warn  : [   61.767119] ------------[ cut here ]------------
kern  :warn  : [   61.767679] WARNING: CPU: 1 PID: 26 at net/netfilter/nfnetlink_queue.c:328 nf_reinject+0x3d/0x210 [nfnetlink_queue]
kern  :warn  : [   61.768721] Modules linked in: nft_limit tcp_diag inet_diag nfnetlink_queue nft_queue nf_tables veth nfnetlink netconsole openvswitch nf_conncount nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ipmi_devintf ipmi_msghandler binfmt_misc intel_rapl_msr intel_rapl_common btrfs nfit libnvdimm blake2b_generic x86_pkg_temp_thermal xor intel_powerclamp zstd_compress coretemp kvm_intel kvm raid6_pq libcrc32c crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel sha512_ssse3 rapl intel_cstate ahci nvme libahci nvme_core wmi_bmof intel_wmi_thunderbolt libata mxm_wmi mei_me intel_uncore t10_pi mei ioatdma crc64_rocksoft_generic wdat_wdt crc64_rocksoft crc64 dca wmi drm dm_mod fuse ip_tables x_tables sch_fq_codel
kern  :warn  : [   61.774467] CPU: 1 PID: 26 Comm: ksoftirqd/1 Tainted: G S                 6.10.0-rc4-00927-g742ad979f500 #1
kern  :warn  : [   61.775495] Hardware name: Gigabyte Technology Co., Ltd. X299 UD4 Pro/X299 UD4 Pro-CF, BIOS F8a 04/27/2021
kern  :warn  : [   61.776446] RIP: 0010:nf_reinject+0x3d/0x210 [nfnetlink_queue]
kern  :warn  : [   61.777065] Code: 57 31 48 89 fb 48 8b 6f 10 48 8b 77 50 0f b6 47 30 80 fa 07 0f 84 a5 00 00 00 80 fa 0a 74 2e 80 fa 02 0f 84 a4 00 00 00 0f 0b <0f> 0b ba 08 00 00 00 48 89 ee 31 ff e8 92 9e 07 c1 48 89 df 5b 5d
kern  :warn  : [   61.778808] RSP: 0018:ffffc9000028fd28 EFLAGS: 00010246
kern  :warn  : [   61.779377] RAX: 0000000000000002 RBX: ffff888890380d00 RCX: 0000000000000000
kern  :warn  : [   61.780116] RDX: 0000000000000002 RSI: ffff888850215640 RDI: ffff888890380d00
kern  :warn  : [   61.780852] RBP: ffff888889861f00 R08: ffff888896b6ca00 R09: 0000000000000013
kern  :warn  : [   61.781621] R10: 8000000000000163 R11: 000ffffffffff000 R12: 0000000000000000
kern  :warn  : [   61.782361] R13: 0000000000000002 R14: ffff88889f2cb8a0 R15: ffff888890380d00
kern  :warn  : [   61.783100] FS:  0000000000000000(0000) GS:ffff88889ec80000(0000) knlGS:0000000000000000
kern  :warn  : [   61.783916] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kern  :warn  : [   61.784553] CR2: 00007f18b9947000 CR3: 000000089d022005 CR4: 00000000003706f0
kern  :warn  : [   61.785305] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
kern  :warn  : [   61.786035] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
kern  :warn  : [   61.786770] Call Trace:
kern  :warn  : [   61.787104]  <TASK>
kern  :warn  : [   61.787409]  ? __warn+0x80/0x120
kern  :warn  : [   61.787808]  ? nf_reinject+0x3d/0x210 [nfnetlink_queue]
kern  :warn  : [   61.788399]  ? report_bug+0x164/0x190
kern  :warn  : [   61.788834]  ? handle_bug+0x3a/0x70
kern  :warn  : [   61.789256]  ? exc_invalid_op+0x17/0x70
kern  :warn  : [   61.789701]  ? asm_exc_invalid_op+0x1a/0x20
kern  :warn  : [   61.790180]  ? nf_reinject+0x3d/0x210 [nfnetlink_queue]
kern  :warn  : [   61.790739]  nfqnl_flush+0xc3/0xf0 [nfnetlink_queue]
kern  :warn  : [   61.791282]  instance_destroy_rcu+0x1f/0x40 [nfnetlink_queue]
kern  :warn  : [   61.791884]  rcu_do_batch+0x1af/0x550
kern  :warn  : [   61.792321]  ? rcu_do_batch+0x14f/0x550
kern  :warn  : [   61.792766]  rcu_core+0x189/0x460
kern  :warn  : [   61.793174]  handle_softirqs+0xe2/0x2e0
kern  :warn  : [   61.793622]  ? smpboot_thread_fn+0x25/0x1f0
kern  :warn  : [   61.794100]  ? smpboot_thread_fn+0x25/0x1f0
kern  :warn  : [   61.794585]  ? __pfx_smpboot_thread_fn+0x10/0x10
kern  :warn  : [   61.796064]  run_ksoftirqd+0x25/0x40
kern  :warn  : [   61.796501]  smpboot_thread_fn+0xef/0x1f0
kern  :warn  : [   61.796957]  kthread+0xdd/0x110
kern  :warn  : [   61.797348]  ? __pfx_kthread+0x10/0x10
kern  :warn  : [   61.797782]  ret_from_fork+0x31/0x50
kern  :warn  : [   61.798209]  ? __pfx_kthread+0x10/0x10
kern  :warn  : [   61.798644]  ret_from_fork_asm+0x1a/0x30
kern  :warn  : [   61.799101]  </TASK>
kern  :warn  : [   61.799407] ---[ end trace 0000000000000000 ]---
user  :notice: [   61.836290] ok 1 selftests: net/netfilter: nft_queue.sh



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

