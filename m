From: Thomas Jacob <jacob@internet24.de>
Subject: Re: Plans for future iptables versions / jumpset feature
Date: Thu, 22 May 2008 22:47:16 +0200
Message-ID: <20080522204716.GA29008@internet24.de>
References: <1211482843.28066.40.camel@enterprise.ims-firmen.de> <4835C6F0.5080604@trash.net> <20080522201419.GA28832@internet24.de> <4835D511.7030503@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout01.ims-firmen.de ([213.174.32.96]:52467 "EHLO
	mailout01.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060AbYEVUrS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 16:47:18 -0400
Content-Disposition: inline
In-Reply-To: <4835D511.7030503@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 22, 2008 at 10:18:25PM +0200, Patrick McHardy wrote:
> Not implemented yet, but I'm probably going to add this as an option
> (since it may affect the choice of data structure). For jumps its
> tricky though because loop detection has to be performed.

I don't see why this always has to be performed. There so many ways
to break your system when you're root, so being required to define a loop
free rule sets after specifying some kind of "yes I really want to"-
option should be that much of a burden. As far as I understand
the code, the loop checking at the moment is done in userspace, so
nobody stops you from simply removing that part from the iptables
code.
