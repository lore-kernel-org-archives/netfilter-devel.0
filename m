From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] Removed duplicated code in netlink.c
Date: Tue, 10 Jun 2014 17:02:48 +0200
Message-ID: <20140610150248.GA13025@localhost>
References: <1402412087-9825-1-git-send-email-hendrik@os-t.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Hendrik Schwartke <hendrik@os-t.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36576 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbaFJPCx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:02:53 -0400
Content-Disposition: inline
In-Reply-To: <1402412087-9825-1-git-send-email-hendrik@os-t.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 10, 2014 at 04:54:46PM +0200, Hendrik Schwartke wrote:
> -	return err;
> +        struct nft_chain *nlc;
   ^^^^^^^^

Please, fix coding style and resend. This needs to follow Linux kernel
8-chars tab indent. Thanks.
