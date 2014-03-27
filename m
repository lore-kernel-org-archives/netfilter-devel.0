From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [RFC 3/3] netfilter: nftables: Return preferably given family
 expression if any
Date: Thu, 27 Mar 2014 13:00:15 +0200
Message-ID: <533404BF.8060006@linux.intel.com>
References: <1395911972-17259-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1395911972-17259-4-git-send-email-tomasz.bursztyka@linux.intel.com> <20140327092638.GA3884@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43795 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755359AbaC0LAX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Mar 2014 07:00:23 -0400
In-Reply-To: <20140327092638.GA3884@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>> Currently, when looking up for the proper expression type, what comes
>> >first is returned. Which might end up to be a non-family tight type.
>> >Instead, if a specific family type exist, it will be better to return
>> >this one.
> Easier suggestion:
>
> Change nft_register_expr() to appent NFPROTO_UNSPEC to the end of the
> list and prepend all others.

Obvious one which I missed, as usual.

Thanks Patrick

Tomasz
