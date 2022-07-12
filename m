Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6001C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Jul 2022 12:45:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbiGLMpv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Jul 2022 08:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233089AbiGLMpj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Jul 2022 08:45:39 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F70B0272
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Jul 2022 05:45:38 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26CCDfwm004899;
        Tue, 12 Jul 2022 12:45:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2021-07-09; bh=0fog2H8vXlltsXrUeE3NHN4ePF991taiQeoUyf9cQM4=;
 b=aXtOih5xtRHCdrwnUrDKGx+Bc+bC9eVLaxe5AsozVBSigzL3eS4jcBUh09AT6cGEkBld
 IkpQOGlAt/knVZW3BrThQCj7MQGRQrHi7I/lZuLC3q+sGH9kehC/1F2tXMND1FzvdM2D
 8NaHI/buJgrf1genv7gyOoCL8KNuJyRw/toHnxmNt4liK35cIspT6tsbSSQrbHBYhHno
 GkKedvCL7AjFIVDONJja4WbgrU4PUkTJJ0cLq2J6nfJCV0KewEm0ZH5p7y49pRdrqUPp
 FF73EoJXLGDx2HIn5CYY8lzTNrzGsucPPq4MgxppwQRShCL8bJV2XmMDHvblUhl5SqqT 2Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h71rfxk2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jul 2022 12:45:22 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26CCf8ga007347;
        Tue, 12 Jul 2022 12:45:21 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h7042ww0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jul 2022 12:45:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BS8Ap6TEwBqC/q8/ue/EcaRIeEt5DPnYukGDplBIM4rQxpM52Dnj4lw3h6z5RWuaQ9Wy4gssisJN9qujj72HL6mqVmGhs7Jwa4+A6vWQxfFceghnUeQ1AlGsUBuHcPeUwdj6152A1+JUcXBKVQmL90VYeU7oc3G7Ub0HPHYo0HuHKRGVYFRW7W1BzsaqC3vXr8/cqxrPSwmiIauzY9POrBTyJEPSv1/eFJUu1AWdkcenRpBsm+aJQ6jRiX0kI4H47TdGBJBnSgDGLYQQheZvbfTOpCb5Z/nGnkVf6kERwbW0pZm1WeAn1mZdDu5eFWXOcAL/yaOqZZxskDQ9k/e4YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0fog2H8vXlltsXrUeE3NHN4ePF991taiQeoUyf9cQM4=;
 b=hvbKJvVVW5rC8sZ0mT/B3A6y+8T4eD9ybO7vghagxNp90Zlk2ZtFyCzn0l3KwGcgVUbYrGJ0FCYzMUMvazU3a0GGf4imk8PjMTsxRvIpG3w4lLTBpyxYZVogeQXlryBUyM5HFiz+mi0V4crbYgi+nIQpU/RULvt9XjLVIcOYNIreB9z8C5Ftsu2AZX70ucBPQoP32XyQtUh0PouB+4W3AlWIrMk6P1em/hK4Tti2/FRSZ71nercmX3LQ528WKWRvBWf+4Yzwj4Uubj64kcGn4F4jr774O8DfjGnGDiss+LvrOp5KrsnXKFOuhNvQN3QRsD1e96MBTG+MxOrn1CWOPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0fog2H8vXlltsXrUeE3NHN4ePF991taiQeoUyf9cQM4=;
 b=ZYtBmIm2z7GNnLhGcsHhL3oeAZkdTclMYurV/ixcgKbqD08tmFmInNJCNS5M0tZgQgxBi9dO6Z+Z/8RGV1tWcosaP9zLI/PJ6EDgByg5sOZMCGOFVZGuAfDSQszYg79mBHJ6OC7fo0qbqWytmF61614sKsk5OduzY/IrINbAxzo=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DS7PR10MB4941.namprd10.prod.outlook.com
 (2603:10b6:5:38f::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Tue, 12 Jul
 2022 12:45:18 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 12:45:18 +0000
Date:   Tue, 12 Jul 2022 15:44:58 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@lists.01.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     lkp@intel.com, kbuild-all@lists.01.org
Subject: Re: [PATCH nf, v2 1/2] netfilter: nf_tables: release element key
 when parser fails
Message-ID: <202207100802.TRaePFrj-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708100633.18896-1-pablo@netfilter.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0039.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:2::27)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1828eae9-16a1-4a58-9537-08da64046020
X-MS-TrafficTypeDiagnostic: DS7PR10MB4941:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vi77gnM6/JMcSslZxx11UdHzdJvbeRxGdGaLUklZZxuc9i5hWsUGEMCyvGgA2BEsHJ2Hi7ceBxsH1NR7IiWMNV/ozlDjApwJdO/TPUtDWo5/RReQJwrhk4kEqkB5iex+Bc/4hPv7RUJkf6mFJoDo7Vq5GZ85QwuALQ7me7JGyblEk4ZgU1FcJHJJ1IxlhlU2i4Y7VEjXxyqLLube79+jHhQU3KJMfyfpkXdGUqPoJynzikYmJM2KCJnNt3zyAE2U4BUgRrcvJQJ2n2y5Dl6sqAZD5mYa/W2piasQ+IosAEvpHjH+9d3f+YL5B+70zwtOGfPsjdc3KYPucAwkf3PZU2Qs0IoY2XXkmX8Ygu2mDCn4XMaB4gaUYWR1NmKx77ofHWLpOBjOXnAG7A3jjRaSI7I51Ve5am5wCYr2ZmMEfjB+uQqEfppJt4Nm6BN/g1vYnVzKg2bosua/TxOuZRJsE1mFuNxWBaVvCWlrwyHdMKAHGKSYFknofpKqZrm9TNLBO0KtAL5e998iYGBhTKxUEikjQa6XEYgtM+LcwByV2RjqGNUBiZ9I2qvlHC6Hh3YWqTqT9h2/H7spejDZOiOdeTJ1V8D7IEmO72Z9FahEZB/VxKeBOOwhcAbzfNWFhMMDcLgnUYL5EDyFDfYCCttvuq6DcKSNlhlScn7BOK3nvj5SqSLcYo8TX9pBcor9jDUQ6ryH6S2OKkQ27z/lp+ssex289ZG0cc2OvG59jGfNQil7CJHx1oWLJj11+DhGc+Pv7XkESwCSio0nMxcxaCIk6mhdIfVnh8tUqZvJN14++eOkACzEpyKlycwVlXsfBJ5Yx8QuGlIU+ichA+5tvr6hZU+dEb+hNlVYWw59A7OZvjPviOCQFDWW6kmyDW2GWGkb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(396003)(376002)(39860400002)(136003)(66556008)(38350700002)(1076003)(38100700002)(83380400001)(66476007)(4326008)(186003)(8936002)(8676002)(66946007)(44832011)(5660300002)(4001150100001)(36756003)(478600001)(2906002)(9686003)(41300700001)(6666004)(6512007)(316002)(6506007)(86362001)(966005)(52116002)(6486002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HT2fo5BunY12QmD94B/uV0XjbS8RqQhhBpWyrBTNeSHlMI3PwBoMEKJn0Evz?=
 =?us-ascii?Q?bbLEWXNJAULuoX+zx8eti0Cg75CmOkDGJLZQlr98gXYwizoE5vIRKssUzGbl?=
 =?us-ascii?Q?EhHSJTQazx7krRtW+4/fuKjNPMEiwfz9xYnuKfrB+Uw+pAv89GSE8dJmN95l?=
 =?us-ascii?Q?BfhKXp1+CnuYOTNC5Gkmt6srU6MAq75H5ProMu+j21gI+3F8ogk0Ek8/aaDd?=
 =?us-ascii?Q?UDe6XX+xIbFZ0MK+ZtzSXKN6KVnzVNgo4Tsvls4ywZvn4r6UJHoWUsrC0LWr?=
 =?us-ascii?Q?r18LtsOQwN3Adpwl+h/To9sSvHDK/Fi0D5rkDfnDAefMMrLwCLlnIKLw6tLw?=
 =?us-ascii?Q?nJG3mvXYEEcztQzkzV1fzsL+ztkouqqtP47ySUvXUTvSfUCiBm93HJerMGA4?=
 =?us-ascii?Q?3d31DjkCCop7zAyerK27cWj3FdmtgUvT1yK6ydu/UEXMWRr+4WmhfeuvHFTX?=
 =?us-ascii?Q?2qfQbWUBRV3gO7IEV9tIZjN5347jQpyyh0o9vv4V5tkYWMm9aOUz6io1zvf7?=
 =?us-ascii?Q?gSqF3fraJC5kjH/bKTsNh0wWAy8l9LGgqdaSnRWZPu4XT3NcMfpQtMDYrjrx?=
 =?us-ascii?Q?RZ9GlMM1WjK7EBU/qcriliVym1EAuaq/ZmItrxDpbUZTcvRfIaqSET2D/X8d?=
 =?us-ascii?Q?ojJrvLzwK5ivoIlSsVWLeaH9rQHfCS3oxBf9/uLLmcgg3zHIveMUoHDVQuk4?=
 =?us-ascii?Q?0EkXNgJQWc3b/zZKX+uv2QWycgIUAipSZEhT2xDBNARO5I1BgCyQyNesuzw0?=
 =?us-ascii?Q?ZUFs9ew4yXBDzwFh9hRKarjQ8rtys0B3qV7apV15bid4tGKxAUIMWrXJZPFE?=
 =?us-ascii?Q?k63ZNuVku2ua8CYyYNe9UMpz70u2bAN96SAeUDLvPao6peCiG5C1ml+amWTj?=
 =?us-ascii?Q?WzxkB2XPofwImvcqgqOU+axHg+PteqxpDFh4rRtqCvZwlcI9qW8pqFGD7IcQ?=
 =?us-ascii?Q?KkCr4GNAB7uoOFTsfiY3x/HqW6umcSt1nuBFcIt6VaAvc+imvStnBe0pzC5s?=
 =?us-ascii?Q?GYvj/MIH8TKCnp1xLG0vhZwtcEyq8LFffuuuhgJgakKhBnYLkqUWpuzmWfuN?=
 =?us-ascii?Q?7IZs4WmrtkzzT+ZIpezlY1G5odXGAndjCd18TnoRes9V94acYorwwCiN1A1r?=
 =?us-ascii?Q?aFowckau9w2XIoR2X4itaeAXzVrRys9xT7wSBQMwAeSqX7hNdPANxbo+LoMi?=
 =?us-ascii?Q?G6dd/O8ZWfPiXdohIs3vRP9lPh6I/ZzWG4Ty2jfcpfccml91KhXxoDanP+Vr?=
 =?us-ascii?Q?fNhCaRSEU1+Iq7J31t8JLLxQCNzK6ENSgt+S5waU8irdY4kmCVwbU5IsdsDO?=
 =?us-ascii?Q?7bcOv9/gH1DcWQGGr/lHz2LjLlTm0iCUeCrFoMKjUrMabm0orcotWFsCkUvB?=
 =?us-ascii?Q?Jt7KLOpuPOuWsOMksyomYgvnoQnS5eqsio6PezMvzne3zkItS2cAS+MAhQom?=
 =?us-ascii?Q?0P9q3BfC5TYLC0mDD4wYIrt69YGdsVvUvc5xD5nX8P4OHrGbeh6046Evg4cS?=
 =?us-ascii?Q?LO9OhmAGIaFRCoj9MCx/eg/cUo7+pE5Mgc3jxdS0/4kcUp6Bf7CBbeJ3C0bs?=
 =?us-ascii?Q?6+k4cB6DmFCUX8F/PtcDp1ZVefrcArDBt8K6ilBiysOiW2Po2v3CXcYziwgS?=
 =?us-ascii?Q?Vw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1828eae9-16a1-4a58-9537-08da64046020
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 12:45:18.4866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xDy9mQtfdZCteCaw36HYMaRI7nwCUTvdxotNrpL48faBinTD0zJ6K1BDPX783xUAPEMj6K350yquH6nahsC+w+N7Cv0aUuYsmi4FBDw3CaI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4941
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-12_08:2022-07-12,2022-07-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207120049
X-Proofpoint-GUID: qibgbdZuVoGRMJeRRI66GWjnQUIPjgat
X-Proofpoint-ORIG-GUID: qibgbdZuVoGRMJeRRI66GWjnQUIPjgat
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Pablo-Neira-Ayuso/netfilter-nf_tables-release-element-key-when-parser-fails/20220708-180911
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git master
config: x86_64-rhel-8.3-kselftests (https://download.01.org/0day-ci/archive/20220710/202207100802.TRaePFrj-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

smatch warnings:
net/netfilter/nf_tables_api.c:6254 nft_del_setelem() warn: passing zero to 'PTR_ERR'

vim +/PTR_ERR +6254 net/netfilter/nf_tables_api.c

60319eb1ca351a Pablo Neira Ayuso 2014-04-04  6203  static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
20a69341f2d00c Patrick McHardy   2013-10-11  6204  			   const struct nlattr *attr)
20a69341f2d00c Patrick McHardy   2013-10-11  6205  {
20a69341f2d00c Patrick McHardy   2013-10-11  6206  	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
3971ca14350062 Pablo Neira Ayuso 2016-04-12  6207  	struct nft_set_ext_tmpl tmpl;
20a69341f2d00c Patrick McHardy   2013-10-11  6208  	struct nft_set_elem elem;
3971ca14350062 Pablo Neira Ayuso 2016-04-12  6209  	struct nft_set_ext *ext;
60319eb1ca351a Pablo Neira Ayuso 2014-04-04  6210  	struct nft_trans *trans;
3971ca14350062 Pablo Neira Ayuso 2016-04-12  6211  	u32 flags = 0;
20a69341f2d00c Patrick McHardy   2013-10-11  6212  	int err;
20a69341f2d00c Patrick McHardy   2013-10-11  6213  
8cb081746c031f Johannes Berg     2019-04-26  6214  	err = nla_parse_nested_deprecated(nla, NFTA_SET_ELEM_MAX, attr,
fceb6435e85298 Johannes Berg     2017-04-12  6215  					  nft_set_elem_policy, NULL);
20a69341f2d00c Patrick McHardy   2013-10-11  6216  	if (err < 0)
20a1452c35425b Pablo Neira Ayuso 2020-01-22  6217  		return err;
20a69341f2d00c Patrick McHardy   2013-10-11  6218  
aaa31047a6d25d Pablo Neira Ayuso 2021-04-27  6219  	err = nft_setelem_parse_flags(set, nla[NFTA_SET_ELEM_FLAGS], &flags);
aaa31047a6d25d Pablo Neira Ayuso 2021-04-27  6220  	if (err < 0)
aaa31047a6d25d Pablo Neira Ayuso 2021-04-27  6221  		return err;
aaa31047a6d25d Pablo Neira Ayuso 2021-04-27  6222  
aaa31047a6d25d Pablo Neira Ayuso 2021-04-27  6223  	if (!nla[NFTA_SET_ELEM_KEY] && !(flags & NFT_SET_ELEM_CATCHALL))
20a1452c35425b Pablo Neira Ayuso 2020-01-22  6224  		return -EINVAL;
20a69341f2d00c Patrick McHardy   2013-10-11  6225  
3971ca14350062 Pablo Neira Ayuso 2016-04-12  6226  	nft_set_ext_prepare(&tmpl);
3971ca14350062 Pablo Neira Ayuso 2016-04-12  6227  
3971ca14350062 Pablo Neira Ayuso 2016-04-12  6228  	if (flags != 0)
3971ca14350062 Pablo Neira Ayuso 2016-04-12  6229  		nft_set_ext_add(&tmpl, NFT_SET_EXT_FLAGS);
3971ca14350062 Pablo Neira Ayuso 2016-04-12  6230  
aaa31047a6d25d Pablo Neira Ayuso 2021-04-27  6231  	if (nla[NFTA_SET_ELEM_KEY]) {
20a1452c35425b Pablo Neira Ayuso 2020-01-22  6232  		err = nft_setelem_parse_key(ctx, set, &elem.key.val,
d0a11fc3dc4ab4 Patrick McHardy   2015-04-11  6233  					    nla[NFTA_SET_ELEM_KEY]);
20a69341f2d00c Patrick McHardy   2013-10-11  6234  		if (err < 0)
20a1452c35425b Pablo Neira Ayuso 2020-01-22  6235  			return err;
20a69341f2d00c Patrick McHardy   2013-10-11  6236  
20a1452c35425b Pablo Neira Ayuso 2020-01-22  6237  		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
aaa31047a6d25d Pablo Neira Ayuso 2021-04-27  6238  	}
3971ca14350062 Pablo Neira Ayuso 2016-04-12  6239  
7b225d0b5c6dda Pablo Neira Ayuso 2020-01-22  6240  	if (nla[NFTA_SET_ELEM_KEY_END]) {
7b225d0b5c6dda Pablo Neira Ayuso 2020-01-22  6241  		err = nft_setelem_parse_key(ctx, set, &elem.key_end.val,
7b225d0b5c6dda Pablo Neira Ayuso 2020-01-22  6242  					    nla[NFTA_SET_ELEM_KEY_END]);
7b225d0b5c6dda Pablo Neira Ayuso 2020-01-22  6243  		if (err < 0)
0973c5bfbf138f Pablo Neira Ayuso 2022-07-08  6244  			goto fail_elem;
7b225d0b5c6dda Pablo Neira Ayuso 2020-01-22  6245  
7b225d0b5c6dda Pablo Neira Ayuso 2020-01-22  6246  		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY_END, set->klen);
7b225d0b5c6dda Pablo Neira Ayuso 2020-01-22  6247  	}
7b225d0b5c6dda Pablo Neira Ayuso 2020-01-22  6248  
3971ca14350062 Pablo Neira Ayuso 2016-04-12  6249  	err = -ENOMEM;
7b225d0b5c6dda Pablo Neira Ayuso 2020-01-22  6250  	elem.priv = nft_set_elem_init(set, &tmpl, elem.key.val.data,
7b225d0b5c6dda Pablo Neira Ayuso 2020-01-22  6251  				      elem.key_end.val.data, NULL, 0, 0,
33758c891479ea Vasily Averin     2022-03-24  6252  				      GFP_KERNEL_ACCOUNT);
0973c5bfbf138f Pablo Neira Ayuso 2022-07-08  6253  	if (elem.priv == NULL) {
0973c5bfbf138f Pablo Neira Ayuso 2022-07-08 @6254  		err = PTR_ERR(elem.priv);

err = -ENOMEM;?

0973c5bfbf138f Pablo Neira Ayuso 2022-07-08  6255  		goto fail_elem_key_end;
0973c5bfbf138f Pablo Neira Ayuso 2022-07-08  6256  	}
3971ca14350062 Pablo Neira Ayuso 2016-04-12  6257  
3971ca14350062 Pablo Neira Ayuso 2016-04-12  6258  	ext = nft_set_elem_ext(set, elem.priv);
3971ca14350062 Pablo Neira Ayuso 2016-04-12  6259  	if (flags)
3971ca14350062 Pablo Neira Ayuso 2016-04-12  6260  		*nft_set_ext_flags(ext) = flags;
3971ca14350062 Pablo Neira Ayuso 2016-04-12  6261  
60319eb1ca351a Pablo Neira Ayuso 2014-04-04  6262  	trans = nft_trans_elem_alloc(ctx, NFT_MSG_DELSETELEM, set);
20a1452c35425b Pablo Neira Ayuso 2020-01-22  6263  	if (trans == NULL)
20a1452c35425b Pablo Neira Ayuso 2020-01-22  6264  		goto fail_trans;
20a69341f2d00c Patrick McHardy   2013-10-11  6265  
aaa31047a6d25d Pablo Neira Ayuso 2021-04-27  6266  	err = nft_setelem_deactivate(ctx->net, set, &elem, flags);
aaa31047a6d25d Pablo Neira Ayuso 2021-04-27  6267  	if (err < 0)
20a1452c35425b Pablo Neira Ayuso 2020-01-22  6268  		goto fail_ops;
cc02e457bb86f7 Patrick McHardy   2015-03-25  6269  
f8bb7889af58d8 Pablo Neira Ayuso 2021-04-27  6270  	nft_setelem_data_deactivate(ctx->net, set, &elem);
591054469b3eef Pablo Neira Ayuso 2017-05-15  6271  
60319eb1ca351a Pablo Neira Ayuso 2014-04-04  6272  	nft_trans_elem(trans) = elem;
0854db2aaef3fc Florian Westphal  2021-04-01  6273  	nft_trans_commit_list_add_tail(ctx->net, trans);
0dc1362562a2e8 Thomas Graf       2014-08-01  6274  	return 0;
cc02e457bb86f7 Patrick McHardy   2015-03-25  6275  
20a1452c35425b Pablo Neira Ayuso 2020-01-22  6276  fail_ops:
cc02e457bb86f7 Patrick McHardy   2015-03-25  6277  	kfree(trans);
20a1452c35425b Pablo Neira Ayuso 2020-01-22  6278  fail_trans:
3971ca14350062 Pablo Neira Ayuso 2016-04-12  6279  	kfree(elem.priv);
0973c5bfbf138f Pablo Neira Ayuso 2022-07-08  6280  fail_elem_key_end:
0973c5bfbf138f Pablo Neira Ayuso 2022-07-08  6281  	nft_data_release(&elem.key_end.val, NFT_DATA_VALUE);
20a1452c35425b Pablo Neira Ayuso 2020-01-22  6282  fail_elem:
20a1452c35425b Pablo Neira Ayuso 2020-01-22  6283  	nft_data_release(&elem.key.val, NFT_DATA_VALUE);
0973c5bfbf138f Pablo Neira Ayuso 2022-07-08  6284  
20a69341f2d00c Patrick McHardy   2013-10-11  6285  	return err;
20a69341f2d00c Patrick McHardy   2013-10-11  6286  }

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

