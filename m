From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/2] src: add support for display maps content
Date: Tue, 31 May 2016 12:45:00 +0200
Message-ID: <20160531104500.GB4491@salvia>
References: <20160531103707.20058-1-pablombg@gmail.com>
 <20160531103707.20058-2-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48076 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963AbcEaKpJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 May 2016 06:45:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A3D64EAA63
	for <netfilter-devel@vger.kernel.org>; Tue, 31 May 2016 12:45:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9373415D64E
	for <netfilter-devel@vger.kernel.org>; Tue, 31 May 2016 12:45:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 91A7415D651
	for <netfilter-devel@vger.kernel.org>; Tue, 31 May 2016 12:45:05 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160531103707.20058-2-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 31, 2016 at 12:37:07PM +0200, Pablo M. Bermudo Garay wrote:
> This commit adds a new command that displays the definition of a single
> map:
> 
>   # nft list map [family] <table> <map>
> 
> If no family is specified, ip is assumed.
> 
> Example:
> 
>   # nft list map ip6 filter test
> 
>   table ip6 filter {
>           map test {
>                   type ipv6_addr : inet_service
>                   elements = { 2001:db8::ff00:42:8329 : http}
>           }
>   }

Also applied, thanks.
