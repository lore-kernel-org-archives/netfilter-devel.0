Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC9D1BC9F4;
	Wed,  7 Aug 2024 06:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723012953; cv=fail; b=TP2ZyptEolm4WaqNfiMRUKg6fSJ+N9O/5fIqQ9qm/9A7WhT5fgjwpoHha9mmNVt8qZ4PK0ex9lo8ZsVnd9GPRaLT/qMjNRtMP72dW6cxIaLbvfdGmFpTxdVZ5t4ZRqeTrE1mvIEfE8f42RJHPG4pjC9l5Mb3BiE6fXUPVPu4PGE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723012953; c=relaxed/simple;
	bh=rj3bf7FEgvadgMwX4rnY41wAXhpPFN0zHNF8JsRJJLg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:Content-Type:
	 MIME-Version; b=tJjluk4ZknnVox7CEFqIEuUKNViQnScX/gacW7vgvu32p7D8gEuAp5y1HxDfD5uHiwPiMY52UT9zSfe06vnISlugoi2O1eIV7cQ4uP99ZVCKRFDKBHml4TCTRlFHVdKWuIB18k/8JEVq1aBkgwMFSu+LJFtw4hjqvmOkX1WoMPI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=St3nPy8p; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QRVbNbRj; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="St3nPy8p";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QRVbNbRj"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4776BZTG023477;
	Wed, 7 Aug 2024 06:42:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:content-type
	:mime-version; s=corp-2023-11-20; bh=A4MboREmlkevyiwi1o47vtjPZ8f
	SHzkn4B3YXLxAqpo=; b=St3nPy8pS/4kXWu9EH4JJjYVxTIbMs2qAerNYsptVvG
	VONsV29E22rPXpyoZfZF1yaMSYJ6E0TyXYCkv8qRFq5dw6bQz78PW+Ci/duM4kS0
	rIEUM3Z6XQzS2TqK38LYfOqzqv1fjcEI39qKPh0oe5JaiJc4qECw7QuvwQBVJzWn
	xT0zTdyjh0es9EGqU3JK6qWYezi6+MWBtsviMeXCewrpEFOKIUZPBbEMayBTXgIb
	0VATrXfXen6v0yE+FLeK2SQbJr43MAyhcwUej8puLPzHoUxzQ4SctUFCG7DQtvNd
	oC3oXSAP/eS+0BLz0v8hYwO7pKv7RHr2XIBr92zYaAg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40saye6vw2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Aug 2024 06:42:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4774Lq2e018391;
	Wed, 7 Aug 2024 06:42:17 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2048.outbound.protection.outlook.com [104.47.55.48])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40sb09mjqf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Aug 2024 06:42:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ViBZJuReUIGQMY3D+wK4WWV2yVr+wVPydy5DpWs6EMhP4NJw/g/FO1PlSac08d/wPt1XEMiQ0zA2jF43784952beo+6O3GDOveCDr4B+NPHgvtIHyA5EbJL3FcLRfFA1/sO2aXmiL8JoHHfvFjjG1IJ/u81vHsRm/a+KbXi74XZHvalruQEiLFwb9ZGa7KbtLsC5gR6w8TzBL228Z8AgZkNuyusFKopJF6ItTtucz+kK3Qrwzgb5WSqXbF32EMHpvlNpBUwZXEPnacbhw9C6WxzQjWIiddvcebsGNn8ieCt2/TvOReZNhjNzEFHsZzNVC2AG+bZkjUUYXLfxP8v1dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A4MboREmlkevyiwi1o47vtjPZ8fSHzkn4B3YXLxAqpo=;
 b=uSjYomr83zjPvrflOycXb+XAXVMB1bxffuYFL6xfkSjpmPCsyJeZZXvkqpmxjocOO5REv7akciaEIzEnIR+qqObo+QApGedGpE13ePiWpIowLqA6qDgM0G9ozLB+l5MLh9rZW9roUmOYBmkZiwAKhPgi9Z4uPQpqgVYdTVZwwoAxQUV3OVwh7pTmio/3p2qP5eD84mHlMcd+1gZHpvEC68ldqmdOmmypXD9Ga0Sfj5WLGdAom90D3erF3mp2/snb6FZREIttJJjZ1lItj+SCB169k6asq15QHwI7BagLrDTuS/NCGF4pznBX0StuBrFdde62wfA2welphKDF+uWKnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A4MboREmlkevyiwi1o47vtjPZ8fSHzkn4B3YXLxAqpo=;
 b=QRVbNbRjSBVBwD+G0g0rsJxaTSiitaVVK0x50MggXpA56GQ1p8L2G7FjqM0rBBIpl3+K9lz62ZikozwaQf4L6CXHSpJD+McTUIVQ6vgWCMeKBPx9erzZEsUf/nn6zdt8Vlh51n4DSRwTPq5EbxB6iIGywxxEBrm742c6qfZkGXI=
Received: from PH0PR10MB5563.namprd10.prod.outlook.com (2603:10b6:510:f2::13)
 by BLAPR10MB5123.namprd10.prod.outlook.com (2603:10b6:208:333::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.13; Wed, 7 Aug
 2024 06:42:14 +0000
Received: from PH0PR10MB5563.namprd10.prod.outlook.com
 ([fe80::1917:9c45:4a41:240]) by PH0PR10MB5563.namprd10.prod.outlook.com
 ([fe80::1917:9c45:4a41:240%5]) with mapi id 15.20.7828.023; Wed, 7 Aug 2024
 06:42:14 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "pablo@netfilter.org"
	<pablo@netfilter.org>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: CVE-2024-39503: netfilter: ipset: Fix race between namespace
 cleanup and gc in the list:set type
Thread-Topic: CVE-2024-39503: netfilter: ipset: Fix race between namespace
 cleanup and gc in the list:set type
Thread-Index: AQHa6JTwmTFiBQCbo0es+aNWmXIFLA==
Date: Wed, 7 Aug 2024 06:42:14 +0000
Message-ID: <c44971f608d7d1d2733757112ef6fca87b004d17.camel@oracle.com>
In-Reply-To: <2024071204-CVE-2024-39503-e604@gregkh>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5563:EE_|BLAPR10MB5123:EE_
x-ms-office365-filtering-correlation-id: 37e2e6de-3d4a-431e-cf8e-08dcb6ac12ec
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?TjlHQlYvbU1KdlZQZ3NUWUs0TWEwNSsxRlNPdGZhcUg0MExOMnJ2QThEeVVh?=
 =?utf-8?B?bFV5UkRKdjc4TmVzd2lhWGo1Ulk2VTQvWnMrRXBSbHl5SGV6a2ppQTZCaERP?=
 =?utf-8?B?SHBWT2M4VnFrRUdXL01Xc0xzQkJsQkNFNnhoa0JlSHpaTXVYZDhDbVBIZG92?=
 =?utf-8?B?T2hORUlKVitERnFyZUF6dW1RbmdlSHg1blpWYjFDSDF0bGFTVzRpOVV0YVhL?=
 =?utf-8?B?Y01oOGkzQmNjdUs5dUJMeEhMRDFzdGNLbGI1aFV5dVdnRzEwOGpNSVo5eGds?=
 =?utf-8?B?THh1RFhKb2dIRUpYcWFELzZta1pHdUhHSk1yKzNzeHhjK25iWUFJa2tmYy9u?=
 =?utf-8?B?dzNZTXA1Z3ArZURTWkEwR3pVMFg0M1lPZk9TQk5JY2NOZXpDZHlLQkF6U3Zy?=
 =?utf-8?B?L09rcmlMVmRWVVhzNTQ1L3hJZ3ZRL1ZIcVB4eENKcThSZ3kvNTBmeERyYjVQ?=
 =?utf-8?B?blpLRVU2ckxldXhDNTlDVDVNNEYrOHNuM1YwMk9hZ2xyc1BERVdMODB6Y2Va?=
 =?utf-8?B?eEk3WWRqWEhONWJodW11UXNTU3Jlem9LbnJGWXUzR3JublNVaGxpajNlTERk?=
 =?utf-8?B?Z3A1bXp6dHl2RTd3RHNtUU90QS9yMVpuaUxMcGhrcUpuUTBmdjJqZ1FsdVJI?=
 =?utf-8?B?bkptSUFLeU9JYXNlWlgyeEdodG5RRDdqOC8vdGFIRk1iRnFHWUQvRUJSUU42?=
 =?utf-8?B?SFdOMWhmS2R0eFI1R2JEc2RUVzlCQXJ3WkVGa21OVVJmcGcxLzhrVGhYY3ph?=
 =?utf-8?B?SWg4dVB4TFBXR0Y5ak1aN3JIWXFTRXJ1b3prdlB1UlJpaElaYzJBRnBLUnUw?=
 =?utf-8?B?TkVNUVNuUlZhbXdnVktmeTYzU0tDRXlMNjd4YW9XOU5YYmZta0ZYOU9SbGt2?=
 =?utf-8?B?NVBLblZzLy9BblgyZVFyTjB5UmsydFNvTnNUa2JteHZmUDVLOU5lSHdVdzZp?=
 =?utf-8?B?RTdUbktvK2JIU2xBcmh1aFdEa1FZMmgzR0lEZ0tHZUY3cHcxZjV1QlIrTjV0?=
 =?utf-8?B?YmpndUhWVVBQNHpPSG5SNXovZDBIV2FOazBxQVBERFNwSDBVRDhUanpmRzF3?=
 =?utf-8?B?N1dZSzhFTW81UTF3MVZNUVdQUTg1VzZ0aDdvTTdwZzVlM1dFOUJCTVk4TWIv?=
 =?utf-8?B?cU16LzRVM0Nyd0Q0dTFYNm83c1lFZnFnMVJpK0x3U2xQM0pFZ2pXZW5KUWVh?=
 =?utf-8?B?TXpacEJRNEtCeDRRK25ZaGlBa0dha3hMSFpUM2c0K0pEU1RLd2RiMndDSDc3?=
 =?utf-8?B?K1JlQUMrYWxnYnl0TVZVcnd3Q3UwcUhEYkxQVEo3cmxVRTMxdTgvcHpGclNS?=
 =?utf-8?B?QUl2SlltcDErVGR3STljV202dHVLUTBENDM2VW5GWnpLNVZiajJVLzlSSktm?=
 =?utf-8?B?bEI1blhIcmduWVZUakdrb05EY3FLZVJwaEtBY2VqVCtkMnRDczU1S1NhNk9O?=
 =?utf-8?B?dXVROHBtSkJUYm5CcWlhMFNrZkw0VTJSRFllNG8vWHV0U1dXY3RMWVNGNVli?=
 =?utf-8?B?UXJwQnMyZklDa1NaUCs2N2hkeVl1ODhUVnpneTFjc1pqQmZpSG0rZXFtZjZX?=
 =?utf-8?B?SWhSOU1OcG9HbndCL2pQRlhrS0tmdDlxZWt6R0pob2RVazZxbWR3eE4vNWhB?=
 =?utf-8?B?bmx0VWMyQnZsZGw3T3BxUnMxT2w3cUJnbXBwdmwvK1ZCUGtXNTZtOWtPSFJ4?=
 =?utf-8?B?NlQ0ellRY1NMbWRnc0RReENuQVlENFhobis2TXU4cVpUSHJSNWtGRy9qRlBq?=
 =?utf-8?B?Z3cwZlh6c2F3NUdZakdCUFlKNmZobTN0TXczd2dJY1VPWmcxVXdmNzNFZkVR?=
 =?utf-8?B?ekZpUUNCemsrTzVUa2xkM0RRVXM2VE0vS2U4bmxybEhMMms0Q2RKRm91S0VU?=
 =?utf-8?B?M2RpMWV0a0xnNG9KVTlTTUc0VnVNR25vUHJScWRwNDJtR3c9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5563.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YWN0WTUzNnRIMmVCb3YvMTh0VEFtbW5rM0g0SFRnYk5PandiOFcya1ptNnRs?=
 =?utf-8?B?OUpnalEwdllqSXJneXlMRkRUM1FJTWVRVXpQaWI2VVJOU1d5S0RZNWFlQS9F?=
 =?utf-8?B?Yk8wUWF5QVVkMXhBSEY5UGViT3ZnWVhCd0paNzBGamJFSkRWbWJjczhqTlJK?=
 =?utf-8?B?T3hRRVUwQ2VzdW8vazNCMnhrQWlsSVF5eldaVkN1aUgvOHBzeS9jWjRHMG1S?=
 =?utf-8?B?cmF0T0FRS1dPL0lkY3ZEdTRUNzcwRmpjV2ZhNGVUUTBpWjhJeFBEcFhZMHRC?=
 =?utf-8?B?T1A3ekQrQUU1aG1HV3ROQXhBQWF6VkNpZStnRHBXRW9CcExYbmRDNTFEdmJN?=
 =?utf-8?B?UEpVbmpFdjlSa1F6U1QxS2VwaE9LUGRVYkt5UFY0MWRvemRvMExGZmh3cmo0?=
 =?utf-8?B?NHdCN3JuK24vcTFrbU1mQm9oaTNSYzJLK3NZWTcvb0Yyall6Wk5kMkpnY3Ru?=
 =?utf-8?B?a05VL3o4ZytqQS82SXpwZVZXWXpTRlNhaVhRc3VUMmI5QlhZeHZEd0o5RlJH?=
 =?utf-8?B?MEtvT0w1ZWNWNXMrMkZ5d3FYZ1FHOHZxOU4xelYyNWJnY3EvaHVLU1FXcHNJ?=
 =?utf-8?B?eUNPbEVQem9waTFSYlA3OEYzK2Z5QkRuZy9qb21rK1o0UmhzSUkwcDJSUjk2?=
 =?utf-8?B?YTF6MC9KckVkajR5dFlIMDNHTW4xcEZhWmlCN3RZb1Y1ZTUwdnFmS3VleDRK?=
 =?utf-8?B?MUJPL082a2F6QXlObldzaXhERGVOWGl3M1hiMEtaa1EyQVNla1JqWmdlZnZt?=
 =?utf-8?B?dUNNWFBmV1QrNWthVXhmUmNNcW1QUWw2QVZJL1NNVDY0c3BpZU9NcnZyb3hU?=
 =?utf-8?B?emwxR05Ec3Y1bGtjSzJyWlVJOGdnMjhTOG5ZcDkrRmJjamE1VmZ3bjlDclpv?=
 =?utf-8?B?SWhzWFQ3ZzJ5dWhYS3djZ0cyZ0RHckdMOGdsTktTb2NLQzY1R0VRK0RjVU9x?=
 =?utf-8?B?QXNkMkpTOXJpR1haK2ZCMFVYRm5weGMwQUNRdmVmb0N1N1J1dEYzenk2WnVN?=
 =?utf-8?B?bC9ESXJQQUkxUjMwTHo2RTBKTWVPekVETkE4b3Arb0JNUzliellzOGlXWjdy?=
 =?utf-8?B?RTlUQTBCc3Nlc2NNRkN6N1NEQnFUeTRKOHp5SHRJVHRFbEtlOHprZFplUm41?=
 =?utf-8?B?Vk51RHVoVFRLdkJ6UGQ3VGw2S0NOeThjUnF4Sk9hczkwYk9JTlVidGxZUWpF?=
 =?utf-8?B?dkM5MmE1bWttZndYVTEvenROalBvNnRCK1JWRnZ3YXdnRUtjVDBzWGcxWkhi?=
 =?utf-8?B?NG54QWU2SjhmLzdUWHJ0NUVXZnAvaFBtR3R1c1dDWG54M0dzWTNsZ05qdTB5?=
 =?utf-8?B?VlN6OG9FT1daQ0xTL292cm5rMmRZVkF1OVZ6QlhLZ2lZZ0JDeGI4bWlQTGJm?=
 =?utf-8?B?STBVS0J3MUZMSWxBSVpJdGVHZXJmVm9WK1dYaTFEV2Q0VTdVaUl3NmVjb20r?=
 =?utf-8?B?Q2d3alphVEtpaTg0QmNlOW5mVmNBTUpCRUp1WllJeFFZd0tQNVFiZFh0Vnl4?=
 =?utf-8?B?LzFmTXFQUWMrNUlmMUlPRWZ4SHpabjVqQjJIY3ZiNU1PbjdHRXNUNEkzTXVm?=
 =?utf-8?B?Q1pkRW1FMHdkamlmalVtK0o5YmM4MHZOazJkaHJLN0pNSURpNzlJdi92Vm9o?=
 =?utf-8?B?OXNkVmh1SFFoMyt3eEVWQjltc2MwVXVUaHpYdFdER1RzWU9mWVlxdXRsMHd3?=
 =?utf-8?B?NVJsVUsvUFJvaDNFTzI5K2RFbXpFcmlEcmV2YkJKeWpNNmRIQk00MFZVb0Fj?=
 =?utf-8?B?L0VFZjNNaDhWYnQyQVJiV2RPZ0wxZXlJam5HbWo2TWgyZEI4eUg0R1RpRlJZ?=
 =?utf-8?B?NDhxblFhWFNsY3BsbnZZdXBxRjN5UFBJbGNDODlFdXBkMTV2bmlEVGhJbFl0?=
 =?utf-8?B?elhob1RTWEJQRERxeDY5UVdIRWJWaEh0eXNIc25XQWRCRFJudjBaZjRKSWw1?=
 =?utf-8?B?enh2bDA5Vm0vcC9YdTlKaGVwbjNYM2ZSU1Y0d0tBQVFIUld1a2pXZUhSWU9l?=
 =?utf-8?B?Rlp0SDdKTEJSejMwZk8xck01U2NaUVlJRDN1YzAyQlp4Uml5MmpPZjlhaFBi?=
 =?utf-8?B?QnF2cnc2RGVXTTNLUTRHN1pNQ0dyRTMvZ0k4QTNNSi9OUFEvR3V1Uzg4R2JX?=
 =?utf-8?B?ZkVldnVGcUV3UHIvUGQvNWNYMHJJYVhoNkRHSDZzU0dhV2FhZGtnSmhuQ0ls?=
 =?utf-8?Q?cmlSR14bJrWmfutyd2KwJR3RkSJBiOD8vEbkfWQogBTj?=
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-WwP/g0ZkmQqtmw6t9MoF"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	p0MZhsgQNjTITjHPtO5Qj629sxs+aa1KmfwJIstHAPFiob7GGZrF3JuW3T/ohMntutzX9FYQewLPruOW6kii3poQmqRUJnWxk77Ybf+UiiScq84fUtDDBAysuEOeuB9e0IBHD88B1Hu1LRHRAZDv06/JYx+vIzkryb8n+fyWOFBJy68zARVjrRx5SmHOgJCPUVQyqFKmRJ8LHrgleuyrlHfA930FvE1vinVetfQ/WKkC+7O1/mYHj5QCzQL0hyXX0lx7RoL0CD9/60sTm+psq+at/9vajPqsV9mtEQk4i5OO44dJKM8NFc4SEuhYlTFABkCxqVjFq/UttGKj+BsOJq3KDqubwpctT1ddJZkTQaVoZiqJL61F1aH4iMggC8Ez0laVwht72DwgUZxUyp2LfIxgLm9wtQIngEGeoOBuqgRFANrwag/e8Id+6jp6wB6s9AgvXqJS4CxvpdqCpBbJD12/LbzSonINA4eqx0yt8AokSCH6p+6JvUaoJKEdU9XV0AdwcdspxigvlmIvwb0Q2NQXzOxwfgpkGwDTYEJfPzcFrJThUuM6C+H6rmC5sbKoUY6nvwkVkj5he03qM2ov1ARjO0BMrCnB8Uhjaz8asxk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5563.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37e2e6de-3d4a-431e-cf8e-08dcb6ac12ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2024 06:42:14.7771
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FnlDt7la1eu4z+0peixEKx+FMbivEMEQxazi9SxwADqIX1YtTELladRZ1g/S2PWcBqZF4VngxjIpUHJpVAsoiyiqpOQI5XqIkakSucuhFws=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5123
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-07_03,2024-08-06_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=844 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408070044
X-Proofpoint-ORIG-GUID: Iv-e23195qSGbBwX44BaLCbclK1AcCpG
X-Proofpoint-GUID: Iv-e23195qSGbBwX44BaLCbclK1AcCpG

--=-WwP/g0ZkmQqtmw6t9MoF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 12 Jul 2024 14:21:09 +0200, Greg Kroah-Hartman wrote:
> In the Linux kernel, the following vulnerability has been resolved:
>=20
> netfilter: ipset: Fix race between namespace cleanup and gc in the list:s=
et type
>=20
> Lion Ackermann reported that there is a race condition between namespace =
cleanup
> in ipset and the garbage collection of the list:set type. The namespace
> cleanup can destroy the list:set type of sets while the gc of the set typ=
e is
> waiting to run in rcu cleanup. The latter uses data from the destroyed se=
t which
> thus leads use after free. The patch contains the following parts:
>=20
> - When destroying all sets, first remove the garbage collectors, then wai=
t
>   if needed and then destroy the sets.
> - Fix the badly ordered "wait then remove gc" for the destroy a single se=
t
>   case.
> - Fix the missing rcu locking in the list:set type in the userspace test
>   case.
> - Use proper RCU list handlings in the list:set type.
>=20
> The patch depends on c1193d9bbbd3 (netfilter: ipset: Add list flush to ca=
ncel_gc).

This commit does not exist in stable kernels. Please backport it.

	netfilter: ipset: Add list flush to cancel_gc
=09
	Flushing list in cancel_gc drops references to other lists right away,
	without waiting for RCU to destroy list. Fixes race when referenced
	ipsets can't be destroyed while referring list is scheduled for destroy.

Since this is missing, the CVE fix potentially introduced new races as
it makes use of RCU.

Thanks,
Siddh

--=-WwP/g0ZkmQqtmw6t9MoF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEQ4+7hHLv3y1dvdaRBwq/MEwk8ioFAmazFyUACgkQBwq/MEwk
8irRvQ//VaRfC/JJYPeIDLVcD1RagFmQ+PaRtlhB5z6uHA73c99urb0idM/Bg558
CA2AjnF+iV9EBSRIII3iq6huPq8E85AoUi0bYyQApnGM8Q+51ZzfT4AXcjXaSkfX
iH55Ly/vtTa8y2YGSY7y6ZhymBIy0B1vSOGWBLEBiaIuEjCBBrzSZALFocEeqsbB
dZI9FvZlBlOtyLVPNDCydZ6dPfjY215D+imfmrTiuiNBEjVF3kKCxZpwTxxPyYZA
agggd/wyb7OQKy4sFzJnWYJ0oNzdL4YhxVNE/mD0le+YlSp3VQBdsYuyo6IBhOoP
QIxNOWKmRioICy0qay+R82NO0n4mumsReaZH2VGDWGBKrBeISyMIHz61MqQcBbBy
EPChDt0gtKUmUYuyYyaJkvFza7KHpzXqPdoweSRS9Z1ew14iQKqoi+Ddltkac+VW
4vNTsYkQpncfxBSQAsqplix+ELdNHDMidXsTItUmAka1YBsRXNie26OmOJVNHaYI
ycC8wYxCwWoxcs9JHs8ooH7qynbR6D2gN83nTP5rm5Cg6DOesXd0GhojMIpxanil
MMCPbOcgdoKDeIwQkN7e8mjWnLppOtt9bU6bPTgTifhxO5/8s6od5umEJkZ7HJtH
ZKuuGL4+B+Fi6vRxwmCBpoVJqItruYWaqWykX0d8/bhD88pfnc0=
=Pge3
-----END PGP SIGNATURE-----

--=-WwP/g0ZkmQqtmw6t9MoF--
