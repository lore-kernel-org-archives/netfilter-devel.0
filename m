From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [iptables-nftables PATCH 0/3] NFPROTO_ARP and arp mangle target
 support (+ one minor fix)
Date: Thu, 03 Oct 2013 12:31:00 +0300
Message-ID: <524D3954.8030104@linux.intel.com>
References: <1378453910-17954-1-git-send-email-tomasz.bursztyka@linux.intel.com> <524D2A2B.1010507@linux.intel.com> <20131003092359.GA14246@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:2328 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710Ab3JCJbD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Oct 2013 05:31:03 -0400
In-Reply-To: <20131003092359.GA14246@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,
> Please, rename it to libxt_mangle.c and restrict its usage to the
> NFPROTO_ARP family. With this change, I think we can skip patch 2, I'm
> reticent to bloat our build system to support libarp_ prefix, it's
> just one single extension after all.
>
> Let me know if you have any issue, thanks.

Ok, should work.
Then I have to fix xtables-arp-standalone.c so it does not try to look 
for any libarp_ prefix right?

Tomasz
