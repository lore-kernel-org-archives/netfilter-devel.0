From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: net/netfilter reorganization
Date: Sun, 05 Oct 2008 18:11:34 +0200
Message-ID: <48E8E736.8060800@trash.net>
References: <48E8C90D.10202@trash.net>	<alpine.LNX.1.10.0810051004230.21891@fbirervta.pbzchgretzou.qr>	<48E8D3C4.60306@trash.net> <20081005.090202.143862823.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: jengelh@medozas.de, netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48373 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438AbYJEQLl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:11:41 -0400
In-Reply-To: <20081005.090202.143862823.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

David Miller wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Sun, 05 Oct 2008 16:48:36 +0200
> 
>> The main goal is to get the directory contents to a more reasonable
>> level and group related stuff together; using just net/netfilter/ct
>> is still a bit too coarse in my opinion. Under that aspect, what
>> would your proposed structure be?
> 
> One thing I'm looking forward to is the elimination of all of
> the xt_* prefixes, and in general better TAB completion
> friendliness when I try to open netfilter source files under
> emacs or grep things from the command line with tab completed
> paths.

I'm not sure how emacs handles completion, would using different
prefixes for matches and targets help? Otherwise I guess we can
just get rid of the prefixes entirely.

The main problem with these renames is that it module aliases
don't work for "rmmod", which is a pretty common thing with
these modules. I guess we'd need to fix up module-init-tools
first.
