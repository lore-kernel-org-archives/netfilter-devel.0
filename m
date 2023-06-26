Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8192EB64DD
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Jun 2023 19:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjFZTAH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Jun 2023 15:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbjFZTAF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Jun 2023 15:00:05 -0400
Received: from smtp-bc0d.mail.infomaniak.ch (smtp-bc0d.mail.infomaniak.ch [IPv6:2001:1600:3:17::bc0d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A7A710CB
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jun 2023 11:59:57 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Qqcbb3j51zMqHtw;
        Mon, 26 Jun 2023 18:59:55 +0000 (UTC)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4QqcbZ4T7mzMpvTt;
        Mon, 26 Jun 2023 20:59:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1687805995;
        bh=Rp8e/1RLaJ/xuqp2uYfEReDbnGzeQ5DGvewG/zWsFBs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=VPR0HlK1nc9903KzRFaGnqZer/CQ0zCy2kFFF+lh2wpFH2ymZL1IbR9MMIBaolGjz
         0WmeQ6p+F8Dl4S+xFBfmVel3m+gq7wXuScNBDRvshV7z1GJ6J7k0euWiWHAtVwZEZ2
         qusN8URnhgyroKm+MvsEpsB5Ov5q7EYS/7rGZjd8=
Message-ID: <524f3c11-f228-1519-451f-c992bff8be79@digikod.net>
Date:   Mon, 26 Jun 2023 20:59:54 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v11 12/12] landlock: Document Landlock's network support
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20230515161339.631577-1-konstantin.meskhidze@huawei.com>
 <20230515161339.631577-13-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20230515161339.631577-13-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 15/05/2023 18:13, Konstantin Meskhidze wrote:
> Describe network access rules for TCP sockets. Add network access
> example in the tutorial. Add kernel configuration support for network.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v10:
> * Fixes documentaion as Mickaёl suggested:
> https://lore.kernel.org/linux-security-module/ec23be77-566e-c8fd-179e-f50e025ac2cf@digikod.net/
> 
> Changes since v9:
> * Minor refactoring.
> 
> Changes since v8:
> * Minor refactoring.
> 
> Changes since v7:
> * Fixes documentaion logic errors and typos as Mickaёl suggested:
> https://lore.kernel.org/netdev/9f354862-2bc3-39ea-92fd-53803d9bbc21@digikod.net/
> 
> Changes since v6:
> * Adds network support documentaion.
> 
> ---
>   Documentation/userspace-api/landlock.rst | 83 ++++++++++++++++++------
>   1 file changed, 62 insertions(+), 21 deletions(-)
> 

[...]

> @@ -143,10 +159,23 @@ for the ruleset creation, by filtering access rights according to the Landlock
>   ABI version.  In this example, this is not required because all of the requested
>   ``allowed_access`` rights are already available in ABI 1.
> 
> -We now have a ruleset with one rule allowing read access to ``/usr`` while
> -denying all other handled accesses for the filesystem.  The next step is to
> -restrict the current thread from gaining more privileges (e.g. thanks to a SUID
> -binary).
> +For network access-control, we can add a set of rules that allow to use a port
> +number for a specific action: HTTPS connections.
> +
> +.. code-block:: c
> +
> +    struct landlock_net_service_attr net_service = {
> +        .allowed_access = NET_CONNECT_TCP,

LANDLOCK_ACCESS_NET_CONNECT_TCP


> +        .port = 443,
> +    };
> +
> +    err = landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
> +                            &net_service, 0);
> +
