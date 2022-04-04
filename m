Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E276AC47084
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 21:39:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239814AbiDDVlF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 17:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379988AbiDDSeS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 14:34:18 -0400
Received: from smtp-8fac.mail.infomaniak.ch (smtp-8fac.mail.infomaniak.ch [83.166.143.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3602E0AF
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 11:32:20 -0700 (PDT)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4KXKBV48wlzMpvVR;
        Mon,  4 Apr 2022 20:32:18 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4KXKBT6wMFzlhRVT;
        Mon,  4 Apr 2022 20:32:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1649097138;
        bh=YAOsStc2y5wOQ15cC5RQNCD4FLyM/10VhMrFzxISgno=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=dexQLDYr9HI4i84PBFN4kfFFHH7V/THIYIw9SnEIu6mK92PIi9YM/lsl1sSUAYaSN
         +AGPbebQ3W/4GZ1fNlMaDLJyokXVrygARsFiZORaETOEStrGvOZtp5L+wU2GcHH38T
         vL3xoFDW1zl5GSL4IQaEgqYDq1+2d6NX0LzFygco=
Message-ID: <c2bc5ccf-8942-ab5e-c071-6f6c6e6b2d9d@digikod.net>
Date:   Mon, 4 Apr 2022 20:32:42 +0200
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com, anton.sirazetdinov@huawei.com
References: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
 <20220309134459.6448-11-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [RFC PATCH v4 10/15] seltest/landlock: add tests for bind() hooks
In-Reply-To: <20220309134459.6448-11-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 09/03/2022 14:44, Konstantin Meskhidze wrote:
> Adds two selftests for bind socket action.
> The one is with no landlock restrictions:
>      - bind_no_restrictions;
> The second one is with mixed landlock rules:
>      - bind_with_restrictions;
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v3:
> * Split commit.
> * Add helper create_socket.
> * Add FIXTURE_SETUP.
> 
> ---
>   .../testing/selftests/landlock/network_test.c | 153 ++++++++++++++++++
>   1 file changed, 153 insertions(+)
>   create mode 100644 tools/testing/selftests/landlock/network_test.c
> 
> diff --git a/tools/testing/selftests/landlock/network_test.c b/tools/testing/selftests/landlock/network_test.c
> new file mode 100644
> index 000000000000..4c60f6d973a8
> --- /dev/null
> +++ b/tools/testing/selftests/landlock/network_test.c

[...]

> +
> +uint port[MAX_SOCKET_NUM];
> +struct sockaddr_in addr[MAX_SOCKET_NUM];

You should not change global variables, it is a source of issue. Instead 
use FIXTURE local variables accessible through self->X.

> +
> +const int one = 1;

This doesn't need to be global.

[...]

> +
> +static void enforce_ruleset(struct __test_metadata *const _metadata,
> +		const int ruleset_fd)
> +{
> +	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
> +	ASSERT_EQ(0, landlock_restrict_self(ruleset_fd, 0)) {
> +		TH_LOG("Failed to enforce ruleset: %s", strerror(errno));
> +	}
> +}

You should move the same helper from fs_base.c to common.h (see caps 
helpers) and reuse it here.


> +
> +FIXTURE(socket) { };
> +
> +FIXTURE_SETUP(socket)
> +{
> +	int i;

Please add a new line between declaration and actual code (everywhere).

> +	/* Creates socket addresses */
> +	for (i = 0; i < MAX_SOCKET_NUM; i++) {

Use ARRAY_SIZE() instead of MAY_SOCKET_NUM.


> +		port[i] = SOCK_PORT_START + SOCK_PORT_ADD*i;

Use self->port[i] and self->addr[i] instead.

> +		addr[i].sin_family = AF_INET;
> +		addr[i].sin_port = htons(port[i]);
> +		addr[i].sin_addr.s_addr = inet_addr(IP_ADDRESS);
> +		memset(&(addr[i].sin_zero), '\0', 8);
> +	}
> +}

[...]

> +	/* Allows connect and deny bind operations to the port[1] socket. */
> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
> +				&net_service_2, 0));
> +	/* Empty allowed_access (i.e. deny rules) are ignored in network actions

The kernel coding style says to start a multi-line comments with a "/*" 
and a new line.
