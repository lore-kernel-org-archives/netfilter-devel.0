From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 1/2] src: add 'list maps' support
Date: Tue, 31 May 2016 12:44:44 +0200
Message-ID: <20160531104444.GA4491@salvia>
References: <20160531103707.20058-1-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48020 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963AbcEaKo4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 May 2016 06:44:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 67D74EAA63
	for <netfilter-devel@vger.kernel.org>; Tue, 31 May 2016 12:44:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 58D6615D62C
	for <netfilter-devel@vger.kernel.org>; Tue, 31 May 2016 12:44:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2AE4215D644
	for <netfilter-devel@vger.kernel.org>; Tue, 31 May 2016 12:44:52 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160531103707.20058-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 31, 2016 at 12:37:06PM +0200, Pablo M. Bermudo Garay wrote:
> This commit adds a new command that lists maps:
> 
>   # nft list maps [family]
> 
> Only the declaration is displayed. If no family is specified, all maps
> of all families are listed.
> 
> Example:
> 
>   # nft list maps
> 
>   table ip filter {
>           map test {
>                   type ipv4_addr : inet_service
>           }
>   }
>   table ip6 filter {
>           map test {
>                   type ipv6_addr : inet_service
>           }
>   }

Applied, thanks.
