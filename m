Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2132.outbound.protection.outlook.com [40.107.241.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0C66EB4B
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Mar 2024 13:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.241.132
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710424581; cv=fail; b=b7c696F3bJr2xozNGve2fghBlqSFl1B2oAefvtrlCF8/Xvj26RMU6EmK2Q+2n6ZhqR22j13Kiwi2K503marXtJDgms4cb82hfPVJsgCpc2ySW107GQiKk2/Yipr9oIgnozS3d9tndFxRD4vxx4kvfXc05l+xq5hrtJESinOfVoU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710424581; c=relaxed/simple;
	bh=PGZzpe409gvEUtm980bC8FrkyGZHSsLXkJhWQIAAQv4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZRCYbtkTSlgfLSF1L+HCn07dZfjxtzNxXLrfWEtgjZfUo2IZelL+ObR4LHXVspByqogWk05BxHjfJ0BMbqTF5leR3ABxJT7O9FSCQcAQ7XkAW4aGPO5L1N809LZTeElIdPfwLAdlp2wPG+OPSwSMB4ZD4YALA6sFdw2gzIuvHj8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de; spf=pass smtp.mailfrom=voleatech.de; dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b=eGuxpq9m; arc=fail smtp.client-ip=40.107.241.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=voleatech.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="eGuxpq9m"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m1Nf7jbrzyZ1BPeRI2vaI1adBdjPIG1RDPXZpw91b4BChpTQTnYNYPlOw9vP9kPK63CDSjO2y6XQFqi4uB9V+uxB9TuefJS6KSewRA4bQjpbKd4YnjgcBE/7y0YYnrk8F9rTdIuuI0I7Xo95nBvi05fEtoSPiXNCWasAEr8ZqE5+mFVIGxSGIGwB9jQrUrDiQJEih+sXMbBV2WEehITzSp2N/z6Va8bgtac4Ceq+YdbKZgdV3JccVqFD7QSwk6UDkjWC3O993H+wSogFtb0TJ2tMSXFc1Od7U6abSvuUK8DBAXGRmsFZPIJtML97lGJyxgtCNkCa9wEYa9H25yZyig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yyJixYf1pR8NUKIes965ituDNvQ+J+ABSFo+cuCyewE=;
 b=j09nWVjgJAnj/Ct16PTJ7vWGqpBfwtMsxxDrNP7enoCjE8/32CKCovlJuvVabj6JA+Z6w+V+U18l82DLm+t8nYzOvrCxpocIp5iLH6CFy6LRNshzk7KY28vP5IPEXPHGCuTICqIekdBQdYiiGnK36Q0onGAxKlO+nratvNNVta3OJWLJs4WqkO5yuKaoF0J//m+x0zzTNSRwyOaDOI7LWSclpnEU2yupPlee+PcbHnmN2IutE4ymmsplQpcvcyb12gHabcixuPzGhGUeUdocvbXNZXp3Hy1jn8fv3dqStmzbsLA3v6jd+UuzMohf1wsSO8djQylRQfp7Q1mufcqD6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yyJixYf1pR8NUKIes965ituDNvQ+J+ABSFo+cuCyewE=;
 b=eGuxpq9mdlxmVLonBPR7UBIgePNCzWCe2d7VVGZBpAliMhf8zEHw8/mt2UxAG4IUBE5Q38MtkakBpTN8958QURddwGX5dzOZr6/QuZgrWuTS7YUxvgDDmfLu5Ax3x3Lf8/m5bGvZ7talmcyco77gacqjMvk+N5vr8FIpcdSMaZs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13) by DU0PR05MB9333.eurprd05.prod.outlook.com
 (2603:10a6:10:35d::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.19; Thu, 14 Mar
 2024 13:56:14 +0000
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b]) by GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b%2]) with mapi id 15.20.7362.019; Thu, 14 Mar 2024
 13:56:14 +0000
Date: Thu, 14 Mar 2024 14:56:09 +0100
From: Sven Auhagen <sven.auhagen@voleatech.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: Flowtable race condition error
Message-ID: <b4njfcasd5hgwlpggiqnwrldimymcogwhvjfbmzvdrneyxotzs@74k2hyddhemo>
References: <x6s4ukl7gfgkcap6b56o6wv6oqanyjx4u7fj5ldnjqna7yp6lu@2pxdntq2pe5f>
 <ZfLc33WgQPKdv2vG@calendula>
 <2lv2ycmvwqpzw2etorhz32oxxnzgnpmi7g7ykm3z5c2cnqcilk@zmixunfs4sjz>
 <ZfLv3iQk--ddRsk2@calendula>
 <4tq2bj2nylpqkkqep2v47dnb3nfismzbdzv42jj2ksdll4figl@scwfgkdwyuks>
 <ZfLz7NEwUnY_BEYZ@calendula>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfLz7NEwUnY_BEYZ@calendula>
X-ClientProxiedBy: FR4P281CA0410.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d0::15) To GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GVXPR05MB11233:EE_|DU0PR05MB9333:EE_
X-MS-Office365-Filtering-Correlation-Id: 45aba781-8c6f-4858-27e0-08dc442e82fe
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	l42MjMR6fRNTmYxwikU7SRLjWPy1uGlp1walcHzn4HrIhcPI2CTetDOlCidlO6MZlvM8/b8OA2huobwmlcWW22A41gGSzoU0Q9qrVKGlCCV84SjRCqegKc2u+QAA1E/T0DJ/8wKvdaFKpmIR7TCcnRggeC5J5kq49Ubn1XhhyUfFpbsZuKIV5zLMZc+EaE7zRZg315lMWwnJmYgTRwG5sbI7QBUcJgMHCFBP52wXGVQ+WASmdQCybtFp1QlbG2o+J4VWxSNLh3xBjpo2Hlt4ObKtH0/p+uWbjUR882AL5ezLqx3/X5YI2TYfPt+qP2Q+7fZ/vk+wvc3TIrL4s9AtP3pktFd6+7kYZ9EUq4IpK6iozmw/a6FecuqTvkQT2uDkiy+KMq3nTuGQIc1KHvuUwYronDzDWI5QMKKNxUXLRgwrScv8O6IluhuLOFqxcKjGPO48u9B1qLsj9pvxV8oA1e38/Bzy23GFMVv8XIaSVMI6c4RRKgA5YUneI9Ye0krU/AME8DKvatAnc6rJAzSMabBRqaYPBg+vqpRNCe/lesx38x7wqOqxe+juhQcVp5w8dwXbk2MbFRUEca8xTfEdMRrdCJtBzVzvTtesxqAPgBsUyXA7fLavahmleAIXZbceeoUXOGEt05eKWDlBn7LRF2HrSsDAYXIz8Gsc+R2R/pA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR05MB11233.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lowSdr1C420kIPlE+8WGjdVEpUrmzGuCRUrpWa4Y4GPP/bX+fsWkRq4KE2X9?=
 =?us-ascii?Q?LDNG9FFJFWbMTngH5eBg6jyj4hhoowYs/wsThFUTQSGnGNa8I0IzpI8OCs2O?=
 =?us-ascii?Q?gDVWW9mhQwRf/0MRFAXXYylbpO9BzJcZrzPZcqWGIBSiOpwsuSYcVuXZF8F+?=
 =?us-ascii?Q?VKCVnInFbbV+/csJ3kKXkfWS/J5IqI2zpY+RHB+8cFfVo2jO3z8h9Q2v+1A2?=
 =?us-ascii?Q?JRTCJ4uTW4oz6LYEg1I3WGOso8ou6wFlfUgCuicwKR744xncXtIsI101XOC2?=
 =?us-ascii?Q?eOrAkdO9MjiM9TNoLrIzw+szSBEscRCbrCmGFmCMRFzhVuTMVYRdc+8q/aC0?=
 =?us-ascii?Q?hGFFSptyDuBOs57+lbtnkOwBc4tsJY+6T+hcgUSXx2zz4uy3mCS276iEpR+B?=
 =?us-ascii?Q?9P5Hson2VbAgm1FjW4V4G87keQhvqQ0Am/krA6mNdtRgyvwkX6a63WeU28k/?=
 =?us-ascii?Q?2JSXe/iDPN+Jw7UXFZuFF1l9kOdJNpFQ+1utvQBM43JNGakDRETcUOu5K1yl?=
 =?us-ascii?Q?VzfTUOb1Wh1L8eOhYZ8kk7+0vTmDSZBduY6nJQjqa0S4RH7XxPisJRYdWh9e?=
 =?us-ascii?Q?mO3kXyULTq1M0w/yNgapeTxaK2YU7gn7+y23IalHV/BO8IcaI7dpvkhs1/RS?=
 =?us-ascii?Q?/UgaeiQWj6rpiUT4sUZZ0hNG6+5DGmz57IjKn2tcBmqlP/O1bShAnOEYSzYg?=
 =?us-ascii?Q?IGmtjQeRMofdKDcCSQA2KcTzgBWKLUAR8Jm68EUmSeD5A2QU4q6xWaqZatnX?=
 =?us-ascii?Q?fo+FrPeflfpgESaSgyP9cLmEMJUjAreDXohM+76WFXbOVGOk6/1cQyy7re4I?=
 =?us-ascii?Q?jMor+2MLAQunWS38I8DkwepxSonVP3nqQC9/y7U/dbj3q4a0rONhmIRqxWtL?=
 =?us-ascii?Q?kosGKnCogy+HR9JD98zb2PWD3FQv+5vamIMlrgmfaRelJwGf0oI4ka9F9bU0?=
 =?us-ascii?Q?absb5zCByQc31Mb4P7I5uBJDFogzCxLszumGQVvgC2HtEIYxXYtzJf9zGTSY?=
 =?us-ascii?Q?Y4hfD97xOnoFE7kFTm5s+JcGVTez+LssVuhY7pelQn28gCRYS0pL7RHxN+kw?=
 =?us-ascii?Q?P0urKWMq7p4ErQ5XGnh63dZKdUsHrPaSTCtCaRg1NMI7cyhJyh2DdaO18CWu?=
 =?us-ascii?Q?jrca40d1WTjil2AAeTlH5TxKT5F3bmmpLyqq1CCAt5wjAUqmvkevH1pflVN4?=
 =?us-ascii?Q?O7woxxISVpgaoTNyR3VDTN99NMoHaEcpkziiL5qQo67+efwg+N9siHCrkVt9?=
 =?us-ascii?Q?0QN3ZSLTZkay/WaNETL+NG30JQ6SV1v9cEUZn+YapFNM/Gy8oKYGc6NA11RS?=
 =?us-ascii?Q?QXhVXcuRfXwsTo3rj/V1Lfr2NcCe+Ab1zKoPQ/+cFCqf9sxdzGtSEF7D6cAT?=
 =?us-ascii?Q?I5NsZ/DjWl1wPUwMbiV0SF1Cce3mEWEXHOMElb8wX7o+qSRrml3WsZ+g/R7A?=
 =?us-ascii?Q?kzDN0IrgBvvzPKOjmC+LQYzyVz+Uiu3mKulk/ay/IZGEsqunQ2Xw7cFrri5I?=
 =?us-ascii?Q?0HcouWaOnbwqwtjlm/7onRx1dKpLws3CtoFqgDlnP7asS61qb4OaWGLeEsut?=
 =?us-ascii?Q?cZUam6DSu3QZFRuSCJAG7v/ZIQonxbnPzaQ19EJTvWOU1xqU1ZzdWUL5yBLs?=
 =?us-ascii?Q?Aw=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 45aba781-8c6f-4858-27e0-08dc442e82fe
X-MS-Exchange-CrossTenant-AuthSource: GVXPR05MB11233.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2024 13:56:13.9185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mMxSuCODujdUSPXws6d5kyWfL2ft9GLwcROz3VoZvuCdVtdEQZnWL+t9z1wi0MIQSGVYMkzDtBFWsooTUfDUoSsfpnXp7FAbT8Mmrh3pFVw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR05MB9333

On Thu, Mar 14, 2024 at 01:56:12PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Mar 14, 2024 at 01:43:52PM +0100, Sven Auhagen wrote:
> > On Thu, Mar 14, 2024 at 01:38:54PM +0100, Pablo Neira Ayuso wrote:
> > > On Thu, Mar 14, 2024 at 12:30:30PM +0100, Sven Auhagen wrote:
> [...]
> > > > I found this out.
> > > > The state is deleted in the end because the flow_offload_fixup_ct
> > > > function is pulling the FIN_WAIT timeout and deducts the offload_timeout
> > > > from it. This is 0 or very close to 0 and therefore ct gc is deleting the state
> > > > more or less right away after the flow_offload_teardown is called
> > > > (for the second time).
> > > 
> > > This used to be set to:
> > > 
> > >         timeout = tn->timeouts[TCP_CONNTRACK_ESTABLISHED];
> > > 
> > > but after:
> > > 
> > > commit e5eaac2beb54f0a16ff851125082d9faeb475572
> > > Author: Pablo Neira Ayuso <pablo@netfilter.org>
> > > Date:   Tue May 17 10:44:14 2022 +0200
> > > 
> > >     netfilter: flowtable: fix TCP flow teardown
> > > 
> > > it uses the current state.
> > 
> > Yes since the TCP state might not be established anymore at that time.
> > Your patch will work but also give my TCP_FIN a very large timeout.
> 
> Is that still possible? My patch also fixes up conntrack _before_
> the offload flag is cleared, so the packet in the reply direction
> either sees the already fixed up conntrack or it follows flowtable
> datapath.

Yes, the call to flow_offload_teardown happens in the ingress stage.
When a TCP FIN is going through there and the offload is removed that is fine.
But between the packet now moving from ingress to the normal slow path netfilter
code a reply packet might come in the tcp state is still established
because the FIN is not processed yet and therefore it is offloading the state again.
The FIN is now processed after after re-offload and the state move on to FIN_WAIT.

I do not think there is a way to resolve this problem.
We would need to transition the TCP state right in the flowtable flow_offload_teardown
function to avoid this.

> 
> > I have successfully tested this version today:
> > 
> > -	if (timeout < 0)
> > -		timeout = 0;
> > +	// Have at least some time left on the state
> > +	if (timeout < NF_FLOW_TIMEOUT)
> > +		timeout = NF_FLOW_TIMEOUT;
> >
> > This makes sure that the timeout is not so big like ESTABLISHED but still enough
> > so the state does not time out right away.
> 
> This also seems sensible to me. Currently it is using the last conntrack
> state that we have observed when conntrack handed over this flow to the
> flowtable, which is inaccurate in any case, and which could still be low
> depending on user-defined tcp conntrack timeouts (in case user decided
> to tweaks them).
