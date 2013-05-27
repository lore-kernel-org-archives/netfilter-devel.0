From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] data_reg: fix XML operations
Date: Mon, 27 May 2013 20:59:58 +0200
Message-ID: <20130527185958.GA27839@localhost>
References: <20130527171654.4585.61260.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51968 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073Ab3E0TAF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 May 2013 15:00:05 -0400
Content-Disposition: inline
In-Reply-To: <20130527171654.4585.61260.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Arturo,

On Mon, May 27, 2013 at 07:16:54PM +0200, Arturo Borrero wrote:
> Several fixes:
> 
>  * Conditional XML code for snprintf_xml.
>  I don't think that not having XML support breaks XML printing.
> 
>  * Add generic interface for parsing: nft_data_reg_parse().
>  Simply missing in previous patches.
> 
>  * Fix conditional code in XML parsing functions.
>  All the XML parsing chunk was conditional but the main function. I think is better to
>  do the conditional compilation by function, returning -1 and setting errno = EOPNOTSUPP.
> 
>  * Delete trailing space in snprintf_xml " >"

I cannot take a patch with four fixes. You have to split them, one for
each. Sorry.
