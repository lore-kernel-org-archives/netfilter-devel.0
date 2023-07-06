Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1325EEB64D9
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jul 2023 16:09:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbjGFQJr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Jul 2023 12:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjGFQJq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jul 2023 12:09:46 -0400
Received: from smtp-bc0b.mail.infomaniak.ch (smtp-bc0b.mail.infomaniak.ch [45.157.188.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFC01BD0
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Jul 2023 09:09:43 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4QxhLZ1FhlzMq7xl;
        Thu,  6 Jul 2023 16:09:42 +0000 (UTC)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4QxhLY2C42zMpqbm;
        Thu,  6 Jul 2023 18:09:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1688659782;
        bh=1Zjmn502HPA+0yvPQbN3DQQjsYS0yUUpJ6D6akr8vTE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=TqTrUFllyne62XCaJ9huvbxg57tqATZsADdh39mJkoTyvCqbdCDgMOdZuGEtkidoH
         v8ucgPwko2t0iuipLitxAeC290bd2AO4oamru8X6yup5sqArRcKilbOpeN646gs7ET
         JeLoVd3HcGbM48GNOd2Y5GNfeUqMumh/gIsfvR5o=
Message-ID: <3cd233b9-3cee-ec37-d16a-8dbb13cfd41a@digikod.net>
Date:   Thu, 6 Jul 2023 18:09:25 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v11.1] selftests/landlock: Add 11 new test suites
 dedicated to network
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     artem.kuzin@huawei.com, gnoack3000@gmail.com,
        willemdebruijn.kernel@gmail.com, yusongping@huawei.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
References: <20230515161339.631577-11-konstantin.meskhidze@huawei.com>
 <20230706145543.1284007-1-mic@digikod.net>
Content-Language: en-US
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20230706145543.1284007-1-mic@digikod.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 06/07/2023 16:55, Mickaël Salaün wrote:
> From: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> 
> This patch is a revamp of the v11 tests [1] with new tests (see the
> "Changes since v11" description).  I (Mickaël) only added the following
> todo list and the "Changes since v11" sections in this commit message.
> I think this patch is good but it would appreciate reviews.
> You can find the diff of my changes here but it is not really readable:
> https://git.kernel.org/mic/c/78edf722fba5 (landlock-net-v11 branch)
> [1] https://lore.kernel.org/all/20230515161339.631577-11-konstantin.meskhidze@huawei.com/
> TODO:
> - Rename all "net_service" to "net_port".
> - Fix the two kernel bugs found with the new tests.
> - Update this commit message with a small description of all tests.
> 
> These test suites try to check edge cases for TCP sockets
> bind() and connect() actions.
> 
> inet:
> * bind: Tests with non-landlocked/landlocked ipv4 and ipv6 sockets.
> * connect: Tests with non-landlocked/landlocked ipv4 and ipv6 sockets.
> * bind_afunspec: Tests with non-landlocked/landlocked restrictions
> for bind action with AF_UNSPEC socket family.
> * connect_afunspec: Tests with non-landlocked/landlocked restrictions
> for connect action with AF_UNSPEC socket family.
> * ruleset_overlap: Tests with overlapping rules for one port.
> * ruleset_expanding: Tests with expanding rulesets in which rules are
> gradually added one by one, restricting sockets' connections.
> * inval_port_format: Tests with wrong port format for ipv4/ipv6 sockets
> and with port values more than U16_MAX.
> 
> port:
> * inval: Tests with invalid user space supplied data:
>      - out of range ruleset attribute;
>      - unhandled allowed access;
>      - zero port value;
>      - zero access value;
>      - legitimate access values;
> * bind_connect_inval_addrlen: Tests with invalid address length.
> * bind_connect_unix_*_socket: Tests to make sure unix sockets' actions
> are not restricted by Landlock rules applied to TCP ones.
> 
> layout1:
> * with_net: Tests with network bind() socket action within
> filesystem directory access test.
> 
> Test coverage for security/landlock is 94.8% of 934 lines according
> to gcc/gcov-11.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> Co-developed-by: Mickaël Salaün <mic@digikod.net>
> Signed-off-by: Mickaël Salaün <mic@digikod.net>
> ---
> 
> Changes since v11 (from Mickaël Salaün):
> - Add ipv4.from_unix_to_tcp test suite to check that socket family is
>    the same between a socket and a sockaddr by trying to connect/bind on
>    a unix socket (stream or dgram) using an inet family.  Landlock should
>    not change the error code.  This found a bug (which needs to be fixed)
>    with the TCP restriction.
> - Revamp the inet.{bind,connect} tests into protocol.{bind,connect}:
>    - Merge bind_connect_unix_dgram_socket, bind_connect_unix_dgram_socket
>      and bind_connect_inval_addrlen into it: add a full test matrix of
>      IPv4/TCP, IPv6/TCP, IPv4/UDP, IPv6/UDP, unix/stream, unix/dgram, all
>      of them with or without sandboxing. This improve coverage and it
>      enables to check that a TCP restriction work as expected but doesn't
>      restrict other stream or datagram protocols. This also enables to
>      check consistency of the network stack with or without Landlock.
>      We now have 76 test suites for the network.
>    - Add full send/recv checks.
>    - Make a generic framework that will be ready for future
>      protocol supports.
> - Replace most ASSERT with EXPECT according to the criticity of an
>    action: if we can get more meaningful information with following
>    checks.  For instance, failure to create a kernel object (e.g.
>    socket(), accept() or fork() call) is critical if it is used by
>    following checks. For Landlock ruleset building, the following checks
>    don't make sense if the sandbox is not complete.  However, it doesn't
>    make sense to continue a FIXTURE_SETUP() if any check failed.
> - Add a new unspec fixture to replace inet.bind_afunspec with
>    unspec.bind and inet.connect_afunspec with unspec.connect, factoring
>    and simplifying code.
> - Replace inet.bind_afunspec with protocol.bind_unspec, and
>    inet.connect_afunspec with protocol.connect_unspec.  Extend these
>    tests with the matrix of all "protocol" variants.  Don't test connect
>    with the same socket which is already binded/listening (I guess this
>    was an copy-paste error).  The protocol.bind_unspec tests found a bug
>    (which needs to be fixed).
> - Add and use set_service() and setup_loopback() helpers to configure
>    network services.  Add and use and test_bind_and_connect() to factor
>    out a lot of checks.
> - Add new types (protocol_variant, service_fixture) and update related
>    helpers to get more generic test code.
> - Replace static (port) arrays with service_fixture variables.
> - Add new helpers: {bind,connect}_variant_addrlen() and get_addrlen() to
>    cover all protocols with previous bind_connect_inval_addrlen tests.
>    Make them return -errno in case of error.
> - Switch from a unix socket path address to an abstract one. This
>    enables to avoid file cleanup in test teardowns.
> - Close all rulesets after enforcement.
> - Remove the duplicate "empty access" test.
> - Replace inet.ruleset_overlay with tcp_layers.ruleset_overlap and
>    simplify test:
>    - Always run sandbox tests because test were always run sandboxed and
>      it doesn't give more guarantees to do it not sandboxed.
>    - Rewrite test with variant->num_layers to make it simpler and
>      configurable.
>    - Add another test layer to tcp_layers used for ruleset_overlap and
>      test without sandbox.
>    - Leverage test_bind_and_connect() and avoid using SO_REUSEADDR
>      because the socket was not listened to, and don't use the same
>      socket/FD for server and client.
>    - Replace inet.ruleset_expanding with tcp_layers.ruleset_expand.
> - Drop capabilities in all FIXTURE_SETUP().
> - Change test ports to cover more ranges.
> - Add "mini" tests:
>    - Replace the invalid ruleset attribute test from port.inval with
>      mini.unknow_access_rights.
>    - Simplify port.inval and move some code to other mini.* tests.
>    - Add new mini.network_access_rights test.
> - Rewrite inet.inval_port_format into mini.tcp_port_overflow:
>    - Remove useless is_sandbox checks.
>    - Extend tests with bind/connect checks.
>    - Interleave valid requests with invalid ones.
> - Add two_srv.port_endianness test, extracted and extended from
>    inet.inval_port_format .
> - Add Microsoft copyright.
> - Rename some variables to make them easier to read.
> - Constify variables.
> - Add minimal logs to help debug test failures.
> ---
>   tools/testing/selftests/landlock/config     |    4 +
>   tools/testing/selftests/landlock/fs_test.c  |   64 +
>   tools/testing/selftests/landlock/net_test.c | 1439 +++++++++++++++++++
>   3 files changed, 1507 insertions(+)
>   create mode 100644 tools/testing/selftests/landlock/net_test.c


[...]

> +
> +FIXTURE(inet)
> +{
> +	struct service_fixture srv0, srv1;
> +};
> +
> +FIXTURE_VARIANT(inet)
> +{
> +	const bool is_sandboxed;

Well, this "is_sandboxed" variable can now be removed, and the variants 
updated accordingly.

> +	const struct protocol_variant prot;
> +};
> +
> +/* clang-format off */

Rename to ipv4 and same for the ipv6 variants.

> +FIXTURE_VARIANT_ADD(inet, no_sandbox_with_ipv4) {
> +	/* clang-format on */
> +	.is_sandboxed = false,
> +	.prot = {
> +		.domain = AF_INET,
> +		.type = SOCK_STREAM,
> +	},
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(inet, sandbox_with_ipv4) {
> +	/* clang-format on */
> +	.is_sandboxed = true,
> +	.prot = {
> +		.domain = AF_INET,
> +		.type = SOCK_STREAM,
> +	},
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(inet, no_sandbox_with_ipv6) {
> +	/* clang-format on */
> +	.is_sandboxed = false,
> +	.prot = {
> +		.domain = AF_INET6,
> +		.type = SOCK_STREAM,
> +	},
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(inet, sandbox_with_ipv6) {
> +	/* clang-format on */
> +	.is_sandboxed = true,
> +	.prot = {
> +		.domain = AF_INET6,
> +		.type = SOCK_STREAM,
> +	},
> +};
> +
>
