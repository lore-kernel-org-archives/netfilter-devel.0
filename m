From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] src: Add cgroup support in meta expresion
Date: Mon, 10 Nov 2014 18:14:30 +0100
Message-ID: <20141110171430.GA26920@salvia>
References: <1415034651-27242-1-git-send-email-anarey@gmail.com>
 <1415034651-27242-3-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, dborkman@redhat.com
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40924 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918AbaKJRMn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:12:43 -0500
Content-Disposition: inline
In-Reply-To: <1415034651-27242-3-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 03, 2014 at 06:10:51PM +0100, Ana Rey wrote:
> The new attribute of meta is "cgroup".
> 
> Example of use in nft:
>  # nft add rule ip test output meta cgroup != 0x100001 counter drop
> 
> Moreover, It adds tests in meta.t test file.
> 
> The kernel support is add in the commit:
> netfilter: nft_meta: add cgroup support
> 
> The libnftnl  support is add in the commit:
> expr: meta: Add cgroup support
> 
> More information about the steps to use cgroup:
> https://www.kernel.org/doc/Documentation/cgroups/net_cls.txt
> 
> More info about cgroup in iptables:
> http://git.kernel.org/cgit/linux/kernel/git/pablo/nftables.git/commit/net/netfilter/xt_cgroup.c?id=82a37132f300ea53bdcd812917af5a6329ec80c3

Applied, thanks.
