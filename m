From: Thomas Jacob <jacob@internet24.de>
Subject: Re: Plans for future iptables versions / jumpset feature
Date: Thu, 22 May 2008 23:43:41 +0200
Message-ID: <20080522214341.GA29142@internet24.de>
References: <1211482843.28066.40.camel@enterprise.ims-firmen.de> <4835C6F0.5080604@trash.net> <20080522201419.GA28832@internet24.de> <4835D511.7030503@trash.net> <20080522204716.GA29008@internet24.de> <4835DCEF.8060002@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout01.ims-firmen.de ([213.174.32.96]:56429 "EHLO
	mailout01.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933741AbYEVVnn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 17:43:43 -0400
Content-Disposition: inline
In-Reply-To: <4835DCEF.8060002@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 22, 2008 at 10:51:59PM +0200, Patrick McHardy wrote:
> No, its done in the kernel. I also don't buy this argument.

Oh yes, mark_source_chains, sorry

> Sure, you can wreck your system if you really want to, but
> it should be prevented to do so accidentally. Additionally,
> if you consider setups with limited root powers, this becomes
> a serious bug.

Well if you can't wreck your system this way now, creating such
a possibility wouldn't be so good... agreed.

