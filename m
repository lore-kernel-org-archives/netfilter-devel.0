Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784252CCB7;
	Tue, 11 Jun 2024 09:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718096413; cv=fail; b=EjX1rCDIi0S2WLtZBHHTvIMrTiUfHZEKKyPm+6B9dY8CaOUGy36Jtq2TijpCrWPYFPvaORNQOWmmvCPwtPE9uaInNwRXlRRxpJhRUtZjgifOsahW/d//VORe9iII2tVXtV/kGTwe7SYIGko5DGisH+z03XFiHx09NmsSF8OiCbU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718096413; c=relaxed/simple;
	bh=a70rQXCnWFQ1B3r+1rJ9/DpnkzCaeIKANhzYRrR2vIQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Z+Aztg4ImF9BMsYjAxckCKhEAVNkSNH1P9JjWvrnhMH5IJkO0jeq6hmRg2DsuQbQajrY8w8Ed671dCwX5e4V+/jK/AMvC8J15GXp5cFxWJBgBQyl+NIEKHn/G9euFzQwnffgXW2FIN7e5MYdFF/NylJHgPHzwcMvyLzyv183MEs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FKalYr2F; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Gxowbmq/; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FKalYr2F";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Gxowbmq/"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45B7fWLM011740;
	Tue, 11 Jun 2024 09:00:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=u5wpQ+h3Pm1NwyNsQ/z01s2AXSJGi2mNz4puP2QGu0Q=; b=
	FKalYr2FAPcSwR0v8LAb10D+FX6TlEbo5eO8dv9BQyZMWzN210frCjOjWyztzHP+
	w7fM+/IGDHyCpeNX7dKIUpwc45u3SvCeN6QOImRJzcoP9o/8iBQJefGrSPnXFya8
	fzZTgOjT8FqtRbL+5WazL9lHJozDvqZh13jkSN21CJXOyC9dBu09dqhFUysFM/yx
	A+LCA4lE4xTt/AAu78+FUJSB6KS20yovlaiObc1PyKXDy4xlIT7Z5iMaFuvhnHDS
	5iZZA5yJLFN7stLaNa+QjOxfEQpEcdgUoOf0XUxiY2+eJEW2k9BvwvyT1BGR3XIa
	MqwAB2WQrDIJTWhw78mQtw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymhf1cbj0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Jun 2024 09:00:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45B82518036558;
	Tue, 11 Jun 2024 09:00:07 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2044.outbound.protection.outlook.com [104.47.55.44])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yncdvxssy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Jun 2024 09:00:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W4qe57RbW7XQPVOBFSCYVQZL1JqPFD0tm377N1VT5d5WexBQxJAgujFOfYL234lQYLWrsrXj04iOefZMHX5GBbmz6fUe4UF/dx6qLcta10FBKJ96m21NSvX8Vzq2YBG/QnoqpIHJRG0x3JkzE+sGVLy4o++mk2t+85bDxBCL9Sbk1MFcpqcXjAfHHeKGVJzdGVHYHifW1fIpS4o36UfQ6zKXilWSp7sOgGse9acA1nm/9kX0Pv7P8iOdOlDrTO2eFS7GOeOu2JJb8Pgm3hCbR0Fjdh/HlhT79E/yuOWEiE1exg/5eumk0HGoMaZ5xmLnimSz9NQBxC7Vhqiybpyqtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u5wpQ+h3Pm1NwyNsQ/z01s2AXSJGi2mNz4puP2QGu0Q=;
 b=TeVusKGZpBpF0pVfLODwrJYIuygOTquFUjt92By+oG2Tt1A7OPIGh+8WfjAWHI/f+0Ovlrup0BBpHqrFDjR6ogESIz9UAWBesbzyPRFaeu7uHRWTw+EdqBuCeDRYDqWZFWIYA3affOrQkGVq3Po78uQArjSW4aaUrHvGai30xFiex21XNh+28bqPyOO7Wnpb7A3mYgd4DUCxbQPTmwRWaLhhmlS8nr99Be6wglTeqm18yclL3c7wvAd8JPbWiKUpAdNDWcbbONurWqsjO3n7rVCi+jQPt0Sii201J7sylF05yXi5JlEn2sydnis9IAUYbAVhEsh0BHfWx1ZTV5PaUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u5wpQ+h3Pm1NwyNsQ/z01s2AXSJGi2mNz4puP2QGu0Q=;
 b=Gxowbmq/wuYicBoHdPjAqd6/I0btUsm/9javWPcqbPi5xQfZLbxHFiiuS10/k1T0FKo1ixhuQhLfWfD3kNF+n/G+Xjmg0E3UsH/eUyQFJy5X68jFJflQgmpJ7SHDQRkwtubDXz06OJJbl0E+r9z2UrIVWbkvEmFJRku8YhaL7gc=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by CY8PR10MB6586.namprd10.prod.outlook.com (2603:10b6:930:59::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Tue, 11 Jun
 2024 09:00:00 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80%4]) with mapi id 15.20.7633.037; Tue, 11 Jun 2024
 08:59:59 +0000
Message-ID: <a4cb3a2d-5238-4086-acad-f80fb06d2488@oracle.com>
Date: Tue, 11 Jun 2024 10:59:54 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: Testing stable backports for netfilter
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: netfilter-devel@vger.kernel.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <652cad2e-2857-4374-a597-a3337f9330f0@oracle.com>
 <Zmd3XaiC_GiCakyf@calendula>
 <c3789a4c-f262-444b-8234-8431cded548b@oracle.com>
 <ZmgNr0y2gCR4YW_K@calendula>
Content-Language: en-US
From: Vegard Nossum <vegard.nossum@oracle.com>
Autocrypt: addr=vegard.nossum@oracle.com; keydata=
 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 8A==
In-Reply-To: <ZmgNr0y2gCR4YW_K@calendula>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PA7P264CA0389.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:399::24) To PH0PR10MB5433.namprd10.prod.outlook.com
 (2603:10b6:510:e0::9)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5433:EE_|CY8PR10MB6586:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ccfb7e6-e8d3-46fe-af92-08dc89f4df7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?L1JuSlVwMDF6K2w0QWNIbnRCdy94WXBwa2JHcjY5ZnVlU1l6amdpWnBGYTht?=
 =?utf-8?B?SHRtN1h0ODJ3RlZDeWtkMGZVU0VjSXB0akZyVnc5RXNBUHg2OEU0cEwvOFJu?=
 =?utf-8?B?cEpjbndvR3VuVUI2dUlNODNXdURHVWVCMy9DeVR6LzlqZTA0R2ZpUzNFZ0dQ?=
 =?utf-8?B?MU5hUWtWdTRoZmxYTjBGclRZeUh5d1Q5K1BHRStkem1oaXpEajNOUzZDdEdu?=
 =?utf-8?B?UTRtK3poV0xjTlJ5Mk9vSGFYUkVVRXFPMVoreTc4SlVLN3JLSDRyQW9vazEv?=
 =?utf-8?B?WlI3eGNWZVBRaVFvYmhod1c2YmVVeEhMWHk2bUkvM2JFWEduWmNGS2t2Q3BK?=
 =?utf-8?B?S2Ntd0NJVTdJb09lSElZa2hwdE5TZll6d1NxVWF5NDdzcjhpdm5kbmgrTXBJ?=
 =?utf-8?B?eThtVnkvL01RWnVVelZEQ1hDeWlrRWxzSWU1Z2FlRjZLMUxMclRabU1HSzlG?=
 =?utf-8?B?OE9NWUg3bnBNYzloTk93NzlTakZkNGpsMzFVZ1diWk5US200Y2lLbm9jVDVV?=
 =?utf-8?B?VWluT1gxTHl0YVAydzZkUHZEYmNibi8zdHFLY2JvS2JuVXZmZUxyRU5JMDZW?=
 =?utf-8?B?cnB6bDJDdEZuRENubU5jbHJFaWNXQnVvUXp5K2s4OVZCMmtQQmZ0K3RNYWhw?=
 =?utf-8?B?YllXWmt2bXU5cnVzcXZqYjJ2VWtseDIySHpQYjF3Tis2aW10aHJEdDVrTHFz?=
 =?utf-8?B?VUVzUlV2TVF4ajE1MDRFVzREU3BGZkFJQ0ROTUcrN0JDeC9rSXZKMVV0VmRv?=
 =?utf-8?B?RzA4TTJ1dWxHMkpseDFvRllDRHlreHpCemxmcTZqSzJUZ2ZMLys0L2xKckVQ?=
 =?utf-8?B?S2VONkNCdXg5QUlEU3k0eW9tSnV5WUJlRGtxVnRSZUpQM3BieGVkaGVrNXRG?=
 =?utf-8?B?ZmJkTm1TNVhxd2pJWDhQWFE3MkpybWkweWk1cHExelpjNE1LbWQ2N1czbld0?=
 =?utf-8?B?TUZqQ2RRSnp0bHRzbEtxUExlb2toOEJYUDR3VTRlOFZCTzN6UG5qRXJZYkwx?=
 =?utf-8?B?VnRGL3QyR1E1NllKWC80TzJjKzhZdjdvRElMb2g2L012K2M4Zk5vbXViYnAy?=
 =?utf-8?B?NUlyNzdJRjhPQiszNUtJMXBieVF0dmE2dks2RUNNOFlxcVJQVEgyenpPZGVj?=
 =?utf-8?B?R0pWNUl4WE1CZ1NQTEF4UE1JcFE5d0FqTGg4T3RKbWxkcGRidXVuOUsrdDVv?=
 =?utf-8?B?VlFUcFJ4YkFSY2lkbjhwcFdzMXpheXozN3VyY0dLQVllb1Q5blRXQUdMaUxY?=
 =?utf-8?B?dzZuRVpaU09OVU1xMEk4WmtLcDY0Z0pzZG1NQXFhMEhsdWJqMm9XYnZzeVFX?=
 =?utf-8?B?bzJBSDcvbVg5L0hCYVVzZzY0WnZBb0lIaHo1Mzl5NnNJT3NiSTN5UW9yWWp3?=
 =?utf-8?B?OXVjc1lINm55VkV4WTFOL1ZxUnBzd0FMTXVmNDlsTm5QWEFJaXRSMGVkbjIv?=
 =?utf-8?B?M3FBbzRxR0FyMG9OZFY2VEpSMW92bW80ZVU3QW02R2dvdm1QdkgrUlBqZFZa?=
 =?utf-8?B?OU9VclBncHdob0p4Y3hEVUV5WHFsZ2FDUkZtVHFkSzZWYWpVd1NoYWhxR2RM?=
 =?utf-8?B?eEEwWFhabFl2QkpGU0phdksxbm5PZGJEY1luMXFVNmJaOGk1cSs2TWx0V29L?=
 =?utf-8?B?VzNNS1BTYTd0ZjdrT1dZYXphU2REV0MvSXNRWGNMaXdEZlF3akQ0RkZ0Myt6?=
 =?utf-8?B?KzAzK1YvTUpvdWpqakszNVZobVFiZG14MU9PcytVUnlFeTQ2bWdDMU02dmo0?=
 =?utf-8?Q?mYMm0dFPUux7vO/4DXY8sIfW70GYt85cgAZfwaQ?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?SFFIb2s1eXU1YXQ4SUs2N0lsc09YOFNkVnpVditmZDdmeTBoa2xmdTZsNkNW?=
 =?utf-8?B?V3V0Y25Ld1J1Z09iM2k0eGJEWlpONWpkWlNtM3ZYZkhqU3lraUN6UDlaZ1Uz?=
 =?utf-8?B?RWxhRCtMS2NieEhCNGMrQStVdHVCK092S3U0RE1vTkM0U3BRU0Nta3pIMEx1?=
 =?utf-8?B?WGV3R3dPamQ4QmUrZ3YrRFVxUlVaZmxEK1VGcWdtNUNtbytFOU9OdkhBQi9w?=
 =?utf-8?B?RUpLVXF1VEk0Vzg4N2ZSbTVsejBSZ0Jic1VnMUNSKzJnL1pUOG5HdlhTMitS?=
 =?utf-8?B?dGZWME03MzhNeHhJTnpMdk5FZjZzaFpHTlpWN2JValBrSHUvc2NST1dJMkVj?=
 =?utf-8?B?WmxKRkwwQTRud3pGS0pTNlJnUFN0WFNPZjVBWUdDaFgyazRualEvbjcwSHMv?=
 =?utf-8?B?eHdLcnh3NU5aRlFVKzhuQ05mL0xEVVZGN3VINmI3U0NaNkRKZHBGc29IWlNo?=
 =?utf-8?B?UVRWRkFVY3Juclk0UnJ6R052S3NzUGhNQ2N3cmtMa3hJcURnVURwTmZ2UWJa?=
 =?utf-8?B?V0RnVWhldVFFVnc2MkprektNYkRhbXQ1cmhma3I2eWd1Z2tTaTNxQlBaL1Bl?=
 =?utf-8?B?S3g4bkRPQ2xWRnJ1aElvbEVTMFJqa0VvWlY3SjUzVUF1T0xuMERqcVJ4MVB3?=
 =?utf-8?B?bUhuelVaaE9WVTNZWXRxVWtJS1d3T3VWS29IYm1NbjRUY1BuaktBVHJIL1Ba?=
 =?utf-8?B?c1R6Ukt2dlVGbFFJZnVLcEpmQ0lNMWRYYWhsNE4wTHZKMVMyd2tGQWFYRlZF?=
 =?utf-8?B?MWlKUWVvK2xDakwybndDUkg3QW5McmcyTSthZHBXM084NlpDKzlLODlmcjF4?=
 =?utf-8?B?cHVmL2p0RHBNNWVCWXNDUVpudkRwNnM1aVo0aDdCOHA2Sm8wS09RcmJ0bk8x?=
 =?utf-8?B?emQwN3EyT21XOVZDdWNrZFlyOUppc09na2lyRjhWL1FieVJCTjU2Z01rb1No?=
 =?utf-8?B?RWFkbTlwM2RDZHEweGJkT1hxcVF3U05JOEhIV2tYdHpnMjhCRDg5M0ZhZlRV?=
 =?utf-8?B?NUgwNjNaNFRCRUVYdzBmNWhMREovWFkyRzNDNVNoUDZlQ1BtWlBmOUVoUCt2?=
 =?utf-8?B?U1NKV0VaY3BzV1hjam1ZWk9nN01UcjM5dFlucERONDl6V00xKzZORWNOQ1pP?=
 =?utf-8?B?ZlEydlJJcjlTQ3djbnN6blZORGhBajVmZlBoczdqQU1Ua1cvSWVzcGFXM3Vz?=
 =?utf-8?B?MlpNdHVsNXJJb3VXc2JUVGZDdUYvdUxTaVFDdzJGN0I3aEhienU0RlJ3NkFl?=
 =?utf-8?B?NzNBUUw2MTVkMDgxa2k1VU5ic1BVcjZDV1U1RUVVSlI4NjUvTFJHK1g1dFZS?=
 =?utf-8?B?Nm5wZUQyUGVLa0Zqa25VWSs2MCtXdTM4RmU5VENMZDFtUmQvMWhwaVJ6ZXRr?=
 =?utf-8?B?U1RmTWw5TFFaaVJ6cks4L2s2YzhaUjl4TGJiVU14OFN4K1kzOE1uNllVTGUw?=
 =?utf-8?B?ZklQVWNoSmgzUVZGR2w3cUg0ZEhEOXhCNFY2UGZzSGw2TTVtYmxTMDBtcWhr?=
 =?utf-8?B?NHJwK3JvQVI5REpkR3JxMkVHbGY5Y2J0V3lJV1VUSlJGRmZZQ1hqdENZNXZU?=
 =?utf-8?B?L0g4V3BVQ2ptdkVqV0xpOG5LMHZwTHJMTXl2OE9UaVJMZlRFSFY3UDR1MHNR?=
 =?utf-8?B?Rnp3MkZwQzY4ZnBiWEcxUytIb3VaKzJ3VFpaS29jclNvOGk3bDVCc2UzektN?=
 =?utf-8?B?bGp3M0UrUzAxWWFyREdVTDNXLzNPcmtXc3pSeFVwY29QbXVsN1Zkb3BBQjRJ?=
 =?utf-8?B?RlhBYWZReE51UUkyUDB6RnZMcFl5Rm9mRXhiS1ZabU1xbTk0RnFSUzAxdVNy?=
 =?utf-8?B?MkpYSjJaVHM4aHdTbC9YRUxRMHVudEFmeFF0ejhvRVFNVGRCdnkvd2c5N1VG?=
 =?utf-8?B?aTJYaGZaTHlkSmd2Z2pBUU5vTW1tN2hsZ05nUXdoOXkvcm1HODhxZE9HUkg2?=
 =?utf-8?B?NE5IQ0F4TGZvSTBWUXI2MWl5NU1GWUE4ODE3YTlEaE5uYkR6MmpoYVRzd2FS?=
 =?utf-8?B?NGtQS3BUc1dqS0I4dURHa0hwd2FaNGRMZjI0eVlTbkRKYUU5ZEtjSDdHdlZl?=
 =?utf-8?B?dFVJQ2FLVENCQ2FHdjZkakF4UXk3dTljNExCbnFqZE8wb2xJY0VQSVE2Z2FQ?=
 =?utf-8?B?T0tYY3VuTnh5RmRGcUQwQlRyRUxaQjFTVjVuN2xITWhSMEFFWmFrSWJjdXk4?=
 =?utf-8?B?clE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	ZagH2yNGpgzP6QuNvys68kT0mJyYT5D929ew+CmuoGnzi4nhR1E14QeaTFSZKE55B9fqKN8KbfB0/XlJTf9qA8snkm+0GSFlZDJFT5Zqp2ckgYsi2Jl3VztCI2M7P/nkehpXEhA2Yc23nrE0S1qpBsj0PYuzN/TdQakJDI3J+dJH4TcPyTCEZRP9IBXI1DIm0H3hK55GMHB911r/6wzGavk+onQpMywY+giAb6folFKTw310VQHZQnWFivmWlXnOyE6Jlz/q0lhzcC1Cro9e6UUwgVjrBhUuhbXcxkmf/G5Ev3cxa1+IWRxJzZTKf29mZW2GoAjvvlAFOf0v32w/3FDccZb+7Bzec4nZiQr7t2tkql1PlAYPt3+YfO8qjpTXAa5FYqi274CSGeXGJHMEygLiddhwHjDBQ3OW4+3OD2+mMi6aNCHUnXaAn6nBBq2fgEU8TjHLq+N3INqcvvtB9GiANeZ5z18ueY/bMBQUcoMm3z8K6vk/xBkHVZTxJ/d79EBYMKnbxxgyGw62g70rV3OPDGQrhFul592DPlmalscAOWUlP3+nQDBwsW+u+csvLoHiftCVX6s61Ogpm7Jja32LtlELu1Dyutxm6JNEDbc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ccfb7e6-e8d3-46fe-af92-08dc89f4df7b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 08:59:59.6632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FaKOgi0DbS3WV9gzCwBq8443HtT1+WXxPbr7w1qoEW0KtAhaGMTdewjAd+/HxExWkc9ci5OdX+t5Ztp9r/1P3AIneq81mAQhrt72UbTpr5U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6586
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-11_04,2024-06-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406110067
X-Proofpoint-ORIG-GUID: GvIYr3utDKJU8L_xZKRMoW-2z7hf8Yrz
X-Proofpoint-GUID: GvIYr3utDKJU8L_xZKRMoW-2z7hf8Yrz


On 11/06/2024 10:41, Pablo Neira Ayuso wrote:
> On Tue, Jun 11, 2024 at 11:28:29AM +0530, Harshit Mogalapalli wrote:
>> On 11/06/24 03:29, Pablo Neira Ayuso wrote:
>>> On Mon, Jun 10, 2024 at 11:51:53PM +0530, Harshit Mogalapalli wrote:
>>>> Hello netfilter developers,
>>>>
>>>> Do we have any tests that we could run before sending a stable backport in
>>>> netfilter/ subsystem to stable@vger ?
>>>>
>>>> Let us say we have a CVE fix which is only backported till 5.10.y but it is
>>>> needed is 5.4.y and 4.19.y, the backport might need to easy to make, just
>>>> fixing some conflicts due to contextual changes or missing commits.
>>>
>>> Which one in particular is missing?
>>
>> I was planning to backport the fix for CVE-2023-52628 onto 5.4.y and 4.19.y
>> trees.
>>
>> lts-5.10       : v5.10.198             - a7d86a77c33b netfilter: nftables:
>> exthdr: fix 4-byte stack OOB write
>>    lts-5.15       : v5.15.132             - 1ad7b189cc14 netfilter: nftables:
>> exthdr: fix 4-byte stack OOB write
>>    lts-6.1        : v6.1.54               - d9ebfc0f2137 netfilter: nftables:
>>
>> exthdr: fix 4-byte stack OOB write
>>    mainline       : v6.6-rc1              - fd94d9dadee5 netfilter: nftables:
>> exthdr: fix 4-byte stack OOB write
> 
> This is information is incorrect.
> 
> This fix is already in 6.1 -stable.
> 
> commit d9ebfc0f21377690837ebbd119e679243e0099cc
> Author: Florian Westphal <fw@strlen.de>
> Date:   Tue Sep 5 23:13:56 2023 +0200
> 
>      netfilter: nftables: exthdr: fix 4-byte stack OOB write
> 
>      [ Upstream commit fd94d9dadee58e09b49075240fe83423eb1dcd36 ]

Right, it's in 6.1, 5.10, and 5.5 -- that's what the list above shows.

It still seems to be missing from 5.4 and 4.19.


Vegard
