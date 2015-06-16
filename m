From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: iptables nftables compat weirdness
Date: Tue, 16 Jun 2015 18:07:25 +0200
Message-ID: <20150616160725.GA7165@salvia>
References: <1424744661.225751.1433848590972.JavaMail.zimbra@tpip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Andreas Schultz <aschultz@tpip.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59204 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbbFPQCT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2015 12:02:19 -0400
Content-Disposition: inline
In-Reply-To: <1424744661.225751.1433848590972.JavaMail.zimbra@tpip.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 09, 2015 at 11:16:30AM +0000, Andreas Schultz wrote:
> Hi,
> 
> While testing iptables-compat, I've come across some weird behavior:
> 
> # iptables-compat -t mangle -N TEST
> # iptables-compat -t mangle -A PREROUTING -j TEST 
> 
> This works nicely, but when we put something in the TEST chain:
> 
> # iptables-compat -t mangle -A TEST -j MARK --set-mark 0x80000000/0x80000000
> # iptables-compat -t mangle -A PREROUTING -j TEST
> iptables-compat: Invalid argument. Run `dmesg' for more information.
> 
> dmesg does not contain any information.
> 
> The same problem exists for all default chains in mangle, filter and nat.
> 
> Kernel is: 4.1-rc5
> iptables: git://git.netfilter.org/iptables, branch master,   commit 0bb1859e2d6dd79a0a59c3ee65f6a78cba118b86
> nftables: git://git.netfilter.org/nftables, branch next-4.1, commit a93bc1795b272174a10d90961a248f2c620bfa2c

Given that the pernet netfilter hooks are on its way to reach
mainstream (Eric Bierderman is working on that).

Could you help me diagnosing this problem? The nf_tables kernel side
is rejecting this with -EINVAL. Is this a new bug in the 4.1-rc
series?

Thank you.
