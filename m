Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A83152504;
	Fri, 14 Jun 2024 07:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718351091; cv=fail; b=qom35qYrc6TuKy01ERbk5oudG5LyyG3N86GTDjagX72VJZVcYGnSlPaJdPpR0J8N4F5vA+ZNpJnMXqLisa+518iULxSvG8L39iTC5tHF7KTPxI4e0tcMBkw0G6iuOQnqBSj4A9mHBl2iKn0o59ku55/JXWxBRGM8g/5IroOKBmc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718351091; c=relaxed/simple;
	bh=genisvNqYBo9kTXEb9ovkgHn67nrGqqU9rYZPAbH/LU=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=YwOpMPd5tLuWGygyy4P+C7NPUcYzPus46zJqt81JVJZyZpXP8GnLCdrFVFrpfN9BuS2AEINlvuCyTcWYXxSKUt967j9rsgG/GfHcguoxgYaxfvcCDhTuu92uPA7NT6muQyWa90U0vXuNmuK8qS6unk/SNElmvxG0dEh1XjBoZQw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E7jYULN6; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E7jYULN6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718351090; x=1749887090;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=genisvNqYBo9kTXEb9ovkgHn67nrGqqU9rYZPAbH/LU=;
  b=E7jYULN6gNJVj2L12ZCo62X40i1OHPt8xzkPoHGG5j4Ux6j2gVTPyIwk
   ub6w8rSgD70lGswuvBPoDJAgZX+GTHF77rDnjo80S0hgPPbXrkJVH/PKl
   gdgNjvHnc7jonVkrqrX0zk7GBpFL1/JGSLlBwfkZbgE/OTnP1/ef+77X9
   6dcGjw9GfyBU0x7sBZVohiNfyVz5oLed+BYATXXbrK6nDGNc1d2DAreSQ
   PWACVR6w/Jz9aWNXSvNP8wTKgepAWXUKzS3SSBMc0c5vrltZ7K5wZ6mrv
   7UNN8zQHAF76GZWv9APyaittmUOWhojVboVzTtCSvjmAGsfKRlUpeNVfy
   w==;
X-CSE-ConnectionGUID: /htR4x88RiCtom9VWlCZnA==
X-CSE-MsgGUID: 0u6YJKxjTNiUshZEWMPvQw==
X-IronPort-AV: E=McAfee;i="6700,10204,11102"; a="15454624"
X-IronPort-AV: E=Sophos;i="6.08,237,1712646000"; 
   d="scan'208";a="15454624"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2024 00:44:49 -0700
X-CSE-ConnectionGUID: rW1pxjOHQ+Kj3+oYogXd6Q==
X-CSE-MsgGUID: 8zc2vdRZRCuvYL/YdNl4hg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,237,1712646000"; 
   d="scan'208";a="63622767"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Jun 2024 00:44:49 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 14 Jun 2024 00:44:48 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 14 Jun 2024 00:44:48 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 14 Jun 2024 00:44:48 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 14 Jun 2024 00:44:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bgHXVIGZ3zBHgN9gyshp67ruap6RfvD+ocO7saR9FcDzhro2ePE019Wqg8rANeCquW5jZ+6I3TJ1r+RhD3usDoW9QPzf0HvhGyPt+heaD7qK9jJm666s34Wp8nu23KFbTDcaUFVvElt6J6f104WrjIDFrwTyvFdFRMHsbgw+de1UeqhjLr9WeCreWRU+nyZtvwPXXdVB09TG0qZ7jxaUR0y0nDFKZvmXlIZhu1/rQEBenCvgQd4z3lmjM4tPSBwHjOxeCQm/dORVlCyG8bioScYfitw6QcF57tFPDIYBOHAgM4xPgkwc2MJE50bpT+rNtI0N0BxMEGTVQ+BN9tQ0OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eHz+RgwEPFqNBSj8nppR17WTtnb6OuYth4KNLMM7XNg=;
 b=gMMK7CfnP+cHmUA13T2w5pu3ytU2sWoMfv7gxWwnkz0/YFwG5py7pmEQns+hwTV+9KFvMkA5iYyfwRkG8Jw7ugAgYRrJCYmyAED+fyK0NZL+acyEikDQ8jUOG9tbzFigpiRbd73AcWHLrMFIN4JZejkDbGBV0+D5iKjgOFtJvjZJOmrAHuH1e9ds/3sEoKJ6N/9CR9Et9LLk+uiq+Haf9biczOuIWIjGWr6rRMzTzxw4yGT5breYPxf7f9jzidwVVq3uPt9o/CmMjcPdxNugXUzq/JLahx0wh/WwmNjkRC5Ig5q+2ASIPNNVrRkm6mCE/oW34xqlgE/dPycfAKemkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by SA1PR11MB7086.namprd11.prod.outlook.com (2603:10b6:806:2b3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.20; Fri, 14 Jun
 2024 07:44:37 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%2]) with mapi id 15.20.7633.037; Fri, 14 Jun 2024
 07:44:37 +0000
Date: Fri, 14 Jun 2024 15:44:28 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Jozsef Kadlecsik <kadlec@netfilter.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>, Lion Ackermann <nnamrec@gmail.com>,
	<netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
	<oliver.sang@intel.com>
Subject: [linus:master] [netfilter]  4e7aaa6b82: WARNING:suspicious_RCU_usage
Message-ID: <202406141556.e0b6f17e-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SI2PR01CA0005.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::23) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|SA1PR11MB7086:EE_
X-MS-Office365-Filtering-Correlation-Id: c284280e-96da-4a7a-6d53-08dc8c45d725
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230035|376009|1800799019|366011;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?S8XIVVztdRI5YQ+/5zK0+T+rY8m04N/5ZJ69DiOKstlJ81Flgqerw7VtMp11?=
 =?us-ascii?Q?c5nvq2eNGqMY6ee0mQpyccuol7unQ7+afl6OYVlQqkhhNKE+poR7KPjgvC51?=
 =?us-ascii?Q?SaMV+lfuIxc4XEz+k44i3h2uSg6MN2S4AsG5MSGTwQm4rlWHk02NnP1EIMrd?=
 =?us-ascii?Q?L4vT008T2Hhn3mjGg3yCPlWIcteWnUWioxHqPyk9e2wNUYQfDGKlkeYsI+K7?=
 =?us-ascii?Q?KWD1+9fcqQ7VNAJd9UaiERX0e2nWVPuIsJIa6qkno8p3an0jrmjEdsZQsUyy?=
 =?us-ascii?Q?4sBpqkpiSkIFlMicKStOjFjATOJqXGJudgljrljketuZx9k821dP6CtT3PCq?=
 =?us-ascii?Q?va6M8DxgTt7oeyLHLrvRO3REikBmarRNUSc1ci/w1WuAfPZwRGM3Dhhkc2O4?=
 =?us-ascii?Q?OjqtFK49sDBTJwB9eoeAW/VpwWfiQLHPp9KDe2tzV0kdzmsLFtTkTFznbYWF?=
 =?us-ascii?Q?4BREjYlnNg4qxzUp9yRjvAz8kQ2g0kFqaczzkr6XXcWv/xmhuONux6dlJUac?=
 =?us-ascii?Q?Mjc8bVfJWIN6/22anE++Md2/zqKrThVEfv0SynetlERIaLm8rQmNhtDxx4z7?=
 =?us-ascii?Q?ybdIREZc0ArT0AzFlEg94/5XzNWf3+cW8z+x3FS8/W6HONgVA1x+3RRU67Id?=
 =?us-ascii?Q?uVTY3GDvrsSpCzZxLbONWx7LdrEs1sh6zVYB89wgoCQIrrvYuLFrRbOp3Dbg?=
 =?us-ascii?Q?CHjeIYo50umf8j67oGke3DlVYcwg5Bk6BvvNBA08SGgupujjN6np3AIBR0qZ?=
 =?us-ascii?Q?2/BCt5m5xe5RyhB/hfVmahrHKsbpEBp7aelsP5GTXTb2CWnBZixVWQtFSnBu?=
 =?us-ascii?Q?SOGxSY40dqCsyDwvmumYrjJhzvO+funthUtELt9Jy+vu4DVaHaI7DYb4JGvl?=
 =?us-ascii?Q?qOaCPmb2kxYrYJ43B/HrysPeAD/s9TRUx0K/8sXvzNhFviNLLw0gsdXTKYoT?=
 =?us-ascii?Q?MtTyxrIYL9C7y2zbugFKYhsrdzghvJwX2/EOU+a3NC26PkKu1W77PiHIss93?=
 =?us-ascii?Q?BEvIeavOuUlkVdd8XYLWmIyAVFWnAuVnKrH6NuiwkcwXQkpxT0f/Pyr5HFM2?=
 =?us-ascii?Q?pfZbEjAmIyT4yD222IRbTRLt5UNbRRXoHowpnk2i//8A32c/4nHruOvDxJYx?=
 =?us-ascii?Q?oHxrEoraOitN8pgPMQ8HqGNeRcIUq5XjAmtbhijJ1UU6eM+Q6pjGt7ScWHgn?=
 =?us-ascii?Q?Qw/FiuYxfiyvYKXCxgjFIoZXi8wbchvc83HmZKdo0OT4DKqe6PI0rqrNym95?=
 =?us-ascii?Q?YLwLIhUAJjJYGCbONl79GmZKcO7MEdxpXWUGRP7lDQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230035)(376009)(1800799019)(366011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yVkQBIJHdOAUnrioZCk6Kr1YNFP9dT+vm9zpJjlMuIGITJ7lAmjppDmtV+Lz?=
 =?us-ascii?Q?WV14yUTiViWkAQVQCGpdvIz0+mInEd6c93dZINu0rhNORGJYf347sKnrOudT?=
 =?us-ascii?Q?KHPacb8f4C2BcwVe1ASWWW8vvsVzpiVUCXFPPC/yF0YotwQNEjXZ2GEhnZl5?=
 =?us-ascii?Q?60gm2CIJfmBT1iuQPjcMk/97TVRWiCHCeEuSsBA4M9RIi5G76KSnTC2OcbjQ?=
 =?us-ascii?Q?FFzqORzzKPGM85t8Mh9TRXAFExFafECfo15lhAszRPVs5oRsny0DdNobbuiW?=
 =?us-ascii?Q?Elt9TVe8PC9IozFf22ZEpx0J8VhnHgVdmMI32HWOBNC5k6DgzBZgD4JeHdHR?=
 =?us-ascii?Q?arbZtR2cMK7azoqSCt86T4yhBKGKhjkgiuObtuozBYHBR6LdBCMLeuBJJgxm?=
 =?us-ascii?Q?QhS5OGp7uyJ1Bg+362sqtxH9EGaaFxTM+M+kk1x8c8A9oBNMLQXo5HDlBj7Q?=
 =?us-ascii?Q?irvbTSfu6q8AlOiJDWQ5EFRUDb7RgePzZibJwKb74/lbzFueSxf+ylQhom/B?=
 =?us-ascii?Q?WiC7yvUMnZrqtutBIuS08c+T20n8iCt+v0ku8YFW01wHBns7BTr/bp5zZ31l?=
 =?us-ascii?Q?Ye9xqODbZq4UCS66G9wW2CjbopEvSr1I9mO9sLbEZCBZWfnmaZ0Mu+Jg1Bhk?=
 =?us-ascii?Q?iC9dajDSzAQtDlknLEiwjgxb6ir9phnwM7YQ6tNt4QFQM2gX0/Xp+LMzQop7?=
 =?us-ascii?Q?qzjgmasT1Dw/PwuGpuLJ3rd5NZ1wxKaplAv4BaznjfIhLsBuMNgRDTuwudgN?=
 =?us-ascii?Q?s8jmsFsm/Ut2JhU8BAQH9R+cLzHmQpVJRwUWipa9KBJAIlFwPdH8N/3zOHSC?=
 =?us-ascii?Q?kut7noKOO35UZeyfTefAlAhAnrMMNt24P2NnCcSjJbGZrOkseYJ/33ZjlsCY?=
 =?us-ascii?Q?vPdIlqQ0+eXwfESQv14J2wHu2A3gWYwZ+BWLwhGgBcSGjteytTuR7IaultBv?=
 =?us-ascii?Q?IrQVpbryZgjNESB3pl4ifpa1digBt1n0jhyamvNdanFL6BwH6SY8Q7mibixg?=
 =?us-ascii?Q?qiKm6+siLQQQRUfuCarwCz2XrYIVMJs4E2zSbzxOgkQ8n4hFC0KWtY/67mjN?=
 =?us-ascii?Q?f6M6t6LQi4QdYLjuQar3vOa662PUfh2+UNUjO7LczqUioIEEjWbEs166pGvP?=
 =?us-ascii?Q?7aoBtLbCv5sG48sb0MZ6hJgb6eE7R4dE88zQpLREfuBf7wXsM6nsfTXTet3g?=
 =?us-ascii?Q?sCYkjV52fbNeJ6xD+OfknHiJaa5VGKRB0Dr0MNoKNBnsYLmmORdr7gUABjTe?=
 =?us-ascii?Q?BYvb42bsJ73k9/zQlWyvNlk5dcHWq8762CNJcu40VntSTDhsYoN4hniEXCgu?=
 =?us-ascii?Q?adScVqGgci15fP0GxNggRjll3whu6RpQ7oVWbU5iMBwr88UZbWX9mBENz0Gf?=
 =?us-ascii?Q?RbWoMMGNq/sd28+HwOe5XlEz2Dq2mh2pc1QQ+ZpSL8nSnrqCe2Bv49KDHGnl?=
 =?us-ascii?Q?HmWlWW02UpdaGkgB8TesDFVRtxMUpUTQy4bwhcU/1umtuaMCiPl3edSLOxgC?=
 =?us-ascii?Q?QEZfTTfD/Tju06RK7ASc2kZZhoequEeixJHbDFtc8ejv2g0S6HRVVqizq1wc?=
 =?us-ascii?Q?0qJR5DAH+ZMmCmbieUW5l1urWgtAkghEzLyO5oMpfnIApNzYWnn3bo6Z6TEh?=
 =?us-ascii?Q?cQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c284280e-96da-4a7a-6d53-08dc8c45d725
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 07:44:37.2914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WQYCJG3/GyzrE2yIc3NfiOkPjPgE2g7+14dOeOHhyVc5/f0A2KLEC+j3mgFLEuPUeQanKmY7SM4SNlsuirPc9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7086
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "WARNING:suspicious_RCU_usage" on:

commit: 4e7aaa6b82d63e8ddcbfb56b4fd3d014ca586f10 ("netfilter: ipset: Fix race between namespace cleanup and gc in the list:set type")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

[test failed on linux-next/master 6906a84c482f098d31486df8dc98cead21cce2d0]

in testcase: boot

compiler: clang-18
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G

(please refer to attached dmesg/kmsg for entire log/backtrace)


+--------------------------------------------------------------------------------+------------+------------+
|                                                                                | c4ab9da85b | 4e7aaa6b82 |
+--------------------------------------------------------------------------------+------------+------------+
| WARNING:suspicious_RCU_usage                                                   | 0          | 6          |
| net/netfilter/ipset/ip_set_core.c:#suspicious_rcu_dereference_protected()usage | 0          | 6          |
+--------------------------------------------------------------------------------+------------+------------+


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202406141556.e0b6f17e-lkp@intel.com


[   33.826616][   T31] WARNING: suspicious RCU usage
[   33.826862][   T31] 6.10.0-rc2-00244-g4e7aaa6b82d6 #1 Not tainted
[   33.827175][   T31] -----------------------------
[   33.827419][   T31] net/netfilter/ipset/ip_set_core.c:1200 suspicious rcu_dereference_protected() usage!
[   33.827894][   T31]
[   33.827894][   T31] other info that might help us debug this:
[   33.827894][   T31]
[   33.828404][   T31]
[   33.828404][   T31] rcu_scheduler_active = 2, debug_locks = 1
[   33.828806][   T31] 3 locks held by kworker/u8:2/31:
[ 33.829109][ T31] #0: ffff8af0c1a58158 ((wq_completion)netns){+.+.}-{0:0}, at: process_scheduled_works (kernel/workqueue.c:3206) 
[ 33.829668][ T31] #1: ffff8af0c466fe38 (net_cleanup_work){+.+.}-{0:0}, at: process_scheduled_works (kernel/workqueue.c:3207) 
[ 33.830204][ T31] #2: ffffffff8b263070 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net (net/core/net_namespace.c:597) 
[   33.830685][   T31]
[   33.830685][   T31] stack backtrace:
[   33.830983][   T31] CPU: 0 PID: 31 Comm: kworker/u8:2 Not tainted 6.10.0-rc2-00244-g4e7aaa6b82d6 #1
[   33.831438][   T31] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
[   33.831947][   T31] Workqueue: netns cleanup_net
[   33.832193][   T31] Call Trace:
[   33.832366][   T31]  <TASK>
[ 33.832519][ T31] dump_stack_lvl (lib/dump_stack.c:116) 
[ 33.832769][ T31] lockdep_rcu_suspicious (include/linux/context_tracking.h:122) 
[ 33.833053][ T31] _destroy_all_sets (net/netfilter/ipset/ip_set_core.c:?) 
[ 33.833313][ T31] ip_set_net_exit (net/netfilter/ipset/ip_set_core.c:2397) 
[ 33.833554][ T31] cleanup_net (net/core/net_namespace.c:174 net/core/net_namespace.c:640) 
[ 33.833789][ T31] ? process_scheduled_works (kernel/workqueue.c:3206) 
[ 33.834080][ T31] process_scheduled_works (kernel/workqueue.c:3236) 
[ 33.834364][ T31] ? process_scheduled_works (kernel/workqueue.c:3207) 
[ 33.834664][ T31] worker_thread (kernel/workqueue.c:?) 
[ 33.834924][ T31] kthread (kernel/kthread.c:391) 
[ 33.835137][ T31] ? pr_cont_work (kernel/workqueue.c:3339) 
[ 33.835384][ T31] ? kthread_unuse_mm (kernel/kthread.c:342) 
[ 33.835645][ T31] ret_from_fork (arch/x86/kernel/process.c:153) 
[ 33.835876][ T31] ? kthread_unuse_mm (kernel/kthread.c:342) 
[ 33.836137][ T31] ret_from_fork_asm (arch/x86/entry/entry_64.S:257) 
[   33.836402][   T31]  </TASK>
[   33.836598][   T31]
[   33.836723][   T31] =============================
[   33.836976][   T31] WARNING: suspicious RCU usage
[   33.837221][   T31] 6.10.0-rc2-00244-g4e7aaa6b82d6 #1 Not tainted
[   33.837534][   T31] -----------------------------
[   33.837779][   T31] net/netfilter/ipset/ip_set_core.c:1211 suspicious rcu_dereference_protected() usage!
[   33.838255][   T31]
[   33.838255][   T31] other info that might help us debug this:
[   33.838255][   T31]
[   33.838760][   T31]
[   33.838760][   T31] rcu_scheduler_active = 2, debug_locks = 1
[   33.839161][   T31] 3 locks held by kworker/u8:2/31:
[ 33.839420][ T31] #0: ffff8af0c1a58158 ((wq_completion)netns){+.+.}-{0:0}, at: process_scheduled_works (kernel/workqueue.c:3206) 
[ 33.839973][ T31] #1: ffff8af0c466fe38 (net_cleanup_work){+.+.}-{0:0}, at: process_scheduled_works (kernel/workqueue.c:3207) 
[ 33.840513][ T31] #2: ffffffff8b263070 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net (net/core/net_namespace.c:597) 
[   33.840998][   T31]
[   33.840998][   T31] stack backtrace:
[   33.841292][   T31] CPU: 0 PID: 31 Comm: kworker/u8:2 Not tainted 6.10.0-rc2-00244-g4e7aaa6b82d6 #1
[   33.841748][   T31] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
[   33.842259][   T31] Workqueue: netns cleanup_net
[   33.842506][   T31] Call Trace:
[   33.842675][   T31]  <TASK>
[ 33.842827][ T31] dump_stack_lvl (lib/dump_stack.c:116) 
[ 33.843074][ T31] lockdep_rcu_suspicious (include/linux/context_tracking.h:122) 
[ 33.843355][ T31] _destroy_all_sets (net/netfilter/ipset/ip_set_core.c:?) 
[ 33.843613][ T31] ip_set_net_exit (net/netfilter/ipset/ip_set_core.c:2397) 
[ 33.843852][ T31] cleanup_net (net/core/net_namespace.c:174 net/core/net_namespace.c:640) 
[ 33.844087][ T31] ? process_scheduled_works (kernel/workqueue.c:3206) 
[ 33.844384][ T31] process_scheduled_works (kernel/workqueue.c:3236) 
[ 33.844668][ T31] ? process_scheduled_works (kernel/workqueue.c:3207) 
[ 33.844967][ T31] worker_thread (kernel/workqueue.c:?) 
[ 33.845212][ T31] kthread (kernel/kthread.c:391) 
[ 33.845424][ T31] ? pr_cont_work (kernel/workqueue.c:3339) 
[ 33.845668][ T31] ? kthread_unuse_mm (kernel/kthread.c:342) 
[ 33.845927][ T31] ret_from_fork (arch/x86/kernel/process.c:153) 
[ 33.846155][ T31] ? kthread_unuse_mm (kernel/kthread.c:342) 
[ 33.846416][ T31] ret_from_fork_asm (arch/x86/entry/entry_64.S:257) 
[   33.846673][   T31]  </TASK>



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20240614/202406141556.e0b6f17e-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

