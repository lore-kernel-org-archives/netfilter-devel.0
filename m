From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: remove dead code
Date: Mon, 5 Oct 2015 17:32:36 +0200
Message-ID: <20151005153236.GA22738@salvia>
References: <1443619430-5302-1-git-send-email-fbl@sysclose.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Flavio Leitner <fbl@sysclose.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55954 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbbJEPZh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Oct 2015 11:25:37 -0400
Content-Disposition: inline
In-Reply-To: <1443619430-5302-1-git-send-email-fbl@sysclose.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 30, 2015 at 10:23:50AM -0300, Flavio Leitner wrote:
> Remove __nf_conntrack_find() from headers.
> Fixes: dcd93ed4cd1 ("netfilter: nf_conntrack: remove dead code"

Applied, thanks.

