From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2] rule: delete extra space in sets printing
Date: Thu, 3 Mar 2016 19:59:45 +0100
Message-ID: <20160303185945.GA4107@salvia>
References: <145270561444.23138.11119007913809214107.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44320 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758527AbcCCS7z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Mar 2016 13:59:55 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id DA59D73E4
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Mar 2016 19:59:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C7097DA395
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Mar 2016 19:59:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 58DF9DA39B
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Mar 2016 19:59:44 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <145270561444.23138.11119007913809214107.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 13, 2016 at 06:21:41PM +0100, Arturo Borrero Gonzalez wrote:
> The extra space is printed when sets are printed in tabulated format.
> 
> table inet test {
> 	set test {
> 		  ^
> 		type ipv4_addr
> 	}
> }
> 
> However, the space is still required in printing in plain format (ie, monitor).

Arturo, I going back in my queue of pending things (I left some stuff
behind because of NetDev 1.1).

So I'm now pushing this into the repo. Thanks for your patience.
