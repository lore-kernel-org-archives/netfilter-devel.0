From: Aaron Conole <aconole@bytheb.org>
Subject: Re: [PATCH nf] netfilter: core: remove erroneous warn_on
Date: Wed, 06 Sep 2017 17:51:14 -0400
Message-ID: <f7tzia7sdgt.fsf@dhcp-25-97.bos.redhat.com>
References: <20170906124757.13934-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:33988 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752501AbdIFVvS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2017 17:51:18 -0400
Received: by mail-qk0-f194.google.com with SMTP id d70so4596190qkc.1
        for <netfilter-devel@vger.kernel.org>; Wed, 06 Sep 2017 14:51:18 -0700 (PDT)
In-Reply-To: <20170906124757.13934-1-fw@strlen.de> (Florian Westphal's message
        of "Wed, 6 Sep 2017 14:47:57 +0200")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> writes:

> kernel test robot reported:
>
> WARNING: CPU: 0 PID: 1244 at net/netfilter/core.c:218 __nf_hook_entries_try_shrink+0x49/0xcd
> [..]
>
> After allowing batching in nf_unregister_net_hooks its possible that an earlier
> call to __nf_hook_entries_try_shrink already compacted the list.
> If this happens we don't need to do anything.
>
> Fixes: d3ad2c17b4047 ("netfilter: core: batch nf_unregister_net_hooks synchronize_net calls")
> Reported-by: kernel test robot <xiaolong.ye@intel.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---


Acked-by: Aaron Conole <aconole@bytheb.org>
