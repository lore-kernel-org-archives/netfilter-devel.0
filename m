Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2045.outbound.protection.outlook.com [40.107.21.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71661448C7
	for <netfilter-devel@vger.kernel.org>; Mon, 22 Apr 2024 10:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.21.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713783559; cv=fail; b=icX3qosRz/tAK4a7BOwA53+lHnkVkH57HbcAPis7dQSSXkb1R/unY9Ozn+JnDUKC5/GHFQlsYd5y+xAZe0QqBD7CDBCN75QtnBeAR9x1GruSr4wkNNl8RfFUGVoMYsIT8MCCaCuMApAzlDPx1hjLZmNI/FCXUFBEcHe0zV2oNHs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713783559; c=relaxed/simple;
	bh=+5PUZ9FNuHMRczHI342YiBuzBQezJDAMEdX6iDQH6uo=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kF8bTrn8tPaMjhQQlb8aA2frwGfQjtKI6akMc/AJcojFsH8vwxrse1YmxdEocDpeqYttwU6pOWy2suzwFZcC85i7Gi7LXTLswppAM0B7UPFvpBfS+Dv8/UPGEG/ehOHu2Jwl2vHZKAUPsQRewJyJ1gxGQ/pMhg23NShRWhkoRNE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b=a10jOyqV; arc=fail smtp.client-ip=40.107.21.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=siemens.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b="a10jOyqV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IVEXZKCsVXSXKZ3Y1NxXTnzHrmCiabc5J55CqMT6Guqvkc7BFu6N2gQBtud7ddjvUzGqIenBsCsE7kGxhjgdwusFdYfRnDvKv4O8PueOtffMDYw6EofxcQ+PB6oAsndv7dST7hFsAWls2jAxr/azOqu4S2ITN37vm1DXOwtTujpyz028o8bFzVTYWR5yBSXT/wiI3/b3Rh5OIFBj0tzyTxpor+HWDkVbg4GdgDsM8TYkj2h37Q2pe1me23H2u73th8+ccCovx8ExFQwt7SpM4CFczDLkCcaSr3SSKAk7ysBWpWeVdjbMhkgTAF16Y8hGlvQ71MaRHk1uVYpKOtOc1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+5PUZ9FNuHMRczHI342YiBuzBQezJDAMEdX6iDQH6uo=;
 b=ls+uOsgkod8G05e68dXb6/aKxow3VGI2mcaX49c+hS+zy7ldCtug7oBkA2s3fnIIf/ymMZ8BLA7Pei+TRqxT0/6urawRsIafFjfCYKOBA0x2jB468o+2gXvVg4mTzhOoItFHCFfMoNRTZu1+UwT8T+VBIQH+gp6zLmTfMey6XbCIzB2ayG/l5w80z/hC68AfVSyZ2c0GlAPbd+ZIs2WgpCnEAigjWlLe8zkxvzarHwch+IlSaMEM7uDse+qsvuTJ4qqd8v6W/xwi0OEiAzz5ZhF4V/iwhzzmCwskcAJX15Az3wuSZjkXqv8ylS8afP39fMghCdWxALYzOujxe2KtyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+5PUZ9FNuHMRczHI342YiBuzBQezJDAMEdX6iDQH6uo=;
 b=a10jOyqVZsQH2MyYtjB/eh5cmq/l8MmeI0H3smWOgE4aCodZqrqiSXJNxyr7ZvV11Uq23ApAycWgvakGAdi6cZtAy0YLPVkHu2YY3ix+qrWtpH1qfUMGwSxuFM0RhiRTSdLPc9gUgvUkYjIyKyhSwxpp09ZP6GU9twCb5KKffNywDmviLxAqr0iMs0T1orgYGAny/iionzmENO2TPcfEAROw08GpeGc4xg6j9F8A64QIvs2xmE7ihG2QlDZc9VDuxIVGU2SyOvC7zPzarzOhXjta5UplIbVPFIt2s+h6ie0SPvL089oUofw1Ju6mKiM0qOhoA7phkOlwdi2mt1Yvuw==
Received: from AM9PR10MB5005.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:41e::15)
 by VI1PR10MB3536.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:800:134::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Mon, 22 Apr
 2024 10:59:13 +0000
Received: from AM9PR10MB5005.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9419:8737:3c78:2cf9]) by AM9PR10MB5005.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9419:8737:3c78:2cf9%3]) with mapi id 15.20.7472.044; Mon, 22 Apr 2024
 10:59:13 +0000
From: "Schroeder, Stefan" <stefan.ss.schroeder@siemens.com>
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Looking for (unit-) tests for libmnl
Thread-Topic: Looking for (unit-) tests for libmnl
Thread-Index: AdqUoyDAYMoB/RXuS26ZQ/bmhLwLUQAAOP3w
Date: Mon, 22 Apr 2024 10:59:13 +0000
Message-ID:
 <AM9PR10MB5005BE11FED7A7DA5C7D9988A7122@AM9PR10MB5005.EURPRD10.PROD.OUTLOOK.COM>
References:
 <AM9PR10MB5005955C84571853FFE35B05A7122@AM9PR10MB5005.EURPRD10.PROD.OUTLOOK.COM>
In-Reply-To:
 <AM9PR10MB5005955C84571853FFE35B05A7122@AM9PR10MB5005.EURPRD10.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_9d258917-277f-42cd-a3cd-14c4e9ee58bc_ActionId=260efc30-2b49-4ffe-9ed6-4c9f094d4677;MSIP_Label_9d258917-277f-42cd-a3cd-14c4e9ee58bc_ContentBits=0;MSIP_Label_9d258917-277f-42cd-a3cd-14c4e9ee58bc_Enabled=true;MSIP_Label_9d258917-277f-42cd-a3cd-14c4e9ee58bc_Method=Standard;MSIP_Label_9d258917-277f-42cd-a3cd-14c4e9ee58bc_Name=restricted;MSIP_Label_9d258917-277f-42cd-a3cd-14c4e9ee58bc_SetDate=2024-04-22T10:51:47Z;MSIP_Label_9d258917-277f-42cd-a3cd-14c4e9ee58bc_SiteId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR10MB5005:EE_|VI1PR10MB3536:EE_
x-ms-office365-filtering-correlation-id: 841b11ab-75d0-4b2e-5dc6-08dc62bb3ee8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?8lSMX3LrfPEtblDmGrP/c0huINKks+lGSqQw95hRZARrBrWAa2aUUwSPD7lW?=
 =?us-ascii?Q?WTRIBM5V6xbbLdIwIO1gS1yJh6s87b3ZgPWFGVOGWphfbFVvft4yGpkD+goa?=
 =?us-ascii?Q?ZBksiM2tQeafcW3o9FBTX5cldSav7Z4ExjFm8r2qPSCKFfhnN8P4gloNeuNX?=
 =?us-ascii?Q?1IJsP3VE4Pd2owU2CcJrjdLp0aIV0a16bB6eq8D3TJ1fZnah0/ah2Gar1PZW?=
 =?us-ascii?Q?xTMrQnInVm2u3jaCwPVpAUeTory14N6zk/qBFHnj5UmMQVKNIpdmIeOosikF?=
 =?us-ascii?Q?FkRjODDk4wU6EXvPit0A2rtklHUYHdumEfXZKzHTsaF01Jtul0q//uyd0X3q?=
 =?us-ascii?Q?qteNdAQozyzBwpdhWGKtYRnm277VRrq7B/AnvjjphNDQ2SmmVVZfFN3ePjm8?=
 =?us-ascii?Q?ZCqhfCJB+l2FUolO7/BBPDMu61p0p7Fn+A3Yrc79pEEGX7nScXFTgqo9UceT?=
 =?us-ascii?Q?Q6mykGb0wUphcbVzvXRmV9O83YsfuzxZwhw/0P+SQINPLG6RkL7IvQYaYrWt?=
 =?us-ascii?Q?86MQeUuovI/b9WTGTwFXnOBpnT/VXFPl/NOM1vphdIr0fwz9k5FoY1YSyCcN?=
 =?us-ascii?Q?/tKuxNRMPJtacGQTaedFzyyuuMY5WYUAioFHuSc3YvMPSCPzsaV/6fUgutCy?=
 =?us-ascii?Q?gj1tTOfdwsRrhqnCd+mHn3YB3gX5ZoqmxTQCYwY9bYvs5WMWfhzRtqxmw0xs?=
 =?us-ascii?Q?uQrmwJamjGhl9at3wb/wAl4f+n6ZaGfea82KWe+i/REGBJUOmz9vPyj74KaL?=
 =?us-ascii?Q?UEXLE/ZvhtBTGTPT0VDNyfMxyAI6H17eSQbR52Vlsa/vQSVAJaZeW1NFcf7a?=
 =?us-ascii?Q?69TUqy4rbSgXkypAWdaV0gVx+731Vo0O/xcm4aGRPwMt58FNXFwKMNSYMROB?=
 =?us-ascii?Q?qTSLFXOWPUpDlCurnyR3q3q9YC4r6dojX9bEraGqlgL5+2cHiV8O6EniurNi?=
 =?us-ascii?Q?kqyxspVmzIgAftIpIrL7q4Ioamg2sKgjJfQbjYp0YKI+gDF6u508iB4zTUam?=
 =?us-ascii?Q?L9sPxRwvF4fq9WPFR89R0iHP/53Gqey0QAXlcAYqMNK6MTC2AhhJfpRqw5Fd?=
 =?us-ascii?Q?lalDGJUGYVtqyBD/VN+hZJJN+OrvxixckgJ/ZDUDt1zNKC+313JoQmEsH9qg?=
 =?us-ascii?Q?aIw3IroHQTIU3OZ5DkvhkzpSZLmV6kXsHnt9tPvae9SIPzssYH7v/4hzYaHo?=
 =?us-ascii?Q?KvuJEhIb5MRc4PlB3q64aP6A2DgKDymX6EOsf2hlHHgTm3isF+eve2G/iiC1?=
 =?us-ascii?Q?lrtrrsTpJW1qPruaOcVmSd6tFgpPeCqMoZzHLLly8Q=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR10MB5005.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?xyW5/0eiaHYJ6fZJgpBS43rxYVqQTV+AAbR+6NT17wysUgmdmr613/9EAt2m?=
 =?us-ascii?Q?xxg9JgH6ECCc0N/rRT1Uj2pOS4wEMi80lyz+g+ijcqVnTc/+nfc4eB5fL0BP?=
 =?us-ascii?Q?Re83EOSWJyWB0PQRJ4RfjaOHy4QEYX1El52GYKZw7EhudevIzRI5/GTI6BzZ?=
 =?us-ascii?Q?WaOypntc/EyafeUnRFQhEuu05dsNorpBHR6456R1SoZYAyGN53S/LTTaDdTO?=
 =?us-ascii?Q?RH2p3gvvCPmMm8RT3uYOP4zAsnSNlnQrAQn7TesjekAN9jzr1PUqaU/ZRCvv?=
 =?us-ascii?Q?R/bceml4x57yFoOPB8JPHI8lAXJ6HCBLCxt12woY+Yqw7vTJNYing5PBs8Gj?=
 =?us-ascii?Q?F2OeJAczf+XiiOt8Z2dQYGo8Tjo6VpGBcZmAsQFvFxaup/py9p30DsmqzQM2?=
 =?us-ascii?Q?K2dARsGK587UIXp2u70VlTZePysgdmc4oYtUSY2taVd8RnSsdJXyihQnrwAl?=
 =?us-ascii?Q?k8NqFvKmLr1W7Kxq67jF7rgJ5Z54YUCe3k355cuYt1LWv00pciIGQKEuG/HD?=
 =?us-ascii?Q?cB7xzYBAparfUbDYBnHY6cuA4fX4uLgQTR8TQ7g0rwYBUUEkxW8mJgvfZzXm?=
 =?us-ascii?Q?RtXoGzpfyuXiiD+5CSJUOfYGioW8eJdv8H8q4FxvbyUXjLuj9KeuKoIJU+Fr?=
 =?us-ascii?Q?d5gjP1IDwxu47uABcgnI8m9Hwd8Nu5ZDuI69DdUHZkxs9+In+3hsigdyk6UT?=
 =?us-ascii?Q?GrWlMaymVOrOjfU4iyUajz3nCknDkNf9BXOaESXzeHyyQt6t9e1uwrghgr83?=
 =?us-ascii?Q?JAM7S8ZOuYltWcdXSvaZggCYN4aBf6qADuK742RQC0SXjJnw3OCy0yrShjDO?=
 =?us-ascii?Q?4iDAR81d1mUWGa8tqZKFHU7Px8rdkz7kbsO7dsCivoPhS3Z+vVZT41h8HVfo?=
 =?us-ascii?Q?2Zyp2DQKFlMOGBq7EnlXvgd0IFD7AEjxZ7P1xlIdNGIO3sJ6+6PfclQFiW6S?=
 =?us-ascii?Q?FBAbUXNL+/ohMQbjHOCXxsHUH80osjidPxJeGWVbTs3kblpLYLCp5G3C2v0h?=
 =?us-ascii?Q?1nTiRLabhK0eqmdqoswe8zqYXwVFfH+R5UG5N89OOAxEvNdgIn+PKDwyNv4z?=
 =?us-ascii?Q?pMRjA+z92SovaWJuv/ymIvAE8wM03dcz1jsbk0VPnUTCib1nTR1aCzMlI33n?=
 =?us-ascii?Q?YkclFT+ginsgtyUNQUbTXWNjbq4nSKIMle6w6FQJHLRH6Sc+OR77Y67Zj0Bo?=
 =?us-ascii?Q?eXLtWl64c+vRIvX0cw5P+6S4hqjBlAF18F9qveavwLpjDI4XLaa9ACbI42lV?=
 =?us-ascii?Q?L+otEA3jR8D3m8VCEnfjrglGoI2GyddRXy89qiIn4lzlNUIFh4mMqwqTvSvQ?=
 =?us-ascii?Q?pPQldogWVLPQNr9Duo/V28vZGtd7NskQs4gtihMcnTaJxjwnyH3JcwNsv7QM?=
 =?us-ascii?Q?OfucL4zz5M+uCrzLHWYyqs0MQGwG5mjBE053P8216/4B6f/8UNy5stERonCS?=
 =?us-ascii?Q?rexnAsFW4is1gbG0sJKHyq2xEIRCQMx6INHbzm0fBPzdWP8njyw2t8OlDgaa?=
 =?us-ascii?Q?CHAT+tjoVLb9Uru2q9Fy02Ke1xe3Eg9gtCaKJeCvSC89MIj0BEPHU7CJl11n?=
 =?us-ascii?Q?N25h3dh9f4qlAvmuax5JKWjQwDUmEWQADyey0teWDb0Pjrf645jY6KMSxS6m?=
 =?us-ascii?Q?zw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR10MB5005.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 841b11ab-75d0-4b2e-5dc6-08dc62bb3ee8
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2024 10:59:13.3532
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X3iwMCSggbelwt9odQCke84AUZAl0G+9vShDzLVDk+gkM3cxbT4fmtp2M9V/Bpxsdbb4siD7LNkgGaVoFIPWAqvE/x/DcDKdgKMY0M7Sm3E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB3536

Hi,

while reviewing the sources for the CIP project (https://www.cip-project.or=
g/) which is built on top of Debian, in

https://salsa.debian.org/pkg-netfilter-team/pkg-libmnl

I found that there are no tests whatsoever in that package's upstream:

https://git.netfilter.org/libmnl/

What's the reasoning for having no unit-tests? Are there tests located else=
where?

Thanks

With best regards,
Stefan Schroeder

Siemens Mobility GmbH
