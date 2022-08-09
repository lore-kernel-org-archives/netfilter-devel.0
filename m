Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08A19C19F2D
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Aug 2022 16:54:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244507AbiHIQyz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Aug 2022 12:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242649AbiHIQyz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Aug 2022 12:54:55 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F1122B17
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2022 09:54:53 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 27963OVv007038
        for <netfilter-devel@vger.kernel.org>; Tue, 9 Aug 2022 09:54:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 mime-version; s=facebook; bh=/83p4keHHvalYDFh7zUGjFYe4rjILlA+oGD7MokC6QI=;
 b=atE6pdboH3/FkdUvB9x9+wlgfkKEiCO6nhGRlugS6bS2pcvYQubaQVrVLPomXxvUzMGT
 O1W2DLdym6qSwYc3kZuUD8jXieEibJMTTWD/znJkzD8/VX5P0MOXasbNdnVb9IT3nW4c
 STxOSlLRf+EC/3y+4s47Bm80CJilw4WALRk= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by m0001303.ppops.net (PPS) with ESMTPS id 3huhydc04s-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Aug 2022 09:54:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EsDINGD0hymYADwRvXDKyC3aRA7fDh+2zLY5+9q9PzJ9Vs7bfwoeSQWVCR/XC3Umu5DDioZcAiMfXuZ3o/UMiFh/tuvY0vMnjaWslHWglXa0f9/KJP21C++6TUiZKiVtusmzbkx7C976rP2RJBeLJBGY+aNXez6UhlBYKSaH5FbvBKKE24F4IH6f0o5oqznthVbBs/FA25JP/T2wU6yfNTfiz3GEuKddZtWfe8H10VPEUCTAKKLqP0bvJd0/89W1Z7eXd4w0HJEo4LqeQIzZbY2745kR4e2S8lIEZkJwph9QxKvWgUP3kWRyn5j1lejJd5E/S7+TboLGHdsl8jjw6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/83p4keHHvalYDFh7zUGjFYe4rjILlA+oGD7MokC6QI=;
 b=hZ57/nwcYKSO8lMCsK3WzwqfAn74I3xagkadZaQLhljlY8TpKKVQ/TFAzb6aRk6xnGxutL0iyR4W3DZuXtuzJ9OAE6iKwOa7t5khhbYaaB6jhzAu9K2Mi43Ul16zn18YYQ5dTn2fxFzf9Jl68AB+pjARQOgtI1rW9tl06BNlKBNP0IPO6fv43fuzCU0QynOnIP1qnzZZGgljdJ3pL7TdR7fRdi1t9uH3sfQ2mnUpryaZ9ZzZyvYnEMERu26nQsAzOGqmE4tqvIG9OeKrNLtH/0WBp3hZ+cGc5UsqRGbZLqWub7P0yRhAUO8WczX05S3PfY70hxg2Dd+limsOJOUv5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5137.namprd15.prod.outlook.com (2603:10b6:806:236::18)
 by MW4PR15MB4441.namprd15.prod.outlook.com (2603:10b6:303:102::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.21; Tue, 9 Aug
 2022 16:54:50 +0000
Received: from SA1PR15MB5137.namprd15.prod.outlook.com
 ([fe80::c41c:730c:8312:be0a]) by SA1PR15MB5137.namprd15.prod.outlook.com
 ([fe80::c41c:730c:8312:be0a%4]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 16:54:50 +0000
From:   Alexander Duyck <alexanderduyck@fb.com>
To:     Florian Westphal <fw@strlen.de>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>
Subject: RE: [PATCH nf 3/4] netfilter: conntrack_ftp: prefer skb_linearize
Thread-Topic: [PATCH nf 3/4] netfilter: conntrack_ftp: prefer skb_linearize
Thread-Index: AQHYq/JOQ27YKKfNmEKkUJg1t9fV0K2msUmQgAALBwCAAAaGQA==
Date:   Tue, 9 Aug 2022 16:54:50 +0000
Message-ID: <SA1PR15MB5137593CF6DD8CF489DA97F5BD629@SA1PR15MB5137.namprd15.prod.outlook.com>
References: <20220809131635.3376-1-fw@strlen.de>
 <20220809131635.3376-4-fw@strlen.de>
 <SA1PR15MB51371BED076EBB8032CC6F3EBD629@SA1PR15MB5137.namprd15.prod.outlook.com>
 <20220809160720.GA26023@breakpoint.cc>
In-Reply-To: <20220809160720.GA26023@breakpoint.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 213b5208-6840-4155-221b-08da7a27e003
x-ms-traffictypediagnostic: MW4PR15MB4441:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yMuLwW7EYwK0UPPD4e8wvhO9JgGQgWggeRUSwhtYLkzu1aQPDRZgGESHcdGd8UtNvnri6GDjYKgPby6cs2kO1zLsa+KUMF87bNWjixunrpbtvGfzs1FtMZFs+Vn3Z93l+Mw0+mRPjmZfoUj10CFy4vMOLsINWAFWmEDYOUbvji+3BuRTYzhkVySzOTRaCu3oHZoiNwGvSMUzYbqaJ5SOu57rD7kOUTZ5PoVYGwWumUcO1OLZ8kv9MTrHtvygNccgoJ2ZpWeX0d1kOI2QOUlPI1wOFwRZ1REruW0TQgFlfU6Zva0mxWGV0+MJjmNtnb6tmNOJaAPAdGeR99UygY8WqVbJ5yu0p8F8e9yQAcK3RoG7Zgp9WEDSe+qqLU8xdx5luMS7omwZBr5Lw7tGfQ8Dg8aUGH8OoOt9mAGAZe2ouhE6M4Bpq24jgAmxzco4BixEjXkGmjEvADNith9489W4gMAH6CAbIm+MAnr1uRjItgnDXcB3IIGdXBrSpW9CbJlK6/kr3XShCKLk7ChruKndsdKL9tLpVdJZ1vDkbICDk9pT6Y8bLyaq16Vg/bN3n1Fp0h2sGFa8YSajTY9+p4x8RxXk50dlF5PZfBUxzJAC/VwSJwetWnjM0qo2FWj/wIIDhcSsDsy5ZKCM2HMOeFoDPopEE5AlzLEmFS+YgyI8FwrwISa4SF1o/RehGTBSwO5MKn26joaZDieGnF/k5s+8DhD14YUw7Kvxw0FUUVOCa+abMmr8Q6DW7XDFaRSNYkSrpf8+LxVSj9KJ2uaJoddvzF2Q24XFxBm/jEE6jl+AhxwI9VvYL2r3DaWZOuRQsJiE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5137.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(376002)(346002)(366004)(136003)(5660300002)(55016003)(186003)(8676002)(64756008)(4326008)(66446008)(66476007)(66556008)(66946007)(76116006)(38100700002)(41300700001)(71200400001)(122000001)(52536014)(8936002)(38070700005)(86362001)(2906002)(478600001)(7696005)(54906003)(316002)(33656002)(26005)(6506007)(9686003)(6916009)(53546011)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2CwdixNxI7XXz2rE/OwAphe5iZCycRnxy0fbt55KCgqUgDfHTJc+WWhG2XPR?=
 =?us-ascii?Q?zqclaLzccpKO3kGEHulMUfWAa4NTeshJnWPLGfXj/kT1TFIXD99iE9gt0M0e?=
 =?us-ascii?Q?FCxgCrL/QLkxmTvP8dHYao11Zs38nYQ+ovgOPGf7CkfoYAoxX+WxHTcaQgBg?=
 =?us-ascii?Q?J4iwLId8wniAOwOm3AkCfIbO2/edSr1Cz9YK7n+ANCBU8fxc84Wbu1AjAyDH?=
 =?us-ascii?Q?xSlYpgErxyvLd5LeQWyVZW+4aKOreeCPiUXizntJw2mDBNUUsxmcQ7J9T5nG?=
 =?us-ascii?Q?H23otPeMYdqR3GVw1rLWnu5/zJrIt80ituhEROaoNs6oKkHU2yNTxTKofGeC?=
 =?us-ascii?Q?/xRsAqYKCyVROxLyPAzHtR6DPyaoCCO1Unyk7OGSYCsBIs7Y0xDxb/flQEYo?=
 =?us-ascii?Q?cxhuaUajxJuTdedY5UC7mhAu32FfVvIuaGrKBZqmS0BLg+62FEVBRjKvYcmD?=
 =?us-ascii?Q?91oBiwb71ytuPo/w8wjoBFJfeDqdJDTLwye9TIIL/9BeVOX/dt2YfeCgUE4o?=
 =?us-ascii?Q?i8S5+C4y9B9BlVCptv/DzmjN5PcxeXRadM1MsRqXIPUCOLBsh10WIZ8Nx6/g?=
 =?us-ascii?Q?4gNzEzuE10WFBb1gVoc2qwGRNyN8DFbtdAPMs/cJuXmslTHsmCS3ijb6fl7M?=
 =?us-ascii?Q?AwLeeMf1DwPveYSO239oCsgw22AicPQzh6RHC3qneqM4sXwOulSkvfAGd9GX?=
 =?us-ascii?Q?7Fcoi1Fq/r/93k2KzYCA2GajAw1lOW3csYJYLrAOnSRZEbs+ajoL0x8rAgPP?=
 =?us-ascii?Q?zQbEac9/3/7mn0wZ0izAj966+P0rZjbL1A+5/exCgKWsFt1srv6NlpBKEZsS?=
 =?us-ascii?Q?TkqkFfQNGGQE9gaUlSI0CGjP35lHO95/Ay4ls/R3AdC7T4Kj9/ztEM3oyp2y?=
 =?us-ascii?Q?KrFWUVWhcY6/uAVXKJb8rAzKQ1whzx2ecm+MwfeWuEGHz68VGclcyhaIYSkA?=
 =?us-ascii?Q?v3jTbiHFHHNdsW8eKly5PFjoB7K8CW1c9LvXCqJStkNRlFe/JKem6oNCIJ0Q?=
 =?us-ascii?Q?p6pdxll+KfDpW3tkF7obiYtqOr7EnIpmA4TSHiZVFhWhaCuqovhKYSVz7a7O?=
 =?us-ascii?Q?BWzkI/bJyaRyJ6nr0RlyNHJ/iqSyFGcsbfL+xORkIV4uJyrS/NF8+bBdE0oZ?=
 =?us-ascii?Q?mGCLvEZfjfUjEH8YczNAog5WJ9G6dv9odNKTnTGAwKAdIqFS4kfXnns9nP6K?=
 =?us-ascii?Q?53UKKh1MhJWI+AL+LFHHynZgVugiH7wt5Ca053xTnPOXHZflyruWoKl7bLvq?=
 =?us-ascii?Q?nMbrbd9m3wuC+UgLervR6WcejLTaMhtdVvyT6eNzVXviHIPhaeu5ofFoolZm?=
 =?us-ascii?Q?eM5R3tNS/ORn2N9zYlj8CgbsoPOHMTxkkNwTOxrBfudeGd9GGiHv+3ln0BKy?=
 =?us-ascii?Q?e7Gixzn8QlCBHhgC/fRQa65kBnvEQTIqCgerPfbhKxYcmhWD9NgsOom1HOuv?=
 =?us-ascii?Q?uNk4QOux+b5dfkd6xas38u/FfuqpbNIwGJamYZKnYfI2aCniRMwjSgGUPL3G?=
 =?us-ascii?Q?pnvqPfjrUQ54hWCwLNmugFIVzPNPRBYSEe9eLfa6vyGkdECTcWHEagLkCX+b?=
 =?us-ascii?Q?4x/V3VVK7i6X6PIzNRCg+nBR1UCnEXR9L4r+Vobk?=
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5137.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 213b5208-6840-4155-221b-08da7a27e003
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2022 16:54:50.6648
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WOCmSatOu+sKGCxILr7/y0WftZh2gJZrV0Whwg9FDvPcbAyJrmCGJp+HWBzsRm1w8J4xGFIPQ8RX5pfrVcDqxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR15MB4441
X-Proofpoint-GUID: BeLiDLKUmZxucOW3zsxWUQloGLGN2-ME
X-Proofpoint-ORIG-GUID: BeLiDLKUmZxucOW3zsxWUQloGLGN2-ME
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-09_05,2022-08-09_02,2022-06-22_01
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

> -----Original Message-----
> From: Florian Westphal <fw@strlen.de>
> Sent: Tuesday, August 9, 2022 9:07 AM
> To: Alexander Duyck <alexanderduyck@fb.com>
> Cc: Florian Westphal <fw@strlen.de>; netfilter-devel@vger.kernel.org;
> edumazet@google.com
> Subject: Re: [PATCH nf 3/4] netfilter: conntrack_ftp: prefer skb_linearize
> Alexander Duyck <alexanderduyck@fb.com> wrote:
> > > -	spin_lock_bh(&nf_ftp_lock);
> > > -	fb_ptr = skb_header_pointer(skb, dataoff, datalen, ftp_buffer);
> > > -	if (!fb_ptr) {
> > > -		spin_unlock_bh(&nf_ftp_lock);
> > > -		return NF_ACCEPT;
> > > -	}
> > > +	spin_lock_bh(&ct->lock);
> > > +	fb_ptr = skb->data + dataoff;
> > >
> > >  	ends_in_nl = (fb_ptr[datalen - 1] == '\n');
> > >  	seq = ntohl(th->seq) + datalen;
> >
> > Rather than using skb_header_pointer/skb_linearize is there any reason
> why you couldn't use pskb_may_pull? It seems like that would be much
> closer to what you are looking for here rather than linearizing the entire
> buffer. With that you would have access to all the same headers you did with
> the skb_header_pointer approach and in most cases the copy should just be
> skipped since the headlen is already in the skb->data buffer.
> 
> This helper is written with the assumption that everything is searchable via
> 'const char *'.
> 
> I'm not going to submit a patch to -net that rewrites this, and I'm not sure its
> worth it to spend time on it for -next either.

My bad, I misread it. I thought it was looking at the headers, instead this is looking at everything after the headers. I am honestly surprised it is using this approach since copying the entire buffer over to a linear buffer would be really expensive. I am assuming this code isn't exercised often? If so I guess skb_linearize works here, but it will be much more prone to failure for larger buffers as the higher order memory allocations will be likely to fail as memory gets more fragmented over time.
