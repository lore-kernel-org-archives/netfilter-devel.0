From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] extensions: restore matching any SPI id by default
Date: Wed, 15 Jul 2015 18:55:15 +0200
Message-ID: <20150715165515.GA4177@salvia>
References: <1436964819-28109-1-git-send-email-jengelh@inai.de>
 <1436964819-28109-3-git-send-email-jengelh@inai.de>
 <20150715162442.GA22476@salvia>
 <alpine.LSU.2.20.1507151837110.15534@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50922 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbbGOQte (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jul 2015 12:49:34 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1507151837110.15534@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 15, 2015 at 06:41:54PM +0200, Jan Engelhardt wrote:
> 
> On Wednesday 2015-07-15 18:24, Pablo Neira Ayuso wrote:
> >On Wed, Jul 15, 2015 at 02:53:39PM +0200, Jan Engelhardt wrote:
> >[...]
> >> diff --git a/extensions/libxt_esp.t b/extensions/libxt_esp.t
> >> index 008013b..f207def 100644
> >> --- a/extensions/libxt_esp.t
> >> +++ b/extensions/libxt_esp.t
> >> @@ -4,6 +4,7 @@
> >>  -p esp -m esp --espspi 0:4294967295;-p esp -m esp;OK
> >>  -p esp -m esp ! --espspi 0:4294967294;=;OK
> >>  -p esp -m esp --espspi -1;;FAIL
> >> +-p esp -m esp;-p esp -m esp --espspi 0;FAIL
> >>  # should fail?
> >>  -p esp -m esp;=;OK
> >
> >This line looks very similar to the one above the comment, but it says OK.
> 
> Indeed the FAIL line is indeed mirroring the OK line, the latter of 
> which should have failed the testsuite previously.

Right.

Given that this is changing the behaviour again, I would suggest that
-p esp -m esp displays -p -m esp --espspi 0:4294967295 via
iptables-save.

I think this default behaviour is less obscure which they can still
type less from the command line.
