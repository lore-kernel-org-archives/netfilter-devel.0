From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v2] evaluate: fix "list set" unexpected behaviour
Date: Wed, 1 Jun 2016 13:11:44 +0200
Message-ID: <20160601111144.GA11275@salvia>
References: <20160601101651.23971-1-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48413 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbcFALLw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Jun 2016 07:11:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 07DE04BADC2
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2016 13:11:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EB01E1BDA04
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2016 13:11:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0345D1BDA0B
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2016 13:11:49 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160601101651.23971-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 01, 2016 at 12:16:51PM +0200, Pablo M. Bermudo Garay wrote:
> Special sets like maps and flow tables have their own commands to be
> listed and inspected.
> 
> Before this patch, "nft list set" was able to display these special sets
> content:
> 
>   # nft list set filter test
>   table ip filter {
>           map test {
>                   type ipv4_addr : inet_service
>                   elements = { 192.168.1.101 : http-alt}
>           }
>   }
> 
> Now an error is shown:
> 
>   # nft list set filter test
>   <cmdline>:1:1-20: Error: Could not process rule: Set 'test' does not exist
>   list set filter test
>   ^^^^^^^^^^^^^^^^^^^^

OK, let's place this in the tree before the release.

Applied, thanks.
