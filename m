From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: synproxy: fix conntrackd interaction
Date: Mon, 15 May 2017 18:52:38 +0200
Message-ID: <20170515165238.GA3999@salvia>
References: <20170511181428.4b3416cc@redhat.com>
 <20170511165638.10913-1-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: brouer@redhat.com, netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:54615 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935224AbdEOQwo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 May 2017 12:52:44 -0400
Content-Disposition: inline
In-Reply-To: <20170511165638.10913-1-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 11, 2017 at 06:56:38PM +0200, Eric Leblond wrote:
> This patch fixes the creation of connection tracking entry from
> netlink when synproxy is used. It was missing the addition of
> the synproxy extension.
> 
> This was causing kernel crashes when a conntrack entry created by
> conntrackd was used after the switch of traffic from active node
> to the passive node.

Applied, thanks Eric.
