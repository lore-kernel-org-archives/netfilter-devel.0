From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: synproxy: only register hooks when
 needed
Date: Wed, 19 Apr 2017 18:13:12 +0200
Message-ID: <20170419161312.GB17294@breakpoint.cc>
References: <20170419161404.18346-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:43084 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965665AbdDSQOe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Apr 2017 12:14:34 -0400
Content-Disposition: inline
In-Reply-To: <20170419161404.18346-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> Defer registration of the synproxy hooks until the first SYNPROXY rule is
> added.  Also means we only register hooks in namespaces that need it.

On a related note: should I bother with CLUSTERIP or can be remove it?
