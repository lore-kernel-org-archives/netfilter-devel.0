From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: nf_tables_trace: fix endiness when dump
 chain policy
Date: Fri, 2 Sep 2016 15:00:18 +0200
Message-ID: <20160902130018.GC506@breakpoint.cc>
References: <1472820552-7803-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:50282 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751074AbcIBNUw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Sep 2016 09:20:52 -0400
Content-Disposition: inline
In-Reply-To: <1472820552-7803-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@163.com> wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> NFTA_TRACE_POLICY attribute is big endian, but we forget to call
> htonl to convert it. Fortunately, this attribute is parsed as big
> endian in libnftnl.

It is however handled as u16, not u32.  Care to send a patch for this as
well?  Thanks!
