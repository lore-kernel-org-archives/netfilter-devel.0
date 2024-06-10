Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6955115A8;
	Mon, 10 Jun 2024 18:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718043729; cv=fail; b=OG1sNS6zv/Uye2f1f3dZ6oOIqi9bVVO8Yu1GBp5pBYXZAGN9bv1diKmfps2ao3/lsOqvnnIXC2gqJ9WYHQTJMveXD4rxXukbvliOgK9DgDhuXVzASFQMs9ZQ6DYHFLZDwUM/dKXpZX17oM02x9erHJhP8DPyIMkKg2QChxc8ob8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718043729; c=relaxed/simple;
	bh=Es+QgHRiSphPA01zA6QRJtB92mvCACaDRlW+wyTY8uY=;
	h=Message-ID:Date:From:Subject:To:Cc:Content-Type:MIME-Version; b=kV070xLgUSxhiuRy8xBCCjkV+hZ59/TEcV/UgnJgeLI7G0GaZk5LEKtfLBRhwYfxqwHsTy9TcUuFf/t64ib5axldYMH+mU8WbI2HSbKPJ8K+CHM/612i3aFd3aXi711jpQOEw5nd1HzYhyb5Fk3INp9nphMBGt0jZKYQ5ZyCobQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SCW6RzaX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gn1i22g9; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SCW6RzaX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gn1i22g9"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45AEMRvp010912;
	Mon, 10 Jun 2024 18:22:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:from:subject:to:cc:content-type
	:content-transfer-encoding:mime-version; s=corp-2023-11-20; bh=v
	N25KNz31+WZsjmVCxsYhz3oxn43jbLIdquW022G0KE=; b=SCW6RzaXoxkQtlEIR
	eTMppFsHVWPAcFhiwmb8WayKhviZTjOb4vshIU/FsNbdzhsfJj5oFzcLLJciyfBo
	wGyX7xdhbWzJcqXfMHZzYEitmSLfkp6BHzEwzoZ5/s5pbvU+qu/woZuFggoQQJ/X
	6Qpt4dOrLapD+xDnMUq+aooqX4Vd/iyRanTWGBc2dXZc0iLbPdOod3hT3gj86tDg
	+BbhFQQalfl6pAe+k9opOXYHbaNTyyFT6hDukiVdKLhJxHJWC3dKPpcLpuwcAM7t
	NXwt5I+uqEGZEwH2jxG4RISIpbQiSFIr8XKv9QIXUp6Z9LPcXs2PZ3ENSa+iEryS
	OwHVQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh3p38j1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 18:22:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45AHPr8A014400;
	Mon, 10 Jun 2024 18:22:03 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3yncesw9dv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 18:22:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P5813IHi2QLiaUzbKNIRYcUcbE0LxcFNghqF0OAC8eSMihBBqy+tDPjAGHiZjdzH02OAvAgRMJgc0MLzUHb+BvROgt4GmoczRZDwm/Zk2N87qC0YuYW5cqSwUu9cRM6z9LWd5K966TMzsDbXlVbL6O0aCJy7viCe5y0syPg0XWMCMEUYJT9t5qfMdVvkJFfEMpIrzPP89fbnj7vzNlfXqMTYDscSVXjm++D4mbColjS4ffqMZndb0GsU9lD68jPoCP88NhnQbpJca+1ieRzKiWesGEsTCz763fMFcMthItVAkLLdBwoKyrCmYl7gv5GbeLqDLTy+L58MoxfDyHE+2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vN25KNz31+WZsjmVCxsYhz3oxn43jbLIdquW022G0KE=;
 b=WXOSjsEaUIKIxBsvMEuZqrmmM9HlfqsuLgrhGngrDSmLsC+dEQXtOcyHajjppp7DEAMQ2MI1OepXHS48TpX9CQeMvfIVHo7AxsQ7bYeoJmpesUH2wFgxyOsA8iaW1L0YOcRNXtgc7SACNmyhm0ucbQJ6zIaSIG+avJCiIFffqgAKjlxGG90Wfg3iKO4GecvtVnfCNgIdMMi2xbA3d0swASytOmr7BwvsR0oJEUpWriz6NccdcgZzlE+owoWbjl2nEVSlb2WdMEtjkWPWGinCRSjMrKSOIjL+etLksF+oOu3abz4fujIH1sSgiXoX+FiG1ZDR4U3koeOIi9WjlG4G4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vN25KNz31+WZsjmVCxsYhz3oxn43jbLIdquW022G0KE=;
 b=gn1i22g9UX9WHbbVqoQftdtrJOGTaUTKOI/f3nUZp4OUwgF69P6uYMNc7aDdEAWAZGp6JXM4Ms8ZRHdg1D/+cP8Pfm9pchmsKUkIjbkgwnhWAWtUYRKB4BDmhXDz2XWmZpeZr5qqMmqdchc12U4MRUVlWRzRoLV9CHEnty6lgQI=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by CH3PR10MB7906.namprd10.prod.outlook.com (2603:10b6:610:1cc::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Mon, 10 Jun
 2024 18:22:01 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%6]) with mapi id 15.20.7633.036; Mon, 10 Jun 2024
 18:22:01 +0000
Message-ID: <652cad2e-2857-4374-a597-a3337f9330f0@oracle.com>
Date: Mon, 10 Jun 2024 23:51:53 +0530
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Testing stable backports for netfilter
To: netfilter-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0036.apcprd02.prod.outlook.com
 (2603:1096:4:195::15) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|CH3PR10MB7906:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fc294ee-6c1f-479b-dcd3-08dc897a38ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?LzM3Z3R4a2JDclQ5WDZOQW01SHVjVStiSUNzeDNxa2k4ZWpKVHUzaU13TjNP?=
 =?utf-8?B?clFrSmRCTC9ER0syMVRGZzVCdjRZNFc3amNOOFpqR2s0YmlvdXhza3VSSzFM?=
 =?utf-8?B?L0NoVTBCTW9jaytKQTNRWHJyVi9Ebm5JZEJkVzZLS0ZURmVMU0tiQmsvSTQx?=
 =?utf-8?B?Myt4RmFiVjdDenY0UkxPdjZ6L3dScXJRVkhIa1IvQ3lrellUR3NYaGFoNU1Y?=
 =?utf-8?B?ZUdaSkNaUjFMaERxanVGdjVtUzJBaHVNdUF5SFVTWVJTY3JPaVlWTFZydDJ5?=
 =?utf-8?B?OTZRdzd2Z202NnR5N0JNS0tDRTA3SWtCZ3htdHh2Q0Y0QllUMVdCaytvWHFy?=
 =?utf-8?B?RDBhd09uQ0JjcXZGb1IrNHp1WGZvNkFrZ0FBUnlNOXE2TVNZSzN2VUtTYTZ1?=
 =?utf-8?B?U2VUVVE0MW5OQW1KeUl3dExJTXpieFR3V282MHE2M2ZuZUxORU5YVGloTGJK?=
 =?utf-8?B?cVJjU1lOYmVXSTBpOWFFVW5NNnhURDdGcU0xNHhuTS8vWVNnd2pOOHJOT3Ex?=
 =?utf-8?B?d2thTXkxcjhhT3FtMnhsZHJUbzN6WUJTdHowRVc5dndzSlhwV3NUcDZacHQz?=
 =?utf-8?B?ZDM3bjV2eDNqcXpyY0k5YldFZ2R1L1NVTUhIdGtnMTBuak9rSEVaSW05dll5?=
 =?utf-8?B?cEVMMWJza2s1M0RLMmFISkQ5TDk1MWx4VXFhZTNHM0FzOTU1L011MlVkdi9x?=
 =?utf-8?B?R1F4ditLelRCbHNraElBOTVZbVg4aVI2UG1DSmkzeGR1enhWS2JnNHZDUkdT?=
 =?utf-8?B?NUJsbFhLank1K01KL1RXNUlmaXJCOE1JNVFRbzBxQUFSMWtEM1E1VHU1V3RU?=
 =?utf-8?B?QnNpclhYQUhzMVprNnNHUTB6bVhQTHV4ZlQySytidnFMSzRWOEYzSWV6R2g0?=
 =?utf-8?B?aEdwakwyS2oxamZmZ29Ia285NDdqRlJSWDlmUlBCbFd4QzYzcU9mcEw1S0lB?=
 =?utf-8?B?VmQ0SkVLaGVESzZlb3dnd1dRWWtxMStkZnVTTE1BUWpEbUcvd3lML1BFdTli?=
 =?utf-8?B?Yk4reERQRUVyWnVsUkdOVmpUdElsMW4yTUxzTnVLM1Fua3VkQ1h1L1BiK2gr?=
 =?utf-8?B?alU0NytoMGQ1eTFMK1RIZ2lmUC9UN3pqL25ZTjFsd29IazdMQkVjUnVuSDZu?=
 =?utf-8?B?aHJWejQyNnI2b0p6dTNWSDFDZkx2eTV1eC9pck9DZGgycDNrNjV0Tm9vUnFX?=
 =?utf-8?B?MGJKM3pCbnlQSlkwSjBQbkJiNzJtZ3dDVzdwdHE1aE9kR3ZYS0ZKSjB4UHlX?=
 =?utf-8?B?Wm1LdHlRc2JvSnp3YnE5NktxLzVPRFpTZEtDTGJ3RnZ1azI2bkpERHRzalpR?=
 =?utf-8?B?QmUvc0wwSGdGeWFnUFdHVW5IS0FEeDFIYUMzbVhTR1RQU05zUVRTN0lJLzJo?=
 =?utf-8?B?UVQybnZzU212MzgveE82WmwvM3p6Q3VlK3pVNjRtNG8zQUk3aTBscVVXRTY3?=
 =?utf-8?B?TnM3WG95OTh3Y1ZSSDBKellBbUtxYkc1aDBjU05CWFpkYnQwcThWVVRuVndX?=
 =?utf-8?B?a0VQMG5zZ1ZROUdUa2NFQWtMZVZtQVFxdWw0TWZCam81QVdaVkw3cjBhdU5L?=
 =?utf-8?B?cDZaUk5rRkV5c21maGU0NndnalcrMDV6YXMvNmxOSkFSU3YwYjQvcEJOTEtL?=
 =?utf-8?B?ZkVYL21za3JsNml3b3RCc3NKY3pJQ05PNElTZFNjbzRvSDVpUjQzZU56bDJk?=
 =?utf-8?B?ZUs1clJsK3JVT2VrMDFUN0N0NWhDMldpeDlCb3M0bTRmd1d1bFBPWFdKMXNm?=
 =?utf-8?Q?CGMzWnudDQAtiGi+nE=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Y0pXOXZkQlUzWkl4MFh3K2lKZEhDN1J3cHQwWWZ4YW5qUUdHNWdZRklSc3pz?=
 =?utf-8?B?U0p0cTA1WjNaZElsUXl1VmNWVXdUdHI1d1lRWFBaYlBjSW1QZmF5K1VnbkF3?=
 =?utf-8?B?c2laVys1UlBRc3ZVWHAvYzkxOFdUT2cydG5ZWWt3SHBKYnVGckZIRmovWExN?=
 =?utf-8?B?N0V1cEVNQXplNDFGbHhHb0lrMURDb1NWWnRHaFg0ZllleWtLbzZBWUtPby9K?=
 =?utf-8?B?R3J2R1Iwc1Rnd09RUSt0WXc0YlRSNWNva1o2NE9WNkYyVnN1T0ZHZ2VGbG1v?=
 =?utf-8?B?RXZOSzBjdUErUURFaElMQ3U0SHB1eTZDZFJjM1RkR3VCa2M0a1hVeVhQV3Yz?=
 =?utf-8?B?aktWa0NGcjU2TWpIM0dJamVBSFFta0kzQy9UditFTHBoNzBUeWFxTGJtTlhp?=
 =?utf-8?B?aVZNSHJJQk01dmQxM3FDRHFHbEpnWXZUZjlmd0M0eXE3NEk3UVVYcFlxQjJL?=
 =?utf-8?B?U1pWQTkxdG9JQ1h6OTVXdTIydUo2djhJQ1V1SEpsVUhINy9NblpJOUV6ZmNj?=
 =?utf-8?B?YysrQldzOHYvTjhlSlJyYzJOdjdhT3l0VStJT0loSFUvYVBJRFZjY3RLRUNY?=
 =?utf-8?B?VmV1OXI4bzdhUlc3V2JoeVA3VzdNdUhnQ043d1dOMkNGNk01T1RYWDREaXA3?=
 =?utf-8?B?V1FnNVRtdWV2NndJZm5BUmxQcWg5Wm4zYlFtWFlrd0hCa041aFd3VmZkdmR0?=
 =?utf-8?B?eWN2dVQ0RlA0QUs1ZGN4UGwzSVg5ZFRiU2x1SmlYTDZIcitOVENwOFB0VlZF?=
 =?utf-8?B?VTdNUTJMek40aGl5VktmNjF3U3k1cFNHMFgwWUNkVTRuYXdpU1FBcXo3RUVF?=
 =?utf-8?B?ZEhhdE5jRXNiRlEvbHlxS0JkRHBPUk9aQWphVlZaeStCR1dmUXhMckNKT3JI?=
 =?utf-8?B?MG9KRkxuVTdUditmU0N6c0tGS1ljVWUwQlR5a28wTFZ5YndQcFhYNUI5U1A3?=
 =?utf-8?B?VER2bVFkbnJEK2xuMTBXNml2RTBUcnBNcStvQ0dYcWlmaHRMRzJCMmNFTTEy?=
 =?utf-8?B?bCsyaU8vdWlFUDBtbVRTbE5PT0N3QUFyeC9BbFJSWXppbnhPbWhQcU5QQTZj?=
 =?utf-8?B?MTZyaGdnSndxUkh5S2pnK2F4aVdCQnJsQVZna1ZReVZZNTJ4N0djS0VseS8x?=
 =?utf-8?B?b290Q3dnajQ2ZWNwN2g4UTBid2dRZGtwa2dOYzAzbzBkbmg5UTRNSXNWbkdE?=
 =?utf-8?B?ZHRWa3N1TzNKTkM1WnZWTUI0ZzlKd2ZmSmI1Z0N5VWxkeGovYStGNWpxRWdV?=
 =?utf-8?B?Qjd4eEQ1WWYyeHFEYWxQb1gwY2kxYStFQlNQM1V6OEZCK21oR1IzTXN5N09I?=
 =?utf-8?B?WVRkYWp6cjA2MUw3YkdOSzQ5QkFLMm92dnVNTWx6Ry9TQmp2NjllV25PT1NJ?=
 =?utf-8?B?TUtMcXI1M3M3dzNwdWJpMmlTRU9Xajc4MUwyYm1Eb0Z6eWdnbkljTS9lZDlZ?=
 =?utf-8?B?WFozL0Z2YVJHSTNrek9ibVkvZVVqU2h5Ny85Mzl1Y2gvNXl5UzRpV3VSQzVR?=
 =?utf-8?B?c3dOSTJndTlERHorSUI2T2pYbjVGTjRaOWwxUm1mU0RCcWhzVzIwWnJoZVhD?=
 =?utf-8?B?L29QZTFlUFBrbkFud0Q0UUluc3VwQXhtK2Jsa2I4VjZCMGFoZ3hkeU9aVWxF?=
 =?utf-8?B?dWpHeVZpVUhWSVR1LzFuK2NhV2x4QWkvU2hKR0dqNmFrSG0zSjhYbmJsdDlB?=
 =?utf-8?B?MUVIUmwwbGZsRE1lUHhJWm9nS3lQSFF4TlZnNlIxOXcyTHo3U3JPaGlmbnJX?=
 =?utf-8?B?NkdRUW5uL3A0ZUU2UDEzZFMwTFVWNW9tMUl3eFJKY1JiTzVsNkg2VUt2eWpx?=
 =?utf-8?B?bXhLSHJnbVVlaWorTE04L0ZkcXAyK2tHemlFY0krZXN5d2lkOGFReTkzT2dX?=
 =?utf-8?B?TllIMnlHMXR1Um13MkZpeEZzZlhoQ0JPMnJCLzIwYldNN3lOSWo3RWtKNnBF?=
 =?utf-8?B?MFZjNzJoSWVOS2REMVEyc2VtS1RHaGxtZTMraXRNMUpnaFlrWW1RVWE0OWZi?=
 =?utf-8?B?dFhPRVRtU2ZFbFpWUkE1eUhEWmVVeGpSRXhSOGFRWDFzNG1oTEdSZVJ6VDB5?=
 =?utf-8?B?cmdJaHZGNVdESVpwOXZSK3FES25DYnVZQThoNUYrb2NkV3pOME1Ud3NCMGFx?=
 =?utf-8?B?U2FCbU5OZGwwZUJNWURwWVNoejB0OThtTm5LVC9XMTVPeXFWQURIcGZiaSs2?=
 =?utf-8?B?a3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	41rMb/MxpxERrNnC3UaiBOoqP1t3P5N/QfmZvBI6y4MObcavskTP8Pjhn7w6JNbysMjAppVTfocPJc4B6VG31c+G8NLOGwXbuPAwnGlfHF7lOzO4Nb6ul4rDcIwXU6ekf1qLhnmEWNfnKJxeZQ1MHuH82PfYkDkfPUlgwFJ4B7aFJFvLK/fB/ufB9nEMqMb0lI12iXvTLmsBu2uXF704da8MsQJDg//+pZgH5PBftP6ZGIT3uuTbB25NeOB5lemmB4hGF8B6fSr+ywbs8fW/dLfslc/bizO50X2DQzF3VWMqIj1loVyQPmA5TE+ndJPMKUy33sIJJbPN8aDneB2eekCz6229FJ22vlJ3PPUksntlwIwIkVNwMWi2ZkJeU31pO77OMwTTgRhkegHnavlE9h09tKs2BwPU8EFkoqjI/vifRU9V1rsMK3A6FSpH69F1OtOcmG1QtC2dtjU9rJle7TOJ31hoGH0nWo98j+86ZjFeoDfRgpP1VHUbUD6SlYk9EQtM8mb1mnDmqyLy7jrvLfqb5nDhdu6VSOydrhgWRE+4GchysIxftsEVV5Da+XAACZYmIykVRnAWfcnDDBR/ppOOwU0LUDdOvYViM01bgCs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fc294ee-6c1f-479b-dcd3-08dc897a38ba
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2024 18:22:01.4753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QTZjUOD3qnQ4E0pawdSsz6lstAvS64BNTLALAYcQ5pbAwYBEtX+on4uXEAVXI+tdJQFyLO6j7BucbJBVRhsTzVl8P6bONZPA1OcmVguJVp+1AEHhsr+xqeJmnL+DmIMQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7906
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-10_04,2024-06-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406100138
X-Proofpoint-GUID: SXpQqxO7VXIjIZaH4S7OmlEr7MZMFIfD
X-Proofpoint-ORIG-GUID: SXpQqxO7VXIjIZaH4S7OmlEr7MZMFIfD

Hello netfilter developers,

Do we have any tests that we could run before sending a stable backport 
in netfilter/ subsystem to stable@vger ?

Let us say we have a CVE fix which is only backported till 5.10.y but it 
is needed is 5.4.y and 4.19.y, the backport might need to easy to make, 
just fixing some conflicts due to contextual changes or missing commits.

One question that comes in my mind is did I test that particular code, 
often testing that particular code is tough unless the reproducer is 
public. So I thought it would be good to learn about any netfilter test 
suite(set of tests) to run before sending a backport to stable kernel 
which might ensure we don't introduce regressions.

Thanks,
Harshit
