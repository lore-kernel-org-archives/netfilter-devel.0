Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB2B2C25B06
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Aug 2022 00:06:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbiHEAF7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Aug 2022 20:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiHEAF5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Aug 2022 20:05:57 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF6F1836D
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Aug 2022 17:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659657955; x=1691193955;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=v7jGSjvv+zKRJ3swGRcRyogy2JYh9IoRylIiXzubQj8=;
  b=WL8P3MA4XvmLeej8zRVQXiHH+78aAb4B0tYkDtNJw1TrW37IwfYsjBJB
   6TcAb2VpRaqQhTIY4J/HI8bG+DM/viQtPeDT31GBTUs43lVuTU++/vH1i
   FO8usi2GFC5Q5M/q1S26plzNrk1LitLy8uWqdf+8upZI4LIc68x6tBuc7
   QzOID+IidxfhJkY4rTd6sexpuU3GdV6thPW8C6FhreQiqSYTVI20afk/N
   pMsb9a4arR2Y9LD3GZeLwn0Jor6+bmD+i2aCS57tHZIiXVAUT9nO/WLJt
   JWfi4Ac2hMvHo1xMqsWbNTZIRNHN+VRGPX7LRD0d79393miStXEDLq2Cw
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10429"; a="277004154"
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="277004154"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2022 17:05:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="729807422"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga004.jf.intel.com with ESMTP; 04 Aug 2022 17:05:55 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 4 Aug 2022 17:05:54 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 4 Aug 2022 17:05:53 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 4 Aug 2022 17:05:53 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 4 Aug 2022 17:05:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZNpiUG/MAbP9ZQd1m4aKCLR0JUfzc9VG+Mn52fnbOsOn5UM4qw0i3FQQfyS/1TNxD7IcuIVNMvO0cb4X1dwk5ErQr67cajMJOmkI1SfpKhlctXi6nDIGuT5AJbhSaCfa+biPLrrGjmqAMqyk7+qNaUsmp0o5viIzWM4KbvG0vwrdyiZOt0eZgNQmCdR+C54WytRpDLs8ZsU4Qdzx0D3361b9GGhmntXMCshb10HBU95fqAN9KsWUWHurlmvXhtwsnecQla/CeVWj9/aOtqYg28Bx7BAY2puLeIKHQLTsC2K1OeeQhAcPs+gw9UeM5zOfh/5RRfGo+cM0yyDyiJP/Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nmFRQuo1F/2KDP7kWEh9vUvFlQa98DGE6YL4p5nDiAw=;
 b=VuG4yA1RKNTco7Drm3oDkTJ9JxMHolNoQ/ScU3EWyOoYsxK9MZhH1DLhV2dV9Y2JWR7YZLjywyXEABdzLzAg4doKEijGiPAK2TexYZwlfKMjlWPsu528bpSmoGF2CarKS2NBpcFYX1NSEbl1mCZ6IgpNhlKZEF2XD9xIPoZOh8/OpAUgpXwSYCHUjAQeh41alWr84dyRxkzNZHYEau8EbCPMLAU46FqcxLTKq+JtZ/6P0rJUkMSAFW04oGRJ39rxjrarv1VMFX91pznXUlrREQMspJIetq3U51AwyqNRsnLVwDbnLD8HNpI/JwX7HTSQ4d5ffV4uZswUhnF7SrCIww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MW4PR11MB5890.namprd11.prod.outlook.com (2603:10b6:303:188::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Fri, 5 Aug
 2022 00:05:51 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5504.014; Fri, 5 Aug 2022
 00:05:51 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jan Engelhardt <jengelh@inai.de>
CC:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Duncan Roe <duncan_roe@optusnet.com.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: RE: [PATCH libmnl] libmnl: add support for signed types
Thread-Topic: [PATCH libmnl] libmnl: add support for signed types
Thread-Index: AQHYqE5oQqk2q3Yqek2h8HHGmEwAwa2fZTmAgAAH81A=
Date:   Fri, 5 Aug 2022 00:05:51 +0000
Message-ID: <CO1PR11MB50891EED7CE4B1427F30FB04D69E9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220804220555.2681949-1-jacob.e.keller@intel.com>
 <q7301nr-3q5r-q54s-o9o7-r19104226p3@vanv.qr>
In-Reply-To: <q7301nr-3q5r-q54s-o9o7-r19104226p3@vanv.qr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ffc74964-5fbb-428f-769b-08da7676422f
x-ms-traffictypediagnostic: MW4PR11MB5890:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yCFZ6l9C3htq+QhSwGGtfFBtCujdNrdZ86QKu+SHqFrJ/3Inud2i3hW9UpL71cnKW0LHLJuAMq8BW2nydSZ1c/PP6z1PCFutr2IasDue29qVS6IrcmPVQ7Us1Y/cju/zOfCHMl8B4QsPsNLIH0/r9fTG7XaTM/JCLASAJmyNgGI6madSLoIkASMxM8V5ZavC80HuhhEORiZpEIikmV4xFyfIfj3JCjTjzy0+FLxyPErUIVKAoNPHYoV8615iUELWxcxcK78PTeHASySWsF/vy2IZbDEsNgGjrgV3j+bLwOXPSuEI8y1TJj1E5r59WWx32TnaxUm4AXzjCb4MPJvY7ReL0I64TwRyq5yxp4+Fvn8Hq1DAUK7P8+OTTBSZXdG/MW9YYVc1rO7m7esmpvxmbuDNLp8MiTGq8TlJKUGGGegM2Oma+quTU30nAArZohPDyLTdwIlTIG1Y4wK62aq14zgPKShAPxW5gRhKpj9n7zonacWXv7zLorn40M6AJwzwl3WYMKCe/hKiGJJ4M8+rmOhXd35EgbRUS1bgqQSKHKdo4cLC97x2q6ZDJslieQEUiKgEp7YV1FJzUKWMcZ0zx9il+Il/ruiQVQSiKHCu4eOgfMEOtaKEQ8l9pK0VqVCxpS2kr0LUnEPUVEDKq+l4DzJ8kF7O9a/bOfbyIZFkc7SGGvyY2WUWIMkA2U3lDDml8SZvPrqPzpL9tMAjMtbm5H0mKHs0I39FuI+ioC4ctTLfLoN9YdFtp8Ym51hwJ+SdVFUggHo9GEmU2o+muAADOZlbqoLmCrWP7I3UeS0AORFSfTVHZRBDBp6h/KSJbNB5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(366004)(136003)(39860400002)(346002)(186003)(54906003)(6916009)(316002)(9686003)(122000001)(83380400001)(38100700002)(26005)(53546011)(38070700005)(71200400001)(478600001)(55016003)(33656002)(76116006)(7696005)(64756008)(4326008)(52536014)(66476007)(66446008)(8936002)(66946007)(8676002)(66556008)(6506007)(82960400001)(86362001)(5660300002)(2906002)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nYkpQ0WZvaL+w2kh9WC3vHH9I8R1wb4I2/qDvcfLsRbNZTu9BOQUehf5uoDX?=
 =?us-ascii?Q?Jh95a2/8EW7Lx4vN6PGJY4ao12FUaikz/t90qaA+WTQgseV2zM2l2Mlclj/B?=
 =?us-ascii?Q?uevJN9FOuJLct+wyuG66A0SySngalPfLNhBCo7BvZ4F0M6YotC9gW2ZIxyU9?=
 =?us-ascii?Q?ORoBaG10ycI3pzeDR9UqTICKXDJfPBQrwpG/B6dZ4YDFQEMATdLO6WKIM074?=
 =?us-ascii?Q?4+dRYSfTHKM9IFWX2FuYMJL35NFhWCnE6N9DzHV/nJQ5O4UCI2shQMSfHl+r?=
 =?us-ascii?Q?Qdr5LJzK0ZNdj0jRNaWG7JJ0IcdgMrzz2dVBiYFMMJB3D8uH5KYE+KhFlZEg?=
 =?us-ascii?Q?hvulwqO3oW/tVsiJR9wPA9sttwsg97BfX0rMT+tAJ9JlWSuM8FBobqjsDmi3?=
 =?us-ascii?Q?vaRhGUBF4qGjfwlCro167wFWx1HUGH81m6etImljBE6ve9xBXVnFhDMFBsjH?=
 =?us-ascii?Q?O6FvNReLllFU4mhfh92S2BAWGmHGAF/z4ziyJZlRxlb0lAL/r4j/lzTGpS+/?=
 =?us-ascii?Q?7UyYkImjG5+tenSZWHjoSdvesz7PgYjtgWxH/4fOz0ixBqnVh+9UimQjF8x0?=
 =?us-ascii?Q?Y9Zu8Ut/MIhxpd4DLHB95TDycofhtVf3BSnee8tijVme198t2jAwRcurKvZZ?=
 =?us-ascii?Q?ppq0V47coruZNhXh4DzFGSxRYS8u565ekjMdNwYugVH+3Wv8IWplpBmajtau?=
 =?us-ascii?Q?QITw6WwL8GkKg/rJcfNfgMTylwD1bNac6AfWwH+7Y1KHxGH5oPO6mlD2cE5G?=
 =?us-ascii?Q?p6Lki+qgJ6XJaB2e3FCvut1rL69eFZXAuQKvx8q6gMCxp69SgiDDWNZOomMO?=
 =?us-ascii?Q?aETQvKXWoS1J4rdVfEWlAb3f5149GS+FM4rad1bA0VITJtrwvyB2mYnzxSis?=
 =?us-ascii?Q?R9b+UWTGr3+9EhvrrTHEZH8o9fIphQqnRmYSPjyFlcwwSrSIZ7LOCamKcpEV?=
 =?us-ascii?Q?Ciw/8+21Z/0is1T+zfpi411ePGtpk5OVep/qYFQ3xSdmsgzkfiM1rAAa1DPl?=
 =?us-ascii?Q?l6yUabdDpkkAmvk9Y0t+c/4DHK2+XJwR3PQBZpnjaMRB6Sx9irAkVoXgPE1q?=
 =?us-ascii?Q?LyzmASyR1Z2D5Xpay8Tde9SkFtBZS5pHCuUzW37CX8zUXhPk5qDii4GG1lre?=
 =?us-ascii?Q?0naN7bsDx/2umu/Ayx2b5/cTYppCfjo1fIwHYydDi0xnWf+Us6Llqo0Vhk03?=
 =?us-ascii?Q?LP98eSnGB3UZ3iYKBk2PAkpVXEG3xkO0f/qPB1WWubtUbCPtjv/O6cfwW6hP?=
 =?us-ascii?Q?5JaPyq4J7ela8CsD2eUlIdEFcuL8Zqmlpg6hGLj9mpZq4wvOUmfRfZQc3GJj?=
 =?us-ascii?Q?L+7NDrzDcp2Xjo92BlnJPd4+Dg69nLxPuzomvx/Bba+fwOkOnVbvcRbd491r?=
 =?us-ascii?Q?hueBPsJXhfdXLf8PVZStF5GpjBEJ4L3+QgPExgVmL/87aMUDGAQWO8yWIyu4?=
 =?us-ascii?Q?k8zFOAIN6A/YuMLRhwywtuIrnDh/H9hmEwUvC2RGnNboYj05CH8D+SSPd3oE?=
 =?us-ascii?Q?eFlDd1kboGfPlsjPGdfQ6sfr16WwFdPeBb//10Mrws3PgZriaZTipb0gD4yt?=
 =?us-ascii?Q?skGNgF4yh25xraKPHxrYgzPE4MRtNBjvTqRjsVLl?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffc74964-5fbb-428f-769b-08da7676422f
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2022 00:05:51.4346
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M2Dn0EQI30C1oYXDg9ajhXJkpyy4f72u7jCLJJpM2IDcUWnSk6NeC1w1smCN3X6zGnCMFTnBePx2jYzhiWA3Y3NAZiR9BKfIv3GEr3eiqc0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5890
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



> -----Original Message-----
> From: Jan Engelhardt <jengelh@inai.de>
> Sent: Thursday, August 04, 2022 4:36 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>; Duncan Roe
> <duncan_roe@optusnet.com.au>; Pablo Neira Ayuso <pablo@netfilter.org>
> Subject: Re: [PATCH libmnl] libmnl: add support for signed types
>=20
>=20
> >+ * mnl_attr_get_s8 - returns 8-bit signed integer attribute payload
> >+ *
> >+ * This function returns the 8-bit value of the attribute payload.
> >+ */
>=20
> That's kinda redundant - it's logically the same thing, just written
> ever-so-slightly differently.
>=20

I guess I can fix the unsigned wording as well then. This is just a copy of=
 that but converted to signed.

>=20
> >+/**
> >+ * mnl_attr_get_s64 - returns 64-bit signed integer attribute.
> >    This
> >+ * function is align-safe, since accessing 64-bit Netlink attributes is=
 a
> >+ * common source of alignment issues.
>=20
> That sentence is self-defeating. If NLA access is a commn source of
> alignment issues, then, by transitivity, this function too would
> be potentially affected. Just
>=20

This is specifically calling out the use of memcpy rather than just derefer=
encing the pointer address. The default NLA alignment is only 4bytes, not 8=
 bytes. This is exactly the same as the unsigned implementation, just copie=
d to implement support for signed types.

Thanks,
Jake

>   "This function reads the 64-bit nlattr in an alignment-safe manner."
>=20

