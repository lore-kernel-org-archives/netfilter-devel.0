From: Cong Wang <amwang@redhat.com>
Subject: Re: [PATCH] net/ipv6/netfilter: solve section mismatch in
 nf_conntrack_reasm
Date: Sun, 28 Oct 2012 20:49:45 +0800
Message-ID: <1351428585.15482.3.camel@cr0>
References: <508BAE26.6010104@yahoo.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	Michal =?UTF-8?Q?Kube=C4=8Dek?= <mkubecek@suse.cz>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
To: Hein Tibosch <hein_tibosch@yahoo.es>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079Ab2J1MuM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Oct 2012 08:50:12 -0400
In-Reply-To: <508BAE26.6010104@yahoo.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 2012-10-27 at 17:49 +0800, Hein Tibosch wrote:
> From: Hein Tibosch <hein_tibosch@yahoo.es>
> Subject: net/ipv6/netfilter: solve section mismatch in nf_conntrack_reasm
> 
> WARNING: net/ipv6/netfilter/nf_defrag_ipv6.o(.text+0xe0): Section mismatch in
> reference from the function nf_ct_net_init() to the function
> .init.text:nf_ct_frag6_sysctl_register()
> The function nf_ct_net_init() references
> the function __init nf_ct_frag6_sysctl_register().
> etc
> 
> In case nf_conntrack_ipv6 is compiled as a module, nf_ct_net_init could be
> called after the init code and data are unloaded.
> Therefore remove the "__net_init" annotation from nf_ct_frag6_sysctl_register()
> 
> Signed-off-by: Hein Tibosch <hein_tibosch@yahoo.es>

Acked-by: Cong Wang <amwang@redhat.com>

Thanks!

