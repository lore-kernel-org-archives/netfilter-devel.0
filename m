Received: from SY5PR01CU010.outbound.protection.outlook.com (mail-australiaeastazon11022084.outbound.protection.outlook.com [40.107.40.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EB53126D4
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Feb 2026 10:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.40.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771581918; cv=fail; b=I/cwATkZNVTMwLtDhbX9/IeXMu2PGjwxruM/WF3goomzfOtPXKOQnwl6HIe9iYyjniYS+l1ZQ0qwp3GkeMbB2k8WC/JvagxqZHpJUO6w+wHdGnnjqGlvpwe7RxC+PheRWgQjpXdRLBaN2gbS60pINu4mnFgmgwmj9u8fZ9W2SO0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771581918; c=relaxed/simple;
	bh=+0r4ix+PhtNWozc+5/0mjLi5NwPt+QfYTSUYY80161A=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=n9NqwL2tJvjRLEh90po2clD9RC/xgSN9iv67Js4DpiwqxxBv/EaTrY/kyeNYobjSwxt1mbMO9ZA9gYYfWdEtvydALRMHPDEPuim1M4AfGLvc7u3hFm8RW+orCuknVUibQ/6h/q1hd/pa8Ll3siRz0KDfgKyxluXmQR9Z55XzDZc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=heitbaum.com; spf=pass smtp.mailfrom=heitbaum.com; arc=fail smtp.client-ip=40.107.40.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=heitbaum.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heitbaum.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tb+AOxaCPBIEY/W0ihJc6nS+79PAzd+7NBrj+4gZ3UGqbpMlqjPIg7vLoS+7M9nzwm2nQxWrmqYvQJF++EFInIqCnG26DH2l9kzZergX6CtlLk2oeZK1SakaaUwrpvTLjIx78e54zPlTcDSLIiml2qOlTup+qa7Qs1DZzHsevVMQgsLhuGYRqw3/0Na/WAoCPDJLH8bSdDWVKdNIWncFOCN0iQa7lVnOmPwONwbkpgMfY8j4Ggz9/N5Bhgq+FCRMklwwLgkTjEBB2VcP2vLxQBmETYV3+fb5w5e/if7pDJpER2LzFXT9rgSIVkLgLQ9WkEkHFv3BzvXeFDkuRfJyMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e6l8Y68iTwaIgSAkqjzi5nL+BNXdoQ8va/hPvcLvYJ4=;
 b=jnTEj6F464YVMoB0Jn5pHdLngIlnoul6YcEAp/04tHJB+C2biot1Mg/EUV2Jrvgk8GNS4LKATxgU3VEQCM87LuYcHPesl/d2nLH9OlzGDWc4uRNMkM32KnWJDOY2bAbkO5pPe6CTPhhEpsNpF3oic6OPe7Z/0ys7AuPf87OzTjLf1e3zE5tn3kYjhIRHqsfbAx0VokQ8LITy5CgD+MXF+JfRq8DgZjvAo7nX6dnL8kLt7u06PXa5SZNrt7Xa1sLoc+tLcYYJUCF/OpRCs3nmjFAylhj5eeJyiO5ezA7733zDX9QpWDxVlYBeOPwZ30PJTlcROI7flMReWJApAc5BTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=heitbaum.com; dmarc=pass action=none header.from=heitbaum.com;
 dkim=pass header.d=heitbaum.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=heitbaum.com;
Received: from SYYP282MB0960.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:73::13) by
 ME0P282MB5141.AUSP282.PROD.OUTLOOK.COM (2603:10c6:220:239::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.16; Fri, 20 Feb 2026 10:05:12 +0000
Received: from SYYP282MB0960.AUSP282.PROD.OUTLOOK.COM
 ([fe80::7340:fb70:eaa2:ee1f]) by SYYP282MB0960.AUSP282.PROD.OUTLOOK.COM
 ([fe80::7340:fb70:eaa2:ee1f%4]) with mapi id 15.20.9632.015; Fri, 20 Feb 2026
 10:05:12 +0000
Date: Fri, 20 Feb 2026 10:04:52 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: netfilter-devel@vger.kernel.org
Cc: rudi@heitbaum.com
Subject: iptables user tools: const variable being in functions
Message-ID: <aZgxxNcuJ77bt1n6@6f548583a531>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: MEWPR01CA0011.ausprd01.prod.outlook.com
 (2603:10c6:220:1e3::18) To SYYP282MB0960.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:73::13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SYYP282MB0960:EE_|ME0P282MB5141:EE_
X-MS-Office365-Filtering-Correlation-Id: bba3161b-591f-4d63-05be-08de70678928
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?93KIYACgUkizwJ8I8VAvMzcPMxnn64pfxzQma67Pr8fMCk7Il7V2T7XC+xbC?=
 =?us-ascii?Q?oLrACnC9MUp0e6UAg0yCRrEzrN0Hm6GTqbf5UKd0PbpXYLCUzcFR0MiavYDK?=
 =?us-ascii?Q?15ilo3LhsfuO4m1Yw4UmN3MpvLbpOPxYqNymySsL1JDnMk7scAuXIFUSNNZg?=
 =?us-ascii?Q?+Du0kIM6ZM+sGnzafoJ+SdvCcVqLQjMlHFldgwyzNNp3Lx4YmPw0CYcb2tnh?=
 =?us-ascii?Q?KYv9T3Ul/Gbv/NXyruJj6ufBfXiw/gdc3CpJkm1ffU0P+9Y1KbFUJMJ1oX6K?=
 =?us-ascii?Q?3pVUhUZP93mHmkm0anBUWDkwXVuw9XXJ1oS0l2Dn5SJZpBcFIb4z5IkZfxDH?=
 =?us-ascii?Q?TEbz1GIAgZAkHmbzEHjvm3JzFBMZW5M3Sy4D6na2SQuCQELq+G5SGr91/mnV?=
 =?us-ascii?Q?BHDmxQ8mGJbBY0JBI5Kci59UaIfd8HOkOcIGagMkm29z896HCKseidyScWAI?=
 =?us-ascii?Q?xSl0yTRV8UugJdbZ/PSwh3E0Qn/sdQAu18LNavHUnnlc7F/hRbdYNSdWXsI0?=
 =?us-ascii?Q?+KHUy4+/xrnlAs0Rc/2t0/QA/1EGvlroc1O9MO0TFP+uFbXSQuJOaTTxoZAz?=
 =?us-ascii?Q?ZrkusHj8IyTR3j0HvHN1PNJr6LZfe8LXZsXY9FynKg8tyzq1au42MIFZejia?=
 =?us-ascii?Q?ohS0v4hArSJiu8zuXmlHxM+U7crkr3mT6MpZ24FZCdOBfemO9ZIPALxjAwc/?=
 =?us-ascii?Q?8/zWQH1Na/Juwu7AfkYZpVrHqrzd0tn3fXHQ4Swqy2LR1L1nQuOls4/W6PEW?=
 =?us-ascii?Q?uTjxIyn0YXfd2cxU5r6Z/N42OZzasIvUctngMQcLz6R6nzrx8FisAXnKHaS6?=
 =?us-ascii?Q?2k0qZ+CHHwlXOMqhMA5M45tvnr5RsO828jwMgKWgu3trrE7CliHGaXIf0ph0?=
 =?us-ascii?Q?F5xn21UvgEoL9B3jEAsgFylEdgsYVkb7DpG2RH9BDAc/JXYvzLQEwATJxr7G?=
 =?us-ascii?Q?4r7JGT2kooNyjaneyIO1gQeUPPD8cXQWvMLqJbGOQrRCpdzKAhyJ6f9Jgmde?=
 =?us-ascii?Q?AbMNg8LWfh5+SHP8y/Xr03sWUMlyW1QODNx5rLsN1xYJip98eRShpzIRn5T8?=
 =?us-ascii?Q?x4kuGWnbsd0HUPS7cMNX+jgqyhaBd23JW/Sn/DOJQ09MgvGVCXFLI4JUS0b7?=
 =?us-ascii?Q?5MSq3fvHCJLpYmvlNaIaqWA0oeYwk36/886KXF385utgdhzzGglZQ1gFqsIK?=
 =?us-ascii?Q?bAX9mgCkFOnUo10mDz1atZpAKm1GRg93G++YJUtEJqPCkmIOBW+FW9m8MX6E?=
 =?us-ascii?Q?G4OVyPJTXQnGicKNMD4/IcyAPuJe3VzSuql0r5FFH1XsjAIvXNrWtkyquOfU?=
 =?us-ascii?Q?KilEFE/xPP2Fil3GON71pDkhmN1vLsV8q+MZxaD3056/4hp8rbcMu9EOIuvi?=
 =?us-ascii?Q?XlHGCeK1y18LRuLcFG35Qqg9zWJUONFy8H0ipyBwEPZGTZdNtZTjgYV80dpq?=
 =?us-ascii?Q?zVx4cq1ObDxVPsqDyEXS3dGLBdY38WJGwTRsiYic00povotldq6nOon9kTuH?=
 =?us-ascii?Q?JSuxodE/4ZNQiiyIAY3PnOP0fUWDZqvwHkJbj9269J2QUMMLHmtheOy1SNHc?=
 =?us-ascii?Q?KJRGx7caprxvrpfi5Ho=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SYYP282MB0960.AUSP282.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Fz1VVna+bHEBjBEidV5bCoH7bdfXNRDRl3cg+jnRSyvWaBxUSOUmEx/H3wHo?=
 =?us-ascii?Q?axMNu7+QWvPZ1vdz8u7kfmiWR2xhzHucHIMHVcBeYCK38oasGFkxmNalThS7?=
 =?us-ascii?Q?rEcMD7SJtP+SpxNq9niEHgX3KJQDQAYh2gGGE0lmYxe7RD8rpFmGhSI+iVH0?=
 =?us-ascii?Q?GHva6rztYB6l8v3yxmn96FocpNf5iqWsJDipm5kegBI7zOMfiqlUyx6LHMuG?=
 =?us-ascii?Q?QiyQpqZcHwMmRcIoollR/3DF/dIUFHL0cICnKzMg9l3v3ok2MgSnvKnnIHVn?=
 =?us-ascii?Q?RZWkFRW5sGuLq+kIvkgaPU33RzbWrmUh8L2jycaEiZ7FoYteBrHOAGBdaXHw?=
 =?us-ascii?Q?hqdHRQprvdhuZwzVdCmSDJkMt5bdXATq2QhKXosDGMhcL5tCbQUjJywZZ9NQ?=
 =?us-ascii?Q?SkT5VL6ktdgfGG4zqVI1dhXo8KWrgteGzFff3WLAOTl6zFvkQ+Vy7nqpjfsN?=
 =?us-ascii?Q?Ig37PpVOkfmUmw64nzaPrckQl5JEAn23vfO5txRNp7hREhK5jTbKILPqCbNF?=
 =?us-ascii?Q?+Kdyg7PFIvB5Tq1jMM4w6FT1eneAer2JgclF9iXdCx1Kair8UbubkQy/F7lH?=
 =?us-ascii?Q?QLw8qHlZePkqjr1P2aPhrXJUvPSG0YTAOGf10T1Vw0ZGo7tUoX6OLx6ryIyk?=
 =?us-ascii?Q?pNQOev3TkI91QkVfjp5/DCYeL1blJw4RatxyR63ecM0YDyWX7rP9wYrhMqbS?=
 =?us-ascii?Q?eCrWNRh3IVr9iVRY7X+UCpxb9tvfDs0TfQbsGmnXpUD9smdLc9wbhjPLuBM+?=
 =?us-ascii?Q?BvHGByH2HEsjF761pPevY+gY9gacY49EpfzczADDLOCG1f2P8zoQeEdlb97y?=
 =?us-ascii?Q?H/hGAFAbH1lJ/wG5MxyhyTQyTLzDwy/p5zHH5h1N7t59mk42urAPq3GbJQyk?=
 =?us-ascii?Q?W4cyehmwYtlzQu9HDbemkScY+KAPIIP2RlfpbZaLpdQ9xm3ppkpOXt9l6VTF?=
 =?us-ascii?Q?VLgOj2+ad2bxqKGmQfLKptQu/WRTyOvbnkOsWXnh1FolXy4HZoBiJpYNXzhc?=
 =?us-ascii?Q?uox8tYAiFmtGAixtOUmfSgrwQx/opoSDVwcW3RGf/7jn9gxsBzyN+P8xdji/?=
 =?us-ascii?Q?+PZWhv/PVx76F8kSUwqU4J5GlyqpUSXLNazOInHf5whXRdReSE4M38LBVhfB?=
 =?us-ascii?Q?WBbI4/JOzXtHEfo0ZqYoQS6Eg48/SMsVLUGkrgj3/t1U4zj1HbD0eUu0s5hf?=
 =?us-ascii?Q?wYcacIGnQ+DGiFu5tP/0CW9YjTX0m19BPsRnYwOs5FyRWwXvYE66/iYZ9YMr?=
 =?us-ascii?Q?l6lZ5AQMcA9MXOpCAimMpEzjAyr+UQRjCqor0VmLeTQD/QL/BWqD9BrG0yy7?=
 =?us-ascii?Q?3vWgZwFFvwaPhKQakxUQOgMcBZd/qpvTIbZF/z8Ez0GXgFo+MvmkMnNwgys+?=
 =?us-ascii?Q?7zLRpzSTPWiHhiDvg0/Gktj+mphMqGUHDwOSLB7fHiDjXvDdQkImdJkFPYOv?=
 =?us-ascii?Q?lKXvRyB/Ag11g/YfhGHL+4KUvRNr8i5so24fL8RJyVgTiUJTkeNCGHgrQ/YU?=
 =?us-ascii?Q?jqc056q985NoNiOaALtVd33kpud7LpFGtZ3h4tJjdu9uA3EKiGnkG+lPzKKD?=
 =?us-ascii?Q?c5ZQmhOu0Y/HMwqNzoKQfm4s4APtMD+xeOCjH6YAX6+X3Ym9i/zdS5aHmI8X?=
 =?us-ascii?Q?G3arqm/bNQq53S8jV2+7cUtEW8vHYZIwqN5wtXyl+A5XXbvOtzpEVVW+R67J?=
 =?us-ascii?Q?MmwumfpKxkOys7GTB7kbUE62wXWulS41c2/FrW+IaKWVkdXO?=
X-OriginatorOrg: heitbaum.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bba3161b-591f-4d63-05be-08de70678928
X-MS-Exchange-CrossTenant-AuthSource: SYYP282MB0960.AUSP282.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2026 10:05:11.9587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 35ffebb5-7282-4da6-8519-efab29b0108e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ImPoKmOJUIoXV8O3SqKOmYOxCqFVw5Hy9QyokROlTrdOTgkGqWlkU9On1N6HYOX4bJ3N3vJgD3x9F2xhSBgQlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ME0P282MB5141

I was unable to log the following bug on bugzilla.

There are an additional 2 discard const warnings when building iptables-1.8.12 with glibc-2.43 and gcc-16.

Both of these warnings are occurring with the passed in const being changed in the function.

../../libxtables/xtables.c: In function 'xtables_parse_mac_and_mask':
../../libxtables/xtables.c:2307:17: warning: assignment discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
 2307 |         if ( (p = strrchr(from, '/')) != NULL) {
      |                 ^
../../extensions/libxt_TCPOPTSTRIP.c: In function 'parse_list':
../../extensions/libxt_TCPOPTSTRIP.c:78:19: warning: assignment discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
   78 |                 p = strchr(arg, ',');
      |                   ^


The other warnings have been addressed in:
- https://lore.kernel.org/netfilter-devel/aZgragyOBo2vEOUe@6f548583a531/T/#u
- https://lore.kernel.org/netfilter-devel/aZgrmmEUEQ1L_Sjx@6f548583a531/T/#u
- https://lore.kernel.org/netfilter-devel/aZgrw5yXNZIaRXfV@6f548583a531/T/#u

Regards
Rudi
