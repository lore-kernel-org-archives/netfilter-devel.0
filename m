From: David Miller <davem@davemloft.net>
Subject: Re: RFC: net/netfilter reorganization
Date: Sun, 05 Oct 2008 09:17:39 -0700 (PDT)
Message-ID: <20081005.091739.131587847.davem@davemloft.net>
References: <48E8D3C4.60306@trash.net>
	<20081005.090202.143862823.davem@davemloft.net>
	<48E8E736.8060800@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: jengelh@medozas.de, netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50164
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757613AbYJEQSE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:18:04 -0400
In-Reply-To: <48E8E736.8060800@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Sun, 05 Oct 2008 18:11:34 +0200

> David Miller wrote:
> > From: Patrick McHardy <kaber@trash.net>
> > Date: Sun, 05 Oct 2008 16:48:36 +0200
> > 
> >> The main goal is to get the directory contents to a more reasonable
> >> level and group related stuff together; using just net/netfilter/ct
> >> is still a bit too coarse in my opinion. Under that aspect, what
> >> would your proposed structure be?
> > One thing I'm looking forward to is the elimination of all of
> > the xt_* prefixes, and in general better TAB completion
> > friendliness when I try to open netfilter source files under
> > emacs or grep things from the command line with tab completed
> > paths.
> 
> I'm not sure how emacs handles completion, would using different
> prefixes for matches and targets help? Otherwise I guess we can
> just get rid of the prefixes entirely.

Putting them in different sub-directories would help.

> The main problem with these renames is that it module aliases
> don't work for "rmmod", which is a pretty common thing with
> these modules. I guess we'd need to fix up module-init-tools
> first.

I see.
