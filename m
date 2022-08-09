Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5780BC19F2D
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Aug 2022 15:37:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbiHIPhn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Aug 2022 11:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239967AbiHIPhY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Aug 2022 11:37:24 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8EE5F68
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2022 08:37:02 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 279EtSKa026330
        for <netfilter-devel@vger.kernel.org>; Tue, 9 Aug 2022 08:37:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=facebook;
 bh=kb9kpUt/QOzYxCVDFdgT8bNyeJELQkY73V6qmQE3N7s=;
 b=CrngXXGDY1E7iMCvLZRlEnTb+seOcIyZnSZ56UHaCrJEd8qSN19fzoqbQe+Nnn+cf3n2
 KK6u7YEze6pPsQXoux/UpZHjGInFzq+QhyUWoVzNzZL/JB3+PqyIMQ3yKyJ0FT3b1oaP
 fIu9CSeUq4T7/ddEaPnUsIvFGCvZW4FfgG4= 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2169.outbound.protection.outlook.com [104.47.73.169])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hu774y1m1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Aug 2022 08:37:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WiqctRL3Xjrh+B8XDi8riI1SLGr2n/LkdpcSXZQjYYcS1coJQxXD8p8e0Ktj+4qyK6XXZP/iEsESHHWzlLalBSyyfqiQg1D6I3PtKwYnyD9SK2ZDCepAZt2BlXgTWxz45T18m0d2AOSZ8G2AcfuhZX4nXzF1BJzh3ZJVEtYqN+vRdApgRs7RdZY9huGt1I8QSkfmNQD1RCQffhPakOYnv163ICmFsMjciAp7BtuPeGYeu5J/8h4ni/vTAgHOHg/sFLojxO1Xrkkj1i7IpFXrbclTWbdonjbcCZXsQ8WVVcfYCvStrVZmJp16VMJsPf5H01EvJJL/G91XWdyQiq1Ebw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qja7ukQL5ytDRFPol4eBE9bJLBlufy0B2eutXeikx+w=;
 b=QQ2GyCMCbzi1k42FRaE3I0TRj5rsAgb80WTB5tWq4VjuCmOp19ZF1gxyC16prU/kG6PYGyVhiHktsAStULRHbjDP5bKtwPmwjyoINnuD5oxQ1U/9CIbxuy2GHgnd28lM0lCwrpvo+rOlKITVxhQ15+s3wdGOsf7/lYT1ygbQLrTLhabig9jpFzASdDUjPLCPgtBPu7cZqZBG61lT3h6ScQP5IC25CfwAZVmd35SxingFaO//cFY0/PWPv+CMbBY8lBmD23vu+t0mzHbDKXKoS7+WVcWaOMnUMCtkvGTCNzxdhZZ+uUztogMXt2tQ8zaDPu6L69uY6qU7CTt1vWyUoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5137.namprd15.prod.outlook.com (2603:10b6:806:236::18)
 by DM6PR15MB4105.namprd15.prod.outlook.com (2603:10b6:5:c3::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.20; Tue, 9 Aug
 2022 15:36:58 +0000
Received: from SA1PR15MB5137.namprd15.prod.outlook.com
 ([fe80::c41c:730c:8312:be0a]) by SA1PR15MB5137.namprd15.prod.outlook.com
 ([fe80::c41c:730c:8312:be0a%4]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 15:36:58 +0000
From:   Alexander Duyck <alexanderduyck@fb.com>
To:     Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
CC:     "edumazet@google.com" <edumazet@google.com>
Subject: RE: [PATCH nf 3/4] netfilter: conntrack_ftp: prefer skb_linearize
Thread-Topic: [PATCH nf 3/4] netfilter: conntrack_ftp: prefer skb_linearize
Thread-Index: AQHYq/JOQ27YKKfNmEKkUJg1t9fV0K2msUmQ
Date:   Tue, 9 Aug 2022 15:36:57 +0000
Message-ID: <SA1PR15MB51371BED076EBB8032CC6F3EBD629@SA1PR15MB5137.namprd15.prod.outlook.com>
References: <20220809131635.3376-1-fw@strlen.de>
 <20220809131635.3376-4-fw@strlen.de>
In-Reply-To: <20220809131635.3376-4-fw@strlen.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7eff71ca-c7a9-48cd-85b7-08da7a1cff1e
x-ms-traffictypediagnostic: DM6PR15MB4105:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KLXgU2304cPYg0uzKGt/c41wLJqzf3e5JGK6JtoExL6iuHYgv9B7JIsJB9jLM+EPE24Xlxqu7sHFoSikkxYxnel0zlwR5C3Op4ujqd3K6Pd6Buz8XLS5srr/Cw0EKQR98NGdDfUKlwyU8ySNfJFry7WOxjIW6mE1UZA7BQUUCPJdHzSPpgOaWmq9y6UIcms0SPxjO2nBpJ27o4j9f0dviq3f0cKVxpazh5pWNVtfGR7r/cOfdCKawiv9qrJSdEIO0STN85p7sS+GXYPAES+uFonGmQFrA/zYaFNd5zrg8Jlw/FwBs9KwTE01lec79Pu1htzyrcnd2NlvCxdYRw0WhhxKRwF76LMt8LSu86wJEOGY0zjQjJRjgDakjeo5iYUM/rpyjiH/n7qFBtjeDo+3RSe20KcFLvi5HVsuxaSNT9B51Gt2lgYlBkdI+1OmgxoDj9/8Pmq2ztUWgJ4e0fF+ai0shKvZCB6eohwooMisI7UHob5KwUBV2g35HN0pS022cRJgEiNkmuOuMCNNOOiSGx/00rP/nuu+MgVt/trKc7x/SfTflVD7x+KsgSLfAX7TwelP9A+vgSdZpA+VcToJFwy+rt/5Fc4BTh7Fx2XnYHbwvutkCH7gaDqlZiFEv3fPnpqzgH9gRl97+cE4LcKHvexUMi5lUzrC/RWKnziHW0r1W2w6K9o3Y7dhHtt9wbtWSgVgmxLkmIpRrOgnv5Sv3MIUphK1HUO/Ps76VkhvaAzcaUcFvXxSEgsGVD1BKMs8wTQvTzD9v8EjYwtXylZrouBh3SZ9JBcXoOH3HmYCyrXO2OwCGegURnOGpk5ERs0h
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5137.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(136003)(39860400002)(376002)(366004)(6506007)(38100700002)(38070700005)(7696005)(53546011)(41300700001)(33656002)(2906002)(86362001)(9686003)(55016003)(186003)(26005)(122000001)(316002)(66446008)(76116006)(66946007)(8676002)(66556008)(66476007)(110136005)(64756008)(71200400001)(83380400001)(52536014)(4326008)(5660300002)(478600001)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?k8KWaLNQuezcSsjl9FLMhVKv+UefOMYJac1B02ZdC3WDxalb332VyibSYwwH?=
 =?us-ascii?Q?IdgXKsukkKDksIJ3rKxIPpuqYnZwgLcac/3FjQglkM7pu6VVsA90onRatkv1?=
 =?us-ascii?Q?zc0PGBalO27sYHDwjmuqvWjKtpxOXMjQFji2KGd72Xo5DI3hN1pZNy8ZA1/E?=
 =?us-ascii?Q?PcE+ewVkdCggE8tHEDaNBG1XH73StUhaS5V9kZHaB6sMYcuYqhH0GSxju0CT?=
 =?us-ascii?Q?USxvwRMiJoWR+NifxuFtBA1rs3t5qWGdyXkvWQ7W7QyQhRbhjF5Nj4DRtoXi?=
 =?us-ascii?Q?yVGf8pmQnfu0qJAxqjfTohDC+Vs8DHfdUC+mTrInCkT6kxd8nlcmUvUo6GXe?=
 =?us-ascii?Q?FJ+khsk//mJqljPZma+e7Znh3cAQyGNsCMQ5jP716U9ALsxbq15oP432jeZ3?=
 =?us-ascii?Q?S1nm5ylW/pEcxigXEdzhPrKmT853oJWxtq6aa7VKlE4VgxEd2giQEz7m8fEk?=
 =?us-ascii?Q?MN5NIQWLkCvjaQ3JvEslUjynnjOgwaQhMTWWl6unruCLZFAOVVWzFoB3dqCJ?=
 =?us-ascii?Q?hj52tQpgFyLPTQCN0NINSrSD36ZrIG6IhSWVQbDpY73a4zcZbhMuvfMh6nrE?=
 =?us-ascii?Q?iboCd47RCUw9S5Ngw5zm8iQYFXyyKdWUJIW8aMfUi+/3i5TxInAOBaOpqB2+?=
 =?us-ascii?Q?XDiNvunBlzSJSeFX6uqJdegT9vYVLk2CCZMNcDq7HZGSNR2l1L1cTeBM1E3V?=
 =?us-ascii?Q?/0QTU/LBBvWWEo0dtaAqPBXtuBWXjHyoVS7U/1akH+6HqzAaXoajUNfr+t/W?=
 =?us-ascii?Q?lzmRX1YveHXDgLC/g9iqY6baud8KbVGA4McyFDCLL23xulRVua5GDajkFuXm?=
 =?us-ascii?Q?0TlDRLEl7H/k32um2sgYuYq00tQ7vxhcAfXMPVr0UI9VhhT6pmPVIPs8qRPY?=
 =?us-ascii?Q?LHxu/P/H625Xf3oCIWeGz0EgQ9CSSuKhsqb3z2lIbTOlgOntfT1JIYaWbMPS?=
 =?us-ascii?Q?jlhGgoe/vMNNZuHCxtx4jJwDRlQXGJS8HDz7k4muoITmT1yBq8w2gaiUcDDP?=
 =?us-ascii?Q?3bgd3XxSaY9XpAWRJz68gmwvqwkr3ZIftvwM1EvIsw7X64TnhGRGK/l2gWqj?=
 =?us-ascii?Q?9loQiU8tnQfyX0VBrQg3NkhOeRs1cNjNn7UNXwY4w8CT97QcmDs4MFi4FBfV?=
 =?us-ascii?Q?I2vXLJBEr3PA40w+PyUI5f5O0KSx32XQRhH/JbrVLW0Esp6tGB5MeywM9PJD?=
 =?us-ascii?Q?jwftA0hv9Raprix0I7rriRAjeiDbICZ8+HrmrsgwETyN/4Bx/MsAcVHkHt8t?=
 =?us-ascii?Q?e6UXLph7Tyxdpe4YesyobFlpah8pvFXACwH9KNJpECGxfIZMdydZyAasC3Zb?=
 =?us-ascii?Q?zsPACXFiVN1qj9GlZR4c4imYNaI8U72GnIhNfk5eTs3DFfBU1Wy/8uQIRnu3?=
 =?us-ascii?Q?GAn+dDpNwm3p08t9Vf377njNyevf3vWdIOVzqQGBVqUtx+xt2pOeQJyyU2cg?=
 =?us-ascii?Q?lnWqyeL2o2jRHsq9Qokl4GZW6joz+ebJMvnXZQtFuGHEeSFomp6rE4KjLwt3?=
 =?us-ascii?Q?0N0WThA8BEiXV9Hi9PxoDqBY5R8f8Cb30hRLQSmC2YzsMRko55e0YJOn0rrp?=
 =?us-ascii?Q?89etVjWquOU73whCA2ouzp+yiX3SMgWVhABy/Yd/?=
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5137.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7eff71ca-c7a9-48cd-85b7-08da7a1cff1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2022 15:36:57.8273
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XxOBv6tYHJmEcZTVBm2OATNQ3jkdtcCvFVsDwzBEAJmwYjnMnN/L2x/OpxwBQ4rLRq867uxeep5UMJwa1qfEqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB4105
X-Proofpoint-GUID: XWlCGKlgtXj12yCoTOnhY84Xvu4fbn5w
X-Proofpoint-ORIG-GUID: XWlCGKlgtXj12yCoTOnhY84Xvu4fbn5w
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-09_04,2022-08-09_02,2022-06-22_01
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

> -----Original Message-----
> From: Florian Westphal <fw@strlen.de>
> Sent: Tuesday, August 9, 2022 6:17 AM
> To: netfilter-devel@vger.kernel.org
> Cc: Alexander Duyck <alexanderduyck@fb.com>; edumazet@google.com;
> Florian Westphal <fw@strlen.de>
> Subject: [PATCH nf 3/4] netfilter: conntrack_ftp: prefer skb_linearize
>=20
> >=20
> This uses a pseudo-linearization scheme with a 64k global buffer, but BIG=
 TCP
> arrival means IPv6 TCP stack can generate skbs that exceed this size.
>=20
> Use skb_linearize.  It should be possible to rewrite this to properly dea=
l with
> segmented skbs (i.e., only do small chunk-wise accesses), but this is goi=
ng to
> be a lot more intrusive than this because every helper function needs to =
get
> the sk_buff instead of a pointer to a raw data buffer.
>=20
> In practice, provided we're really looking at FTP control channel packets,
> there should never be a case where we deal with huge packets.
>=20
> Fixes: 7c4e983c4f3c ("net: allow gso_max_size to exceed 65536")
> Fixes: 0fe79f28bfaf ("net: allow gro_max_size to exceed 65536")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nf_conntrack_ftp.c | 24 ++++++------------------
>  1 file changed, 6 insertions(+), 18 deletions(-)
>=20
> diff --git a/net/netfilter/nf_conntrack_ftp.c
> b/net/netfilter/nf_conntrack_ftp.c
> index a414274338cf..0d9332e9cf71 100644
> --- a/net/netfilter/nf_conntrack_ftp.c
> +++ b/net/netfilter/nf_conntrack_ftp.c
> @@ -34,11 +34,6 @@ MODULE_DESCRIPTION("ftp connection tracking
> helper");  MODULE_ALIAS("ip_conntrack_ftp");
> MODULE_ALIAS_NFCT_HELPER(HELPER_NAME);
>=20
> -/* This is slow, but it's simple. --RR */ -static char *ftp_buffer;
> -
> -static DEFINE_SPINLOCK(nf_ftp_lock);
> -
>  #define MAX_PORTS 8
>  static u_int16_t ports[MAX_PORTS];
>  static unsigned int ports_c;
> @@ -398,6 +393,9 @@ static int help(struct sk_buff *skb,
>  		return NF_ACCEPT;
>  	}
>=20
> +	if (unlikely(skb_linearize(skb)))
> +		return NF_DROP;
> +
>  	th =3D skb_header_pointer(skb, protoff, sizeof(_tcph), &_tcph);
>  	if (th =3D=3D NULL)
>  		return NF_ACCEPT;

Doing a full linearize seems like it would be much more expensive than it n=
eeds to be for a full frame.

> @@ -411,12 +409,8 @@ static int help(struct sk_buff *skb,
>  	}
>  	datalen =3D skb->len - dataoff;
>=20
> -	spin_lock_bh(&nf_ftp_lock);
> -	fb_ptr =3D skb_header_pointer(skb, dataoff, datalen, ftp_buffer);
> -	if (!fb_ptr) {
> -		spin_unlock_bh(&nf_ftp_lock);
> -		return NF_ACCEPT;
> -	}
> +	spin_lock_bh(&ct->lock);
> +	fb_ptr =3D skb->data + dataoff;
>=20
>  	ends_in_nl =3D (fb_ptr[datalen - 1] =3D=3D '\n');
>  	seq =3D ntohl(th->seq) + datalen;

Rather than using skb_header_pointer/skb_linearize is there any reason why =
you couldn't use pskb_may_pull? It seems like that would be much closer to =
what you are looking for here rather than linearizing the entire buffer. Wi=
th that you would have access to all the same headers you did with the skb_=
header_pointer approach and in most cases the copy should just be skipped s=
ince the headlen is already in the skb->data buffer.
