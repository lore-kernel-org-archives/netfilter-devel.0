From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv2] conntrackd: make conntrackd namespace aware
Date: Tue, 18 Sep 2012 20:53:34 +0200
Message-ID: <20120918185334.GA32009@1984>
References: <1347331857-6577-1-git-send-email-aatteka@nicira.com>
 <20120918180802.GA28256@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ansis Atteka <aatteka@nicira.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47337 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116Ab2IRSxi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:53:38 -0400
Content-Disposition: inline
In-Reply-To: <20120918180802.GA28256@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 18, 2012 at 08:08:02PM +0200, Pablo Neira Ayuso wrote:
[...]
> > diff --git a/src/namespace.c b/src/namespace.c
> > new file mode 100644
> > index 0000000..3f64cb5
> > --- /dev/null
> > +++ b/src/namespace.c
[...]
> > +	struct nfct_handle *handle;
> 
> This need handle = NULL. See below why.

Not really, sorry, I just noticed handle does not need to be
initialized to NULL.
