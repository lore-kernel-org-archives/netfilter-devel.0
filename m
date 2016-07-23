From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables 1/2] xtables-translate: add new field to
 identify the caller
Date: Sat, 23 Jul 2016 13:24:09 +0200
Message-ID: <20160723112409.GA13371@salvia>
References: <20160722154834.1802-1-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37158 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbcGWLYS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Jul 2016 07:24:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 01090E7DA2
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 13:24:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E4FD8FAB58
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 13:24:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E99686DA2D
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 13:24:14 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160722154834.1802-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 22, 2016 at 05:48:33PM +0200, Pablo M. Bermudo Garay wrote:
> In some cases, xlate functions must print a different result if they are
> invoked from nft and not from a xtables-translate command.
> 
> This commit adds a new boolean field to the xt_xlate struct. This
> variable must be true when a xlate function is called from a nft
> command. Additional code is required in nft in order to obtain this
> behavior.

Why not simply pass a new parameter to ->xlate()?

This patch is anyway updating the binary interface and it makes this
less obscure as it is part of the interface.

The xlate structure hides the buffer intentionally to avoid exposing
it the the backend extensions, the comments are also stored there to
use native nf_tables comment support.

But the only reason for this approach is that you're being lazy and
you don't want to upgrade the footprint of every xlate extension ;-)
