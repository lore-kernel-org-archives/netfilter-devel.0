Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96793C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Jan 2022 07:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348611AbiAKHpk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Jan 2022 02:45:40 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:25112 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235501AbiAKHpj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Jan 2022 02:45:39 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20B3TB2u030524;
        Tue, 11 Jan 2022 07:45:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=ShVMl2akUnuWFydefeZKlcSDflCeHnsZ6FnK+AZ8OXY=;
 b=hJtTqtdHDDtrqnYMU5rrB6DrrcXjyJ6KofvkGyJR/A0tUKtsEPRVAGSYP5B4hCv0RvcD
 ISpEPJZ3ManOkFbtr2Y5ESN8TngKhIFlf95XM9zQ2brxcEjwYEJy/ZBxV1Tv52GQ1XoN
 NOXgIM8r7IDcapnvhJCQE+kVwUsNNXwhe0WhHVm9NEMiTa9xbiPyRgB0Bc21FWCgKaVh
 noUwVCxsPpVDm4eLowEPZ6JRh81ZS/wlGh7DCUj6hhzws2UCkO9UueSL25ug+S6/CFru
 BWvf8/In+lpwudcNHSQzqZTQQ5yRdyvnDDY9ELpEHki9FB1RESmuVhp8P0bdmx3HwxOy ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgkhx2ec4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 07:45:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20B7eR0e124088;
        Tue, 11 Jan 2022 07:45:27 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by aserp3030.oracle.com with ESMTP id 3df0ndpn4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 07:45:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jhbCiFi2KyEqUzm7W37gn0ZXq56M5NiBuOecNjaO/trvIpsoFxseBpKz5Y7rF+uXcC9ne1coQr/+tHyCtkBD3KVe+6j3+Rv739iBVAZTXd0trwA0u4r+lIAS6OIozsZxddM80jjcj3ksESzgjO8rI4M0DX4KlU37IsQk8sYX0BY6gP6KdeF4+y9EXHK2zFpccrFY2LP+7lSuecVef8QxevlRPFZxTmpBZLnH3nyGK/PoWouoTXvweeNbfM9Xqjj04ZUaEkA7jWh5U7LFmST5RWT6QmlYMlXve314W5atPZeoTWNrQonHBlza7B4Ok2DfneNzp8RL2NomXwb7QyOYag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ShVMl2akUnuWFydefeZKlcSDflCeHnsZ6FnK+AZ8OXY=;
 b=Gs42MJ1+SlgTGRj17DIqjCbENV/WM+OFceUgqsPLy+Uiqq3d5mJ7iKk1tKe2qFM0OsK8x14+jdOpshQCR+WxWi+fluxacP9sIuaUYcZyGa3eydUgAD3avhBnfbE3yoOZiKs+fjhI72koMYcyavMnfR0d2K/lQboXKzicPpjqEC19/USChmQvSUHD0VQ8e58sH1CNn31eFwZO+/LZxhhVueJ6BruFILd0TdpkXaQOnY7keQiheh98tMa+mcv5/pS8vuk7iMXruobllYfy8EGJCYGWoua8rjRyxEvm1CaJP4aSK52ke+jmXv+3Eeh5cyYNErcPX3x5oHhLDKrYjEZl6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ShVMl2akUnuWFydefeZKlcSDflCeHnsZ6FnK+AZ8OXY=;
 b=a2Jak9xMPixpiEbMBBXgDvsQTDLIp/I7+0qTUACG8osQm3ZVwWu/oThi2iFdwMtBVxf8qlRIt0sqrejlQCHtb7LVpAmtWSxE7uvwapfShOHCSUbx62HceDNToxTa6gi07FgggTwjnkK+lhpSBf+bxiQFN72Xp2l84nNgQuzhXdk=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1950.namprd10.prod.outlook.com
 (2603:10b6:300:10d::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Tue, 11 Jan
 2022 07:45:25 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b889:5c86:23c0:82b8]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b889:5c86:23c0:82b8%4]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 07:45:25 +0000
Date:   Tue, 11 Jan 2022 10:45:05 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] netfilter: nft_connlimit: fix nft clone() functions
Message-ID: <20220111074505.GE1978@kadam>
References: <20220111072115.GF11243@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111072115.GF11243@kili>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0031.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::7)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f33b341d-b42b-4606-8314-08d9d4d6547a
X-MS-TrafficTypeDiagnostic: MWHPR10MB1950:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB1950348596F89BCA05C808588E519@MWHPR10MB1950.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:364;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e6gbgOxfg1UVDUzd2xvAQTKrkKZWDsmsNYdTxkUSkVkImBe98MuOf+zQsp3ZZ5LfGSRm3ShKSjDkKQkvpuW3e2xFyDJmCwVBVyCSiCUnt9wA71pxcatQiBB3kJz/Rnbw4pISwhbSMIlj1wAKGmHtk4DRym7tDvN6VFCOxHXT7541l3K/ltjPQJPdQtkAUlfyOnD2A6E+tAoD0/yNRpJRyTuVzQkBw8S05CX+NLWa0n9i9uA7/rUp/H2wVtJKJhJAirUG/KjIs4vD6ys5xaWUvxjiinQ5kSUGmbkNDQkVMlYUdzwt8Ux5D9GA73Y6jrmsnuf/BJcO7iB94VugvEolcnG46JG5WT6BMSpwHfmOqHAL6Z4t901uGeQ01AObH3BOjS0Kze4dZioMTCh4w8y2HXvTCtzcB+NJ2DmP3gDPVuq4P7hcHu5XDVTKlSSCvWkhgcAAy8w5Q1d0YZ3Q/46YEsk1DTf+F8+EVuU1UoLa3Gr+MfHHHmiBImJShxAFOWU9+plIrT1omwyL3n5VuYaY2iJ9NenJBM73GkAfzm2WTIjM07B6AfP5hE16nOFhBdt5TMtEzOT7dIYO2t6nqmLb0Iaye2oK0K3U15xDgp61IUYH/OTJBX9xQbfR3cT4LxSVUwPzrZOIewMMm/kGjiSUog2zalbiznhQfyCyEHwTidGfexCUzC4OlNz0oK02KQSFpAbfnyY5iHeeasfwgikiFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(83380400001)(33716001)(38100700002)(8936002)(316002)(8676002)(38350700002)(5660300002)(186003)(4744005)(6916009)(44832011)(66556008)(1076003)(52116002)(66946007)(66476007)(26005)(6506007)(4326008)(508600001)(6666004)(54906003)(6486002)(6512007)(9686003)(2906002)(33656002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RxQveBNOxAd9vCSi1EMMMLAEg9TWvY+QDwijiuM3dmqQaPVSw3AnobmVd5Is?=
 =?us-ascii?Q?5hempLiM9klaE3cflNKCbNanMeXcPMTrtpHS7yFV9oIF5zc6qdYDMpyms7Tl?=
 =?us-ascii?Q?Z8tj9KOns8g7TvQkBQFjgG+lB7inF5BY2yH7Bz7A0oVwXTWP9snKJIQL6GU2?=
 =?us-ascii?Q?bhzHYt3ac31mWJT/zXgBmsRVauzE7sS0ZYpxJKi5uWK98vK4o8b+u8Hzcb/P?=
 =?us-ascii?Q?JwcsdPuiRDa6tYIpGwFk5imqe1tNuNNRU0VRTuYFabpsHPURvsIoX6Lg+dxv?=
 =?us-ascii?Q?sAEYdW83Ducs8qENRzcuZTzWvi1tCNg8swfSBbyZiun+RRK5eBPZ1pp9fcZ8?=
 =?us-ascii?Q?x7W+prXr61wRLU3/jW9C3dKrHJkTLyYbE60Q/gUPcqVO2SJmZwz6OlxrzONU?=
 =?us-ascii?Q?SmbLGnkA1AvAJpIwPRUgOIffsycvQoOfEe1Kj+wXzsG/0aTz3ATOUf4yrzBk?=
 =?us-ascii?Q?h50GSBBpRzUNJ2+ehITi3/NHd7fyTK3RMLsAXZW5n1UYWZsEk1EMrXhvo01k?=
 =?us-ascii?Q?tX+fN95WwRh+NOWE91r8akrhCzMPhA5Ubwtk3h0prgS6UOH58mxCje5sHWJ+?=
 =?us-ascii?Q?0keo9QyuYr6SI7cktZ61bT3bfBe/Wu8jqNGaC7LIGXkt+OfYVhaGEUDOaClz?=
 =?us-ascii?Q?KjnMBvFMFY0+bIRZxy9J5m2v0eJQPokOduqG4rCoxlsd/iVjdRG8VVrO9mNG?=
 =?us-ascii?Q?G8POqd5cyJTu4yaLCcWhOsK8i8RkXXW9S2TRnDqubKIUlVNq1HRUHLL/x5jl?=
 =?us-ascii?Q?K+Wad7s7rPcCgPgaDI8FADyWV/qN5kjG2EFWS2fZM3p5KYNjWGAbff2dLU9P?=
 =?us-ascii?Q?yBQb4Zfm+GCmbUa7gfoC6SNpeNbksuIs/sW7+ZeZXoU652jC8Btf5vxJNwT6?=
 =?us-ascii?Q?dZH4GG+A56wrYP6KBhBrSSQyesZ8f545X5Xofx1EfE8AGw76IxOLSclWHcsJ?=
 =?us-ascii?Q?0Z8GIZHtS5WeMnvstD9vtSEgGpO2KPduKl8lUvAXMs+R+DvVzTNnGeElnVr2?=
 =?us-ascii?Q?y4dJ5kaSyBFeY8mh7MoL26oS8Qt6CiyoflDhZy/9jpMHNa0rDxPgW6mpi1DT?=
 =?us-ascii?Q?jM6tJw0GbxRgkYFtfsEtxdGU1rXwnQHVZ18RXixyxb+YoEx4vBWwVDYW/bvb?=
 =?us-ascii?Q?JDGJ9reBLikCZEQj/99w5uftpaj9ORMilGucMpEbqVUQd3M7tCuv83OAaovA?=
 =?us-ascii?Q?p15b3TilZrYw4I0gUDoI8KvU116PAaHqEF7FrN0CPeEBOLFNsuE9Cap0lge9?=
 =?us-ascii?Q?cxYSLSetxZgXpKyyTVpdtFch70lDefaBXNR8b485DH3PcRCV7NqaJn8Q/Zar?=
 =?us-ascii?Q?71gW7yBvUNKKpGxduUc0iWKClkp+9d+pN3qNAyMpHTfrJJCsCcxx71rpyXi/?=
 =?us-ascii?Q?ifZlcgUSRUvU16MWgNAhjH8LywvpqdD1r6lbDklUQoJE8Yd9lebyRqUlqBmR?=
 =?us-ascii?Q?PFmwIXq6pO0Z1Bq9aCEbn2f8j9+WTlAvYJgTFe/sgv0d3HkUcujW87lm8cAe?=
 =?us-ascii?Q?LGrRpu4mBGCd3fWON7FeioD6X3PCjJzeVgV2rE4dAymVd8QthFrcv477GyDu?=
 =?us-ascii?Q?Nk5Jh8kcQhFQzDOMV+vvg4eQa2tJ60LvAhpaY4nyI2sOhEFvMMy2CgrFIGdH?=
 =?us-ascii?Q?NZBcGk84v2ojq4pBmmCE6coG/KlRWuJoJbO3mjxlra9+fcU1kfoeRs+PXe4f?=
 =?us-ascii?Q?Wzc3Waht+WgoAlCw7UU/4HOUwW0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f33b341d-b42b-4606-8314-08d9d4d6547a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 07:45:25.6290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QSggO1W0J1xigWdn9j44ynM5kS1Ore6peW9gDalqMvrK5pqSsS8b3Z9FfopImDKm2LiKRgHFhlWezZqIqZI9tFxc3PZRQVHfUalTT74oUBQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1950
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10223 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201110041
X-Proofpoint-GUID: GfvWxdnQw9SUDzSJoi0IG7k_FUWT72Qk
X-Proofpoint-ORIG-GUID: GfvWxdnQw9SUDzSJoi0IG7k_FUWT72Qk
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jan 11, 2022 at 10:21:15AM +0300, Dan Carpenter wrote:
> These NULL checks are reversed so the clone() can never succeed.
> 
> Fixes: 37f319f37d90 ("netfilter: nft_connlimit: move stateful fields out of expression data")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: fix a couple similar bugs

Gar.  Nope.  Missed one still.

regards,
dan carpenter

