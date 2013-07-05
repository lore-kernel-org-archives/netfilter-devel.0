From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] src: improving default text output
Date: Fri, 5 Jul 2013 13:30:35 +0200
Message-ID: <20130705113035.GA21146@localhost>
References: <20130705080628.2770.63222.stgit@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45686 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757135Ab3GELdd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jul 2013 07:33:33 -0400
Content-Disposition: inline
In-Reply-To: <20130705080628.2770.63222.stgit@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 05, 2013 at 10:06:28AM +0200, Giuseppe Longo wrote:
> With this patch, you can improve default plain text output.
> Warning fixed, and replaced %lu with %"PRIu64".

Applied, thanks Giuseppe.
