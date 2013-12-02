From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [PATCH 2/2] netfilter: nft: add queue module
Date: Mon, 02 Dec 2013 13:03:18 +0200
Message-ID: <529C68F6.70002@linux.intel.com>
References: <1385808722.4321.19.camel@ice-age2.regit.org>	 <1385808978-19833-1-git-send-email-eric@regit.org>	 <1385808978-19833-2-git-send-email-eric@regit.org>	 <529C2B33.9020205@linux.intel.com> <1385976728.19102.7.camel@ice-age2.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:5515 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198Ab3LBLD3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Dec 2013 06:03:29 -0500
In-Reply-To: <1385976728.19102.7.camel@ice-age2.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric,

>> Why not declaring them in an enum, as for nft_rule_compat_flags,
>> >nft_set_flags or nft_set_elem_flags?
> Simple answer: It was not an enum in the original NFQUEUE code;)
>
> Real answer: We have only two values, third one is a mask. So it may be
> a bit overkill to use an enum here.

I understand, but this would be diverging from what has been the "rule" 
so far.
It's a minor detail I agree.

Btw, nft_set_elem_flags owns only one value ^^

Tomasz
