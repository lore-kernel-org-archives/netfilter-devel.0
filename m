From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH] list: fix prefetch dummy
Date: Wed, 8 Apr 2015 19:04:07 +0200
Message-ID: <20150408170407.GB25269@salvia>
References: <20150406180541.7031.97131.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48230 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932241AbbDHQ75 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Apr 2015 12:59:57 -0400
Content-Disposition: inline
In-Reply-To: <20150406180541.7031.97131.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 06, 2015 at 08:05:41PM +0200, Arturo Borrero Gonzalez wrote:
> linux_list.h:381:59: warning: right-hand operand of comma expression has no effect [-Wunused-value]
>   for (pos = list_entry((head)->next, typeof(*pos), member), \
>                                                            ^
> libiptc.c:552:2: note: in expansion of macro 'list_for_each_entry'
>   list_for_each_entry(c, &h->chains, list) {
>   ^
> 
> [ Patch copied from one similar of Patrick McHardy on libnftnl ]

Also applied, thanks.
