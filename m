From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH] ebtables-compat: fix misplaced function
 attribute on ebt_print_error()
Date: Wed, 8 Apr 2015 19:03:54 +0200
Message-ID: <20150408170354.GA25269@salvia>
References: <20150406140528.30059.48340.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48204 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932319AbbDHQ7r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Apr 2015 12:59:47 -0400
Content-Disposition: inline
In-Reply-To: <20150406140528.30059.48340.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 06, 2015 at 04:05:28PM +0200, Arturo Borrero Gonzalez wrote:
> From: Arturo Borrero Gonzalez <aborrero@nfdev2.cica.es>
> 
> xtables-eb.c:305:1: warning: empty declaration
>  } __attribute__((noreturn, format(printf,2,3)));
>  ^
> xtables-eb.c:311:2: warning: initialization makes '__attribute__((noreturn))' qualified function pointer from unqualified
>   .exit_err  = ebt_print_error,
>   ^

Applied, thanks Arturo.
