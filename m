From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [FIX V2] sip: add missing RCU reader lock
Date: Fri, 27 Sep 2013 16:14:25 +0200
Message-ID: <20130927141425.GA10230@localhost>
References: <20130920204304.GA12439@imap.eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: "holger@eitzenberger.org" <holger@eitzenberger.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44835 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710Ab3I0OO3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Sep 2013 10:14:29 -0400
Content-Disposition: inline
In-Reply-To: <20130920204304.GA12439@imap.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 20, 2013 at 10:43:04PM +0200, Holger Eitzenberger wrote:
> Hi,
> 
> I noticed that set_expected_rtp_rtcp() in net-next misses a 2nd
> RCU reader lock when dereferencing the 2nd hook function.  Same
> bug is present in kernel v3.8 at least.
> 
> This is a resend, which extend the RCU protected area as needed.

Applied to nf-next, thanks Holger.

I added to the description a short clarification, as Patrick mentioned,
this is comestic fix.
