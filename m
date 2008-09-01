From: Phil Oester <kernel@linuxace.com>
Subject: Re: Bugzilla mails not working
Date: Mon, 1 Sep 2008 10:50:13 -0700
Message-ID: <20080901175013.GA27500@linuxace.com>
References: <20080901150950.GA24543@linuxace.com> <48BC07E4.4010102@trash.net> <48BC12B3.7050902@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:40212
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753551AbYIARuQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Sep 2008 13:50:16 -0400
Content-Disposition: inline
In-Reply-To: <48BC12B3.7050902@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 01, 2008 at 06:05:07PM +0200, Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
> > Phil Oester wrote:
> >> Email out of bugzilla doesn't seem to be working.  Can someone
> >> take a look?
> > 
> > There are no mails visible in the mailman interface. Pablo, you seem
> > to be familiar with the bugzilla setup, could you have a look please?
> 
> exim was rejecting emails for user bugzilla-daemon as unroutable, I have
> added it to /etc/aliases. It should work now.

Sorry, still doesn't seem to be working.

Phil
