From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH next] libnetfilter_conntrack: don't ignore ATTR_CONNLABELS
Date: Thu, 16 May 2013 12:47:00 +0200
Message-ID: <20130516104700.GA3984@localhost>
References: <a17383ac-860c-4a6f-baf1-a382ce895a5c@DE-WIE-EXCH3A.green.sophos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Afschin Hormozdiary <Afschin.Hormozdiary@sophos.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38949 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763Ab3EPKrG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 May 2013 06:47:06 -0400
Content-Disposition: inline
In-Reply-To: <a17383ac-860c-4a6f-baf1-a382ce895a5c@DE-WIE-EXCH3A.green.sophos>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 16, 2013 at 11:30:43AM +0200, Afschin Hormozdiary wrote:
> The libnfnetlink based backend 'build.c' currently ignores
> ATTR_CONNLABELS and ATTR_CONNLABELS_MASK.
> 
> The libmnl based backend 'build_mnl.c' instead handles
> both attributes correct.
> 
> Add function to set CTA_LABELS and CTA_LABELS_MASK
> if required.

I'm fine with this change, but you also need to modify the parsing
function not to leave connlabel support for the libnfnetlink-based API
incomplete.
