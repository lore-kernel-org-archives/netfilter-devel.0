Return-Path: <SRS0=GfVU=S6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE1FBC43219
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 Apr 2019 03:04:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6266208C2
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 Apr 2019 03:04:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbfD1DEZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 27 Apr 2019 23:04:25 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:55008 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726460AbfD1DEZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 27 Apr 2019 23:04:25 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 53D6ECFF0376589402A0;
        Sun, 28 Apr 2019 11:04:22 +0800 (CST)
Received: from [127.0.0.1] (10.184.189.20) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Sun, 28 Apr 2019
 11:04:13 +0800
Subject: Re: [PATCH v2] ipvs:set sock send/receive buffer correctly
To:     Julian Anastasov <ja@ssi.bg>
CC:     <wensong@linux-vs.org>, <horms@verge.net.au>,
        <pablo@netfilter.org>, <kadlec@blackhole.kfki.hu>, <fw@strlen.de>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <lvs-devel@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <coreteam@netfilter.org>, <linux-kernel@vger.kernel.org>,
        <eric.dumazet@gmail.com>, Mingfangsen <mingfangsen@huawei.com>,
        <liujie165@huawei.com>
References: <7d0dbb46-09aa-0163-bfd9-169594489584@huawei.com>
 <alpine.LFD.2.21.1904212142540.2345@ja.home.ssi.bg>
From:   linmiaohe <linmiaohe@huawei.com>
Message-ID: <a4a786c0-85f5-a134-bcd0-ace8edf7762a@huawei.com>
Date:   Sun, 28 Apr 2019 11:03:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.21.1904212142540.2345@ja.home.ssi.bg>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.189.20]
X-CFilter-Loop: Reflected
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 2019/4/22 2:48, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Thu, 18 Apr 2019, linmiaohe wrote:
> 
>> From: Jie Liu <liujie165@huawei.com>
>>
>> If we set sysctl_wmem_max or sysctl_rmem_max larger than INT_MAX, the
>> send/receive buffer of sock will be an negative value. Same as when
>> the val is larger than INT_MAX/2.
>>
>> Fixes: 1c003b1580e2 ("ipvs: wakeup master thread")
>> Reported-by: Qiang Ning <ningqiang1@huawei.com>
>> Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
>> Signed-off-by: Jie Liu <liujie165@huawei.com>
> 
> 	Looks good to me, thanks!
> 
> Acked-by: Julian Anastasov <ja@ssi.bg>
> 
>> ---
>>  net/netfilter/ipvs/ip_vs_sync.c | 20 ++++++++++++++------
>>  1 file changed, 14 insertions(+), 6 deletions(-)
>>
>> diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
>> index 2526be6b3d90..760f3364d4a2 100644
>> --- a/net/netfilter/ipvs/ip_vs_sync.c
>> +++ b/net/netfilter/ipvs/ip_vs_sync.c
>> @@ -1278,14 +1278,22 @@ static void set_sock_size(struct sock *sk, int mode, int val)
>>  	/* setsockopt(sock, SOL_SOCKET, SO_RCVBUF, &val, sizeof(val)); */
>>  	lock_sock(sk);
>>  	if (mode) {
>> -		val = clamp_t(int, val, (SOCK_MIN_SNDBUF + 1) / 2,
>> -			      sysctl_wmem_max);
>> -		sk->sk_sndbuf = val * 2;
>> +		val = min_t(u32, val, sysctl_wmem_max);
>> +
>> +		/* Ensure val * 2 fits into an int, to prevent max_t()
>> +		 * from treating it as a negative value.
>> +		 */
>> +		val = min_t(int, val, INT_MAX / 2);
>> +		sk->sk_sndbuf = max_t(int, val * 2, SOCK_MIN_SNDBUF);
>>  		sk->sk_userlocks |= SOCK_SNDBUF_LOCK;
>>  	} else {
>> -		val = clamp_t(int, val, (SOCK_MIN_RCVBUF + 1) / 2,
>> -			      sysctl_rmem_max);
>> -		sk->sk_rcvbuf = val * 2;
>> +		val = min_t(u32, val, sysctl_rmem_max);
>> +
>> +		/* Ensure val * 2 fits into an int, to prevent max_t()
>> +		 * from treating it as a negative value.
>> +		 */
>> +		val = min_t(int, val, INT_MAX / 2);
>> +		sk->sk_rcvbuf = max_t(int, val * 2, SOCK_MIN_RCVBUF);
>>  		sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
>>  	}
>>  	release_sock(sk);
>> -- 
> 
> Regards
> 
> --
> Julian Anastasov <ja@ssi.bg>
> 
> .
> 

Hi all,
    Could you please tell me if there is still any problem?
Many thanks.

