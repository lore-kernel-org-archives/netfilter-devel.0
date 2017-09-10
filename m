From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] xtables-compat-restore: fix translation of mangle's
 OUTPUT
Date: Sun, 10 Sep 2017 22:05:32 +0200
Message-ID: <20170910200532.GA30715@salvia>
References: <90185d38-8713-2a2a-6d47-c3db17f83dcb@gmail.com>
 <603ee036-ea61-e797-7828-a7b0bd3a9bd9@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Louis Sautier <sautier.louis@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:53612 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750935AbdIJUF5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 Sep 2017 16:05:57 -0400
Content-Disposition: inline
In-Reply-To: <603ee036-ea61-e797-7828-a7b0bd3a9bd9@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Sep 10, 2017 at 08:35:23PM +0200, Louis Sautier wrote:
> On 10/09/17 02:39, Louis Sautier wrote:
> > Hello,
> > I noticed that the iptables-restore-translate tool does not properly
> > translate the OUTPUT chain from the mangle table. It creates a filter
> > chain when it should be creating a route chain.
> > Here is a rather simple patch that should fix the issue.
> >
> > Please CC me, I'm not subscribed.

Applied, thanks.
