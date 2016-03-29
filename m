From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 1/3] src/rule.c: don't print trailing statement
 whitespace
Date: Tue, 29 Mar 2016 13:17:31 +0200
Message-ID: <20160329111731.GB13065@salvia>
References: <145873749309.10004.11477358360509958985.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41049 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbcC2LRw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Mar 2016 07:17:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9FE8D83D31
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2016 13:17:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1C79BDA3A0
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2016 13:17:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 721BADA3A3
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2016 13:17:37 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <145873749309.10004.11477358360509958985.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 23, 2016 at 01:51:33PM +0100, Arturo Borrero Gonzalez wrote:
> This trailing whitespace is annoying when working with the textual output
> of nft.
> 
> Before:
> 
> table t {
> 	chain c {
> 		ct state new
> 			    ^
> 	}
> }
> 
> 
> After:
> 
> table t {
> 	chain c {
> 		ct state new
> 	}
> }

Applied, thanks.
