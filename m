From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nft-arp: fix is_same_interfaces arguments
Date: Fri, 7 Mar 2014 18:32:47 +0100
Message-ID: <20140307173247.GA28555@localhost>
References: <1394188993-4752-1-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56972 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbaCGRcw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 12:32:52 -0500
Content-Disposition: inline
In-Reply-To: <1394188993-4752-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 07, 2014 at 11:43:13AM +0100, Giuseppe Longo wrote:
> Wrong arguments are passed to is_same_interfaces
> that causes sometimes to delete a wrong rule.
> See the example below:
> 
> arptables-compat -A INPUT -i eth0 -j ACCEPT
> arptables-compat -A INPUT -i eth1 -j ACCEPT
> arptables-compat -A INPUT -i eth2 -j ACCEPT
> 
> arptables-compat -L
> Chain INPUT (policy ACCEPT)
> target     prot opt source               destination
> -j ACCEPT -i eth0
> -j ACCEPT -i eth1
> -j ACCEPT -i eth2
> 
> arptables-compat -D INPUT -i eth2 -j ACCEPT
> 
> arptables-compat -L
> Chain INPUT (policy ACCEPT)
> target     prot opt source               destination
> -j ACCEPT -i eth1
> -j ACCEPT -i eth2

Applied, thanks.
