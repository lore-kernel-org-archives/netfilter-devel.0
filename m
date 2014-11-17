From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables in network name spaces breaks networking
Date: Mon, 17 Nov 2014 20:37:11 +0100
Message-ID: <20141117193711.GA5544@salvia>
References: <2819252.KHfeL7dgec@grover>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ed Tomlinson <edt@aei.ca>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45920 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbaKQTfO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Nov 2014 14:35:14 -0500
Content-Disposition: inline
In-Reply-To: <2819252.KHfeL7dgec@grover>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 29, 2014 at 08:00:26AM -0400, Ed Tomlinson wrote:
> Hi
> 
> Using 3.17.1 and setting up firewalls with nftables breaks networking when nft -f <somefile> is run in an systemd-nspawn instance.  
> 
> Please take a look at: https://bugs.freedesktop.org/show_bug.cgi?id=85464 

I'm unable to reproduce this here, I have tested ip netns with several
generic configurations per family.

Could you please provide the ruleset? If you believe this is a
nftables bug, we need that information to narrow it down.

Thank you.
