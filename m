From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] build: have `make clean` remove dep files too
Date: Mon, 10 Sep 2012 15:44:13 +0200
Message-ID: <20120910134413.GA23537@1984>
References: <1347272891-3015-1-git-send-email-pablo@netfilter.org>
 <1347282605-20781-1-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40405 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033Ab2IJNo3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Sep 2012 09:44:29 -0400
Content-Disposition: inline
In-Reply-To: <1347282605-20781-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 10, 2012 at 03:10:05PM +0200, Jan Engelhardt wrote:
> While changing branches, one can hit errors like:
> 
> make[2]: ***   CC       libipt_CLUSTERIP.oo
> No hay ninguna regla para construir el objetivo
> `../include/net/netfilter/nf_nat.h', necesario para
> `libipt_DNAT.oo'. Alto.
> 
> Pablo thinks dep files should be removed on `make clean`, and I
> concur. (JFI, Note that native automake would not clear its ".deps"
> directory.) Keep the "distclean: clean" line to keep invocations by
> automake from the parent directory working.

As soon as I get it fixed for me is fine, I have applied this patch.
