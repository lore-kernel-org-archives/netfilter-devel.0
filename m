From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: net/netfilter reorganization
Date: Sun, 05 Oct 2008 18:21:24 +0200
Message-ID: <48E8E984.8090807@trash.net>
References: <48E8C90D.10202@trash.net> <alpine.LNX.1.10.0810051004230.21891@fbirervta.pbzchgretzou.qr> <48E8D3C4.60306@trash.net> <20081005.090202.143862823.davem@davemloft.net> <48E8E736.8060800@trash.net> <alpine.LNX.1.10.0810051212060.21891@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48591 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758768AbYJEQVa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:21:30 -0400
In-Reply-To: <alpine.LNX.1.10.0810051212060.21891@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Sunday 2008-10-05 12:11, Patrick McHardy wrote:
>>> One thing I'm looking forward to is the elimination of all of
>>> the xt_* prefixes, and in general better TAB completion
>>> friendliness when I try to open netfilter source files under
>>> emacs or grep things from the command line with tab completed
>>> paths.
>> I'm not sure how emacs handles completion, would using different
>> prefixes for matches and targets help? Otherwise I guess we can
>> just get rid of the prefixes entirely.
> 
> Allow me to speak generally for humans.. we are lazy to type, so
> usually it's just the first three or four characters (or less,
> of course) we want to type before hitting TAB the first time.
> By eliminating prefixes, you already start typing on the "real"
> name, which means your chances that TAB completion returns just
> a single file is much higher.

Thats true. Not using any prefixes requires keeping the
upper letter naming convention for targets though (which
I don't really mind).

>> The main problem with these renames is that it module aliases
>> don't work for "rmmod", which is a pretty common thing with
>> these modules. I guess we'd need to fix up module-init-tools
>> first.
> 
> When was the last time you used tab completion on .ko files?

I don't use tab-completion above file-level at all, its takes
way to long to initialize all the more fancy stuff.

> I think this is sufficient:
> 
> obj-$(config_foo) += nfct_ftp.o
> nfct_ftp-objs := ftp.c
> 
> That way, Mr Developer can use ft<TAB> to get ftp.c, but the
> final module that we will be using with modprobe/rmmod still
> has the prefix (and we should really have one!)

A lot of people are unloading modules in their firewall scripts
and that will break.
