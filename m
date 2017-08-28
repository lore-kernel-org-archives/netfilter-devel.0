From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: conntrack: don't log "invalid" icmpv6
 connections
Date: Mon, 28 Aug 2017 17:51:39 +0200
Message-ID: <20170828155139.GA20496@salvia>
References: <20170825005941.8773-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:37792 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751744AbdH1PwD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Aug 2017 11:52:03 -0400
Content-Disposition: inline
In-Reply-To: <20170825005941.8773-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 25, 2017 at 02:59:41AM +0200, Florian Westphal wrote:
> When enabling logging for invalid connections we currently also log most
> icmpv6 types, which we don't track intentionally (e.g. neigh discovery).
> "invalid" should really mean "invalid", i.e. short header or bad checksum.
> 
> We don't do any logging for icmp(v4) either, its just useless noise.

Applied, thanks.
