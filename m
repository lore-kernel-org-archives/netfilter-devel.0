From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] doc: nft.8 aim for consistent synopses throughout
Date: Sun, 3 Dec 2017 22:59:53 +0100
Message-ID: <20171203215953.GA28667@breakpoint.cc>
References: <20171202110443.11770-1-duncan_roe@optusnet.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Duncan Roe <duncan_roe@optusnet.com.au>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:48128 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752434AbdLCWBM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Dec 2017 17:01:12 -0500
Content-Disposition: inline
In-Reply-To: <20171202110443.11770-1-duncan_roe@optusnet.com.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Duncan Roe <duncan_roe@optusnet.com.au> wrote:
> Single items in braces have the braces removed as per wiki Scripting:
> "It is simply overkill to define a set that only stores one single element".
> Items that were in braces or square brackets are made consistent, e.g. {family}
> expands to single wor Ip, inet &c., but (type) in set spec expands to
> "type type_name ;".

Looks good, applied, thank you.
