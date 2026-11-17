Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794929087;
	b=pAllqU2GmT+Ox0LfeKvyQmqd/5gmW0vz710GrG7qulYZfOLLSSH6RLU9Qwef4RPJVuBn
	 vHDjtcCu38wtLkP+lZH3mGQIGJgUR9qg58MwPwDsEyC4kYVv3fP2QMkN47gm5oPD1f7wV
	 cXKkRqUX8rdL7O9Esnxmz9hdHIrH5rcM7BTTUFzS/ZHxIBySdSArSgdsrX6ckQvp4/239
	 PX/6/Y+FA3PvJD/QD3G5pijDXcr4j4OE61+ERbaJBQtLRnXOLgeVspEtrwnO2aU/R2v2p
	 TgUFJ1IYCE8tB6RW+ty3Hab2P2pa4I8pwB2yFKecd0LbGcGy0zixLueuH7j81l5ViUA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794929087;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=JKMNXsHhSdG5Tayc+NAwWSGYY99eRnwTfy1Rt07lgXE=;
	b=hPoff2SW/803sbxAZK9Ez9qoVWt96v58ufmsOHFaxhNTFkqL+ZNocCjEPfKuPQ708Adf
	 5KmulFoxzrtKE9i+Z0C3onlM786zC2xu13Amutzr1Wv0jUOBVbICOlE+8CXa1/iGB9l/h
	 YNHp/n003ghJQln+KkPU5UaeSbhWt8xWLI/BJnZQW/s8V18ursRVUjsWztiZ3PNs/Rsyx
	 PhunR2vXiU4a/HSDJQ7ZjHI7J/ZFMofrpTS/yQQchOoAWpggZY2+e1Zy/sa2eM3VFtLBB
	 mDBoV4U3ZZJ/yQ1NiasNukoqOMfOfREwI3DFYfmAqAPw9mnjE74YMlqSyN5ighAiadw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=reAgcCae;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.50
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011050.outbound.protection.outlook.com [52.101.62.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E97F606A31C;
	Tue, 17 Nov 2026 15:24:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E97F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=reAgcCae
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u1hBvx57eItwstIVJcxSeJScnF8IKcqNeC3FhpQvfSUSjK7mlRrej+K19dBEISFV7rnrg6NXvWsVEtiy2i5JlEA8T3pryitWTG2ZCbJTYgwEVG//Fv9021HWAsT7EPY62c/vKElVK6qyyR4uwfyXYl2cmc+5lFeCXICqFGHZxo7aCC6vdw59GXtpgH/VEip7UfXXP8EsuUsGFRiX0NPBpDUVWqS646F+GG2DCvLw/j+PUWNspldYRHKEKl50O9LA/f6zgACwjivIuxVj2B1JR4UGvbU4O6pGUE4vaJ75Ly8h7xJTtKgXdVZu72ARsfTrVZpfUHAqgB6EDVZ2s6fbxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JKMNXsHhSdG5Tayc+NAwWSGYY99eRnwTfy1Rt07lgXE=;
 b=CbJiVYx9mGJ/1tLOQHhRcQCVcosHxWZ+eDwg9OTMsAhwChCG0lDSbjj/kQXJlJGvNdzhsaN0VRDf2JFYTtsi1HWwTvZwN0wZPIFqd5nuiBOKXIYDhE9HFo1XRufybSGR8oNB+IvaciC/Uu2lcUAa2eXnGe0XG7jAkE/ZzyHaoMhp98F5OJ7zSZiYwX/3tV3AGhB54wrYprp9MpYX6kXzklzJSEmBI7936pwQiTh8x1s1rbHn1nDIYGFKHNX/wsvkisEpF8KW8T4Bx8mlXta2Lu3AilOJimWLuvo/ziBdra7iBL2vXh5t72diltKsIZwLZ+427pn7snkAq0fFaXOQyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JKMNXsHhSdG5Tayc+NAwWSGYY99eRnwTfy1Rt07lgXE=;
 b=reAgcCaenoqAj61bMIdQGpGf9P0/KoY9vn0mc8OecSgK/mQOcKOyPgHe6YMNW0D/HGmnFsgeqLSp3YLxd7Hfx+ksRCUDu9aSiS/fkHGFYWJRTUHKZAbPeKs/SgKXWYZdIJCOmXmSHUkAXICOw+1xQuYgu+CdBXmM5sXIME+K8xCqbrlZUDfDarE2R92Ytq7E49DNReu/bdgkqpVg7ADgxXaTBdiQOLRBVvgUVScgKZIYn9F5aCzaoug4tP4iHU2gUXYZdahHSDgpKts4Fx2agWoSzpVHbb1RzwD5jrNyhsE3A0ZYA3Jr7pLAiVLH21Fl3BHEeJnIULIySnHuFuxsbQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9407.namprd12.prod.outlook.com (2603:10b6:408:1f9::13)
 by DS6PR12MB039703.namprd12.prod.outlook.com (2603:10b6:8:4f6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 15:24:23 +0000
Received: from LV8PR12MB9407.namprd12.prod.outlook.com
 ([fe80::208b:424e:47e9:8a96]) by LV8PR12MB9407.namprd12.prod.outlook.com
 ([fe80::208b:424e:47e9:8a96%4]) with mapi id 15.21.0615.009; Tue, 17 Nov 2026
 15:24:23 +0000
Date: Tue, 17 Nov 2026 17:24:14 +0200
From: Ido Schimmel <idosch@nvidia.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Leonard Lausen <leonard@lausen.nl>, netdev@vger.kernel.org,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>, Shuah Khan <shuah@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v4 0/2] ipv6: Honor suppress_prefixlength in
 fib6_lookup()
Message-ID: <20261117152414.GA824125@shredder>
References: <20261117110813.9894-2-leonard@lausen.nl>
 <avxPFYfEirXzTup8@chamomile>
 <94f4ea0e-c1bf-467c-94be-b65963410d30@lausen.nl>
 <avxRfzsnke7VJq_w@chamomile>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avxRfzsnke7VJq_w@chamomile>
X-ClientProxiedBy: TLZP290CA0010.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:9::9)
 To LV8PR12MB9407.namprd12.prod.outlook.com (2603:10b6:408:1f9::13)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9407:EE_|DS6PR12MB039703:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b276c35-b411-468e-2a33-08df44bedbd1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|18002099003|22082099003|261009223027099003|4143699003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	PWXupoXPQZNtTmFld8a0x24NzV0qZrbvqnbEMXt0n9R6W7RU7PB55cZPhdgs9rndoM0JTIEe/2DrnAhal9TEIaKUYXX9P6vfIgLjWHgIvh1OUvrttg0DcwKEHQDq33HYQzx3hCImRix68pDKM4trHCB6KwT2q9Hy7b3aJunzuk6i5f4WryUmnBusygGWdVaav8AgISuW0ozq5PdiATiNImA/ug1D2x0AAswrKKr/jwwbCIHkKVEq194dqhoEEC6hdIAXgKOH69jNnBQVIfXRqHjfI0SDLvpY/rUQfm/uuftBtP5YxvS+fAiGgMb+kY6Ve9zI6pCKW+pqf7fySnwXwREzCNmHZAN71w4Zxv7D8lpb6QEl/xo+ea+L8rZBR7EHW8onEAdQC4FNN1Pxu6gok2PTx81/MAO/pMoyQm1XGmMG5oPkMJyGy+GL5iM2IsZrK8v8pdNW3xxStfDKYNi0F4eMBSYHLL22UMHhp3zqRihjVqM8abeHeX88qOXDRJo0MC5R0J8LgMCtMplAntavSup1GrbTmM7ydpM3QkVXmWxsaWGo8AumKWebParjIVhEXvO09rRn28NiwTAYxf+UD6QOMz+UfFH71XI1H8mIXy88V4FXUJ/wQYU17Xm1sWsmeaW3m4FjMjbvH+lotGM35knHCu86PbaGaUr4P3DqWRw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9407.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(18002099003)(22082099003)(261009223027099003)(4143699003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?74ZVabBkIyc7ZL99qwLCEh3b68K82OWi1pe5UPiDgPXZnswY2y+R0guuTclR?=
 =?us-ascii?Q?bosNjghVJHRzWFjZfcOBnDtwG2yWPWA/ZKtqACwhCMKW8J6HoD2C7DMGpy78?=
 =?us-ascii?Q?UyFKPHXfbPQ/I6KKHugwLfpXcETZ9sJqClbidOJJ3+gbnN4rljk91Hxf6L2W?=
 =?us-ascii?Q?CWPmKW7+sRg9enDh7Yl7/vYVmoKoyXq8XKhs8G1WhLxX0IT4mtQcidHxdH+0?=
 =?us-ascii?Q?w2NsyYCUJpGNF//a/RUFBvN7Y3n/CHbbrzSi97voxX3QpJ2z8/htwO/c+DsY?=
 =?us-ascii?Q?ZYOdMRUejMssfkdO/tJCfHQomL4e00DgD2N7tOPoxlRIlh48HKMj6oS992CD?=
 =?us-ascii?Q?QiTdXHyH/6kV5sWd4YewW2PclZEquQ3PsAB4gow1NmogDcDicSGCTzVFTUf8?=
 =?us-ascii?Q?n9DTh1leOI7QbYECDeFPD9PZxeoI1uhKYc/NtksSAtidjVjw2xf2QJuFvq0u?=
 =?us-ascii?Q?o1IiYE3hpvkxhObLv2c6921RUirehX08axWYmlU8OwnCbb3mSnkhfrFJNekC?=
 =?us-ascii?Q?QMQ7Hai26ndkc8ci7S80IIW3tNISHQJjkT9E6jOQ2mPnJB/B+l9SUiQqGRY3?=
 =?us-ascii?Q?jL/EFuQ2lMw2Fg0fTjuIiZ+1u+tCu6HVvwUC0BnxpilL/hCvqUN+5cXixDob?=
 =?us-ascii?Q?dHOjyDdNzpqDTvaiqKasxXnn2Hjn4CxbeSlSwLryLJrM6wJDwb8kbVpOMGkZ?=
 =?us-ascii?Q?yZ19QtAAbRNQDwfFn5dJzFLzah7u4HDfk+nVUCNAn1xUSy6DeMOIvzOSb0yH?=
 =?us-ascii?Q?0+LQl56+2Rx7sK2qGuH1BvYkOyus0RuvNhVR7jOoV5+jvsjiP4mlMpt1cJzX?=
 =?us-ascii?Q?rbvA0Fo0DFCaUFpwwrUGbmmGvcdbCam3t+oXrDNVk1XOiKPnb6DwGyaFqxr4?=
 =?us-ascii?Q?tI0VF5jIdxJbQ4WkHxGO+wyBnXnmMBCfe/KYzV07flHzHAP6f2uW2Hjz815J?=
 =?us-ascii?Q?hQPR6fayfxeFi72Jq1U5zap0kDnu8emAETNaMSF97nG98LznWVrNB2uynZhh?=
 =?us-ascii?Q?buXa873r1syEcFkiwim66EIV+Vcla+fVR+7zhVdF9YdqaLCEkgE9hQUWX++A?=
 =?us-ascii?Q?XJhvoS2uXwRaojRuyXNKrjeHVunNnGkI0iCj13YxPLlP5EOgX7CdfjV198/K?=
 =?us-ascii?Q?upK9yOhMvLfYFlTrGyGtKS6bHIKJOHSrU5ZcpIn7X6x83dj+Fakhh/stYXbc?=
 =?us-ascii?Q?p+0ort3fFXDVTVq00cumHNI3F5Bnbr/bdwFWP+H9nLJSqm5fdmwNGo7ln3iI?=
 =?us-ascii?Q?mMN0sQLCM4giCYhl5+LcnIbekfrqrq6u9YFoGHOXp43sVr1xcgUqSe+nkh+X?=
 =?us-ascii?Q?k75WxmDMRvn63tFzHFOmwhvi50I+u/V5VSrLNxG1LR6VBkKBSi5tQ6papKeL?=
 =?us-ascii?Q?uPeqsWo3jKcGBWJj35eA3mA3HCibt5XZqG+g8bgaYQ59sZai/jVvtLCz1lW5?=
 =?us-ascii?Q?xilfkziUyE2GNLGbPJbSJbRSHR42prL4IhH7ea8da9ulGNz7UJ15bgWHZ0od?=
 =?us-ascii?Q?Konh3q3Luxlvu73KztnF00Fhp7Zr1RWV08vIYjQ1gyylJY55wtyscTm9VpgM?=
 =?us-ascii?Q?wPX5dpb7c7QNbjpvw8+HYQqkn6L1/whD+PYcWz1cnHH9wsi8cFThk5mUjhxK?=
 =?us-ascii?Q?uwbGPJVjQI8BMoWxU1f60RQJ3XaPhB0NOnhRiBe/d5GDSmx02Hl7KN/HZuL+?=
 =?us-ascii?Q?N519ieH7btfw3OzBGoFm7cedYvSolHb/JjYjjKTgslksiIVz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b276c35-b411-468e-2a33-08df44bedbd1
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9407.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 15:24:23.3822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dDK3xvFMYhJTRLKLHWXjFfam9zwrQk+ZKJvE/mVuK2f/R19HPt84u617duU/S2Du5vm+crY8b5QE2Qp6Ans/Xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS6PR12MB039703

On Tue, Nov 17, 2026 at 02:07:11PM +0100, Pablo Neira Ayuso wrote:
> As Paolo suggests you explore fixing this from nft_fib itself,

Why?

fib6_lookup() is the IPv6 counterpart of fib_lookup() which is used by
nft_fib_ipv4. The fact that it's not working with
'suppress_prefixlength' is an oversight, which is being fixed here.

Also, it's not like ip6_route_lookup() is working correctly with
'suppress_prefixlength' either. See the exception bug mentioned here
[1]. Unlike the issue being fixed here, it's not a regression (always
broken) and will be handled in net-next.

[1] https://lore.kernel.org/netdev/20261115154639.GA4121811@shredder/
