From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nftables v2] nftables: fix compilation when nf-netlink is
 a module
Date: Thu, 14 Mar 2013 16:43:47 +0100
Message-ID: <20130314154347.GA15759@localhost>
References: <51372681.7010604@6wind.com>
 <1362577327-16634-1-git-send-email-nicolas.dichtel@6wind.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45434 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755779Ab3CNPnx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Mar 2013 11:43:53 -0400
Content-Disposition: inline
In-Reply-To: <1362577327-16634-1-git-send-email-nicolas.dichtel@6wind.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 06, 2013 at 02:42:07PM +0100, Nicolas Dichtel wrote:
> nftables uses nfnl_[un]lock() and thus depends on
> CONFIG_NETFILTER_NETLINK.  It's not possible to have nftables
> built-in when CONFIG_NETFILTER_NETLINK is set to m.
> 
> I also add a dependancy between NETFILTER_XTABLES and NFT_COMPAT
> instead of automatically set NETFILTER_XTABLES when NFT_COMPAT is
> set. This is to avoid a circular dependency:
> 
> net/netfilter/Kconfig:432:error: recursive dependency detected!
> net/netfilter/Kconfig:432:	symbol NF_TABLES depends on NETFILTER_NETLINK
> net/netfilter/Kconfig:4:	symbol NETFILTER_NETLINK is selected by NETFILTER_NETLINK_ACCT
> net/netfilter/Kconfig:7:	symbol NETFILTER_NETLINK_ACCT is selected by NETFILTER_XT_MATCH_NFACCT
> net/netfilter/Kconfig:1087:	symbol NETFILTER_XT_MATCH_NFACCT depends on NETFILTER_XTABLES
> net/netfilter/Kconfig:425:	symbol NETFILTER_XTABLES is selected by NFT_COMPAT
> net/netfilter/Kconfig:478:	symbol NFT_COMPAT depends on NF_TABLES

Applied, thanks Nicolas.
