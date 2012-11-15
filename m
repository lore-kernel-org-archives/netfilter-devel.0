From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [nf-next:nf_tables-experiments PATCH 2/4] nf_tables: Split IPv4
 NAT into NAT expression and NAT IPv4 chain
Date: Thu, 15 Nov 2012 14:38:53 +0200
Message-ID: <50A4E25D.7010101@linux.intel.com>
References: <1352970952-3447-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1352970952-3447-3-git-send-email-tomasz.bursztyka@linux.intel.com> <20121115122645.GA2271@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:6574 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993283Ab2KOMiz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 07:38:55 -0500
In-Reply-To: <20121115122645.GA2271@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

>>   {
>> >  	int err;
>> >  
>> >+#ifdef CONFIG_MODULES
>> >+	request_module("nft_nat");
>> >+#endif
> I think this expression is automagically via nft_expr_type_get. The
> MODULE_ALIAS_NFT_EXPR macro already helps to achieve that. So I think
> we can remove that request_module call.
>
> No need to resend this patchset in case you confirm this comment is
> correct, I can delete those lines myself.

Sure, go ahead.

Tomasz
