Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC6D9C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Mar 2022 12:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242657AbiCGMsO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Mar 2022 07:48:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242507AbiCGMrx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Mar 2022 07:47:53 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A4288793;
        Mon,  7 Mar 2022 04:46:58 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nRClI-0006ca-29; Mon, 07 Mar 2022 13:46:52 +0100
Date:   Mon, 7 Mar 2022 13:46:52 +0100
From:   Florian Westphal <fw@strlen.de>
To:     trix@redhat.com
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: conditionally use ct and ctinfo
Message-ID: <20220307124652.GB21350@breakpoint.cc>
References: <20220305180853.696640-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220305180853.696640-1-trix@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

trix@redhat.com <trix@redhat.com> wrote:
> From: Tom Rix <trix@redhat.com>
> 
> The setting ct and ctinfo are controlled by
> CONF_NF_CONNTRACK.  So their use should also
> be controlled.

Any reason for this change?

We try to avoid ifdef where possible, unless it avoids a compiler
warning/build/linker issue.

This doesn't change generated code for me (NF_CONNTRACK=n) either.
