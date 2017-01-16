From: Keno Fischer <keno@juliacomputing.com>
Subject: Re: [PATCH] Add a configure flag to link libc statically
Date: Mon, 16 Jan 2017 11:39:45 -0500
Message-ID: <CABV8kRwNRwGcREYxiD4Z1n2ki6p-2Ke1x0Xm9i4DQtSyE+1pxw@mail.gmail.com>
References: <20161230054426.GA9694@juliacomputing.com> <20170116125759.GA25857@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f175.google.com ([209.85.217.175]:35437 "EHLO
        mail-ua0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751465AbdAPQk1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Jan 2017 11:40:27 -0500
Received: by mail-ua0-f175.google.com with SMTP id y9so85351750uae.2
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 08:40:26 -0800 (PST)
In-Reply-To: <20170116125759.GA25857@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>> The primary concern here is probably that iptables uses functions
>> that in glibc still require the dynamic library at runtime.
>
> I think that explains this:
>
> libxt_owner.c:416: warning: Using 'getgrgid' in statically linked
> applications requires at runtime the shared libraries from the glibc
> version used for linking

It does, yes. Other C libraries don't have this problem though.

>> However, for my usage of iptables, I have never actually run into
>> this situation, and even if I did, I'd rather switch libcs (though I
>> may be in the minority there). Nevertheless, I think it would be
>> useful to have this option available for those wanting a statically
>> linked iptables.
>
> I'm trying to understand why you need this. Thanks.

I'm running docker in a stripped down security-enhanced context where
everything is statically linked. Docker calls out to iptables to set
up some firewall rules. So far I have not encountered it needing any
of the code paths in iptables that would require the shared libraries
from glibc at runtime. I'm also not the only person in this exact
situation, e.g.:

https://github.com/vallinux/base/issues/14
