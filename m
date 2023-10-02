Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECC63E7490C
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Oct 2023 20:26:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235696AbjJBU05 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Oct 2023 16:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235924AbjJBU05 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Oct 2023 16:26:57 -0400
Received: from smtp-42a8.mail.infomaniak.ch (smtp-42a8.mail.infomaniak.ch [84.16.66.168])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7CCDD
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Oct 2023 13:26:53 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Rzstd2zZxzMq8P9;
        Mon,  2 Oct 2023 20:26:49 +0000 (UTC)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4Rzstc6pWCzMpp9v;
        Mon,  2 Oct 2023 22:26:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1696278409;
        bh=FQO4GYtxljEfIaFZeQ1Y6yEZIrp0kicWALHfGDHmN0k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AmroIdmZHCbvRmg5IsMg7QKReKE1dWoeCGFwiL1hHV9lt/MyfI7bUsAmj0N0diwLV
         3PLZ286IUVxZeTgv+XVezY1PW32d6DiLA5AREY7pBBemZ/m/6esksvEAYWyMBXtKpa
         nj5uOqseF2Rbn5jSOaJNAylyAJxc/fG/w17dBSRQ=
Date:   Mon, 2 Oct 2023 22:26:48 +0200
From:   =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
Subject: Re: [PATCH v12 02/12] landlock: Allow filesystem layout changes for
 domains without such rule type
Message-ID: <20231001.lahkohr4pu4P@digikod.net>
References: <20230920092641.832134-1-konstantin.meskhidze@huawei.com>
 <20230920092641.832134-3-konstantin.meskhidze@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230920092641.832134-3-konstantin.meskhidze@huawei.com>
X-Infomaniak-Routing: alpha
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Please change the subject to "landlock: Allow FS topology changes for
domains without such rule type" to be consistent with the documentation.


On Wed, Sep 20, 2023 at 05:26:30PM +0800, Konstantin Meskhidze wrote:
> From: Mickaël Salaün <mic@digikod.net>
> 
> Allow mount point and root directory changes when there is no filesystem
> rule tied to the current Landlock domain.  This doesn't change anything
> for now because a domain must have at least a (filesystem) rule, but
> this will change when other rule types will come.  For instance, a
> domain only restricting the network should have no impact on filesystem
> restrictions.
> 
> Add a new get_current_fs_domain() helper to quickly check filesystem
> rule existence for all filesystem LSM hooks.
> 
> Remove unnecessary inlining.
> 
> Signed-off-by: Mickaël Salaün <mic@digikod.net>
