From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 2/6] monitor: Fix printing of set declarations
Date: Wed, 26 Jul 2017 13:18:03 +0200
Message-ID: <20170726111803.GA1894@salvia>
References: <20170725145629.20974-1-phil@nwl.cc>
 <20170725145629.20974-3-phil@nwl.cc>
 <20170725155741.GA591@salvia>
 <20170725170934.GB2235@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60626 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751325AbdGZLSM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jul 2017 07:18:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7D17A17D42B
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jul 2017 13:17:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 65EA9DA80E
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jul 2017 13:17:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E5D53DA90C
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jul 2017 13:17:55 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170725170934.GB2235@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 25, 2017 at 07:09:34PM +0200, Phil Sutter wrote:
> On Tue, Jul 25, 2017 at 05:57:41PM +0200, Pablo Neira Ayuso wrote:
> > On Tue, Jul 25, 2017 at 04:56:25PM +0200, Phil Sutter wrote:
> > > diff --git a/tests/monitor/testcases/set-maps.t b/tests/monitor/testcases/set-maps.t
> > > index d94016beb0767..6ea36cb9d11d6 100644
> > > --- a/tests/monitor/testcases/set-maps.t
> > > +++ b/tests/monitor/testcases/set-maps.t
> > > @@ -2,7 +2,7 @@
> > >  I add table ip t
> > >  O add table ip t
> > >  I add map ip t portip { type inet_service: ipv4_addr; flags interval; }
> > > -O add map ip t portip { type inet_service : ipv4_addr;flags interval }
> > > +O add map ip t portip { type inet_service : ipv4_addr;flags interval; }
> > 
> > So the proposal is to remove the whitespace? I think it's more
> > readable the way it is already.
> 
> No, it is about the missing semicolon after 'flags interval' (and after
> 'timeout' and 'gc-interval' options if present). The output of 'nft
> monitor' is not syntactically correct without this.
> 
> You are correct in that it removes the whitespace before the closing
> brace, but patch 4 "fixes" that by making 'stmt_separator' consist of
> semicolon + whitespace.
> 
> Is it clear now?

Thanks for explaining, yes this clarifies. Please, add examples next
time to your commit messages.

BTW, no need to update .t files after patch 4/6 to add the space after
semicolon?

Thanks!
