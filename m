From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] iptables: support insisting that the lock is
 held
Date: Wed, 3 May 2017 13:01:20 +0200
Message-ID: <20170503110120.GA11014@salvia>
References: <20170420092333.78247-1-lorenzo@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, jscherpelz@google.com,
        subashab@codeaurora.org, dcbw@redhat.com
To: Lorenzo Colitti <lorenzo@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45522 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751385AbdECLBZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 May 2017 07:01:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A2C272EFEAB
        for <netfilter-devel@vger.kernel.org>; Wed,  3 May 2017 13:01:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 93752FF2D8
        for <netfilter-devel@vger.kernel.org>; Wed,  3 May 2017 13:01:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 78BF1FF2D3
        for <netfilter-devel@vger.kernel.org>; Wed,  3 May 2017 13:01:16 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170420092333.78247-1-lorenzo@google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 20, 2017 at 06:23:33PM +0900, Lorenzo Colitti wrote:
> Currently, iptables programs will exit with an error if the
> iptables lock cannot be acquired, but will silently continue if
> the lock cannot be opened at all.

This sounds to me like a wrong design decision was made when
introducing this userspace lock.

> This can cause unexpected failures (with unhelpful error messages)
> in the presence of concurrent updates.
> 
> This patch adds a compile-time option that causes iptables to
> refuse to do anything if the lock cannot be acquired. It is a
> compile-time option instead of a command-line flag because:
> 
> 1. In order to reliably avoid concurrent modification, all
>    invocations of iptables commands must follow this behaviour.
> 2. Whether or not the lock can be opened is typically not
>    a run-time condition but is likely to be a configuration
>    error.
> 
> Tested by deleting xtables.lock and observing that all commands
> failed if iptables was compiled with --enable-strict-locking, but
> succeeded otherwise.
> 
> By default, --enable-strict-locking is disabled for backwards
> compatibility reasons. It can be enabled by default in a future
> change if desired.

I would like to skip this compile time switch, if the existing
behaviour is broken, we should just fix it. What is the scenario that
can indeed have an impact in terms of backward compatibility breakage?
Does it really make sense to keep a buggy behaviour around?
