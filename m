Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06257EB64DA
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jul 2023 12:24:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbjGJMYn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Jul 2023 08:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjGJMYn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jul 2023 08:24:43 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D1BC7;
        Mon, 10 Jul 2023 05:24:40 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4R035T1P3Jz687PR;
        Mon, 10 Jul 2023 20:21:33 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 10 Jul 2023 13:24:37 +0100
Message-ID: <bd4a889d-b0dd-9977-6d99-8c4362954cc4@huawei.com>
Date:   Mon, 10 Jul 2023 15:24:37 +0300
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
 <3cd233b9-3cee-ec37-d16a-8dbb13cfd41a@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <3cd233b9-3cee-ec37-d16a-8dbb13cfd41a@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



7/6/2023 7:09 PM, Mickaël Salaün пишет:
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
>> These test suites try to check edge cases for TCP sockets
>> bind() and connect() actions.
>> 
>> inet:
>> * bind: Tests with non-landlocked/landlocked ipv4 and ipv6 sockets.
>> * connect: Tests with non-landlocked/landlocked ipv4 and ipv6 sockets.
>> * bind_afunspec: Tests with non-landlocked/landlocked restrictions
>> for bind action with AF_UNSPEC socket family.
>> * connect_afunspec: Tests with non-landlocked/landlocked restrictions
>> for connect action with AF_UNSPEC socket family.
>> * ruleset_overlap: Tests with overlapping rules for one port.
>> * ruleset_expanding: Tests with expanding rulesets in which rules are
>> gradually added one by one, restricting sockets' connections.
>> * inval_port_format: Tests with wrong port format for ipv4/ipv6 sockets
>> and with port values more than U16_MAX.
>> 
>> port:
>> * inval: Tests with invalid user space supplied data:
>>      - out of range ruleset attribute;
>>      - unhandled allowed access;
>>      - zero port value;
>>      - zero access value;
>>      - legitimate access values;
>> * bind_connect_inval_addrlen: Tests with invalid address length.
>> * bind_connect_unix_*_socket: Tests to make sure unix sockets' actions
>> are not restricted by Landlock rules applied to TCP ones.
>> 
>> layout1:
>> * with_net: Tests with network bind() socket action within
>> filesystem directory access test.
>> 
>> Test coverage for security/landlock is 94.8% of 934 lines according
>> to gcc/gcov-11.
>> 
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> Co-developed-by: Mickaël Salaün <mic@digikod.net>
>> Signed-off-by: Mickaël Salaün <mic@digikod.net>
>> ---
>> 
>> Changes since v11 (from Mickaël Salaün):
>> - Add ipv4.from_unix_to_tcp test suite to check that socket family is
>>    the same between a socket and a sockaddr by trying to connect/bind on
>>    a unix socket (stream or dgram) using an inet family.  Landlock should
>>    not change the error code.  This found a bug (which needs to be fixed)
>>    with the TCP restriction.
>> - Revamp the inet.{bind,connect} tests into protocol.{bind,connect}:
>>    - Merge bind_connect_unix_dgram_socket, bind_connect_unix_dgram_socket
>>      and bind_connect_inval_addrlen into it: add a full test matrix of
>>      IPv4/TCP, IPv6/TCP, IPv4/UDP, IPv6/UDP, unix/stream, unix/dgram, all
>>      of them with or without sandboxing. This improve coverage and it
>>      enables to check that a TCP restriction work as expected but doesn't
>>      restrict other stream or datagram protocols. This also enables to
>>      check consistency of the network stack with or without Landlock.
>>      We now have 76 test suites for the network.
>>    - Add full send/recv checks.
>>    - Make a generic framework that will be ready for future
>>      protocol supports.
>> - Replace most ASSERT with EXPECT according to the criticity of an
>>    action: if we can get more meaningful information with following
>>    checks.  For instance, failure to create a kernel object (e.g.
>>    socket(), accept() or fork() call) is critical if it is used by
>>    following checks. For Landlock ruleset building, the following checks
>>    don't make sense if the sandbox is not complete.  However, it doesn't
>>    make sense to continue a FIXTURE_SETUP() if any check failed.
>> - Add a new unspec fixture to replace inet.bind_afunspec with
>>    unspec.bind and inet.connect_afunspec with unspec.connect, factoring
>>    and simplifying code.
>> - Replace inet.bind_afunspec with protocol.bind_unspec, and
>>    inet.connect_afunspec with protocol.connect_unspec.  Extend these
>>    tests with the matrix of all "protocol" variants.  Don't test connect
>>    with the same socket which is already binded/listening (I guess this
>>    was an copy-paste error).  The protocol.bind_unspec tests found a bug
>>    (which needs to be fixed).
>> - Add and use set_service() and setup_loopback() helpers to configure
>>    network services.  Add and use and test_bind_and_connect() to factor
>>    out a lot of checks.
>> - Add new types (protocol_variant, service_fixture) and update related
>>    helpers to get more generic test code.
>> - Replace static (port) arrays with service_fixture variables.
>> - Add new helpers: {bind,connect}_variant_addrlen() and get_addrlen() to
>>    cover all protocols with previous bind_connect_inval_addrlen tests.
>>    Make them return -errno in case of error.
>> - Switch from a unix socket path address to an abstract one. This
>>    enables to avoid file cleanup in test teardowns.
>> - Close all rulesets after enforcement.
>> - Remove the duplicate "empty access" test.
>> - Replace inet.ruleset_overlay with tcp_layers.ruleset_overlap and
>>    simplify test:
>>    - Always run sandbox tests because test were always run sandboxed and
>>      it doesn't give more guarantees to do it not sandboxed.
>>    - Rewrite test with variant->num_layers to make it simpler and
>>      configurable.
>>    - Add another test layer to tcp_layers used for ruleset_overlap and
>>      test without sandbox.
>>    - Leverage test_bind_and_connect() and avoid using SO_REUSEADDR
>>      because the socket was not listened to, and don't use the same
>>      socket/FD for server and client.
>>    - Replace inet.ruleset_expanding with tcp_layers.ruleset_expand.
>> - Drop capabilities in all FIXTURE_SETUP().
>> - Change test ports to cover more ranges.
>> - Add "mini" tests:
>>    - Replace the invalid ruleset attribute test from port.inval with
>>      mini.unknow_access_rights.
>>    - Simplify port.inval and move some code to other mini.* tests.
>>    - Add new mini.network_access_rights test.
>> - Rewrite inet.inval_port_format into mini.tcp_port_overflow:
>>    - Remove useless is_sandbox checks.
>>    - Extend tests with bind/connect checks.
>>    - Interleave valid requests with invalid ones.
>> - Add two_srv.port_endianness test, extracted and extended from
>>    inet.inval_port_format .
>> - Add Microsoft copyright.
>> - Rename some variables to make them easier to read.
>> - Constify variables.
>> - Add minimal logs to help debug test failures.
>> ---
>>   tools/testing/selftests/landlock/config     |    4 +
>>   tools/testing/selftests/landlock/fs_test.c  |   64 +
>>   tools/testing/selftests/landlock/net_test.c | 1439 +++++++++++++++++++
>>   3 files changed, 1507 insertions(+)
>>   create mode 100644 tools/testing/selftests/landlock/net_test.c
> 
> 
> [...]
> 
>> +
>> +FIXTURE(inet)
>> +{
>> +	struct service_fixture srv0, srv1;
>> +};
>> +
>> +FIXTURE_VARIANT(inet)
>> +{
>> +	const bool is_sandboxed;
> 
> Well, this "is_sandboxed" variable can now be removed, and the variants
> updated accordingly.

   Ok. Thanks. Im reviewing the patch now.
> 
>> +	const struct protocol_variant prot;
>> +};
>> +
>> +/* clang-format off */
> 
> Rename to ipv4 and same for the ipv6 variants.

   Got it.
> 
>> +FIXTURE_VARIANT_ADD(inet, no_sandbox_with_ipv4) {
>> +	/* clang-format on */
>> +	.is_sandboxed = false,
>> +	.prot = {
>> +		.domain = AF_INET,
>> +		.type = SOCK_STREAM,
>> +	},
>> +};
>> +
>> +/* clang-format off */
>> +FIXTURE_VARIANT_ADD(inet, sandbox_with_ipv4) {
>> +	/* clang-format on */
>> +	.is_sandboxed = true,
>> +	.prot = {
>> +		.domain = AF_INET,
>> +		.type = SOCK_STREAM,
>> +	},
>> +};
>> +
>> +/* clang-format off */
>> +FIXTURE_VARIANT_ADD(inet, no_sandbox_with_ipv6) {
>> +	/* clang-format on */
>> +	.is_sandboxed = false,
>> +	.prot = {
>> +		.domain = AF_INET6,
>> +		.type = SOCK_STREAM,
>> +	},
>> +};
>> +
>> +/* clang-format off */
>> +FIXTURE_VARIANT_ADD(inet, sandbox_with_ipv6) {
>> +	/* clang-format on */
>> +	.is_sandboxed = true,
>> +	.prot = {
>> +		.domain = AF_INET6,
>> +		.type = SOCK_STREAM,
>> +	},
>> +};
>> +
>>
> .
