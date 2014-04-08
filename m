From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [RFC 2/3] netfilter: nf_tables: Add meta expression key for bridge
 interface name
Date: Tue, 08 Apr 2014 11:20:35 +0300
Message-ID: <5343B153.30804@linux.intel.com>
References: <1395911972-17259-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1395911972-17259-3-git-send-email-tomasz.bursztyka@linux.intel.com> <20140408080642.GA3904@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20022 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756389AbaDHIVT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2014 04:21:19 -0400
In-Reply-To: <20140408080642.GA3904@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

> Please, also rework this so we have one _init function for the get and
> the set variants, ie. nft_meta_bridge_get_init and
> nft_meta_bridge_set_init, I'd suggest.
>
> Apart from that, this patch looks fine to me. Thanks.

I fully changed that on the version 2. This RFC is no longer valid, prior to
Patrick's comments and also his changes on nft_meta.c

Tomasz
