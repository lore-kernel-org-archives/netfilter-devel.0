From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: Add new function nf_ct_helper_init to
 init ct helper easily
Date: Wed, 25 Nov 2015 14:05:42 +0100
Message-ID: <20151125130542.GA27382@salvia>
References: <BAY403-EAS869240A915D1543054A10395150@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Feng Gao <gfree.wind@outlook.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41030 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140AbbKYNFq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 08:05:46 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id CCF15DA870
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 14:05:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BBCA9DA7FF
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 14:05:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9A93DDA85E
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 14:05:43 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <BAY403-EAS869240A915D1543054A10395150@phx.gbl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 10, 2015 at 07:47:02AM +0800, Feng Gao wrote:
> Hi Pablo,
> 
> Signed-off-by: Gao Feng <fgao@ikuai8.com>
> ---
>  include/net/netfilter/nf_conntrack_helper.h | 17 +++++-
>  net/netfilter/nf_conntrack_ftp.c            | 51 ++++++++---------
>  net/netfilter/nf_conntrack_helper.c         | 35 ++++++++++++
>  net/netfilter/nf_conntrack_irc.c            | 16 ++----
>  net/netfilter/nf_conntrack_sane.c           | 50 ++++++++--------
>  net/netfilter/nf_conntrack_sip.c            | 89
> +++++++++++++++++------------
>  net/netfilter/nf_conntrack_tftp.c           | 47 +++++++--------
>  7 files changed, 179 insertions(+), 126 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_conntrack_helper.h
> b/include/net/netfilter/nf_conntrack_helper.h
> index 6cf614bc..0c49c78 100644
> --- a/include/net/netfilter/nf_conntrack_helper.h
> +++ b/include/net/netfilter/nf_conntrack_helper.h
> @@ -58,7 +58,22 @@ struct nf_conntrack_helper
> *__nf_conntrack_helper_find(const char *name,
>  struct nf_conntrack_helper *nf_conntrack_helper_try_module_get(const char
> *name,
>  							       u16 l3num,
>  							       u8 protonum);

I wish I could say "Yes, applied" but I cannot :-(

Your MUA keeps mangling your emails, which basically result in
unappliable patches.

I spent 15 minutes trying to fix this but I couldn't so I'm giving up.

Please, resolve this and resubmit. Sorry.
