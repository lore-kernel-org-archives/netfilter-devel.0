Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9C5FC28D13
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Aug 2022 11:10:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbiHVLKM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Aug 2022 07:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233926AbiHVLKA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2022 07:10:00 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 314B232A86
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2022 04:09:59 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27MB3ZM5025986;
        Mon, 22 Aug 2022 11:09:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=hElAGjlCKJHel/7zMNWgBn9H4AooSg/t5xr7Xr2sxC0=;
 b=NilHlUyhnkY0E0to6NGVvr8S88O6rCNJxXKZx5l8t3zlTUTxewD1BOAmWzpWMXSDg9G+
 nWArbLa5RM6VYUAs5h530AVeyaMZaJwzsAepRe8whBeYfXWR16+0nnLWncuAFNxdbTsD
 NvX8AB/7WJC/GQgbOzdYn8JfoM/jNsn60fPqhUv4GaF6jyOscdehxHH+iCTmMt9ysgxe
 hiMlRKidj1UTrByJFc5xX2jyi+0qdHQJxC7JkPNkEFyp2hpiIUQp7wQJq0A1/yVlFCfE
 JkjQ6sDjnzsiL7xGDwOGCDGyGSlnKpyyN6ezNiMa3gSISiMBYZuaxcsaJnNn0jvNDo5D gA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j486gr2f1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Aug 2022 11:09:45 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27MAO3Eo036130;
        Mon, 22 Aug 2022 10:55:38 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2041.outbound.protection.outlook.com [104.47.56.41])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3j3mn1mekg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Aug 2022 10:55:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DeObLzoIpsyGbbwcFd86dWSij6hghuU8EJbLjsqEqiDe7zx6w37lClvt/7vXHQnrBHSiXxNDUj9n0WhcQ9dafZc8w+9XEACw6S+uVLuT1VEtO39dccW/FWlZjydtUyQvEuCSnPaaAUEb070InfSgPc+ADEwL/E1aDygVkDphS0zmilHEfQN+rYBvF7rkuh1NJ/xrlBiX9vFlG5o3D8ZEjaPwU+J2OqNdKf2Hn98fbyqNtXBwcElEv6JUOazovYD1diWLIobSkWGKsxFzzZKc3+DQwDGHMR4D3nwrcPJ7wFgkR6d7Hmlj191ECvtX7U57HQrruMbYb10TQQvMawFYVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hElAGjlCKJHel/7zMNWgBn9H4AooSg/t5xr7Xr2sxC0=;
 b=NUToltIgfkwUI4Y4eQv/e9w6g/Mv1GZAXEzx5vxYum/cVFQXta5Ni7MomUYSYHfgOHWdy8QCygCQJQ7MvlHQ7lFurBfogyeHlF7iSVcb67HK2Vs3yvZmBmIJ542KYgxYdc8PA87qrQ3k0p33LuYsdsOktJzRw8gia5cX6GDF4eICAvsJoV1o8bYLRPVeDDr/QX1011gujG/BPfIbSyJldnz8EYXosU+TIt2Z9IQ39FlHFXXISufzIu6ZjeMvYUowzqeEv183FGHLBfovMp1zepcJfBrTyORYq8cCxzn5aR/8N6IBwuiqCEK7T6BsyoxgcokhXpmQH8RmZw8jm/S70w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hElAGjlCKJHel/7zMNWgBn9H4AooSg/t5xr7Xr2sxC0=;
 b=Zgw7bobh1prk3RO60Svmn4U6DYPbGPWj+3qAqwo2QbB6aDOSiljh9DpwiZg8rJWc/SpTEUlPxcJM2Sz55BgBV7q8DgAtPbFdw7xzBVK31b4qMsEkMUutudYwXph4mMZs4ztLqS+//pI9T8TOg5vAXyHJp5l5mGMZkdLM+6WUbUM=
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by CH0PR10MB5324.namprd10.prod.outlook.com (2603:10b6:610:c3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Mon, 22 Aug
 2022 10:55:36 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::d0c6:fa96:addf:6112]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::d0c6:fa96:addf:6112%9]) with mapi id 15.20.5546.023; Mon, 22 Aug 2022
 10:55:36 +0000
Message-ID: <744aee39-390b-6743-839c-28be5a64dcd4@oracle.com>
Date:   Mon, 22 Aug 2022 05:55:33 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH nf] netfilter: ebtables: reject blobs that don't provide
 all entry points
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Cc:     syzkaller@googlegroups.com
References: <20220820070331.48817-1-harshit.m.mogalapalli@oracle.com>
 <20220820173555.131326-1-fw@strlen.de>
From:   John Donnelly <john.p.donnelly@oracle.com>
In-Reply-To: <20220820173555.131326-1-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0020.namprd05.prod.outlook.com
 (2603:10b6:a03:254::25) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 850f3a66-bc19-45cb-1b66-08da842cd7ab
X-MS-TrafficTypeDiagnostic: CH0PR10MB5324:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LByfMuONN0hoAb9e7lIVYDECtN620sOi3j84ZcRPbGlwhgQxtzNZVNVGRMoEH5i5+mCKLJV6bGxg0/5jGUN8EDZgYHgwlKEq2pHVTyzkM+5c6OMDuok275FuyChAoOInAoLU+3pq+Q2ZwumhGKkkhw3ZZ0eMnci2lDOSHUJyHC6p8ULAd6IDTzm6dh5rXWwHJiunSIHJG1P7CBNlBhLF8E0eqgee1lYDY0zEvX7oezoah70fC80EGJCli7UOtQkuEhDyuK8AfizB0O6sYJQ/bu/mBAZOgRvQsZNbMORhVENE3rsGNdjlnqRPyuw7R2KvBNqNOak5g7LH93SAeQ9nZQo6EDIYbQfntnhcQRaisrgJ1K3VH3Kc9vSQyw1FtrXbtFmOZVyE5HBfiv+JF9/nSFbtGTWk1f19A+nNYLw1eyDcdiLLal11VxBSOYA/aqDINOCT/nbU/QZqtz2nzMQ70erSyhRLLXzIkquKA2D5N+wC9peoXdNCfO9zFYoMf0NloIZahYoLObzx7WqANZGF5TnC7bwCnzQRSlaeBr3z1j7W8mSmWZCTNu4QNuLDMwttVaj59dxKCxeaLoFklU3abRmv1yy0GDXI9fwWntYmziuepFZ2YwWMo+tB5vZ+4RTcLuUR5ee0e9bm9y8Ic4xaflexjDqOpei/R3tCcpcjo3n2M+6kINM4xFHBDZr5cICWi9mL2YYl2Kwjw8CYC1Iu6YWowSaR1e6i6BwR42eVhAwm5aCSHWmqab63duhAnMd+KdOb7qqAyGH6DUki4lQL5U0LKUJb+DeCYdHHmxWui/w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39860400002)(346002)(136003)(366004)(396003)(8676002)(4326008)(478600001)(6486002)(66556008)(66476007)(66946007)(6666004)(41300700001)(2906002)(31696002)(53546011)(6506007)(6512007)(26005)(86362001)(2616005)(186003)(5660300002)(8936002)(316002)(36756003)(31686004)(38100700002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dlNzTG1scS9Vbyt1REJoa3VXU29jaERMUzBQTDFsMjRUVlB6cUJ2dTdiNjhq?=
 =?utf-8?B?cE5FUldkY1VHQW5ldFNBc0lQMzBzSVdwYW1sV2E3Znhsc0g1U3lUNHozUDM1?=
 =?utf-8?B?SmNlT0k5T2tOc00rcG1Sb2MxTU5yZG54VTQzRFFiRkdUV1RSSy9ySEJBZERH?=
 =?utf-8?B?Nm55a2NwRUEyZUNoZ1R5MEpEUTJVaVpxcUZvNHpneSswR1V2N2RwVEFiMkdt?=
 =?utf-8?B?OEhhTktJY3lWS0o3Z3FCdmMxV0EvRVVyREJzWjVvajRtRXM4Ukc2WnJnMzIr?=
 =?utf-8?B?dDlmQWFPUjBZNjczWHl1c0RtbkRvR1dLRmUvSlhra2VhQitKQ1VBaU9FeHBj?=
 =?utf-8?B?WkszUnZJSVFEL01tV3ZoVk9KbzAxRWs3VEZ2cmdyb242VU5DWHlXUnV3Ukt0?=
 =?utf-8?B?MnFOSk53NWNKZGhrbURQdEVjTDRYZmV2V1NFcXlxNXdVKzZlRzU0d21yeUpx?=
 =?utf-8?B?ZFQ5OXJldmFMVlpJYzFOM2pYcXkyVHRWL21YRXJVKzNFUDFDYjd2T0QzMWdX?=
 =?utf-8?B?dTF1ci8wVmlmOTVJQ05SY3kyTmZaOGRqQ1BMN3FCTGE2TFE2UVVMbjhQMDN0?=
 =?utf-8?B?RElmeURkbmRnUlB2bFEwYzlFcmZ6L2ZCR1VGUkduUWJHNk9lQ3ljOElkNW5S?=
 =?utf-8?B?SUFoSGRWK0tMZlJJZDBNdUp0YzMrU3pJUkVBLy9SSFV3TGJGMjlUZ0EwK1lT?=
 =?utf-8?B?QUJISjR1OE1NUnRIVDgzRHUwamt5OWFMR1FqOG1tbjJBaUhxaFJNWTd5cmI2?=
 =?utf-8?B?elhUVHlQbUpjM1hmM0lsd1JjTU9WUWdGVjdWeFZ5OUprYnh0YkNzam56eEJZ?=
 =?utf-8?B?TjZTY29OS2xLWDRKU29qb3E3SjVwV3BwclloTzJpVmlwaUhNclNFRW1Pd3hZ?=
 =?utf-8?B?U1plV2dPNlhaZWtXWllwb0o3c0ZveUI4b01lUFZqSWhYRUdrbVpJSmJVYW9z?=
 =?utf-8?B?NE5SM3FLZ2Yyd0duZU5vclc4aGRtbmtHR242NFpKbjZRaXRWL3lSZ1ZWT2Na?=
 =?utf-8?B?QnhDbjNPYktQeU12bzIvQXhSd0JzQ0g3cjV5MVcxWU9YNTRYR244NlhyVk92?=
 =?utf-8?B?WGZrK0pzcGJPZHAwSUd4SmVHSWNhTWhpekFxNzJZeEp5U1A5TkFTbzROaEgv?=
 =?utf-8?B?MEdzU1JiT0hMUmhTa2R0Rng2TmNkY3d1NFlxejFUN29vVExwSllnSEprMnA2?=
 =?utf-8?B?bC81cVVyN0ZVSEU2eXZKSTRTbHFrd2RnaE9JTi8zeVljc1pwK05WKytXbW1i?=
 =?utf-8?B?QzZ3NW4xOW9JWUluRFpycFpLaTd1OTNsRUhUZUNXWUJVMmhtT2FoN090V2t6?=
 =?utf-8?B?bHNJR3JBeEZSSUFMamxKTUgybmswQjBydDI5RSsvY1h6cVY3TFp1aFQ4RVAy?=
 =?utf-8?B?WUo3ckhVTVBvWHd5K1loK2FKQUlNZzdLNnNTRmg2T09CVys1aFZFNmQ2dndq?=
 =?utf-8?B?SDZnVldHdlNzdUlpZUZRbFIxTDJGWE00WitOTk5UNGcxYWlCWXUyRmxHeE9M?=
 =?utf-8?B?WWtyMnFhblJFSjhkM3ZTbUtEWjZaZHhtSlhVQmFZZEdpRXk1N1pZV1ZMcmF0?=
 =?utf-8?B?RnorQnkxWHhPckdhUCtZOFY5UUluenM3Z21TcjBPWURVdVFoTTdwUTlwOHFV?=
 =?utf-8?B?STZaWEV0Q1NqMm9ycnpNYThQYVI5VmZKVGx2SFVudjVWYTFaS0dEaVNNaFhM?=
 =?utf-8?B?NGVBa0dNYzZHYXN5NUxrUlBvU2xUcW9ydVZkOXBCMmlMdlVscFBCRXZ5bEky?=
 =?utf-8?B?UExLNTk0c3RJdDJNejQxdTgrTldKRy9NTklqNGR5Z2hKczhtYW0rc0QxZ0pa?=
 =?utf-8?B?OHlFOTU5SVh5alNFSUtVRTNaQ1BjVmU2WFZ1TGZvbWJPMmd5b2w0K3RMdTUz?=
 =?utf-8?B?Uit1Q2NvN3JjNjBsUzFPVVp2bDE3UmZyZHk4U1dTdGQ1MGRsNm5sbVFkVldr?=
 =?utf-8?B?clE5RzNZVXVyV2hmVVQrZC9yTmtIWW5BQUp4UzRrN3AzVHFZWG9KMTNQNUtF?=
 =?utf-8?B?MFFhZ0QyNEFPVUtqRjg0VnU2MEo0d2JrU1B0aUFjb0VXTVVwU1pLUzRLQ1VJ?=
 =?utf-8?B?eEVZN2JTOG1yTDVEYUdOMkNNUFZzcVZoYUtrQ3BBNGFLZ29QV216U0lvODh0?=
 =?utf-8?B?djc4b2pXVWVwZ2FocURhOXUxWjhNeWdKUzlrS0ZMaGU5NEFQMjlXeXBUUHhK?=
 =?utf-8?B?N1E9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 850f3a66-bc19-45cb-1b66-08da842cd7ab
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2022 10:55:36.3881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q99wcmSgoYvOQr1RGhi6A0/H0QqxhNCHWgYZIIiJF3yEPn+IxVt1UxsmWmP7ZuEW0RyGyHB6iP0GlVSsegAg7Ip2Jzd42JkBqaujekrR6I8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5324
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-22_06,2022-08-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208220046
X-Proofpoint-ORIG-GUID: Ciq74hL1GrP0jHSn9eqRuXFWry5N7-jW
X-Proofpoint-GUID: Ciq74hL1GrP0jHSn9eqRuXFWry5N7-jW
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 8/20/22 12:35, Florian Westphal wrote:
> For some reason ebtables reject blobs that provide entry points that are
> not supported by the table.

Hi,

Could you include the panic dump noted in the original message and note 
it was found by KASAN+Syzkaller testing in the final version ?

Thank you.


> 
> What it should instead reject is the opposite, i.e. rulesets that
> DO NOT provide an entry point that is supported by the table.
> 
> t->valid_hooks is the bitmask of hooks (input, forward ...) that will
> see packets.  So, providing an entry point that is not support is
> harmless (never called/used), but the reverse is NOT, this will cause
> crash because the ebtables traverser doesn't expect a NULL blob for
> a location its receiving packets for.
> 
> Instead of fixing all the individual checks, do what iptables is doing and
> reject all blobs that doesn't provide the expected hooks.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>   Harshit, can you check if this also silences your reproducer?
> 
>   Thanks!
> 
>   include/linux/netfilter_bridge/ebtables.h | 4 ----
>   net/bridge/netfilter/ebtable_broute.c     | 8 --------
>   net/bridge/netfilter/ebtable_filter.c     | 8 --------
>   net/bridge/netfilter/ebtable_nat.c        | 8 --------
>   net/bridge/netfilter/ebtables.c           | 8 +-------
>   5 files changed, 1 insertion(+), 35 deletions(-)
> 
> diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
> index a13296d6c7ce..fd533552a062 100644
> --- a/include/linux/netfilter_bridge/ebtables.h
> +++ b/include/linux/netfilter_bridge/ebtables.h
> @@ -94,10 +94,6 @@ struct ebt_table {
>   	struct ebt_replace_kernel *table;
>   	unsigned int valid_hooks;
>   	rwlock_t lock;
> -	/* e.g. could be the table explicitly only allows certain
> -	 * matches, targets, ... 0 == let it in */
> -	int (*check)(const struct ebt_table_info *info,
> -	   unsigned int valid_hooks);
>   	/* the data used by the kernel */
>   	struct ebt_table_info *private;
>   	struct nf_hook_ops *ops;
> diff --git a/net/bridge/netfilter/ebtable_broute.c b/net/bridge/netfilter/ebtable_broute.c
> index 1a11064f9990..8f19253024b0 100644
> --- a/net/bridge/netfilter/ebtable_broute.c
> +++ b/net/bridge/netfilter/ebtable_broute.c
> @@ -36,18 +36,10 @@ static struct ebt_replace_kernel initial_table = {
>   	.entries	= (char *)&initial_chain,
>   };
>   
> -static int check(const struct ebt_table_info *info, unsigned int valid_hooks)
> -{
> -	if (valid_hooks & ~(1 << NF_BR_BROUTING))
> -		return -EINVAL;
> -	return 0;
> -}
> -
>   static const struct ebt_table broute_table = {
>   	.name		= "broute",
>   	.table		= &initial_table,
>   	.valid_hooks	= 1 << NF_BR_BROUTING,
> -	.check		= check,
>   	.me		= THIS_MODULE,
>   };
>   
> diff --git a/net/bridge/netfilter/ebtable_filter.c b/net/bridge/netfilter/ebtable_filter.c
> index cb949436bc0e..278f324e6752 100644
> --- a/net/bridge/netfilter/ebtable_filter.c
> +++ b/net/bridge/netfilter/ebtable_filter.c
> @@ -43,18 +43,10 @@ static struct ebt_replace_kernel initial_table = {
>   	.entries	= (char *)initial_chains,
>   };
>   
> -static int check(const struct ebt_table_info *info, unsigned int valid_hooks)
> -{
> -	if (valid_hooks & ~FILTER_VALID_HOOKS)
> -		return -EINVAL;
> -	return 0;
> -}
> -
>   static const struct ebt_table frame_filter = {
>   	.name		= "filter",
>   	.table		= &initial_table,
>   	.valid_hooks	= FILTER_VALID_HOOKS,
> -	.check		= check,
>   	.me		= THIS_MODULE,
>   };
>   
> diff --git a/net/bridge/netfilter/ebtable_nat.c b/net/bridge/netfilter/ebtable_nat.c
> index 5ee0531ae506..9066f7f376d5 100644
> --- a/net/bridge/netfilter/ebtable_nat.c
> +++ b/net/bridge/netfilter/ebtable_nat.c
> @@ -43,18 +43,10 @@ static struct ebt_replace_kernel initial_table = {
>   	.entries	= (char *)initial_chains,
>   };
>   
> -static int check(const struct ebt_table_info *info, unsigned int valid_hooks)
> -{
> -	if (valid_hooks & ~NAT_VALID_HOOKS)
> -		return -EINVAL;
> -	return 0;
> -}
> -
>   static const struct ebt_table frame_nat = {
>   	.name		= "nat",
>   	.table		= &initial_table,
>   	.valid_hooks	= NAT_VALID_HOOKS,
> -	.check		= check,
>   	.me		= THIS_MODULE,
>   };
>   
> diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
> index f2dbefb61ce8..9a0ae59cdc50 100644
> --- a/net/bridge/netfilter/ebtables.c
> +++ b/net/bridge/netfilter/ebtables.c
> @@ -1040,8 +1040,7 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
>   		goto free_iterate;
>   	}
>   
> -	/* the table doesn't like it */
> -	if (t->check && (ret = t->check(newinfo, repl->valid_hooks)))
> +	if (repl->valid_hooks != t->valid_hooks)
>   		goto free_unlock;
>   
>   	if (repl->num_counters && repl->num_counters != t->private->nentries) {
> @@ -1231,11 +1230,6 @@ int ebt_register_table(struct net *net, const struct ebt_table *input_table,
>   	if (ret != 0)
>   		goto free_chainstack;
>   
> -	if (table->check && table->check(newinfo, table->valid_hooks)) {
> -		ret = -EINVAL;
> -		goto free_chainstack;
> -	}
> -
>   	table->private = newinfo;
>   	rwlock_init(&table->lock);
>   	mutex_lock(&ebt_mutex);

