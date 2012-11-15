From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [nf-next:nf_tables-experiments PATCH 3/4] nf_tables: Add support
 for IPv6 NAT expression
Date: Thu, 15 Nov 2012 14:44:27 +0200
Message-ID: <50A4E3AB.3080703@linux.intel.com>
References: <1352970952-3447-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1352970952-3447-4-git-send-email-tomasz.bursztyka@linux.intel.com> <20121115122908.GB2271@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:31172 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993283Ab2KOMoa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 07:44:30 -0500
In-Reply-To: <20121115122908.GB2271@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

>>   #include <linux/netfilter_ipv4.h>
>> >@@ -26,8 +27,10 @@
>> >  #include <net/ip.h>
>> >  
>> >  struct nft_nat {
>> >-	enum nft_registers      sreg_addr_min:8;
>> >-	enum nft_registers      sreg_addr_max:8;
>> >+	enum nft_registers      sreg_addr_min_v4:8;
>> >+	enum nft_registers      sreg_addr_max_v4:8;
>> >+	enum nft_registers      sreg_addr_min_v6:8;
>> >+	enum nft_registers      sreg_addr_max_v6:8;
> Suggestion: Couldn't we get this patch a bit smaller by adding int
> family and the NFTA_NAT_FAMILY attribute?

Why not, at least semantically it could look better indeed, though from 
struct size point of view it won't change anything.
The logic for parsing NFTA would be easier too.

Let's do this.

Tomasz
