From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_tables: fix update chain error
Date: Fri, 29 Sep 2017 13:34:20 +0200
Message-ID: <20170929113420.GA14459@salvia>
References: <20170923091044.2947-1-chenjingpiao@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: JingPiao Chen <chenjingpiao@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [213.95.27.120] ([213.95.27.120]:59590 "EHLO
        ganesha.gnumonks.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752092AbdI2Lfd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2017 07:35:33 -0400
Content-Disposition: inline
In-Reply-To: <20170923091044.2947-1-chenjingpiao@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Sep 23, 2017 at 05:10:44PM +0800, JingPiao Chen wrote:
>  # nft add table filter
>  # nft add chain filter c1
>  # nft rename chain filter c1 c2
> 
> Error: Could not process rule: No such file or directory
> rename chain filter c1 c2
> ^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
>  # nft add chain filter c2
>  # nft rename chain filter c1 c2
>  # nft list table filter
> 
> table ip filter {
> 	chain c2 {
> 	}
> 
> 	chain c2 {
> 	}
> }

Applied, thanks.
