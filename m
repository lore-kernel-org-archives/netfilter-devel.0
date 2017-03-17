From: Lorenzo Colitti <lorenzo@google.com>
Subject: Re: [PATCH iptables v2 2/2] iptables-restore: support acquiring the lock.
Date: Sat, 18 Mar 2017 01:46:52 +0900
Message-ID: <CAKD1Yr2CQ1U9PtS2i3VUH1bMJ+dJ5CftYq8K=Dd65dHBk7kgsQ@mail.gmail.com>
References: <20170316075502.2337-1-lorenzo@google.com> <20170316075502.2337-3-lorenzo@google.com>
 <20170317132003.GC12186@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org,
        Joel Scherpelz <jscherpelz@google.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        zlpnobody@gmail.com, Narayan Kamath <narayan@google.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f173.google.com ([209.85.217.173]:35740 "EHLO
        mail-ua0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751178AbdCQQrO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Mar 2017 12:47:14 -0400
Received: by mail-ua0-f173.google.com with SMTP id q7so47335696uaf.2
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 09:47:13 -0700 (PDT)
In-Reply-To: <20170317132003.GC12186@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 17, 2017 at 10:20 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> My concern with this is that one iptables-restore instance may
> postpone any other iptables call indefinitely, by simply typing
> "*filter" with no COMMIT ever.

True. But unless the command is run with just plain "-w" (i.e., wait
forever with no timeout) then the user will get an error message that
the lock is held and can take action.

Also: are you thinking about a misconfiguration or an error in a
script, or malicious behaviour? A malicious actor can already block
any iptables commands in the same way by running "flock -e
/run/iptables.lock cat".
