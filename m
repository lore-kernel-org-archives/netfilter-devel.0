From: Lorenzo Colitti <lorenzo@google.com>
Subject: Re: [PATCH iptables] iptables: support insisting that the lock is held
Date: Thu, 4 May 2017 01:07:58 +0900
Message-ID: <CAKD1Yr3LFe2KXZdhtVxLq6qiSUK_Wfz45=_sucUL5naxbBrxxA@mail.gmail.com>
References: <20170420092333.78247-1-lorenzo@google.com> <20170503110120.GA11014@salvia>
 <f7tbmrauial.fsf@redhat.com> <f7tshkmt2n7.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Joel Scherpelz <jscherpelz@google.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Dan Williams <dcbw@redhat.com>
To: Aaron Conole <aconole@bytheb.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:33920 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752347AbdECQIZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 May 2017 12:08:25 -0400
Received: by mail-ua0-f170.google.com with SMTP id g49so44463318uaa.1
        for <netfilter-devel@vger.kernel.org>; Wed, 03 May 2017 09:08:25 -0700 (PDT)
In-Reply-To: <f7tshkmt2n7.fsf@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 3, 2017 at 11:51 PM, Aaron Conole <aconole@bytheb.org> wrote:
> I've thought about it.  I think a better change that makes sense in the
> presence of concurrent updates would be to use the wait argument as a
> total time, and apply it to both the userspace lock, AND an EAGAIN from
> the kernel space side.  So if the kernel space says 'locked try again',
> and the user passed a -w option, we can simply keep retrying until the
> wait time expires.  Does that make sense and solve your issue, Lorenzo?

The lock is always taken regardless of whether -w is specified. The
only difference is that with -w userspace waits instead of exiting
with an error.

I'm with Pablo on this one - the behaviour is incorrect and should be
fixed. Admins shouldn't have to wait for a concurrent execution to
happen before they know that they misconfigured the lock. I think that
if the admin runs iptables and the lock is unusable, it's a
configuration error, and it should be reported as such immediately.

Also - even if we add a check for EAGAIN, how reliable is that
codepath going to be? Concurrent updates are already pretty rare, and
the problem we saw was pretty hard to track down. If we sprinkle
checks for EAGAIN all over the code, and a future change misses one of
them, how will anyone notice breakage?
