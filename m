From: Lorenzo Colitti <lorenzo@google.com>
Subject: Re: [PATCH iptables] iptables: support insisting that the lock is held
Date: Thu, 4 May 2017 00:57:29 +0900
Message-ID: <CAKD1Yr2MwcmPhyFYDcjdjhtZ6KbdkznobXivoq-Rt50m+8nnuw@mail.gmail.com>
References: <20170420092333.78247-1-lorenzo@google.com> <20170503110120.GA11014@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org,
        Joel Scherpelz <jscherpelz@google.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Dan Williams <dcbw@redhat.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:35159 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751177AbdECP5v (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 May 2017 11:57:51 -0400
Received: by mail-ua0-f170.google.com with SMTP id e55so74674512uaa.2
        for <netfilter-devel@vger.kernel.org>; Wed, 03 May 2017 08:57:50 -0700 (PDT)
In-Reply-To: <20170503110120.GA11014@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 3, 2017 at 8:01 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> This sounds to me like a wrong design decision was made when
> introducing this userspace lock.

Looks like the lock was introduced by

93587a04d0f2 ("ip[6]tables: Add locking to prevent concurrent instances")

which made the lock optional for backwards compatibility:

       xt_socket = socket(AF_UNIX, SOCK_STREAM, 0);
       /* If we can't even create a socket, fall back to prior
(lockless) behavior */
       if (xt_socket < 0)
               return true;

That was almost four years ago. Sometime between 1.4 and 1.6, the lock
was switched to use flock() on /run/xtables.lock , but the fail-open
behaviour was preserved.

> I would like to skip this compile time switch, if the existing
> behaviour is broken, we should just fix it. What is the scenario that
> can indeed have an impact in terms of backward compatibility breakage?
> Does it really make sense to keep a buggy behaviour around?

I agree that the current behaviour is dangerous and error-prone. It's
bitten us badly several times now. The only use case I came up with is
running commands early on boot, from a read-only filesystem that does
not have /run/xtables.lock. If we change the behaviour, that system
might become unbootable on an iptables upgrade.

Another issue mentioned in the initial socket-based approach was that
no locking is necessary for iptables commands running in different
network namespaces. Someone with such a system might be relying on
this. The impact of this change would be to slow down concurrent
iptables commands.

These both seem like a very contrived cases though. I'll send out
another patch that changes the behaviour.
