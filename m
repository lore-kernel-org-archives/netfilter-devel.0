From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] extensions: libxt_multiport: Add translation to nft
Date: Tue, 31 May 2016 00:41:04 +0200
Message-ID: <20160530224104.GA2199@salvia>
References: <20160530194748.GA25328@sonyv>
 <CAOkSjBgKZyr-GJLWwASNoLOftJbQu5boiTpMOfNsj7YCktYGxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Laura Garcia Liebana <nevola@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43633 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161681AbcE3WlM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 May 2016 18:41:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 154A71B6C07
	for <netfilter-devel@vger.kernel.org>; Tue, 31 May 2016 00:41:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 051EFA8E2
	for <netfilter-devel@vger.kernel.org>; Tue, 31 May 2016 00:41:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 063976447E
	for <netfilter-devel@vger.kernel.org>; Tue, 31 May 2016 00:41:06 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAOkSjBgKZyr-GJLWwASNoLOftJbQu5boiTpMOfNsj7YCktYGxw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 31, 2016 at 12:08:57AM +0200, Arturo Borrero Gonzalez wrote:
> On 30 May 2016 at 21:47, Laura Garcia Liebana <nevola@gmail.com> wrote:
> > Add translation for multiport to nftables, which it's supported natively.
> >
> > Examples:
> >
> > $ sudo iptables-translate -t filter -A INPUT -p tcp -m multiport --dports 80,81 -j ACCEPT
> > nft add rule ip filter INPUT ip protocol tcp tcp dport { 80,81} counter accept
> >
> > $ sudo iptables-translate -t filter -A INPUT -p tcp -m multiport --dports 80:88 -j ACCEPT
> > nft add rule ip filter INPUT ip protocol tcp tcp dport { 80-88} counter accept
> >
> > $ sudo iptables-translate -t filter -A INPUT -p tcp -m multiport ! --dports 80:88 -j ACCEPT
> > nft add rule ip filter INPUT ip protocol tcp tcp dport != 80-88 counter accept
> >
> 
> Lets clarify the syntax, this is valid:
> 
> tcp dport 8000-8100
> tcp dport { 8000-8100}
> tcp dport { 8000-8100, 9000-9100}
> 
> but they mean different things. It seems we should avoid the braces {}
> for the range case, otherwise we would be using a set with a single
> element.
> 
> However,
> 
> tcp dport {8000,8100} <-- valid
> tcp dport 8000,8100 <-- invalid
> 
> So we should always use braces {} in the non-range case.
> 
> Same seems to apply in the case of inversion.
> 
> so we end with this combinations:
> 
> tcp dport {x,x}
> tcp dport != {x,x}
> tcp dport x-x
> tcp dport != x-x
> 
> BTW, related to this, there seems to be a bug in nftables:
> 
> % nft add rule t c tcp dport != {80, 81}
> BUG: invalid expression type set
> nft: evaluate.c:1463: expr_evaluate_relational: Assertion `0' failed.
> Aborted

This is not yet supported. This requires a small kernel patch to allow
inversions in the nft_lookup.c. Then, the little extra code for
libnftnl and nft.

All tests for this usecase are disabled at the moment.
