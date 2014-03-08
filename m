From: Florian Westphal <fw@strlen.de>
Subject: Re: [libnetfilter_conntrack PATCH] conntrack: introduce clear and
 equal functions for bitmask object
Date: Sat, 8 Mar 2014 10:25:23 +0100
Message-ID: <20140308092523.GG17526@breakpoint.cc>
References: <20140308010344.GA4415@gmail.com>
 <20140308012416.GJ4415@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:48019 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750925AbaCHJZZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Mar 2014 04:25:25 -0500
Content-Disposition: inline
In-Reply-To: <20140308012416.GJ4415@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ken-ichirou MATSUZAWA <chamaken@gmail.com> wrote:
>  This patch adds two functions, useful for ulogd IPFIX
> output module.

I am ok with this patch.  Once the ulogd patches have been
reviewed/accepted this can be applied to libnf-ct.

Will need lib versioning bump before next release of library.
