From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv4] extensions: libxt_multiport: Add translation to nft
Date: Mon, 6 Jun 2016 13:27:45 +0200
Message-ID: <20160606112745.GA30079@salvia>
References: <20160602172923.GA24172@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52911 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbcFFL1x (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jun 2016 07:27:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 6F98310078A
	for <netfilter-devel@vger.kernel.org>; Mon,  6 Jun 2016 13:27:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5F31F1B32E1
	for <netfilter-devel@vger.kernel.org>; Mon,  6 Jun 2016 13:27:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 43FEB1B32D4
	for <netfilter-devel@vger.kernel.org>; Mon,  6 Jun 2016 13:27:50 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160602172923.GA24172@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 02, 2016 at 07:29:26PM +0200, Laura Garcia Liebana wrote:
> Add translation for multiport to nftables, which it's supported natively.
> 
> Examples:
> 
> $ sudo iptables-translate -t filter -A INPUT -p tcp -m multiport --dports 80,81 -j ACCEPT
> nft add rule ip filter INPUT ip protocol tcp tcp dport { 80,81} counter accept
> 
> $ sudo iptables-translate -t filter -A INPUT -p tcp -m multiport --dports 80:88 -j ACCEPT
> nft add rule ip filter INPUT ip protocol tcp tcp dport 80-88 counter accept
> 
> $ sudo iptables-translate -t filter -A INPUT -p tcp -m multiport ! --dports 80:88 -j ACCEPT
> nft add rule ip filter INPUT ip protocol tcp tcp dport != 80-88 counter accept

Applied.

Please, enable trailing whitespace detection in your editor:

patch:88:
trailing whitespace.
        if (multiinfo->count > 2 || 
                                   ^
 warning: 2 lines add whitespace errors.

Thanks.
