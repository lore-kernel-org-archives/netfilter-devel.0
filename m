From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH nf] netfilter: xt_NFLOG: fix unexpected truncated packet
Date: Wed, 9 Nov 2016 09:32:21 +0100
Message-ID: <20161109083221.GB19387@kroah.com>
References: <1476191025-16296-1-git-send-email-zlpnobody@163.com>
 <Pine.LNX.4.64.1610291902380.20350@nacho.alt.net>
 <CAML_gOcF=1cC5e57Q1SKt5tnZj3E==pMYmpc1yD98fFrCrp4ug@mail.gmail.com>
 <Pine.LNX.4.64.1610300318300.21786@nacho.alt.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liping Zhang <zlpnobody@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>,
        Justin Piszcz <jpiszcz@lucidpixels.com>,
        Vishwanath Pai <vpai@akamai.com>,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Chris Caputo <ccaputo@alt.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48158 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751611AbcKIIcO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Nov 2016 03:32:14 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1610300318300.21786@nacho.alt.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 30, 2016 at 03:20:25AM +0000, Chris Caputo wrote:
> On Sun, 30 Oct 2016, Liping Zhang wrote:
> > 2016-10-30 3:04 GMT+08:00 Chris Caputo <ccaputo@alt.net>:
> > > Can we get this patch approved?  It is definitely needed for the 4.8.x
> > > tree and 4.9-rcX and mainline.
> > 
> > This patch was already applied, and was upstream to net.git:
> > https://git.kernel.org/cgit/linux/kernel/git/davem/net.git/commit/?id=6d19375b58763fefc2f215fb45117d3353ced888
> > 
> > I think you will see this patch in mainline soon.
> 
> Greg, any chance this could be picked up for 4.8.6?  (apologies if I am 
> out of line)

Looks good, now queued up.

thanks,

greg k-h
