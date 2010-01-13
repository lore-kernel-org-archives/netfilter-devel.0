From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 1/2] nfnetlink: add netns support
Date: Wed, 13 Jan 2010 15:47:14 +0200
Message-ID: <20100113134714.GA19594@x200>
References: <20100113122420.GA5790@x200>
 <4B4DC469.5000408@trash.net>
 <20100113132255.GA16975@x200>
 <4B4DCA2C.7020000@trash.net>
 <20100113133727.GC16975@x200>
 <4B4DCDA8.5070108@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	containers@lists.linux-foundation.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:40088 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab0AMNrU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2010 08:47:20 -0500
Received: by fxm25 with SMTP id 25so170438fxm.21
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Jan 2010 05:47:19 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <4B4DCDA8.5070108@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 13, 2010 at 02:42:00PM +0100, Patrick McHardy wrote:
> Alexey Dobriyan wrote:
> > On Wed, Jan 13, 2010 at 02:27:08PM +0100, Patrick McHardy wrote:
> >> Alexey Dobriyan wrote:
> >>> On Wed, Jan 13, 2010 at 02:02:33PM +0100, Patrick McHardy wrote:
> >>>> Alexey Dobriyan wrote:
> >>>>> +	struct sock		*nfnl;
> >>>>> +	struct sock		*nfnl_stash;
> >>>> Shouldn't this be contained in an ifdef(CONFIG_NETFILTER_NETLINK)
> >>>> (_MODULE) ?
> >>> No, otherwise you won't be able to start using, e. g., nfnetlink_log
> >>> module on NETFILTER_NETLINK=n kernels without reboot.
> >> You mean after enabling CONFIG_NETFILTER_NETLINK?
> > 
> > Yes, and it can't be directly enabled, because it's hidden option.
> > 
> >> That seems like a pretty poor argument, you have to do a reboot after
> >> changing a lot of config options.
> > 
> > It's still a step back if I add #ifdef and a regression if you ask me.
> > The price is only two pointers per-netns.
> 
> Yes, I don't mind much, but I still think this is not an argument
> at all. Whether you have to reboot after changing your configuration
> has never been "stable" and we don't consider it when making changes.

Perhaps we should start considering it.

What's bool is bool and fair game.
What's tristate better be fully tristate.
