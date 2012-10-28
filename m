From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] net/ipv6/netfilter: solve section mismatch in
 nf_conntrack_reasm
Date: Sun, 28 Oct 2012 23:50:26 +0100
Message-ID: <20121028225026.GA1143@1984>
References: <508BAE26.6010104@yahoo.es>
 <1351428585.15482.3.camel@cr0>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Hein Tibosch <hein_tibosch@yahoo.es>,
	David Miller <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	Michal =?utf-8?Q?Kube=C4=8Dek?= <mkubecek@suse.cz>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
To: Cong Wang <amwang@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33488 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754346Ab2J1Wu3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Oct 2012 18:50:29 -0400
Content-Disposition: inline
In-Reply-To: <1351428585.15482.3.camel@cr0>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 28, 2012 at 08:49:45PM +0800, Cong Wang wrote:
> On Sat, 2012-10-27 at 17:49 +0800, Hein Tibosch wrote:
> > From: Hein Tibosch <hein_tibosch@yahoo.es>
> > Subject: net/ipv6/netfilter: solve section mismatch in nf_conntrack_reasm
> > 
> > WARNING: net/ipv6/netfilter/nf_defrag_ipv6.o(.text+0xe0): Section mismatch in
> > reference from the function nf_ct_net_init() to the function
> > .init.text:nf_ct_frag6_sysctl_register()
> > The function nf_ct_net_init() references
> > the function __init nf_ct_frag6_sysctl_register().
> > etc
> > 
> > In case nf_conntrack_ipv6 is compiled as a module, nf_ct_net_init could be
> > called after the init code and data are unloaded.
> > Therefore remove the "__net_init" annotation from nf_ct_frag6_sysctl_register()
> > 
> > Signed-off-by: Hein Tibosch <hein_tibosch@yahoo.es>
> 
> Acked-by: Cong Wang <amwang@redhat.com>

Applied, thanks.
