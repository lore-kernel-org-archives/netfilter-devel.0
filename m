From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH 2/2] ebtables-compat: fix rule deleting with -D
 in rules with no target
Date: Fri, 13 Mar 2015 12:16:01 +0100
Message-ID: <20150313111601.GC8730@salvia>
References: <20150311175457.30898.35962.stgit@nfdev.cica.es>
 <20150311175502.30898.36762.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34174 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946AbbCMLML (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Mar 2015 07:12:11 -0400
Content-Disposition: inline
In-Reply-To: <20150311175502.30898.36762.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 11, 2015 at 06:55:03PM +0100, Arturo Borrero Gonzalez wrote:
> Before this patch, rule deleting with -D produces segfault in rules
> with no target.

Applied, thanks.
