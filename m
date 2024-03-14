Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2100.outbound.protection.outlook.com [40.107.15.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E0E5EE8A
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Mar 2024 07:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.15.100
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710402542; cv=fail; b=kTDeuYj7Hne4M/PWDawnmPpUjVFhi0mRSqxOlrhnZwuHWj4HxOUao6nBoK0EYnFXWjDDnf0JS9v/lokDJXqMzazcTlPWVf8FCglMGyA/on0l12govzNAPWvQ+1s6bzNxkS5/YPhFFOrNNQhjrhKp3PuELsExDBja2S+psNiYMas=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710402542; c=relaxed/simple;
	bh=nOCJN9qK+d9s2gHiAGITJW7gomS/wDQzFqTTPPQ+1nE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LPJC/QzRn0e7zfk02tjiJrP2hSfNPaeX76bvgoxltoixYBCAmGxKKlV4Eln/DFsCcTsjM1JZImPgtx2PM+W88dwUAeYyESvIJtzVCFaLi/o3PIBmpkl2Pa5KJ+nO2EIxtmK7JuBZ7Dbs0AG/eWFID+Jfalxde20euQGU0WFCUl8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de; spf=pass smtp.mailfrom=voleatech.de; dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b=OK1BocS3; arc=fail smtp.client-ip=40.107.15.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=voleatech.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="OK1BocS3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H0qTNEpxcGTUuJ83+1UZXp4ZJ6qAXsr+1kLG6OhP6Ftaa44cbZiuVOQb2xNrxZzxY4BMUlHDrBkJd9+ganRQMNAXcP5fmZELFTwoNi7b2EsxHbL27SdA2lOCODuwOBkjp+bA7KuRNGgUlwjf6jOmjsI10sHL66Izbbs0//g5Bfq6k8mvaCA8vkgqU7DFGn0YLCfmDfDjuv/bHxjKgHgQVMC0JPrtSQNwhLv8DzdyLwx2F4RdiWY4Kwq3gWQtAffER7RjD2SiT5xw18whcgvbUFVL0JOql0njurrKiSEaDYvNSk+zNEXAa5BkIdaElXYDnUMLO5T1MzV/PyANuIl55A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ANmr2oqfUjlmCiqKaPGfmDNBBISQyFDyqHvZ+cg11bw=;
 b=I/WdywRyO3fgMSuVMJG8SzcyPoYsLDpPx+UZo28sLBu7hf+xBSfyMRR7ifULjxj9tqdNZ7UIqntTSkms12pBKeqRLQRs/p/bF+3wDyabWtiwNpegErhRJKIi5j0jjVpgItW0hNTWD+k1duA3GaxsP+Om0Qxy24Zqb4oqKp48UE6Y000H6jgwXdsGphl8KlPJeQCLVfj5VmhIyabdpZ2Po1QLBW1LaT8f4eT1ZKyVe45JUGuAODcsR7uKhtLWdmulkqE4D/hnba4OUBZ0VZvl2JOcUOOh99UG3kr/xSDJvZ+apbL5uw36zYRTAW+iJhKz6FdPNn6wAFrjoEzYOGcIrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ANmr2oqfUjlmCiqKaPGfmDNBBISQyFDyqHvZ+cg11bw=;
 b=OK1BocS3eELnLMKdOOfd0Lp/wKvumhWCOaTa/Y/ePz2IpHR8FZe2MLxI3/zBT06j5f78Cfa/iR19siEEK4h886jbnLbXSMV/F+itekJPbTNJiyc4NAjMeY824M5qfo+zggTt6ranQjiUozRAzyoahaWCgZW9hOkdMzw9Ucb1a/0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13) by PAXPR05MB8543.eurprd05.prod.outlook.com
 (2603:10a6:102:1ab::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.21; Thu, 14 Mar
 2024 07:48:55 +0000
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b]) by GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b%2]) with mapi id 15.20.7362.019; Thu, 14 Mar 2024
 07:48:55 +0000
Date: Thu, 14 Mar 2024 08:48:51 +0100
From: Sven Auhagen <sven.auhagen@voleatech.de>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: Flowtable race condition error
Message-ID: <2rzv5gwtw3mp4hzndzb4sjtnibefs7sjcsychvm7vpoy5wetv2@ssrxj7cmi42b>
References: <x6s4ukl7gfgkcap6b56o6wv6oqanyjx4u7fj5ldnjqna7yp6lu@2pxdntq2pe5f>
 <20240313145557.GD2899@breakpoint.cc>
 <20240313150203.GE2899@breakpoint.cc>
 <yyi2e7vs4kojiadm7arndmxj5pzyrqqmjlge6j657nfr4hkv4y@einahmfi76rr>
 <20240313152528.GF2899@breakpoint.cc>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240313152528.GF2899@breakpoint.cc>
X-ClientProxiedBy: FR4P281CA0229.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e9::7) To GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GVXPR05MB11233:EE_|PAXPR05MB8543:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a74f653-2569-4cca-77ff-08dc43fb32e0
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2tLQBWKMAHO3Z1mwcyvpgYjO91PSyHguggilv/YcuTAhPiUUmnlQDtf54Zuw53RhA/i3WZBp3q7P1NkKKJIcv//UT4Qq1SAHKnc0GLisztavf6RBrVVqI7nmaC1QemPDffcjDO1I3AAQ74OJubPZU7jWKSupJrCMm7JtroJJpeYbKwpITdUOa8eUcbFDZocP7ad8fDEihWnz6cWjnvnhrzCx56gabPSPnr/sR7L5D1WguhjWh/spDH81GgxxXWsl/m/O3JB0pbQ7w1wd8BI7RqYSs31oz8zWvDLORqnO0T6b1mie3bwynyvUpT4+MZwCUgOt0yicyh9z9hKrRVgZX3/deF2++fWZzix1kuZxxKlrfgg/RHRpHahNg6wRurY3/yyEbb6n9i28frV3wsdh2Az9a5hNxVHenSIS9fiLixnbYvA2mpPHV2/5BQeYL1jGbZ2TSByIr4lv8Ngcy7xvVjxpySqjolvqny9LOTqwZD1RN4fiUvCNi13Nn3kG4RxQPZ7zq/VX10of5f2qd0Qn5KFNPRXHrcsYCFMFNWbt+uZKxu3UVGRzgoP7Ux4v+zsbD3M5sWiQHOFEbvlsCg81d+p4Pv9QfRPl7mihPXFHxs8pD63yR2zShSmFeMWnXnN2jlTbCDHkuA/lTvD7LJOmXP1YZMqnNsElEHhoUKy3pY0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR05MB11233.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SXXYTJw1BMeHBEJWB9qC6vBEBxAB0Nul/SJtHi+VFf9z47x1X3KleIMA6fAS?=
 =?us-ascii?Q?au4yVF+2IK3h2XFWbY7t3zgdF9WlzvNzD7OYohINa9lj6O6x72gMjbB3no41?=
 =?us-ascii?Q?sGqi2D/qgKsfNYFnmAi23n+dZXkR5vgSe6UKgwIWovUpoJgfqD8L3cLwljaZ?=
 =?us-ascii?Q?g7whnEgYPuHd4Aq6DyVRmlp+fLM2Jf00oFQX59BCSbuxR4Bx0WAj0YjKLJij?=
 =?us-ascii?Q?4fiE4IELyRT8CC9v2an09PS+Flxn8npesKBBi3UZ7tu2IQmKs39OJY9W6/C2?=
 =?us-ascii?Q?zfle84ddL/1mZWxpkwdV5VHDXRKPdN3YtAg+JN8z4DYJ5znt3VCRt9GmDclY?=
 =?us-ascii?Q?zUvAf9yGQ0Kyd88q7H2Qlt3ZVVCPHvxn7F7YPJB0ijnZUwxWXcZt/57MKJ6N?=
 =?us-ascii?Q?DM/j2/9MmKvAdNbRTcvWSBCeKSVVp1a+FQqKw24O406vNfYIOpqZFMW1fyUM?=
 =?us-ascii?Q?0bA37INM55C0ArgVgZI3sOd39s5ts9GtaJaHrQvTKHl6+M4qS5EzS8qmwf8g?=
 =?us-ascii?Q?tMGvWaAXK2JuxMm0DC+1bHTyNEFxTfvnCGQ8Sn5kPvRhxU6wTYL9xOWDLOi1?=
 =?us-ascii?Q?QTkGie97etV0FkxXvWXMZ40HVdAOS4JknpR+G7fpgMTT/6lMmzzpjqSg4ME2?=
 =?us-ascii?Q?YWUJ3epEI+GAKVDD96bbgpMV/ouKvQGQDag4SEvz6Eh6R7zT3fOx66Bdx6UM?=
 =?us-ascii?Q?gMWr2GBUmQGBjQ1r02t6aHNW2KATLo8IwtOZUQvYdHz/dH+uR/2KNR0ua7s0?=
 =?us-ascii?Q?/XbJnQo0UEgFBogWv1VvvS63swEoiCS3puVe6mceQi36tSwRPpeutg7dWW9J?=
 =?us-ascii?Q?9i20jzT6tKMpYhaijCYM0kAzAOThcWQ10Oma20pDc6Yu2MrhD6Fdtzoil3qg?=
 =?us-ascii?Q?vggJiACA6691v35MTB4JhNwN1WHR/YFtWAnmoDW+rjaQl679ZZyMJ+HLRFVQ?=
 =?us-ascii?Q?QmqLawuzKGfeS7dFMcya63gEemm4wN+5DHkh/o6EtJDe0UkfNAUuWoaxPXF6?=
 =?us-ascii?Q?t6QvkJnSrfxG8aqxG80ECg7kV02Q0D5EPIJ7BITy2H1+kIkI+LKuujTU0cJQ?=
 =?us-ascii?Q?DtFSFQx07D+6s5mdT7Ai2IgFBh3QUpL9uUAQ4cE9lZo5v2uJv7GqwOPlvNr4?=
 =?us-ascii?Q?4P/5z4ElNqF50Co0gtGvI+I1NO+HGfZ92JBtiHMEhZGVHAJufCGyAzBF0jEn?=
 =?us-ascii?Q?u1vBdQjjcMojR3C98ZmyUqE3gd+S9Uo1MYqgDnLphZXcRiJi/rogykeIUnYI?=
 =?us-ascii?Q?BL3R8dYk5ruB6JGcZtPS6G4cc50Tbah+4h7brFke+BO0nolqul3e6x5Mgt66?=
 =?us-ascii?Q?x8F89UB9gzdRV1eh3HMd0Ts+xh+S+b2MSy55zHpDQ4OaVtmbolT5TjiWGRLI?=
 =?us-ascii?Q?Oli9zyIvX0YDKlXrwmlcKYsZdaBNFTXQ4EA57ErYKU2kywcAhI2iXURlQMbw?=
 =?us-ascii?Q?NnG5rzCXekHMDb/xASuqhY1Hvec9f3kcC/1+gwF6fXXlGKgGuziTRe8J0yds?=
 =?us-ascii?Q?DFEH1GDD6fTR6VvXOLHGLu/q1q9LjgZzXVEw8+usJjCsTUsDa4BR889uy955?=
 =?us-ascii?Q?o3Asq9RCDI1WLkXfA5BdfBkEtuwKw7YffMBzca15SAl+wBPMFlspXJo0m/gt?=
 =?us-ascii?Q?Xw=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a74f653-2569-4cca-77ff-08dc43fb32e0
X-MS-Exchange-CrossTenant-AuthSource: GVXPR05MB11233.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2024 07:48:55.1119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L12r7/6p/+EYmwRl789vt/QR86+TuPKUoRtsCAElY7a378CLExEdL7JfDs0EC76kTXZEmHsY6JmVF9YH7kDhdVbVHyt+dufMOFBeWcn8Sp4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR05MB8543

On Wed, Mar 13, 2024 at 04:25:28PM +0100, Florian Westphal wrote:
> Sven Auhagen <sven.auhagen@voleatech.de> wrote:
> > On Wed, Mar 13, 2024 at 04:02:03PM +0100, Florian Westphal wrote:
> > > Florian Westphal <fw@strlen.de> wrote:
> > > > No idea, but it was intentional, see
> > > > b6f27d322a0a ("netfilter: nf_flow_table: tear down TCP flows if RST or FIN was seen")
> > > 
> > > Maybe:
> > > 
> > > diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> > > --- a/net/netfilter/nf_flow_table_ip.c
> > > +++ b/net/netfilter/nf_flow_table_ip.c
> > > @@ -28,10 +28,8 @@ static int nf_flow_state_check(struct flow_offload *flow, int proto,
> > >  		return 0;
> > >  
> > >  	tcph = (void *)(skb_network_header(skb) + thoff);
> > > -	if (unlikely(tcph->fin || tcph->rst)) {
> > > -		flow_offload_teardown(flow);
> > > +	if (unlikely(tcph->fin || tcph->rst))
> > >  		return -1;
> > > -	}
> > >  
> > >  	return 0;
> > >  }
> > > 
> > > ?
> > > 
> > > This will let gc step clean the entry from the flowtable.
> > Thanks for your answer.
> > 
> > I double checked and the problem is that the timeout in flow_offload_fixup_ct is set to a very small value
> > and the state is deleted immediately afterwards.
> 
> but from where is the call to flow_offload_fixup_ct() made?
> 
> I don't think tearing down the flowtable entry on first fin or rst makes
> any sense, its racy by design.

I tested your patch but that leads to other problems.
The ct gc relies on the fact that the flowtable code is setting
the ct timeout to a high value so it is not removed.
With your patch the state for TCP is going into CLOSE while
still beeing offloaded and eventuelly beeing destroyed while
still offloaded. So now bad things happen during flowtable gc
we are accessing the state in there and it has been destroyed already.

So either we need to make the ct gc aware of the offload flag or
need to keep the call to flow_offload_teardown.

Any thoughts?


