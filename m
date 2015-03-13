From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH 1/2] ebtables-compat: add a bridge-specific
 exit_error function
Date: Fri, 13 Mar 2015 12:15:44 +0100
Message-ID: <20150313111544.GB8730@salvia>
References: <20150311175457.30898.35962.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34089 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbbCMLLy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Mar 2015 07:11:54 -0400
Content-Disposition: inline
In-Reply-To: <20150311175457.30898.35962.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 11, 2015 at 06:54:57PM +0100, Arturo Borrero Gonzalez wrote:
> Previous to this patch, error reporting in ebtables-compat was like:
> 
> % ebtables-compat xxx
> (null) v1.4.21: Bad argument : 'xxx'
> Try `(null) -h' or '(null) --help' for more information.
> 
> While the original ebtables was:
> 
> % ebtables xxx
> Bad argument : 'xxx'.
> 
> With this patch, we switch to:
> 
> % ebtables-compat xxx
> Bad argument : 'xxx'.

Also applied, thanks.
