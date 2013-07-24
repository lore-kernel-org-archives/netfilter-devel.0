From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [xtables-arptables PATCH v2 3/5] nft: nft_xtables_config_load()
 called only in nft_init()
Date: Wed, 24 Jul 2013 14:14:37 +0300
Message-ID: <51EFB71D.6020403@linux.intel.com>
References: <20130723161017.10040.6256.stgit@localhost> <20130723161244.10040.57825.stgit@localhost> <20130724085649.GC16434@localhost> <51EFA01B.30907@linux.intel.com> <20130724105638.GA17248@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Giuseppe Longo <giuseppelng@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:20621 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab3GXLOk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Jul 2013 07:14:40 -0400
In-Reply-To: <20130724105638.GA17248@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Indeed h->tables is always not NULL, so this test should be removed.

> Please, resolve all open issue and get back to me with a patch for
> this if you think the time is worth to discuss this small
> refactorization.

Getting xtables-arptables bootstrapped is an open issue.
And while doing some necessary refactoring (like making some functions 
public), such cleanups are also quite handy.
I don't see the point to spread unclear code in a new place and cleaning 
it up afterwards when it can be done just right now. It's would be more 
time consuming.

Please, consider these patches - after being reworked because they 
obviously need it yes - to be included.

Cheers,

Tomasz
