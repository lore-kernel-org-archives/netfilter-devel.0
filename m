Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2104.outbound.protection.outlook.com [40.107.15.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709B0168AF6
	for <netfilter-devel@vger.kernel.org>; Fri, 10 May 2024 10:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.15.104
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715337925; cv=fail; b=NymrflXztrsaZ7JI9vOe+z+lAvoMHiPST50Gu9OtZof8aqI8PS1xziGunZ7U7f06OXJlFkH+LvIYR6IMDSmifny8se5hlM/PvwM/bonKItMmbviQhtNz0biAol26Aek07mfkXMGwgAFlfWEClhwYJ63crUNF7nkFB16GXeaRYlM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715337925; c=relaxed/simple;
	bh=lZCAsFK+Mn8VQ8asI1Mo8hyhhMTZdYuOPxhvOGNtHGU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UbLumBUiIeqOPeLnz2NLHiGS0MCLJ++rgVsvSg75GPUPjW9WLdmDhWbnwg6O0gGJuckypEMBkMYr+/GeUeK9IGvFsCR9TgWCIxCziK21zaA4jim+61Zcf0v6sMdBk0eQzp5L3z5qjqQw2vtqSEwDob/BFAG3ovxB9CWFkWb2oQQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de; spf=pass smtp.mailfrom=voleatech.de; dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b=HYjPxWeT; arc=fail smtp.client-ip=40.107.15.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=voleatech.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="HYjPxWeT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OOPXhngvlQTn41AwL//GJzgZXX3PVUcHe9hYty8wcnsRgkAUCi80/kSVWTIp3riwwf6YiY5S6sJ9ohss9QyagQoScVn1U5YlxdZQdAr+G7OIzb67re6iYcgqiITvCb0CUExG+WTyDrl3w1pkJInvpHxhzkKtV1AWSHopKsivhxhRfc5jIJx1DDbMpQeJ6g1IHgx29D1bjki7mKCHKimMBU4E/UruiAVBaWoSJUW1x2y1yutM6MplINKfX9q9ICK+W9iYgFR9TfKv0vVjiE24ZHy/mnjQztprP4oHMkrfkeTjsRIMytiQ+/Udcv6i9+syWFU8542k0zRaBVVUi/qBsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JfdXWO6kHtk4wdv1Ru8cdpPmSUAxC+YFee9eLyorarc=;
 b=MN2UggQcq2O3lHY5UnvR/t2gt47XPErJmzCxxlq/TxJFyfilc2/J66OlVSzTyV5VUkEeT1VWsC141y3J12vN82zrDrrXXhYhG2wW/S8eTowRr7A5dK8fwt5vusYsqZ2pLpRVAeMcBl1Cjev+k7rcixtCDCJAbReUa9MJU61JqPJlCXu/8JEIKxajZRwVBiUg9r75spB0pDnJYkItsI4tQDQgMrx8GJki2HNV1L+i9FMhre+3luOq1EmPIdH4q8tteydfYik7785Uc9C0zGM38DNYmr1wxiZZxbnLfg03FKzoGj9TTU//YQhXdzj8DqPPRKu9/b8M8VoJlyz4up8A+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JfdXWO6kHtk4wdv1Ru8cdpPmSUAxC+YFee9eLyorarc=;
 b=HYjPxWeT/Cg8a2sEUWxjzsNcDEgMWP3gdFIy2nn1+Ij96nVv50d4MFo9Mt+k89fyLQYCmypVT2FPyOGOf3U9Ty67vc6FXsLoWe1CfcYyOvbcd9t9eaYVq1jCa3CXJINSsz4wzHMBlAcRiDQsa9nHegjhW8woSMH0sfB8fC9OAps=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from DBBPR05MB11225.eurprd05.prod.outlook.com (2603:10a6:10:538::14)
 by PR3PR05MB6923.eurprd05.prod.outlook.com (2603:10a6:102:68::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.49; Fri, 10 May
 2024 10:45:19 +0000
Received: from DBBPR05MB11225.eurprd05.prod.outlook.com
 ([fe80::eb7:22e6:e723:9086]) by DBBPR05MB11225.eurprd05.prod.outlook.com
 ([fe80::eb7:22e6:e723:9086%6]) with mapi id 15.20.7544.048; Fri, 10 May 2024
 10:45:19 +0000
Date: Fri, 10 May 2024 12:45:15 +0200
From: Sven Auhagen <sven.auhagen@voleatech.de>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: Could not process rule: Cannot allocate memory
Message-ID: <qhjlvlrbtoxmlmowgkku3gqqgczzdyvvm4urz3322qbzxwqbc3@ns35urbmwknj>
References: <qfqcb3jgkeovcelauadxyxyg65ps32nndcdutwcjg55wpzywkr@vzgi3sh2izrw>
 <20240508140820.GB28190@breakpoint.cc>
 <20240510090629.GD16079@breakpoint.cc>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240510090629.GD16079@breakpoint.cc>
X-ClientProxiedBy: FR3P281CA0203.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a5::11) To DBBPR05MB11225.eurprd05.prod.outlook.com
 (2603:10a6:10:538::14)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBPR05MB11225:EE_|PR3PR05MB6923:EE_
X-MS-Office365-Filtering-Correlation-Id: deba442f-4fc6-4add-45c2-08dc70de491a
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1o9mZT5V5KudEU3amx0dNztganc/eTOxrfNrxUD6MgPzSy2DnBvhxhH2LHRs?=
 =?us-ascii?Q?CcPdPZTbHcLuLagGAs/KFiTzOT3SHZCUEY+qEHb0+6htJ3jfeebLErtUm/iE?=
 =?us-ascii?Q?E48ZWwyNr9P89ALZa1xoB/IkB5rQGj67qHwEyzopQnNZgiunXwtvIDXn7GsO?=
 =?us-ascii?Q?UY94IRDI+4Jcr7H96PmRPIk4FrrJu8UCvf/CdFWROPH276YpE6559z7hE4nd?=
 =?us-ascii?Q?pFI4bzGD2iVpc++2QMWWg5DDxu2dmafy9D64VDyL9z5M4z/gA0J+EcUP6dxh?=
 =?us-ascii?Q?x1pvonMNhLKPyCPSw9eY5u4nTEMbrLUUH5YX9ZWiYUvswDHmSzatdJ63sDZG?=
 =?us-ascii?Q?9xTo35Fg8HHvrNYHVSDmNiPezopfG6B18qN/yt9vcFWaBP7wjprOBkBHrG0Z?=
 =?us-ascii?Q?noIP31FWkfJ1vF3VTtNTinR7IAISLPvSoRRgZTe7BtlVWRVi70uwnKMHmUMD?=
 =?us-ascii?Q?NjzP229YRJHXGLD0UPwFhUIHrTUNAMN00+1vNdpLtpVVjkaSNRy9dV+/TtFt?=
 =?us-ascii?Q?AGDaPJnM24tZpiAF5E790pgHqb8SRXi8d7YIg5YWHXtpZTY40oUKscWQM0ib?=
 =?us-ascii?Q?/YLDHQG6+5joeyqzsE02ARIoD4xrJH6fMnlgGpTUjbc985HAqgovm8hZHlao?=
 =?us-ascii?Q?Jir3NTAtD78x9DAaywPZZjZrmyHB/uBmTrbkEJbNpKYqxv0BEHb2wZI3RXis?=
 =?us-ascii?Q?0Hrzljwy0YqeTWWCaXkZ60mZAsW4GpYxwyuIT9wSpbCouiswp/pkWLyIX72r?=
 =?us-ascii?Q?0LmQN2wcu5GuCN2jjcHbW9LB8g1N2/wXD60V+5YFkcSCgITY4yAMbiooJqu4?=
 =?us-ascii?Q?6vS/lMDs9SK/+OLYvEy4+96U7Lsw7kb2HSlbyxsvZecr7zrjI83Iwv0xyu0G?=
 =?us-ascii?Q?jBGCBnfAbwDmd8FQDDia4k0SnBWhvNdxItRuz0EGEdUTyuQWhky1Qj8KhzMB?=
 =?us-ascii?Q?GBzdylfdOM49jjx213Yt3Ybi28KKxASjgUxiXvc6DiDHC8uWD08vfsvco/KJ?=
 =?us-ascii?Q?KrwRmwHL1B7S086nm+Ucv6aT4/jlMPzFn7jCJnRhQzKGirIqP4X+3nTkNOEI?=
 =?us-ascii?Q?VK84u6MKwQRO2qNHR59HI4dSN+kl3yt2Mt26D2fvVbO0YxEbE+mm9LZxffR3?=
 =?us-ascii?Q?966wO+dkvCelFlxb5QQQEl1/hXsRPwvMghrnPMmfJnhXU6u7foGGGjwXMDxx?=
 =?us-ascii?Q?O2JBPR6sBFoU8hcEuXikzn8vGAQ9Zumk33Li/GYkHy0hWKDlSycpTeUGR7fF?=
 =?us-ascii?Q?BwIJaSUZjCyO582ZemB+Xq0RYF4sExTZmFLZ+3HCQA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR05MB11225.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?61S7FRf4w3rYlKZ4IokTWbJx/v495CLQze8VZSRJkyPXiGCvESU+xC2mkVz0?=
 =?us-ascii?Q?clmKqTdss+6P4gv4rsYlOM1vjOt2fpjMcTsRLfMELhBoH3rU3wJ/XXvo9yg2?=
 =?us-ascii?Q?Xc2eRmRERcPyCeta01Yn4ttCbJD1VHculV40yLId+WPiRir9kvFCnkr50Bkf?=
 =?us-ascii?Q?ufH7E1U0rZF8/xdjaPs11Cj/zer0hNBNjjiDabgpAaJWPw5X3g+mpc0lV2Ti?=
 =?us-ascii?Q?BlkIozM3NL85nRBapDIfTq2rJz77CfyiTMYbvJjTts9RUq03uNYailbD6rG1?=
 =?us-ascii?Q?X+noLcYSgX8Pl3TFwSJ33MS7lvWckR4/s5mYaemt7zGPFC84CXXkF6DpLkUV?=
 =?us-ascii?Q?0tcW8pn61NGj+y9YnQvwVVsxCY3aS/TVj6bJ2mQwODhtxT0a7gBWrNlhnWkj?=
 =?us-ascii?Q?B9PLG0vpmeXo8hMDBqpAaBrzr5pvdwfNw6OHxSc73QwI1CQd63RBwHBqIy9L?=
 =?us-ascii?Q?QwiRaYEPMPWyfrLxSPe2q75/KXt+S47jMGKntAgJzBvXAxNu6soMRty7QFzF?=
 =?us-ascii?Q?v7ZSxhGjEkvtePBvUqLoP1HnQQSvSPQ7o+hCPFeCp4rC7V+QgLe8sTkKE7n+?=
 =?us-ascii?Q?VMMyyfgJT1gwpFQRTEFa+vvUWpnYWV3HlgudkC+9NUkFJZwosCfGNWuGFoob?=
 =?us-ascii?Q?M5Vc8Ebur9Zu/uksgQESvhgCV6PbhfFGYkUqOiXwFaXxkH1MPBIIqquhAbm1?=
 =?us-ascii?Q?juitZZrSg+P30jGTbvoFEL/FlmLr8u0WMkwDXKJTVi6hq7QaomJx5/5I51Dh?=
 =?us-ascii?Q?VBQzNtMoSDku1CThj3F9/raS6dkEPa4pKq8OyG1/t8GaEYWXaMZHMaGvTt60?=
 =?us-ascii?Q?k/VlQGikSf3TGs6GuAVLgOhl7+kPVkleBBPcyU2G0bjA62UF8ZNeDEmF795O?=
 =?us-ascii?Q?/PZpk3vyaxBI27dwHQDvdvuiNjtx8OUrTW+9RyzLwR+HYcXgNHwr8NVWIQ+Q?=
 =?us-ascii?Q?V+d9OVf11V+sfpkbkCeEL5yGNE3IT6WhYJ2hkLVaqShpcjJhzTlLg3x43OuA?=
 =?us-ascii?Q?aXabBIELUZLhcmgE5Gzr1mVsZ+dcSiuy/34r0Q9ZmQVexjI0W4qwPF+swW4n?=
 =?us-ascii?Q?RwXnFTonqr9FYB26kt5QGSvZXoX39gUSvYgVYFhwpfcfPK/gn8u+HMhZck0e?=
 =?us-ascii?Q?3GXgyC8aCE01zEGDwcQzFgyuVkhkyZNipzB50W2fevi+aUO5Bk7jU701I50w?=
 =?us-ascii?Q?M1vIHob3EJTab8ZNsnAQGS/p6vekf/sCd/ZRsQDE9B9+zmbjP9xrY8baRMYs?=
 =?us-ascii?Q?VC77GTXjvbwGlgVktMQdAostOb8fS+TEBRFrlyiIPV+QG3tht8h73ESdiNKV?=
 =?us-ascii?Q?g1INf/yT0u1AoahfuKJHWaoFGMLE+gy4JnQdm9VXeZgvH4VCPayK6v0v7dEP?=
 =?us-ascii?Q?AZyzAJqFyAPV3KpMfahiTyfVjc9QGx9KMONoKwOr/8rUOq2Mvcutb0jPivVd?=
 =?us-ascii?Q?R6/9rqdvu+hMEQ2QO3th+UrYajU6gp7gCvTpUZ1g5cb6p4spXEych9DPoy6Z?=
 =?us-ascii?Q?0h4swAXM/XVOLX0KiEZFp5qiC3u+oqkrs3dELjOQ612o/DfWgLcntrgf3Tru?=
 =?us-ascii?Q?JyzGVLVk5ldNdlnbxSKIJ44lULCeXawgaujtjRUU6ifUnVYA7lAeGBBFeqIm?=
 =?us-ascii?Q?Ww=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: deba442f-4fc6-4add-45c2-08dc70de491a
X-MS-Exchange-CrossTenant-AuthSource: DBBPR05MB11225.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 10:45:19.2823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NmK0ewxcYieajgpF3w5PB7R56DXFhnCOn8HEllzFUebcCcKzD9snUzhvktZiQ1vWyEMejeR7wjxp03OdlMJsUqal1fvqpxtf6iKwk2M5Kbk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR05MB6923

On Fri, May 10, 2024 at 11:06:29AM +0200, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > Sven Auhagen <sven.auhagen@voleatech.de> wrote:
> > > When the sets are larger I now always get an error:
> > > ./main.nft:13:1-26: Error: Could not process rule: Cannot allocate memory
> > > destroy table inet filter
> > > ^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > along with the kernel message
> > > percpu: allocation failed, size=16 align=8 atomic=1, atomic alloc failed, no space left
> > 
> > This specific pcpu allocation failure aside, I think we need to reduce
> > memory waste with flush op.
> 
> Plan is:
> 
> 1. Get rid of ->data[] in struct nft_trans.
>    All nft_trans_xxx will add struct nft_trans as first
>    member instead.
> 
> 2. Add nft_trans_binding.  Move binding_list head from
>    nft_trans to nft_trans_binding.
>    nft_trans_set and nft_trans_chain use nft_trans_binding
>    as first member.
>    This gets rid of struct list_head for all other types.
> 
> 3. Get rid of struct nft_ctx from nft_trans.
>    As far as I can see a lot of data here is redundant,
>    We can likely stash only struct net, u16 flags,
>    bool report.
>    nft_chain can be moved to the appropriate sub-trans type
>    struct.

Here is also a minimal example to trigger the problem.
I left out the ip addresses:

destroy table inet filter

table inet filter {

    set SET1_FW_V4 {
        type ipv4_addr;
        flags interval;
        counter;
        elements = { }
    }

    set SET2_FW_V4 {
        type ipv4_addr;
        flags interval;
        counter;
        elements = { }
    }

    set SET3_FW_V4 {
        type ipv4_addr;
        flags interval;
        counter;
        elements = { }
    }

    set SET4_FW_V4 {
        type ipv4_addr;
        flags interval;
        counter;
        elements = { }
    }

    chain input {
        type filter hook input priority 0;
        policy accept;

        ip saddr @SET1_FW_V4 drop
        ip saddr @SET2_FW_V4 drop
        ip saddr @SET3_FW_V4 drop
        ip saddr @SET4_FW_V4 drop
    }
}

