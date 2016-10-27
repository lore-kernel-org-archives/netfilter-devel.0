From: Florian Westphal <fw@strlen.de>
Subject: Re: [conntrack-tools PATCH] sync-mode: print errno message on failure
Date: Thu, 27 Oct 2016 16:45:22 +0200
Message-ID: <20161027144522.GB23011@breakpoint.cc>
References: <147756361728.15386.11786527603548778870.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60288 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755926AbcJ0Oqw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Oct 2016 10:46:52 -0400
Content-Disposition: inline
In-Reply-To: <147756361728.15386.11786527603548778870.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Arturo Borrero Gonzalez <arturo@debian.org> wrote:
> I have observed this message several times:
> 
>  [ERROR] can't open channel socket
>  [ERROR] initialization failed
> 
> which is very difficult to understand.
> 
> The errno message should help this to be a bit more explicit.
> With this patch, in the case of wrong interface:
> 
>  [ERROR] can't open channel socket: No such device

Indeed, much better.

Applied, thanks Arturo.
