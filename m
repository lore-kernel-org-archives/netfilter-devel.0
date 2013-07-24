From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [xtables-arptables PATCH v2 5/5] nft: replace args.family
Date: Wed, 24 Jul 2013 12:40:11 +0300
Message-ID: <51EFA0FB.60400@linux.intel.com>
References: <20130723161017.10040.6256.stgit@localhost> <20130723161316.10040.78293.stgit@localhost> <20130724085808.GD16434@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Giuseppe Longo <giuseppelng@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:7727 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255Ab3GXJkN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Jul 2013 05:40:13 -0400
In-Reply-To: <20130724085808.GD16434@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

>> >-	h->ops = nft_family_ops_lookup(args.family);
>> >+	h->ops = nft_family_ops_lookup(h->family);
> Due to lack of patch description, I don't know if you're trying to
> address a bug or this is just a simple cleanup.

It's clearly a bug fix here (using args.family forget about if user has 
used -6)  but indeed a one liner description does not harm :)


Tomasz

