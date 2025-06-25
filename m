Received: from mx0b-00015a02.pphosted.com (mx0b-00015a02.pphosted.com [205.220.178.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0FF1D5165
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Jun 2025 14:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.250
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750863107; cv=none; b=EZouvNBncx2AJ0AN0Fc5P9NPvyEX84CdoJBGSBpjN1ueJ2+ALdZhKmttC/HGK5mR7aYGfNxSW9DCNJCLcWazIjT5RJe16pPtOSSULqeMNsRa59otdU9+1/CCF1z/hNfDb5oSN7pZ06F3UTTAgCVLgoGskrlb7btDIUU0Ll2t0mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750863107; c=relaxed/simple;
	bh=0b4ZjqpUz8oa5icwUBsqvShpJzPs/wnY5JMgopA/NG0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=JPyhh0fzkbCYmBBs70Xpi9+0ZoBurt9dxcFZaTniNw/biaNiZITVim5m5Clml2TIeVuNXCaQSrxrBaOSeLGbmdepO64VxaSeIh82QL8uQIIj2HczMRlxIm06SZoxC6p0Jo433q2Q6R/V8pNIb4HZS+FinAhBbhgyv7kh2eNzgzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=belden.com; spf=pass smtp.mailfrom=belden.com; dkim=pass (2048-bit key) header.d=belden.com header.i=@belden.com header.b=SbmdE4Wq; arc=none smtp.client-ip=205.220.178.250
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=belden.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=belden.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=belden.com header.i=@belden.com header.b="SbmdE4Wq"
Received: from pps.filterd (m0382793.ppops.net [127.0.0.1])
	by mx0b-00015a02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55P9o0nU009146;
	Wed, 25 Jun 2025 10:51:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=belden.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=podpps1; bh=dQ
	lzmHeaujhTo05kcM4hfacAxTuDXnHvedjUoG65J28=; b=SbmdE4WqQGZ+eSpra5
	ocqWmM64CItlG/5YY0kt1Mcz5w72bFz7g698hnh1IqDAaMWBhm2MOPheT7RfLM3i
	8XX4IhwjbH6RkfUmscXNqEpW9Tx2A7Ge7fKDo3M46zKZ36dty1/IeXPRUz/Kzs8Z
	5A85lW4CGVHtRAgq3ajijbpL5yVS98eW2CmfWZtVEGe171ykXPwt8uovjbEszILK
	2WscOkYJhUlFub23BJxakzfqiK2PVEvi/8JVurgbcgaamoBXgWVpnr1qvBbeIRux
	RjVp2xwHqfV2BI/mFkf/a20RAGMi2HhoKxb+ihWcWEOHraj61eZjZi85ILqWpBoP
	Mkqg==
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2122.outbound.protection.outlook.com [40.107.92.122])
	by mx0b-00015a02.pphosted.com (PPS) with ESMTPS id 47eandpuhh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Jun 2025 10:51:39 -0400 (EDT)
Received: from BY1PR18MB5874.namprd18.prod.outlook.com (2603:10b6:a03:4b1::7)
 by SA0PR18MB3470.namprd18.prod.outlook.com (2603:10b6:806:95::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Wed, 25 Jun
 2025 14:51:38 +0000
Received: from BY1PR18MB5874.namprd18.prod.outlook.com
 ([fe80::87f6:31aa:bb07:965d]) by BY1PR18MB5874.namprd18.prod.outlook.com
 ([fe80::87f6:31aa:bb07:965d%3]) with mapi id 15.20.8857.026; Wed, 25 Jun 2025
 14:51:37 +0000
From: Sven Auhagen <Sven.Auhagen@belden.com>
To: Florian Westphal <fw@strlen.de>
CC: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Cannot allocate memory delete table inet filter
Thread-Topic: Cannot allocate memory delete table inet filter
Thread-Index: AQHb5aNNhZSA/ulCI0+LraAw182A4bQT78SAgAAE4Ds=
Date: Wed, 25 Jun 2025 14:51:37 +0000
Message-ID:
 <BY1PR18MB58746445C00F31B0BAF392ACE07BA@BY1PR18MB5874.namprd18.prod.outlook.com>
References:
 <BY1PR18MB5874110CAFF1ED098D0BC4E7E07BA@BY1PR18MB5874.namprd18.prod.outlook.com>
 <aFwHuT7m7GHtmtSm@strlen.de>
In-Reply-To: <aFwHuT7m7GHtmtSm@strlen.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY1PR18MB5874:EE_|SA0PR18MB3470:EE_
x-ms-office365-filtering-correlation-id: c4a78682-2c6a-4b32-18e6-08ddb3f7c9b1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?5lBxW/1DDrCIOtPUBNz84pRJbawqbTfkQmQGibixB2u97UDozKcLj4srnX?=
 =?iso-8859-1?Q?6Qlu8ilnMgrxIbF1QBFnGeBLtb5bkW/MYiPP/wHZ9iuOd8istWUycE8EGU?=
 =?iso-8859-1?Q?5Ia1Hw+BqNIpbLijFy+N32nPniOKLKmsYb2tqCvlUNYGiFfVUdwvgFavh3?=
 =?iso-8859-1?Q?0c5m1nQ0ASzwYp7zLwFyv8eyomU+l5QiSFbmviruDqpQfQTIFD8qEapTt7?=
 =?iso-8859-1?Q?VkVhOtMtQ4k4XZ9N4cz0meqGw/BTbAGIy1KFLpy7xhWzXxOhi9PXNwxa4w?=
 =?iso-8859-1?Q?Fdh1+ne3xtqzOTHU9213tDIn5OEPOHRM9mcSst0serExiFMVYssy97D28T?=
 =?iso-8859-1?Q?O7ugKRZzgEb9ijNJwzcBa16JVtokZcYwV8ZTTMEZYgGOSC7lu2djl0dvlQ?=
 =?iso-8859-1?Q?mVZXEg+d95tNmDi2A1cTuv6pGPadEvksnNot27tnccg7sAnIERSBU8khBH?=
 =?iso-8859-1?Q?BpGuAFjEaOfTr5Y/WGTT332nRazM5Y6MB/3zMPSHB9vknijXMFYeXNa/+F?=
 =?iso-8859-1?Q?ZVwzzhRwhtMb7pawAXhdGp2tqzrdrPujCr35nw9rIGPT4Ear0/vNA27LeP?=
 =?iso-8859-1?Q?z2Gt2aMG34FK8R4qDKRzEzoYU0AeSuMwRlhl5r1cG/Cp1VTUPq4zoHC9tD?=
 =?iso-8859-1?Q?hXTKtpuKPWZ2gQDM3cRtQ0yDQTEPD83FfNUqpHSZU0s9rKB1y4RQxhqTU4?=
 =?iso-8859-1?Q?jKcGy6ycdAz6T3usuWRXsYOsscFVda6RRPkS2HD/YLPnYWjtFMc4Bni8P2?=
 =?iso-8859-1?Q?YhvDNE75AcRLnTsyV1ekq8CynJR6DwfW+kQ+ctdRo5FC2hy65rYPyboowL?=
 =?iso-8859-1?Q?VGRfhzHOcTwBNiTXUYs2WRJpcjj5D7cDIzJKh8FjJ6G7NA6o7y0IbChWim?=
 =?iso-8859-1?Q?BwaJ/70dcr0S/epk8UXrRYBr9iVtowOaaEr1/gMO7Ez4e1nOVPtD6LWQI1?=
 =?iso-8859-1?Q?Vjll4cZ6aozUX5vDsniRG558K0aNNqQCth8pgRGHQFIZDfrjsLK016WzlN?=
 =?iso-8859-1?Q?eQl4rDt2NucgnqbQSw9uWh+ovZmUNwA6kbn9njsmOVEHObK+lY+UeHRGa7?=
 =?iso-8859-1?Q?YwsLg2Q7F7BF0OrmCTUOaZG6ADkTi/NGp8G0zFrcdXLx+rG8199p3t1QAB?=
 =?iso-8859-1?Q?DXozIGDHq1tIPsXvxA2giyKmbIjuwj7976ZKioQuyCYFVGMEJh44sjFSvP?=
 =?iso-8859-1?Q?1HSQi4RoOSeDS1a7cot4ONltdOWfDUV8WRK+dfRELYQnrWOMHBPOSq1KtT?=
 =?iso-8859-1?Q?Hkngfh0AZ7DiMUr0fgssoYaLrbN0pW0TQsA18/1IePEkDOGG4P+n2r+DUe?=
 =?iso-8859-1?Q?55CIJ5pnesGJdS63hXaEZtMl+RGweoImirx7uG4ZcW2yFaokbnfp16hSKK?=
 =?iso-8859-1?Q?tn9j8Nfva6YSZeWUpLLNsbIcIVFugHaWn5pE7TvSJmQ2/DwRspZvWt56Ar?=
 =?iso-8859-1?Q?+gwJcJLPP0+3qhw79EY3n8c/1vDGwZsvloakgMz9TGntpKY/kG4NJ4aeK9?=
 =?iso-8859-1?Q?dMdlj9zRXFvOKIjzFbtRD3yF+5a1PI28+MlyV7Te5VEu4qld0zlvBdfa75?=
 =?iso-8859-1?Q?xkVzuLU=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY1PR18MB5874.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?a6IF0c37tx2TIyoBuiDOSeVKa46jw6Z9QtyQDi5A1VZTpELV1oNWkNHky6?=
 =?iso-8859-1?Q?uASqCMKeeMpBfISBaPYw1I3mxJpWrZ/99DgDf08O9yIxhi7nFsUff1EHJc?=
 =?iso-8859-1?Q?uWi2oMm0oR2nci09hzAxrXhciDyloFcYRNrv451EYoFU6IzSBXPYFalCOu?=
 =?iso-8859-1?Q?ayaatQlxotFrLiViZ9GRzFQ7QuwSh2Y0FX6A07kLBhu176+vA1E81/id0i?=
 =?iso-8859-1?Q?C9Nzj9sqVP/iuAxqYFJi4St0Y2nORCNP2bcoOESL/0A1R7EMBuQ1dnA6xP?=
 =?iso-8859-1?Q?9ihWgnrjwhm/12GU5DB7gbiJoaIJlrU1KWIFBeRIwGYJ+uN0IOoHY+CKja?=
 =?iso-8859-1?Q?WUBAfik/68EpOQBLOKDGhHBbVqIhr+lscJNMNpfTQ2NxDWnkhWJMwfL3/7?=
 =?iso-8859-1?Q?wq8mj+yiwgTMipB+8cOpqkD8IpJC8xW19vSJt6CnkFX894p3zQJvdOrpCN?=
 =?iso-8859-1?Q?7LGw9XXIoHYvAjaT6I9+X8KDZy4Rr7oNGWxxy3tP6wJKX701kfaUIoT8r0?=
 =?iso-8859-1?Q?XQlBvNzU86n4vjdGPujSXrStemZFccrqBl69KZ/ru0bKI3XWxnnIN3Osjg?=
 =?iso-8859-1?Q?v7o8FDbSNqP/Oup7iPForZzZ25uNkxRmWcJeStWzd7zcWy6epRFzye7Mck?=
 =?iso-8859-1?Q?9LJOC80QbG0Ro8cXQpIDfUYs45Ht0jwhzvWRbXn9qFeo90ZKtMAkUIk7cY?=
 =?iso-8859-1?Q?VaGdtF9TqsPkRZKlCM9A+lXkPug3m9FvP7nSkuWbwyQIyw8OMCpOViC25q?=
 =?iso-8859-1?Q?hPZNvpFi5c3QfC4uHkSVZvbAx1sf6r+rHWJCWlYyE6R5majJcIcuOuejm9?=
 =?iso-8859-1?Q?jG3CcYj4DVQ/T6P53w8Ah3tnkczfqXa2HMGW0EFDZ8NSHz8o6cCRWAa5Wj?=
 =?iso-8859-1?Q?sVcWwa5yRPTwhlANTexgRU0SBErQspkHY35j/kbpl97LwTFGq76mt9fMUr?=
 =?iso-8859-1?Q?iB6mEXg97U5XtkASnisBWOSMqbBUJ7EZEuhZ2rthimacNkihRfsVRgUPlo?=
 =?iso-8859-1?Q?sPtMWAL9WNiW+PNt0ywKLcCTKZRaP87dpeRiE33WftXxYVBRgYRkBZG7lI?=
 =?iso-8859-1?Q?gWNygIXnmeQWmCuloF1GGeuWgHCvcqWcslw1WFOTaiR3NnC/lcgKe4B0TH?=
 =?iso-8859-1?Q?DDZ3YUIqR37eqtmYgUY3kfgA6pgPv0OY2mvt7OK9Y6bxSFGGTmqGIUt3r/?=
 =?iso-8859-1?Q?52wFqy9RR6AVCUFNOxIExA4ZnY9KRxZx7XQz+DqtTgS7f98CwT5feicXUE?=
 =?iso-8859-1?Q?xI2OiIFuKTK3AmIOvIbyc5iKpY5Mljgm8KFz5pyedhKyVTjLrkYdtFmNHW?=
 =?iso-8859-1?Q?yvz+LPRjCPXdITbKGuVOiGApIP5h0dNimVydEyNqWtpHveq11cy1jK2MWs?=
 =?iso-8859-1?Q?ZoMYRByMDOjzw1DQsvu8bqckycINwBP7CCCPn8aXukqhEAbqBLgB0gEROY?=
 =?iso-8859-1?Q?6IbV1mnp4JthhYdXyH2mEDpGM8UIA260j1C12vjI7gt/CNwieJd9kIjFvN?=
 =?iso-8859-1?Q?bUvGGZ4qWbOccNMiyo32BABqZD3xx7s4gvLJPMLWM49drMnAeNcdx+tDNj?=
 =?iso-8859-1?Q?Ju6eKahQ+hGqaLhMftWcS7PgOPzKTKU0jo3Y267GtBj0RqWxyAb8tPhizB?=
 =?iso-8859-1?Q?SZ+mnGnTtJ6Nm7TQUYgibFK4VaFPpl+LDf?=
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	swOjvjAH/mn/zzqtyFgGT8g2FFPdE5qQN5EWwf5PquqeH9tP6VYxU1qfteJrCb+5YEFWzSJ23HRBOl/jpknl8GeU4ihB7uEQQHdvItsZjnjHVxW7+VqoHloEp68eEd+ajnLCYdQDNBa84tEJAQe5jRMuLWdcKgDDC7uC/ZDb0zDyLXdta9Wk27o2b2W83uNYoKvBYkjPtXXFEXzRo4eMIYrse1aTaSybLB4fJklQsmGFZMkDmzb9Lc/AIPF2YEitq1v6fzo+g+1DO6nCKu1sBd+c03cfOh5ZA/fAePPGqbAjzaJa25g7Lv+1tUyRu5ILIEendNB25AeFrHbXn3MGLjQ28SAgT5LKSX+2ktKXHEjj599z0wEp4dCtRXS/nuUENFnsbVehO9wEFwy7jI2xMizvV+EN2dPDCrLEwqx/HJraeCB/+5yMtRGykkznDHgzK+JbzHNTMJmRqrq0CeU+OUde/NE/bE+5V5sOPw+WLTXKxek3aD1hrtW3FYgnu5uh3k+Op0FsDs39fKUp2hDFfRugNlbkAu8X0ZUuVQkOtihD+jUHkbzFLJ8sKhxuXkFNs5uuTevApVPrfqVXVUp22u1CZMffdR4QyURWr/12NNgAhujq8U5NE38QqKY8qM0A80h3zK36EsFfgWWI4pDoDg==
X-OriginatorOrg: belden.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY1PR18MB5874.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4a78682-2c6a-4b32-18e6-08ddb3f7c9b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2025 14:51:37.8068
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0f7367b1-44f7-45a7-bb10-563965c5f2e5
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wS73hklmysMeX6/CQaA4nAenLktkbDZKj9M7JDOmqJlDFSvEJEuWHPvIMGpiAQUaO6miqtehjyXgwtRh+jExZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR18MB3470
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI1MDEwOCBTYWx0ZWRfX3G5gBr2aOI+g
 S4Bba2vJ+hVJmegaoy9AeFRu2PhOlluAdzzL2Wi1Ny30IDiaShssZfgWaHSvBgn4+1dMOW7sKrl
 Gn6KEOLkeJ5ovVkj0opbwVOz7OwOldNrXH/3wQz6l1KWZD3wGebf8jadRmP0xEfZoHnbxXzSiGN
 /cn2hOlIpnP6pMosi7YveOjJtR/1v6NfgTPfI61eS9e/ONO3Fh3j+XA1lYF6YZTZo2rAcZjxkmh
 ANFZ3DnIU+2EYUgyaK5FdazO4L9eZB0SDVD6M/54GM/atsrRhH82aQKnAQPlocj/e5Y38u1E3pS
 u/Cl+Xx+K0x35JtLPnCyoA3XCBHHLYJyyhQRyqTcZklf0a3X5+BD2q8cUNwY+PcKzrDYutUjk6H
 hF2reoiUrVAR3IVsTzXkf5Ko/ughkXW7M8cQ4UgybFkLL8Aa85Z70MQgAsT9+rCGd9fD7Nw+
X-Authority-Analysis: v=2.4 cv=aK/wqa9m c=1 sm=1 tr=0 ts=685c0cfb cx=c_pps
 a=ITavxs4S4at15BTzwWu3Ng==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10 a=6IFa9wvqVegA:10 a=mCf63rc527wA:10
 a=WDlp8lUfAAAA:8 a=9uhfofQvCe30nU1JH8kA:9 a=wPNLvfGTeEIA:10
X-Proofpoint-GUID: 78i9V1xtfeCHI4doUiBfOJb5gpw0Z1U4
X-Proofpoint-ORIG-GUID: 78i9V1xtfeCHI4doUiBfOJb5gpw0Z1U4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-25_04,2025-06-25_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 mlxlogscore=686 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 spamscore=0 clxscore=1015 impostorscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 phishscore=0 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505280000 definitions=main-2506250108
X-Proofpoint-TriggeredRule: module.spam.rule.outbound_notspam
Content-Type: text/plain; charset="iso-8859-1"

Thanks, I checked and this setup has a lot of sets and some of them have 10=
0-200 entries.
When I clear all the sets I never have the error.
The nft_set_flush must be the reason.

I think 2. is the general solution that should work for all cases then.
I will have a look into that.

Best
Sven

Sven Auhagen <Sven.Auhagen@belden.com> wrote:
> we do see on occasions that we get the following error message, more so o=
n x86 systems than on arm64:
>=20
> Error: Could not process rule: Cannot allocate memory delete table inet f=
ilter
>=20
> It is not a consistent error and does not happen all the time.
> We are on Kernel 6.6.80, seems to me like we have something along the lin=
es of the nf_tables: allow clone callbacks to sleep problem using GFP_ATOMI=
C.

Yes, set element deletion (flushing) requires atomic (non-sleepable)
allocations.

> Do you have any idea what I can try out/look at?

Do you have large sets? (I suspect yes).

As for a solution, I can see two:
1). Leverage what nft_set_pipapo.c is doing and extend
    this for all sets that could use the same solution.
    The .walk callback for pipapo doesn't need/use rcu read locks,
    and could use sleepable allocations.
    all set types except rhashtable could follow this.

    Then, we'd just need a way for the generic flush code to
    see that the walk callback can sleep (e.g. by annotation in
    set_ops).

    Upside: Clean and straightforward solution.
    Downside: won't work for rhashtable which runs under
    rcu read lock protection.
 2). Preallocate transaction elements before calling .walk
     in nft_set_flush(), based on set->nelems.

2) is a bit more (w)hacky but it would work for all set types.
And I could be wrong and the alloc problem isn't related to
nft_set_flush.

**********************************************************************
DISCLAIMER:
Privileged and/or Confidential information may be contained in this message=
. If you are not the addressee of this message, you may not copy, use or de=
liver this message to anyone. In such event, you should destroy the message=
 and kindly notify the sender by reply e-mail. It is understood that opinio=
ns or conclusions that do not relate to the official business of the compan=
y are neither given nor endorsed by the company. Thank You.
