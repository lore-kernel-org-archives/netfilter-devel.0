From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] net/netfilter/x_tables.c: use __seq_open_private()
Date: Tue, 23 Sep 2014 16:02:37 +0200
Message-ID: <20140923140237.GA27307@salvia>
References: <1411122471-20087-1-git-send-email-rob.jones@codethink.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, linux-kernel@codethink.co.uk
To: Rob Jones <rob.jones@codethink.co.uk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50073 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709AbaIWOBg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:01:36 -0400
Content-Disposition: inline
In-Reply-To: <1411122471-20087-1-git-send-email-rob.jones@codethink.co.uk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 19, 2014 at 11:27:51AM +0100, Rob Jones wrote:
> Reduce boilerplate code by using __seq_open_private() instead of seq_open()
> in xt_match_open() and xt_target_open().
> 
> Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
> ---
> 
> This patch uses an existing variant of seq_open() to reduce the kernel code
> size.

Less code to maintain, good.

> The only significant variation from the pre-existing code is the fact that
> __seq_open_private() calls kzalloc() rather than kmalloc(), which could
> conceivably have an impact on timing.

I think you can skip

        trav->class = MTTG_TRAV_INIT;

too, now that trav is set to zero.

