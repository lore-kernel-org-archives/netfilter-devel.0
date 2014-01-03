From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH 1/1] netfilter: xtables: add quota support to nfacct
Date: Fri, 3 Jan 2014 13:38:45 -0700
Message-ID: <CANLsYkyA-DT3jWeYJUJG-6rNTDcfv22BrjfBBAaaL4qHu+H+PA@mail.gmail.com>
References: <1386780798-24374-1-git-send-email-mathieu.poirier@linaro.org>
	<1386780798-24374-2-git-send-email-mathieu.poirier@linaro.org>
	<20131218095322.GA4740@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	John Stultz <john.stultz@linaro.org>,
	JP Abgrall <jpa@google.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vb0-f47.google.com ([209.85.212.47]:64148 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbaACUiq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Jan 2014 15:38:46 -0500
Received: by mail-vb0-f47.google.com with SMTP id m10so1876949vbh.34
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Jan 2014 12:38:45 -0800 (PST)
In-Reply-To: <20131218095322.GA4740@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

...

> I think you can avoid this private area (including the spinlock) by
> storing a copy of the packet/byte counter before calling
> nfnl_acct_update(). Then if you note that old packet/byte counter was
> below quota but new is overquota, then you have to send an event, ie.
>
>         old_pkts = atomic64_read(info->nfacct->pkts);
>         new_pkts = nfnl_acct_update(skb, info->nfacct, info->flags);
>         if (old_pkts < info->quota && new_pkts > info->quota)
>                 send event
>
> There's still one problem with this approach since it is racy, as it
> may send several events, so you can refine it with:
>
>         if (old_pkts < info->quota && new_pkts > info->quota
>             && old_pkts + 1 == new_pkts)
>                 send event
>
> You will need two different functions depending on the quota mode
> (packet or bytes), and you will also need to modify nfnl_acct_update()
> to return the new number of packets or bytes (depending on the flags),
> you can use atomic_add_return and atomic_inc_return respectively to
> retrieve the new (updated) value.

Now that we've dealt with the logging issue we can concentrate on the
above suggestion that tries to avoid using a spinlock.  It works well
in packet mode but not so much in byte mode.

Whether working in byte or packet mode the solution is using packets
to determine who will send the notification.  When dealing with bytes
identifying which packet made the byte count go over quota is of prime
importance.  The problem is that the upgrade of packet and bytes in
"nfnl_acct_update()" is not atomic to the caller - there is always a
possibility that the thread will lose the CPU between incrementing
packet and bytes.  This could eventually lead to erroneous arithmetic
and an imprecise recognition of a quota attainment.

No matter how I turn things around in my head we need a spinlock -
either in nfnl_acct_update() or in the match function of xt_nfacct.c.

Comments are welcomed.
