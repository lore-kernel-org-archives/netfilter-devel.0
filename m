From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] Correct description of -n/--numeric option
Date: Sat, 29 Oct 2016 20:47:17 +0200
Message-ID: <20161029184717.GD30951@breakpoint.cc>
References: <1477714691-8043-1-git-send-email-jon@endpoint.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: Jon Jensen <jon@endpoint.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:39916 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750806AbcJ2Ssx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Oct 2016 14:48:53 -0400
Content-Disposition: inline
In-Reply-To: <1477714691-8043-1-git-send-email-jon@endpoint.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jon Jensen <jon@endpoint.com> wrote:
> "When used twice" was used twice in the manpage. :)
> 
> And as Florian Westphal <fw@strlen.de> pointed out, it was also incorrect
> for the -nn case.
> 
> Update the manpage and built-in help in main.c to match actual behavior.

Applied, thanks.
