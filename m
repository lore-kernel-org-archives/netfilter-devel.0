From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables: tar packages
Date: Sun, 3 Nov 2013 18:45:06 +0100
Message-ID: <20131103174506.GA3836@localhost>
References: <52757AD7.30204@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48868 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753723Ab3KCRpL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Nov 2013 12:45:11 -0500
Content-Disposition: inline
In-Reply-To: <52757AD7.30204@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Nov 02, 2013 at 11:21:11PM +0100, Xose Vazquez Perez wrote:
> hi Pablo/Patrick,
> 
> Are you going to do tar packages of nftables [1]
> infrastructure (libnftables, nftables, iptables-nftables) ?
> 
> Or just only git ?

You can fetch daily snapshots via:

ftp://ftp.netfilter.org/pub/libnftables/snapshot/
ftp://ftp.netfilter.org/pub/nftables/snapshot/

Remember that the first expected Linux kernel version including
nftables is *3.13*.

The iptables-nftables tree is planned to be merged into iptables by
when 3.13-rc1 will be released.

The library ABI will freeze by when 3.13 will be released, meanwhile
expect ABI breakages. My recommendation, at this stage, is that you
keep fresh paired installations of libnftables and nftables to avoid
troubles.
