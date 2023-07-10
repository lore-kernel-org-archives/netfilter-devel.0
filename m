Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8008AEB64DC
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jul 2023 16:06:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbjGJQG2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Jul 2023 12:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbjGJQG1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jul 2023 12:06:27 -0400
Received: from smtp-8fab.mail.infomaniak.ch (smtp-8fab.mail.infomaniak.ch [IPv6:2001:1600:3:17::8fab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F059AC3
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jul 2023 09:06:24 -0700 (PDT)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4R084t4Y8PzMqNQd;
        Mon, 10 Jul 2023 16:06:22 +0000 (UTC)
Received: from unknown by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4R084s66tYzMppq8;
        Mon, 10 Jul 2023 18:06:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1689005182;
        bh=FT/Iq0DkCVsHjKVPnLtkqhfF27BDGNgGWVrpdACmXk0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=TZWMOyKWuN2dIVcNQ0Xt+RBGhwk566pffa1tNEQ5sRkgwBbLskWEWcWDHIDghkdUs
         zjV1y8enxIzm0sozCYPfkHXuR5TzvwU5b8ngi+nmwy3z0PQh2eZqp1e4kJK5I6OuUT
         FGV9stNmBa9f/ioX9ixR0pUmdhsdazgMw+PMjoOQ=
Message-ID: <f8f76bff-c434-07f8-8a53-f8a0d69292b1@digikod.net>
Date:   Mon, 10 Jul 2023 18:06:21 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v11.1] selftests/landlock: Add 11 new test suites
 dedicated to network
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     artem.kuzin@huawei.com, gnoack3000@gmail.com,
        willemdebruijn.kernel@gmail.com, yusongping@huawei.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
References: <20230515161339.631577-11-konstantin.meskhidze@huawei.com>
 <20230706145543.1284007-1-mic@digikod.net>
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


[...]

> +static int bind_variant_addrlen(const int sock_fd,
> +				const struct service_fixture *const srv,
> +				const socklen_t addrlen)
> +{
> +	int ret;
> +
> +	switch (srv->protocol.domain) {
> +	case AF_UNSPEC:
> +	case AF_INET:
> +		ret = bind(sock_fd, &srv->ipv4_addr, addrlen);
> +		break;
> +
> +	case AF_INET6:
> +		ret = bind(sock_fd, &srv->ipv6_addr, addrlen);
> +		break;
> +
> +	case AF_UNIX:
> +		ret = bind(sock_fd, &srv->unix_addr, addrlen);
> +		break;
> +
> +	default:
> +		errno = -EAFNOSUPPORT;

This should be `errno = EAFNOSUPPORT`

> +		return -errno;
> +	}
> +
> +	if (ret < 0)
> +		return -errno;
> +	return ret;
