From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH] libxtables: extensions find based also on family
Date: Thu, 9 Apr 2015 19:05:30 +0200
Message-ID: <20150409170530.GA5725@salvia>
References: <20150408174219.25244.24487.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50749 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478AbbDIRB2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Apr 2015 13:01:28 -0400
Content-Disposition: inline
In-Reply-To: <20150408174219.25244.24487.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 08, 2015 at 07:42:19PM +0200, Arturo Borrero Gonzalez wrote:
> When using libxtables with an external program (nft) which switches family
> contexts (using xtables_set_nfproto()), the extensions finding proccess
> needs to be smarter and also know about the family.
> 
> We want to avoid this situation:
> 
>  1) user first sets context to IPv6
>  2) xtables_find_target() finds & load ip6t_REJECT and uses it
>  3) context switch to IPv4
>  4) user then tries to use ipt_REJECT
>  5) xtables_find_target() will find ip6t_REJECT instead (same target name)
>  6) using ip6t_REJECT as ipt_REJECT can cause a lot of troubles

Applied with minor changes:

http://git.netfilter.org/iptables/commit/?id=06d14d702e481f29d5fdc33afab4347e6efb678d

Thanks.
