From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Implicit flow tables can't be listed
Date: Thu, 23 Jun 2016 12:11:14 +0200
Message-ID: <20160623101114.GA6248@salvia>
References: <20160616102901.GA27422@breakpoint.cc>
 <20160622121503.GA12472@salvia>
 <20160622122547.GA10213@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: nf-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39677 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbcFWKLS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2016 06:11:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 5062FE7DAA
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 12:11:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3EA04FF2C8
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 12:11:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 36304266721
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 12:11:15 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160622122547.GA10213@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 22, 2016 at 02:25:47PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > How can we actually relate the rule with the flow table if we have
> > several anonymous flow tables?
> 
> nft list table filter
> table ip filter {
>         chain input {
>                 type filter hook input priority 0; policy accept;
>                 flow table __ft0 { ip saddr counter packets 0 bytes 0}
>                 flow table __ft1 { ip daddr counter packets 0 bytes 0}
>         }
> 
> ... so the internal name will be shown.

OK, then enhance the scanner to catch __ and run tests to validate. I
don't think this break anything.
