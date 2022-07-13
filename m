Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23E0CC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Jul 2022 20:07:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236653AbiGMUHv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Jul 2022 16:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbiGMUHu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Jul 2022 16:07:50 -0400
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E85930F54
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Jul 2022 13:07:47 -0700 (PDT)
Received: from pps.filterd (m0122331.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26DHisEG021489;
        Wed, 13 Jul 2022 21:07:37 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=t2CH7/qbBTPWDrsk1mrs7/NyTQ2ozs0qEsfgoUMw6Es=;
 b=l06J/lGfg1BARRyyfJRgDzfUcJZeRKp5qF2BCCkPzSFtJMVRwH19fBkLIaIc4dfuOJWS
 eR3pu8OEVWm82+TJzlNCdpFI/2i+UWoIcuo1jMVPdVnHWZPgydv4ejpqOMi1mPyG6utR
 KDuumSiqHA0nvOuKITtK8O6xcNALLy7b6aRwTLWRCLF/DKVl4pP1MMiJB0Pa87hlC8w7
 APwVUtFabUo6fjREc+6YaFHwXb4W8ETFYL14hpTCBA8/dbp0nX7SWpbDHD5n0h+rMRMz
 5vSs3mlN+TTqXbXKDLkevggMjmvGaBhdp2v+GJQVigkyOUbDRcTYFJXm6TOV0Rf1KkQA lw== 
Received: from prod-mail-ppoint3 (a72-247-45-31.deploy.static.akamaitechnologies.com [72.247.45.31] (may be forged))
        by mx0b-00190b01.pphosted.com (PPS) with ESMTPS id 3h9dsrxn9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 21:07:36 +0100
Received: from pps.filterd (prod-mail-ppoint3.akamai.com [127.0.0.1])
        by prod-mail-ppoint3.akamai.com (8.17.1.5/8.17.1.5) with ESMTP id 26DGrAR2031753;
        Wed, 13 Jul 2022 16:07:36 -0400
Received: from prod-mail-relay19.dfw02.corp.akamai.com ([172.27.165.173])
        by prod-mail-ppoint3.akamai.com (PPS) with ESMTP id 3h7q6pcts8-1;
        Wed, 13 Jul 2022 16:07:36 -0400
Received: from [0.0.0.0] (prod-ssh-gw01.bos01.corp.akamai.com [172.27.119.138])
        by prod-mail-relay19.dfw02.corp.akamai.com (Postfix) with ESMTP id C62BD60062;
        Wed, 13 Jul 2022 20:07:35 +0000 (GMT)
Message-ID: <1ed749ee-f338-348c-e788-0bb71ca70485@akamai.com>
Date:   Wed, 13 Jul 2022 16:07:35 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] netfilter: ipset: regression in ip_set_hash_ip.c
Content-Language: en-US
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     pablo@netfilter.org, fw@strlen.de, johunt@akamai.com,
        netfilter-devel@vger.kernel.org
References: <20220629212109.3045794-1-vpai@akamai.com>
 <20220629212109.3045794-2-vpai@akamai.com>
 <e394ba75-afe1-c50-54eb-dfceee45bd7a@netfilter.org>
From:   Vishwanath Pai <vpai@akamai.com>
In-Reply-To: <e394ba75-afe1-c50-54eb-dfceee45bd7a@netfilter.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-13_10,2022-07-13_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207130073
X-Proofpoint-GUID: FCvKPygpaMjneuq39eKQYCGqBsSQKhsq
X-Proofpoint-ORIG-GUID: FCvKPygpaMjneuq39eKQYCGqBsSQKhsq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-13_09,2022-07-13_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 mlxscore=0 impostorscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207130073
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 7/12/22 17:42, Jozsef Kadlecsik wrote:
> Hi Vishwanath,
> 
> On Wed, 29 Jun 2022, Vishwanath Pai wrote:
> 
>> This patch introduced a regression: commit 48596a8ddc46 ("netfilter:
>> ipset: Fix adding an IPv4 range containing more than 2^31 addresses")
>>
>> The variable e.ip is passed to adtfn() function which finally adds the
>> ip address to the set. The patch above refactored the for loop and moved
>> e.ip = htonl(ip) to the end of the for loop.
>>
>> What this means is that if the value of "ip" changes between the first
>> assignement of e.ip and the forloop, then e.ip is pointing to a
>> different ip address than "ip".
>>
>> Test case:
>> $ ipset create jdtest_tmp hash:ip family inet hashsize 2048 maxelem 100000
>> $ ipset add jdtest_tmp 10.0.1.1/31
>> ipset v6.21.1: Element cannot be added to the set: it's already added
>>
>> The value of ip gets updated inside the  "else if (tb[IPSET_ATTR_CIDR])"
>> block but e.ip is still pointing to the old value.
>>
>> Reviewed-by: Joshua Hunt <johunt@akamai.com>
>> Signed-off-by: Vishwanath Pai <vpai@akamai.com>
>> ---
>>  net/netfilter/ipset/ip_set_hash_ip.c | 12 +++++++++---
>>  1 file changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
>> index dd30c03d5a23..258aeb324483 100644
>> --- a/net/netfilter/ipset/ip_set_hash_ip.c
>> +++ b/net/netfilter/ipset/ip_set_hash_ip.c
>> @@ -120,12 +120,14 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
>>  		return ret;
>>  
>>  	ip &= ip_set_hostmask(h->netmask);
>> -	e.ip = htonl(ip);
>> -	if (e.ip == 0)
>> +
>> +	if (ip == 0)
>>  		return -IPSET_ERR_HASH_ELEM;
>>  
>> -	if (adt == IPSET_TEST)
>> +	if (adt == IPSET_TEST) {
>> +		e.ip = htonl(ip);
>>  		return adtfn(set, &e, &ext, &ext, flags);
>> +	}
>>  
>>  	ip_to = ip;
>>  	if (tb[IPSET_ATTR_IP_TO]) {
>> @@ -145,6 +147,10 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
>>  		ip_set_mask_from_to(ip, ip_to, cidr);
>>  	}
>>  
>> +	e.ip = htonl(ip);
>> +	if (e.ip == 0)
>> +		return -IPSET_ERR_HASH_ELEM;
>> +
>>  	hosts = h->netmask == 32 ? 1 : 2 << (32 - h->netmask - 1);
>>  
>>  	/* 64bit division is not allowed on 32bit */
> 
> You are right, however the patch can be made much smaller if the e.ip 
> conversion is simply moved from
> 
>         if (retried) {
>                 ip = ntohl(h->next.ip);
>                 e.ip = htonl(ip);
>         }
> 
> into the next for loop as the first instruction. Could you resend 
> your patch that way?
> 
> Best regards,
> Jozsef
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> PGP key : https://urldefense.com/v3/__https://wigner.hu/*kadlec/pgp_public_key.txt__;fg!!GjvTz_vk!Ueht58Jfq7I9Q7kUGd0c_P7hXtIX50eqzQrTiCXOlath9rqfr5WF4srmHwNQ06rfNxUsBM7lCp3bew$ 
> Address : Wigner Research Centre for Physics
>           H-1525 Budapest 114, POB. 49, Hungary

Hi Jozsef,

Agreed that would be much simpler. I'll send a v2.

Thanks,
Vishwanath
