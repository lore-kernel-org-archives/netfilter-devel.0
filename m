From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables PATCH 3/3] nft: Print unknown target data
 only when relevant
Date: Wed, 7 Aug 2013 11:01:12 +0200
Message-ID: <20130807090112.GC6935@localhost>
References: <1375864297-9347-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1375864297-9347-4-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53887 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757216Ab3HGJBU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Aug 2013 05:01:20 -0400
Content-Disposition: inline
In-Reply-To: <1375864297-9347-4-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 07, 2013 at 11:31:37AM +0300, Tomasz Bursztyka wrote:
> Bug is:
> xtables -N test
> xtables -A FORWARD -j test
> xtables -L
> Chain INPUT (policy ACCEPT)
> target     prot opt source               destination
> 
> Chain FORWARD (policy ACCEPT)
> target     prot opt source               destination
> test       all  --  anywhere             anywhere            [0 bytes of unknown target data]
> 
> Chain OUTPUT (policy ACCEPT)
> target     prot opt source               destination
> 
> Chain test (1 references)
> target     prot opt source               destination
> 
> "[0 bytes of unknown target data]" should not be printed in this case.

Applied, thanks.
