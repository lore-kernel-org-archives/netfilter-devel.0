From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3/3] netfilter: ipset: timeout fixing bug broke SET
 target special timeout value
Date: Mon, 15 Oct 2012 16:22:25 -0700
Message-ID: <20121015232225.GB2118@kroah.com>
References: <1349950658-12548-1-git-send-email-pablo@netfilter.org>
 <1349950658-12548-4-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47615 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab2JOXW3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Oct 2012 19:22:29 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so5394230pbb.19
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Oct 2012 16:22:29 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1349950658-12548-4-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 11, 2012 at 12:17:38PM +0200, pablo@netfilter.org wrote:
> From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> 
> The patch "127f559 netfilter: ipset: fix timeout value overflow bug"
> broke the SET target when no timeout was specified.
> 
> Reported-by: Jean-Philippe Menil <jean-philippe.menil@univ-nantes.fr>
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> 
> This patch requires:
> 
> commit 127f559127f5175e4bec3dab725a34845d956591
> Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> Date:   Mon May 7 02:35:44 2012 +0000
> 
>     netfilter: ipset: fix timeout value overflow bug
>     
>     Large timeout parameters could result wrong timeout values due to
>     an overflow at msec to jiffies conversion (reported by Andreas Herz)

This patch doesn't apply to the 3.0.y series, care to provide a
backport, and a backported version of the original patch above that
needs it?

thanks,

greg k-h
