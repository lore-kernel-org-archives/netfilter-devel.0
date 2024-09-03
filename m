Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833B1189B8F
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Sep 2024 16:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725379674; cv=fail; b=p2WB9/ZLhxsNktjkY5yzyRhpN5PMJ86V1JXedhbMkFV8/RpDxJeagbUxwTrRJMQPQxIZUY2iQfuqDGxYvFHiFJao1UAkgCwFG+NilvPGwx8/o2hv5XQwvO7N7HuIGEaPLboQQGRSB4AXsBRd1axQYBHmaYbXfQ5ugRrjgT3bLRg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725379674; c=relaxed/simple;
	bh=MZNTMep8NUfr6VXbG3MvsFMwsWZNWWX2OJetaCYwYco=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FZpfcJwSrekV8KkX0fOkMQKM2f1NJQPOuq0Wd6oV1sk//jNYamXPXjYihwC33i8W82qvsjxaCx797LpWGUCGrNm7fFHcD4WQjLGtWL+9GyJHNRhhzU5jhrQwpPjgAsZDUT38apq9SOcJxK4PICIyWMryVZWd+AmQ95CeT9xxGmA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=E1TOsY/8; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=iJMxRzi5; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="E1TOsY/8";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="iJMxRzi5"
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 483FgKHp013013;
	Tue, 3 Sep 2024 09:07:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=3TpwqVBhtp+qk2uCAwldiIQCDOs7+g4CYp8b1Wont
	uI=; b=E1TOsY/8/BSwE78lqrVbR9awZGcljZ/6EynAD1d9QvG9oCTPl2aokcrqU
	X0nKwfINmYyNH4GQ8vfDkdvavvWADTZOby7NlIqw/lSmzXs9vs4wq4r2ChpMVCQi
	9vH13jdTZtV9wOeq8pn/bBMsX1arC7hx/T3TqpmAw7HaueEwE7D75h01GMUtXfmY
	fzXOmB9XKa0B/4GdB68hEd4k9MXKuwQkzGgWqyjSeqsaq94B017M0ZR8NM5mRgaa
	6obixgxor9O1p6KK8rx7lIXVtxEWfRqC1kLyXqodFePdmYI9TsIQqBQPlhcSjOkr
	LgNP9eAgZsyRhWScD64p/rWysYHtQ==
Received: from cy4pr05cu001.outbound.protection.outlook.com (mail-westcentralusazlp17010000.outbound.protection.outlook.com [40.93.6.0])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 41c28g5wav-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Sep 2024 09:07:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TfAOpVJXsoTzMc19GDpTg7aW8A+inqdWuxf6eVOJcj5c7AVvnynNbXnKtL1uT56OcX96CWqjzHjLH1jJ5pVhpW/sm4ycavabzUcC7Ai6/B1By+mzr+gbCUdMWyOI3xaIYy2yCmyxV5JWXgfOhOBkQ6WNMFflX6s1RgfJJAyEIviyhePlbu67V2Q28Vtjm0fbjGE05z02UXcjaVOxpqeZG6qJV9czRqXaJd07M17LxQy4V2xtr/WmUvof8K3kRHzATvhRy764T0/C4RazBSSFoiq3438svth4gDt+Yh8xVoS247vwDmSl9v3X1pY4ZEi+qgKFm15dT745fVHP06KkOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3TpwqVBhtp+qk2uCAwldiIQCDOs7+g4CYp8b1WontuI=;
 b=Wfxi2F7C1S/myIn0vnTUoPsH9LPmZMxeM93lGByEYgjc++fZO1A0tuwrWpZfjR64fGx5cDVfPe2hfml8tu1xrrabpHFSIpFkcc6hil4rLX2pc8qxVQ9tEUzJS1DNFgqYMcrliK08aDPGxuZZFvOG9oxZYABxNVLxoaG+3TrkSfQgtVAFfje5DebFMuEkzZjnh3LPtBRTtu4xgLGza5PPJGSjQq3177P6EcRtexPSuhNMJcscLPrAzwOfshx0yFdzpBdkDdoL2qUWHoMAdOzeGU4WVYae8yg3iMSabaayHCj6e5Hd5WdkJEm2pInhMHHAMLmKGWSqqHuNhGISTpsoVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3TpwqVBhtp+qk2uCAwldiIQCDOs7+g4CYp8b1WontuI=;
 b=iJMxRzi5nRkMauOATW2KOJSgQACHBXau9QmJ4HQDODMD1qiLWI++f3VoHVOJVBgCRGzi0OikXfaEn7RV/XlgUz3pc7tNt8V+B7vdzY9g31fdsIg44pC5YlsMVgl+FES/B7xiQD5lX2AyLnfzGWbAunz9dLk3FKV+QhUe0UZIeS4FHPOMwYoSQKxV8hjjb/De2WqnoKq7iOMTlnIBIyWAD5+jr9ICEPY5ZN8N9jAJgVhqIWgq5joONNOqqdTEm9Hhmg3XdOwy3uLWYjtZpBFvEx8/Is/PGZO/j8bnVJ7YK+xP+TDc9/CXG7hLjPtqVEFOSJ5z32+IOtRkq17Q+c0VFQ==
Received: from PH0PR02MB7496.namprd02.prod.outlook.com (2603:10b6:510:16::12)
 by CH2PR02MB6997.namprd02.prod.outlook.com (2603:10b6:610:83::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Tue, 3 Sep
 2024 16:07:40 +0000
Received: from PH0PR02MB7496.namprd02.prod.outlook.com
 ([fe80::d47d:ed:381c:b8d5]) by PH0PR02MB7496.namprd02.prod.outlook.com
 ([fe80::d47d:ed:381c:b8d5%6]) with mapi id 15.20.7918.024; Tue, 3 Sep 2024
 16:07:40 +0000
Message-ID: <341f4134-73ec-4860-8c93-ee1e1f4b03d2@nutanix.com>
Date: Tue, 3 Sep 2024 21:37:33 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH libnetfilter_conntrack v2] conntrack: Add zone filtering
 for conntrack events
Content-Language: en-GB
From: Priyankar Jain <priyankar.jain@nutanix.com>
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Cc: "pablo@netfilter.org" <pablo@netfilter.org>
References: <20240830090530.99134-1-priyankar.jain@nutanix.com>
 <PH0PR02MB7496D619D1674886AC17798083932@PH0PR02MB7496.namprd02.prod.outlook.com>
In-Reply-To: <PH0PR02MB7496D619D1674886AC17798083932@PH0PR02MB7496.namprd02.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA0PR01CA0097.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:af::14) To PH0PR02MB7496.namprd02.prod.outlook.com
 (2603:10b6:510:16::12)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR02MB7496:EE_|CH2PR02MB6997:EE_
X-MS-Office365-Filtering-Correlation-Id: a890cd8e-2f68-4250-9c50-08dccc3288b5
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?LzREQytidWNkS1lvelgyeTM5TkRJdnBsb2RoWWxJWDkzYXFzUyt1Qml4a2lW?=
 =?utf-8?B?NzNGWkhSYit3L0FpUE5LTXZLY0R4V3JwK2FPd2wrZXRuSVpVN0NRcmZFdUNv?=
 =?utf-8?B?NVFWNW9DdUE2VmFJdEMrUnJvNG96TFZBZ3pWVmxjMjY5cFVZbUt1bkxpbTZu?=
 =?utf-8?B?c3A4bkZSaUU2UEZzcXpZdUdrZGVKZnlpbndVZzF0OERRSUpENk53OHZHdDJQ?=
 =?utf-8?B?dit4STJYd25IMGROYUJFS2l2RFJhSVd2Q21KMWRKemZZR0pEajNWSzRwWkVL?=
 =?utf-8?B?NVF4M25ZQUdVSnozTExkckZWZEd1RHFoeHJPbDFScVNZV01zZnF2RE1wVFk3?=
 =?utf-8?B?bUlKMCtpSkx0djRHS3Y1VnRxYTBMYXNqYmZYd0VVRXpWZ1RGc2F5OUpKdkND?=
 =?utf-8?B?TDF1dmlpSCtiTnhTZVFySURZTG1UK3pwWTdxeHpzdVM4NGVzNzQ2VWVTU0Yw?=
 =?utf-8?B?dDM5R0pzVE9ycHI0U1BNMDEyTmtzZmllYkluT0JCeXlFSHhRVVhabWYxTFkw?=
 =?utf-8?B?L0F2L1NWTWZzR1ZsNTRZTk9CRXd2K2ZjaDFjd0N6Y0x3K0xSNnlST2RLNDFt?=
 =?utf-8?B?WThkMFZYMmJDZm5oT1RzNUw5dmQ2Yi9keDNwamJDeUVudXAveEdHZjRIYlVU?=
 =?utf-8?B?WWovWm9aL2FlRjlmNC9hM2ZnZVJkSS9icEtmVC9VUEh4SnNsdjh1Tmp3QkxY?=
 =?utf-8?B?aDNXWkZjVENhKzFENWY0MmFxd0JwV1FqaWQvWjRvL1RwT2l2aThvVEVBUWdz?=
 =?utf-8?B?MU85VWEvMkFiYUhWV2FwR3MvUEVQV1pxM0VVbE5Mc1NYTXF1cTZmV29zMjZm?=
 =?utf-8?B?MDZvbTV3ODJKVloxVjNmK09SR2RSa2tGa1puYlFMQkRkMmZuTXU2eFBkZ3cw?=
 =?utf-8?B?dExBRmFacDNEMUFIWmJKdER6bFF5eng2UnIyd1lFaEZTK1ljVkZBRDdCTnRR?=
 =?utf-8?B?QXRVUkcyOTU1dTN5MWJnZlgzL0N6aDZIa0ZMOTZ4alpyRnNrb1JGTHpHUFp0?=
 =?utf-8?B?aU1kV3I3c05GNjRIWDlWMkNGTUJzazEvWUpwU0xDQ2d5S3MrcCtUYWJTOE1n?=
 =?utf-8?B?bkVOc01YY2Z2MWszeDhUam9IbEtaVjlJSGhCdHI4YVg5c1F4QzZhVEw1cVVm?=
 =?utf-8?B?WVc5QUhPNURiV3gxbU5ZU0d6eHZzYktJVURsOUthTVNCTVFNcS9YSEVBNFlt?=
 =?utf-8?B?eEZDdUJuOXlqQzhKc2hUUFRmMzkxRGVhTHV5b054RStNdXhSenlCd0J3RUZW?=
 =?utf-8?B?OVdHZnhFblAzYUNiYmROYk80L2s3YlJSVjNNMWY5eEprNmdIOXBPQmZBNUYw?=
 =?utf-8?B?SE5JNGVCSmxDMW1mY0kvMUoyZGdPdlU5WFdvaWZOdjZBYXRFbWt0OXhUVVRu?=
 =?utf-8?B?MkV4eFRyZUs0VGd3RlY0N0traURobkdsWVJ0YnFUc3ZsTnRBMTNZenhvY2RF?=
 =?utf-8?B?TzdCWERjcUg3OGQ0UU95Nmw2QTVEdFE1ejRqa2NOT1R0bk1HOXlCN3RrdjY1?=
 =?utf-8?B?bmpmSXg0SHV4WnNteVRJUE1PcTNNaE1uSGQxY1hrOEFTREEwaW9GeG81ZFVG?=
 =?utf-8?B?U2NjUWEvZE9Oakd3bytHdGFWRml4em1UcnlIL1VTMXdpOE5rRDFaSlNMNGND?=
 =?utf-8?B?bEVYTzk5VENGaGROTFNmK3p3Vm5IaDNFVDNnK29NdU5DSW9jS0l0V3RxRDZ0?=
 =?utf-8?B?RTBidDljVUR2dml6TWZiSHdBVVAvUlBOUUoweXN4cUQyRWpXeG9GSkRkOGh6?=
 =?utf-8?B?cDc4ZUw3V1VhS0ZXREJ4aUsxMDYxMGxCK0taSjlINHExUDFoanlBUHVab1Z5?=
 =?utf-8?B?MWNOWDBRVE5YNXhnR3F0QT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7496.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MDhkUk9kZmh0WnFMa3BsbkZpSURmamF3aW5GdjB1am8wQUozR0dOSEdJTkx2?=
 =?utf-8?B?MVJFczYvQXdqdzJMKzZTbEJVVDc5UFpJS0RKRkhidUNXNCtQeFZDT2NKak1u?=
 =?utf-8?B?QlJIT01ETnlSRmZTNEdZbVVaajN4VExITVNyMGRreE8xNWZaOUJpK1oyUEVB?=
 =?utf-8?B?TEdGTWpwbmhlWTNENXlQYllQd0NxQVdrL050K1E4emZSR1BKYmJ0Ymt3R0V4?=
 =?utf-8?B?b0JsNnNUVzhVTTdraTE0RGpnN3orV0I1Q3BpWDFkaUFwb25oaEVrbEROYzVI?=
 =?utf-8?B?NHFvN0xTTlpYVEpTUWdhdEdZRlZSRUxBK1lMMEVSZW90cndyWUZnN2dxK0JD?=
 =?utf-8?B?NjU0MWNidDVOcFRRTnY1N3dJd2h2V2h3ajJHZm5XWVl3UlJCb2JMazZXSmhO?=
 =?utf-8?B?S0hJYmttMTVQZGFoLzlWOVRpdnhtS1YxRjhoVXJKUUMvMnRNL1FDOWZWanZX?=
 =?utf-8?B?a216TGV2RzVqZ2g5WkU1VlZzd0lwZ1Z5K1FDcjRPTWtwUUNkWjVuQWVVWGwx?=
 =?utf-8?B?RmhFT3VEWS81ejYyWnVFeFpiMjV4V2FZa2lRNFFoM3pnTCtrTDlSNWU2a3Zh?=
 =?utf-8?B?bElySGJORW5rdk9wVEp6S1VXdjV1YTNJRFdTNGc2eGN4akZ5VjE1emRmMEpI?=
 =?utf-8?B?WitiZlo4eURJdmwzWnl6alFtaVZpVHo2UFA5R3N3S1pGZzNIZTEvYkh4K2U2?=
 =?utf-8?B?d0NyeVpVeWY2UTNtYW8vcTM5QWFuT2YwVi8rd1RIZ2JYSGVZcFZHejgvY0Fu?=
 =?utf-8?B?NFhrSE1zczhKYjlNWHRzMnNESzExbDFXbCtycGVoUlFRZmhxQTNuRlQ1eksx?=
 =?utf-8?B?ZlV4bnhNVmo0VFJwN2t2MUJJMUlYYjhxWE54TkVFdG1jZUpoYTUxbDE3S1VQ?=
 =?utf-8?B?YWZxeXN0d2daRjhDdUYyY0RiaS9OU1FNRC9nd2VNcDk0TjJqV1lBaFRERjd4?=
 =?utf-8?B?ZTJ2ZmtMTC9sK0I1a1YycHNiTW5zWVN2c1RpTDJHeXhsWHFpQk4yRUFVVWxl?=
 =?utf-8?B?VmVpMFdZWndoSnhRNHl3V0dLWEtiWjZ3N2t0akVPV0Zla09qS0lTeGJOODI3?=
 =?utf-8?B?b0pKQ2NNeFNsNjFnVTl4UHE5Vm1yejAxTGNxNHFacDFabzhRanhDc25WdU1p?=
 =?utf-8?B?d2R4NGVDWHYwMi9QZCtNUm9LSWx5RHA5V3pxOFIwK3dCN3lENU5jVlorVnpu?=
 =?utf-8?B?c25RRGJ1eTJGV0svS2JCWVlhYldETU96bzBqY1lHMC9KZGpGUWcwWC90eEZN?=
 =?utf-8?B?bzhzVkZFVWlFNU1pL3QxaEhwMkdZVzU2c2R3ei95SWZ2RVRiWWI4V0xSNW1q?=
 =?utf-8?B?Nno2dFAxNDdmQkY4aUtJRFMwM2pYamhKTXM0K1hhbEhiUFh2TDdRRW0yRndy?=
 =?utf-8?B?dk5EYVp3ZXBmSUVWOGFweVlvb21FamluYkVQRTZYWHVYK1FSMUlINmdHNGg1?=
 =?utf-8?B?eDBjV1ZTdHFPYzIvUGEyYmk3QndjOEZaR1BkYXBsVVpWVi9hbHRjTmsxQlRj?=
 =?utf-8?B?bk83WEJmMlZiRGFmbEM2anFnVXZuMzVxZ3FyMEV2R0pPMmg2Q3RZbFhKbkVM?=
 =?utf-8?B?elBrM1hTT0pXRWMxUUkwckJjZGFqdmM0dXBoVnVCSGw3OEFvdUNNMnJiRHpK?=
 =?utf-8?B?ZzF2TlhONUM4ZW1ocjkxVTZPR1Z0UmkvaTBLbndsR3cwS3V5ZGdITEttNVVH?=
 =?utf-8?B?VWtNbHpNbFpjeE9SNkxERlVtZlN2cTE5bmI0Wld3a1RpRHJxbUQ3dzVCTXVo?=
 =?utf-8?B?OFhXMXhNRTkzRVVTYUNpODAzLzV1dy9ITFJYZHB0SlM3bXIyUVRYZFc2Nnds?=
 =?utf-8?B?ZlhVUm5hbkpycmppVTRPZmxPY3JSb3J0UVd1ZVMzR243d2JQWk12elZlMzla?=
 =?utf-8?B?QjNxTTJXalZqbzFNMUNaRXIwQVlhS25CV0tBb0Q3QTlxM3RrclpxcVhnaHNq?=
 =?utf-8?B?MWZKNEVNOE5Rck00TFFkVGJwenVNZkx4K29kMk8reDNXSGdkRnZhSWNCUThs?=
 =?utf-8?B?RVFHSXBMVWlnWklodEtMdVNDemlHSysyZ2dwL21SNnpva3d0elg4c010WmpB?=
 =?utf-8?B?SFkvWURVeEtRMTBxYSsvd3Z3dHphczg5MG9tRHZ5VmRJT3NpcmtTbGZ5eCtR?=
 =?utf-8?B?OUJDeWFJZ29JWHpQeE1kZkNTNVVDODNNQll6UVJ5QzNLcTFSaEcxYU0vRXhZ?=
 =?utf-8?B?QjNsQmVqdzRTayt3UjVCdzgvR29ZSksvdFRhZjlKS1VEc1JqamZSMVNMa0V3?=
 =?utf-8?B?YXZmVTB1V0MzenJRMExqYVJIbU5BPT0=?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a890cd8e-2f68-4250-9c50-08dccc3288b5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7496.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 16:07:39.9919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OeLJp7f5ydNZeY+PT0z0/NpJxZ5HygKdTBkl3KeH4OebtJrnPzHri6SQ+Iko+BXKiJ3gg/JmeuYcg45rVTUy7TqpUBW+8VBdOvYHgMjv3dY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6997
X-Proofpoint-GUID: PdePhOTsPmp3eeGARY5Hrr13CFJvR2qC
X-Authority-Analysis: v=2.4 cv=AarjHGXG c=1 sm=1 tr=0 ts=66d7344f cx=c_pps a=GHJUnOcs406mhZkDzxAeiQ==:117 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=EaEq8P2WXUwA:10 a=0034W8JfsZAA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8
 a=VwQbUJbxAAAA:8 a=3HDBlxybAAAA:8 a=OgK866Z0vTZvkKTO_2YA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=14NRyaPF5x3gF6G45PvQ:22 a=laEoCiVfU_Unz3mSdgXN:22
X-Proofpoint-ORIG-GUID: PdePhOTsPmp3eeGARY5Hrr13CFJvR2qC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-03_04,2024-09-03_01,2024-09-02_01
X-Proofpoint-Spam-Reason: safe

Hi,

Ping for review.

Thanks,
Priyankar


On 03/09/24 9:34 pm, Priyankar Jain wrote:
> From: Priyankar Jain <priyankar.jain@nutanix.com>
> Date: Friday, 30 August 2024 at 2:35 PM
> To: netfilter-devel@vger.kernel.org <netfilter-devel@vger.kernel.org>
> Cc: pablo@netfilter.org <pablo@netfilter.org>, Priyankar Jain
> <priyankar.jain@nutanix.com>
> Subject: [PATCH libnetfilter_conntrack v2] conntrack: Add zone filtering for
> conntrack events
>
> This patch adds support for filtering CT entries by their zones
> using bsf. Max number of zones for filtering is 127. (Although
> it can be supported till 255 but keeping it consistent with
> IPv4 and mark filtering). Entries which does not have ct-zone
> set will be treated as ct-zone=0.
>
> Signed-off-by: Priyankar Jain <priyankar.jain@nutanix.com>
> ---
>    include/internal/object.h                     |  4 ++
>    .../libnetfilter_conntrack.h                  |  1 +
>    src/conntrack/bsf.c                           | 55 +++++++++++++++++++
>    src/conntrack/filter.c                        | 10 ++++
>    4 files changed, 70 insertions(+)
>
> diff --git a/include/internal/object.h b/include/internal/object.h
> index 8854ef2..658e4d2 100644
> --- a/include/internal/object.h
> +++ b/include/internal/object.h
> @@ -280,6 +280,10 @@ struct nfct_filter {
>                    uint32_t         mask;
>            } mark[__FILTER_MARK_MAX];
>
> +       uint32_t          zone_elems;
> +#define __FILTER_ZONE_MAX      127
> +       uint16_t zone[__FILTER_ZONE_MAX];
> +
>            uint32_t                 set[1];
>    };
>
> diff --git a/include/libnetfilter_conntrack/libnetfilter_conntrack.h b/include/
> libnetfilter_conntrack/libnetfilter_conntrack.h
> index 2e9458a..27d972d 100644
> --- a/include/libnetfilter_conntrack/libnetfilter_conntrack.h
> +++ b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
> @@ -510,6 +510,7 @@ enum nfct_filter_attr {
>            NFCT_FILTER_SRC_IPV6,           /* struct nfct_filter_ipv6 */
>            NFCT_FILTER_DST_IPV6,           /* struct nfct_filter_ipv6 */
>            NFCT_FILTER_MARK,               /* struct nfct_filter_dump_mark */
> +       NFCT_FILTER_ZONE,               /* uint16_t */
>            NFCT_FILTER_MAX
>    };
>
> diff --git a/src/conntrack/bsf.c b/src/conntrack/bsf.c
> index 1e78bad..da5919c 100644
> --- a/src/conntrack/bsf.c
> +++ b/src/conntrack/bsf.c
> @@ -738,6 +738,58 @@ bsf_add_mark_filter(const struct nfct_filter *f, struct
> sock_filter *this)
>            return j;
>    }
>
> +static int
> +bsf_add_zone_filter(const struct nfct_filter *f, struct sock_filter *this)
> +{
> +       unsigned int i, j;
> +       unsigned int jt;
> +       struct stack *s;
> +       struct jump jmp;
> +       struct sock_filter __code = {
> +               /* if (A == 0) skip next two */
> +               .code = BPF_JMP|BPF_JEQ|BPF_K,
> +               .k = 0,
> +               .jt = 2,
> +               .jf = 0,
> +       };
> +
> +       /* nothing to filter, skip */
> +       if (f->zone_elems == 0)
> +               return 0;
> +
> +       /* 127 max filterable zones. One JMP instruction per zone. */
> +       s = stack_create(sizeof(struct jump), 127);
> +       if (s == NULL) {
> +               errno = ENOMEM;
> +               return 0;
> +       }
> +
> +       jt = 1;
> +       j = 0;
> +       j += nfct_bsf_load_payload_offset(this, j);     /* A = nla header
> offset                 */
> +       j += nfct_bsf_find_attr(this, CTA_ZONE, j);     /* A = CTA_ZONE offset,
> started from A  */
> +       memcpy(&this[j], &__code, sizeof(__code));      /* if A == 0 skip next
> two op           */
> +       j += NEW_POS(__code);
> +       j += nfct_bsf_x_equal_a(this, j);               /* X = A <CTA_ZONE
> offset>              */
> +       j += nfct_bsf_load_attr(this, BPF_H, j);        /* A = skb->data[X:X +
> BPF_H]           */
> +
> +       for (i = 0; i < f->zone_elems; i++) {
> +               j += nfct_bsf_cmp_k_stack(this, f->zone[i], jt - j, j, s);
> +       }
> +
> +       while (stack_pop(s, &jmp) != -1)
> +               this[jmp.line].jt += jmp.jt + j;
> +
> +       if (f->logic[NFCT_FILTER_ZONE] == NFCT_FILTER_LOGIC_NEGATIVE)
> +               j += nfct_bsf_jump_to(this, 1, j);
> +
> +       j += nfct_bsf_ret_verdict(this, NFCT_FILTER_REJECT, j);
> +
> +       stack_destroy(s);
> +
> +       return j;
> +}
> +
>    /* this buffer must be big enough to store all the autogenerated lines */
>    #define BSF_BUFFER_SIZE  2048
>
> @@ -774,6 +826,9 @@ int __setup_netlink_socket_filter(int fd, struct nfct_filter *f)
>            j += bsf_add_mark_filter(f, &bsf[j]);
>            show_filter(bsf, from, j, "---- check mark ----");
>            from = j;
> +       j += bsf_add_zone_filter(f, &bsf[j]);
> +       show_filter(bsf, from, j, "---- check zone ----");
> +       from = j;
>
>            /* nothing to filter, skip */
>            if (j == 0)
> diff --git a/src/conntrack/filter.c b/src/conntrack/filter.c
> index 57b2294..9feff80 100644
> --- a/src/conntrack/filter.c
> +++ b/src/conntrack/filter.c
> @@ -104,6 +104,15 @@ static void filter_attr_mark(struct nfct_filter *filter,
> const void *value)
>            filter->mark_elems++;
>    }
>
> +static void filter_attr_zone(struct nfct_filter *filter, const void *value)
> +{
> +       if (filter->zone_elems >= __FILTER_ZONE_MAX)
> +               return;
> +
> +       filter->zone[filter->zone_elems] = *(uint16_t *) value;
> +       filter->zone_elems++;
> +}
> +
>    const filter_attr filter_attr_array[NFCT_FILTER_MAX] = {
>            [NFCT_FILTER_L4PROTO]           = filter_attr_l4proto,
>            [NFCT_FILTER_L4PROTO_STATE]     = filter_attr_l4proto_state,
> @@ -112,4 +121,5 @@ const filter_attr filter_attr_array[NFCT_FILTER_MAX] = {
>            [NFCT_FILTER_SRC_IPV6]          = filter_attr_src_ipv6,
>            [NFCT_FILTER_DST_IPV6]          = filter_attr_dst_ipv6,
>            [NFCT_FILTER_MARK]              = filter_attr_mark,
> +       [NFCT_FILTER_ZONE]              = filter_attr_zone,
>    };
> -- 
> 2.39.2 (Apple Git-143)
>

