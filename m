Received: from lgeamrelo11.lge.com (lgeamrelo13.lge.com [156.147.23.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066E4234964
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jan 2025 05:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=156.147.23.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736830824; cv=fail; b=RBjnhtZZnz24rRfXZeR4sX0X3uRs7qHIZgxgHvZHL160VTdix/+FCiiBBKawAcIiZqtLbw2LrU4xuHtTIUSpFKCl3Jw77l66IAO5WveL6tWeTfgwyl+dzKj8nuPovcEzG4/jOTPP5HPTeD5wn7LuoE39bVQEvCys1ZjgOSL1pLE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736830824; c=relaxed/simple;
	bh=3UAZyNQHLpkscxtuwVoAQQ2Hzs2HTJamRxgyWrhbZ4o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DPwPs/yp6K3XHUAMceciNCE/zdVN/k0Wwu2BauebccZ8Lekk6rhSDjfrclLqNAFk5YIxujYmA0hkpS/jBgVUt+8Tncuamc21+SLFbneMBZt+XfIWmQjxh9mcJcuRn38zU03pu4Flr4PzO6KWwznNG4WDi2u8J+J9sQTr6O0LURk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=fail smtp.client-ip=156.147.23.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO lgemrelse7q.lge.com) (156.147.1.151)
	by 156.147.23.53 with ESMTP; 14 Jan 2025 14:00:16 +0900
X-Original-SENDERIP: 156.147.1.151
X-Original-MAILFROM: hongsik.jo@lge.com
Received: from unknown (HELO sniperexo7.lge.com) (165.244.66.188)
	by 156.147.1.151 with ESMTP; 14 Jan 2025 14:00:16 +0900
X-Original-SENDERIP: 165.244.66.188
X-Original-MAILFROM: hongsik.jo@lge.com
Received: from unknown (HELO PUWP216CU001.outbound.protection.outlook.com) (40.93.139.7)
	by 165.244.66.188 with ESMTP; 14 Jan 2025 14:01:55 +0900
X-Original-SENDERIP: 40.93.139.7
X-Original-SENDERCOUNTRY: unknown
X-Original-MAILFROM: hongsik.jo@lge.com
X-Original-RCPTTO: pablo@netfilter.org,
	netfilter-devel@vger.kernel.org
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WrFkuNkzv29ROXJZMZ1DmGaGB9PuLCExhl3Wp5pEZeuEdH/HCEuFY/GHzNJMBzsPGNQEsVvlySDjOYyFSN8bZAY2OX4Rxg/Qa5WBw1F3ax+hkXFCKIqYTxgY3TPTxPuKYhS43SGu/2ek1JVWfPPN9NsqVHyvIzjePVYJxvvwXu+nf0cqwXPrKpwscOLxGyATfUW/+bCjsvSOBeNEav8iQg5VsiXxytSHUPjcvBz6Wgn1AInRB6UmmdSmMxDSi3KBYFX3OUSEtdtyOUNa8zj3ynz0YDLj3HM73Er8XNBFZke0JTvY3IfxZ0KXlDDuSqBbCSyh9SvwF6kiUOnXFjIs4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3UAZyNQHLpkscxtuwVoAQQ2Hzs2HTJamRxgyWrhbZ4o=;
 b=NGG3+Hc7hLtOYb9BX/xJsBCVL5vwim63cczTBooZpwCwNSReuCn9GVjCSQxPrVrEdWcrDE/8ME41oqQmZQWS8fGDiMp2AOhOJJGJo9cltp53QV1dmwv/pkkTh1D19NrE2QJLHjfMbIppkTuRdX65/Pus/Ui/VKJi7dz5JiTdCxJ54J0ocIcdgO7VDAcceO2xr5bEu8p68fSeh5FHfhsT7nHGpDxMd543TDDp+ISYqaBpR/X1hKE/6t4i16Oofqp7yQsOzVNahvrGtjkV/Icn1rED+KdCaGujRqaaXvaffTVAx3Tqe9PxMo6C33HQbzh3CUzeKkg011eypTCQ+tE29Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=lge.com; dmarc=pass action=none header.from=lge.com; dkim=pass
 header.d=lge.com; arc=none
Received: from SE1P216MB1558.KORP216.PROD.OUTLOOK.COM (2603:1096:101:28::7) by
 SE2P216MB2835.KORP216.PROD.OUTLOOK.COM (2603:1096:101:292::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.19; Tue, 14 Jan 2025 05:00:14 +0000
Received: from SE1P216MB1558.KORP216.PROD.OUTLOOK.COM
 ([fe80::cdf9:f1be:d666:7315]) by SE1P216MB1558.KORP216.PROD.OUTLOOK.COM
 ([fe80::cdf9:f1be:d666:7315%7]) with mapi id 15.20.8335.017; Tue, 14 Jan 2025
 05:00:14 +0000
From: =?utf-8?B?7KGw7ZmN7IudL+yxheyehOyXsOq1rOybkC9TVyBTZWN1cml0eeqwnOuwnA==?=
 =?utf-8?B?7IukIFNXIFNlY3VyaXR5IFRQ?= <hongsik.jo@lge.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
CC: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	=?utf-8?B?7IaQ7JiB7IStL+yxheyehOyXsOq1rOybkC9TVyBTZWN1cml0eeqwnOuwnA==?=
 =?utf-8?B?7IukIFNXIFNlY3VyaXR5IFRQ?= <loth.son@lge.com>,
	=?utf-8?B?64Ko7KCV7KO8L+yxheyehOyXsOq1rOybkC9TVyBTZWN1cml0eeqwnOuwnA==?=
 =?utf-8?B?7IukIFNXIFNlY3VyaXR5IFRQ?= <jungjoo.nahm@lge.com>,
	=?utf-8?B?7KCV7J6s7JykL1Rhc2sgTGVhZGVyL1NXIFBsYXRmb3JtKOyXsCnshKDtlolQ?=
 =?utf-8?B?bGF0Zm9ybeqwnOuwnOyLpCDsi5zsiqTthZxTVyBUYXNr?=
	<jaeyoon.jung@lge.com>,
	=?utf-8?B?7KGw7ZmN7IudL+yxheyehOyXsOq1rOybkC9TVyBTZWN1cml0eeqwnOuwnA==?=
 =?utf-8?B?7IukIFNXIFNlY3VyaXR5IFRQ?= <hongsik.jo@lge.com>
Subject: Re: Symbol Collision between ulogd and jansson
Thread-Topic: Symbol Collision between ulogd and jansson
Thread-Index: AQHbZYUZeSfuxQZz00yVbYxjbJSvM7MVSF+AgABtups=
Date: Tue, 14 Jan 2025 05:00:14 +0000
Message-ID:
 <SE1P216MB1558D45C17B9EFF9176AC5C38F182@SE1P216MB1558.KORP216.PROD.OUTLOOK.COM>
References:
 <SE1P216MB155825DDA1CD5809E1569DDE8F1F2@SE1P216MB1558.KORP216.PROD.OUTLOOK.COM>
 <Z4WSRVQPmmYfpqvV@calendula>
In-Reply-To: <Z4WSRVQPmmYfpqvV@calendula>
Accept-Language: ko-KR, en-US
Content-Language: ko-KR
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=lge.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SE1P216MB1558:EE_|SE2P216MB2835:EE_
x-ms-office365-filtering-correlation-id: a386e5cd-51c8-4177-07da-08dd3458552a
x-ld-processed: 5069cde4-642a-45c0-8094-d0c2dec10be3,ExtFwd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?VmN5NWM5VEFqck45amphdmpHbzlFaXFicTB0TWtObUFJUVRFSXB5aHM0T3RH?=
 =?utf-8?B?M2k3K3Jra2ZiS3lMcnZ2N2pXKzYzZjR4NDk1R1ZxMVVMK01JWVJ1YjFlZ0l2?=
 =?utf-8?B?bkZOVTIweUs3YVdlcVhvU044RFVPNXorSDNMbU5MYVJFaC9BWnByb0JaUEF1?=
 =?utf-8?B?NXpTaktzclUrZjlRVWZacjl4VjRFL3Fxa0t4K0lYb3FydHZwbTcyb3cvcStn?=
 =?utf-8?B?NFRRZ3JXQTYrNW9jSURydjM1Z25EQ0U2MDE4RXc4VmxrSUovYjRoRzdGbTdl?=
 =?utf-8?B?UThiVjhjL1JaejdwT2dSWWNqWWxIWkY0aVdNY2V1QlVnOXp6NERweTEzWGZB?=
 =?utf-8?B?S2xCSHZiQTFUcVF1d2N0eTQyNGxOSjFCdzlLWWYyMmJ4bEIyOGlGQmVKOGVz?=
 =?utf-8?B?LzU0L2FZNUNORlVHOERVOFI2RXpOYjF1R2R3M0FyK295MFJuUGZqVFFwTXlS?=
 =?utf-8?B?b2t5amZtVy93L1RxMStNNXduYWluaElCVUJzRFpVczNkSFIwUTd6eFR0K1Q2?=
 =?utf-8?B?ckdrT29nUTJWSTBybHNEZnU2QkhkbktycnNBSTFKSHRRNTZEekpsRmM5VVB2?=
 =?utf-8?B?WEtkMkkzYTFEUlpIUnNxK2JnR2drNElwVGlhOWQrRXptRjdjTExZVWRiR3Na?=
 =?utf-8?B?WFJwMVB3UEgzdTNVUnB2NVR2ajhOaXYxSnB1dXNuZTRJSmEwOXVHcS94QlRa?=
 =?utf-8?B?NG9tekhPb2hOdDRGZ0NJbGZWem5TMFRBQjRxZ2F5WTRvZktsS2RaaWdDT3gx?=
 =?utf-8?B?T0JoL1VUbjE4US8ycS95dkhuRWdQVmdTZjAyZXovb1dFcHViUG4rVnVpMzM5?=
 =?utf-8?B?Tmlna2VmWWlLOTFhWlBxS09jbTU0MU9kMWt5dTJLZVNUOWtVeDVBdzAvY3RL?=
 =?utf-8?B?aW9PeHZ6dFYrSjQzNXpxeXV4VlVJcnRVRjY5dHFuYjd5ZnZra3gxOHpVMEFq?=
 =?utf-8?B?c2hiejhvR3RoWURtaU1xUjgyd201MTVTSDduN1V6SXFhZklYVzVyREFXcTRy?=
 =?utf-8?B?Ti9TUWg0T3YwTDRGQk0zVWRua2xNN0VVNTl0ZUgwNjRrU1hBd1pYeE5hdnFN?=
 =?utf-8?B?Y0xLTUJ3MU1UcDY3aGlidEkweGdtYldsSHBtK0d2VFVIdEdaRWtjc25mcHJF?=
 =?utf-8?B?Q1lMbyttazNZTzgybS9WWHZVaU1sQVF1Wk8wMkNENzlETTg1UklGS1VJVWJj?=
 =?utf-8?B?UXFUQ1E1amxQNWlQZGFsS1VWYWRUVTk5eW5hdzM1RGc3NUMwWUxwZTJ5K25l?=
 =?utf-8?B?blA2ejhTcEg1L2dRUDBRSUx0NW9UMWtzandreDhxL0pWckcra05zcXRpSUhI?=
 =?utf-8?B?RzZrNTdTR3lpRVJ6cWhBU3ZVMnNUSG4wU0NUNVAxQ3VEOFBobm95ekptakR2?=
 =?utf-8?B?bTlhQXFaQ1B1QUlxM2pkNWYzc3NUdDR0aWZSdFVRYzFHS2prbC9pUFVrdkFK?=
 =?utf-8?B?dG1UNjB4SXhyK1pjR3VUZmZJallDTGVueTNyWWI5SjdiQUhDY3JDWlJtVDdo?=
 =?utf-8?B?ZTQzeGtBOGhXazRoRnBPdlpUOVRheXBGeGk0SmUrd2J4RTFpR2E3ajhoWFVq?=
 =?utf-8?B?R3ROd3cxV0kyQ00xc3pMemFGTEdiK0dNNTlBd1pQK3RNT0RPWGdQL0E4MU53?=
 =?utf-8?B?eUpCSmZmM2Z4N0NhTUZSYmkwbWwvb0tmcjZuRlAxbzIzS2w2aHBZQkI2dGVQ?=
 =?utf-8?B?U3pGSHhiaTBvcHNjMWluRk9pcEF5Zjh0czdWZTlJU09JSnhXWVZyOUk3eDlI?=
 =?utf-8?B?ZXR4SWF6eTI2d3hRTlpqbzdCaklHTUFMcEdDTWZJZnZUcWtWTUc1QlhaeUNt?=
 =?utf-8?B?bkJtNVRXNng3MmJJMVRiVkhHZG9wcDgwVWFhWDY4TkV3L3JTYXArbVlLMHB5?=
 =?utf-8?B?NFZwaXVEL01Dd010dStTbEUzWFVobS8razE3QWdMSENBVVdIbmQ3UVJuZ251?=
 =?utf-8?Q?t9OAypvkT1DE78M+MN7TjQVKRsK/MrMH?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ko;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SE1P216MB1558.KORP216.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VU5nQm9LaGlPdVRRaVNuWWxsQlhXV1ZoMlZxUWJhOEpjU28wTXdxNXVzYmFa?=
 =?utf-8?B?K2ZlN0htNjBDdGtsdzRSeFBaN0diTkRPbkIvMng4cXYrWCs5Q3BodFVXOGxO?=
 =?utf-8?B?ZDZMNGdaUDBlUUdEUFRFbE1JSSttWFc4ZWZWMVJ3RTNqQlJzb0xUWUdMUmV5?=
 =?utf-8?B?T25neC93Y1pMMTlkcFdMY3czMlBpZzVVRzJrSlFsSnZKbGlVdi9lUzlsRDgv?=
 =?utf-8?B?dEgrWTk0Y24xQkR6OUZoTmF6MlhxTHA1Zzk4WW9oYXVrUjAvR1lVMG5lV2tO?=
 =?utf-8?B?N2ZXVTByTnJWaDRaZ1oySjVJSGFINHdnSmhSSGpteWFoT05qMTdlaDltdklY?=
 =?utf-8?B?d1dpNFJmSUwxWkhkeC9yaVRjMTQ2dUVtNGhpd1FOb3FTeW0zTSsxdFhCMDJV?=
 =?utf-8?B?VnBqelpHK0MzUnZnT2NzcUQ3QVd3YStXcTE3ejlXK01kODZIM0lIUUJGTjFx?=
 =?utf-8?B?NEl5WDBvQk9JWUliQzF3dnBoYjRCdVU1RUJYMDJRemRoV0t1cVh5NC9seDZr?=
 =?utf-8?B?R3VEUnVqY201Ym1xRUM0aTY2UHVFcnJGNmNiY2JQUEhyZlpSWDY2aURVdFlP?=
 =?utf-8?B?b1pzMzM5T3k1MytldkovREc5SFNxMUpTK09TN3FFM3dlQWRXZFB1RjNxcjBo?=
 =?utf-8?B?YlpBa25SajdyZGVWR1hDRC9rZ3lqRkJhVDFwK2xib3l6aENtVnorUHgxRFhm?=
 =?utf-8?B?OTAyVmtza1hvTlBDVEVkN2REYU5NRlk1MVZGYUlsUEVHZHIyRFh0QVo1UlZ3?=
 =?utf-8?B?T2IxTDhQL1RnMFNRa0RFV2pENTdYdkR5d3ZCaTZ5MGkzbEZYanNjRHk1eHVK?=
 =?utf-8?B?WCtaWEZyR0FUTDF2a0dzT3RGbXFZTmw0SjI5WXFDZUNSWk5KbDFEVGtMeitY?=
 =?utf-8?B?UmJ2NUZsWkV4bytpY01zeUVUUEp3cnRpN0cwRXFjOEFydm9vRE9zME93elo1?=
 =?utf-8?B?Vi8ya3p4YUhDckhYb05BWEhnZFBjNmltUlpHVXBEcVZLUXJqdEZZUllRcnpw?=
 =?utf-8?B?eEZnYWhhZmptcVl0ZlhYbUZXRVUrcmdpRHp4ZTNmSUl0NFhOMkp1dE0xR2k3?=
 =?utf-8?B?L055d0ZmbzVDRFFjWW9OVkI3RnJhQnBSMnVOdk93eDRkVFk0WnhJNDllNUpv?=
 =?utf-8?B?Z3NKcTBSTTFveGZHZGZRdWpyWEM4WEhhb2NBdVFWUDZZbGZ0QzMxM0hTZmNn?=
 =?utf-8?B?UWNSOVAvaTJmRlkwZXJuZTM4MVZmY3NQdXJxd1N6VFJQSkVmVjJKSkxWdnZQ?=
 =?utf-8?B?YzFJRldFSzVuRGhKOFJFN2JPS2xvWUxNZjl2MmFtMGVtZnJOTnB5UmdmaWFF?=
 =?utf-8?B?dTdicjFiTU1hcGZHSWd2dXVDUERpaUoyejlTZkpEWGx5cklORlBrODdLV000?=
 =?utf-8?B?dS9hUjBuZUQ4ZmVoYVdmOGV2YUtjd1c4NFV6MVFjR0F4YXBtU1dVZWJmREk0?=
 =?utf-8?B?YjVkVlpvejFKUnI0TDVyRUdXSUVHMlhYbGlPeGhnclhKYUpQZm9qZWs3TFdM?=
 =?utf-8?B?QVFMRmo2dlpCL3pYNXg0VmZmNFFMN25wdnRHUEFFRFpvVURNVG1NRk5kUE5I?=
 =?utf-8?B?STFZRTFIZ2dTeHBzMDVJTkpsY2lBV1hORFBhaVJlNGdjSTk5aktKRm1UWUg3?=
 =?utf-8?B?bzY4SCtQQlNTempVRG5iM044N0RDZVVZWFBsSHpITzJpaVBzVS91OGxrdE1q?=
 =?utf-8?B?OHhrQWFlbWhkMm5GODBRc1Nub05MUEtDc3V2eWNDdEljNG8wcVdOalU5dWMv?=
 =?utf-8?B?VkVidU15SVhtRTV4R2dVVG9LcTJzQlBjMkJ5VWtpbkNGL0hBWi9WLzE2anFv?=
 =?utf-8?B?YWtMSkxCZ1FtR2JGNXhzVGZLVmI0OERkQVRZS2JDMEc4L2xUR21VeWlHSkV2?=
 =?utf-8?B?bVpCN0FPYzE5aGJnRXhSOGdNRTZrd3p3Qmh3di9RYmZIc2FHckxUcnlyR2c0?=
 =?utf-8?B?V3dGWXE2Q0xWZTRERDJDR3RKRWpSc1grQ0ZVSkltL3FjLytUcDJaYWdOTFJZ?=
 =?utf-8?B?Sm9FSnFtbnB4VWxSMEtEV3ZDdHlBZTB5bmkzSk9LMU5VZ2RaRU9FQ2prSlhl?=
 =?utf-8?B?SS9odTJVUGJGUzR3Mzh1d2o1OFhyaXhqbjRSVk5aVlpKQkp6UHZmWWhLeE9n?=
 =?utf-8?Q?noA4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: lge.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SE1P216MB1558.KORP216.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: a386e5cd-51c8-4177-07da-08dd3458552a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2025 05:00:14.6499
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5069cde4-642a-45c0-8094-d0c2dec10be3
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dgyxgOOkZnVqvraYiSw1bYyQNqvnHDmNIISJ10Pf8L4dM4qx9CF38Tx1K24Y5BfdLotRd91vP0M3acrovrySvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE2P216MB2835

SGVyZSBpcyB0aGUgcmVzdWx0IG9mIGZpbmRpbmcgc3ltYm9scyBpbiB1bG9nZCBhbmQgbGliamFu
c3Nvbi4KCiQgbm0gLUQgbGliamFuc3Nvbi5zbyB8IGdyZXAgaGFzaHRhYmxlX2RlbAowMDAwMDAw
MDAwMDA1YjUwIFQgaGFzaHRhYmxlX2RlbEBASkFOU1NPTl80CgokIG5tIHVsb2dkIHwgZ3JlcCBo
YXNodGFibGVfZGVsCjAwMDAwMDAwMDAwMDc3MDQgVCBoYXNodGFibGVfZGVsCgpXZSBkaWQgbm90
IGJ1aWxkIGl0IGFzIGEgc3RhdGljIGxpYnJhcnkuCkxpa2UgeW91IG1lbnRpb25lZCwgSSBhbHNv
IGRvIG5vdCBrbm93IHRoZSBleGFjdCByZWFzb24gd2h5IGEgU0VHViBvY2N1cnMgaW4gdGhpcyBj
YXNlLgpIb3dldmVyLCBJIGhhdmUgY29uZmlybWVkIHRocm91Z2ggc291cmNlcyBsaWtlIEdQVCB0
aGF0IHN5bWJvbCBjb2xsaXNpb25zIGNhbiBvY2N1ciBpbiBzdWNoIHNpdHVhdGlvbnMgKHRoZSBw
b3NzaWJpbGl0eSBvZiBzeW1ib2wgY29sbGlzaW9ucyBkdWUgdG8gdGhlIGxvYWRpbmcgb3JkZXIg
b2YgbGlicmFyaWVzKS4KCkFuc3dlcnMgb2YgR1BUOgpUaGVyZWZvcmUsIGV2ZW4gaWYgYSBzeW1i
b2wgdmVyc2lvbiBsaWtlIGhhc2h0YWJsZV9kZWxAQEpBTlNTT05fNCBleGlzdHMsIGlmIGEgc3lt
Ym9sIHdpdGggdGhlIHNhbWUgbmFtZSBpcyBkZWZpbmVkIGluIGFub3RoZXIgbGlicmFyeSwgYSBz
eW1ib2wgY29sbGlzaW9uIGNhbiBzdGlsbCBvY2N1ci4KSW4gc3VjaCBjYXNlcywgd2hpY2ggc3lt
Ym9sIGdldHMgY2FsbGVkIHdpbGwgZGVwZW5kIG9uIGZhY3RvcnMgc3VjaCBhcyBsaWJyYXJ5IGxv
YWQgb3JkZXIsIHZlcnNpb24gaW5mb3JtYXRpb24sIGFuZCBlbnZpcm9ubWVudCB2YXJpYWJsZSBz
ZXR0aW5ncy4KCkFueXdheSwgSSdsbCB1cGRhdGUgdGhlIHBhdGNoIChpbmNsdWRpbmcgU2lnbmVk
LW9mZi1ieTrCoCkgaW4gbmV4dCByZXBseSB0byBkaXZpZGUgdGhlIGNvbnRlbnQuCgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCuuztOuCuCDsgqzrnow6wqBQYWJsbyBO
ZWlyYSBBeXVzbyA8cGFibG9AbmV0ZmlsdGVyLm9yZz4K67O064K4IOuCoOynnDrCoDIwMjXrhYQg
MeyblCAxNOydvCDtmZTsmpTsnbwg7Jik7KCEIDc6MjMK67Cb64qUIOyCrOuejDrCoOyhsO2ZjeyL
nS/ssYXsnoTsl7Dqtazsm5AvU1cgU2VjdXJpdHnqsJzrsJzsi6QgU1cgU2VjdXJpdHkgVFAgPGhv
bmdzaWsuam9AbGdlLmNvbT4K7LC47KGwOsKgbmV0ZmlsdGVyLWRldmVsQHZnZXIua2VybmVsLm9y
ZyA8bmV0ZmlsdGVyLWRldmVsQHZnZXIua2VybmVsLm9yZz47IOyGkOyYgeyErS/ssYXsnoTsl7Dq
tazsm5AvU1cgU2VjdXJpdHnqsJzrsJzsi6QgU1cgU2VjdXJpdHkgVFAgPGxvdGguc29uQGxnZS5j
b20+OyDrgqjsoJXso7wv7LGF7J6E7Jew6rWs7JuQL1NXIFNlY3VyaXR56rCc67Cc7IukIFNXIFNl
Y3VyaXR5IFRQIDxqdW5nam9vLm5haG1AbGdlLmNvbT47IOygleyerOycpC9UYXNrIExlYWRlci9T
VyBQbGF0Zm9ybSjsl7Ap7ISg7ZaJUGxhdGZvcm3qsJzrsJzsi6Qg7Iuc7Iqk7YWcU1cgVGFzayA8
amFleW9vbi5qdW5nQGxnZS5jb20+CuygnOuqqTrCoFJlOiBTeW1ib2wgQ29sbGlzaW9uIGJldHdl
ZW4gdWxvZ2QgYW5kIGphbnNzb24KwqAKSGksCgpPbiBNb24sIEphbiAxMywgMjAyNSBhdCAwNjo0
MToxOUFNICswMDAwLCDsobDtmY3si50v7LGF7J6E7Jew6rWs7JuQL1NXIFNlY3VyaXR56rCc67Cc
7IukIFNXIFNlY3VyaXR5IFRQIHdyb3RlOgo+IFRoZSBpc3N1ZSBJIHdvdWxkIGxpa2UgdG8gYnJp
bmcgdG8geW91ciBhdHRlbnRpb24gaXMgYXMgZm9sbG93czogV2UKPiBhcmUgdXNpbmcgdGhlIEpT
T04gZmVhdHVyZSBpbiB0aGUgUEFDS0FHRUNPTkZJRyBvZiB1bG9nZCwgYW5kIHdlCj4gaGF2ZSBk
aXNjb3ZlcmVkIHRoYXQgYm90aCB1bG9nZCBhbmQgamFuc3NvbiBoYXZlIG1ldGhvZHMgd2l0aCB0
aGUKPiBzYW1lIG5hbWUsIHdoaWNoIGNhbiBsZWFkIHRvIGEgc3ltYm9sIHJlZmVyZW5jZSBlcnJv
ciByZXN1bHRpbmcgaW4gYQo+IHNlZ21lbnRhdGlvbiBmYXVsdC7CoCBUaGUgbWV0aG9kIGluIHF1
ZXN0aW9uIGlzIGhhc2h0YWJsZV9kZWwoKS4KPiBCYXNlZCBvbiBvdXIgYmFja3RyYWNlIGFuYWx5
c2lzLCBpdCBhcHBlYXJzIHRoYXQgd2hlbiB1bG9nZCdzCj4gaGFzaHRhYmxlX2RlbCgpIGlzIGV4
ZWN1dGVkIGluc3RlYWQgb2YgamFuc3NvbidzIGhhc2h0YWJsZV9kZWwoKSwgaXQKPiBsZWFkcyB0
byBhIHNlZ21lbnRhdGlvbiBmYXVsdCAoU0VHVikuCj4gVG8gYXZvaWQgdGhpcyBzeW1ib2wgY29s
bGlzaW9uLCBJIG1vZGlmaWVkIHVsb2dkJ3MgaGFzaHRhYmxlX2RlbCgpCj4gdG8gaGFzaHRhYmxl
X2RlbGV0ZSgpLCBhbmQgSSBoYXZlIGNvbmZpcm1lZCB0aGF0IHRoaXMgcmVzb2x2ZXMgdGhlCj4g
aXNzdWUuCgokIG5tIC1EIGxpYmphbnNzb24uc28uNCB8IGdyZXAgaGFzaHRhYmxlX2RlbAokCgpB
cmUgeW91IGJ1aWxkaW5nIGEgc3RhdGljIGJpbmFyeT8gT3RoZXJ3aXNlLCBJIGRvbid0IHNlZSBo
b3cgdGhlIGNsYXNoCmlzIGdvaW5nIG9uLgoKSSBhbSBmaW5lIHdpdGggdGhpcyBwYXRjaCwgd291
bGQgeW91IHN1Ym1pdCBpdCB1c2luZyBnaXQgZm9ybWF0LXBhdGNoCmFuZCBpbmNsdWRpbmcgU2ln
bmVkLW9mZi1ieTo/CgpUaGFua3Mu
