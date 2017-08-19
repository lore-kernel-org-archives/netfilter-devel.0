From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: connlimit: merge root4 and root6.
Date: Sat, 19 Aug 2017 13:15:39 +0200
Message-ID: <20170819111539.GA4534@salvia>
References: <20170802091443.32713-1-ap420073@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org
To: Taehee Yoo <ap420073@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:38769 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751446AbdHSLQD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Aug 2017 07:16:03 -0400
Content-Disposition: inline
In-Reply-To: <20170802091443.32713-1-ap420073@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 02, 2017 at 06:14:43PM +0900, Taehee Yoo wrote:
> The root4 variable is used only when connlimit extension module has been
> stored by the iptables command. and the roo6 variable is used only when
> connlimit extension module has been stored by the ip6tables command.
> So the root4 and roo6 variable does not be used at the same time.

Applied, thanks a lot for your patience.
