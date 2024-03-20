Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2102.outbound.protection.outlook.com [40.107.15.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABCDF9F8
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2024 10:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.15.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710931128; cv=fail; b=EkmD7Z9l2BnbuY/ECAA9RiVyAbpN/fTQpXSAjJuAkhlvLoe3YleMYe9O6x5XrT3yMu5aqt0Qgp6s2GCbLRT90eVS9RbWXH0Vuqi7Bynq9NqOiq5HubP7YCWOY46j3pNHI03RNHSI1qHsl9wVtXk0ZvEzaK/5WH1rAOgjEaunhu8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710931128; c=relaxed/simple;
	bh=QYiz3HMJEsHET7Hj6L3BqA7667a4ajjGeQXvfA4qxlc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=M4pwJK8RUH9Z3NQQ95lQv35K0PZxAvq+i9Kcuc7nrQ9IlaZkOvKRG2ycVRlNeyc9dtI5iwPoJNSXGKt5XauD97WS1XuVQrnTIumrAWXjdThfnSi4yA7y/XOXBF6L7spDOv6WSx7JINIVYuU/nJhwbUMMB8QR2OLTFjaS2RgmJ4M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de; spf=pass smtp.mailfrom=voleatech.de; dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b=BXuZ57yc; arc=fail smtp.client-ip=40.107.15.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=voleatech.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="BXuZ57yc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DpDKIv+CVXTDHcjjKTYZg6VEcBJqn9x5qSM5sbnYrF+DiotHYihtSYLRW9ociTRj8b2iUpsRaaeTIbRFhCz+19Q3VVVTaspuGBFJAeP8fO3xVXMBGmhggFw+BBxPVYUauawdcPrPdwZXpwD9yonau7EJyPgFCufSMVN6E/vtJ3ztmIhznshVJDcOeHvpmVffc+EyKnUP/Dl0F20ljm9mTNKEbB1NMoGvGumfywjfghznFQErFJMq7szRYhOPp4h0rjlWcnpcw0CxwaFo0Ezu24JKED+eZ/G1D+zBo5CNz6JgQvW4K/iiijMMRbK7b1DUTESImohF+4nVR6U+Lji1pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=maMo8Jtgy8Hjf46PzSPq6LoOOOQ7jhEgnTBPRttWeYY=;
 b=kuPvgNZdxl7DXHInIZYQ+gwZ4QEY4tWTwTIi018CGuS9ALphuKfIcD/8yMXlO0glRXf6W4cO5VWmiYidGEAb2Hc5UlNO8in7d0EQICKPH82S4R31jQ6S01o7JCqPKDxRmLGecJzN+r9qMQqw09I+utXhelCMlzdFEHQYanb1c9KnzWQjeLpFSVgmnKW/iOAIaf8rhPOZ6IkncKXqkoOQemEjOkkihuVQxzx8DMVTHqSLb+zBCIga/3Sm5ZAzzsnoSqFeEJwaw1aLH/uXTAYxcOuXsQv6JA+VLhABfCi1hsKqxy+tacSFjR3Vzxbs1+eAjG29bffiQ0xanfhY+pAZgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=maMo8Jtgy8Hjf46PzSPq6LoOOOQ7jhEgnTBPRttWeYY=;
 b=BXuZ57ycDVb168YPJtG2dzHvxLbG9Ig5/n+Nueq5BdlFX/cEZSTot5hJyVWSSbuSL/6Ots82K4CP2p9DxCK9NocPYU5x+Yp0rNqFi+x/vMgqbiaIbh1ahEv+hcqoAYAHQ5gSUquzhQLrTC9hLOmdRjZ5KV398WqEVzinSfIVBZQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13) by VI1PR05MB6909.eurprd05.prod.outlook.com
 (2603:10a6:800:187::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.31; Wed, 20 Mar
 2024 10:38:41 +0000
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b]) by GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b%2]) with mapi id 15.20.7362.019; Wed, 20 Mar 2024
 10:38:41 +0000
Date: Wed, 20 Mar 2024 11:38:36 +0100
From: Sven Auhagen <sven.auhagen@voleatech.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, cratiu@nvidia.com, ozsh@nvidia.com, 
	vladbu@nvidia.com, gal@nvidia.com, fw@strlen.de
Subject: Re: [PATCH nf] netfilter: flowtable: infer TCP state and timeout
 before flow teardown
Message-ID: <6ksa6gputwzgzgep5g44c634bngoax67wroqjp3gqhfceue6qt@477zbmg4vpea>
References: <zxdruu67c2xs6zrhagjilitxu5ysik5x7zvk3kthzcclype22c@nevv7c7adz7z>
 <ZfqiHPpUfFwHI5-h@calendula>
 <lajzqkqbqptfa6m6ntyseutpmbnrrc4yb26x6lwjaxm3aldzvc@u33db2j37rtb>
 <ZfqnTJKyW1VSIOgY@calendula>
 <lderg42fd4jbcwsztkidn3lhnjhufj5yv3zsdu4dpsenzikkta@cya5vq3prnzf>
 <ZfqsAoSNA4DRsVga@calendula>
 <nvslglowbvxntlpftefkumbwn2gz72evwnfvv4q2qencte7wyn@3jejk23urzeg>
 <Zfqxq3HK_nsGRLhx@calendula>
 <fcas4qeo45hbbjmu6h2ipryoi4cmhmhtzhudabqdj6egzxidg6@o5kaoqak26io>
 <Zfq8FedQ05ZuY9o6@calendula>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zfq8FedQ05ZuY9o6@calendula>
X-ClientProxiedBy: FR3P281CA0004.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::23) To GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GVXPR05MB11233:EE_|VI1PR05MB6909:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a875fac-c71c-445f-77c7-08dc48c9e8a5
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	r4XAB7M9pwVCG7tmM+DdcTnH/OBlkWaKBhlP4bxtbq24zGWQIw4Yl0i/iND04Xgtj4DmTrNYGurwYi3xgBcMj9d1Rwe9AwXmLe3/3DLpKI5yxPr0SjzjICNi5Xq7Ted3TFSSFNc2YLHgb9r1y40b63Ozrkv/ui8LioiKz2aDv5eZapJctkRGDbPtVs9tMMzEa7jlsMkZFXmvp2KOE1RUVfhq3oaRh9LPen6XbSkZa2T6czMxMzU0a7apybtSXVdrRI8yLSuEwRY3jZW3wnfzdUFCMtL1uPyDf3/btBidaCpYvBncMpfhI4lHnK5bSB+IN6xMkWC5aux4DmD+LzwTKDUM8L8LfDtZqpJ7RQDsiOmh5pmoWPVkNG6VKlb3qYKlPTIamrzdea32njgWwuQuV/kGCN8mIy30MDbE6lI7Ce1mZECYaAO730icERqxkQ5Wkq1RtNwx0jmfYs3H0j6ZuuxDrVxW/nYVv1cls1SYU8gNFrrR3LoJxZhedi4uk91B1EY+IolhLbsLrWOqt6EtU0Qrm7D+niKgYVieXLY7Nn73zJw3x7KDX8eKnb4ZCyAUA8sTSTZ/rwUGnXvQG6pXWvFG1a+EgoK2dAvUgUzkQH4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR05MB11233.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Lfirq8mgZ6cS9hS56mMA+AWQ4weM70S36LaqdjabS0e85uQUxqaGv0w4mNx7?=
 =?us-ascii?Q?cCE5FrIdL3Ipg+Y7GJV9MBldsxtVeECJEzh+uGfIuLMXhZ7XAtN+enRT92wt?=
 =?us-ascii?Q?hiXcmSzqu/U5WqFlEZBQcdjLeT3O7E8KGF/HYLUpgdYVG/Xcn2BpWiSrlWyE?=
 =?us-ascii?Q?+zllFEoxb274+LAPVm+SUQYuGAPiJIg3dZOfgMrjDIVIMAqi5D4+W3BD/q5j?=
 =?us-ascii?Q?79STGKqI6BOx/9uNuyrLlzl3vQg/xlDAPFEEBhk4TAQn7lovYIWM+TkMMWgE?=
 =?us-ascii?Q?7J5g37LZ9nv+Mtc3kiSFBEgck6eEpaVc71f6FKBZhrl6IWLNgLOmML6upfzC?=
 =?us-ascii?Q?u9JcL/6b5ZmRku+nGBpBCf69vN4ezx33ijDdr0z6j1l851YkhjSKHsYmPsJp?=
 =?us-ascii?Q?T+5Q8sLIppDTjIn887t966FE9zBv25/4iePgseRr6y8DfGBE61B5qsS13Rxs?=
 =?us-ascii?Q?WH8i7tfW2t75SFAEKk+/ZF1NtYPmjAbVdMZADHmpPgzEoT3QRgu6NrdJtiY6?=
 =?us-ascii?Q?n4kw5qkvDvTdrT1LcN3LLEz0fTKdBaNvwpc0B63jzc9b5IT4yWJTx6N0NaVe?=
 =?us-ascii?Q?8NkA9zygaKonj6tIAAHTyFxQvpdjZlVxWI8YCmw3nSrUUNAX7XtTW+WpznBX?=
 =?us-ascii?Q?3lmZSqE5R59hWC9QHSUYSECN1PxbZ4bxD1beApoVEUew4CeLTdYluqsu7Y3I?=
 =?us-ascii?Q?RWH8fKdpGliWwVAxHQamhrVzp8IMXBW+ndZUKFWLjlo4ONV8tz9vvSJvgPbI?=
 =?us-ascii?Q?/9NH4s6iwBDZ85Qdpz/YFeYTWIuysFOfCipSpk9vpX0sfpuD+1++JETINW4p?=
 =?us-ascii?Q?Qjvs+vej9yQlIdJ2Ma0DzKEjww7awgYoMKAVuUmoZVTyMZrCFHiHCuAirLmw?=
 =?us-ascii?Q?My6cMsiEfULe1RrR84qMWRGt6b9N8b1dn4F2ukWl4UkZ3KTZrvIHe+HByTEB?=
 =?us-ascii?Q?z5bJ/I3XQFzueWNNYaIRiCmnncHe3qStP6Bf9jTguD979Ca59gktxng2D14t?=
 =?us-ascii?Q?56VuJnEgOCWct6WPGcru+aMUfDSUCp1/6ddTgLkx1XSjRy2QaXL1z/IuS3fX?=
 =?us-ascii?Q?rhjL3F7QeehJfFB+cTBYXyZQDOYM+y81cFW7XfU22O0NEtH0TvOOBHX8ppoP?=
 =?us-ascii?Q?uewUtnTsZjCb3dIOqYd8X2E86J1Ig54rjTIAIaZgTDjgmVWyehqKdRxnG3lS?=
 =?us-ascii?Q?FLUXJWkAFuTfN0lMWTNQNhqp7aWbXfWDVbQX5/R3hetgobqxmfmRBMXxI0xQ?=
 =?us-ascii?Q?W/kc7IKywu3RGKaisV4oPNGkOmnJAfyt+YRwcqneAtZ6joQfV1Dph+F4hxqw?=
 =?us-ascii?Q?P1UNdRkNqodpvKm/WZyD26CaHqzawV1GW702i2+nCav+yk46GzasB/BRpY16?=
 =?us-ascii?Q?aSwWm6pwC45TGysulxx16kUcR2kKuPoUYH/oIyWaS0EiXnTKz1jXNoawDyqg?=
 =?us-ascii?Q?iWafwOhU8kSFvK2hJjEeSACqXQhLeHX8O+akwAVU1XHSBJiyLMwfXuOS8d1m?=
 =?us-ascii?Q?Ktl+RSv6/iNfg7J5FpQXBn3LmA2e1XmeXlvZXoO4uBNcUC0C9GsEorhxzLTN?=
 =?us-ascii?Q?OqnrLhS+zPM2eSh5sYrpEO2QfoYJJZqOGyP5FtcZQIMi0tMYANKesPlvBgo4?=
 =?us-ascii?Q?Hw=3D=3D?=
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a875fac-c71c-445f-77c7-08dc48c9e8a5
X-MS-Exchange-CrossTenant-AuthSource: GVXPR05MB11233.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 10:38:41.0172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qG2qCcdvbZ6Ejd1ug0q2/f1we/DePD59uhERgNjU4T/K0NfVWgdJkA9fbEonCavbyyCHXYPcrDAiGLlUglPxi4RT5ZcZ5lOO9tC5bguF0ZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6909

On Wed, Mar 20, 2024 at 11:36:05AM +0100, Pablo Neira Ayuso wrote:
> On Wed, Mar 20, 2024 at 11:13:23AM +0100, Sven Auhagen wrote:
> > On Wed, Mar 20, 2024 at 10:51:39AM +0100, Pablo Neira Ayuso wrote:
> > > On Wed, Mar 20, 2024 at 10:31:00AM +0100, Sven Auhagen wrote:
> > > > On Wed, Mar 20, 2024 at 10:27:30AM +0100, Pablo Neira Ayuso wrote:
> > > > > On Wed, Mar 20, 2024 at 10:20:29AM +0100, Sven Auhagen wrote:
> [...]
> > > > I think for it to be foolproof we need
> > > > to migrate the TCP state as well in flow_offload_teardown_tcp to FIN or CLOSE.
> > > 
> > > My patch already does it:
> > > 
> > > +void flow_offload_teardown_tcp(struct flow_offload *flow, bool fin)
> > > +{
> > > +       enum tcp_conntrack tcp_state;
> > > +
> > > +       if (fin)
> > > +               tcp_state = TCP_CONNTRACK_FIN_WAIT;
> > > +       else /* rst */
> > > +               tcp_state = TCP_CONNTRACK_CLOSE;
> > > +
> > > +       flow_offload_fixup_tcp(nf_ct_net(flow->ct), flow->ct, tcp_state);
> > > 
> > > flow_offload_fixup_tcp() updates the TCP state to FIN / CLOSE state.
> > 
> > Ah you are correct.
> > Never the less I can tell you that I still see this problem with the patch attached:
> >
> >  [UPDATE] tcp      6 120 FIN_WAIT src=192.168.7.105 dst=17.253.57.219 sport=49574 dport=443 src=17.253.57.219 dst=87.138.198.79 sport=443 dport=5078 [OFFLOAD] mark=25165825
> >   [UPDATE] tcp      6 30 LAST_ACK src=192.168.7.105 dst=17.253.57.219 sport=49574 dport=443 src=17.253.57.219 dst=87.138.198.79 sport=443 dport=5078 [ASSURED] mark=25165825
> >    [UPDATE] tcp      6 10 CLOSE src=192.168.7.105 dst=17.253.57.219 sport=49574 dport=443 src=17.253.57.219 dst=87.138.198.79 sport=443 dport=5078 [ASSURED] mark=25165825
> >    [DESTROY] tcp      6 CLOSE src=192.168.7.105 dst=17.253.57.219 sport=49574 dport=443 packets=15 bytes=2688 src=17.253.57.219 dst=87.138.198.79 sport=443 dport=5078 packets=18 bytes=7172 [ASSURED] mark=25165825 delta-time=126
> 
> Just to make sure, are you testing with these two patches?
> 
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20240320092638.798076-1-pablo@netfilter.org/
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20240320092638.798076-2-pablo@netfilter.org/

I am currently testing with v1 of these patches.
I need to wait until later today to reboot the production system for v2.

