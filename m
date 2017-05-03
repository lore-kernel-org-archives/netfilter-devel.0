From: Aaron Conole <aconole@bytheb.org>
Subject: Re: [PATCH iptables] iptables: support insisting that the lock is held
Date: Wed, 03 May 2017 10:27:46 -0400
Message-ID: <f7tbmrauial.fsf@redhat.com>
References: <20170420092333.78247-1-lorenzo@google.com>
        <20170503110120.GA11014@salvia>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Lorenzo Colitti <lorenzo@google.com>,
        netfilter-devel@vger.kernel.org, jscherpelz@google.com,
        subashab@codeaurora.org, dcbw@redhat.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:33053 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753327AbdECO1u (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 May 2017 10:27:50 -0400
Received: by mail-qk0-f196.google.com with SMTP id o85so2905785qkh.0
        for <netfilter-devel@vger.kernel.org>; Wed, 03 May 2017 07:27:50 -0700 (PDT)
In-Reply-To: <20170503110120.GA11014@salvia> (Pablo Neira Ayuso's message of
        "Wed, 3 May 2017 13:01:20 +0200")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> writes:

> On Thu, Apr 20, 2017 at 06:23:33PM +0900, Lorenzo Colitti wrote:
>> Currently, iptables programs will exit with an error if the
>> iptables lock cannot be acquired, but will silently continue if
>> the lock cannot be opened at all.
>
> This sounds to me like a wrong design decision was made when
> introducing this userspace lock.

I wouldn't say it that way.  I looked at this a while ago, and one thing
to keep in mind is the if the particular prefix path in the filesystem
(for instance /run) isn't available, then this will cause iptables to
fail.  I'm not sure how many systems do provide /run - at the time it
might have been more common.

>> This can cause unexpected failures (with unhelpful error messages)
>> in the presence of concurrent updates.
>> 
>> This patch adds a compile-time option that causes iptables to
>> refuse to do anything if the lock cannot be acquired. It is a
>> compile-time option instead of a command-line flag because:
>> 
>> 1. In order to reliably avoid concurrent modification, all
>>    invocations of iptables commands must follow this behaviour.
>> 2. Whether or not the lock can be opened is typically not
>>    a run-time condition but is likely to be a configuration
>>    error.
>>
>> Tested by deleting xtables.lock and observing that all commands
>> failed if iptables was compiled with --enable-strict-locking, but
>> succeeded otherwise.
>> 
>> By default, --enable-strict-locking is disabled for backwards
>> compatibility reasons. It can be enabled by default in a future
>> change if desired.
>
> I would like to skip this compile time switch, if the existing
> behaviour is broken, we should just fix it. What is the scenario that
> can indeed have an impact in terms of backward compatibility breakage?
> Does it really make sense to keep a buggy behaviour around?

I'm not sure about a change to the behavior, but I agree that a compile
time switch is probably not the way to go.

-Aaron
