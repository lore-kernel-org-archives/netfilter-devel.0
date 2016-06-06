From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv2] extensions: libip6t_frag: Add translation to nft
Date: Tue, 7 Jun 2016 00:45:50 +0200
Message-ID: <20160606224550.GA3040@salvia>
References: <20160606192543.GA4818@sonyv>
 <20160606224345.GB2936@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51318 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900AbcFFWpy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jun 2016 18:45:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 6EAB8CD6F0D
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2016 00:45:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 611799EBA3
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2016 00:45:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 671EC9EBAA
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2016 00:45:51 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160606224345.GB2936@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 07, 2016 at 12:43:45AM +0200, Pablo Neira Ayuso wrote:
> On Mon, Jun 06, 2016 at 09:25:46PM +0200, Laura Garcia Liebana wrote:
> > Add translation for frag to nftables. According to the --fraglen code:
> > 
> > 	case O_FRAGLEN:
> > 		/*
> > 		 * As of Linux 3.0, the kernel does not check for
> > 		 * fraglen at all.
> > 		 */
> > 
> > In addition, the kernel code doesn't show any reference to the flag
> > IP6T_FRAG_LEN, so this option is deprecated and won't be translated to
> > nft.
> > 
> > Examples:
> > 
> > $ sudo iptables-translate -t filter -A INPUT -m frag --fragid 100:200 -j ACCEPT
> > nft add rule ip6 filter INPUT frag id 100-200 counter accept
> > 
> > $ sudo iptables-translate -t filter -A INPUT -m frag --fragid 100 --fragres --fragmore -j ACCEPT
> > nft add rule ip6 filter INPUT frag id 100 frag reserved 1 frag more-fragments 1 counter accept
> > 
> > $ sudo iptables-translate -t filter -A INPUT -m frag ! --fragid 100:200 -j ACCEPT
> > nft add rule ip6 filter INPUT frag id != 100-200 counter accept
> > 
> > $ sudo iptables-translate -t filter -A INPUT -m frag --fragid 100:200 --fraglast -j ACCEPT
> > nft add rule ip6 filter INPUT frag id 100-200 frag more-fragments 1 counter accept
> > 
> > $ sudo iptables-translate -t filter -A INPUT -m frag --fragid 100:200 --fragfirst -j ACCEPT
> > nft add rule ip6 filter INPUT frag id 100-200 frag frag-off 0 counter accept
> 
> Also applied, thanks.

Wait..

+static int frag_xlate(const void *ip, const struct xt_entry_match *match,
+                     struct xt_xlate *xl, int numeric)
+{
+       const struct ip6t_frag *fraginfo = (struct ip6t_frag
*)match->data;
+
+       if (fraginfo->flags & IP6T_FRAG_LEN)
+               return 0;

You better ignore completely IP6T_FRAG_LEN as the kernelside does.

No need to give up on providing a translation if this is used,
instead, let's relax this.

So please, remove this check. Thanks.
