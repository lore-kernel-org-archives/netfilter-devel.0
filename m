From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4] extensions: libxt_mark: Add translation to nft
Date: Tue, 22 Dec 2015 17:22:19 +0100
Message-ID: <20151222162219.GA13758@salvia>
References: <20151220031412.GA8273@gmail.com>
 <20151222161948.GA13092@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56604 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655AbbLVQWZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2015 11:22:25 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id BA93B225927
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 17:22:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AC968DA803
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 17:22:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D4BD5DA85D
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 17:22:20 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151222161948.GA13092@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 22, 2015 at 05:19:48PM +0100, Pablo Neira Ayuso wrote:
> On Sun, Dec 20, 2015 at 08:44:12AM +0530, Shivani Bhardwaj wrote:
> > Add translation for metainformation mark to nftables.
> >
> > Examples:
> > 
> > $ sudo iptables-translate -I INPUT -m mark --mark 12
> > nft insert rule ip filter INPUT mark  0xc counter
> > 
> > $ sudo iptables-translate -A FORWARD -m mark --mark 22 -j ACCEPT
> > nft add rule ip filter FORWARD mark  0x16 counter accept
> > 
> > $ sudo iptables-translate -t mangle -A PREROUTING -p tcp --dport 4600 -m mark --mark 0x40
> > nft add rule ip mangle PREROUTING tcp dport 4600 mark  0x40 counter
> > 
> > $ sudo iptables-translate -A FORWARD -m mark --mark 0x400/0x400 -j ACCEPT
> > nft add rule ip filter FORWARD mark  and 0x400 == 0x400 counter accept
> 
> Applied with minor glitch I have fixed here.

I noticed another problem.

This translation doesn't look OK.

 # iptables-translate -I INPUT -p tcp -m mark ! --mark 0xa/0xa
 nft insert rule ip filter INPUT ip protocol tcp mark != and 0xa == 0xa counter 

No problem, please just send me a follow up patch to fix this and make
sure you test all possible code branches next time.

Thanks.
