Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C43CCEE644B
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Sep 2023 08:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbjIOI5Y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Sep 2023 04:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233269AbjIOI5X (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Sep 2023 04:57:23 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5998B3ABD;
        Fri, 15 Sep 2023 01:54:51 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Rn7KF41bTz6K6ph;
        Fri, 15 Sep 2023 16:54:09 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Fri, 15 Sep 2023 09:54:47 +0100
Message-ID: <076bfaa6-1e0b-c95b-5727-00001c79f2c0@huawei.com>
Date:   Fri, 15 Sep 2023 11:54:46 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v11.1] selftests/landlock: Add 11 new test suites
 dedicated to network
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>,
        Paul Moore <paul@paul-moore.com>
CC:     <artem.kuzin@huawei.com>, <gnoack3000@gmail.com>,
        <willemdebruijn.kernel@gmail.com>, <yusongping@huawei.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>
References: <20230515161339.631577-11-konstantin.meskhidze@huawei.com>
 <20230706145543.1284007-1-mic@digikod.net>
 <3db64cf8-6a45-a361-aa57-9bfbaf866ef8@digikod.net>
 <b2a94da1-f9df-b684-7666-1c63060f68f1@huawei.com>
 <20230817.koh5see0eaLa@digikod.net>
 <239800f3-baf4-1c7d-047f-8ba90b097bee@huawei.com>
 <20230914.ASu9sho1Aef0@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <20230914.ASu9sho1Aef0@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml100005.china.huawei.com (7.191.160.25) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



9/14/2023 11:08 AM, Mickaël Salaün пишет:
> On Mon, Sep 11, 2023 at 01:13:24PM +0300, Konstantin Meskhidze (A) wrote:
>> 
>> 
>> 8/17/2023 6:08 PM, Mickaël Salaün пишет:
>> > On Sat, Aug 12, 2023 at 05:37:00PM +0300, Konstantin Meskhidze (A) wrote:
>> > > 
>> > > 
>> > > 7/12/2023 10:02 AM, Mickaël Salaün пишет:
>> > > > > On 06/07/2023 16:55, Mickaël Salaün wrote:
>> > > > > From: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> > > > > > > This patch is a revamp of the v11 tests [1] with new tests
>> > > (see the
>> > > > > "Changes since v11" description).  I (Mickaël) only added the following
>> > > > > todo list and the "Changes since v11" sections in this commit message.
>> > > > > I think this patch is good but it would appreciate reviews.
>> > > > > You can find the diff of my changes here but it is not really readable:
>> > > > > https://git.kernel.org/mic/c/78edf722fba5 (landlock-net-v11 branch)
>> > > > > [1] https://lore.kernel.org/all/20230515161339.631577-11-konstantin.meskhidze@huawei.com/
>> > > > > TODO:
>> > > > > - Rename all "net_service" to "net_port".
>> > > > > - Fix the two kernel bugs found with the new tests.
>> > > > > - Update this commit message with a small description of all tests.
>> > > > > [...]
>> > 
>> > > > We should also add a test to make sure errno is the same with and
>> > > > without sandboxing when using port 0 for connect and consistent with
>> > > > bind (using an available port). The test fixture and variants should be
>> > > > quite similar to the "ipv4" ones, but we can also add AF_INET6 variants,
>> > > > which will result in 8 "ip" variants:
>> > > > > TEST_F(ip, port_zero)
>> > > > {
>> > > > 	if (variant->sandbox == TCP_SANDBOX) {
>> > > > 		/* Denies any connect and bind. */
>> > > > 	}
>> > > > 	/* Checks errno for port 0. */
>> > > > }
>> > > As I understand the would be the next test cases:
>> > > 
>> > > 	1. ip4, sandboxed, bind port 0 -> should return EACCES (denied by
>> > > landlock).
>> > 
>> > Without any allowed port, yes. This test case is useful.
>> > 
>> > By tuning /proc/sys/net/ipv4/ip_local_port_range (see
>> > inet_csk_find_open_port call) we should be able to pick a specific
>> > allowed port and test it.  We can also test for the EADDRINUSE error to
>> > make sure error ordering is correct (compared with -EACCES).
>>   Sorry, did not get this case. Could please explain it with more details?
> 
> According to bind(2), if no port are available, the syscall should
> return EADDRINUSE. And this returned value should be the same whatever
> the process is sandbox or not (and never EACCES). But as I explained
> just below, we cannot know this random port from the LSM hook, so no
> need to tweak /proc/sys/net/ipv4/ip_local_port_range, and your this is
> correct:
> 
> 1. ip4, sandboxed, bind port 0 -> should return EACCES (denied by
> landlock).

   yep, adding rule with port 0 (for bind) returns EINVAL then
   calling bind port 0 returns EACCES cause there is no rule with port 0.
> 
>> > 
>> > However, I think the current LSM API don't enable to infer this random
>> > port because the LSM hook is called before a port is picked.  If this is
>> > correct, the best way to control port binding would be to always deny
>> > binding on port zero/random (when restricting port binding, whatever
>> > exception rules are in place). This explanation should be part of a
>> > comment for this specific exception.
>> 
>>   Yep, if some LSM rule (for bind) has been applied a with specific port,
>> other attemps to bind with zero/random ports would be refused by LSM
>> security checks.
> 
> To say it another way, we should not allow to add a rule with port 0 for
> LANDLOCK_ACCESS_NET_BIND_TCP, but return -EINVAL in this case. This
> limitation should be explained, documented and tested.
> 
> With (only) LANDLOCK_ACCESS_NET_CONNECT_TCP it should be allowed though
> (except if there is also LANDLOCK_ACCESS_NET_BIND_TCP) of course.
> Another test should cover the case with a new rule with these two access
> rights and port 0.

  I think it's possible to have LANDLOCK_ACCESS_NET_CONNECT_TCP with 
port 0 with LANDLOCK_ACCESS_NET_BIND_TCP at the same time, cause 
LANDLOCK_ACCESS_NET_BIND_TCP rule is allowed (by Landlock) with any 
other port but 0.

> 
>> > 
>> > Cc Paul
>> > 
>> > > 	2. ip4, non-sandboxed, bind port 0 -> should return 0 (should be bounded to
>> > > random port).
>> > 
>> > I think so but we need to make sure the random port cannot be < 1024, I
>> > guess with /proc/sys/net/ipv4/ip_local_port_range but I don't know for
>> > IPv6.
>> 
>>   For ipv4 when connecting to a server a client binds to a random port
>> within /proc/sys/net/ipv4/ip_local_port_range, by default one my machine
>> this range is: cat /proc/sys/net/ipv4/ip_local_port_range
>> 32768   60999.
>> But for ipv6 there is no such tuning range.
> 
> Ok, let's just assume that the test system doesn't have
> ip_local_port_range < 1024, put this assumption in a comment, and don't
> touch ip_local_port_range at all.
> 
>> 
>> > 
>> > > 	3. ip6, sandboxed, bind port 0 -> should return EACCES (denied by
>> > > landlock).
>> > > 	4. ip6, non-sandboxed, bind port 0 -> should return 0 (should be bounded to
>> > > random port).
>> > > 	5. ip4, sandboxed, bind some available port, connect port 0 -> should
>> > > return -EACCES (denied by landlock).
> 
> If a rule allows connecting to port 0, then it should be ECONNREFUSED,
> otherwise EACCES indeed. Both cases should be tested.
> 
>> > 
>> > Yes, but don't need to bind to anything (same for the next ones).
>> > 
>> > > 	6. ip4, non-sandboxed, bind some available port, connect port 0 -> should
>> > > return ECONNREFUSED.
>> > 
>> > Yes, but without any binding.
>> > 
>> > > 	7. ip6, sandboxed, bind some available port, connect port 0 -> should
>> > > return -EACCES (denied by landlock)
>> > > 	8. ip6, non-sandboxed, some bind available port, connect port 0 -> should
>> > > return ECONNREFUSED.
>> > > 
>> > > Correct?
>> > 
>> > Thinking more about this case, being able to add a rule with port zero
>> > *for a connect action* looks legitimate.  A rule with both connect and
>> > bind actions on port zero should then be denied.  We should fix
>> > add_rule_net_service() and test that (with a first layer allowing port
>> > zero, and a second without rule, for connect).
>> 
>>  So with first rule allowing port 0 connect action, the second rule with
>> some another port and connect action,
> 
> Yes, but the first rule being part of a first layer/restriction, and the
> second rule part of a second layer.
> 
>> as a result test should allow that.
>> Correct?
> 
> The first layer should return ECONNREFUSED when connecting on port 0
> (allowed but nothing listening), and once the second layer is enforced,
> EACCES should be returned on port 0.
> 
>> > 
>> > 
>> > > 
>> > > > > [...]
>> > > > > > +FIXTURE(inet)
>> > > > > +{
>> > > > > +	struct service_fixture srv0, srv1;
>> > > > > +};
>> > > > > The "inet" variants are useless and should be removed. The
>> > > "inet"
>> > > > fixture can then be renamed to "ipv4_tcp".
>> > > >   So inet should be changed to ipv4_tcp and ipv6_tcp with next
>> > > variants:
>> > > 
>> > >   - ipv4_tcp.no_sandbox_with_ipv4.port_endianness
>> > >   - ipv4_tcp.sandbox_with_ipv4.port_endianness
>> > >   - ipv6_tcp.no_sandbox_with_ipv6.port_endianness
>> > >   - ipv6_tcp.sandbox_with_ipv6.port_endianness
>> > > ????
>> > > 
>> > >    in this case we need double copy of TEST_F(inet, port_endianness) :
>> > > 	TEST_F(ipv4_tcp, port_endianness)
>> > > 	TEST_F(ipv6_tcp, port_endianness)
>> > 
>> > There is no need for any variant for the port_endianness test. You can
>> > rename "inet" to "ipv4_tcp" (and not "inet_tcp" like I said before).
>> > .
> .
