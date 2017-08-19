From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: xt_NFLOG: use nf_log_packet instead of
 nfulnl_log_packet.
Date: Sat, 19 Aug 2017 14:07:05 +0200
Message-ID: <20170819120705.GA4893@salvia>
References: <20170809075949.28553-1-ap420073@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Taehee Yoo <ap420073@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:39113 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751153AbdHSMHa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Aug 2017 08:07:30 -0400
Content-Disposition: inline
In-Reply-To: <20170809075949.28553-1-ap420073@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 09, 2017 at 04:59:49PM +0900, Taehee Yoo wrote:
> The nfulnl_log_packet() is added to make sure that the NFLOG target
> works as only user-space logger. but now, nf_log_packet() can find proper
> log function using NF_LOG_TYPE_ULOG and NF_LOG_TYPE_LOG.

Applied, thanks!
