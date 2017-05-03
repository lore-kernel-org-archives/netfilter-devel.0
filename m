From: Aaron Conole <aconole@bytheb.org>
Subject: Re: [PATCH iptables] iptables: support insisting that the lock is held
Date: Wed, 03 May 2017 10:51:08 -0400
Message-ID: <f7tshkmt2n7.fsf@redhat.com>
References: <20170420092333.78247-1-lorenzo@google.com>
        <20170503110120.GA11014@salvia> <f7tbmrauial.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Lorenzo Colitti <lorenzo@google.com>,
        netfilter-devel@vger.kernel.org, jscherpelz@google.com,
        subashab@codeaurora.org, dcbw@redhat.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:33415 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752682AbdECOvM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 May 2017 10:51:12 -0400
Received: by mail-qt0-f193.google.com with SMTP id c45so24973786qtb.0
        for <netfilter-devel@vger.kernel.org>; Wed, 03 May 2017 07:51:12 -0700 (PDT)
In-Reply-To: <f7tbmrauial.fsf@redhat.com> (Aaron Conole's message of "Wed, 03
        May 2017 10:27:46 -0400")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Aaron Conole <aconole@bytheb.org> writes:

> Pablo Neira Ayuso <pablo@netfilter.org> writes:
>
>> On Thu, Apr 20, 2017 at 06:23:33PM +0900, Lorenzo Colitti wrote:
>>> Currently, iptables programs will exit with an error if the
>>> iptables lock cannot be acquired, but will silently continue if
>>> the lock cannot be opened at all.
>>
>> This sounds to me like a wrong design decision was made when
>> introducing this userspace lock.
>
> I wouldn't say it that way.  I looked at this a while ago, and one thing
> to keep in mind is the if the particular prefix path in the filesystem
> (for instance /run) isn't available, then this will cause iptables to
> fail.  I'm not sure how many systems do provide /run - at the time it
> might have been more common.

Another issue is container systems.  Until recently, Kubernetes didn't
provide /run at all, and not all container orchestration tools will
provide this filesystem.

>>> This can cause unexpected failures (with unhelpful error messages)
>>> in the presence of concurrent updates.
>>> 
>>> This patch adds a compile-time option that causes iptables to
>>> refuse to do anything if the lock cannot be acquired. It is a
>>> compile-time option instead of a command-line flag because:
>>> 
>>> 1. In order to reliably avoid concurrent modification, all
>>>    invocations of iptables commands must follow this behaviour.
>>> 2. Whether or not the lock can be opened is typically not
>>>    a run-time condition but is likely to be a configuration
>>>    error.
>>>
>>> Tested by deleting xtables.lock and observing that all commands
>>> failed if iptables was compiled with --enable-strict-locking, but
>>> succeeded otherwise.
>>> 
>>> By default, --enable-strict-locking is disabled for backwards
>>> compatibility reasons. It can be enabled by default in a future
>>> change if desired.
>>
>> I would like to skip this compile time switch, if the existing
>> behaviour is broken, we should just fix it. What is the scenario that
>> can indeed have an impact in terms of backward compatibility breakage?
>> Does it really make sense to keep a buggy behaviour around?
>
> I'm not sure about a change to the behavior, but I agree that a compile
> time switch is probably not the way to go.

I've thought about it.  I think a better change that makes sense in the
presence of concurrent updates would be to use the wait argument as a
total time, and apply it to both the userspace lock, AND an EAGAIN from
the kernel space side.  So if the kernel space says 'locked try again',
and the user passed a -w option, we can simply keep retrying until the
wait time expires.  Does that make sense and solve your issue, Lorenzo?
