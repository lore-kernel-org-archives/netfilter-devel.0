From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [nft PATCH] src: check if the set name is too long
Date: Tue, 25 Mar 2014 09:37:24 +0200
Message-ID: <53313234.6050602@linux.intel.com>
References: <1395423541-5098-1-git-send-email-giuseppelng@gmail.com> <20140324145738.GB32472@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:16177 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbaCYHh1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2014 03:37:27 -0400
In-Reply-To: <20140324145738.GB32472@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

> I sent you a patch, I think it's better if we fix this from
> kernel-space.

I think it's also good if we check the length when parsing, as Giuseppe did.
Then it reduce the overhead: the error is detected way before we process 
anything through netlink.

Of course here it should be IFNAMSIZ-1.
Giuseppe: could you resubmit your patch fixed ?

About the parsing error on unexpected '}' I believe it's another issue
the patch revealed somehow. (state->msgs issue?).

Tomasz
