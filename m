From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Increasing XT_EXTENSION_MAXNAMELEN to 32
Date: Sat, 29 Sep 2012 20:47:16 +0200
Message-ID: <20120929184716.GA4050@1984>
References: <1348934029.10238.15.camel@cr0>
 <alpine.LNX.2.01.1209291844490.19330@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Cong Wang <amwang@redhat.com>, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50236 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758653Ab2I2SrW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Sep 2012 14:47:22 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1209291844490.19330@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Sep 29, 2012 at 06:46:22PM +0200, Jan Engelhardt wrote:
> On Saturday 2012-09-29 17:53, Cong Wang wrote:
> 
> >Hi, netfilter experts,
> >
> >A customer wants to increase XT_EXTENSION_MAXNAMELEN to at least 31 (1
> >for '\0'), so I just increase it to 32. Do you have any comments or
> >objections for the following patch?
> 
> This is a no-no. You are breaking the ABI.

Agreed. Sorry Cong, you cannot do that.
