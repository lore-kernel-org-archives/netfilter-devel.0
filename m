From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nf_conntrack: fix skb_header_pointer API
 usages in DCCP
Date: Mon, 6 Jan 2014 14:14:32 +0100
Message-ID: <20140106131432.GA8362@localhost>
References: <1388966274-9532-1-git-send-email-dborkman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Daniel Borkmann <dborkman@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57522 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376AbaAFNOg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 08:14:36 -0500
Content-Disposition: inline
In-Reply-To: <1388966274-9532-1-git-send-email-dborkman@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 06, 2014 at 12:57:54AM +0100, Daniel Borkmann wrote:
> Some occurences in the netfilter tree use skb_header_pointer() in
> the following way ...
> 
>   struct dccp_hdr _dh, *dh;
>   ...
>   skb_header_pointer(skb, dataoff, sizeof(_dh), &dh);

I see, we're not crashing because *dh is 4 bytes at worst case, which
matches with the size of the dccp_hdr header.

Applied, thanks.
