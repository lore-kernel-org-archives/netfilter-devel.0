From: Cong Wang <amwang@redhat.com>
Subject: Re: Increasing XT_EXTENSION_MAXNAMELEN to 32
Date: Tue, 02 Oct 2012 12:21:33 +0800
Message-ID: <1349151693.22107.10.camel@cr0>
References: <1348934029.10238.15.camel@cr0>
	 <alpine.LNX.2.01.1209291844490.19330@nerf07.vanv.qr>
	 <20120929184716.GA4050@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153Ab2JBEVy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Oct 2012 00:21:54 -0400
In-Reply-To: <20120929184716.GA4050@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 2012-09-29 at 20:47 +0200, Pablo Neira Ayuso wrote:
> On Sat, Sep 29, 2012 at 06:46:22PM +0200, Jan Engelhardt wrote:
> > On Saturday 2012-09-29 17:53, Cong Wang wrote:
> > 
> > >Hi, netfilter experts,
> > >
> > >A customer wants to increase XT_EXTENSION_MAXNAMELEN to at least 31 (1
> > >for '\0'), so I just increase it to 32. Do you have any comments or
> > >objections for the following patch?
> > 
> > This is a no-no. You are breaking the ABI.
> 
> Agreed. Sorry Cong, you cannot do that.

Ok, no problem.

I knew this could break user-space iptables, so there must be some other
applications relying on this ABI too, hmm... I will tell the customer
this is not possible to change.

Thanks!

