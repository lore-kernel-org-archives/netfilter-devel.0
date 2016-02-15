From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4] extensions: libxt_NFQUEUE: Add translation to nft
Date: Mon, 15 Feb 2016 20:49:57 +0100
Message-ID: <20160215194957.GA8889@salvia>
References: <20160209085310.GA13872@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57831 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbcBOTuC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Feb 2016 14:50:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 74DAC6C0A
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Feb 2016 20:50:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6652D91DC
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Feb 2016 20:50:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9417291C4
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Feb 2016 20:49:58 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160209085310.GA13872@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 09, 2016 at 02:23:10PM +0530, Shivani Bhardwaj wrote:
> Add translation for NF queue to nftables.
> 
> Examples:
> 
> $ sudo iptables-translate -t nat -A PREROUTING -p tcp --dport 80 -j NFQUEUE --queue-num 30
> nft add rule ip nat PREROUTING tcp dport 80 counter queue num 30
> 
> $ sudo iptables-translate -A FORWARD -j NFQUEUE --queue-num 0 --queue-bypass -p TCP --sport 80
> nft add rule ip filter FORWARD tcp sport 80 counter queue num 0 bypass
> 
> $ sudo iptables-translate -A FORWARD -j NFQUEUE --queue-bypass -p TCP --sport 80 --queue-balance 0:3 --queue-cpu-fanout
> nft add rule ip filter FORWARD tcp sport 80 counter queue num 0-3 bypass,fanout

Applied, thanks Shivani.
