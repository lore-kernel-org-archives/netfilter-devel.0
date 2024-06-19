Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2126.outbound.protection.outlook.com [40.107.20.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28626612EB
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Jun 2024 11:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.20.126
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718796583; cv=fail; b=OLfWBpHGKYw1wcbcjPRW/G7IawZ598vQr6/qk1PiWca7Dcsi6P82nAnYKVrhWmHEA9zh3R6qzFvVL4pQWnzc4rDodw5Vzib3RpY+/5oB0/xpPXS+SUxVWk+6iimoGoOBQr4N4RDHCqyY+IAbOk1ESQ2OgPC/a6RR3oM/maaxE3M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718796583; c=relaxed/simple;
	bh=rG2pk4atNWyS40pONNivThpvhhrCxN8kZIYxIb9mlgQ=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PW8Urv3EpAeOIJVpGBknX57c/+oocdV0lCkrNOVcY5cGM9CmFEdvPcouMBpgA/nzOC5UYF8d0XpveJ0gzUPjvnqAc2R2JQnZsZN69LSs8MyP0GPh8VlY57yEpkoRDopwkYRlfQeed5mCMMvkum0RixWF2WiRphjHwIJGQ1ZS/gM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=keba.com; spf=pass smtp.mailfrom=keba.com; dkim=pass (2048-bit key) header.d=keba.com header.i=@keba.com header.b=XRQZKuDR; arc=fail smtp.client-ip=40.107.20.126
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=keba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=keba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=keba.com header.i=@keba.com header.b="XRQZKuDR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MxlFKYLNYT+YkU6CnK4+YYECW3R4OTzy4RJUC+ainjH/L5asSzBbc7F9LKKvW/7HhrddZXZ1+z5KihVa4vW9zvnO6kZTv2uJGoLOJsY4pVrNESRlc/DtOFfVlJHBDr9EUvPTtOvwF02dfRXOdH35qR86cz+DtBg9nVaS67469BUs8eTX7xdk6JcYfxhW44sWJFJENFMql6d26UZzZeYWBFqzF0EX1ZKpP38aWcEb5DvL9UlcbMa0rRVhNTG0BfLL6RJ/LkuN+iOT6Q0+HLCTa1KJrlPeu1gG7sK962Jt9GAPQ+IE4SJlnZBKqZkNFJSf3HbOfXRxngY56HYnhIC18A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+2BcludiJfcCBXexPMrGTpZIJWoiN2eCueyvodCHaVk=;
 b=MhG+BNpVIW2c4Kx/u4FY/cyvqxbs/hdQSc75Q1oxJVduoFd5d4Py7dPWfJXVzWb6yKhAWpG9IrOUpKtWfdSJpuZU/w4n+RosUbTKqNvpqFOcLgm9/o4C2bwrcEY5YqNPogBjhnT7kOGfBmeyhL7qqCpks2upnGbKHyccVY536Mv1ImhdTDoUhrGhA/k5MZ/naUhLbLROoknjiJNGMz5faAQhNwaRADUd3uah/uINPciXbSs/wGsW6lPd4DMCmYp1jRcrlCG3dcwhAdRcvNAwJrclVtz6aApLe0+8WgBuHBYOZE+iVypGn8Vci8RLDyCuYWbjezvsw4jXtrF9qpNIIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=keba.com; dmarc=pass action=none header.from=keba.com;
 dkim=pass header.d=keba.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=keba.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+2BcludiJfcCBXexPMrGTpZIJWoiN2eCueyvodCHaVk=;
 b=XRQZKuDREWMvvlyFNVN/lO2FjVM/RF2twj0UskA8BZVt2wtj/0L2tC6WQgfFHKKm6w3eVuDFb0FtWRTV1GWpXdTXUylPuZHqoaw5wMO0n5McidU4PzXl5xwgikdoejxfKkjdg8S1Oe7tf3tFjQEp+Db1JldzbI0tD2xiAsb8rDcWWzw0SpLEdRwlkQbfq6i6f9oqS+Qce+6Vy1tVbHoT5yKSgkase22Hx5OCQs44sxgt62cDoXk132e+Fu2xHhFuUgHPQEGk7QC1rMK7LcG53s9dC2w5y1pO7VrXUhFv4p6Y2ea8+hdFdeLjCrTIzksWu2/OWUqEcD959ItcbdDhtw==
Received: from DUZPR07MB9841.eurprd07.prod.outlook.com (2603:10a6:10:4d8::7)
 by PR3PR07MB7002.eurprd07.prod.outlook.com (2603:10a6:102:7d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.16; Wed, 19 Jun
 2024 11:29:37 +0000
Received: from DUZPR07MB9841.eurprd07.prod.outlook.com
 ([fe80::281d:a24f:a337:eddb]) by DUZPR07MB9841.eurprd07.prod.outlook.com
 ([fe80::281d:a24f:a337:eddb%6]) with mapi id 15.20.7698.014; Wed, 19 Jun 2024
 11:29:37 +0000
From: pda Pfeil Daniel <pda@keba.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, "netfilter-devel@vger.kernel.org"
	<netfilter-devel@vger.kernel.org>
Subject: AW: [PATCH] conntrackd: helpers/rpc: Don't add expectation table
 entry for portmap port
Thread-Topic: [PATCH] conntrackd: helpers/rpc: Don't add expectation table
 entry for portmap port
Thread-Index: AdqXCOniFtq9Dyz6TEmv+uvqfOYRYwrL16OAAAArXAAAAGpZQA==
Date: Wed, 19 Jun 2024 11:29:37 +0000
Message-ID:
 <DUZPR07MB9841985506C0E34204093904CDCF2@DUZPR07MB9841.eurprd07.prod.outlook.com>
References:
 <DUZPR07MB9841A3D8BEF10EB04F33636BCD172@DUZPR07MB9841.eurprd07.prod.outlook.com>
 <ZnK6821kYBYzqRZZ@calendula> <ZnK8Fj52_8cIgKp9@calendula>
In-Reply-To: <ZnK8Fj52_8cIgKp9@calendula>
Accept-Language: de-AT, en-US
Content-Language: de-DE
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f7ce15f3-f9cf-4fe0-be64-c49742693951_ActionId=276eee32-7d09-4a14-ba5b-77a909e98642;MSIP_Label_f7ce15f3-f9cf-4fe0-be64-c49742693951_ContentBits=0;MSIP_Label_f7ce15f3-f9cf-4fe0-be64-c49742693951_Enabled=true;MSIP_Label_f7ce15f3-f9cf-4fe0-be64-c49742693951_Method=Standard;MSIP_Label_f7ce15f3-f9cf-4fe0-be64-c49742693951_Name=Confidential;MSIP_Label_f7ce15f3-f9cf-4fe0-be64-c49742693951_SetDate=2024-06-19T11:19:59Z;MSIP_Label_f7ce15f3-f9cf-4fe0-be64-c49742693951_SiteId=83e2508b-c1e1-4014-8ab1-e34a653fca88;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=keba.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DUZPR07MB9841:EE_|PR3PR07MB7002:EE_
x-ms-office365-filtering-correlation-id: 192bc5da-b7b8-44fa-5313-08dc90531a26
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|366013|376011|1800799021|38070700015;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?UTvoLYsTj/Rhlzrh3fIaHLp5Aneh/Y/Hut/Sg1pLObKSfLFquenYg8CfM8?=
 =?iso-8859-1?Q?r6RycSZ31C7SZyiVXR6IyMMshnTdJj41W/Cn41he9OcxyRVcyBMLJDJASp?=
 =?iso-8859-1?Q?oYIlaOwcvZrB1A6kgawhHoekjP+TL94aJHzPE+DBM3hpN268uLXQdmYPKt?=
 =?iso-8859-1?Q?l+djXiclldFFZlIk7jV93jCq6tT43lkDYQhhL/54a/aAo5ac4/+CRuuZOU?=
 =?iso-8859-1?Q?bc/XOYHEyEujBqodmaGNfY+lhYd6+VWo/tcY04DBSDucKpIuAz86lY97xt?=
 =?iso-8859-1?Q?TI8bKk9vtkM0c5fEz5BPzi5fwalnrk/TOY8vnjlpgimFGh+iS1uvhoHFpz?=
 =?iso-8859-1?Q?K98eN0mMp3S5MxOabDeYFkWvIgmFzhgf+hYZz8AlkP7rPpk9Ksc6sQ6SPn?=
 =?iso-8859-1?Q?oBi4+Tl7SdIr+OzjUwe3YOp+gWosX/qNe3QgrigurwmkXpJZgQncqfoype?=
 =?iso-8859-1?Q?Myj78Y++rJgG6R9dikTtdaUB/aEOfNYHmuRJMY5dapIGXKJKgBfWPNxMvS?=
 =?iso-8859-1?Q?9di9O7M2VDtkvbGjkLuYqP/CI8+qLitw0KPzBy04E3kI275V2K4OZgzUHV?=
 =?iso-8859-1?Q?yLmr1/m8HKCCmWjvsLAq5efEGs/pDLzGT04hocb8BWPHuY48CY5ngnOhHQ?=
 =?iso-8859-1?Q?V6A6ass6Nq5fDY7RsT11D2fE7VG5cspikCi4v4jeIv8bT+jzz1HGGGX+fX?=
 =?iso-8859-1?Q?fT1Sn93ztSF3E1i6gH0fvZNybdPgwIxnWXPEIVnfXcO7zHwqish8Dh1fHD?=
 =?iso-8859-1?Q?4Bkh3Gj0/SJ1ZYowcNlyqKpqeORyPxcJBtTeuC0rgQhsct3NPaNxnjMgLt?=
 =?iso-8859-1?Q?Om0nzbln8RtTEdwCMSrpaKxXwcW26hiayoH4aveczIPSu/jxWL+ks4kWLt?=
 =?iso-8859-1?Q?I3/rzVR+4N64pXqqeosyu6UKKhbjaJNPHRRd7jIbVCWjgULkoMtP8JO9jV?=
 =?iso-8859-1?Q?WaVvdWzB3/f9MUMD6g59z/nW1fkA3tknkXOvB/zVNUMljliErfavDWO3Yc?=
 =?iso-8859-1?Q?Tl5OaQFyljU9WlR3xSGd7McBx5y7zBcbRKN3DmL64s0pOjlqhD+9Xa7kWw?=
 =?iso-8859-1?Q?Y7VMFnDhELHUuRoy/GYFdxRga7Y4pWe9wTpTMf4+fUj19H0rvT+LM2xAN2?=
 =?iso-8859-1?Q?og5kQt1JDOY0xEwNghqdpKETtdrBrCbFrx9rXwdNNq7mx7bHT2BtgxXYci?=
 =?iso-8859-1?Q?yAnWYM71PwMgqIX3d0Y9aLGpuFennv7TObw75dE9J7hF86nEzNwMag+Pbo?=
 =?iso-8859-1?Q?0B65PQfnT7coNBpd8mR4zmZw7z4sZtC+yHnzAH4fDyxBeB8Ku+LHli0rt7?=
 =?iso-8859-1?Q?/78kgQKJ31iEtKwXx/HxDwo+Q85xFVggY07NzKepvcUGo0rOs9Nh/jiUop?=
 =?iso-8859-1?Q?ASJE4L8zBK?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DUZPR07MB9841.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(376011)(1800799021)(38070700015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?jQeTqnrDYab2czai9QUsmVjPG/RZHxQNSYk69+jM97IySBF9ed1YVc67Kz?=
 =?iso-8859-1?Q?ATscgJiqHDN9zesmmk0YanIyNfQS9RMtTuqcWcGICbqb1vI4+JAPtgVGQe?=
 =?iso-8859-1?Q?uiuCL1LQNrypNO/T7vfCASQz+YHajcODFf6L3q0yc3xTUmrYNCgQRXSi3+?=
 =?iso-8859-1?Q?B3mTiVF0sd7K1SDN5gNYD4tTJpxiiEcqpw6SwadRG0dbUwAgIoZ1riMcNi?=
 =?iso-8859-1?Q?PkRDRl+PT9zdEMfTBnP+KenKAlqy5l7Kw4oQ83zxLQbK20NtI9Q7PszfPw?=
 =?iso-8859-1?Q?FlkKAGDTbsuJvq7urIJwnbtszdKQ54DK42JAWK8g8xd+1f09b6Ce8r4GN6?=
 =?iso-8859-1?Q?2zi4PzGbg80i2cCrdQswUOR0NUQHC67oBE0BUKXAH75G3vqh9m6GjwAvI8?=
 =?iso-8859-1?Q?7raA0bVO0/dOtn6+85xj+VHF+e18U7pmvzMPxT8+1f9aSrGeIPadxU/y1y?=
 =?iso-8859-1?Q?snHbNJlaEhhxFsjilzXmA8kFl4FMJMa6G/SX5mny01h3U5jPCwWTctg8cV?=
 =?iso-8859-1?Q?MsLGieMouEdQ2/8od53wGElZRQDx55iRN/hEosIKS9iaLiP1CewPzm+rIZ?=
 =?iso-8859-1?Q?IeUWTfEmLNUwnNw1sP+jYddNpL7NwfgLNV9WfLrxIWdb7VgCLEBi3lEQvn?=
 =?iso-8859-1?Q?jEGb71QFyDxNUXRCaYfNeLJTIZLK+zg0LNaE10dTi4CdVXu83j5H4GTsn/?=
 =?iso-8859-1?Q?uop9h4pSAaiIhTViB99Rbg7Yxp+1aZZGj7kKcvP0SvV1z0SYmIFS55Ljpv?=
 =?iso-8859-1?Q?NO1TsXwF69pA+DDeZTM18koUC1gKR5e/SYWDf0/yYh8oVeNn1RBNa12H1x?=
 =?iso-8859-1?Q?8k+QF75r9JeGKQZSGp1gtXepT5DeBnCtUTpfjFhpqqSDif/1ByeX4qgrbH?=
 =?iso-8859-1?Q?VUrYCz97ZjEyulBb000AQW7/OAJTnj/Zpsp6F05TQ6Ggo+tbnLFIsGjjRY?=
 =?iso-8859-1?Q?Vd9v3Y3Ao7WbXp7v5QtBqWR+I5tLoKj/NAoUcXf33cgLZMlb0xrYPZj+pU?=
 =?iso-8859-1?Q?TkyvaLncGKw50eiBa0X2YfIBEkjwlc+ktldnDqWCq3awB1PNxM+8rRa+Ey?=
 =?iso-8859-1?Q?ZauAkTaLe5Q0zMqAiJCCAil7eYAFZ+3SfNubLqby017odfRTsyIsX+P6ZV?=
 =?iso-8859-1?Q?+3+ee2NWRVYq5C3wAjzQFA+IwpedzpfjC4mT/2da3fuRtfdT8jQRfzYpID?=
 =?iso-8859-1?Q?TArTuZbfX0m2HiKUeziYiMYZB32Mbt8yQOkN24wYshY3jIa+mC7HV2dRzw?=
 =?iso-8859-1?Q?ULIokxzAEeFwHMgmmg2GhpuqqxcKDkAA9LnhsWL6LUkkf9u+aPru8tFXh6?=
 =?iso-8859-1?Q?FAKinyt+afftOrd9WP+3nCOOCvY3jVxwAjuc71H0NL8VeyX0CLcND/MF84?=
 =?iso-8859-1?Q?FRNTWH2oyZB/WC3K82r4AIk+lNDTy5UVD/7ZAlpyrEBcWT13JDVOAdoGWF?=
 =?iso-8859-1?Q?AEF199q5fcltPNLvAQLdR+42J1HnebSMAX6tovzZoy2xyogEaUWgQdlTm+?=
 =?iso-8859-1?Q?qswDf6xOeXUxz33QDzuD3pz0KQHrxh7LLM+5CNWVURnygWomusD6HSWVm8?=
 =?iso-8859-1?Q?9SUJRjEpIJXfLkx/Lk/M3vUQpwngak8rbkdEWiXlWvI5NLwOXOMER/sc8n?=
 =?iso-8859-1?Q?GziZ+BaQErjrk=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: keba.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DUZPR07MB9841.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 192bc5da-b7b8-44fa-5313-08dc90531a26
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2024 11:29:37.4846
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2508b-c1e1-4014-8ab1-e34a653fca88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EzSfzKFZjCSx0T1DFafslekoGF770+fPiGsFpDSR398wIaTc3eqNsuL4kh6UhVAd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR07MB7002

Hi Pablo,

the portmap port must be opened via static iptables/nftables rule anyway, s=
o adding an expectation table entry for the portmap port is unnecessary.

BR Daniel

-----Urspr=FCngliche Nachricht-----
Von: Pablo Neira Ayuso <pablo@netfilter.org>=20
Gesendet: Mittwoch, 19. Juni 2024 13:08
An: pda Pfeil Daniel <pda@keba.com>
Cc: netfilter-devel@vger.kernel.org
Betreff: Re: [PATCH] conntrackd: helpers/rpc: Don't add expectation table e=
ntry for portmap port

ACHTUNG: Das Mail kommt von einer anderen Organisation ! Links nicht anklic=
ken und Anh=E4nge nicht =F6ffnen, au=DFer der Absender ist bekannt und der =
Inhalt der Anlage ist sicher. Im Zweifelsfall bitte mit der <https://collab=
oration.keba.com/trustedurls> Liste vertrauensw=FCrdiger Absender<https://c=
ollaboration.keba.com/trustedurls> gegenpr=FCfen, oder  den KEBA IT-Service=
desk kontaktieren!

CAUTION:  This email originated from outside of the organization. Do not cl=
ick links or open attachments unless you recognize the sender and know the =
content is safe. In case of doubt please verify with the <https://collabora=
tion.keba.com/trustedurls> list of trustworthy senders<https://collaboratio=
n.keba.com/trustedurls>, or contact the IT-Servicedesk!

On Wed, Jun 19, 2024 at 01:03:20PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Apr 25, 2024 at 12:13:11PM +0000, pda Pfeil Daniel wrote:
> > After an RPC call to portmap using the portmap program number=20
> > (100000), subsequent RPC calls are not handled correctly by connection =
tracking.
> > This results in client connections to ports specified in RPC replies=20
> > failing to operate.
>
> Applied, thanks

Wait, program 100000 usually runs on the portmapper port (tcp,udp/111), whi=
ch is the one where you install the helper to add
expectations:

   100000    2   tcp    111  portmapper
   100000    2   udp    111  portmapper

How is this working?
