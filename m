Received: from PNYPR01CU001.outbound.protection.outlook.com (mail-centralindiaazon11020114.outbound.protection.outlook.com [52.101.225.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2868C2D5959
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Sep 2025 07:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.225.114
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757921665; cv=fail; b=ZBmCM+vdhuDW2nNOIyaGCmJGRCZ4NxoY7rOYkqFA7R3HXfYx4Fiz9J8tJFGaCYN3Qc0uGZ8rwdCDd+8IraB5JKxE2bFtwegOrcr77qxkkFS2xL2t7iOBAXuPGEX76ckvs4XEp8bZowmi1Jz0Yws5emv22iUDuO8CtEl08kH9HxQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757921665; c=relaxed/simple;
	bh=rbQT/0yGq5FtWH1LqlLHfdekNyhxRf7OK8Bb+TmKlPY=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=KIuc+24kTbvNTgGjiCeh8edSJ1H5EjY6eRfOJLTjQMIW5fOXy2GmzTY0N7FMAmBa1jN1s9x9qIilbqL9Wul030HtoCGx0wwiyRh8Hd883uiHccRxwE2wDpO2P7pkAwOq9+A/ctJMaH0ao7U70q0/7gnvQtbvnLlOO5vyPDjmZ78=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bmwtechworks.in; spf=pass smtp.mailfrom=bmwtechworks.in; dkim=pass (2048-bit key) header.d=bmwtechworks.in header.i=@bmwtechworks.in header.b=2SaZbaue; arc=fail smtp.client-ip=52.101.225.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bmwtechworks.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bmwtechworks.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bmwtechworks.in header.i=@bmwtechworks.in header.b="2SaZbaue"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SB1u3mwFXTPunFzIS6rGRVFMFz5QU7VWVsifq0OFZfShfL5NW7t5MCCS/2acriAET+m/h35rOTu09/0X5RO2bfdPxUFgIsalR3lhVfht3OB/PMbeGfp5NBuQ3WeFzuxNdX0nuaE1qAvfeXw8M+FmEb4kG1oZxFPbZQhKpYehtk3bEvkSSZp7KnUME6B4tM/ziGbqzIHPnN6WUjT7PwcFUIgBC7ZtcCNxjJr7J1UXoIKjAX7up7iDfBTBrB3qX3kSossWHWwsrN74JwQog6kG4Fz7gslwAoKXihnWMc/RpBRHey8mAOu1ODylXSi38c+Ds8PaEo6K9ex0Stdv1tSMfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rbQT/0yGq5FtWH1LqlLHfdekNyhxRf7OK8Bb+TmKlPY=;
 b=v8oiyEnqFhQO3pRJbK8B9WV4xqaWZys5iQe9SeUPWSiwUI52u4ia5ZN9E5OvPGqv8W73/GmEF5YBJ/hIefCkzwi8dMfCh0GTQQh8sYoggQY+iWaBtFne3IDdVls89gxtLmXFZ+ABMk3AnkPYLiILqQicKEjyTNzdIdEveMUzE1kH+x00KxdgrFd4zBnuJY1JLoR50KPHqo7u4NDOvV9Gz1kn/oIKr3fMxcy5UhaDDjhkALuSaapCwYBEyPm0QMNXzwl7RG11odyGVcU3Z/81wB0mDUx4mLI3FoLchjUSlDpryMxal9CQGP9nEX7sO8s5WeXhlIAyzw9SwD7xlE5Gbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bmwtechworks.in; dmarc=pass action=none
 header.from=bmwtechworks.in; dkim=pass header.d=bmwtechworks.in; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bmwtechworks.in;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rbQT/0yGq5FtWH1LqlLHfdekNyhxRf7OK8Bb+TmKlPY=;
 b=2SaZbaueSZSLWbMG0SVmrqR7KE9qvC4YQY4mYNLP+WJyAdEAP8BVn/utZjlypWH6Z0RBhGkpuFXDzqbWmxVQea0uT2Seq+RMFnTVibtz24vM0AVN9KbpAWRt4ihPOmK7mqYPlAz+vW67QeutNOh05oL27uSxBqO7E3ZJYEho6mDm3NMLX5QB0X2hWsfJ2U5OdiVAj12N4D/D1p6QyUnz0rhHbKbANQrXPdPBsfzbIJ2LPP8siAqpJ+NVc1pgDEfo8473mVXfP3yOw4GtQoNCgXmra+lLPG99qlOIEY2sEPpfQQa4bbfTF17NSkAm7gHCPjIuGTiSumqo10K65Ja+DQ==
Received: from MA0P287MB3378.INDP287.PROD.OUTLOOK.COM (2603:1096:a01:143::11)
 by MA0P287MB2147.INDP287.PROD.OUTLOOK.COM (2603:1096:a01:102::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Mon, 15 Sep
 2025 07:34:16 +0000
Received: from MA0P287MB3378.INDP287.PROD.OUTLOOK.COM
 ([fe80::9dac:f479:3c66:70f0]) by MA0P287MB3378.INDP287.PROD.OUTLOOK.COM
 ([fe80::9dac:f479:3c66:70f0%4]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 07:34:16 +0000
From: Divyanshu Rathore <Divyanshu.Rathore@bmwtechworks.in>
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
CC: Sudha Ranganathan <Sudha.Ranganathan@bmwtechworks.in>
Subject: genl-family-get test fails with "Invalid Argument" on kernel 6.8
Thread-Topic: genl-family-get test fails with "Invalid Argument" on kernel 6.8
Thread-Index: AQHcJhL6/D9zViLSzUuPwzCTDvAtjw==
Date: Mon, 15 Sep 2025 07:34:16 +0000
Message-ID:
 <MA0P287MB33783620765E4FC9131E161DF915A@MA0P287MB3378.INDP287.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bmwtechworks.in;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MA0P287MB3378:EE_|MA0P287MB2147:EE_
x-ms-office365-filtering-correlation-id: 3ff413bd-26cb-4f25-42ee-08ddf42a468c
x-ms-exchange-atpmessageproperties: SA
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?UFk5/RVbUr3AeWOgNwiKLb0vgXx5aD28Z/6oy5hBUajn0Lv4mk3ldVVhsp?=
 =?iso-8859-1?Q?4zEXBKEVcXTr5SUwcn/IEA4pP+ZvrslEp6Cm/98PGqUniqTkDhTjfOdwNj?=
 =?iso-8859-1?Q?adSBEvXKyWKuUIkPJ1x79gAyXkOvHe89mtXgQR/E4UtA39uAhS6QCVWhy5?=
 =?iso-8859-1?Q?hkaxIIdH8pWRwt4sDTc4oYHhFz3cueUfGlkLw/g0akBEVU+k1hWeJsCGG7?=
 =?iso-8859-1?Q?AR7x6JUMUfNoVtq5r2qba7hBV9bce5/ldwQLsebxVy1J6wHEeeoL+6vBxR?=
 =?iso-8859-1?Q?P/uagJ5RKUfLpaX00vnqIo6HeXNzYMrDXTgVMX5rGBXT1/9EMlLoUXknNn?=
 =?iso-8859-1?Q?DXbTcsrJ/w0nppOt6rqVYPMqky875/oMaBJwXv/5ZtGt1JpDWuA3ulDLbK?=
 =?iso-8859-1?Q?jauta8Yhs4R+LhiFPFXTtaUqM88FUefmGKUa2k2xlE+z0Q9VNy8KJvqkbZ?=
 =?iso-8859-1?Q?d4+AXL8E+MtpQOMRC8EfUtsGNw4De+N8Hryucg3wPSRqJ9fMvYYGope6g9?=
 =?iso-8859-1?Q?Bq4TSGtkEni90uHXtAivdz7ASgEGRNzG0FdpY9y5W2USL3saln/FhmHS6/?=
 =?iso-8859-1?Q?bxN5kcq/W22fhAOVDMniIdzSKeYmJG4yxVzGASxaWCRi3OyfsnkBte0u0H?=
 =?iso-8859-1?Q?8RhtPUnG9wHd7vzNhu00PTbu9bqNVCDI44kd29lBFLDPYbRcHjV0vNdrpm?=
 =?iso-8859-1?Q?p4XoVkS4GVm6tce9AVN78ndP3xl9lb5yh+LsAUaz4N4mfXBGXLZ89zSXWL?=
 =?iso-8859-1?Q?zwCQaTKnYiiH0pfWUnxtDpvZh+Q52UUXpRNbAPUzWuwL73d+O9MVg4j97/?=
 =?iso-8859-1?Q?ythIRkcZnwlxeNqkeyJH8/8rVbCMae3xEBn3W2OZAzQj+yXtfztpLdwc3F?=
 =?iso-8859-1?Q?2TDJif88G3wiMogU6HBVBQyKye+UPB2unXRq5Hq04dW65QebvADs/v5c3k?=
 =?iso-8859-1?Q?ojBCFEQ5QANSNdqQkDFOX6mC/ti0B6Fsq2Gn5j/hPsVM0XxzYDWoRyXwf0?=
 =?iso-8859-1?Q?X63BAaq5q8qqRZ7E8HMBKw8LH8hGQFCFA0AJf+P0XWAv0xUHs/2BRMbvyp?=
 =?iso-8859-1?Q?ZTceGhqBpIcTLuT1gXnffLi4mLbOMJiJM63XenUfRXKvuA+TFTOjqwRCFf?=
 =?iso-8859-1?Q?EdbEl6G4otC/ijpOhinmAB3RpGfCXl1I8QeiV9sqzm+RaRtSXCiVZwk9cx?=
 =?iso-8859-1?Q?XoZYFToWY4c4gbpSrojFD/NhIt2IR/OzD1lRNZxxYX/ex3MadvMSdjIu3L?=
 =?iso-8859-1?Q?zMODh/VBkEHpOeji2C9smIGziWo12jFoZMhu34KIMxPPKB6D7KUhxdbz/1?=
 =?iso-8859-1?Q?BkX5dNlUrgP9Ph8LcUNKKECYUPkr5xCMzM8J/YBg7lLhkwmnoBcPM5uh5D?=
 =?iso-8859-1?Q?RxsVaq+N/QwfBiBBQMw7CPu634lhFu7lKp+upSl2p9E+3jWAmaTzig9au9?=
 =?iso-8859-1?Q?X5XNhaDrDLsSVlm2gphd5y1TJAkeisZZBjUQRfkfns17RZtNCaFnVAxm8U?=
 =?iso-8859-1?Q?RaJAyCREFhWi1hGPedSjrkQXfgGfy+Y4hGhzHYghxsE4synSig8WqAi5pF?=
 =?iso-8859-1?Q?U793INQ=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MA0P287MB3378.INDP287.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?9Jqk1ipBEzKgFytDsEcs3+8BBxE8SI48XnD5+jHrHs/RNn0x0/9sNfDejV?=
 =?iso-8859-1?Q?ztBvy0BRdKjW1uob7Bopc3btb6Ozeh8UIx14/+RBpy8IPGxxjpGBUlnHw+?=
 =?iso-8859-1?Q?jYCI9H/QI5ELTJV/meZeB7ntsiwBOKajoba6biXRQ22LqEd1Llu7XGD9Fi?=
 =?iso-8859-1?Q?nuFbCHvTK1MvOA4WdU6wvVUEBMsE0Aot5qzx5pWBlZXx0rG5dhDCFp+zwX?=
 =?iso-8859-1?Q?il69i5cMNJrNkcBNNdLBiR45LanDZDJ1/2mysjNQ8QtnOunle5m5ge0xbd?=
 =?iso-8859-1?Q?x3zdMVZOfSo2YjCgjQ4axoUW9Cic04c/+L5+PWbzEaCf4zIEL2DnNyZQxe?=
 =?iso-8859-1?Q?3HnONZeSvW/QE1vbXoPAXpoYTR654w3Gs7CPItHOIA60vNJjQV0QykLDLl?=
 =?iso-8859-1?Q?pJp78To/mZ6WeqQuNV0eMo9ZdK9FTVc0kzi9aIpbmjJZM/0CFexzi08Att?=
 =?iso-8859-1?Q?sWBbCBY5b2LUZ0nuxDwr+KBrnkNkfB2fPE/A1H2IjKljFx2dXH/bjRmtkh?=
 =?iso-8859-1?Q?AoY6eARCJmC+Gu4bgdL/8SpLyMV+Bzlz4afn3m2CDhNBXJHJeLHLF1Z6qi?=
 =?iso-8859-1?Q?24SWL5F5YLzh/Vl2c8CL5t8DxG5qy6WgMvUtecZUD+YSBbHCrlS1qJHEVb?=
 =?iso-8859-1?Q?dZAd1R6phWb02h/k7oPa0Os5DUkJiYYVnenqRu5ktpgrvwvm5Ie0LwhQ0M?=
 =?iso-8859-1?Q?Cbz+2cti0vLalgzmfke0fVPf+46gVDqeIWaZ37kHpNNCSTBnmwxI7hqRzg?=
 =?iso-8859-1?Q?Y9ktEf0faZOXWsjc64pFUZGEsFsNb4Sr+xByxswR/XzfkPyebAcL1IMbOk?=
 =?iso-8859-1?Q?PdcaCLF/xJfA8DpYv96x6wejKCXfy1PTq2RUaMnzjcV4a8FZgmp0gmgaWz?=
 =?iso-8859-1?Q?Ev8SK+PONaT/Ydc+d9GZaUhUa37Krkvknzuc9a1i3pikNpJwgfbE7o0hTt?=
 =?iso-8859-1?Q?JUm1YA4SLg1feRXxMI0u9Q8/k16zCfzZ6KLPuS2sBfXQr9HRiyOHwf+Wna?=
 =?iso-8859-1?Q?ZkAeXVDOvotyL7z3vr7hjslMP6bpIIfpuQlrfB2oXJO2D2GJJ65SEaWpGd?=
 =?iso-8859-1?Q?m4LKZ3Kq2SH/61KGhaA2vSB6G8wnpU1FTtQIMkLFw/nQWxDPjwuvYWOMSl?=
 =?iso-8859-1?Q?TBVfqa4KyMfY6pM9MtmZXNMPrBC4oSFSAoyi7sjzWGu3d0ZhNv1TTAbfRF?=
 =?iso-8859-1?Q?3pXLq7FL0ThSXR1XM835OySimzeySic9JRAWeIzY/0LkJZA1L0l9xU5lDw?=
 =?iso-8859-1?Q?AaKfr+q/83Doc4QZqBupQXtn/fDmY3KEcOnvw/syqKmZpy/T6UKwTLz94C?=
 =?iso-8859-1?Q?JuTmTlgzRe1H2jmLU6t9rLYOKSBDTuKL87cuTqMovnHTfC5TvHaGoW2nOq?=
 =?iso-8859-1?Q?z9o5YKnhFJao53H/g2tVXrIqdNga7i61e76QRcBIWwTD0ro+/KLinobtSz?=
 =?iso-8859-1?Q?YZnxg0RH8K52ISAjwVtq0fbVnJgXK3EYZevZ9hmJN/cGKrE18p3io4VRLk?=
 =?iso-8859-1?Q?J/89g9ZyHsEbpAOdcN7v2aLUA1ELxrq48XV5RU6fLtWGCqFM9uyFSo0+YH?=
 =?iso-8859-1?Q?ZXIvrxI+bxD459QJiiaqm7TLgMpwCZ4Qu2U2UFWg2oxz3wWrG+C5WHRB1W?=
 =?iso-8859-1?Q?OIj+qwcC/WhMISeW24F5uP0ZC3P3lndNrTH0nclxyrLQ7EU22ZJmmjHQ?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: bmwtechworks.in
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MA0P287MB3378.INDP287.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ff413bd-26cb-4f25-42ee-08ddf42a468c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2025 07:34:16.5597
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 970fa6fd-1031-4cc6-8c56-488f3c61cd05
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c+9QUugsHOmEr3lvoTlvnYtU3oSVRxpqw/sYX/TEI3bC+WF7pPrB6ViIJIFZU0KDYemIt3cZoAO/+eDeUtup9lYCQsE2cS/F+KxlVwZANSFOzE531IOhW/XDsoa5Q+ee
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MA0P287MB2147

Dear Team,=0A=
=0A=
As part of our system testing for the libmnl component version 1.0.5, we ar=
e using the genl-family-get.c test file from the upstream repository:=0A=
=0A=
libmnl/tree/examples/genl/genl-family-get.c=0A=
=0A=
In our test setup, we execute this binary without any arguments. We have ob=
served that the test behaves differently depending on the kernel version:=
=0A=
=0A=
On systems running kernel 5.15, the binary executes successfully.=0A=
=0A=
On systems running kernel 6.8, it consistently fails with the following err=
or: "Invalid Argument"=0A=
=0A=
We added debug logs and got the below output:=0A=
=0A=
Test failing due to:=0A=
=0A=
AssertionError: Regex didn't match: 'name=3D' not found in '[DBG] main: pro=
gram start\n[DBG] main: building request: nlmsg_type=3D16, nlmsg_flags=3D0x=
5, nlmsg_seq=3D1756046191\n[DBG] main: dumping all families\n[DBG] main: op=
ened netlink socket\n[DBG] main: socket bound, portid=3D9125\n[DBG] main: s=
ent request to kernel\n[DBG] main: received 48 bytes from kernel\n[DBG] mai=
n: mnl_cb_run returned -1\n[DBG] main: program finished'=0A=
=0A=
We ensured that the same libmnl version 1.0.5 is used across all systems, a=
nd we verified this issue on multiple hardware platforms. We also added deb=
ug prints and verified that the failure occurs in the call to mnl_socket_se=
ndto().=0A=
=0A=
From our investigation, We checked in multiple hardwares and added debug pr=
ints, from that it is concluded that, the kernel version upgrade is causing=
 the issue=0A=
Can you please check this issue and provide the fix for it.=0A=
=0A=
Let us know if additional details are needed.=0A=
=0A=
Best Regards,=0A=
Divyanshu Rathore=
