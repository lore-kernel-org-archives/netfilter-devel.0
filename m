From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf_tables PATCH v3 1/2] netfilter: refactor NAT redirect IPv6
 code to use it from nf_tables
Date: Thu, 30 Oct 2014 17:28:35 +0100
Message-ID: <20141030162835.GB2224@salvia>
References: <20141017103632.7248.1023.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33599 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758636AbaJ3Q04 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Oct 2014 12:26:56 -0400
Content-Disposition: inline
In-Reply-To: <20141017103632.7248.1023.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 17, 2014 at 12:37:52PM +0200, Arturo Borrero Gonzalez wrote:
> This patch refactors the IPv6 code so it can be usable both from xt and
> nf_tables.

Applied to nf-next, thanks.
