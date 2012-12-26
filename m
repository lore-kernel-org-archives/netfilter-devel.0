From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnl-nft PATCH] Fix out of bounds buffer access in
 rtnl_netem_set_delay_distribution()
Date: Wed, 26 Dec 2012 23:11:27 +0100
Message-ID: <20121226221127.GA31047@1984>
References: <50D9B4FF.9000806@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60461 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085Ab2LZWLd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Dec 2012 17:11:33 -0500
Content-Disposition: inline
In-Reply-To: <50D9B4FF.9000806@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Thomas!

On Tue, Dec 25, 2012 at 03:15:27PM +0100, Thomas Jarosch wrote:
> sizeof(test_path) returns the array size
> and not the number of array elements.
> 
> Detected by cppcheck
> 
> Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
> ---
>  lib/route/sch/netem.c | 7 ++++---

These two fixes you sent belong to non-netfilter libnl subsystems. You
should better go to libnl mailing and post them there.
