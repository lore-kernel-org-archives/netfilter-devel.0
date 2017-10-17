From: Duncan Roe <duncan_roe@optusnet.com.au>
Subject: Re: Problem compiling nftables
Date: Wed, 18 Oct 2017 10:38:02 +1100
Message-ID: <20171017233802.GA3615@dimstar.local.net>
References: <20171017171928.GJ6963@ubuntu-server-1604>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        outreachy-kernel@googlegroups.com
To: "Frank A. Cancio Bello" <frank@generalsoftwareinc.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:34889 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753850AbdJQXiR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2017 19:38:17 -0400
Received: from dimstar.local.net (c220-239-36-238.eburwd6.vic.optusnet.com.au [220.239.36.238])
        by mail107.syd.optusnet.com.au (Postfix) with SMTP id 93BD1D4214E
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Oct 2017 10:38:04 +1100 (AEDT)
Content-Disposition: inline
In-Reply-To: <20171017171928.GJ6963@ubuntu-server-1604>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Frank,

The libnftnl patch was comitted 2 minutes before you posted :/

It all builds fine for me now.

Your problem is with generating the man page rather than with compiling the
code. There is a separate Makefile in nftables/doc which you can run on its
own to do this.

When I run "make V=1" in nftables/doc I see the single command
> docbook2x-man --xinclude nft.xml
which gnerates nft.8 for me when I run it. Do you have that utility?

docbook2x-man and jw both come from package linuxdoc-tools (on Slackware, at
least). If you end up installing docbook2x-man, you should likely re-run
./configure before re-trying make.

Cheers ... Duncan.

On Tue, Oct 17, 2017 at 01:19:28PM -0400, Frank A. Cancio Bello wrote:
> Hi,
>
> I trying to install nftables from source ask part of my Outreachy
> application tasks. I already installed libmnl and libnftnl successfully.
>
> The problem comes after the 'make' command while trying to compile nftables.
> I'm running Ubuntu 16.04 and following the steps described here:
> https://wiki.nftables.org/wiki-nftables/index.php/Building_and_installing_nftables_from_sources
>
> I removed the last commit of the nftables master branch:
> 8dee5e43ad4beb2b0a95e0bbf2b3972630c1b327 'netlink: Use nftnl_expr_fprintf()
> in netlink_dump_expr()', to avoid a compilation error because a dependency
> with a libnftnl's patch still pending to apply. But the following error is
> beyond my skills right now and maybe is just a detail that I'm missing and
> somebody can help me.
>
> Thanks in advance
> frank
>
> Here is the relevant make output:
>
> ...
> make[3]: Leaving directory '/home/vagrant/git/pablo/nftables/nftables/include/linux'
> make[3]: Entering directory '/home/vagrant/git/pablo/nftables/nftables/include'
> make[3]: Nothing to be done for 'all-am'.
> make[3]: Leaving directory '/home/vagrant/git/pablo/nftables/nftables/include'
> make[2]: Leaving directory '/home/vagrant/git/pablo/nftables/nftables/include'
> Making all in doc
> make[2]: Entering directory '/home/vagrant/git/pablo/nftables/nftables/doc'
>   GEN      nft.8
> Usage: jw [<options>] <sgml_file>
> where <options> are:
[SNIP]
