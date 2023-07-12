Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 733BAEB64DA
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jul 2023 08:43:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbjGLInG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Jul 2023 04:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbjGLInE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jul 2023 04:43:04 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD7081703;
        Wed, 12 Jul 2023 01:42:40 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4R1B3d6XQhz67qBF;
        Wed, 12 Jul 2023 16:38:53 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 12 Jul 2023 09:42:34 +0100
Message-ID: <7219eb87-8211-bfff-5d63-f1483973dab6@huawei.com>
Date:   Wed, 12 Jul 2023 11:42:33 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v11.1] selftests/landlock: Add 11 new test suites
 dedicated to network
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <artem.kuzin@huawei.com>, <gnoack3000@gmail.com>,
        <willemdebruijn.kernel@gmail.com>, <yusongping@huawei.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>
References: <20230515161339.631577-11-konstantin.meskhidze@huawei.com>
 <20230706145543.1284007-1-mic@digikod.net>
 <f8f76bff-c434-07f8-8a53-f8a0d69292b1@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <f8f76bff-c434-07f8-8a53-f8a0d69292b1@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml500003.china.huawei.com (7.191.162.67) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



7/10/2023 7:06 PM, Mickaël Salaün пишет:
> 
> On 06/07/2023 16:55, Mickaël Salaün wrote:
>> From: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> 
>> This patch is a revamp of the v11 tests [1] with new tests (see the
>> "Changes since v11" description).  I (Mickaël) only added the following
>> todo list and the "Changes since v11" sections in this commit message.
>> I think this patch is good but it would appreciate reviews.
>> You can find the diff of my changes here but it is not really readable:
>> https://git.kernel.org/mic/c/78edf722fba5 (landlock-net-v11 branch)
>> [1] https://lore.kernel.org/all/20230515161339.631577-11-konstantin.meskhidze@huawei.com/
>> TODO:
>> - Rename all "net_service" to "net_port".
>> - Fix the two kernel bugs found with the new tests.
>> - Update this commit message with a small description of all tests.
>> 
> 
> 
> [...]
> 
>> +static int bind_variant_addrlen(const int sock_fd,
>> +				const struct service_fixture *const srv,
>> +				const socklen_t addrlen)
>> +{
>> +	int ret;
>> +
>> +	switch (srv->protocol.domain) {
>> +	case AF_UNSPEC:
>> +	case AF_INET:
>> +		ret = bind(sock_fd, &srv->ipv4_addr, addrlen);
>> +		break;
>> +
>> +	case AF_INET6:
>> +		ret = bind(sock_fd, &srv->ipv6_addr, addrlen);
>> +		break;
>> +
>> +	case AF_UNIX:
>> +		ret = bind(sock_fd, &srv->unix_addr, addrlen);
>> +		break;
>> +
>> +	default:
>> +		errno = -EAFNOSUPPORT;
> 
> This should be `errno = EAFNOSUPPORT`

   Ok. Got it.
> 
>> +		return -errno;
>> +	}
>> +
>> +	if (ret < 0)
>> +		return -errno;
>> +	return ret;
> .
