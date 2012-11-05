From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [PATCH 2/2] netfilter: nf_tables: improve deletion performance
Date: Mon, 05 Nov 2012 12:16:34 +0200
Message-ID: <50979202.7030108@linux.intel.com>
References: <1351785744-7492-1-git-send-email-pablo@netfilter.org> <1351785744-7492-3-git-send-email-pablo@netfilter.org> <50938CDC.4000902@linux.intel.com> <20121104184420.GA22844@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:20716 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642Ab2KEKQg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:16:36 -0500
In-Reply-To: <20121104184420.GA22844@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

>> Shouldn't it free the expression list at the same moment when the
>> rule will actually be freed?
>> So call_rcu() instead of kfree_rcu().
> You're right. New patch attached using the call_rcu approach.

The patch looks fine now. Removing the nft_ctx does not harm actually, 
it was providing
superfluous flexibility in this destroying case.

Tomasz
