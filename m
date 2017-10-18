From: "Frank A. Cancio Bello" <frank@generalsoftwareinc.com>
Subject: Re: Problem compiling nftables
Date: Tue, 17 Oct 2017 21:36:07 -0400
Message-ID: <20171018013607.GA14756@ubuntu-server-1604>
References: <20171017171928.GJ6963@ubuntu-server-1604>
 <20171017233802.GA3615@dimstar.local.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        outreachy-kernel@googlegroups.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f176.google.com ([209.85.217.176]:56181 "EHLO
        mail-ua0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755377AbdJRBgM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2017 21:36:12 -0400
Received: by mail-ua0-f176.google.com with SMTP id b11so2501332uae.12
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 18:36:12 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20171017233802.GA3615@dimstar.local.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 18, 2017 at 10:38:02AM +1100, Duncan Roe wrote:
> Hi Frank,
> 
> The libnftnl patch was comitted 2 minutes before you posted :/
> 
> It all builds fine for me now.
> 
> Your problem is with generating the man page rather than with compiling the
> code. There is a separate Makefile in nftables/doc which you can run on its
> own to do this.
> 

Worked like a charm!

> When I run "make V=1" in nftables/doc I see the single command
> > docbook2x-man --xinclude nft.xml
> which gnerates nft.8 for me when I run it. Do you have that utility?
> 
> docbook2x-man and jw both come from package linuxdoc-tools (on Slackware, at
> least). If you end up installing docbook2x-man, you should likely re-run
> ./configure before re-trying make.
>

After execute 'sudo apt install docbook2x' on my Ubuntu box the problem went away.

Thanks a lot for your quick response Duncan!
frank
