From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv2] extensions: libip6t_frag: Add translation to nft
Date: Tue, 7 Jun 2016 00:43:45 +0200
Message-ID: <20160606224345.GB2936@salvia>
References: <20160606192543.GA4818@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51191 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447AbcFFWnu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jun 2016 18:43:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9A30ACD6F12
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2016 00:43:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8B59D9EBA7
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2016 00:43:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7F3FD9EBA7
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2016 00:43:46 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160606192543.GA4818@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 06, 2016 at 09:25:46PM +0200, Laura Garcia Liebana wrote:
> Add translation for frag to nftables. According to the --fraglen code:
> 
> 	case O_FRAGLEN:
> 		/*
> 		 * As of Linux 3.0, the kernel does not check for
> 		 * fraglen at all.
> 		 */
> 
> In addition, the kernel code doesn't show any reference to the flag
> IP6T_FRAG_LEN, so this option is deprecated and won't be translated to
> nft.
> 
> Examples:
> 
> $ sudo iptables-translate -t filter -A INPUT -m frag --fragid 100:200 -j ACCEPT
> nft add rule ip6 filter INPUT frag id 100-200 counter accept
> 
> $ sudo iptables-translate -t filter -A INPUT -m frag --fragid 100 --fragres --fragmore -j ACCEPT
> nft add rule ip6 filter INPUT frag id 100 frag reserved 1 frag more-fragments 1 counter accept
> 
> $ sudo iptables-translate -t filter -A INPUT -m frag ! --fragid 100:200 -j ACCEPT
> nft add rule ip6 filter INPUT frag id != 100-200 counter accept
> 
> $ sudo iptables-translate -t filter -A INPUT -m frag --fragid 100:200 --fraglast -j ACCEPT
> nft add rule ip6 filter INPUT frag id 100-200 frag more-fragments 1 counter accept
> 
> $ sudo iptables-translate -t filter -A INPUT -m frag --fragid 100:200 --fragfirst -j ACCEPT
> nft add rule ip6 filter INPUT frag id 100-200 frag frag-off 0 counter accept

Also applied, thanks.
