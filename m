From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] datatype: avoid crash in debug mode when printing
 integers
Date: Tue, 30 Jun 2015 02:07:57 +0200
Message-ID: <20150630000757.GA6876@salvia>
References: <1435308644-15892-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38536 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611AbbF3AC2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Jun 2015 20:02:28 -0400
Content-Disposition: inline
In-Reply-To: <1435308644-15892-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 26, 2015 at 10:50:44AM +0200, Florian Westphal wrote:
> nft -i --debug=all
> nft> add rule ip filter foo mark 42
> 
> dies with sigfpe; seems mpz doesn't like len 0:
> #1  0x0805f2ee in mpz_export_data (data=0xbfeda588, op=0x9d9fb08, byteorder=BYTEORDER_HOST_ENDIAN, len=0) at gmputil.c:115
> 
> After patch this prints 0x0000002a.

I have pushed this to nft. Thanks.

