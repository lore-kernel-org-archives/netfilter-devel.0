From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_sctp: Add translation to nft
Date: Wed, 2 Mar 2016 12:54:53 +0100
Message-ID: <20160302115453.GA4365@salvia>
References: <20160301204056.GA18229@gmail.com>
 <20160302114826.GA3493@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55264 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070AbcCBLzK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 06:55:10 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 87FACC108C
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 12:55:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7B59FDA8F7
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 12:55:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 668C4DA8F7
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 12:55:07 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160302114826.GA3493@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 02, 2016 at 12:48:26PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Mar 02, 2016 at 02:10:56AM +0530, Shivani Bhardwaj wrote:
> > Add translation for sctp to nftables.
> > Full translation of this match awaits the support for --chunk-types
> > option.
> 
> Please, keep this documented in the wiki too so we remember there is a
> partial translation for this.
> 
> > Examples:
> > 
> > $ sudo iptables-translate -A INPUT -p sctp --dport 80 -j DROP
> > nft add rule ip filter INPUT sctp dport 80 counter drop
> > 
> > $ sudo iptables-translate -A INPUT -p sctp ! --sport 80:100 -j ACCEPT
> > nft add rule ip filter INPUT sctp sport != 80-100 counter accept
> 
> Applied, thanks Shivani.

Sorry, I have to keep this back.

This crazy thing seems to be valid:

        iptables -I INPUT -p sctp -m sctp

and this will be translated as:

        nft add rule filter INPUT ip protocol sctp sctp
