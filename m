From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: iptables-nftables mnl_nft_batch_talk:: Invalid argument
Date: Wed, 9 Oct 2013 11:04:15 +0200
Message-ID: <20131009090415.GA3766@localhost>
References: <CAEyr1FTqVgbM3zK-UAL0fHU4MRkYvf-xzNb7Cp7FQT3NQiMgXQ@mail.gmail.com>
 <5254E322.10308@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Anand Raj Manickam <anandrm@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52698 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757044Ab3JIJET (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Oct 2013 05:04:19 -0400
Content-Disposition: inline
In-Reply-To: <5254E322.10308@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 09, 2013 at 08:01:22AM +0300, Tomasz Bursztyka wrote:
> Hi Anand,
> 
> You can increase the debug output via iptables/nft-shared.h: just
> change #if 0 to #if 1.

I think Anand is not running latest git HEAD kernel.
