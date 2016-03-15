From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v5] extensions: libxt_multiport: Add translation to nft
Date: Tue, 15 Mar 2016 02:06:04 +0100
Message-ID: <20160315010604.GA23490@salvia>
References: <20160313084618.GA3913@fate>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Piyush Pangtey <gokuvsvegita@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60220 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754262AbcCOBGL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Mar 2016 21:06:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 281CA114F48
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 02:06:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1901FDA8FB
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 02:06:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8BC73DA386
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 02:06:05 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160313084618.GA3913@fate>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Mar 13, 2016 at 02:16:18PM +0530, Piyush Pangtey wrote:
> Added full translation for multiport
> 
> Examples :
> $ iptables-translate -A input -p tcp -m multiport --ports ssh:http -j ACCEPT
> nft add rule ip filter input ip protocol tcp tcp dport ssh - http tcp sport ssh - http counter accept

--ports is not so easy to translate as this implies an 'or'. But what
you expressed above is an 'and'.

So please return 0 for this case so we remember that we currently have
no translation for this. Actually, I remember Shivani documented this
on wiki.nftables.org.

> $ iptables-translate -A input -p sctp -m multiport --dports 11:18  -j ACCEPT
> nft add rule ip filter input ip protocol sctp sctp dport 11 - 18 counter accept

Almost there.

Note that nft generates the dependencies for you, so you can simplify
this translation above to:

$ iptables-translate -A input -p tcp -m multiport --dports ssh:http -j ACCEPT
nft add rule ip filter input tcp dport 22-80 counter accept

> $ iptables-translate -A input -p dccp -m multiport --sports 11:18 -j ACCEPT
> nft add rule ip filter input ip protocol dccp dccp sport 11 - 18 counter
> accept

You can remove "ip protocol dccp".

> $ ip6tables-translate -A input -p udplite -m multiport --sports 11:18 -j ACCEPT
> nft add rule ip6 filter input meta l4proto udplite udplite sport 11 - 18
> counter accept

You can also remove "meta l4proto udplite".

Please, don't forget to test that nft accepts the syntax that you
propose as translation.

Thanks.
