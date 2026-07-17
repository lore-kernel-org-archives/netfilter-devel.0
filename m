Received: from mail361.linkedin.com (mail361.linkedin.com [108.174.3.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94C039021B
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Jul 2026 18:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=108.174.3.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784314772; cv=fail; b=iInl+Snrv3d87JhOcZ67PyW83MHqtHl21rW+0CZiY+UNAPwwZj1D8SHSWpnysc6Awp+dsDro663/9zvEB7UfC+sCN0PfmFXnjwflOW/vW6UlS26vAI6tZsWHMKwh6SFkxeZjA6IgZyTUwZm7S/Loz6nbOS1ObFVpUD7aQNHrmkg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784314772; c=relaxed/simple;
	bh=I1CUomarUEH9GF1sTSRgtSqv5bB/Cyzld7W58vhcxGI=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=YkwgtKYQLSqyvD7813xCrKg0uAu0jfqjoGvG2zik4feUYl5x6QnV/+QWnXjuAknMjrCQs3A9hfoiDjsovHJhsrVzxeXUY4hc13JcTrc+seL9fKp2VZ2idUVhN3TJq3eAuUtXrp7spKcXokLT1YHfOIxqK2aIhZ32FfFvjLjJOXk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=linkedin.com; spf=pass smtp.mailfrom=linkedin.com; dkim=pass (2048-bit key) header.d=linkedin.com header.i=@linkedin.com header.b=BjkVeNq1; dkim=pass (1024-bit key) header.d=microsoft.onmicrosoft.com header.i=@microsoft.onmicrosoft.com header.b=nboN7c2u; arc=fail smtp.client-ip=108.174.3.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=linkedin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linkedin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linkedin.com header.i=@linkedin.com header.b="BjkVeNq1";
	dkim=pass (1024-bit key) header.d=microsoft.onmicrosoft.com header.i=@microsoft.onmicrosoft.com header.b="nboN7c2u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linkedin.com;
	s=d2048-202308-00; t=1784314769;
	bh=JWpYcsc+REk9vb1JWEFXwxOKyJLI5cqQySZO/+u+tss=;
	h=From:To:Subject:Date:Content-Type:MIME-Version;
	b=BjkVeNq14frpCcRSR00rIclTJaJl2ksMLlm93mmQjsdz3h5+9lJnb44mIQKare6Pe
	 EFgtRcXerQSA2DicDYmgHEVX9vSiLCYouqnFptuixf8O4uLJTP9HJt8APOFHW6IBtf
	 QGGRzN4h1xaHyQVhjetUGi4uih9BljJQe1VeSerMf1i5an12gy2A6KzTHbZF9iksF4
	 c/RZn/kj9XyMXo+ylz0Sia1qGGeibUXrFeLmsmwdzN8708nEsyyGtRjPS4BmVohOjm
	 34izsADpBtzjB9T3bksyD/zJ+KgvUMpBZrI6Dr6DaaZEczUVES07FfBkTd1VF8twtR
	 m0YuA0I5ToSIQ==
Authentication-Results:  mail361.prod.linkedin.com x-tls.subject="/C=US/ST=Washington/L=Redmond/O=Microsoft Corporation/CN=mail.protection.outlook.com"; auth=pass (cipher=TLS_AES_256_GCM_SHA384)
Authentication-Results: mail361.prod.linkedin.com; iprev=pass policy.iprev="2a01:111:f403:c10d::1"; spf=softfail smtp.mailfrom="omkhar@linkedin.com" smtp.helo="sn4pr2101cu001.outbound.protection.outlook.com"; dkim=pass header.d=microsoft.onmicrosoft.com; tls=pass (verified) key.ciphersuite="nil" key.length="256" tls.v="tlsv1.3" cert.client="C=US,ST=Washington,L=Redmond,O=Microsoft Corporation,CN=mail.protection.outlook.com" cert.clientissuer="C=US,O=DigiCert Inc,CN=DigiCert SHA2 Secure Server CA"
Received: from [2a01:111:f403:c10d::1] ([2a01:111:f403:c10d::1.48332] helo=SN4PR2101CU001.outbound.protection.outlook.com)
	by mail361.prod.linkedin.com (envelope-from <omkhar@linkedin.com>)
	(ecelerity 4.7.0.20111 r(msys-ecelerity:tags/4.7.0-ga^0)) with ESMTPS (cipher=TLS_AES_256_GCM_SHA384
	subject="/C=US/ST=Washington/L=Redmond/O=Microsoft Corporation/CN=mail.protection.outlook.com") 
	id 74/AE-32778-19B7A5A6; Fri, 17 Jul 2026 18:59:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qBSzPTjsg/heWXNYU7GP+/V06hD80SE2AN0/Then/rJhC4yG2uLgr0E35eKZGsm2Pzmjr5N9Phvb1iYfXxNYvDX3w1CBmv8fAiK4K4sYujLNmlrgvZklCZ6RtERyhpz9dnj+kDhCbQY2fKIkIcgCzbsw7AW8oFpG7BKtKF7SfgOnuVAP+a13SITegLvtvRyMhA7ubAs4imycXJbwXPlfGGnjddahvA3kkvdZOCoWxsQd5RjGCF5koaJUh2assdh4miXU+FR1Fa/KaH3/6XgsRCr3XdrM9G/VrFekHOpSzSB0X+jJDYL9IcTXhcqY5hsLEW37xoPwT0gCd8aDy1vNuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JWpYcsc+REk9vb1JWEFXwxOKyJLI5cqQySZO/+u+tss=;
 b=FZUXYeo4dIk+dW8AeQkh/WTtAemIJ6lzboAPV9fJWfBvuzuhAf0lHe/HTNZ9c7RHCMbk8VJLly51qukD4r8zlqfj6bClL3K5byjxDIR6xV/wuQ8E/yqBDWTp/0a0JjZufmnNkww3JMTocVE4Wgd1N2Ewe6Ul69xiie0G1TfWfJV2mLjyQ1ixNBRZA9E5VL0iFX/7T85uqzGhh8Cn88coScf/dN9HtJN3hOMd53erTwrsdbToVJ5fsO0DLA2T3PyP33/V49LOAtFliUMt+uNNucDhoUXdhP580wGtlwJhyvKA9HYDPtTicDP302PdRhVyaGi4vDD+PJeHyNVV7xsrcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=linkedin.com; dmarc=pass action=none header.from=linkedin.com;
 dkim=pass header.d=linkedin.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microsoft.onmicrosoft.com; s=selector2-microsoft-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JWpYcsc+REk9vb1JWEFXwxOKyJLI5cqQySZO/+u+tss=;
 b=nboN7c2uT8TZZDxU2alxR7bqH42bN+mQ9Zlcm8m1MAjHfmXDJbfWV09xODT9rmqXBo4fFEbJGjYQoPuvjBNra6AB0UM/mqUzkp7ERND8DNt23EFZ0Na0adMx7d88aHpo6NsId01PE8f7IYbWbq7vPOQdK5rc3CVu67jdPTIV2z4=
Received: from LV0SPRMB0026.namprd21.prod.outlook.com (2603:10b6:408:340::11)
 by LV0PR21MB6166.namprd21.prod.outlook.com (2603:10b6:408:333::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.2; Fri, 17 Jul
 2026 18:59:27 +0000
Received: from LV0SPRMB0026.namprd21.prod.outlook.com
 ([fe80::cc6a:8bdb:554:a0bf]) by LV0SPRMB0026.namprd21.prod.outlook.com
 ([fe80::cc6a:8bdb:554:a0bf%6]) with mapi id 15.21.0202.006; Fri, 17 Jul 2026
 18:59:27 +0000
From: Omkhar Arasaratnam <omkhar@linkedin.com>
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
CC: "phil@nwl.cc" <phil@nwl.cc>, "fw@strlen.de" <fw@strlen.de>,
	"pablo@netfilter.org" <pablo@netfilter.org>
Subject: [PATCH iptables] nft: fix out-of-bounds read listing an old-revision
 match
Thread-Topic: [PATCH iptables] nft: fix out-of-bounds read listing an
 old-revision match
Thread-Index: AQHdFh4uLCE++9ErG0ylVn9AujZ5Yw==
Date: Fri, 17 Jul 2026 18:59:27 +0000
Message-ID:
 <LV0SPRMB0026AFC6E85D19E90A2C3CBAA1C62@LV0SPRMB0026.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-07-17T18:59:27.497Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=1;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=linkedin.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0SPRMB0026:EE_|LV0PR21MB6166:EE_
x-ms-office365-filtering-correlation-id: cd89c8db-d4b1-45b2-f6c9-08dee43586ab
x-o365ent-eop-header: Message Processed By - CBR_LInkedIn_Mail_To_External
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|10070799003|38070700021|17056099003|6133799003|56012099006|11063799006|10067099003|18002099003;
x-microsoft-antispam-message-info:
 +WYBA+Qb1iRtl+kXIuU8owCNMVYN5eUNHeo1UmlelKzDpoqqdUOf7giWVQlFavSaJ457h3rAYZxvwzVDjKlmqmR9p5VXIFYenLqerM3xbhc0qpnLGvkriMEWPxAzmQyR436G2tsW3BM7MnRf7xnY0xHxgJgYFFfFmiwi5Y8rT5zktBvqPwzGJUMHLwp66aO1jJY0om7vnuM7/qWmfc5nmleOTfg3fkr/0mNZQzhVuviu8DLSU6S7Q2O7HWnPMsxfofA3tBEMPVr7yBMh0NwxoPsdespEaEEnDhN8u3pFVPam0loRdedmnpf/o0U454Ko7GflGncIk5jCNoQclbZedz6KWNlcL+DN68KynbLYgF/MCv86PDd6MrurA37paTRNhjogo2UgA5DTfpVtBfC8k7neya8QVQETvzpw+BDCWbgIERCBV/2yTYKgAggarOSXXZCL3vjaIFWsFkuClS9qp18RIIW+96j7omPYCUxcT8iWPYLlx503NfBoArzD6tccuI3OysPWln+XswlGQqrx4z9YeYbfHXBDvzonGN6VSiO9gc8U/HgAyiQ+Vx+RibdPacJypzFyomYrm8adwMzwZHVlodH1jhtXNnlACz+QFeqUHffoaa8OGMhve3/iTPmzukCw55ccM+eV0APhGyf96Gb6WE2TXds4wVt9mOyq0RDr1zXSlT2jkxr35wgAAjPEm9QGzKti7NghSjPDwOYpLDosjjwsU9oSHg/Np8Ue+Ho=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0SPRMB0026.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(10070799003)(38070700021)(17056099003)(6133799003)(56012099006)(11063799006)(10067099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?9unTyfpKFxsZjAkIbHyo1FcNL0g5aWJ7c1bzjGkYl0JOyVhnBz5S0E2F6m?=
 =?iso-8859-1?Q?nNOT5wcFeH+RcdpA0q/E7XVB2w3uer1eQkEVK1vRcDQdf9ifIhYQ9RUWnS?=
 =?iso-8859-1?Q?io5676JZe3azhkIKm1ooN9D+sk1JSLnhzXZT/eusaqnYjM3ZaAfg2ptH2E?=
 =?iso-8859-1?Q?OFoHqwI+WC2bJDaICTeiYzRJiqx88hKAcFDelhgK0fNFzIojyDnMRdt9jC?=
 =?iso-8859-1?Q?O1oll/8vzQ6d2htJo9qsp3gmD0JRV/mwwe/UIa00umWCk6kD9etbaGp5B3?=
 =?iso-8859-1?Q?iYCnDWLMjid1Ly9RhhLwpGCd084WSpeyzxXOB6P4ABh6LV/O4GB1KG9JZi?=
 =?iso-8859-1?Q?Xvpod40/8BI87sxNCO5BLa9kPkiMXf14GTE8IYr1ghsu2fZbqmyr9JMRvL?=
 =?iso-8859-1?Q?rNP82WyIinzYqBiRA9iXuFzrutA/R7/YhJvSioW9Hc8cCFqxMT4DFeHjiG?=
 =?iso-8859-1?Q?ExhWfHFYOBMUrHP4pGRdCt629padTPOdtOF8LdXPtnNuSicqcgceF+5eHg?=
 =?iso-8859-1?Q?/XSr4PqHBDCTCifM3vqJeUBuRanDJQePiqPopDq8cu4JY6r1HANvT8Hxca?=
 =?iso-8859-1?Q?J1gnvyF41wKGoNcfefIb8lJ8LR5tIHfCvPtzCFFGM/3qAOv9CCA5M/swYz?=
 =?iso-8859-1?Q?OWBZijCKWUyEKRAMIEM9HC6MoqcEfvJ3qSQtdy/1JMivDtfmznNBGOe3Ui?=
 =?iso-8859-1?Q?fxhKQ+xJ3mpoDCcxfVuujRGze/7x9MG/JI6igrrUursiXcHxvangFzHKfh?=
 =?iso-8859-1?Q?DdyHY1a/Pbn5yPLewfHSGLatMpL+BNmRA4Wn5yJMtXJHdBAnTnsB9926Ie?=
 =?iso-8859-1?Q?a3E4dwsFUmfIdIxGl73too44U2OUnouFQl74+3SWovGWajxbFPwloO6JBk?=
 =?iso-8859-1?Q?GlQkUSew9sXV1qgGfPHq11APzI6DKjjSGL6HWSMaFLXfL0CwwboHngZEAQ?=
 =?iso-8859-1?Q?kImvWv4hPT5QcqSpGaaCqoWT0LcrV5BaDeChBzTgEB6V8x6Z1ufeBSFiXR?=
 =?iso-8859-1?Q?Tw1d76jPHKIiX/vpQWQVXxgXRabMH/tpXO0ksuOSdQ+Pwr7SZ7WCZQul/a?=
 =?iso-8859-1?Q?B5Xcu+5zQb5x37OoMdk5oBdWypC+e1s88+jPrlUUqumiX9f4oZc65zWlcA?=
 =?iso-8859-1?Q?iRJefkKDZI/JAfwMUMoQ0Sf19dUKDLi/TmyeP14j8R3zHvuX85JeGy6x1J?=
 =?iso-8859-1?Q?5+wP6vu6cqbQ86mtTBE4ALVFHRckMpCUZzGdDV9dIc+G/1mv2spSpQbQDT?=
 =?iso-8859-1?Q?7e+RJEP/BgFhjF/GHfJEIUbO6XDriCCyuvF+RBYmpjBsR2o4JXmPUh2Ur6?=
 =?iso-8859-1?Q?20BAZCUwS3fPM+gztnXff0YsTK/dD549j3PbSA62cDbChj8xvKky2KaUci?=
 =?iso-8859-1?Q?jfmHL3Y+B3VtGSVbyEgGQ3DmlRjPWpojtwJlq/G8wOVvdGwdnynNJGNiVR?=
 =?iso-8859-1?Q?BHR4GRiyshQKSo/kwj39lpL176BADghGmfFxpC+AdN5cdHviDVD8m+a9MR?=
 =?iso-8859-1?Q?cXd7FMa98waEri4e05wfjpKUNt3aDtxMFeUxoDyUaoCBVzZQKFewvDuINz?=
 =?iso-8859-1?Q?L71xeiDB/Lm5q8EF+NjzxRmmjiV8EwDCppc1b/ORu9SwOeb/6L/bpig1pH?=
 =?iso-8859-1?Q?oUW5yiOf4uhjiUX2fvdh4iBryMFxaMQacj3f7PY74vwqVEwQKIXpnbWlqQ?=
 =?iso-8859-1?Q?0kPb8Edg0hFjIMII7eN8uR+eRv01nNl9HMIwbq+0BNUylS2O+YpjOT8h9f?=
 =?iso-8859-1?Q?XQA5wBEYd12N0WFEPVjbpx09OD/0SkQo8f7dJ+NMfe1hSmk59v6QajWKgE?=
 =?iso-8859-1?Q?OCf/r+30iiNF+/UJfnv7/6ZlGzz/2BfxgWQRhffQT1VNKZ2k85h9QQVnwU?=
 =?iso-8859-1?Q?Ww?=
x-ms-exchange-antispam-messagedata-1: lsLXEDIV/wpY0Q==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	aPn78Hw9R2LgVHHekO2vD7FWqamRPA9UwD9qncxUvSd9J+GFHVNs6ocje3MrhYJEewMuQTZd9aqTEW34z6cBcLnwCjVW9dRbTf55SJruiJL5R/yvz9TSc0hbLXTTogAdWoCFvlnTP8mRckO8sRC5r76zM4w+fDpOkOUW0jvtIeQtFzPooXnvxqJPaL9QVrmshxqDtNQquO+eYu8ZD2CFYDhtvibmI+L7b17VUVvs7rXfwkkSK3M+FGuwZyQqy1LAAYbsgMyTsxaHCbQgAzsLgwrW6G+EAWSMS00bAxAu3xJRGQJNCkwuE6ouFTxgqeQzbENPjvVLdRiJw/B2ngte9w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/zZVmXpMhUJ2g62JdKYEhL6NkbxSyFhqr+Z7viMrqGbE5BbIqx+j40F/t2D94Ph3uXUqjKIcRuOB998ec/7rtrlN0Jhe98HpxIub2lTj2wCrA6XiQj8XLdrK3LZLKPQXXf+3FY00YNOKKBJuMBnXnKPQ7eQoyjyPjyXOmIyrBXnrSbUPQMn4pMwug83NMl3PAuoDFmpa1D85Ynrq3jsz9fSC+nfBG+YHWXif9jSB4lIgXq8rUi1QfBq9wE210NdseW0ggz13hfE+vv0S0spjv7XVWbAH/euEuw+95AzscHzsOM5Sos9HYjYhDzE4T8Yv/QCW9uQYVQaHOOnzhVBidzeXqZ6UBPAV18FhT00tIELkOuXJT4+bDmhxGtG6kYG9oQYtf4JSbJtJS84UJROUSkSevJjWqL6pn1CdWKHylkCUd+z0tZxC20eaFFwAOhx9of8cCyBhgaA3fuXwdOBxkZC8u8Q4WfkOqxZ/qeZlxhhIWxDOWb3r/V4yYYt8or9Tx0NxzDgd+Yeevfpo8KKas5l13yHpJVA9faEg6NI4lgbqmneSzrx6egLCwYRh+oq0WzEa8O5tAtuB+kZqrLln8w6tNLuOHz2u5PlMTRBIilJBKUkUjg/ziikFhNlzLFtu/Q9etrlA3I/dwKKuYrDKV/xnhF4FxIQZYure7U1I+k4=
X-OriginatorOrg: linkedin.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV0SPRMB0026.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd89c8db-d4b1-45b2-f6c9-08dee43586ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2026 18:59:27.6779
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o1AvB+/BGnY1sDcnUKhWP8+8YZqvsItORnVYvVZBsdt6uuBYJLgCJidY6rJaV+is279Hy5bJBTfT3rbKEv4xSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR21MB6166

nft_parse_match() sizes the xt_entry_match buffer from the wire blob=0A=
length reported by the kernel:=0A=
=0A=
        m =3D xtables_calloc(1, sizeof(struct xt_entry_match) + mt_len);=0A=
        memcpy(&m->data, mt_info, mt_len);=0A=
=0A=
but selects the print/save/compare extension purely by name via=0A=
xtables_find_match(), which returns the highest supported revision. When=0A=
the kernel stored an older, smaller revision of the match, mt_len is=0A=
smaller than the resolved extension's userspacesize, and the print=0A=
callback -- and compare_matches(), which memcmp()s userspacesize bytes=0A=
-- read past the mt_len-sized allocation.=0A=
=0A=
For example a conntrack match stored as xt_conntrack_mtinfo1 (152 bytes)=0A=
is printed by the rev3 callback conntrack_dump(), which reads=0A=
xt_conntrack_mtinfo3 fields (info->origsrc_port_high at offset 154), two=0A=
bytes past the buffer. Listing such a ruleset with iptables-nft -L reads=0A=
out of bounds.=0A=
=0A=
Size the allocation to the resolved extension when its blob is larger,=0A=
just as nft_create_match() and __nft_create_target() already do, so the=0A=
print and compare paths stay in bounds. Matches whose stored blob is at=0A=
least as large as the extension are unaffected.=0A=
=0A=
Fixes: cdc78b1d6bd7 ("nft: convert rule into a command state structure")=0A=
Signed-off-by: Omkhar Arasaratnam <omkhar@linkedin.com>=0A=
---=0A=
 iptables/nft-ruleparse.c | 5 ++++-=0A=
 1 file changed, 4 insertions(+), 1 deletion(-)=0A=
=0A=
diff --git a/iptables/nft-ruleparse.c b/iptables/nft-ruleparse.c=0A=
index 26a605cf..2c5aa9ce 100644=0A=
--- a/iptables/nft-ruleparse.c=0A=
+++ b/iptables/nft-ruleparse.c=0A=
@@ -638,7 +638,10 @@ static void nft_parse_match(struct nft_xt_ctx *ctx, st=
ruct nftnl_expr *e)=0A=
                return;=0A=
        }=0A=
=0A=
-       m =3D xtables_calloc(1, sizeof(struct xt_entry_match) + mt_len);=0A=
+       /* Kernel blob may be smaller than the resolved extension (older=0A=
+        * revision); size to the extension so print/compare stay in bounds=
. */=0A=
+       m =3D xtables_calloc(1, sizeof(struct xt_entry_match) +=0A=
+                             (mt_len < match->size ? match->size : mt_len)=
);=0A=
        memcpy(&m->data, mt_info, mt_len);=0A=
        m->u.match_size =3D mt_len + XT_ALIGN(sizeof(struct xt_entry_match)=
);=0A=
        m->u.user.revision =3D nftnl_expr_get_u32(e, NFTNL_EXPR_TG_REV);=0A=
--=0A=
2.34.1=
