Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.64
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794833469;
	b=Ftz7SJBdwlttpZuizKK9bmB1qhNXwZ8LbI6HgbvY1UOCmbMrx7x+9rRqyLfKLWaP2Jsy
	 zQsBVOfyoyIS4tPjrP7g77NRI6i5nVCO5rgxZfg9mKg17jIGD0dJRbDd4qO+Pw0QfaeJ0
	 S4YeCAZwhDAVEWyGXvpIMDBcxxEgwDB7x+fpfMWHEZx3/pyfUcXzSHeiaL8b4zXvny/5m
	 pDPwZNI7JEZ69N3wN14eVb29A034lGnBmraJKdLXXZ0541B9OG52EYFVvM7AOPLb60lab
	 swiBlAdgQTwr7PrESsbW1Jzo1ywcSxwKPu/t7Zm5CK7zJN8SCrMsByVpJwsx9FJRWFw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794833469;
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
	bh=aMNNkFGAX04I4nDB/kvsKnTIayvtZmcRz9qtXTbAeDQ=;
	b=xs1nGD4D3k99szA2F6hoZ0aeCdKFG2OTZb00cY5/qN5SaqPXkRf0/X5YjMV7HoP6iwZv
	 gN0JYsW83w4aMle3mvS/VBUQNbdkObDKMfRVpshkRkEdYkj8Zdi6KAjLSp0oUktjHLms+
	 mtb8F962yUGftT0wqh7k+SwD2HZWlABHveevsSEq2KHcw8WsG5O2sqBNajjPtXHQxAEPm
	 WkANSo1R0Eds9DT6u334HNMvDUSRBya81iyZbfj6HfcLcyPYAu9SUiztzdZslxur9XERd
	 kf+bZzF1ARJcYw/ZX2e+HWCpSSPOggFGl+tVkitQ9amOPAjJdSE9LZRbzgXiiwC06Tw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=EeDxi68a;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.64
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011064.outbound.protection.outlook.com [52.101.57.64])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F29A606A329;
	Mon, 16 Nov 2026 12:51:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F29A606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=EeDxi68a
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s34WermatOTgBCy34RZqtv9s8/gVkc0dnRBgdjPTLQlGiQMa+G5KLAXM0mgyy/6xIG9yL2kgcC51gP5kanfzpWa6IGFAqZ3Bqy0YOIu9laMS0KfVD6TVfiWLTWLeWuQCnhU9l1StaCLTf07qzlto5FlO4ILBwT8ySOFsvBmwgjRFtu1lzPRx4HxZuKB5Ff/v1Eb6ldUDbWRt+6pHoa4oWaHzWYQn5iBEvTUzm8jlSFzTOrB8GI9igpZkr97hDRidu82nYAl3aOOS4MioPlVv+em6piP6HYEdfGRJaEz3RdSoPHVVq9PrMt/CTgsfaC726ldQSty9LpldN0uOFQuhbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aMNNkFGAX04I4nDB/kvsKnTIayvtZmcRz9qtXTbAeDQ=;
 b=lnG4RQUi8/uhbEZ5GUxD4i/C8Wt2G01ktR+/qcq7cYI9s47X6JDxXDgebnnojtKyScx+TPZ+msFf0UjT8P4iD7WnjiM0zx7SiOkLypC6qVMIwEZW83h4rZ0rIQo5Ban8Nihn9PQY1ofKSkb5hg0OrvbqiheTj6MZrNB32BdVUBcbTL9xXwy7loj4hYCNny6Fw24HfNgJsd118pYCix8rGWYtJHQAQqBx0TXfDhNC5U7cFhM/kYb9449MmGmcv3Bb/st7N7tDiVDXg/v3nmBj8GaGP15G6fu5Lvuf09WR8b2uiNJBAZSl7q8z28PxLfVS5U3wRuPoVgm1eeZetUt2qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aMNNkFGAX04I4nDB/kvsKnTIayvtZmcRz9qtXTbAeDQ=;
 b=EeDxi68aQKVMgW64+h7M7ci8UPPnQzvbOdAmWsm3G6WsDiVfHZIdNUdK6+DN3g6gyAOlVgHuiV+ECwd2mGz48HJfSJ9ouq0vLLA+bumU/7U/+pkd2cgVPAolgaIWvDiuYqsvRT8Uue1CZPrkcMWatzt5HfT05r5rHuzv0R1HydSQ0Fx6ckNq44TMRLlr8Drb0NZmsSR1sJqHjcdvFGc+xeYrtuLdNKjYa7GQygZjx2uukyjCU1/9CNvRM/pqOkkeNaabEKoMrIyFFTpD/VisJYnBgcQyQHDcXtLevIWfkdmrV9L8oqv5fUIqXcqyJA4x6XjNQcYZ3M4D5i3Au7XK4Q==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9407.namprd12.prod.outlook.com (2603:10b6:408:1f9::13)
 by DS5PPF7671D5CC0.namprd12.prod.outlook.com (2603:10b6:f:fc00::653) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Mon, 16 Nov
 2026 12:51:04 +0000
Received: from LV8PR12MB9407.namprd12.prod.outlook.com
 ([fe80::208b:424e:47e9:8a96]) by LV8PR12MB9407.namprd12.prod.outlook.com
 ([fe80::208b:424e:47e9:8a96%4]) with mapi id 15.21.0615.009; Mon, 16 Nov 2026
 12:51:04 +0000
Date: Mon, 16 Nov 2026 14:50:56 +0200
From: Ido Schimmel <idosch@nvidia.com>
To: netdev-bot+sashiko@kernel.org
Cc: leonard@lausen.nl, netdev@vger.kernel.org, dsahern@kernel.org,
	davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org, pablo@netfilter.org,
	fw@strlen.de, phil@nwl.cc, shuah@kernel.org, daniel@iogearbox.net,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 1/2] ipv6: honor prefix-length suppression in raw
 FIB lookups
Message-ID: <20261116125056.GA275796@shredder>
References: <20261115114434.10343-4-leonard@lausen.nl>
 <179482978100.3136.17418106822071501090@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179482978100.3136.17418106822071501090@kernel.org>
X-ClientProxiedBy: MR1P264CA0203.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:57::18) To LV8PR12MB9407.namprd12.prod.outlook.com
 (2603:10b6:408:1f9::13)
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
X-MS-TrafficTypeDiagnostic: LV8PR12MB9407:EE_|DS5PPF7671D5CC0:EE_
X-MS-Office365-Filtering-Correlation-Id: e5cd978e-d88e-42f0-d59b-08df43e04634
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|23010399003|10067099003|11063799006|4143699003|56012099006|261021121427099003|261009223027099003|261102123227099003|261026121527099003|20052099010|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	z+EIwRz4oI42Yo52ZvHdZBL5+9WpHNJ862ewagWt9ab1Aw8lXtuu53r1uu4TW/a9BFsEYj4pAYMc57pZGfYTW4/werdLy6CWFG9iPM3SfYwLX7QNHVOPojLRC9Dc0nMMQ24BUDZNu7JlD+k3R4v1kVeJZSmwVsKjqOvYi2F7uj5eyzGQppVguN9AsYDpdZ4dXwWs670hWoCjbywRkJuMmya520uJwoTbKhpKrtAoUHuMDa41vBb/nofGPdwDmrw1zuFTM9xxATRld5Kxi2hyINVJOV4BkFDjXPr36K9RmDViewVsbla2ooBc8jXszkimlfcVQ0VkpJvKt3XaLgtMMkPnCrQUKM2JRLzd1uhVdgHd0VTCfZSoqLG1ILs1stmIXiQFIpqj9wbLNC1ndyr9dSJ7pbwqLPool3+VWX58qvkl9eBiFzTP1PeIdALDLr4LGiEG63ViCPQBrPCBXUhaaBCgmoAtotYnhMkqn1FaLPCXZQZpmzTIFP+ZIF1OB+uiE+1MpuVLHKX5EKshdDNmO9vavB+PsNHASj15okJWkeItbKoe22O0qcKmXMG9bOXLtBWIiFxnNIERlT9KX4LR+vMW2nyUZAckASeWzG+wmYSlblPkYohbNJmSr1Ft7cIV4Cz9MQXpU5Y3AkRdpD8q7kZIv+K/3/LRPCcX7Rz25Zc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9407.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(23010399003)(10067099003)(11063799006)(4143699003)(56012099006)(261021121427099003)(261009223027099003)(261102123227099003)(261026121527099003)(20052099010)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ty3pQTLlQ8BBSseTmbuAoSSdD7yjPMA8wWWjD3zrikhTgeKOihsXlr1mPH+I?=
 =?us-ascii?Q?0rSU2sWq3Hkh69b8nrzWbCWi1TnzH3qxHdK1w8ysRCKCTD4HchcM7COUeI/T?=
 =?us-ascii?Q?h76GVyTrjfwaJzk5F3zyqJSwggu5Sv+wMpTkUBe77T1FGd+dWGKsKK1xYaVo?=
 =?us-ascii?Q?ub2QObrCwUqfdkdAsSJSC95hLHNeSKNB63evw50r/K5Z3binYsLIOcSG5IUY?=
 =?us-ascii?Q?kEWW/4IXudN3CwBOCJ3Env4NzeBY+nWBpt5znO9htZ02gkzQP7RqNeMujL5w?=
 =?us-ascii?Q?mWQl+/BET88bvvcYiB1FuYxOyB86hvNOO3i8OKlIv4LO6LJ+7++Glmaz06UA?=
 =?us-ascii?Q?5W7tQdA+irfz95/vmNobawg69MCqvoibdcrcug9VVVs0cGePBrxvX0si4YOd?=
 =?us-ascii?Q?PFMmT0iMNu9G0aRilhyKt0Ti3pfVcMl64H6grd/kfmGcnmpbBsGpwiJARnEr?=
 =?us-ascii?Q?QCj7LLOLl50rsLUfZKxiRhhjiZ3pSVhlzBpS1nxCF4G+AZqtLUd2nGNKOtfM?=
 =?us-ascii?Q?OBz/DGgdYbIOMX+m/rjHopQ/0lib1/SoDLcMMVthIGlAaUKvSS9kPOY6QzEc?=
 =?us-ascii?Q?Jt0QsaarslrLlTVoXbMcM1xJreMXkCp3aJy17/B040yNo0E0P/mtbasuEabk?=
 =?us-ascii?Q?32A2RbATS84pm0V86M5dOb5AHc0JKCSrunYAgN6zP8R2DMGB7JljyBZ8ZM0o?=
 =?us-ascii?Q?h3r89szHcs91pP5aIQeYCjawNUKiQPD4C7SGGCHe/ZHAyRYArHFa+Hw0kTJc?=
 =?us-ascii?Q?24MqfCOCndTnRN3e4UCsFCwqINZTNDfAnGL+Ktt0no8wxP8sTQ9webjWa2jd?=
 =?us-ascii?Q?P+Pyv8dmWt8L9/MlzVsR9Aft9vVXe5jS90wR856MjO1B0Zq+a47zoa3GRXow?=
 =?us-ascii?Q?6bnhnkEQo80mBFiKOSXhvL6Sb0TGBOJegRYMrlImPHycm8HbUYQKi67lKH3y?=
 =?us-ascii?Q?bNd+BM5JK22lnYOrZ/5Y0KBrasoIfuSaOyH3mZKk/s9Ed+cgRtg0TQoJ5LIL?=
 =?us-ascii?Q?ARutAdIIRjCwqinS2JKx8znzU4Cs8qm5Ohez/d0o+xAAE014eIu7mvuNnyvU?=
 =?us-ascii?Q?FXV+V3SbqNav5Rt2pJb+LbQJohNaYu4ctkjPG4qLAUbdNgg05qzRglyBhIgN?=
 =?us-ascii?Q?U5YHsxE8A1mRGmTHdGYEnKMy3rWynwaP6F3h8iSvwRhDPxKXlvElG21jQXNV?=
 =?us-ascii?Q?ugrlzp9TiMf1/c7oOzPyZsQHsuMYjPVjRlcVdUCovkkB/zEWtw4dLnTNld+X?=
 =?us-ascii?Q?GjoE2DIiI9+DhfyuVhKa4E0tRiZ9WkyU/A2MG+9vqNgt30rMZmmcaNaxOROB?=
 =?us-ascii?Q?6aOZGVEuEuXvG3R2qke4YtcSErwcplOC0I+xC90WCd6yL+0neT7OtPLh7mwK?=
 =?us-ascii?Q?M0RiEOpoGxLbj7bHVouj4IEmvsvOyfkDhgKpk/iOHMe4R3kOJNRyzqZqUZFK?=
 =?us-ascii?Q?L1lV2ZeQT6fDvgGtz5CdR8/69zX4r98LylhVow9Jcy4wsV+niHw0ONOTQ3W4?=
 =?us-ascii?Q?nyVMqkOLLfln5nKZ8OJAksZyJOz3D8kYPS7Lth/4W2QXoZhDfEQUXFzkHyv4?=
 =?us-ascii?Q?JhR7hDP9QDu5e9bxL3bHeFM9lkEartsxtaGtd2mAPcQRn4NAPr2evhqhTzbd?=
 =?us-ascii?Q?cBLy8o983RjsG2qNA+wa6AFZ495AUhKU3MvPLF7MIxCo7Ck2kiPr1V2Ojouj?=
 =?us-ascii?Q?SGgN87W3nCUOHi+2bRnptEZAINvClys3F/oQ0IAwFSaJrC3w?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5cd978e-d88e-42f0-d59b-08df43e04634
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9407.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 12:51:04.1814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D5i1p5U6ZBjRUFBPJxW53J15xI0FlHw8XDjdTsT8pE85t7VjBMXhA0SDBqnBdhW3hxe5pO9Yf8Yz0dpK47khwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF7671D5CC0

On Mon, Nov 16, 2026 at 11:49:41AM +0000, netdev-bot+sashiko@kernel.org wrote:
> > diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
> > index 0ffd7b47a0460..ceb4180bcf2f8 100644
> > --- a/net/ipv6/fib6_rules.c
> > +++ b/net/ipv6/fib6_rules.c
> > @@ -283,9 +283,16 @@ INDIRECT_CALLABLE_SCOPE bool fib6_rule_suppress(struct fib_rule *rule,
> >  						struct fib_lookup_arg *arg)
> >  {
> >  	struct fib6_result *res = arg->result;
> > -	struct rt6_info *rt = res->rt6;
> > +	struct rt6_info *rt;
> >  	struct net_device *dev = NULL;
> >
> > +	if (arg->lookup_ptr == fib6_table_lookup) {
> > +		/* Raw lookups report reject routes without an error. */
> > +		return !(res->fib6_flags & RTF_REJECT) &&
> > +		       res->f6i->fib6_dst.plen <= rule->suppress_prefixlen;
> > +	}
> 
> [Severity: Medium]
> 
> Can the raw and dst paths now disagree for a destination that has a
> cached exception route?

Yes, and I already mentioned this here:

https://lore.kernel.org/netdev/20261115154639.GA4121811@shredder/

[...]

> Should the dst branch use the parent FIB entry's prefix length for
> RTF_CACHE routes (via rt->from), so that both paths agree? That would also
> be closer to what fib4_rule_suppress() does for IPv4. If not, could the
> commit message document this divergence?

The dst branch should be fixed to derive the prefix length from the FIB
entry and I will take care of it, but it shouldn't be done in this
patch. The patch is doing the right thing and using the FIB entry in
the "raw path".

Not sure we need to overload the commit message with this info. Maybe
under the '---'.
