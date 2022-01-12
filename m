Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6537BC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jan 2022 06:27:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350983AbiALG11 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Jan 2022 01:27:27 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:8780 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231773AbiALG10 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jan 2022 01:27:26 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20C3OwSQ005856;
        Wed, 12 Jan 2022 06:27:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=vlaMazm/xII7aHSvcaml4LrZ1ax+JbkUd+FT3oKZlrM=;
 b=grSqls6dNCPACD5mwQ6dvppvqkLeAeGFtiEsQavObi8+OYS2cEG5NiWWGLabfg8lARVP
 yaDQnkrNuyU2Fiee5C9WzabtIUP+DKHRTEfXrWcw4Chc88vNT4BbHg9Nvn+YDWaHAPCV
 6iVLLUg+SOPtbBa0vAuzm0VQmXuGzhuokMueJlZsFyE5cDU+BqRfzClQCYKPESnIEfeZ
 RryMzHdMW9z+Wxlhmh35g5mtoliGlifTobiLenQiMpYrfcD3YxMyWxkHWf5BvIb2dcJg
 tigX8t8A0VzQWsHW1e5U80QR7r1sQ/83uHbZy/TAuvGbFVPf/jGi4ThvaRp6/i16L/2z Eg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgjtgdmc0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jan 2022 06:27:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20C6G2mx046190;
        Wed, 12 Jan 2022 06:27:17 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by aserp3020.oracle.com with ESMTP id 3df2e5twmv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jan 2022 06:27:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ciVe471lC6WMTlZPq8rVssPW9KEa+41agrXKDGZZCXtx5GMTpHc07KAVaW0IyMd5/T09RFQjsRSlsfByrsW5Ba0KNKOttl4W9lWYyREkUNH+H5OGXRlhXEq64lY5+QWDWoI3ko9zmZvfs/HgTtBjv2D1AX8v6OrIRmtXL2u9qTXasU8dBDAvJvYySFvbtdqAknTLpxvs0hnZ4E1worcKIrJJ9UdIg36dTRci0CRmGaksb/hjDXv0WwGeC6F49TWXvPRVJw1MwRQJio/firrUTCWxLSAbE9gI39xEHi5UTZ+mOTrkTKbLNn40SKkZRBkSedTArjycA5KhKw3gd4mCdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vlaMazm/xII7aHSvcaml4LrZ1ax+JbkUd+FT3oKZlrM=;
 b=Vjpqrsq2pbugKELm/FDjpct2kT0BbVcvCb0XLFShlPzjIQq04p11mZUxqd1h7I2rsDDdb700F+lENExLCIzUPxRY5zpWbLkpsTS4wr1Zj5IgUvZymKj2XTE8Df7NgKwMTPiw1tiAKmPxH5o8NqWJ8L8aoLf3vMF1P0gx3c/bb8wsOhzlMg9kTme40Dg8xDmYFgY28TSkwGqHpp82EEy9UvXKA1Ll1+SRJCItO/2D6BzdpT4VsBTyAgAbfgdR9+DrbEQZ5r2QJYXqWyOKNzlCTFQSUbaEh1EtVumeCzqoGV6p44FwnnrzGvEnF1DzGapYRAs+xbqFKsS5MDzeSmTTrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vlaMazm/xII7aHSvcaml4LrZ1ax+JbkUd+FT3oKZlrM=;
 b=f0Az1r89SmbJ0ChSqtFZcEC8Q0UnPn90QnJyoHVQyGputkkNjJSqLoZ6zcv3SEW5yNulVZ/IoO952KqCiuKU95U6MTVhT2fSPg2YPM2STd7rqp69gRry8gfTVMxYPqWmKKxrhEdfX+pK7sR/mxS3BwZurXIRcRGuUp8PeLeiXro=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2400.namprd10.prod.outlook.com
 (2603:10b6:301:33::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Wed, 12 Jan
 2022 06:27:15 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b889:5c86:23c0:82b8]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b889:5c86:23c0:82b8%4]) with mapi id 15.20.4867.012; Wed, 12 Jan 2022
 06:27:15 +0000
Date:   Wed, 12 Jan 2022 09:26:57 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] netfilter: nft_connlimit: fix nft clone() functions
Message-ID: <20220112062657.GE1951@kadam>
References: <20220111072115.GF11243@kili>
 <20220111074505.GE1978@kadam>
 <Yd1O9RPFe3xlzztN@salvia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yd1O9RPFe3xlzztN@salvia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0014.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::26)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf6bfb9c-102f-438b-3d62-08d9d59492fa
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2400:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2400249C9CF43559C2DD171D8E529@MWHPR1001MB2400.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:758;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mUl8t0jk/CLY/rsQRyKsdT7Bv1tYva/IzhV/hRP2jHVceOIKjQZo/YjV9tTXlsusDy1OHYxSuFV9VxppTLrLnYQzjTN0CPu7TQvJxB5ez3lP6RgCXEjreLKrbA+jfAqn5DksmpewKq1ijPRm6z006MEyokJ38uNhDlKvw0BqL+50wOm7tM4RvQj38IfE3YxHrF17yqwdS8QBUPRwPdXSN596N2/3azHrVvRROykcXhmbyvEqgJxRK+KS5gcKCH1ujEC2EcG+kvpm/Die0Ty1L+uWIo/2qot/yZuZOeyFzGwT68mG2HrDZjfUTv86efy+sIto+fM5+9lma06aavn+WW3JPuRM3sjEhXMKQL188KzRln1NgX/iCwKrn2WSiWnBjLNc2RURQcs0aPWheZFim9CfvOuOjqwLTzx7KhzmtVHUNgyIDQJNzWuKZD5RWXfJKxOx+HGgKIR/9asJI1zNV8pHT62kSiNoYblSmRelpn6AWVKW5wlGytQ4gLXeTGT6rCN/aFdU6/Jkra4+q0LP/DX9IUyeRg1fTZD/Vv1uxqe5bPfmUdsFes8m58ICJlc4WDmaeA4tInPC5Lr8T2Ri22PUmeyMY2S7yZs3tHXXhtixODViWFvcASoe3+pmYzc/hkw444BcyiaCQ6bQ5xAQ+xuS01ETfHTA8i/POBk97yEnJB8CJLdqlAAX/qhvwA18IrarJ78UfDXXaoMn1sluvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(6486002)(66476007)(5660300002)(86362001)(44832011)(26005)(66556008)(4744005)(4326008)(6512007)(33716001)(8676002)(316002)(33656002)(8936002)(9686003)(66946007)(54906003)(6506007)(38350700002)(186003)(6916009)(2906002)(38100700002)(83380400001)(1076003)(6666004)(508600001)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WCNZJyUfLbMd9SAekYKyEFf2pmjwlMpRrjkNkcVhnKS745XRZedp7/+p8Nnm?=
 =?us-ascii?Q?06Bne9S7FwTeyNIXBaZbXWzZZHLvb0n1RuNnwvof0kPGpE+/sBssVAM4hk6Y?=
 =?us-ascii?Q?hpCNFEHLF31k0UHjA1ixgdsW/MppEaJkxJUNPntefDGDwbqbCc0gP6rxANL6?=
 =?us-ascii?Q?Ni8zcLzYQN5SoxhhAkQtcJjnUypR5tA+rMoXpZ3OFjx4kP3iu4zvmMnEk4Ou?=
 =?us-ascii?Q?altnTWKEeIA11LR7+yltjfbg0qLoagDLFTujbPsoGI1MYbhl/So3mcuwsr3K?=
 =?us-ascii?Q?m5zMqbv/vIRx8yxDpszg/ZG6sl1EQ9e19DbcyPa9BcM8J/mUcS5/aix4TBz1?=
 =?us-ascii?Q?rDWp2TVaTh7UP07TICO1vbQZ9KCxnnon90L38FsNp+uHCFp7859eFPHSOPDT?=
 =?us-ascii?Q?Be7UsbAR41CJHVttGXkxwSxYGAQ0z5jmZzpuUCn7oGRQ7DIoNFl7g9Hq3x+R?=
 =?us-ascii?Q?fi2PPFhjPyj3NMLt9lr8YZBdGD9Gb2VTL7Mu11a1WgRQVBPcOzd58XMV3KIb?=
 =?us-ascii?Q?lqmO2GssnCO4TY0FSr/UCfj1+3Da8+e+Be0z2yw6k3gSJwdoeun4sjMmqJjw?=
 =?us-ascii?Q?cwxLS9i+Z3CMMXT7G0sor1qAvLb4+fw9IHardnplCmACOcGD36/Yueo9HdKc?=
 =?us-ascii?Q?miG9vEMl1asS8RgBlSvsh+odpqUhFS6zePp/aEB+VxItaaP7n8XYi4GP5pYz?=
 =?us-ascii?Q?9xzwYvmWkoGOfJDPXW7dz5nTTFL0kpd2RJQ8/CbZeyr4zRNmpC6rFuXuR0jL?=
 =?us-ascii?Q?rIBWYW8ZBVHVp/XudHIxFKo7szOe6j0tdFWaaNAe0DxSIMrevD/cqouVOemv?=
 =?us-ascii?Q?ZWt3inwMTvpeNX49ikYB1UaY1K86//wh7AAVSnKYglMWnbHJoVdY/sXJYEgB?=
 =?us-ascii?Q?+bzLDBcmJHGbcI83EQhhHHrFUawVMzq6J5MKdJVy6nIIYIrcfofBNgtYX3Nb?=
 =?us-ascii?Q?ubU9Ahfy/1mvceHSRGbKWhHQyJN3pLrIW7zVFfBPD0UVMuxRvV95vRZRWXO1?=
 =?us-ascii?Q?IiMCPrwWwo2kJAbkcmU4zhXvMqyWgn1nGfoNsst2mb4sqjfvJUj2AbiCoMU4?=
 =?us-ascii?Q?1qauMb9t73F5nFsNQHyWim4/deo0N4UW+c3cscvRl3ACCSmdV63bTyOK9UoA?=
 =?us-ascii?Q?1bCoKuw2EUKKiriASZXQr0e5ij5jANgzy1Dzvxh51srMdeK/AxKN94Gf/IND?=
 =?us-ascii?Q?TKhTb8IGSzNcxJ39fgjRD+WbQgqE8htOtGGh84R4TruBDoh8PKjUgm991Z/X?=
 =?us-ascii?Q?moGvS9K5mCxWiiEJaXbC/SBjFs3yoBDFOm4x5hftCv5cWFEiw7+Ski8MlOir?=
 =?us-ascii?Q?DmjpQZnigYEo7EhfbWUufuDsg5xnn9iCuwDY3lR4SiZ8YcJfQX0xHyTb1qWa?=
 =?us-ascii?Q?biim3eP4JZBbdNkH+MoFqQBxspcNd5MOEF5l1yv3GIy089f1xVdJTg9d8Gsc?=
 =?us-ascii?Q?cSDyqrChER5MgYtPJnnQEERXB/i9DnKXVLezHgc2GXYgFCtmNNqqIlLU7wtJ?=
 =?us-ascii?Q?L6ersrZwyv4wwv0DKgDaC8UlohLBrJ2KwDlq9O7E373Qq7nfYLjPE6ndA6RV?=
 =?us-ascii?Q?lu2Dt8XsxXKpkYtEJ6VicZzw1ItClC9qp/1bG2iQPyAToVh8bcggYlrc56Lx?=
 =?us-ascii?Q?QdC5hy2xID3BphSO92k7Nk4PiGGXcCyRplnxV7wuwZRflsWXMYmELblU3pBn?=
 =?us-ascii?Q?KVxRYX0SkBVc6SjwB+KPWheWKQc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf6bfb9c-102f-438b-3d62-08d9d59492fa
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 06:27:15.0041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jv2cm5NJvWDbtzhZHElCtV4bPL7cn+vDsH+aUyTMFsjgfhdVetNa6t9HdDoCxpOM0PqPEUxX5o0lJev05m+WJ+ahmXiLgKM9KEGo3EKAhHk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2400
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10224 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201120039
X-Proofpoint-GUID: V5g85GqzziI8RVt_BULo1cTX87eTlI8z
X-Proofpoint-ORIG-GUID: V5g85GqzziI8RVt_BULo1cTX87eTlI8z
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jan 11, 2022 at 10:33:41AM +0100, Pablo Neira Ayuso wrote:
> On Tue, Jan 11, 2022 at 10:45:05AM +0300, Dan Carpenter wrote:
> > On Tue, Jan 11, 2022 at 10:21:15AM +0300, Dan Carpenter wrote:
> > > These NULL checks are reversed so the clone() can never succeed.
> > > 
> > > Fixes: 37f319f37d90 ("netfilter: nft_connlimit: move stateful fields out of expression data")
> > > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > > ---
> > > v2: fix a couple similar bugs
> > 
> > Gar.  Nope.  Missed one still.
> 
> Already fixed in net-next

Maybe I misunderstood.  Are all four functions fixed?

I'm looking at net-next and nft_connlimit_clone() is still broken.

regards,
dan carpenter
