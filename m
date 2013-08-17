From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nftables: validate port number in inet_service_type_parse
Date: Sat, 17 Aug 2013 12:29:24 +0200
Message-ID: <20130817102924.GA7026@localhost>
References: <20130815171911.GA15645@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42789 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702Ab3HQK3b (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Aug 2013 06:29:31 -0400
Content-Disposition: inline
In-Reply-To: <20130815171911.GA15645@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 15, 2013 at 10:19:11AM -0700, Phil Oester wrote:
> At present, nft accepts out of range port values such as in this example:
> 
>     nft add rule ip filter input tcp dport 123456 accept 
> 
> Attached patch adds checks for both integer overflow and 16 bit overflow,
> and avoids getaddrinfo call in the (common) case of digit input. Example
> above now produces this output:
> 
>     <cmdline>:1:36-41: Error: Service out of range
>     add rule ip filter input tcp dport 123456 accept
>                                        ^^^^^^

Applied, thanks Phil.
