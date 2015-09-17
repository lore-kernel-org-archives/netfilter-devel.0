From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] build: bump library versioning
Date: Thu, 17 Sep 2015 13:03:10 +0200
Message-ID: <20150917110310.GA5181@salvia>
References: <1442423567-12120-1-git-send-email-jengelh@inai.de>
 <20150916172836.GA29575@salvia>
 <20150916180048.GA4886@salvia>
 <20150916182251.GA3346@salvia>
 <alpine.LSU.2.20.1509162031310.13589@nerf40.vanv.qr>
 <20150916184939.GA14450@salvia>
 <alpine.LSU.2.20.1509162239440.7375@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59911 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbbIQK4c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Sep 2015 06:56:32 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1509162239440.7375@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 16, 2015 at 10:40:05PM +0200, Jan Engelhardt wrote:
> On Wednesday 2015-09-16 20:49, Pablo Neira Ayuso wrote:
> >
> >I'm attaching your original patch, but I also included the LIBVERSION
> >update into it.
> 
> A "local: *" needs to be readded in the .map file. Looks good 
> otherwise.

Just pushed it out with this change. Thanks.
