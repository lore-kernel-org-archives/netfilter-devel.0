Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9816C43334
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Jul 2022 00:08:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbiGNAIT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Jul 2022 20:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiGNAIT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Jul 2022 20:08:19 -0400
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA57B1D8
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Jul 2022 17:08:17 -0700 (PDT)
Received: from pps.filterd (m0122333.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26DKBokH021198;
        Thu, 14 Jul 2022 01:08:04 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=3kr6mTYY7uaAravVNFDqi0CvYo6jlUvnXvn77H/0EXk=;
 b=kyCZXRSC4HTqK7LHwDIiG26R6QGvfaffrtSk+fURYrDwYDBmm5L9exLIlpg37IYo6LTR
 ArCCTVWnaTzqsS/ghkBRqiv4JkpEOW0H9x0OeDcatlz6oDxRaWJm8ptJlnx6hyREOY6k
 CpIyWYB1F+iQYZ2YuEPk1OKRMZH5mSzCYaNaTMdwqW4oRoUg5pI6L6NQN7jtR3uM+sK4
 GO9aYoTD8NuBy2/ahU8ZDtVozH9r6S3fbBTWcqBdSzWO6r1AML/LicnDmQlT8fTGhWGu
 DmOjAqYhTVaEUAW0KIHYl0s6bQYfZ1ygPm0XKJyWhnr7ruiUpnQXR15TBllm7Ju2VVhI Ew== 
Received: from prod-mail-ppoint6 (prod-mail-ppoint6.akamai.com [184.51.33.61] (may be forged))
        by mx0a-00190b01.pphosted.com (PPS) with ESMTPS id 3ha1u40hb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 01:08:04 +0100
Received: from pps.filterd (prod-mail-ppoint6.akamai.com [127.0.0.1])
        by prod-mail-ppoint6.akamai.com (8.17.1.5/8.17.1.5) with ESMTP id 26DJjVHK010600;
        Wed, 13 Jul 2022 20:08:02 -0400
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint6.akamai.com (PPS) with ESMTP id 3h750y1y08-1;
        Wed, 13 Jul 2022 20:08:02 -0400
Received: from [0.0.0.0] (prod-ssh-gw01.bos01.corp.akamai.com [172.27.119.138])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id 88FF92D65B;
        Thu, 14 Jul 2022 00:08:02 +0000 (GMT)
Message-ID: <b7264c2a-dc7e-dd60-ee04-f2cd87ec761a@akamai.com>
Date:   Wed, 13 Jul 2022 20:08:02 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] netfilter: ipset: ipset list may return wrong member
 count on bitmap types
Content-Language: en-US
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     pablo@netfilter.org, fw@strlen.de, johunt@akamai.com,
        netfilter-devel@vger.kernel.org
References: <20220629212109.3045794-1-vpai@akamai.com>
 <73de8f7a-365-ef8c-77fa-52c6ad94cde@netfilter.org>
From:   Vishwanath Pai <vpai@akamai.com>
In-Reply-To: <73de8f7a-365-ef8c-77fa-52c6ad94cde@netfilter.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-13_13,2022-07-13_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207130096
X-Proofpoint-ORIG-GUID: 0onjTf715DI7oqvvYyHWtsejmG9mMRPH
X-Proofpoint-GUID: 0onjTf715DI7oqvvYyHWtsejmG9mMRPH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-13_12,2022-07-13_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 phishscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 clxscore=1015 adultscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207130096
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 7/12/22 17:06, Jozsef Kadlecsik wrote:
> Hi Vishwanath,
> 
> On Wed, 29 Jun 2022, Vishwanath Pai wrote:
> 
>> We fixed a similar problem before in commit 7f4f7dd4417d ("netfilter:
>> ipset: ipset list may return wrong member count for set with timeout").
>> The same issue exists in ip_set_bitmap_gen.h as well.
> 
> Could you rework the patch to solve the issue the same way as for the hash 
> types (i.e. scanning the set without locking) like in the commit 
> 33f08da28324 (netfilter: ipset: Fix "INFO: rcu detected stall in hash_xxx" 
> reports)? I know the bitmap types have got a limited size but it'd be 
> great if the general method would be the same across the different types.
> 
> Best regards,
> Jozsef
>  
>> Test case:
>>
>> $ ipset create test bitmap:ip range 10.0.0.0/8 netmask 24 timeout 5
>> $ ipset add test 10.0.0.0
>> $ ipset add test 10.255.255.255
>> $ sleep 5s
>>
>> $ ipset list test
>> Name: test
>> Type: bitmap:ip
>> Revision: 3
>> Header: range 10.0.0.0-10.255.255.255 netmask 24 timeout 5
>> Size in memory: 532568
>> References: 0
>> Number of entries: 2
>> Members:
>>
>> We return "Number of entries: 2" but no members are listed. That is
>> because when we run mtype_head the garbage collector hasn't run yet, but
>> mtype_list checks and cleans up members with expired timeout. To avoid
>> this we can run mtype_expire before printing the number of elements in
>> mytype_head().
>>
>> Reviewed-by: Joshua Hunt <johunt@akamai.com>
>> Signed-off-by: Vishwanath Pai <vpai@akamai.com>
>> ---
>>  net/netfilter/ipset/ip_set_bitmap_gen.h | 46 ++++++++++++++++++-------
>>  1 file changed, 34 insertions(+), 12 deletions(-)
>>
>> diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
>> index 26ab0e9612d8..dd871305bd6e 100644
>> --- a/net/netfilter/ipset/ip_set_bitmap_gen.h
>> +++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
>> @@ -28,6 +28,7 @@
>>  #define mtype_del		IPSET_TOKEN(MTYPE, _del)
>>  #define mtype_list		IPSET_TOKEN(MTYPE, _list)
>>  #define mtype_gc		IPSET_TOKEN(MTYPE, _gc)
>> +#define mtype_expire		IPSET_TOKEN(MTYPE, _expire)
>>  #define mtype			MTYPE
>>  
>>  #define get_ext(set, map, id)	((map)->extensions + ((set)->dsize * (id)))
>> @@ -88,13 +89,44 @@ mtype_memsize(const struct mtype *map, size_t dsize)
>>  	       map->elements * dsize;
>>  }
>>  
>> +/* We should grab set->lock before calling this function */
>> +static void
>> +mtype_expire(struct ip_set *set)
>> +{
>> +	struct mtype *map = set->data;
>> +	void *x;
>> +	u32 id;
>> +
>> +	for (id = 0; id < map->elements; id++)
>> +		if (mtype_gc_test(id, map, set->dsize)) {
>> +			x = get_ext(set, map, id);
>> +			if (ip_set_timeout_expired(ext_timeout(x, set))) {
>> +				clear_bit(id, map->members);
>> +				ip_set_ext_destroy(set, x);
>> +				set->elements--;
>> +			}
>> +		}
>> +}
>> +
>>  static int
>>  mtype_head(struct ip_set *set, struct sk_buff *skb)
>>  {
>>  	const struct mtype *map = set->data;
>>  	struct nlattr *nested;
>> -	size_t memsize = mtype_memsize(map, set->dsize) + set->ext_size;
>> +	size_t memsize;
>> +
>> +	/* If any members have expired, set->elements will be wrong,
>> +	 * mytype_expire function will update it with the right count.
>> +	 * set->elements can still be incorrect in the case of a huge set
>> +	 * because elements can timeout during set->list().
>> +	 */
>> +	if (SET_WITH_TIMEOUT(set)) {
>> +		spin_lock_bh(&set->lock);
>> +		mtype_expire(set);
>> +		spin_unlock_bh(&set->lock);
>> +	}
>>  
>> +	memsize = mtype_memsize(map, set->dsize) + set->ext_size;
>>  	nested = nla_nest_start(skb, IPSET_ATTR_DATA);
>>  	if (!nested)
>>  		goto nla_put_failure;
>> @@ -266,22 +298,12 @@ mtype_gc(struct timer_list *t)
>>  {
>>  	struct mtype *map = from_timer(map, t, gc);
>>  	struct ip_set *set = map->set;
>> -	void *x;
>> -	u32 id;
>>  
>>  	/* We run parallel with other readers (test element)
>>  	 * but adding/deleting new entries is locked out
>>  	 */
>>  	spin_lock_bh(&set->lock);
>> -	for (id = 0; id < map->elements; id++)
>> -		if (mtype_gc_test(id, map, set->dsize)) {
>> -			x = get_ext(set, map, id);
>> -			if (ip_set_timeout_expired(ext_timeout(x, set))) {
>> -				clear_bit(id, map->members);
>> -				ip_set_ext_destroy(set, x);
>> -				set->elements--;
>> -			}
>> -		}
>> +	mtype_expire(set);
>>  	spin_unlock_bh(&set->lock);
>>  
>>  	map->gc.expires = jiffies + IPSET_GC_PERIOD(set->timeout) * HZ;
>> -- 
>> 2.25.1
>>
>>
> 
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> PGP key : https://urldefense.com/v3/__https://wigner.hu/*kadlec/pgp_public_key.txt__;fg!!GjvTz_vk!WmVWx08Jyxg7z7R4rXMUupSXptToGLCMfZ7GhOy1yP_Ty0YQZFSbPbvlocRcFRBnQqy787ijhdI-ig$ 
> Address : Wigner Research Centre for Physics
>           H-1525 Budapest 114, POB. 49, Hungary

Hi Jozsef,

Sure, I'll give it a try. It might take me a bit longer cause it looks like a
complex set of changes.

Thanks,
Vishwanath
