From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] pgsql: add SSL connection implementation to PGSQL
 plugin
Date: Tue, 18 Sep 2012 21:28:34 +0200
Message-ID: <20120918192834.GA2138@1984>
References: <1346503911-3781-1-git-send-email-mr.dash.four@googlemail.com>
 <20120902233228.GA22069@1984>
 <50440A1B.7060908@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Eric Leblond <eric@regit.org>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51495 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754405Ab2IRT2i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Sep 2012 15:28:38 -0400
Content-Disposition: inline
In-Reply-To: <50440A1B.7060908@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 03, 2012 at 02:38:35AM +0100, Mr Dash Four wrote:
> > I won't take a patch that fixes a NULL pointer dereference and adds a
> > new feature.
> > 
> > Please, split this in two patches. First fix the bug, then add the new
> > fature.
>
> Sure. Are there any (other) objections to the patch I submitted?

Are you going to send the fix for the NULL pointer dereference in the
PostgreSQL plugin.

I'd like to release a new version of ulogd2 soon.
