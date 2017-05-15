From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH] netfilter: synproxy: fix conntrackd interaction
Date: Mon, 15 May 2017 23:53:44 +0200
Message-ID: <1494885224.15338.2.camel@regit.org>
References: <20170515165238.GA3999@salvia>
         <fbaa0cbd-a13d-46e3-a796-023439433dda@email.android.com>
         <20170515175549.GA6393@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 8bit
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>,
        brouer@redhat.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:53320 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751082AbdEOVxw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 May 2017 17:53:52 -0400
In-Reply-To: <20170515175549.GA6393@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Mon, 2017-05-15 at 19:55 +0200, Pablo Neira Ayuso wrote:
> On Mon, May 15, 2017 at 07:49:18PM +0200, Eric Leblond wrote:
> >    Hello,
> >    Le 15 mai 2017 6:52 PM, Pablo Neira Ayuso <pablo@netfilter.org>
> > a
> >    écrit :
> > 
> >      On Thu, May 11, 2017 at 06:56:38PM +0200, Eric Leblond wrote:
> >      > This patch fixes the creation of connection tracking entry
> > from
> >      > netlink when synproxy is used. It was missing the addition
> > of
> >      > the synproxy extension.
> >      >
> >      > This was causing kernel crashes when a conntrack entry
> > created by
> >      > conntrackd was used after the switch of traffic from active
> > node
> >      > to the passive node.
> >      Applied, thanks Eric.
> > 
> >    Thanks Pablo !
> >    Will you push it to stable as it is causing a crash on older
> > kernel
> >    like 3.16?
> 
> Does this compile cleanly as is?

Yes, I have tested the patch on 3.16.1 and it applies cleanly. I've
build module for 4.1 and patch applies too. I did not test it but code
is unchanged.

> If so, I can just request -stable maintainer to take it as soon as
> this hits upstream.

Thanks!

BR,
-- 
Eric Leblond <eric@regit.org>
