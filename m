Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCC7EC433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Jan 2022 05:28:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245570AbiAKF2P (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Jan 2022 00:28:15 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:44378 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232010AbiAKF2O (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Jan 2022 00:28:14 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20B3TFKi006807;
        Tue, 11 Jan 2022 05:28:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=+qe2AMklcn2NNceKkDHQiOwvZAVdJF5UuaQMdWXigv8=;
 b=iYOUsLDv9JmT6Q2da8fXZ81G6tHS+aBQlaP8vStt9BfyxxYB1qQv39nyASizSH2qoiB9
 W4d7sUon8s64HlWy3Ky5hSMUCmn5Fk3HGi9duuNCDM+CECej1KWQWOCdXddDshCNlhT4
 vMs4JPibtusPIvuQI0IpbvwKg34zy3z17HWOpkTqUK8l0/OWg3H6JlScbsPloqjNpocM
 BCmTgw8/SFd0Xbl/RlV3c1AUatydpsx2qdosSJBIgh3qDA6rLl862rw3VikVYeM9C1E3
 sG19r+KLBXw11mgnAzOAznfLBt3xGt5b4dcRO9g9awSTClELAmi6wSi1woedj3j6aec4 RA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgjtgad12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 05:28:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20B5Pevx018234;
        Tue, 11 Jan 2022 05:28:08 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by userp3020.oracle.com with ESMTP id 3df42m4h82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 05:28:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X88hfJQ0o/G2omJU4wgUVEAkkHxrgJXFZ/Ii5d9TzvcfLn53gHu4Fz9+TdfmDwG2vtpH60zUAJYRFsGZqncXfRIiGG8zlT3+0wMyhK4St+X3fNLlPlkVjDLIm0+k4BE3yqOBnQ3aeKZNP/JPn/b/b+vNqqX6bx1DD52M5YI54xVAk/jWFQ2bvj5iXoCFgpMSFYBRmw1mL1WnpTBdrP0n8nHx3Q0bPZt16PqQjaEqVnOVErojOQXD2z9OGXGOT383DwnlkIRo2rmjVavg39mw2GPF8tHUH2OudLj6MBqOap0HvufXV5XSiKonZNuFA1uiu6/fZpqdiyGedS2cMYw85A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+qe2AMklcn2NNceKkDHQiOwvZAVdJF5UuaQMdWXigv8=;
 b=F/yDDgwC6D1Qh0/G4z7+++X88DswIVLmMrapyPVQ+QGne7/xsuAQGWQ5Y0bN3zVozhecwTao6jQ74bfua5Fk+3EZUt2tU1X4EUP1zrku1oVIRXVKc4VuK/uCL6BxrO4TpVFr6HJr2Dd7/D1B8skcetsJuQd7+1H4M+Ux8aTs415OoJbmMq2iKZlAiJ32/V/+kJ5QvPoHCheExeNBO+n3poEPxCXc7MPnxoMI3NPFez7l5/cIhrI0P5H+jp5dlp+sv1BjkQXzJQPmXzizXfUQS7M2B2fjmDBnVhw+GXTVtHCugGwUdJblf0/Tme2Qc9oX9WQ3QpgLbmJLK4VvnbazIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+qe2AMklcn2NNceKkDHQiOwvZAVdJF5UuaQMdWXigv8=;
 b=I6M239sKHCrJsFD1MBbguNj1By4jH7oq+f9W8n6+PZ6jz/ZVJ3AfBdj2A65EYAWSJtjLYsh0xcSPAUxwlVd5gLVhAqLVP+Oth4CcDm1yy7t6cBkAugsX8pNrM1Kt60/RhYmzZYjj58z3aAfPIL/WGnlRoTZ0D6FxxkNnSwfuSLA=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MW5PR10MB5808.namprd10.prod.outlook.com
 (2603:10b6:303:19b::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.16; Tue, 11 Jan
 2022 05:28:06 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b889:5c86:23c0:82b8]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b889:5c86:23c0:82b8%4]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 05:28:06 +0000
Date:   Tue, 11 Jan 2022 08:27:42 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: nft_connlimit: fix
 nft_connlimit_clone()
Message-ID: <20220111052741.GD1978@kadam>
References: <20220111052234.GA8186@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111052234.GA8186@kili>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0002.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::7)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9db8bd2e-1922-43e6-6bb8-08d9d4c32543
X-MS-TrafficTypeDiagnostic: MW5PR10MB5808:EE_
X-Microsoft-Antispam-PRVS: <MW5PR10MB580825DB4CC0609FA89F7AA78E519@MW5PR10MB5808.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:99;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qxGYcQQbkS92wuFaMryskQKpdQa3KnXOf9Ue6C28Ns9L+vEVIWHHVV4wjbAjzDyXRcmo9WVYGM/l738tpnD7D5ybu7DDuqFpgpQvmI2Z6B5C/inVc5lWip1u4QrZgfBjXBwQkVysv7WZvbb2w++4alMjSKM/AmNKrVnPGEX2My5QPbVjpGuK1f0s+oy8u4LYnZQ5aTMMnVAZ/EqC7WwEzQSLONBd6PDfdLFyFamlZHRLDVCPtZ1+EBEuuJJmtqvHThpyxKkA+qcZB1O5n+mdNr2AyEWtcFX26CPbLLEGSpACGp4gDA3IdLmGOydKQB9SJPUAIX/9R3EIgW4gWjG9+Xshja1ozAM/1ORV1vrrfDn/W5j/rGp/zogYeXgByVQDgX23clgozpwtINoLPbvVTqUXdvNCIGadEVHQHumWLWdI7I68dk89wpGbQpIAVPge4cblu6iypBtEDetWvtBjq9+SIWzNrWhkFwPpH+5kwI45pDSOpuMkDUJEjQSG4Dtaht8aTVT5FrhRoeVYDUO+DGHAriVBXbdhWDeHaoathrU3mEuY5/lIJBqAosV56RmajVRLQupE7uuInKI7UMXXTMJznv+6YaV7c2IBt9rfyp33hAEiHJDS5+ssVr9R6ocSxzvqqvSiK8TyP980BCK0jCDywknTlSTRaMg3r7fAREQI8lfmE7z1QTNTNGa3YYoR6rPncFKUorFAUos9lSUjmw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(26005)(4326008)(508600001)(6506007)(8936002)(52116002)(316002)(38350700002)(33656002)(2906002)(186003)(54906003)(5660300002)(44832011)(8676002)(6512007)(1076003)(66556008)(6666004)(9686003)(38100700002)(86362001)(66946007)(83380400001)(33716001)(6916009)(66476007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+QU35aqkMYzjMX6k6KzSI+94WZWo/iOK//ZhG4v6ykgUBU69H9p5ey6+lru/?=
 =?us-ascii?Q?Z7GUbySrD3g/k8O6q7/KN1DnGF28yjH3HLvhdszi+UBZIcWU1kyAJWt789yV?=
 =?us-ascii?Q?VPny6HLntUqjEYyxbuURMcGNJNMP87mQNrroTfg8qblKzoCVcfSesq5Gqt1f?=
 =?us-ascii?Q?2/u8eTVUau/GZC9Z12NxjJsgNIIPmZYSDvGJFFGHus4DqKmH+qssctEPR4Rv?=
 =?us-ascii?Q?Gj5Mw0T0C9PwkMJfmR0TjbAlhPM3CCxPeLSV2pHiBxXzZMGeEmgr9O3C2hcJ?=
 =?us-ascii?Q?TNKlE33QQlDcti5jLxTPdMdOsYN66GdKcNfezMpiE7wfEiU13A7ovH1Al9RE?=
 =?us-ascii?Q?rRL0cjoDCiamRtHjG2UTa8WKOKF5F2F5KtL4XdtZ23RbDNzF3kXpaEgYcNZz?=
 =?us-ascii?Q?oCJEYDtWZsorLpwL0Z/ohfGeovlmZ9pcvGKCkN8iopun84QS2PuRw+N/Oh1f?=
 =?us-ascii?Q?AiEG7VwB+s6JCTjqgmY2IxQn9UYJuULd269+mtZSOFp6xZovDCNGhKGKawIZ?=
 =?us-ascii?Q?qkBlya7/XoJ6nvKfdQneFBISOLPRyj5nfKhvhUppACbboEIJ9UZ+bjDHXUNK?=
 =?us-ascii?Q?1Mzzb7iH8Rmd5vzI2F/CNG7SNZsrI/228Du4Xv1TiH3ahG1HGxuSNPPh1n+l?=
 =?us-ascii?Q?6r2LldaQJOY6EbELwQHSWOhQfdrAweqwOZ09uZW5RmHJNj9o3OOmPrIlFHbV?=
 =?us-ascii?Q?JA4ElpVgxTd4qntJPjx9nlKTBeM3lb61Dp53Sm1p1F1+KC7A28TtQo8YqTCL?=
 =?us-ascii?Q?6TpYsy6vClO6h36+xfsKkWoJkzMVgqOUsit9/M1jm4kL2NdBvuKIlu02FV7v?=
 =?us-ascii?Q?lCgfHq8ZPKoSpAHKjWwCGuSEghvCim/Fzd0x2B1FKti4zVUJCJ+1fm1Pam/p?=
 =?us-ascii?Q?ZIomGTiLkyafXEFau3XpuvZDVuGSdfWIXzO8lPnBzrXBP6rXPkMcApPqRPYg?=
 =?us-ascii?Q?p+0MZ0cFTH0QEC6Ea3sAm7u1/JFTj2Nk0houW3nQGxwOVxZXmUrlxQJBL814?=
 =?us-ascii?Q?fXMMw9wMImh97Uws9+Fs2Bk/iMDOrNxZEVLXhagLf9qtzqPHZTw4tQOm0+Oy?=
 =?us-ascii?Q?I8iyj+fNDxLPwfUDWb/muB7pooRycLjtLIVHSghQNMKVMtQ5m0oX3BtXwkQm?=
 =?us-ascii?Q?+xu6/13CMhfCa4e/rv6/97D7ZCIqfigsQVI9dUATP/0lpygBPaxxEBZrZtqw?=
 =?us-ascii?Q?PelB98Z3XP68lM4zCuIt/1fBc2hGS1FIYpM/HIBHX5iEop15qfFLoTgSRp+D?=
 =?us-ascii?Q?141LD3kZeDMvsPprIsCLbGHJeQdMjW8OOWrGT77SQwYcD0ee/xH3E3jzmcWu?=
 =?us-ascii?Q?xb5b4sMyrRWJxBE83LAPx9Eu+Cb23xtQo7Aj5LBbu4i/Hsq8kxUFZMkiZPi8?=
 =?us-ascii?Q?E+C2hlXD4YdpeVKvn2GvmEgz6Z7mugHwGw54ijGKAUR7kOvBMFwzb79ozZnY?=
 =?us-ascii?Q?+brPYJ2bJUz2Tk6An8MyA6nhB4MX9RUI7IhvV50B7btuvDPeHm1op9bSDCni?=
 =?us-ascii?Q?LoJgLH2V+yf7Sn8uMPJ/UgUha8ZP4VnJupt3kA8F56Qy0pfhwl10PvfqYk5h?=
 =?us-ascii?Q?/LeCrQFqyQpz0TjX0Lq3XV6Ipigk0y1Y5mN+/5MjXEm8nOem7cmo18RO6Ohh?=
 =?us-ascii?Q?sJGxEssPrQD+68tdcWh6QGFugz9Cf1nqCoczWKG1ZGW43H9ra8RmXmgD97By?=
 =?us-ascii?Q?Ya0aQa8+i3+v1RXrXc8VThxGvwU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9db8bd2e-1922-43e6-6bb8-08d9d4c32543
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 05:28:05.9459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gIBkfHRg1xWpmdUiiHFWdfy+o1mT1EoTZLvgtw+rmAFROEjQqUqRXh2QBny7KVE/8o8xs+7kHCPuC+3eXJu1OTkM466QPN8kQo1PENg4Dnw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5808
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10223 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201110026
X-Proofpoint-GUID: Wp0_s-0pV3Knz6vPj-xVqGsHQp91kcaB
X-Proofpoint-ORIG-GUID: Wp0_s-0pV3Knz6vPj-xVqGsHQp91kcaB
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jan 11, 2022 at 08:22:34AM +0300, Dan Carpenter wrote:
> The NULL check is reversed so nft_connlimit_clone() can never succeed.
> 
> Fixes: 37f319f37d90 ("netfilter: nft_connlimit: move stateful fields out of expression data")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Haha haha.  A couple months back I accidentally reversed a NULL check
> and invested several days in writing multiple Smatch checks to make sure
> that never happened again.  Everyone made fun of me for wasting my time
> but who's laughing now?  ha ha.  <- me
> 
>  net/netfilter/nft_connlimit.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
> index 58dcafe8bf79..7d00a1452b1d 100644
> --- a/net/netfilter/nft_connlimit.c
> +++ b/net/netfilter/nft_connlimit.c
> @@ -206,7 +206,7 @@ static int nft_connlimit_clone(struct nft_expr *dst, const struct nft_expr *src)
>  	struct nft_connlimit *priv_src = nft_expr_priv(src);
>  
>  	priv_dst->list = kmalloc(sizeof(*priv_dst->list), GFP_ATOMIC);
> -	if (priv_dst->list)
> +	if (!priv_dst->list)
>  		return -ENOMEM;
>  
>  	nf_conncount_list_init(priv_dst->list);

Ugh...  Hold of on this.  I'll send v2.  nft_last_clone() has a similar
issue.

regards,
dan carpenter

