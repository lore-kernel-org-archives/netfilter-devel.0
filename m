From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH 2/6] monitor: Fix printing of set declarations
Date: Tue, 25 Jul 2017 19:09:34 +0200
Message-ID: <20170725170934.GB2235@orbyte.nwl.cc>
References: <20170725145629.20974-1-phil@nwl.cc>
 <20170725145629.20974-3-phil@nwl.cc>
 <20170725155741.GA591@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:42235 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751727AbdGYRJf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jul 2017 13:09:35 -0400
Content-Disposition: inline
In-Reply-To: <20170725155741.GA591@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 25, 2017 at 05:57:41PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Jul 25, 2017 at 04:56:25PM +0200, Phil Sutter wrote:
> > diff --git a/tests/monitor/testcases/set-maps.t b/tests/monitor/testcases/set-maps.t
> > index d94016beb0767..6ea36cb9d11d6 100644
> > --- a/tests/monitor/testcases/set-maps.t
> > +++ b/tests/monitor/testcases/set-maps.t
> > @@ -2,7 +2,7 @@
> >  I add table ip t
> >  O add table ip t
> >  I add map ip t portip { type inet_service: ipv4_addr; flags interval; }
> > -O add map ip t portip { type inet_service : ipv4_addr;flags interval }
> > +O add map ip t portip { type inet_service : ipv4_addr;flags interval; }
> 
> So the proposal is to remove the whitespace? I think it's more
> readable the way it is already.

No, it is about the missing semicolon after 'flags interval' (and after
'timeout' and 'gc-interval' options if present). The output of 'nft
monitor' is not syntactically correct without this.

You are correct in that it removes the whitespace before the closing
brace, but patch 4 "fixes" that by making 'stmt_separator' consist of
semicolon + whitespace.

Is it clear now?

Thanks, Phil
