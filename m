Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2114.outbound.protection.outlook.com [40.107.21.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE765228
	for <netfilter-devel@vger.kernel.org>; Wed,  8 May 2024 14:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.21.114
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715177184; cv=fail; b=Q7HTMgizzBT8xm660+WtksTrJkZDBOx93SzoKI3tMRajpkbMkBWroAb1RhRAzwTpy456Eoxnx2nC4k/j7lvxOrI3OlbFEUvTm/Y4pJORCxPIgwj8brcEjo3c8sBhbCTkgAMRry9FbHJnU1uS/bqz3qr2LFIZcr7c8v/JmPzFzGw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715177184; c=relaxed/simple;
	bh=Np7itLAF17NmBfrK8AZx2oU7m8t19xk6D3x55PkFxyI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=O4Yuhd1Iy55FAhEZp9KYhE9i5HGiSKAEcfTVqWE+Fg3b4BCi4S5X/6gaoUXDbjRfAamegM8ze7f3ZRdXlaB1Rrvnq/+uqm6rcd7pm/GvdGnF0KMNaQuKcw7XRibMD1vBWHX1WD3ox5O+cTWANNPbYN8bkVxsu6E7yiD7G3CDCuM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de; spf=pass smtp.mailfrom=voleatech.de; dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b=I4LrEv9R; arc=fail smtp.client-ip=40.107.21.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=voleatech.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="I4LrEv9R"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EaxoEnA0EYSJJsdPvY0YmoNFAjP8UCdj3X1LIe5ltDcM5V79doilD+4xwwq5PWKydEav8/PfLOtm3HAEWaI/LsOvFKPorXsolY2YfhjklcFym1vEtfggq3alWs0ABBvXGuUSudeDKORa+GVCfahAB1D3VhQMDyUw73iCl70s/cAZwplIKLrDFrVrJWBZUQZ1PvUzzxQP46QP03XwgaVZEyS0xSviWFgIZzmt5PibqyRAxBomE5w2mY4PcOOjveIbeFipWeJ5e7J5vMQZzFaKp8dC7Zt3c1SW7MUUDB04vhLNLsxqeTIKFvSC8C+djEXeRsA60H0raPF7/dcjavXYcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UvNBQzJ4owr7OWXaKXsIFF//Rr9YenSuer9b4gUv3Ng=;
 b=D2oD6wWNFRtizWfc95Zqa/YTr+pPVDQ4/Qn7kodlkSBdgVO4wFxRPBUqTNey/LaiIrX8O1VQb+6LwMwXxUxYb0YpMtxhKj4ocozngOTiBCbI7xOM94PYNcnPtV7ZDbZX/E+TIfuzfRk/MhHxoSc6ryAcm9SaMNhxkDmKvNv6gZilxGuvTeleeckNYxKSmH+ChIYsKecjt44cjofB5uCWOB1xzNo1McSeqELm6lKu3XknN/jDgYjQPw/FxxKlFupfs5vO6nNN8NwmJTEQ0PK8XtrujnEtbrd86OSCHP80TJ1DyNcHIko8qRY0hz2oPUcynLtCfKXStL1yOUQZMPXYNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UvNBQzJ4owr7OWXaKXsIFF//Rr9YenSuer9b4gUv3Ng=;
 b=I4LrEv9RPRA1XXJKwkKc30fjz3Q3hJanxQx6s3ESoEZHemO4Jxm8pD8m+RWgrIFTROcQQoWcrfpTNsVdnII5D98eTIeBB3qdJ4BdEBqUKE0JiqETO+iUghwskJTaj1pou6CxaOUg7YKttLK4pFJaRpBo4uRmhcze8iX4J43n9PM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from DBBPR05MB11225.eurprd05.prod.outlook.com (2603:10a6:10:538::14)
 by DBBPR05MB11201.eurprd05.prod.outlook.com (2603:10a6:10:52a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42; Wed, 8 May
 2024 14:06:18 +0000
Received: from DBBPR05MB11225.eurprd05.prod.outlook.com
 ([fe80::eb7:22e6:e723:9086]) by DBBPR05MB11225.eurprd05.prod.outlook.com
 ([fe80::eb7:22e6:e723:9086%6]) with mapi id 15.20.7544.041; Wed, 8 May 2024
 14:06:18 +0000
Date: Wed, 8 May 2024 16:06:14 +0200
From: Sven Auhagen <sven.auhagen@voleatech.de>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: Could not process rule: Cannot allocate memory
Message-ID: <bogi4anaqeh5o7haif57udzf5k3bj73rcsqfpqpna4426y7cyo@lfsyzkb4m2xi>
References: <qfqcb3jgkeovcelauadxyxyg65ps32nndcdutwcjg55wpzywkr@vzgi3sh2izrw>
 <20240508121526.GA28190@breakpoint.cc>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240508121526.GA28190@breakpoint.cc>
X-ClientProxiedBy: FR4P281CA0078.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cd::7) To DBBPR05MB11225.eurprd05.prod.outlook.com
 (2603:10a6:10:538::14)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBPR05MB11225:EE_|DBBPR05MB11201:EE_
X-MS-Office365-Filtering-Correlation-Id: 9089a12d-5e5d-491f-e617-08dc6f680829
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ts98om2hCi/RJ7c8Am3wFbI1/hJC3NNmJQx5eiywZ4UkOgjxibYhjd0+m750?=
 =?us-ascii?Q?tOR0dJovnJDVo75rK/z52sPy5PE6sCSxA3jwG1DrBAzegnZs74GgEndGyB99?=
 =?us-ascii?Q?ZHht23I033oTjpLhpzwY5zOBVWEMiscWFTY2qvIwyxRbyk0QMX2DmvHXGfGJ?=
 =?us-ascii?Q?0lv9GiWaWXba3Z1YeIxZF8AJLupjj8/K6bIV37bapeoydV5NrxRPq6lvMW+R?=
 =?us-ascii?Q?F/DY1SF7qXzc1HXzdsgrtHUXUGX8cJjgtRoOsfkKrA/Q6xBgZTdGu+0SG7qu?=
 =?us-ascii?Q?24rirh8n+vjcbnYJTmGQLpbCDRPU+sjmGu5fB/uyl6SVdFQ2pTskTqvMfVge?=
 =?us-ascii?Q?/YMVWww3cZoM5eP45INaLc/CH7ocikn7YcoLTCLt/TaweQMzL3MGxtPuAk0y?=
 =?us-ascii?Q?PTfOGf4EROwsH84tXD7DGj/YBVaNtlAsnh8VasnUE5eB4ALo8AxESU6xx/wO?=
 =?us-ascii?Q?v2o8y2mS96dDmyKTXgnRCV2YLjGdU3v2WE1vqry/4Hok2nxINw+MIPK+Y+4R?=
 =?us-ascii?Q?5CmA1mkDKoF5HGJiRQx930PmBbDfKszKSmq8BQ5By861ANmKRXyFqKseKkpb?=
 =?us-ascii?Q?4rTqzH9K1e4PA6STOrluTryP4LOZsHK+XADwJHeD7ISr1tjQpSHrmUK4x3HH?=
 =?us-ascii?Q?MUM544nhFDux6uRAOpHB+h82i7AnqjeKK/CKurkelb5xPxFklC591xaIlSsx?=
 =?us-ascii?Q?qfEFfwsjYcyGWhoJlCeoEVVozbuxL+uxGFH+bJSeiRDQW36FIsi6vRHbLS08?=
 =?us-ascii?Q?MFcMUq2ptQEIp+TxU+41gFL0vgFoDrQrHKCpjRuoodueQb/ymfxpcn+v38gj?=
 =?us-ascii?Q?/adYv2xGDXYCpa3Tl2l9wfTjO4fNa5xNmsBVuhazPVr8HLjP3x1xo0yHY9dP?=
 =?us-ascii?Q?AkDm+J1Yptq8kyggHlnSeWwQXO5wGymcg8IAZoFkXezxy8VTWapaZZ9Ez7pl?=
 =?us-ascii?Q?fGE5XFTqrs2fHFKhwun6s6CX4H3HyZbtJIIvP07TkteC247g7EU52j40u87e?=
 =?us-ascii?Q?A77GK2GmkoMkKCNdQ/qDCw003fw0neHkyuwy1gZW3uObS1MpA5Y+t4+njfvM?=
 =?us-ascii?Q?d3y3m+P7vbqLWRJgBHJ5VOz0sazHZNCvtJlczgG1QaMlAJq6Yz78Rnc0jqkM?=
 =?us-ascii?Q?u992L++tCZ0ripFMPrLSVIo6Lm1yvs9ktVN38MQG5l5tYLK+4wMSDzbD+4ki?=
 =?us-ascii?Q?DEXOQ9iiHcU6GBlUjc2+5AuqyAQ9CJZdPMAemEAUaWzeREMMzWekuipO2Vta?=
 =?us-ascii?Q?LRxVqzv2WAdlva61TWFaN+zgiK6vGxWD8M0Rs/XTuQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR05MB11225.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?C2LUs0ZLN3A7ohqFobj822WP/zs9oSMyUiTVKvQ5Y+6I8lZbv4HohTnS/Dyh?=
 =?us-ascii?Q?bqpNm6282tZjVWUtt2/TnvpNf0TKTm/PKPJ5FDWrMiCHPoXEPn7PnW0AG2eM?=
 =?us-ascii?Q?fC4VnLsPLuesdbfXWlSPuImVQ0wyi0OSIFnO3bc/CigIGnh4PYuHpRUj6enN?=
 =?us-ascii?Q?0H7IsWsk0DGoD00RnTDFD7oxrOwsVQD4KDQclSsfrd5EHKDgOKyvDl+4i6RT?=
 =?us-ascii?Q?dz7S2xcdmYw3K8fDUv8xloi9ecHO/8vztieYM9agDHbUBEKhx6HZ2AszRP+q?=
 =?us-ascii?Q?E+m+rshKWbCO02EVwQPe7CVts9hRW0aHPDm7N25y+9QTe+k0PELMq0rgRZES?=
 =?us-ascii?Q?K1dCmQy+1GrfFyVSYaJ5uTVEjbmRRaQd4VVTjKKliPnoIvii0ecXT2EWUxpM?=
 =?us-ascii?Q?BwKXD7x6rumo0x56JYkcsKUAgtcOMbdcagOmP6KWzBzrqX9HsCBn1lu3DjXp?=
 =?us-ascii?Q?UVxGiEstk5JyOO2atqMOuTbDnRGKcungiwZTH8Y+MkPf2D/h12FvLwU17y/f?=
 =?us-ascii?Q?4qJMA6f2AbEmVORXNFtiQiQ0rOmLwN+91ZF8IRwixMGJdB9y3OFyn4+9aDqF?=
 =?us-ascii?Q?P6AezgEL5ExjHcQM4ukTKHhSiPFGHEHGLS5OfBTB1YBywTv7mp3Grvnj+ZX0?=
 =?us-ascii?Q?EpvQNBE/Mzp/QBt5TIbdvLLTMkXlwTuQszT78BpWuIgKVA/wFCyWjhB6bp7P?=
 =?us-ascii?Q?6hdwYErU1xqIYaGSkmNWVGh/ug/P78cjVpCVVkeo48yXZyKOngcXJKLilNJt?=
 =?us-ascii?Q?HnuLpfZWx1Kl3uL7aqz6Os6zDHyXL+AqZg+K5tU7SSYEmZdneKNO6BLxYFjb?=
 =?us-ascii?Q?hlYnEH8Vd9U/BsEHcFXSg6CSwxPga+CfeN5hJBfRiTHCJ3xpHbXFLXjvPYAF?=
 =?us-ascii?Q?SzkqzDiOZ8bblmEYI/3mStCqTfTXLxQlza601j31jr0A97+yf3PNX+bf+ebU?=
 =?us-ascii?Q?jNPN11iJXRJjMd3hTymm/PrK2OnqpWw7s+xGBZAJFchM5xb8kyziqkAPWLeu?=
 =?us-ascii?Q?IOCsch51A1PgPC5o9AeRJ2SLHDFTYgxIRIbZ83NroFYD0Ti2ETCJkjgbpcs1?=
 =?us-ascii?Q?7oHQuXQOV4+zPNaZS35YkFsBUGzIrB+C9pFfc2dqJXTMTpo0xi6MyP4btK4O?=
 =?us-ascii?Q?yleneD8Y3DtkYMtrr5F4J4TAyx858Bv+JetBtdCTXO+GyqO7ccXu5Gnr045u?=
 =?us-ascii?Q?htrFWtGOkZ1XRhTiv/VZE9BUSWlrErhIxniYFmvJ3BcbGQ4i05JUop4zQwv8?=
 =?us-ascii?Q?SUnBEglWuLgwjIc8Ill2AsfWjB38cKj9NvgxVrNW9OcnuEXDuzZbnqhm2HNF?=
 =?us-ascii?Q?OTFOhKTJQ6BhsJ4J1maWTF+Hn4L71KDJpwwrEfb2+otRqne+dL+4h8PxoD58?=
 =?us-ascii?Q?2rbmrrYQX1nYCB+uBgjQ/3bFjXqeDex4M1QJMXEzIiEBxV8UDOvN9tY/Obdu?=
 =?us-ascii?Q?xv4eJH67lwFswlaj69Zvy/KDTIK9brBUIDx18ozR9ueYj6tbELxoZuGRUQuT?=
 =?us-ascii?Q?XakSBXfwK7mWYM3y1DjId1drzW8tXGMNmPsWdUVDkE0692ncjBSjtreIirt2?=
 =?us-ascii?Q?g6Tv5UxgWk/9uJZ7wG6kANdsR8EbroBvoh16GFdEYWIrEGY1pk0wdzuKW244?=
 =?us-ascii?Q?ow=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 9089a12d-5e5d-491f-e617-08dc6f680829
X-MS-Exchange-CrossTenant-AuthSource: DBBPR05MB11225.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 14:06:18.4913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HOZU2cx4gqf4MrT/vnB5WSNRlt00QSnI22u4dfQU3p8WJ5RL7IN5FsF6s90mMZBxGQ5PTCEiHCX9I+wrgR9Bx84nxf3gSQSnBx8romoVcp8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR05MB11201

On Wed, May 08, 2024 at 02:15:26PM +0200, Florian Westphal wrote:
> Sven Auhagen <sven.auhagen@voleatech.de> wrote:
> > I am using nftables with geoip sets.
> > When I have larger sets in my ruleset and I want to atomically update the entire ruleset, I start with
> > destroy table inet filter and then continue with my new ruleset.
> > 
> > When the sets are larger I now always get an error:
> > ./main.nft:13:1-26: Error: Could not process rule: Cannot allocate memory
> > destroy table inet filter
> > ^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> > along with the kernel message
> > percpu: allocation failed, size=16 align=8 atomic=1, atomic alloc failed, no space left
> 
> Are you using 'counter' extension on the set definition?

Yes I do and I just tested it, when I remove the counter it works without issues.

> 
> Could yo usahre a minimal reproducer? You can omit the actual
> elements, its easy to autogen that.

I just saw your patch, do you still want me to send a reproducer?

> 
