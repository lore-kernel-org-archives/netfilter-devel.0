From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH] nft-arp: wrong condition in parse_payload
Date: Fri, 7 Mar 2014 18:33:22 +0100
Message-ID: <20140307173322.GB28555@localhost>
References: <1394202070-6510-1-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57039 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbaCGRd1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 12:33:27 -0500
Content-Disposition: inline
In-Reply-To: <1394202070-6510-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 07, 2014 at 03:21:10PM +0100, Giuseppe Longo wrote:
> the current condition doesn't permit to parse ip addresses
> when they should be.
> Obviously they are not printed.
> 
> arptables-compat -A INPUT -s 1.1.1.1 -i eth0 -j ACCEPT
> arptables-compat -L
> 
> Chain INPUT (policy ACCEPT)
> target     prot opt source               destination
> -j ACCEPT -i eth0

Also applied, good that you're giving testing to this to catch bugs.
Thanks.
