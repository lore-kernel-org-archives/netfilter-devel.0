From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 1/2] nfnetlink: add netns support
Date: Wed, 13 Jan 2010 15:22:56 +0200
Message-ID: <20100113132255.GA16975@x200>
References: <20100113122420.GA5790@x200>
 <4B4DC469.5000408@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	containers@lists.linux-foundation.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:61631 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab0AMNXC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2010 08:23:02 -0500
Received: by fxm25 with SMTP id 25so144227fxm.21
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Jan 2010 05:23:01 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <4B4DC469.5000408@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 13, 2010 at 02:02:33PM +0100, Patrick McHardy wrote:
> Alexey Dobriyan wrote:

> > +	struct sock		*nfnl;
> > +	struct sock		*nfnl_stash;
> 
> Shouldn't this be contained in an ifdef(CONFIG_NETFILTER_NETLINK)
> (_MODULE) ?

No, otherwise you won't be able to start using, e. g., nfnetlink_log
module on NETFILTER_NETLINK=n kernels without reboot.

> The remaining parts look good to me.

OK, I'll resend shortly.
