From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables PATCH] fix nft -i command crashes when try to input
 multi line command
Date: Tue, 10 Jun 2014 12:55:52 +0200
Message-ID: <20140610105552.GA9228@localhost>
References: <CAHSpA5_tm8PJKSCYwo4RObrzm25tGNX+j_7=K8ySB5+NdK0N9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Guruswamy B <guru2018@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54802 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbaFJKz5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jun 2014 06:55:57 -0400
Content-Disposition: inline
In-Reply-To: <CAHSpA5_tm8PJKSCYwo4RObrzm25tGNX+j_7=K8ySB5+NdK0N9g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jun 08, 2014 at 12:44:16AM +0530, Guruswamy B wrote:
> Hello,
>  When try to input multiline command in "nft -i", it crashes.
> 
>  Issue is, function "cli_append_multiline" return null in case of
> multiline command,
>  But in the calling function "cli_complete", cli_exit is getting
> called, which in turn calls "rl_callback_handler_remove"  and the
> handler is getting removed.

Could you include an example on how to reproduce the crash that I can
append to this patch description?

Thanks.
