From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv4] extensions: libip6t_frag: Add translation to nft
Date: Tue, 14 Jun 2016 18:33:29 +0200
Message-ID: <20160614163329.GA1181@salvia>
References: <20160608174725.GA21856@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43153 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbcFNQdg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jun 2016 12:33:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 31D35C2303
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 18:33:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 21E6C9EBA3
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 18:33:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 201CB9EBC2
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 18:33:32 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160608174725.GA21856@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 08, 2016 at 07:47:28PM +0200, Laura Garcia Liebana wrote:
> $ sudo iptables-translate -t filter -A INPUT -m frag --fragid 100:200 --fraglast -j ACCEPT
                                                                        ^^^^^^^^^^
> nft add rule ip6 filter INPUT frag id 100-200 frag more-fragments 1 counter accept
                                                     ^^^^^^^^^^^^^^^^
> $ sudo iptables-translate -t filter -A INPUT -m frag --fragid 100:200 --fragfirst -j ACCEPT
> nft add rule ip6 filter INPUT frag id 100-200 frag frag-off 0 counter accept
>
> $ sudo iptables-translate -t filter -A INPUT -m frag --fraglast -j ACCEPT
                                                       ^^^^^^^^^^
> nft add rule ip6 filter INPUT frag more-fragments 0 counter accept
                                     ^^^^^^^^^^^^^^^^

I'm going to mangle these inconsistencies in the patch description
given the code is fine (you probably just forgot to update the
patch description).

So applied, thanks.
