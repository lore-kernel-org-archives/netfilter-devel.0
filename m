From: Lorenzo Colitti <lorenzo@google.com>
Subject: Re: [PATCH iptables] iptables: support insisting that the lock is held
Date: Thu, 4 May 2017 00:59:12 +0900
Message-ID: <CAKD1Yr089ZKBRMCrV+iy2m5N1WYPfeNMR7w2DrNOucjbr8RUjQ@mail.gmail.com>
References: <20170420092333.78247-1-lorenzo@google.com> <20170503110120.GA11014@salvia>
 <f7tbmrauial.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Joel Scherpelz <jscherpelz@google.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Dan Williams <dcbw@redhat.com>
To: Aaron Conole <aconole@bytheb.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f176.google.com ([209.85.217.176]:33176 "EHLO
        mail-ua0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751981AbdECP7e (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 May 2017 11:59:34 -0400
Received: by mail-ua0-f176.google.com with SMTP id j59so105040447uad.0
        for <netfilter-devel@vger.kernel.org>; Wed, 03 May 2017 08:59:34 -0700 (PDT)
In-Reply-To: <f7tbmrauial.fsf@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 3, 2017 at 11:27 PM, Aaron Conole <aconole@bytheb.org> wrote:
> I wouldn't say it that way.  I looked at this a while ago, and one thing
> to keep in mind is the if the particular prefix path in the filesystem
> (for instance /run) isn't available, then this will cause iptables to
> fail.  I'm not sure how many systems do provide /run - at the time it
> might have been more common.

That is a configuration error on the part of the distribution
maintainers. The location of the iptables lock is configurable at
compile time and if the distribution does not have /run, the
maintainers can use another path.
