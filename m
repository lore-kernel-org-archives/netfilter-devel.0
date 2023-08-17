Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4CBFC2FC14
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Aug 2023 14:05:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351758AbjHQOEp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 10:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351713AbjHQOEM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 10:04:12 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E651B19E;
        Thu, 17 Aug 2023 07:04:06 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4RRRYh29c4z6HJZY;
        Thu, 17 Aug 2023 22:03:36 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Thu, 17 Aug 2023 15:04:01 +0100
Message-ID: <b0bfa45a-c2bd-545e-ec51-02eeeab0677d@huawei.com>
Date:   Thu, 17 Aug 2023 17:04:00 +0300
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
 <3db64cf8-6a45-a361-aa57-9bfbaf866ef8@digikod.net>
 <30e2bacd-2e48-9056-5950-1974b9373ee3@huawei.com>
 <20230817.EiHicha5shei@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <20230817.EiHicha5shei@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



8/17/2023 4:19 PM, Mickaël Salaün пишет:
> On Sun, Aug 13, 2023 at 11:09:59PM +0300, Konstantin Meskhidze (A) wrote:
>> 
>> 
>> 7/12/2023 10:02 AM, Mickaël Salaün пишет:
>> > 
>> > On 06/07/2023 16:55, Mickaël Salaün wrote:
>> > > From: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> > > 
>> > > This patch is a revamp of the v11 tests [1] with new tests (see the
>> > > "Changes since v11" description).  I (Mickaël) only added the following
>> > > todo list and the "Changes since v11" sections in this commit message.
>> > > I think this patch is good but it would appreciate reviews.
>> > > You can find the diff of my changes here but it is not really readable:
>> > > https://git.kernel.org/mic/c/78edf722fba5 (landlock-net-v11 branch)
>> > > [1] https://lore.kernel.org/all/20230515161339.631577-11-konstantin.meskhidze@huawei.com/
>> > > TODO:
>> > > - Rename all "net_service" to "net_port".
>> > > - Fix the two kernel bugs found with the new tests.
>> > > - Update this commit message with a small description of all tests.
>> > 
>> > [...]
> 
>> > > +FIXTURE(inet)
>> > > +{
>> > > +	struct service_fixture srv0, srv1;
>> > > +};
>> > 
>> > The "inet" variants are useless and should be removed. The "inet"
>> > fixture can then be renamed to "ipv4_tcp".
>> > 
>>   Maybe its better to name it "tcp". So we dont need to copy TEST_F(tcp,
>> port_endianness) for ipv6 and ipv4.
>> What do you think?
> 
> I don't see any need to test with IPv4 and IPv6, hence the "inet" name
> (and without variants). You can rename it to "inet_tcp" to highlight the
> specificities of this fixture.
> 

  I think there was some misunderstanding from my side. So I will rename
inet to inet_tcp and keep all fixture variants:
	- no_sandbox_with_ipv4.
	- sandbox_with_ipv4.
	- no_sandbox_with_ipv6.
	- sandbox_with_ipv6.
Correct?
			
>> 
>> > 
>> > > +
>> > > +FIXTURE_VARIANT(inet)
>> > > +{
>> > > +	const bool is_sandboxed;
>> > > +	const struct protocol_variant prot;
>> > > +};
>> > > +
>> > > +/* clang-format off */
>> > > +FIXTURE_VARIANT_ADD(inet, no_sandbox_with_ipv4) {
>> > > +	/* clang-format on */
>> > > +	.is_sandboxed = false,
>> > > +	.prot = {
>> > > +		.domain = AF_INET,
>> > > +		.type = SOCK_STREAM,
>> > > +	},
>> > > +};
>> > > +
>> > > +/* clang-format off */
>> > > +FIXTURE_VARIANT_ADD(inet, sandbox_with_ipv4) {
>> > > +	/* clang-format on */
>> > > +	.is_sandboxed = true,
>> > > +	.prot = {
>> > > +		.domain = AF_INET,
>> > > +		.type = SOCK_STREAM,
>> > > +	},
>> > > +};
>> > > +
>> > > +/* clang-format off */
>> > > +FIXTURE_VARIANT_ADD(inet, no_sandbox_with_ipv6) {
>> > > +	/* clang-format on */
>> > > +	.is_sandboxed = false,
>> > > +	.prot = {
>> > > +		.domain = AF_INET6,
>> > > +		.type = SOCK_STREAM,
>> > > +	},
>> > > +};
>> > > +
>> > > +/* clang-format off */
>> > > +FIXTURE_VARIANT_ADD(inet, sandbox_with_ipv6) {
>> > > +	/* clang-format on */
>> > > +	.is_sandboxed = true,
>> > > +	.prot = {
>> > > +		.domain = AF_INET6,
>> > > +		.type = SOCK_STREAM,
>> > > +	},
>> > > +};
>> > > +
>> > > +FIXTURE_SETUP(inet)
>> > > +{
>> > > +	const struct protocol_variant ipv4_tcp = {
>> > > +		.domain = AF_INET,
>> > > +		.type = SOCK_STREAM,
>> > > +	};
>> > > +
>> > > +	disable_caps(_metadata);
>> > > +
>> > > +	ASSERT_EQ(0, set_service(&self->srv0, ipv4_tcp, 0));
>> > > +	ASSERT_EQ(0, set_service(&self->srv1, ipv4_tcp, 1));
>> > > +
>> > > +	setup_loopback(_metadata);
>> > > +};
>> > > +
>> > > +FIXTURE_TEARDOWN(inet)
>> > > +{
>> > > +}
>> > > +
>> > > +TEST_F(inet, port_endianness)
>> > > +{
>> > > +	const struct landlock_ruleset_attr ruleset_attr = {
>> > > +		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
>> > > +				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
>> > > +	};
>> > > +	const struct landlock_net_service_attr bind_host_endian_p0 = {
>> > > +		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
>> > > +		/* Host port format. */
>> > > +		.port = self->srv0.port,
>> > > +	};
>> > > +	const struct landlock_net_service_attr connect_big_endian_p0 = {
>> > > +		.allowed_access = LANDLOCK_ACCESS_NET_CONNECT_TCP,
>> > > +		/* Big endian port format. */
>> > > +		.port = htons(self->srv0.port),
>> > > +	};
>> > > +	const struct landlock_net_service_attr bind_connect_host_endian_p1 = {
>> > > +		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
>> > > +				  LANDLOCK_ACCESS_NET_CONNECT_TCP,
>> > > +		/* Host port format. */
>> > > +		.port = self->srv1.port,
>> > > +	};
>> > > +	const unsigned int one = 1;
>> > > +	const char little_endian = *(const char *)&one;
>> > > +	int ruleset_fd;
>> > > +
>> > > +	ruleset_fd =
>> > > +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
>> > > +	ASSERT_LE(0, ruleset_fd);
>> > > +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
>> > > +				       &bind_host_endian_p0, 0));
>> > > +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
>> > > +				       &connect_big_endian_p0, 0));
>> > > +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
>> > > +				       &bind_connect_host_endian_p1, 0));
>> > > +	enforce_ruleset(_metadata, ruleset_fd);
>> > > +
>> > > +	/* No restriction for big endinan CPU. */
>> > > +	test_bind_and_connect(_metadata, &self->srv0, false, little_endian);
>> > > +
>> > > +	/* No restriction for any CPU. */
>> > > +	test_bind_and_connect(_metadata, &self->srv1, false, false);
>> > > +}
>> > > +
>> > > +TEST_HARNESS_MAIN
>> > .
> .
