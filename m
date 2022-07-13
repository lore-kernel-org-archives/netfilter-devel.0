Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5767C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Jul 2022 20:53:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237271AbiGMUxE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Jul 2022 16:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236631AbiGMUxB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Jul 2022 16:53:01 -0400
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A11EB31904
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Jul 2022 13:52:56 -0700 (PDT)
Received: from pps.filterd (m0122332.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26DHjExj023193;
        Wed, 13 Jul 2022 21:52:44 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=nJky6PdDwgdQTBjTFiP4BjhQbDctiysHWADp80ptRY8=;
 b=oBx5aeA6mv/1/93tUlTAiqIMrEwp3Y/20GrNXcX+WCL853gkrd6Ny4oa7W3KV6LJGIa7
 +a959rc55ZeIn7nxt9+QEn4HbjJHBCMRB6BuVHyjoHn7cMB1UQhAJkZwTAsqUD/Nkej0
 bl9DYq8wCs0c2JCjNJxaIkxlTBJq13dMp7Awk7uShAi3pS7tktLliXzcAHB3GaEkkVja
 nSOTqsLJspt+r/n3ZU0s9p+lH895ymZJ/SpMzvQ0jy1PWHik3DeWy4ttaE62FBF8/oM+
 G4bdOGn5xVFQlSokQWvOceRo0xRZ0qNhRfuNRyqb2nrcHI30kq8+eAr5XO9fVHeEOtnx Ww== 
Received: from prod-mail-ppoint6 (prod-mail-ppoint6.akamai.com [184.51.33.61] (may be forged))
        by mx0a-00190b01.pphosted.com (PPS) with ESMTPS id 3h94n52gg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 21:52:43 +0100
Received: from pps.filterd (prod-mail-ppoint6.akamai.com [127.0.0.1])
        by prod-mail-ppoint6.akamai.com (8.17.1.5/8.17.1.5) with ESMTP id 26DI18Se025910;
        Wed, 13 Jul 2022 16:52:42 -0400
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint6.akamai.com (PPS) with ESMTP id 3h750y1h54-1;
        Wed, 13 Jul 2022 16:52:42 -0400
Received: from [0.0.0.0] (prod-ssh-gw01.bos01.corp.akamai.com [172.27.119.138])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id 6F6192D643;
        Wed, 13 Jul 2022 20:52:42 +0000 (GMT)
Message-ID: <1b873df4-9b87-11b0-63f7-9a0de0a33e99@akamai.com>
Date:   Wed, 13 Jul 2022 16:52:42 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 1/6] netfilter: ipset: include linux/nf_inet_addr.h
Content-Language: en-US
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     pablo@netfilter.org, fw@strlen.de, johunt@akamai.com,
        netfilter-devel@vger.kernel.org
References: <20220629211902.3045703-1-vpai@akamai.com>
 <20220629211902.3045703-2-vpai@akamai.com>
 <2671440-40b6-1789-25a5-9f16971595cd@netfilter.org>
From:   Vishwanath Pai <vpai@akamai.com>
In-Reply-To: <2671440-40b6-1789-25a5-9f16971595cd@netfilter.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-13_11,2022-07-13_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207130086
X-Proofpoint-GUID: S8iVshbJqLyDy1fUxRVs_H3W5bncVAvO
X-Proofpoint-ORIG-GUID: S8iVshbJqLyDy1fUxRVs_H3W5bncVAvO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-13_11,2022-07-13_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 priorityscore=1501 malwarescore=0 impostorscore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 bulkscore=0 clxscore=1015 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207130086
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 7/12/22 18:48, Jozsef Kadlecsik wrote:
> Hi,
> 
> On Wed, 29 Jun 2022, Vishwanath Pai wrote:
> 
>> We redefined a few things from nf_inet_addr.h, this will prevent others
>> from including nf_inet_addr.h and ipset headers in the same file.
>>
>> Remove the duplicate definitions and include nf_inet_addr.h instead.
> 
> Please don't do that or add the required compatibility stuff into 
> configure.ac and ip_set_compat.h.in in order not to break support for 
> older kernels.
> 
> Best regards,
> Jozsef
>  
>> Signed-off-by: Vishwanath Pai <vpai@akamai.com>
>> Signed-off-by: Joshua Hunt <johunt@akamai.com>
>> ---
>>  include/libipset/nf_inet_addr.h |  9 +--------
>>  include/libipset/nfproto.h      | 15 +--------------
>>  2 files changed, 2 insertions(+), 22 deletions(-)
>>
>> diff --git a/include/libipset/nf_inet_addr.h b/include/libipset/nf_inet_addr.h
>> index f3bdf01..e1e058c 100644
>> --- a/include/libipset/nf_inet_addr.h
>> +++ b/include/libipset/nf_inet_addr.h
>> @@ -10,13 +10,6 @@
>>  #include <stdint.h>				/* uint32_t */
>>  #include <netinet/in.h>				/* struct in[6]_addr */
>>  
>> -/* The structure to hold IP addresses, same as in linux/netfilter.h */
>> -union nf_inet_addr {
>> -	uint32_t	all[4];
>> -	uint32_t	ip;
>> -	uint32_t	ip6[4];
>> -	struct in_addr	in;
>> -	struct in6_addr in6;
>> -};
>> +#include <linux/netfilter.h>
>>  
>>  #endif /* LIBIPSET_NF_INET_ADDR_H */
>> diff --git a/include/libipset/nfproto.h b/include/libipset/nfproto.h
>> index 800da11..5265176 100644
>> --- a/include/libipset/nfproto.h
>> +++ b/include/libipset/nfproto.h
>> @@ -1,19 +1,6 @@
>>  #ifndef LIBIPSET_NFPROTO_H
>>  #define LIBIPSET_NFPROTO_H
>>  
>> -/*
>> - * The constants to select, same as in linux/netfilter.h.
>> - * Like nf_inet_addr.h, this is just here so that we need not to rely on
>> - * the presence of a recent-enough netfilter.h.
>> - */
>> -enum {
>> -	NFPROTO_UNSPEC =  0,
>> -	NFPROTO_IPV4   =  2,
>> -	NFPROTO_ARP    =  3,
>> -	NFPROTO_BRIDGE =  7,
>> -	NFPROTO_IPV6   = 10,
>> -	NFPROTO_DECNET = 12,
>> -	NFPROTO_NUMPROTO,
>> -};
>> +#include <linux/netfilter.h>
>>  
>>  #endif /* LIBIPSET_NFPROTO_H */
>> -- 
>> 2.25.1
>>
>>
> 
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> PGP key : https://urldefense.com/v3/__https://wigner.hu/*kadlec/pgp_public_key.txt__;fg!!GjvTz_vk!RpoeCRFI0PWc4oBxSqKNzLH0ay8yDHYgfzLW5sGYtJy4bMW0G8Vd73lAZEOwigOZXdQAS8906hLTeg$ 
> Address : Wigner Research Centre for Physics
>           H-1525 Budapest 114, POB. 49, Hungary

Ah, thanks for pointing that out. I'll take care of this in V2.

Thanks,
Vishwanath
