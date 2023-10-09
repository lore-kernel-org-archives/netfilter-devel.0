Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B327E95A91
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Oct 2023 15:37:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377564AbjJIPhl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Oct 2023 11:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377718AbjJIPhc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Oct 2023 11:37:32 -0400
Received: from smtp-bc09.mail.infomaniak.ch (smtp-bc09.mail.infomaniak.ch [45.157.188.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57110F4
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Oct 2023 08:36:33 -0700 (PDT)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4S436Q2zgVzMqDhj;
        Mon,  9 Oct 2023 15:36:30 +0000 (UTC)
Received: from unknown by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4S436P6ywXzMpnPc;
        Mon,  9 Oct 2023 17:36:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1696865790;
        bh=BJqZcTfNbCj0R22YsFOtc6MUhionL6VnJo/5ED1Q1KA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ESHYUKQGz5ESQZslyPoQ8hV+1Vgjw30+yBsbFzwEKZ0Z0/wt6+K2uCxV4ci1E3GOP
         ohJiSW2yU+ZPaDixYZuGzyfV2swjlfxsTKOzAh21K9eQiY1WpJNCf+OHbFZZmISfsM
         Tj4un9AiOdrBihzbjEtPox761tbxdn5dNsh0mZjQ=
Date:   Mon, 9 Oct 2023 17:36:24 +0200
From:   =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
Subject: Re: [PATCH v12 08/12] landlock: Add network rules and TCP hooks
 support
Message-ID: <20231009.Aej2eequoodi@digikod.net>
References: <20230920092641.832134-1-konstantin.meskhidze@huawei.com>
 <20230920092641.832134-9-konstantin.meskhidze@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230920092641.832134-9-konstantin.meskhidze@huawei.com>
X-Infomaniak-Routing: alpha
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 20, 2023 at 05:26:36PM +0800, Konstantin Meskhidze wrote:
> This commit adds network rules support in the ruleset management
> helpers and the landlock_create_ruleset syscall.
> Refactor user space API to support network actions. Add new network
> access flags, network rule and network attributes. Increment Landlock
> ABI version. Expand access_masks_t to u32 to be sure network access
> rights can be stored. Implement socket_bind() and socket_connect()
> LSM hooks, which enables to restrict TCP socket binding and connection
> to specific ports.
> The new landlock_net_port_attr structure has two fields. The allowed_access
> field contains the LANDLOCK_ACCESS_NET_* rights. The port field contains
> the port value according to the allowed protocol. This field can
> take up to a 64-bit value [1] but the maximum value depends on the related
> protocol (e.g. 16-bit for TCP).
> 
> [1]
> https://lore.kernel.org/r/278ab07f-7583-a4e0-3d37-1bacd091531d@digikod.net

Could you please include here the rationale to not tie access rights to
sockets' file descriptor, and link [2]?

[2] https://lore.kernel.org/r/263c1eb3-602f-57fe-8450-3f138581bee7@digikod.net
