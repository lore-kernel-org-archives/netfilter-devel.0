Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2096.outbound.protection.outlook.com [40.107.21.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2F024A13
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 13:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.21.96
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710510397; cv=fail; b=ZgFU3T7ugMzeZnTFCjQvHDV0ckD7nhnMwXdN6T+xX8LQqjKkqK2oNk67BQPt5txRKCXvaOdyl3Piz4x+JLO6AJ1kfqEdEO30PZMH0Ifnt7sPt10L8COLFXV47e/kEFYdShakT6ATKct53Kf9LdpfqrCHjQsAHDazfOOn3zoGMl0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710510397; c=relaxed/simple;
	bh=llxD8Vpf8wIvPOwalic0QzoiXFu+LCAy7SLUUXGUvD4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=c5Yvah2lgUgPxiZ+TYKjEPumTu4ledDX3wUrTUaPIK1B4NDphtor5ooNjXBvQW4dh2BLnHZce436Jp0zCHNCBhtAVox8GGOUGGxV/HHYyAXOvJhJS/4OjZn7hUfipTarZphIaM92WZE0S69MQk29TMSCCaHHWpzIXjpPdFxm6PM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de; spf=pass smtp.mailfrom=voleatech.de; dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b=Kb5uo5T4; arc=fail smtp.client-ip=40.107.21.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=voleatech.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="Kb5uo5T4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bi89k7vnkosU8ToF24FOYPZ+YtUUPkn4gb5rv/V9YlzC8xAgKKTiBNh/emKeF2Sv3lveRmXMldDJ/Iah/oyq7J35Dkf34+snmFPHDjyw8ypXSgxsd5gZeSuLmGYnQxIA9l0ZDYdn5WQ8ptTbJ/6TP8pv5BJIihL/Z+Wialm5gzrL2DnNN2juSeoF+cwSTkHQ+AtNakewgqaT+7Hh1b3F/3WYgWgKuQbt4g7qP6OrYbnj2gPQDTQQcI9xL24LuBJ0GfgNXdVjpC6I1zpy/DsLL0csl57lOFVPLxd6PIozFn6FNXhTlkud1FO8b8H71KNAZ3ab55U9gbgNp62NMh1zXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/MUmwDNYFFkE+Ort5nn3Q7eFknHUtacL5qPPvgNQ7pw=;
 b=LCqYuuMUhas7kW1dKYqDaj3APFWaBJKjfj0JQgGEmeyurw1tMYi012OUYiCQEaN1sAshD1PrGgB67C7CUyTm8e916qddb0Ih4J04DR59Q5IRTA/TsvDmQDuGXBpS/nxHGtMnUy43IjAIjEyjWXb6F1++0UnJsbW+KGa/n3eDiEyNPGOTN7BhzgvsXe5fu9cGM+pDZg/n230RdZX49SIBQbVvcqVH10z028Rg1ABAHuW/8llmAketiO4/OfAmJh+jee9sMHTM7GB698p4dbNt/zWM6pIJIQ3WS6K2imuarraAu+SOF1FV1akYh+sTpFsdKurevI5q4MpDWhBWJJhjyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/MUmwDNYFFkE+Ort5nn3Q7eFknHUtacL5qPPvgNQ7pw=;
 b=Kb5uo5T43YZt5uu3efXpWaHhCtYapbwXftPpjbAVHTcxGFv7jlyUOQUBCJ25tO37aL/4ZEME7GTo7QZLnm4Q2BVs88JZv3cSg50BaNN+ahdhNcohfcJhr4RExxindXl5fGJIyYDyelO/Vx22sXwji6dhU5rhHJBjomXho9FpKzI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13) by PAWPR05MB9870.eurprd05.prod.outlook.com
 (2603:10a6:102:333::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.21; Fri, 15 Mar
 2024 13:46:30 +0000
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b]) by GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b%2]) with mapi id 15.20.7362.019; Fri, 15 Mar 2024
 13:46:30 +0000
Date: Fri, 15 Mar 2024 14:46:23 +0100
From: Sven Auhagen <sven.auhagen@voleatech.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: Flowtable race condition error
Message-ID: <36jf7ahr5msa345ugwgi6sf2oghlzlytxmjnp4me4hkuq4rymq@pbnvitdrxehl>
References: <x6s4ukl7gfgkcap6b56o6wv6oqanyjx4u7fj5ldnjqna7yp6lu@2pxdntq2pe5f>
 <ZfLc33WgQPKdv2vG@calendula>
 <2lv2ycmvwqpzw2etorhz32oxxnzgnpmi7g7ykm3z5c2cnqcilk@zmixunfs4sjz>
 <ZfLv3iQk--ddRsk2@calendula>
 <4tq2bj2nylpqkkqep2v47dnb3nfismzbdzv42jj2ksdll4figl@scwfgkdwyuks>
 <ZfLz7NEwUnY_BEYZ@calendula>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfLz7NEwUnY_BEYZ@calendula>
X-ClientProxiedBy: FR5P281CA0033.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f3::10) To GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GVXPR05MB11233:EE_|PAWPR05MB9870:EE_
X-MS-Office365-Filtering-Correlation-Id: 55b890d2-4ed8-4d90-294e-08dc44f6508d
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	jNWDhQvf2ts1GU2B15voa0ucOmkbRbeJ0qCTHm4gWJaA2qVKafogqcF2u43odkZ3Yd6xarJZPkrwcBbD+93BaPEJrJM47l8SylkghNH3VbxxWNxQKVGNVLWjVpzQ9srukQdgtoL9wjZ6nydInSO/YcBJYxEjcAOGQ7LNcyosL/KDkYHBwYaF3iKB2mLxb0/siBhYr3qLL2AGTOkUSZIDGzT9em4k9yxLdMiWIdxV0aApsWxuN5MlXhSx2Yvg2zEUvjv8Jo2z1zeQtkboqwcHH0zx31Fmhyzsn2uDDg4wjLi7tw1u3pvVFYaUIkKQA2Pieb0oMDdJ4zMjTdws23A2ga6XBEudfRNA92z2pDlTjFo2PS3ORxCTFY5GtCRfeU8VIwToLu2BzWnKu+SJilHdhfL4jqQ3bVxnpYDi74dKTYSsonsfmZjJVph7OMERIdubSvNgwYsJzm5Ag5/tlk/1YpVrke9pEZq5rrTGCMjNTs+ZEuG8JABizPcy3iiDuvogpEKrTqPVMBtsRO087btKxEM6/P1WLNdnPKQ+rHqe+3z55LjZc/clb8SWVWDj0PC2KiCnO7PrBgRT8tvfEcrkD8dQQJy1cq8gNYqYUHdc9H3LHT/pUHtw07tSk7AQ27Vve4qbDTDCsb/DtyNcnEI0SmX2x68akGP3F7H4++ExGYs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR05MB11233.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uzSMfe0SsafqMIwO2PDWFAzmkWtP/kkmKuJkZnzxeISjrq4+wFmVFMAqk1Vv?=
 =?us-ascii?Q?IAx5ztu/evgjOQ7S57BJ8EH+kPmmJE334oOTUMQoNpBgpgRZ2xGDtTvPqnso?=
 =?us-ascii?Q?oJiXGv/RvlZ9MpgxUhhslz40fsz/DMypvqKXzY9rhXxdfSBE1dEixCTNdlbL?=
 =?us-ascii?Q?hFqwcamGz2nwke8piSGnTVtkeM+BY5Q/uNoSobzJuSiT+AXjQJ3CBtnhZyCV?=
 =?us-ascii?Q?inJnE05Ha7KXKpojxm0cn75IT91vRknxvfVlVR/+tLxIRK9oymGiRf9SguDO?=
 =?us-ascii?Q?ZXqvueBD6xs/Wk6vOcRNE0qgjtdzxTNXnG707sL0V/V8kKHkpEdrvG428mew?=
 =?us-ascii?Q?iA8uoN/3OQ+Yonp4Ba+s84ex4/5/XeZ1FOORiSY0buf4MoGspFf2wIT/Y6rW?=
 =?us-ascii?Q?dH6jCs0LTidtqoxhB9z4DidWAxKAzYlSTNWImtRI+vyyiw1Qx5IbrBpiTPuS?=
 =?us-ascii?Q?ln0pdDB1Km3gKsqSedDAID8VUvxeUeiDphbQiPfP27ydVyzqWJSTnoVKWV8q?=
 =?us-ascii?Q?b57yyvhM0e0IpJ8XWPv775bzbC/GbOQe9rGvoFrIOLT/n+OgOwyX3EWuAzfW?=
 =?us-ascii?Q?xPPCRy1TLCCmAszEA2faXJFdgTps2kbxfzOTAFFRV9PRpaC6laaszLci8CDT?=
 =?us-ascii?Q?tuGQBtEPgqucSsAqY3gMOIBE2Bup4iUj3vlBoog9ErbPwGbWW7lhZBAYHjfW?=
 =?us-ascii?Q?NQvnmEDZj4c3SxwYfyvQpjwk6LK+ia8Ch5+QsLDtcZnOf5XN3TZ7yQM3b7oM?=
 =?us-ascii?Q?QbU1eBqa2ipPB5H8TvGC6JpWwW7UvrDq14n0bu9ymelCJxgZvKucpBNwtyqu?=
 =?us-ascii?Q?Bc5G5MWEx0tZ7oXdxISFrrv8Ci+5Jh105LrkAPnbVJR3OfrM7Nhg4HK9tmu4?=
 =?us-ascii?Q?9/qY6ndX6Ng6Eee4BmBUX6bBGtpoj94wO3pySkTYXOizHDuzbc2Mu5JeQaNv?=
 =?us-ascii?Q?kqa6rgGi/xdPSer4jy7/mK3L+gbMGWPlkDAqJ8/rh3wXGzmteIPjFyhjQZoa?=
 =?us-ascii?Q?hckcrHRD1o+RKFAfHgH4QActhsSDO/FnSQ+BiqBkrkvily7zbMs7oIU0sZcN?=
 =?us-ascii?Q?XBovKc1NlGJGRLegkjvVgEXjDEy6yGlfU7mHBONH/v3I5xhCDpPZvP407l6D?=
 =?us-ascii?Q?Lt+IHxNQl5k/JjR+3LdW+ZAB0TpzW7DZ4P3AU5747vjXOXlJdnR+eXtPWsc5?=
 =?us-ascii?Q?c0Wk7/F41aQEjft4oPzN5nsy9weJ5rV4hYFlc7Iu2zyiRrM7A/YuqWTmE8fm?=
 =?us-ascii?Q?06JtvbjHkBLWq46OKy7T2VCWCk4vZ1b6623armXjJZVD4a+y7wsvMGvLI6NN?=
 =?us-ascii?Q?/fPY2SnHl40HGIft12fzhZanclg9Z3enYkdI0o9eezc4Us+h+jmkaDvXAeom?=
 =?us-ascii?Q?RM3S2eWPTdsuhIU6Ln8c8GNZZMC8QQ31un/m1RU+i6DV2GusJ90KpSCwv9hM?=
 =?us-ascii?Q?WpL4cACgX3/yc7FIM+7Euip3eM39WVQ2Np0nzDOhOs6xMNqRDFV35EfF6G3G?=
 =?us-ascii?Q?m3xMjpUDhehKyJQZ1dBnFiYCK+hOwC+2FgF4hpgIN29pyRLsjHELnn3bV9SM?=
 =?us-ascii?Q?PUo/aF0Tbb7jEmK2Kv1dfOzj34cLWM9n8fL1t6ojm8ZAnAeaYjtv66sOUFes?=
 =?us-ascii?Q?+RjP1F3IWLyHDoKMs1SbMZpve9T6rO30mBzNbpxxX70iBoJT9m9mdwwvyZAj?=
 =?us-ascii?Q?1nOhhg=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 55b890d2-4ed8-4d90-294e-08dc44f6508d
X-MS-Exchange-CrossTenant-AuthSource: GVXPR05MB11233.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2024 13:46:29.6089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hV2lE/nx029BZRhe4ABTKzQyPbsDvDB7VyxFaacPA/Y0t9Tc4Etas4ZZICU3yMyd7jbYFAOtAgH/QVYZiJsJvVHtoGpW5OQAqLVXPOH5/xQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR05MB9870

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

If I take my patch and the part of your patch that moves up flow_offload_fixup_ct
to the top of the function it works now.
As expected, it still happens that a flow is ending up in FIN_WAIT OFFLOADED but
the state is no longer deleted right away and is eventually removed from the flowoffload
via gc and then goes on until the end.

    [NEW] tcp      6 120 SYN_SENT src=192.168.7.100 dst=17.248.209.132 sport=54774 dport=443 [UNREPLIED] src=17.248.209.132 dst=87.138.198.79 sport=443 dport=30121 mark=25165825
 [UPDATE] tcp      6 60 SYN_RECV src=192.168.7.100 dst=17.248.209.132 sport=54774 dport=443 src=17.248.209.132 dst=87.138.198.79 sport=443 dport=30121 mark=25165825
 [UPDATE] tcp      6 86400 ESTABLISHED src=192.168.7.100 dst=17.248.209.132 sport=54774 dport=443 src=17.248.209.132 dst=87.138.198.79 sport=443 dport=30121 [OFFLOAD] mark=25165825
[DESTROY] tcp      6 TIME_WAIT src=192.168.4.81 dst=192.168.6.8 sport=54774 dport=8080 packets=6 bytes=1388 src=192.168.6.8 dst=192.168.4.81 sport=8080 dport=54774 packets=4 bytes=398 [ASSURED] mark=16777216 delta-time=120
 [UPDATE] tcp      6 120 FIN_WAIT src=192.168.7.100 dst=17.248.209.132 sport=54774 dport=443 src=17.248.209.132 dst=87.138.198.79 sport=443 dport=30121 [OFFLOAD] mark=25165825
 [UPDATE] tcp      6 30 LAST_ACK src=192.168.7.100 dst=17.248.209.132 sport=54774 dport=443 src=17.248.209.132 dst=87.138.198.79 sport=443 dport=30121 [OFFLOAD] mark=25165825
 [UPDATE] tcp      6 10 CLOSE src=192.168.7.100 dst=17.248.209.132 sport=54774 dport=443 src=17.248.209.132 dst=87.138.198.79 sport=443 dport=30121 [ASSURED] mark=25165825
[DESTROY] tcp      6 CLOSE src=192.168.7.100 dst=17.248.209.132 sport=54774 dport=443 packets=31 bytes=5542 src=17.248.209.132 dst=87.138.198.79 sport=443 dport=30121 packets=35 bytes=8168 [ASSURED] mark=25165825 delta-time=50

