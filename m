From: Lorenzo Colitti <lorenzo@google.com>
Subject: Re: [PATCH iptables] iptables: support insisting that the lock is held
Date: Fri, 19 May 2017 16:10:49 +0900
Message-ID: <CAKD1Yr1-QeA=tVcbxTAtuqEzcs96=hUcvTnd307KZdhhJXNQVw@mail.gmail.com>
References: <20170420092333.78247-1-lorenzo@google.com> <20170503110120.GA11014@salvia>
 <CAKD1Yr2MwcmPhyFYDcjdjhtZ6KbdkznobXivoq-Rt50m+8nnuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: netfilter-devel@vger.kernel.org,
        Joel Scherpelz <jscherpelz@google.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Dan Williams <dcbw@redhat.com>,
        Aaron Conole <aconole@bytheb.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f177.google.com ([209.85.217.177]:34307 "EHLO
        mail-ua0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750810AbdESHLL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 May 2017 03:11:11 -0400
Received: by mail-ua0-f177.google.com with SMTP id u10so21007989uaf.1
        for <netfilter-devel@vger.kernel.org>; Fri, 19 May 2017 00:11:11 -0700 (PDT)
In-Reply-To: <CAKD1Yr2MwcmPhyFYDcjdjhtZ6KbdkznobXivoq-Rt50m+8nnuw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 4, 2017 at 12:57 AM, Lorenzo Colitti <lorenzo@google.com> wrote:
> > I would like to skip this compile time switch, if the existing
> > behaviour is broken, we should just fix it. What is the scenario that
> > can indeed have an impact in terms of backward compatibility breakage?
> > Does it really make sense to keep a buggy behaviour around?
>
> I'll send out another patch that changes the behaviour.

Sorry this took a while. http://patchwork.ozlabs.org/patch/764458/
