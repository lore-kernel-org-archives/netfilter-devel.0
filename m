From: Eric Leblond <eric@regit.org>
Subject: Re: [PATH nft v2 05/18] libnftables: add nft_run_command_from_buffer
Date: Fri, 25 Aug 2017 13:26:06 +0200
Message-ID: <1503660366.31357.18.camel@regit.org>
References: <20170819152420.22563-1-eric@regit.org>
         <20170819152420.22563-6-eric@regit.org> <20170824154924.GA24860@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:41826 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932093AbdHYL0I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Aug 2017 07:26:08 -0400
In-Reply-To: <20170824154924.GA24860@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Thu, 2017-08-24 at 17:49 +0200, Pablo Neira Ayuso wrote:
> Attaching a revamped version, it is collapsing your patch 5 and 6.
> 
> We still have to agree on what to do with the netlink socket. I know
> you don't want to open it from the client side.
> 
> The only way I find to do this is to - yick - add a flag to
> nft_ctx_new().

Agree with the flag idea. This will add a minimum flexibility to the
structure creation.

Regarding the patch, I'm good with it.

Acked-by: Eric Leblond <eric@regit.org>

++
-- 
Eric Leblond <eric@regit.org>
