From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 7/6] netfilter: nft_ct: load both IPv4 and IPv6 conntrack
 modules for NFPROTO_INET
Date: Wed, 8 Jan 2014 00:03:33 +0100
Message-ID: <20140107230333.GB16008@localhost>
References: <1388751378-23272-1-git-send-email-kaber@trash.net>
 <20140106180948.GB27979@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33187 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875AbaAGXDh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jan 2014 18:03:37 -0500
Content-Disposition: inline
In-Reply-To: <20140106180948.GB27979@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 06, 2014 at 06:09:49PM +0000, Patrick McHardy wrote:
> commit 71bcc5bde767f1a6da04391b0d9595f30e3f720b
> Author: Patrick McHardy <kaber@trash.net>
> Date:   Mon Jan 6 17:58:02 2014 +0000
> 
>     netfilter: nft_ct: load both IPv4 and IPv6 conntrack modules for NFPROTO_INET
>     
>     The ct expression can currently not be used in the inet family since
>     we don't have a conntrack module for NFPROTO_INET, so
>     nf_ct_l3proto_try_module_get() fails. Add some manual handling to
>     load the modules for both NFPROTO_IPV4 and NFPROTO_IPV6 if the
>     ct expression is used in the inet family.

Applied, thanks!
