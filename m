From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH libnftnl] trace: use get_u32 to parse NFPROTO and POLICY
 attribute
Date: Fri, 2 Sep 2016 15:03:09 +0200
Message-ID: <20160902130309.GD506@breakpoint.cc>
References: <1472820686-8157-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:50200 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753029AbcIBNDM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Sep 2016 09:03:12 -0400
Content-Disposition: inline
In-Reply-To: <1472820686-8157-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@163.com> wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> NFTA_TRACE_NFPROTO and NFTA_TRACE_POLICY attribute is 32-bit
> value, so we should use mnl_attr_get_u32 and htonl here.
 
Applied, thanks.
