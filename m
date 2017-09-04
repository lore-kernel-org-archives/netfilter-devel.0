From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2 1/2] src: add flags fo nft_ctx_new
Date: Mon, 4 Sep 2017 22:43:15 +0200
Message-ID: <20170904204315.GA14434@salvia>
References: <20170903223441.GB12383@salvia>
 <20170904075558.10129-1-eric@regit.org>
 <20170904075558.10129-2-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:49995 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754067AbdIDUnn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Sep 2017 16:43:43 -0400
Content-Disposition: inline
In-Reply-To: <20170904075558.10129-2-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 04, 2017 at 09:55:57AM +0200, Eric Leblond wrote:
> By adding flags to nft_ctx_new, we will have a minimum capabilities
> of changing the way the nft_ctx is created.
> 
> For now, this patch uses a simple value that allow the user to specify
> that he will handle netlink by himself.

Applied, thanks Eric.
