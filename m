Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B051CE79AF
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 10:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbjITKAO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 06:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234347AbjITKAN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 06:00:13 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B89A8F;
        Wed, 20 Sep 2023 03:00:06 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4RrDVd4wpkz6HJcK;
        Wed, 20 Sep 2023 17:58:01 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Wed, 20 Sep 2023 11:00:03 +0100
Message-ID: <7cb458f1-7aff-ccf3-abfd-b563bfc65b84@huawei.com>
Date:   Wed, 20 Sep 2023 13:00:02 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v11.1] selftests/landlock: Add 11 new test suites
 dedicated to network
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     Paul Moore <paul@paul-moore.com>, <artem.kuzin@huawei.com>,
        <gnoack3000@gmail.com>, <willemdebruijn.kernel@gmail.com>,
        <yusongping@huawei.com>, <linux-security-module@vger.kernel.org>,
        <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>
References: <20230515161339.631577-11-konstantin.meskhidze@huawei.com>
 <20230706145543.1284007-1-mic@digikod.net>
 <3db64cf8-6a45-a361-aa57-9bfbaf866ef8@digikod.net>
 <b2a94da1-f9df-b684-7666-1c63060f68f1@huawei.com>
 <20230817.koh5see0eaLa@digikod.net>
 <239800f3-baf4-1c7d-047f-8ba90b097bee@huawei.com>
 <20230914.ASu9sho1Aef0@digikod.net>
 <076bfaa6-1e0b-c95b-5727-00001c79f2c0@huawei.com>
 <20230918.shauB5gei9Ai@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <20230918.shauB5gei9Ai@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml100001.china.huawei.com (7.191.160.183) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



9/18/2023 9:56 AM, Mickaël Salaün пишет:
> On Fri, Sep 15, 2023 at 11:54:46AM +0300, Konstantin Meskhidze (A) wrote:
>> 
>> 
>> 9/14/2023 11:08 AM, Mickaël Salaün пишет:
>> > On Mon, Sep 11, 2023 at 01:13:24PM +0300, Konstantin Meskhidze (A) wrote:
>> > > 
>> > > 
>> > > 8/17/2023 6:08 PM, Mickaël Salaün пишет:
>> > > > On Sat, Aug 12, 2023 at 05:37:00PM +0300, Konstantin Meskhidze (A) wrote:
>> > > > > > > > > 7/12/2023 10:02 AM, Mickaël Salaün пишет:
>> > > > > > > On 06/07/2023 16:55, Mickaël Salaün wrote:
>> > > > > > > From: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> > > > > > > > > This patch is a revamp of the v11 tests [1] with new tests
>> > > > > (see the
>> > > > > > > "Changes since v11" description).  I (Mickaël) only added the following
>> > > > > > > todo list and the "Changes since v11" sections in this commit message.
>> > > > > > > I think this patch is good but it would appreciate reviews.
>> > > > > > > You can find the diff of my changes here but it is not really readable:
>> > > > > > > https://git.kernel.org/mic/c/78edf722fba5 (landlock-net-v11 branch)
>> > > > > > > [1] https://lore.kernel.org/all/20230515161339.631577-11-konstantin.meskhidze@huawei.com/
>> > > > > > > TODO:
>> > > > > > > - Rename all "net_service" to "net_port".
>> > > > > > > - Fix the two kernel bugs found with the new tests.
>> > > > > > > - Update this commit message with a small description of all tests.
>> > > > > > > [...]
>> > > > > > > We should also add a test to make sure errno is the same
>> > > with and
>> > > > > > without sandboxing when using port 0 for connect and consistent with
>> > > > > > bind (using an available port). The test fixture and variants should be
>> > > > > > quite similar to the "ipv4" ones, but we can also add AF_INET6 variants,
>> > > > > > which will result in 8 "ip" variants:
>> > > > > > > TEST_F(ip, port_zero)
>> > > > > > {
>> > > > > > 	if (variant->sandbox == TCP_SANDBOX) {
>> > > > > > 		/* Denies any connect and bind. */
>> > > > > > 	}
>> > > > > > 	/* Checks errno for port 0. */
>> > > > > > }
>> > > > > As I understand the would be the next test cases:
>> > > > > > > 	1. ip4, sandboxed, bind port 0 -> should return EACCES
>> > > (denied by
>> > > > > landlock).
>> > > > > Without any allowed port, yes. This test case is useful.
>> > > > > By tuning /proc/sys/net/ipv4/ip_local_port_range (see
>> > > > inet_csk_find_open_port call) we should be able to pick a specific
>> > > > allowed port and test it.  We can also test for the EADDRINUSE error to
>> > > > make sure error ordering is correct (compared with -EACCES).
>> > >   Sorry, did not get this case. Could please explain it with more details?
>> > 
>> > According to bind(2), if no port are available, the syscall should
>> > return EADDRINUSE. And this returned value should be the same whatever
>> > the process is sandbox or not (and never EACCES). But as I explained
>> > just below, we cannot know this random port from the LSM hook, so no
>> > need to tweak /proc/sys/net/ipv4/ip_local_port_range, and your this is
>> > correct:
>> > 
>> > 1. ip4, sandboxed, bind port 0 -> should return EACCES (denied by
>> > landlock).
>> 
>>   yep, adding rule with port 0 (for bind) returns EINVAL then
>>   calling bind port 0 returns EACCES cause there is no rule with port 0.
>> > 
>> > > > > However, I think the current LSM API don't enable to infer this
>> > > random
>> > > > port because the LSM hook is called before a port is picked.  If this is
>> > > > correct, the best way to control port binding would be to always deny
>> > > > binding on port zero/random (when restricting port binding, whatever
>> > > > exception rules are in place). This explanation should be part of a
>> > > > comment for this specific exception.
>> > > 
>> > >   Yep, if some LSM rule (for bind) has been applied a with specific port,
>> > > other attemps to bind with zero/random ports would be refused by LSM
>> > > security checks.
>> > 
>> > To say it another way, we should not allow to add a rule with port 0 for
>> > LANDLOCK_ACCESS_NET_BIND_TCP, but return -EINVAL in this case. This
>> > limitation should be explained, documented and tested.
>> > 
>> > With (only) LANDLOCK_ACCESS_NET_CONNECT_TCP it should be allowed though
>> > (except if there is also LANDLOCK_ACCESS_NET_BIND_TCP) of course.
>> > Another test should cover the case with a new rule with these two access
>> > rights and port 0.
>> 
>>  I think it's possible to have LANDLOCK_ACCESS_NET_CONNECT_TCP with port 0
>> with LANDLOCK_ACCESS_NET_BIND_TCP at the same time, cause
>> LANDLOCK_ACCESS_NET_BIND_TCP rule is allowed (by Landlock) with any other
>> port but 0.
> 
> It would mask the fact that port zero cannot be allowed, which could be
> possible one day. So for now we need to return EINVAL in this case.

   Got it. I added bind mask in add_rule_net_service() to check that 
zero port is not allowed with bind action. I sent all changes in the 
latest V12 patch.
> .
