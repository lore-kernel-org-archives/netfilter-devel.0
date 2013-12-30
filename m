From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCHv3 2/2] netfilter: nft: reject support for IPv6 and
 TCP reset
Date: Mon, 30 Dec 2013 18:18:31 +0100
Message-ID: <20131230171831.GB21208@localhost>
References: <1388155892.6117.7.camel@ice-age2.regit.org>
 <1388316494-1194-1-git-send-email-eric@regit.org>
 <1388316494-1194-3-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36813 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756051Ab3L3RSf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Dec 2013 12:18:35 -0500
Content-Disposition: inline
In-Reply-To: <1388316494-1194-3-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Dec 29, 2013 at 12:28:14PM +0100, Eric Leblond wrote:
> This patch moves nft_reject_ipv4 to nft_reject and adds support
> for IPv6 protocol. This patch uses functions included in nf_reject.h
> to implement reject by TCP reset.
> 
> The code has to be build as a module if NF_TABLES_IPV6 is also a
> module to avoid compilation error due to usage of IPv6 functions.
> This has been done in Kconfig by using the construct:
>  depends on NF_TABLES_IPV6 || !NF_TABLES_IPV6
> This seems a bit weird in term of syntax but works perfectly.

Also applied, thanks.
