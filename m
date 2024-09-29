Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2089.outbound.protection.outlook.com [40.107.93.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3BE93C00
	for <netfilter-devel@vger.kernel.org>; Sun, 29 Sep 2024 10:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727606568; cv=fail; b=DZ2VcPBf1r4XzVZTabIuSjQFtRj6m++XUGoI/5AO007PC+VHj7L+rSDt+SKk5MFgER3gq3QAoQUIRJV7ositgxOcxd6EPx1L3rc5ntslRDXgVhZLQLQ67S5xJyYEc1labH9zBx343Yq7YP1te9ztaHxhsUrp7tXw0dMU+dAzNIs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727606568; c=relaxed/simple;
	bh=LXTRAZ8buqTY6GmA/2EdFTruRnobdMbTgYDshvIdVKk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LMg6i7B5FiMZTI8uyRnUcZrn0+GzyVoV9D+jhBXD63nr9Rb87jO9gtOj3AmmhubB0A3O1T7X0SS4bUJLQgPNdK/cnjf2Lo3i3id+1loVjkCYXW5c49NDrmzSeIQgO9eWsYtLd8l477QAFi4I8O4coeqjane8N7tsnfOv1KIfJUs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oFUCILoI; arc=fail smtp.client-ip=40.107.93.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oFUCILoI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jXOZaIdiDzsYme5EPYseO+lKxGzGK3gVhCNC+CuyUy7k3ByWE031DflRq/2V2VZVSDUM6lCTdMShMt3EgajuK3+GoDAVn8ciN3Rl7SkniNKvFekTcs2cWuevnFTXuU4lcv88QOk7tjIb3aII1QijbvLwRQmNXpQZlJN3Bdy7ciFqS86ncX2EWkoR5lrikDt41G4WnOrx+o21Hb1wb7NeC08OQrK9G3ITRvrEZcpjH8OLykYHwKj7LmsPFg926HnQzSuh2+h58Ahlrq4b7W/WpIwlLeKOOkvbSl4HozO9lVCMJEECLJuABNlffKymhppcAULJ5ygecQfOpt6fRU2HxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LXTRAZ8buqTY6GmA/2EdFTruRnobdMbTgYDshvIdVKk=;
 b=SRsuyVel3joxeGBbb24U4EEho45mxfn9dtdPvtzm4dIw7OvaIE4ssyaS3prBLsKmH4psswMo3XVygSkpsI4wr/p3aIXsh9eNmq/l4wvxfdW6BeK98mVwkBFWSiEmICdyRX2Fkh4rfV+rnafhTm2iChX8Xkf0O/juEFaiEbp3W6OEJHkfojPQqNcKzXcHIASS9mqbeywycsr0nLIs41VzSYOeBOJtI8qNHogoSoRGhG95qwkrsce47Am43dhnxPQK2JsiqF5nszne+bV9NiQ7FFw1YqDyKZFGpj+/WefSM2BdIgRKrhIX0MouEjI/fUyn4YFv5XAQ9wGuyVERHr8qxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LXTRAZ8buqTY6GmA/2EdFTruRnobdMbTgYDshvIdVKk=;
 b=oFUCILoIW7y4TbKiH672pInvt712iVUak6RQaY2pp3ADnB9G959ThdPTXATu6a2/Wydr0mjTR9xhUuZoW5dO0lLNt/kBVUug8z8N0IHgXAdiQYjTeSL4FGi9G39Pli2MXqGr/PCaLPYwF5nJ3qH9eLiDEKcTgYNPzX7eEETK6DhKAVJLyXSCyRMt7IZ3YJF5Mq12P9J9+9TNBv6Vl/SioenIzkpx3QU7sZ9V4dtjjucIv0PdLBhg6XCiK94TSehY9c71X0NAPy0+HcwSODiuso39tQHyoP4MkgxDv85MoPSwLJyJtEPi6kABAuOcnFzFA7i6Y+gwkqxLXMvq5gG77w==
Received: from DM6PR12MB4516.namprd12.prod.outlook.com (2603:10b6:5:2ac::20)
 by DS0PR12MB9397.namprd12.prod.outlook.com (2603:10b6:8:1bd::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.25; Sun, 29 Sep
 2024 10:42:44 +0000
Received: from DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::43e9:7b19:9e11:d6bd]) by DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::43e9:7b19:9e11:d6bd%4]) with mapi id 15.20.8005.024; Sun, 29 Sep 2024
 10:42:44 +0000
From: Danielle Ratson <danieller@nvidia.com>
To: Phil Sutter <phil@nwl.cc>
CC: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"pablo@netfilter.org" <pablo@netfilter.org>, "fw@strlen.de" <fw@strlen.de>,
	mlxsw <mlxsw@nvidia.com>
Subject: RE: [PATCH libmnl] src: attr: Add mnl_attr_get_uint() function
Thread-Topic: [PATCH libmnl] src: attr: Add mnl_attr_get_uint() function
Thread-Index: AQHa4xP04Q22L7+AvUGSMh1A07WzIrIQbHoAgF6FOxA=
Date: Sun, 29 Sep 2024 10:42:44 +0000
Message-ID:
 <DM6PR12MB4516F083558D7AB3466FAF9ED8752@DM6PR12MB4516.namprd12.prod.outlook.com>
References: <20240731063551.1577681-1-danieller@nvidia.com>
 <ZqnkZM1rddu3xpS4@orbyte.nwl.cc>
In-Reply-To: <ZqnkZM1rddu3xpS4@orbyte.nwl.cc>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB4516:EE_|DS0PR12MB9397:EE_
x-ms-office365-filtering-correlation-id: 8fb1975e-c744-47fd-21a3-08dce0737368
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?N09veEVSNVdZZ2pURm8wN1pyczFvVWdvL0RlMGFSNzRKMWdwWVVienIreWo0?=
 =?utf-8?B?VXdZRSsxOGFkRU5aQlluRDZ4SFJ4ZUREemgycXIxNGFFZ3dXSlpvZDl2VlUy?=
 =?utf-8?B?SFpPL2RhejJnYW5WMXNZdW4zNEUwMDd4dXdqYU0yL3RMdGd4U1dyTmUzT0Yv?=
 =?utf-8?B?NHhSRFBQYXdkUXhWOHFxM1UydjhYQnJIMVd3SDA0ZUVoaDdkSVJpSGFwMDNJ?=
 =?utf-8?B?b0E5Y0hmR2l6T0hoV0FMNk8vMVJzR1FqczNyUjByNDByVkhXdEs3YkdNcElP?=
 =?utf-8?B?Qk1jZHRIdTdEL2F1M1RSMHZtRllPaS85Zkh3WEkzb2RFb2tjZ1J0bmRnMlgw?=
 =?utf-8?B?aUVNQVVsTjR3V3Z0bDZxMWEvbVdlWTdScjlranJyZjc1TjllZTdhRzlaSFJk?=
 =?utf-8?B?ZDFzbHJNOElmbjRPZ2t2VWhQdytyU0IyMVVnVmdQVzR5Ylg0YWVQRG9xemVs?=
 =?utf-8?B?RmRCbG0yQk9iUlJxY2Zock1oMGJsVDdDWTZxQ2FFTytNaTc2enE4MmwvdGF3?=
 =?utf-8?B?NGJDUlE4d2VmUkJFYk5DQW1YcUZUYWc4Q1I5dU1RZ2dOSEQrV3FhR0NEUzE0?=
 =?utf-8?B?N3NleHdrS045SVR6VVdZSGp3VVN5Ry9qTzNlWmdIK2hGVkE5QWhMTXBrbW8x?=
 =?utf-8?B?enhLeVdHT2RYQTQ0a2RpVGg2UWRYNzVGUnl4VzdIK0RoOElYR0FKcWhKOGhV?=
 =?utf-8?B?RzJ3NW9rYUtTa2kyN1FuTkdkL01IdmQrTVFLaE1ZS2NjUXVEVVlFZ3hBZytq?=
 =?utf-8?B?eVdhRmtUN1BlaEZBQmVZQ0Y2L0QwaXB0YjNMSHRpTVlaTmpFVENldFhabHBx?=
 =?utf-8?B?K2orL0RLeTlzVHc0emtrSXZJR1lNQ3dCaVRYODJPaVMwbVk2Y29GSFpIOGdy?=
 =?utf-8?B?Y2pkL251L1BQUjdRWnZSZlFCMUUyTlQyYW1aQ21HTXpPaERnRmRJSjBwbHpp?=
 =?utf-8?B?NjlBUWZjMVJYaDYvRElYNDAvOCtCS1ZraHg4b0QwbkwveVV1WGN3REI2NUpS?=
 =?utf-8?B?QVlVbERCUnpWbG43cXRObGVja2Y4b2pyRnVjQVgxclcwQTlNa3N1WnlvK2VQ?=
 =?utf-8?B?RWIwcGtOQXFxdHV2Y0FpbWRMay9BOVZLM1ZIUXlDclczTGR3S1NtT2poblpD?=
 =?utf-8?B?RktESmFZR1RXTXh3cTdNT1hBemdtczhWbStUYzJxcVFQSit1QUpSUVVKdUdE?=
 =?utf-8?B?Z2lNdy91YzEzMjlkU1EwTksxeTcxWE1BNEhjTUpqM1dzaHJkaGhOMEZaQmoy?=
 =?utf-8?B?WEhRL0VueXBmbmVUS0crOEg2T0hwSENCYmJzblVWTGNST0RseHJHRDI2UkRH?=
 =?utf-8?B?Z3JNbHFXV1liNWZUVXdaTFYvTkRDeS9PTm5HMkgwQisyRitmb3N3WW96NWR6?=
 =?utf-8?B?TTY1VUdwaDlVejdWY29SQkcvNTF4a2ZDQVFIbFJ5dXo0bkRUZmtzdXZoUXFG?=
 =?utf-8?B?MExxOUxaUW15cjFDaDRBckNmckxPZThucWtnekpVbndZN0ttVWJDYjNBQ2Yr?=
 =?utf-8?B?QmZlUUVwZGx6WGJOQnV3MTBTcGRvbTFPM0MyYjVPaEt1dkVzN0JqUERCWUEx?=
 =?utf-8?B?bGhWdExWYnJoa0ptcVM4bndWblh1eGdrcEg1bi9jb1FYWXp0Q3pPUS83Zmlt?=
 =?utf-8?B?M0l6a3pTSEtKK1U5K21FbmozellnMy9adUR2ZGlWcHlZM3ZtT2dlMjRyUlcw?=
 =?utf-8?B?MzZKOVVhYjN0c2ZsVjAzMU02cnVaa3lnd2Ixb0c2US9kTVZwR1FGS1d2SlFn?=
 =?utf-8?B?cnlVaGFoTVJTRkFzODhVbXZ0NXR4MU9Zb3o1Q2ZHc0ovNFlESjR2U1daRFBt?=
 =?utf-8?B?aGl0K3NlSW1mb0s0TlVMeTBFeG9Fb3BKZU01RjZVV3p6dTNtcGVsaUo3NkUy?=
 =?utf-8?B?Y3ZSY1FwVTE5RzJGT2JZdisrNGd4VDYzR3hJaDdkVEhCQ3c9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4516.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?b0RlV3N0cWQwQ2xhWmMvUWVoMnpzbzgxRTNDcFR5ZVFMbGpnSjJHTmY4YVVl?=
 =?utf-8?B?dWc2dHNYdGFjVmtHcmxsMjRQclRCVmN4Wi8wcEE0MkNsM01xMlM2OFBkdk1r?=
 =?utf-8?B?VHg5bi9wRmk2UHUzc2c5eUlsTm5RNE1zWHNWZE5FczZrREhvZmMrTzRaSVZW?=
 =?utf-8?B?M3RrU2d5bnVEbkE3ZkhhaGFhQi81TVViMXdKOEZqY1BGeWRPbzRIMU16WUxH?=
 =?utf-8?B?U0ZaOHV2aUZKSWwzUTlwOThUMFJJZndIWFFQM3VBVStNaW8wQ05aTmJJaFNr?=
 =?utf-8?B?Qlp4Rm9oMWl5a3NuUGhQaktxL25PbUN2MTZZNmx6WlpCejF6d0RIK004ZE5C?=
 =?utf-8?B?c1J3MmVpd0cvcmVwVEZwT2NFMHROUFVlU3dHR3BNSmROUnFTalFoS0Q1YlZS?=
 =?utf-8?B?ZFM0MFFpdGgzdGdYWHBwczFkZmpPZ3Y3N1FwYXV3QWs3TGtZSmQxdEowWkp6?=
 =?utf-8?B?WTE5QXExQ0FPRXE3SVdCNFQrUXNWa0ROZUNpandUTzh6Z0Y4RTFkTGFIbXBo?=
 =?utf-8?B?eU9FeHk1R2JBckNROVVkM0lQRFVCZ3duVGJtNmZOeW04QU5WdWhDUWhqMEVV?=
 =?utf-8?B?ODhBMFd6NzUwa1I0YXI1aDJoR095UG9pem9MMkV4ejZQR0pzRXc5c2ZGMVlp?=
 =?utf-8?B?dFZvc2xHZmt4RHFuSGoyd0gwdXBqQmU5N3YwSVFRbEhkZ2d6YTJmcEVBL09G?=
 =?utf-8?B?eXBwNTZnUnFETC85dGdnamFZYUJRUExka2JJZGs4d08zT0Qvb0NCWXNjOElk?=
 =?utf-8?B?VlN0NzR5K0ljbWZQS2xsMWZJQUtkZ3lxcXVNK0hVOW5maldRMHhsZEpiakFF?=
 =?utf-8?B?b1FDeXNLSE5Kd3dBMFVmVklJUytmZ0tiQmdiKzhDdUV6Rjd2TWFTTzFrcFA3?=
 =?utf-8?B?RTIvNnpzc3VMZFJUZUJ4RXFhY25FVThVeXJlRHlTbFc4Y1pUVm5hN1p3V1JJ?=
 =?utf-8?B?cTN3bTl0R0p1UkJCQm5nZ0EvMjdmK1FucUFBTEVaRG41c0ZYb1YwajI4MVQy?=
 =?utf-8?B?SEVtZHVGWFgvcU9SODdIS3lWeHFWRHJTVzRyQkpxNjd4UWkvRUVGWEQvY3Nq?=
 =?utf-8?B?WTk1U05PWGU2dmNPcjAwVUg4b3U1Wm15dmJTL1V4dHVocDdDRk9SNGhGUS9K?=
 =?utf-8?B?RW5GNS9wZFRaWWZTZGFPeGxwcnFKR0YwTTBWRXlxYkU4a0J3aVhsdGp1bEdF?=
 =?utf-8?B?SWFTRGZnZ3E5ZGVSOEFrTnZ5RG85c0VicG1OZ1RRRmxzL3BRZHk1eXpPcFdl?=
 =?utf-8?B?elhHa20wQ0dLVkV2aXdsL2FzSm5SY0tWbFRnc1Q5NzVpc2FyNFlBaGRtTERa?=
 =?utf-8?B?WlJzYmxZbUlOcC9TbFluRlpZRTNGeE9wRXFSNWF0Z2lTM3FkYUZBeHZZZklL?=
 =?utf-8?B?cWxWaGtGaVpPZ1czRW1vNEwrbWRldU5lS09XdmhqQWIzRi9CRDVpQ3c4RWVu?=
 =?utf-8?B?d3dUZy8xa2Jpc2lLSjI4eHFZSUNMRmRPbHBOdmdtR1NoMmJaaGxRWkwxK1Jt?=
 =?utf-8?B?a2gwSXpVQUY2MUFHRnpCNjlCQi9jQjZlZUVRc1lxQ1g2Z1NaVkJJT3FvYzBO?=
 =?utf-8?B?OUl2dVpkczFzVkhXaVFQVStWNm8rdm1jSlFEQnEyTlFQNG9tVkZ4VDUyVU1R?=
 =?utf-8?B?OEhuSUdTbGZMYVJFZ2hqRlFSMGVwSzZWeGoyS04yT1cwbHlCNklNN3JTUjJH?=
 =?utf-8?B?K3YyYWFiZG1KTDhXV3BwTjdHQUY2SFdnZW83OEhPcDIrbEpuREJvSkFnREFW?=
 =?utf-8?B?TFZFZU5PYzlLeDgzQWZ2bEFSY3JBMEpVN2QxSFdLNGJETXNkTnZUZzdQSkN5?=
 =?utf-8?B?ZUFsNU8xRDVmUWw5OHlRY1JQdjdPR0lxakdlaWo3SjBWTnF5ZWVuUVU3aUhE?=
 =?utf-8?B?b1pCRGZXam9ycmNSMGp1UVFsOHhFTzc3VEZ2Q21yVUJBZ2Z6R3orMkhjN2pG?=
 =?utf-8?B?UG1RTm5qWFJFa0hGaWViYnR0RVVabk5HZG90WFozQ2l6b3QzdDJ3MWVwQ0RZ?=
 =?utf-8?B?cy96TjN0SDZ0RVhCR01JS1hZYXIxTmlYQnNHYUJlYTEwekNIbHk4NUZpYTNv?=
 =?utf-8?B?TW5CMytiNDQ2aWlQQzkwazhzb0t2Z1FCRkc1cVJ1TTlDVzhoV2VLL3lhTzJm?=
 =?utf-8?Q?NCQWjEY7AXptMvsZ5KfsEQuo8?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4516.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fb1975e-c744-47fd-21a3-08dce0737368
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2024 10:42:44.1509
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RRKxkzFReJSI30lEDeR+av94L89tOajnfH+mtmdDdkGqJE+kTmOhIrTC0XCybNQO8WzKxfys8wJ7ApVFPv2JMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9397

SGksDQoNCklzIHRoZXJlIGEgcGxhbiB0byBidWlsZCBhIG5ldyB2ZXJzaW9uIHNvb24/IA0KSSBh
bSBhc2tpbmcgc2luY2UgSSBhbSBwbGFubmluZyB0byB1c2UgdGhpcyBmdW5jdGlvbiBpbiBldGh0
b29sLg0KDQpUaGFua3MsDQpEYW5pZWxsZQ0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0t
DQo+IEZyb206IFBoaWwgU3V0dGVyIDxwaGlsQG53bC5jYz4NCj4gU2VudDogV2VkbmVzZGF5LCAz
MSBKdWx5IDIwMjQgMTA6MTUNCj4gVG86IERhbmllbGxlIFJhdHNvbiA8ZGFuaWVsbGVyQG52aWRp
YS5jb20+DQo+IENjOiBuZXRmaWx0ZXItZGV2ZWxAdmdlci5rZXJuZWwub3JnOyBwYWJsb0BuZXRm
aWx0ZXIub3JnOyBmd0BzdHJsZW4uZGU7IG1seHN3DQo+IDxtbHhzd0BudmlkaWEuY29tPg0KPiBT
dWJqZWN0OiBSZTogW1BBVENIIGxpYm1ubF0gc3JjOiBhdHRyOiBBZGQgbW5sX2F0dHJfZ2V0X3Vp
bnQoKSBmdW5jdGlvbg0KPiANCj4gT24gV2VkLCBKdWwgMzEsIDIwMjQgYXQgMDk6MzU6NTFBTSAr
MDMwMCwgRGFuaWVsbGUgUmF0c29uIHdyb3RlOg0KPiA+IE5MQV9VSU5UIGF0dHJpYnV0ZXMgaGF2
ZSBhIDQtYnl0ZSBwYXlsb2FkIGlmIHBvc3NpYmxlLCBhbmQgYW4gOC1ieXRlDQo+ID4gb25lIGlm
IG5lY2Vzc2FyeS4NCj4gPg0KPiA+IFRoZXJlIGFyZSBzb21lIE5MQV9VSU5UIGF0dHJpYnV0ZXMg
dGhhdCBsYWNrIGFuIGFwcHJvcHJpYXRlIGdldHRlcg0KPiBmdW5jdGlvbi4NCj4gPg0KPiA+IEFk
ZCBhIGZ1bmN0aW9uIG1ubF9hdHRyX2dldF91aW50KCkgdG8gY292ZXIgdGhhdCBleHRyYWN0IHRo
ZXNlLiBTaW5jZQ0KPiA+IHdlIG5lZWQgdG8gZGlzcGF0Y2ggb24gbGVuZ3RoIGFueXdheSwgbWFr
ZSB0aGUgZ2V0dGVyIHRydWx5IHVuaXZlcnNhbA0KPiA+IGJ5IHN1cHBvcnRpbmcgYWxzbyB1OCBh
bmQgdTE2Lg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogRGFuaWVsbGUgUmF0c29uIDxkYW5pZWxs
ZXJAbnZpZGlhLmNvbT4NCj4gDQo+IFBhdGNoIGFwcGxpZWQsIHRoYW5rcyENCg==
