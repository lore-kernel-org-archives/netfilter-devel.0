From: Robby Workman <robby@rlworkman.net>
Subject: Re: build failure if --with-xtables [WAS: nftables 0.7 release]
Date: Tue, 3 Jan 2017 15:56:14 -0600
Message-ID: <20170103155614.40273a5e.robby@rlworkman.net>
References: <20161220204636.GA11674@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from harrier.slackbuilds.org ([207.223.116.211]:52690 "EHLO
        harrier.slackbuilds.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758164AbdACWDk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Jan 2017 17:03:40 -0500
In-Reply-To: <20161220204636.GA11674@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 20 Dec 2016 21:46:36 +0100
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> Hi!
> 
> The Netfilter project proudly presents:
> 
>         nftables 0.7
> 
> This release contains many accumulated bug fixes and new features
> available up to the (upcoming) Linux 4.10-rc1 kernel release.
> 
> * Facilitate migration from iptables to nftables:
> 
>   At compilation time, you have to pass this option.
> 
>   # ./configure --with-xtables


I get a build failure with this option - bug filed with some details:
https://bugzilla.netfilter.org/show_bug.cgi?id=1110

-RW
