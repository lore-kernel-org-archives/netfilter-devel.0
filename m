From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/5] new testsuite for nft
Date: Fri, 18 Dec 2015 14:08:52 +0100
Message-ID: <20151218130852.GA3801@salvia>
References: <144982857800.31246.3547570276555930070.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39642 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697AbbLRNJA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Dec 2015 08:09:00 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1A4A313A366
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2015 14:08:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E8941DA80D
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2015 14:08:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 05EC0DA860
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2015 14:08:53 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <144982857800.31246.3547570276555930070.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 11, 2015 at 11:10:08AM +0100, Arturo Borrero Gonzalez wrote:
> he following series implements a new testsuite for nft.
> 
> It's almost similar to what I sent a couple of month ago, but updated
> with comments by Pablo and other small fixes.

Patches 2/5, 3/5 and 5/5 applied, thanks Arturo!

BTW, it would be good to enhance this to run every test after full
removal of existing nf_tables modules. Thus, we can exercise the
abort() path (this will trigger lots of abort() calls due to module
autoloading).

I have something like 10 more scripts here that I need to adapt to
make it fit into this new infrastructure, they are basically testing
the nft -f path.
