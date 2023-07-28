Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5EF5C001E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jul 2023 03:29:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbjG1D27 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jul 2023 23:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbjG1D26 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jul 2023 23:28:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 740A426AE
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jul 2023 20:28:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1023F61FBE
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jul 2023 03:28:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B254C433C8;
        Fri, 28 Jul 2023 03:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690514932;
        bh=76O3/OzQ12gtVktUqmmUnI31vjwENyYHhcDhdnLesc0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=feYeINk0/xC7jzO9w4HmVaeRKsCVxNQj4shmJ2qyB14aa24QSl67rYEmC+AvY9CnF
         4EhFSZPunXW5IRqLid7tmGlqbH7nbdrW7JrrhlItG3oxFKyhxCFjpnDkEJe7jvWavO
         ma5L30HN8JWFb6woiS6SrQ/9qygXeNxCJNkKw9EeaWj1e/HUjZMXBRCG7+rzyvhE7B
         je52l3BvOSjdINUSbr7OY4HOelaeHRd3mhJ6gMqAk7Bn0JwMn7cdnFgiNZZqqBeI5x
         C2lwBp346Tssdta0+IJguTfXbBPYCZHH6DU4Gys6bgqs4itPdtexVGxJo2SW2JZnEF
         Ng1hzIJPaQPkg==
Date:   Thu, 27 Jul 2023 20:28:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        <netfilter-devel@vger.kernel.org>, Zhu Wang <wangzhu9@huawei.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net-next 1/5] nf_conntrack: fix -Wunused-const-variable=
Message-ID: <20230727202851.5a7cc498@kernel.org>
In-Reply-To: <20230727202811.7b892de5@kernel.org>
References: <20230727133604.8275-1-fw@strlen.de>
        <20230727133604.8275-2-fw@strlen.de>
        <20230727202811.7b892de5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 27 Jul 2023 20:28:11 -0700 Jakub Kicinski wrote:
> > We include dccp_state_names in the macro
> > CONFIG_NF_CONNTRACK_PROCFS, since it is only used in the place
> > which is included in the macro CONFIG_NF_CONNTRACK_PROCFS.  
> 
> FTR I can't say I see this with the versions of gcc / clang I have :S

Ignore. Just my stupidity.
