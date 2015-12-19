From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] extensions: libxt_mark: Add translation to nft
Date: Sat, 19 Dec 2015 18:48:07 +0100
Message-ID: <20151219174807.GB1421@salvia>
References: <20151219071631.GA6338@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54097 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbbLSRsM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Dec 2015 12:48:12 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id BFEA124A0E4
	for <netfilter-devel@vger.kernel.org>; Sat, 19 Dec 2015 18:48:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B2776DA809
	for <netfilter-devel@vger.kernel.org>; Sat, 19 Dec 2015 18:48:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 24AE0DA811
	for <netfilter-devel@vger.kernel.org>; Sat, 19 Dec 2015 18:48:09 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151219071631.GA6338@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Dec 19, 2015 at 12:46:31PM +0530, Shivani Bhardwaj wrote:
> Add translation for metainformation mark to nftables.
> 
> Examples:
> 
> $ sudo iptables-translate -I INPUT -m mark --mark 12
> nft insert rule ip filter INPUT mark  & xc counter
> 
> $ sudo iptables-translate -A FORWARD -m mark --mark 22 -j ACCEPT
> nft add rule ip filter FORWARD mark  & x16 counter accept
> 
> $ sudo iptables-translate -t mangle -A PREROUTING -p tcp --dport 46000 -m mark --mark 0x40
> nft add rule ip mangle PREROUTING tcp dport 46000 mark  & x40 counter
> 
> $  sudo iptables-translate -A FORWARD -m mark -k 0x400/0x400 -j ACCEPT
> nft add rule ip filter FORWARD mark  & x400 == x400 counter accept

Much better, getting closer, but still these translations are not
correct, please fix them and respin, thanks.
