From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables-nftables] iptables: fix compil when
 lib[mnl|nftables] are not in standard path
Date: Thu, 14 Mar 2013 16:43:57 +0100
Message-ID: <20130314154357.GB15759@localhost>
References: <1362582031-17576-1-git-send-email-nicolas.dichtel@6wind.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45465 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755779Ab3CNPoC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Mar 2013 11:44:02 -0400
Content-Disposition: inline
In-Reply-To: <1362582031-17576-1-git-send-email-nicolas.dichtel@6wind.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 06, 2013 at 04:00:31PM +0100, Nicolas Dichtel wrote:
> There was several problems:
>  a typo in the configure option
>  a typo in CFLAGS addon for libmnl and libnftables
>  paths to lib were missing on link

Also applied, thanks.
