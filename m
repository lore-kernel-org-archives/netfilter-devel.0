Received: from mail761.linkedin.com (mail761.linkedin.com [108.174.0.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411393876CE
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Jul 2026 18:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=108.174.0.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784314622; cv=fail; b=s1e1fhjfnuKPa1J8UPbIb/jDPDxFvnYZ556k8H6qtjIUE1OvmoSOX/eT1cPcWhtDx5dEcOj13GQuf9LH4uYnOV+lHig1oMHI1G74Qri8efQDO+O03PgnJsClU0EH2eyJNaRM3kHI44AeX7S5mjnAZH2rFSBvnViUsZ/eazQLMV4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784314622; c=relaxed/simple;
	bh=yIgYM/G9/VnA4N51t334XgPh14Y7a6xYVbqDzYV/rP4=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=oNlKz7bTrBwkRKa8BRwsSuumX4kNabXSSdxtHpW47lwzIQmdXX2DlQQpB+DeRZZmrC6qKfJEVXC031+Ll700Ku9KRkzWpTKGJbbYzeBz3VMTuhR+Dazw6K8ZzkuJtUkNwvTlyh3FpOaAujyiP2QDwQrvpf6Yhgp/xELGhqkeXO4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=linkedin.com; spf=pass smtp.mailfrom=linkedin.com; dkim=pass (2048-bit key) header.d=linkedin.com header.i=@linkedin.com header.b=uFRWiA1G; dkim=pass (1024-bit key) header.d=microsoft.onmicrosoft.com header.i=@microsoft.onmicrosoft.com header.b=ahFpGKej; arc=fail smtp.client-ip=108.174.0.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=linkedin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linkedin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linkedin.com header.i=@linkedin.com header.b="uFRWiA1G";
	dkim=pass (1024-bit key) header.d=microsoft.onmicrosoft.com header.i=@microsoft.onmicrosoft.com header.b="ahFpGKej"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linkedin.com;
	s=d2048-202308-00; t=1784314620;
	bh=yIgYM/G9/VnA4N51t334XgPh14Y7a6xYVbqDzYV/rP4=;
	h=From:To:Subject:Date:Content-Type:MIME-Version;
	b=uFRWiA1Gf5L66IdyrDPyOucw6HFuJOqMoLmcUCey5MeppJbtDhozrAoUjvFVBJJ+7
	 IYsQ2h71F1sDljGEzQdEBfsQV7Pb9/WONWkswfuMJJfLcHdVE+bQbxbt7AJAAqQbPu
	 KdPqCqbdknLzNqJVm7rrjCVleE/OhLAcUzet3zXT1as9NJCmB8/jzvBJv+W7lDXfiH
	 4YWn/7H1d9GMLS4XdiUcanc4ELXIf6Jj39iCfKKUmeJ3z5W3dAxWY15Iu1vqWYWj2Q
	 Jtw1QEBpbKA3HMek8F7tLYa/U+WRyGflLLkvalVa/T/OOQ+q414vHHRZ8G1991myEc
	 1gZKvCoa88oCA==
Authentication-Results:  mail761.prod.linkedin.com x-tls.subject="/C=US/ST=Washington/L=Redmond/O=Microsoft Corporation/CN=mail.protection.outlook.com"; auth=pass (cipher=TLS_AES_256_GCM_SHA384)
Authentication-Results: mail761.prod.linkedin.com; iprev=pass policy.iprev="2a01:111:f403:c10d::1"; spf=softfail smtp.mailfrom="omkhar@linkedin.com" smtp.helo="sn4pr2101cu001.outbound.protection.outlook.com"; dkim=pass header.d=microsoft.onmicrosoft.com; tls=pass (verified) key.ciphersuite="nil" key.length="256" tls.v="tlsv1.3" cert.client="C=US,ST=Washington,L=Redmond,O=Microsoft Corporation,CN=mail.protection.outlook.com" cert.clientissuer="C=US,O=DigiCert Inc,CN=DigiCert SHA2 Secure Server CA"
Received: from [2a01:111:f403:c10d::1] ([2a01:111:f403:c10d::1.27024] helo=SN4PR2101CU001.outbound.protection.outlook.com)
	by mail761.prod.linkedin.com (envelope-from <omkhar@linkedin.com>)
	(ecelerity 4.7.0.20111 r(msys-ecelerity:tags/4.7.0-ga^0)) with ESMTPS (cipher=TLS_AES_256_GCM_SHA384
	subject="/C=US/ST=Washington/L=Redmond/O=Microsoft Corporation/CN=mail.protection.outlook.com") 
	id 07/28-58363-CFA7A5A6; Fri, 17 Jul 2026 18:57:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tmsSvL1xsZjHZVoSNB9nYxry6whpJuMTd+JLgzoMTyOWpXV3sBtSYW+7lgpgjr1ETtgUajqw19Z3AGl3X1jSbnRyWEF2TKTC+0GA7KzP2/q6vbJh+hqXAwd5qf92LZ32YdhQ8sbzrOmKCcd+i6gKpc3wkEFko3zI7+B7UkIPY7fJR82swsCvGfpQtFW5Cn0PWpFXJ/jY8JXhnG9RSAiNA7wv/QMaCiNkpi0xMeKF0XsNVqBVuuFbGNayAuGEdCQb47RCq6JDWfc4OQ7vdk2gvpr9ycNS/4gusasNxrk+xImwcg2Ami9ADTS3Tyjoqy5SBNiU66QC8Mcyhv1OB1zcig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yIgYM/G9/VnA4N51t334XgPh14Y7a6xYVbqDzYV/rP4=;
 b=F/RcZzBueUacSa+QDex9qMOfmgWC0yKtpP21rAqtEUowxDBx6zLdPI3Bl+fAjHDX1CCR5aRvaw7I60LWl3PH7kXTXVYSCj7KYGYToxKf8vOX3LDyuHJjE00U5OQI+2wk204y7NWr7TqVBlTO+nJETH50USTAosZPOPsRAc0hRQ5eGBJ/kvb00rsIzaLYlhfI1PUCrhcTqJBPRC25i8W8icO/wPdsl/1G3IYs7ZPJRjqJuURTyKNVSiCJxm6Lz73dy3O8SY3NJBd3PF7Y0cLcAgf/NgimmR3vYuxp9gPta960HQRui6kVk5zqBO9TsJlfMBa+SB/ZspZsHR56VVw+Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=linkedin.com; dmarc=pass action=none header.from=linkedin.com;
 dkim=pass header.d=linkedin.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microsoft.onmicrosoft.com; s=selector2-microsoft-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yIgYM/G9/VnA4N51t334XgPh14Y7a6xYVbqDzYV/rP4=;
 b=ahFpGKejtHlBfaK5wqNuJIfSSwPlC33T1MfGWIt2weG6X9hn30BC0//k4yNJ64+YbEBpwF/6sRC5H6optJKoJcPA18wZwTK+zvUYwS8tRFJ2yYSIxzA0qv1ZSH5EUPS+e63ubb9ZCPtbzTEawpM3CEjDQAEXYYIOaSM1/r6ns84=
Received: from LV0SPRMB0026.namprd21.prod.outlook.com (2603:10b6:408:340::11)
 by LV0PR21MB6166.namprd21.prod.outlook.com (2603:10b6:408:333::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.2; Fri, 17 Jul
 2026 18:56:59 +0000
Received: from LV0SPRMB0026.namprd21.prod.outlook.com
 ([fe80::cc6a:8bdb:554:a0bf]) by LV0SPRMB0026.namprd21.prod.outlook.com
 ([fe80::cc6a:8bdb:554:a0bf%6]) with mapi id 15.21.0202.006; Fri, 17 Jul 2026
 18:56:58 +0000
From: Omkhar Arasaratnam <omkhar@linkedin.com>
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
CC: "phil@nwl.cc" <phil@nwl.cc>, "fw@strlen.de" <fw@strlen.de>,
	"pablo@netfilter.org" <pablo@netfilter.org>
Subject: [PATCH iptables] nft: bridge: fix among buffer overflow when set has
 no size
Thread-Topic: [PATCH iptables] nft: bridge: fix among buffer overflow when set
 has no size
Thread-Index: AQHdFh3QIPEdUebhhUCcvM5TxvodCg==
Date: Fri, 17 Jul 2026 18:56:58 +0000
Message-ID:
 <LV0SPRMB0026C00DF7CAE003665E672FA1C62@LV0SPRMB0026.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-07-17T18:56:58.627Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=1;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=linkedin.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0SPRMB0026:EE_|LV0PR21MB6166:EE_
x-ms-office365-filtering-correlation-id: 7f30128c-323b-4aa1-1bde-08dee4352df8
x-o365ent-eop-header: Message Processed By - CBR_LInkedIn_Mail_To_External
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|10070799003|38070700021|56012099006|11063799006|10067099003|18002099003;
x-microsoft-antispam-message-info:
 OfMnk8SZrfciwUxb0ZtcC4BrLffLss3wJ73483mUPR9/0ZNaeoUVuRCu7SKrV8om+onl2cdL0oSl9Ntc0fCtMuJeNWfDtC5W3tb7IGpW3pUGszoMbikTvCG3SvphanVJ8E3kYsUvo4uwFA5e1WQdaiVwAM8LSRsIDJ5Tx7EEh3ezk7cuUf49AKzgjQ1gU0c0EPPfIXEfqTbSVa5lt2ysI82/Z2PHDkv3M3fOFaaQ43sMQ0l/MqRTooGZo6IhcyAc5OlEv7MQMvYHLncdiMaPp7+C7bFGAC/6/ftD0tL3XZY979xopSvMrzFTHxbLdAI01z5X88JbsFlFo8NJvZHbii4RfiLnEWL7iZhTdBL6DuFAma08MnasPW1EGY7cgVi8FH23OEn8eAUFGOWT6/ORLk7bU5U46uX26N7qxpNS+zkzPw70XABdwM2T4kGGjELpwbw5UimTG+VpTEfja25DRuJ8f5k0xuJPMU3rEZ2IqKKXViGSDOUXFBzfSmdB1q3Z5opxInCkoLRYA3QZnykSfiqq1PzjX8H5HojuvRQsVI2l2fsq3qFFjfvjxoyU+Q5BrTZexHvVGl7NtaOydlyd5S9jW67DHvwZVtcgycD9mtra7wb9/CDwrFDZMijukHDnpKlCDiJEcsWlLeMqUMA4sEkvOjpCV0i/cLis0F1RhOQvGOkUce5p8PbkU02pxnkTrnx03xwvcsICC9nrecnnVg==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0SPRMB0026.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(10070799003)(38070700021)(56012099006)(11063799006)(10067099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?Windows-1252?Q?ltVFzFzKYbu0iuiGe50nEPbZVV+eqaa60PHRiYv5dX43PLwDuVcH45E8?=
 =?Windows-1252?Q?l/f7fJgrgbtbBz/dIlK7slXLnT7hlNh9O+PglPVdIk+KQ4iVOyIH5o0Q?=
 =?Windows-1252?Q?JVf8MvOUICuhaWAgBRCBa8IG5RtCBXznlsd0hyqsLpGq6951KKB/Hfea?=
 =?Windows-1252?Q?6c+jOcsoFLeOqGMKKbp8ZS7ZYKqjLOmdAWrY2Wm238K+srBZY/wXedFU?=
 =?Windows-1252?Q?UbBU0++6LTezykNlTkd0h7Rq+jghbEOdTz+1LdlUtvMtMjt00iEWFzUa?=
 =?Windows-1252?Q?oXt22PiMB670pt36IkHio4fHBzSPIV0aqt79lz9HTX8WJFBv2sxygNsu?=
 =?Windows-1252?Q?WWZk75cVkIIMNf1IAALr2+rlqMx+7Fcwz9A03Gb079U2Zv61kHX/PhNx?=
 =?Windows-1252?Q?GKFEDkA9FLYAbw0/NQMzlPuvN4MTFjeiowzTwe1pkkyLy56/LVdUehN3?=
 =?Windows-1252?Q?3iDZ+YKxP2xeGgsWKtdY3r5j7zqqB54tmyN8K3La56U6pAfK5ZlYWNBA?=
 =?Windows-1252?Q?0x+RuflMkMy2Et1x9mPg7oi95gcZM+L4Z2IuuwSffaff5dBziRWMmLbw?=
 =?Windows-1252?Q?0+Y8BUjeusjkSTjXrKaTcissBr/XBGQhtuOg7725a1uo6ATVbyff/an1?=
 =?Windows-1252?Q?x5+AFOnIvcjc1sZ77pcQvetJVum15nrAx224hQ6ow3G6bUFMdAL0shzS?=
 =?Windows-1252?Q?ngZDCJ5p/WZKOxh2aP7sQMIT6FAeHSaSnNJ4m/43zkMXFw7d/xaC8h3R?=
 =?Windows-1252?Q?lQFdXI1JrCW6p52yZ+cYC2bwJ57ynu9Jy/1YzInTwPnbfXky0q053eqh?=
 =?Windows-1252?Q?yHX0U+j5pJoZWDGCgQ2UUL8Ce4Jv3GPNubB/JNeLAZEs0Ez3vK4Bq5sK?=
 =?Windows-1252?Q?hAkpne0+vOXSREzsJpADWLYJJpJsrN4DtUgFrS3zvxhbOnCohmjYy36S?=
 =?Windows-1252?Q?2ZlAkuPTW5B66OufSRpDWEv/qnG3xTlXBBZiXPB3A/4nWSlpJq9GTUBb?=
 =?Windows-1252?Q?udo8ap2KkE9uFt39ubVURi6BGXYnQmy/ziT+1b2ik71srQc9dgjTzkdi?=
 =?Windows-1252?Q?q/4NxOi0BmUj7gXhaIfYv3Eo0hkRGSNeg5/fm6yalWnKMKBLVXcWUejS?=
 =?Windows-1252?Q?y5pvEXlE2wIvoGslN9hZuNmXr3tctJNZalChcqk1PIf94vwB9n6Zerl7?=
 =?Windows-1252?Q?0j4AdItjSrN86par7277IRT8uIm9m6lGPiGqcnv77cTnweQ9TWw67yGN?=
 =?Windows-1252?Q?VII9Aoz6jVbH1PTW3LhhAE5wiyz14Nn/rCAhUeMwkaGlYYwJ0oOo9tv5?=
 =?Windows-1252?Q?CXNgC9VUlacO+3fG7ZhhFHJlsaL/G6CfzM8J1qdq0Iasa8upo6zHhq//?=
 =?Windows-1252?Q?1wz48GdoKp3lurvOSyCEGFZiev26mrdjPEbAaQD0dwybyp5Sm1klr/F1?=
 =?Windows-1252?Q?lg00AJNoY5WKEkqp19CJXWCVfaku2fpPgaFnE1eywQa5CHghRYC+0FYW?=
 =?Windows-1252?Q?FjQtk74dAgsFXEWVf60zQS07Apb6bom81BxhllF6/U0P/y45Ll75IULZ?=
 =?Windows-1252?Q?Zyq/AgiYYokPM9DhnZ7racOSEt9nAV3G6SRfnw7jwhbj0TLRSK7hQGhd?=
 =?Windows-1252?Q?xXMDRqQbG/UfRQs6LcEd1TGqPbSC7fNhI8wcz+KNd5SdE0+jloYD8+FJ?=
 =?Windows-1252?Q?do+sGnPC09KdRM65NSfJVon2ujjXrV7HENdtipH00p55sobkW5mZm698?=
 =?Windows-1252?Q?nL12ixc3Xjv27uTIaiAeQfP+c0lbQ1GzM/2k+TOc6w3PTB9bnhxLM0u/?=
 =?Windows-1252?Q?0o+qqiTJ2c7DDEnM8sOquTETCbwa1rSdPrfbUMoRQs/5UDcgJWxMNxyN?=
 =?Windows-1252?Q?+5W4rTebX5Aj22xbdoekSEb6TbLkf6irmm3eq+bScgmH8YJ/viY7L5dn?=
 =?Windows-1252?Q?xOov3v+7?=
x-ms-exchange-antispam-messagedata-1: igXtaGptvRzdeg==
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	BAPLEc50MXP4CwI3g6TPWI2lVZ+UiSlLCm0/FdNnBgMYkuS+X8uTF4bJHx2DJ9kdIo9dXy03Ws4yamYyM/joaOTU1YlILJ86XzBD4KEeUii5Jf6jzCPMSLrbLLePCHwlznSIfB01w7BYU/iFn2CxaGSw6pzNYVwEYmPB7K/syVzBrOIAZuC04coieAn463nUhL7VKRYZbSYL3iDg9j4TOSeaZp7uQPnKRT+SMzGI/75hHbHeCTVeqE7JEqx1pQTx2Luyn7xdnKOcBZmQpf3Gwx2juKUfS5aYm8v4ge9guBQLT2rdJ7EXZWUygQ2Y+Uoyyx7opsUbCfgVyAMoLBD6Sg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OTCIfOFc8LU2SxSghnBhYdomogUc3t+sD9zXdIcy+kUoc0q6u6Sx2wykfuZax1qkLDhq3xx9m5Epf4Rci3qBJi9XIUUqorvFagAHSKX2eD/GaFyrbipYNhSZ3/gBolck4+gS7Ie+eQIdSzDX1HigUuaR/KuDAz7AJJYz93c6PbEIuQs4hs785Eulbf9ajkHzrjt42nY0ejuJKiD9CXkfGtJv4F4r48sOtfBxjzxD7kxOFmknU2ZL9P3o7Z/h+ljyY733e8fvSvieA+rdSQfctZDuzUv8ovsicuTt0rIeFJwIaOuvmlLlkNygz1N7nnyhcm9p+Cx0mkBdjMu77bnuNYRfF32QR9K5CHKyFd5ToJauAnfT9kfFpP/yPUQpzdPtnectm0nXKfto69I8RfeptoMWlhPIX+0kzS8MB9EfHxURjMTMR7q2cnLrWfBV8WjCW+C65SKfu1tt018aic2m4bWN9HoZHFXrWcHHvQWmDCn6SVV9gim7iqS8ZOI66kN+IBJ6cmoGsyRaUcLvtCyR0cogn6ysObbKfJyARiO5DIdQLoH399cVVnGeaYprbfs0hLDGUnqYDfGISip2lL/EMzt4kzutM2a8WUDqEtU8BSkj/UqwpAZ14xEdQ3zLFYxujUXRZTQwlpbo3VQtNu7Jtvlg68u/dV0FT5eHrA5jeeE=
X-OriginatorOrg: linkedin.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV0SPRMB0026.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f30128c-323b-4aa1-1bde-08dee4352df8
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2026 18:56:58.8429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o6mTi1CGNjgkRF2JUjmOGyvfXqnsOfCuBQTBAy6ijREfWQbBtYIXHMB8mtnljGWLO+CVsB/K+qtCdW0bXxwP5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR21MB6166

The among match parser sizes its pair buffer from NFTNL_SET_DESC_SIZE:=0A=
=0A=
=A0 =A0 =A0 =A0 cnt =3D nftnl_set_get_u32(s, NFTNL_SET_DESC_SIZE);=0A=
=A0 =A0 =A0 =A0 ...=0A=
=A0 =A0 =A0 =A0 size =3D cnt * sizeof(struct nft_among_pair);=0A=
=A0 =A0 =A0 =A0 match->m =3D xtables_calloc(1, size);=0A=
=A0 =A0 =A0 =A0 ...=0A=
=A0 =A0 =A0 =A0 set_elems_to_among_pairs(among_data->pairs + poff, s, cnt);=
=0A=
=0A=
NFTNL_SET_DESC_SIZE is the hash-table size hint, which is only present=0A=
when the set was created with an explicit "size". A set created without=0A=
one (e.g. via plain nft: add set bridge filter s { type ether_addr; })=0A=
carries no NFTA_SET_DESC_SIZE, so nftnl_set_get_u32() returns 0. The=0A=
buffer is then allocated header-only while set_elems_to_among_pairs()=0A=
still walks every element of the set and writes one nft_among_pair each,=0A=
overflowing the allocation on the first element. Listing such a ruleset=0A=
with ebtables-nft -L (or ebtables-nft-restore) corrupts the heap.=0A=
=0A=
Size the buffer from the actual number of set elements instead, i.e.=0A=
exactly what set_elems_to_among_pairs() iterates over. Sets created by=0A=
the among match itself are unaffected: their element count equals the=0A=
NFTNL_SET_DESC_SIZE that was used before.=0A=
=0A=
Fixes: 26753888720d ("nft: bridge: Rudimental among extension support")=0A=
Signed-off-by: Omkhar Arasaratnam <omkhar@linkedin.com>=0A=
---=0A=
=A0iptables/nft-ruleparse-bridge.c | 22 +++++++++++++++++++++-=0A=
=A01 file changed, 21 insertions(+), 1 deletion(-)=0A=
=0A=
diff --git a/iptables/nft-ruleparse-bridge.c b/iptables/nft-ruleparse-bridg=
e.c=0A=
index aee08b13..fc877d43 100644=0A=
--- a/iptables/nft-ruleparse-bridge.c=0A=
+++ b/iptables/nft-ruleparse-bridge.c=0A=
@@ -306,6 +306,23 @@ static struct nftnl_set *set_from_lookup_expr(struct n=
ft_xt_ctx *ctx,=0A=
=A0 =A0 =A0 =A0 return NULL;=0A=
=A0}=0A=
=0A=
+static uint32_t set_elem_count(const struct nftnl_set *s)=0A=
+{=0A=
+ =A0 =A0 =A0 struct nftnl_set_elems_iter *iter =3D nftnl_set_elems_iter_cr=
eate(s);=0A=
+ =A0 =A0 =A0 uint32_t cnt =3D 0;=0A=
+=0A=
+ =A0 =A0 =A0 if (!iter)=0A=
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 xtables_error(OTHER_PROBLEM,=0A=
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "BUG: set elems i=
ter allocation failed");=0A=
+=0A=
+ =A0 =A0 =A0 while (nftnl_set_elems_iter_next(iter))=0A=
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 cnt++;=0A=
+=0A=
+ =A0 =A0 =A0 nftnl_set_elems_iter_destroy(iter);=0A=
+=0A=
+ =A0 =A0 =A0 return cnt;=0A=
+}=0A=
+=0A=
=A0static void nft_bridge_parse_lookup(struct nft_xt_ctx *ctx,=0A=
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 str=
uct nftnl_expr *e)=0A=
=A0{=0A=
@@ -328,7 +345,10 @@ static void nft_bridge_parse_lookup(struct nft_xt_ctx =
*ctx,=0A=
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &is=
_dst, &have_ip))=0A=
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;=0A=
=0A=
- =A0 =A0 =A0 cnt =3D nftnl_set_get_u32(s, NFTNL_SET_DESC_SIZE);=0A=
+ =A0 =A0 =A0 /* NFTNL_SET_DESC_SIZE is unset for sets without an explicit =
size, so=0A=
+ =A0 =A0 =A0 =A0* count the actual elements instead of trusting it.=0A=
+ =A0 =A0 =A0 =A0*/=0A=
+ =A0 =A0 =A0 cnt =3D set_elem_count(s);=0A=
=0A=
=A0 =A0 =A0 =A0 for (ematch =3D ctx->cs->match_list; ematch; ematch =3D ema=
tch->next) {=0A=
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ematch->ismatch || strcmp(ematch->u.ma=
tch->name, "among"))=0A=
--=0A=
2.34.1=0A=
=0A=
=97 oa=0A=
