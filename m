Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BFE8C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Nov 2023 08:38:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjKBIit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Nov 2023 04:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjKBIis (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2023 04:38:48 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50A7128
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Nov 2023 01:38:42 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qyTDt-0006L0-EI; Thu, 02 Nov 2023 09:38:41 +0100
Date:   Thu, 2 Nov 2023 09:38:41 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 1/1] tests/shell: fix mount command in
 "test-wrapper.sh"
Message-ID: <20231102083841.GC6174@breakpoint.cc>
References: <20231102081601.154862-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231102081601.154862-1-thaller@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thomas Haller <thaller@redhat.com> wrote:
> With Fedora 39 (util-linux-core-2.39.2-1.fc39), the mount command starts
> to fail. It was still working with Fedora 38 (util-linux-core-2.38.1-4.fc38).
> 
>   $ unshare -f -p -m --mount-proc -U --map-root-user -n bash -c 'mount -t tmpfs --make-private /var/run && mount'
>   mount: /run: mount failed: Invalid argument.
> 
> Not sure why this starts to fail. But arguably the command line
> arguments were wrong. Fix it, we need a pseudo name for the device.

Applied, thanks.
