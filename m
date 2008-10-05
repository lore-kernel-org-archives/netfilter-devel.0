From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: RFC: net/netfilter reorganization
Date: Sun, 5 Oct 2008 12:15:24 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810051212060.21891@fbirervta.pbzchgretzou.qr>
References: <48E8C90D.10202@trash.net> <alpine.LNX.1.10.0810051004230.21891@fbirervta.pbzchgretzou.qr> <48E8D3C4.60306@trash.net> <20081005.090202.143862823.davem@davemloft.net> <48E8E736.8060800@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: David Miller <davem@davemloft.net>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46946 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756965AbYJEQP0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:15:26 -0400
In-Reply-To: <48E8E736.8060800@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2008-10-05 12:11, Patrick McHardy wrote:
>> 
>> One thing I'm looking forward to is the elimination of all of
>> the xt_* prefixes, and in general better TAB completion
>> friendliness when I try to open netfilter source files under
>> emacs or grep things from the command line with tab completed
>> paths.
>
> I'm not sure how emacs handles completion, would using different
> prefixes for matches and targets help? Otherwise I guess we can
> just get rid of the prefixes entirely.

Allow me to speak generally for humans.. we are lazy to type, so
usually it's just the first three or four characters (or less,
of course) we want to type before hitting TAB the first time.
By eliminating prefixes, you already start typing on the "real"
name, which means your chances that TAB completion returns just
a single file is much higher.

> The main problem with these renames is that it module aliases
> don't work for "rmmod", which is a pretty common thing with
> these modules. I guess we'd need to fix up module-init-tools
> first.

When was the last time you used tab completion on .ko files?
I think this is sufficient:

obj-$(config_foo) += nfct_ftp.o
nfct_ftp-objs := ftp.c

That way, Mr Developer can use ft<TAB> to get ftp.c, but the
final module that we will be using with modprobe/rmmod still
has the prefix (and we should really have one!)
