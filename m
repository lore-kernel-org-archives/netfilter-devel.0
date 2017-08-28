From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: rt: account for tcp header size too
Date: Mon, 28 Aug 2017 17:53:00 +0200
Message-ID: <20170828155300.GA24442@salvia>
References: <20170828150012.11287-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:37827 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751184AbdH1PxY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Aug 2017 11:53:24 -0400
Content-Disposition: inline
In-Reply-To: <20170828150012.11287-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 28, 2017 at 05:00:12PM +0200, Florian Westphal wrote:
> This needs to accout for the ipv4/ipv6 header size and the tcp
> header without options.

Applied, thanks.
