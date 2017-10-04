From: Shmulik Ladkani <shmulik@nsof.io>
Subject: Re: [PATCH v2 1/2] iptables: support match info fixup after tc_init
Date: Wed, 4 Oct 2017 17:38:39 +0300
Message-ID: <20171004173839.76c961d8@pixies>
References: <20170917112031.8644-1-shmulik@nsof.io>
        <20170917112031.8644-2-shmulik@nsof.io>
        <20170918162811.GA6091@salvia>
        <20170918200042.3189aa0f@pixies>
        <20170918172353.GA8982@salvia>
        <CA+FuTScxeSWkGZQZOOk24Ni-aQbuVOm5KffuSdimWvHbFKUUxg@mail.gmail.com>
        <20170918175424.GA17019@salvia>
        <20171004143301.GA22316@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Willem de Bruijn <willemb@google.com>,
        netfilter-devel <netfilter-devel@vger.kernel.org>, rbk@nsof.io,
        Rafael Buchbinder <rafi@rbk.ms>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:45366 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752221AbdJDOin (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Oct 2017 10:38:43 -0400
Received: by mail-wr0-f176.google.com with SMTP id m18so8814575wrm.2
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Oct 2017 07:38:43 -0700 (PDT)
In-Reply-To: <20171004143301.GA22316@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Wed, 4 Oct 2017 16:33:01 +0200 Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> > > We can perhaps change the kernel module to ignore .fd and do a
> > > path lookup for .path directly inside the kernel. That would not
> > > require a v2, even.  
> > 
> > That sounds very reasonable, so we can just address this as a plain
> > fix and pass it on to -stable.  
> 
> Anyone following up with this?

I plan to work on a fix to the v1 abi, in which the given fd is ignored.

Best,
Shmulik
