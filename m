From: Aaron Conole <aconole@bytheb.org>
Subject: Re: [PATCH nf] netfilter: x_tables: suppress kmemcheck warning
Date: Mon, 17 Oct 2016 16:16:03 -0400
Message-ID: <f7t4m4aivek.fsf@redhat.com>
References: <1476733823-10714-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:35428 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754883AbcJQUQH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2016 16:16:07 -0400
Received: by mail-qk0-f196.google.com with SMTP id v138so15136915qka.2
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 13:16:06 -0700 (PDT)
In-Reply-To: <1476733823-10714-1-git-send-email-fw@strlen.de> (Florian
        Westphal's message of "Mon, 17 Oct 2016 21:50:23 +0200")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> writes:

> Markus Trippelsdorf reports:
>
> WARNING: kmemcheck: Caught 64-bit read from uninitialized memory (ffff88001e605480)
> 4055601e0088ffff000000000000000090686d81ffffffff0000000000000000
>  u u u u u u u u u u u u u u u u i i i i i i i i u u u u u u u u
>  ^
> |RIP: 0010:[<ffffffff8166e561>]  [<ffffffff8166e561>] nf_register_net_hook+0x51/0x160
> [..]
>  [<ffffffff8166e561>] nf_register_net_hook+0x51/0x160
>  [<ffffffff8166eaaf>] nf_register_net_hooks+0x3f/0xa0
>  [<ffffffff816d6715>] ipt_register_table+0xe5/0x110
> [..]
>
> This warning is harmless; we copy 'uninitialized' data from the hook ops
> but it will not be used.
> Long term the structures keeping run-time data should be disentangled
> from those only containing config-time data (such as where in the list
> to insert a hook), but thats -next material.
>
> Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
> Suggested-by: Al Viro <viro@ZenIV.linux.org.uk>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/x_tables.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

ACK
