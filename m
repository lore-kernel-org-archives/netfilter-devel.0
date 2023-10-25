Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86F2BC07545
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Oct 2023 17:22:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjJYRW7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Oct 2023 13:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjJYRW6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2023 13:22:58 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE55138;
        Wed, 25 Oct 2023 10:22:56 -0700 (PDT)
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39PDPHGn030658;
        Wed, 25 Oct 2023 17:22:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=qZxLb5HJgM1zLa27tYjgpnVphIiyEKx9bHAKAbtiyOY=;
 b=g9L9yCFZx49glTpJqpjzLeGSeT5sHEPn95bfEEZzZjiTtOn7EB4ItKIfrF2Nbq3hfiR5
 EESd/5Cut3cUc9lPNUdzZpGhuSPAJ9fh44Od1UVLLMvfWgLcocBRiS49oerA1dqNbwIC
 i9uN39+7Sd06VkaIGh9kwiT8cjFsJ2ewd3dcOzM0IOmLiUdFwLlw2iPOmm9WNKNqScSV
 q+5af/s/PZFM07l8UnlPEcpQmMmZvRZ0KFGp/r38Zj86G4CBdIF9nGNwcOHNtD6h8LRD
 EFqovHz7hRv3RnT/M4FyJrA9RnrEEYWlH4HZnDFDA8yH+tjdoX3ocEy02wQ0hwCnELBY Ug== 
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3txuj7hk1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Oct 2023 17:22:49 +0000
Received: from nalasex01c.na.qualcomm.com (nalasex01c.na.qualcomm.com [10.47.97.35])
        by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 39PHMkOE002250
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Oct 2023 17:22:46 GMT
Received: from [10.216.19.58] (10.80.80.8) by nalasex01c.na.qualcomm.com
 (10.47.97.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.39; Wed, 25 Oct
 2023 10:22:43 -0700
Message-ID: <45ec4684-6b71-49c2-a082-b7f8aba4a804@quicinc.com>
Date:   Wed, 25 Oct 2023 22:52:39 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: KASAN: vmalloc-out-of-bounds in ipt_do_table
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <mark.tomlinson@alliedtelesis.co.nz>, <netdev@vger.kernel.org>,
        <quic_sharathv@quicinc.com>, <quic_subashab@quicinc.com>,
        <netfilter-devel@vger.kernel.org>
References: <7ce196a5-9477-41df-b0fa-c208021a35ba@quicinc.com>
 <ZTZHBgHovKrN8q6w@calendula>
From:   Kaustubh Pandey <quic_kapandey@quicinc.com>
In-Reply-To: <ZTZHBgHovKrN8q6w@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01c.na.qualcomm.com (10.47.97.35)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: zLkxE41qH1S97i-wPKsHMHQft8JE_xmR
X-Proofpoint-GUID: zLkxE41qH1S97i-wPKsHMHQft8JE_xmR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-25_07,2023-10-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 spamscore=0 malwarescore=0 clxscore=1011 suspectscore=0 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 mlxscore=0 adultscore=0 mlxlogscore=896
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310250151
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 10/23/2023 3:42 PM, Pablo Neira Ayuso wrote:
> Cc'ing netfilter-devel.
> 
> On Mon, Oct 23, 2023 at 03:31:25PM +0530, Kaustubh Pandey wrote:
>> Hi Everyone,
>>
>> We have observed below issue on v5.15 kernel
>>
>> [83180.055298]
>> ==================================================================
>> [83180.055376] BUG: KASAN: vmalloc-out-of-bounds in ipt_do_table+0x43c/0xaf4
>> [83180.055464] Read of size 8 at addr ffffffc02c0f9000 by task Disposer/1686
>> [83180.055544] CPU: 1 PID: 1686 Comm: Disposer Tainted: G S      W  OE
>>   5.15.78-android13-8-g3d973ad4cc47 #1
> 
> This is slightly behind current -stable. Perhaps this is missing?
> 
> commit e58a171d35e32e6e8c37cfe0e8a94406732a331f
> Author: Florian Westphal <fw@strlen.de>
> Date:   Fri Feb 17 23:20:06 2023 +0100
> 
>     netfilter: ebtables: fix table blob use-after-free
> 
>> [83180.055613] Hardware name: Qualcomm Technologies, Inc. Kalama
>> MTP,davinci DVT (DT)
>> [83180.055655] Call trace:
>> [83180.055677]  dump_backtrace+0x0/0x3b0
>> [83180.055740]  show_stack+0x2c/0x3c
>> [83180.055792]  dump_stack_lvl+0x8c/0xa8
>> [83180.055866]  print_address_description+0x74/0x384
>> [83180.055940]  kasan_report+0x180/0x260
>> [83180.056002]  __asan_load8+0xb4/0xb8
>> [83180.056064]  ipt_do_table+0x43c/0xaf4
>> [83180.056120]  iptable_mangle_hook+0xf4/0x22c
>> [83180.056182]  nf_hook_slow+0x90/0x198
>> [83180.056245]  ip_mc_output+0x50c/0x67c
>> [83180.056302]  ip_send_skb+0x88/0x1bc
>> [83180.056355]  udp_send_skb+0x524/0x930
>> [83180.056415]  udp_sendmsg+0x126c/0x13ac
>> [83180.056474]  udpv6_sendmsg+0x6d4/0x1764
>> [83180.056539]  inet6_sendmsg+0x78/0x98
>> [83180.056605]  __sys_sendto+0x360/0x450
>> [83180.056667]  __arm64_sys_sendto+0x80/0x9c
>> [83180.056725]  invoke_syscall+0x80/0x218
>> [83180.056791]  el0_svc_common+0x18c/0x1bc
>> [83180.056857]  do_el0_svc+0x44/0xfc
>> [83180.056918]  el0_svc+0x20/0x50
>> [83180.056966]  el0t_64_sync_handler+0x84/0xe4
>> [83180.057020]  el0t_64_sync+0x1a4/0x1a8
>> [83180.057110] Memory state around the buggy address:
>> [83180.057150]  ffffffc02c0f8f00: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>> f8 f8 f8
>> [83180.057193]  ffffffc02c0f8f80: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>> f8 f8 f8
>> [83180.057237] >ffffffc02c0f9000: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>> f8 f8 f8
>> [83180.057269]                    ^
>> [83180.057304]  ffffffc02c0f9080: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>> f8 f8 f8
>> [83180.057345]  ffffffc02c0f9100: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>> f8 f8 f8
>> [83180.057378]
>> ==================================================================
>>
>> There are no reproduction steps available for this.
>>
>> I have checked along the lines and see that
>> https://github.com/torvalds/linux/commit/175e476b8cdf2a4de7432583b49c871345e4f8a1
>> is still present in this kernel.
>> Checked around similar lines in latest kernel and still see that
>> implementation hasnt  changed much.
>>
>> Can you pls help check if this is a known issue and was fixed in latest
>> or help in pointing out how to debug this further ?
>>
>> Thanks,
>> Kaustubh
>>

Thanks Pablo, I will try after picking the shared change.
I will revert back with results. 

Thanks,
Kaustubh
