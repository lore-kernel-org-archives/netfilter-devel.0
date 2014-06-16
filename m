From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: Re: [RFC PATCH 1/1 libnetfilter_conntrack] zero value handling of
 mark and zone
Date: Mon, 16 Jun 2014 22:20:53 +0900
Message-ID: <20140616131931.GA29940@gmail.com>
References: <20140616114154.GI1982@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:52104 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbaFPNVA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:21:00 -0400
Received: by mail-pb0-f45.google.com with SMTP id rr13so1924753pbb.32
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jun 2014 06:21:00 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140616114154.GI1982@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sorry for lack of explanation.

On Mon, Jun 16, 2014 at 01:41:54PM +0200, Florian Westphal wrote:
> So, if only ct2 has attr:
> nfct_get_attr_u16(ct1, ATTR_ZONE) -> returns 0
> nfct_get_attr_u16(ct2, ATTR_ZONE) -> returns the zone id
> 
> ct1 and ct2 would be equal if ct2 zone is 0.

And nfct_cmp(ct1, ct2, NFCT_CMP_MASK) is expected to return
true if ct2 zone is not 0.
